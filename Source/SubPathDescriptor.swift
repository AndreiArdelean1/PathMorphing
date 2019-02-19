//
//  CGSubPathDescriptor.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 14/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import UIKit

public struct SubPathDescriptor {
	/// The start point of the subpath.
	public var startPoint: CGPoint = .zero
	// The segments in the subpath.
	public var segments: [PathSegmentDescriptor]
	private var _isClosed: Bool
	/// A Boolean value indicating if the subpath is closed.
	var isClosed: Bool {
		get {
			return _isClosed ||
				segments.last?.mainPoint == startPoint
		}
		set {
			_isClosed = newValue
		}
	}
	
	/// Return a subpath formed with the 'segments'.
	///
	/// - Parameters:
	///   - segments: The segments of the subpath
	///   - isClosed: A Boolean value indicating if the subpath is closed. If the 'segments' define a closed subpath, the 'isClosed' parameter will have no effect and the returned subpath will be closed.
	init(segments: [PathSegmentDescriptor], isClosed: Bool = false) {
		self.segments = segments.filter({ (s) -> Bool in
			switch s.type {
			case .moveToPoint:
				return false
			case .addLineToPoint:
				return true
			case .addQuadCurveToPoint:
				return true
			case .addCurveToPoint:
				return true
			case .closeSubpath:
				return false
			}
		})
		
		_isClosed = isClosed ||
			segments.contains { $0.type == .closeSubpath }
	}
	
	/// The end point of the subpath.
	var endPoint: CGPoint {
		if isClosed {
			return startPoint
		}
		return segments.last?.mainPoint ?? startPoint
	}
}

// MARK: - Helper objects
extension SubPathDescriptor {
	public struct Weight {
		/// The procentage of the subpath after which the weight 'value' applies.
		public let startProcentage: CGFloat
		/// The value of the set weight.
		public let value: CGFloat
		
		public init(startProcentage: CGFloat, value: CGFloat) {
			self.startProcentage = startProcentage
			self.value = value
		}
	}
	
	fileprivate struct SegmentDistanceWrapper {
		let previousPoint: CGPoint
		let segment: PathSegmentDescriptor
		let linearDistance: CGFloat
		var weight: CGFloat
		var weightedDistance: CGFloat {
			return linearDistance * weight
		}
		
		static func wrapperArray(withStart startPoint: CGPoint, segments: [PathSegmentDescriptor], weight: CGFloat) -> [SegmentDistanceWrapper] {
			var currentPoint = startPoint
			var wrapperArray = [SegmentDistanceWrapper]()
			for segment in segments {
				guard let mainPoint = segment.mainPoint else {
					
					continue
				}
				
				if segment.isSplittable {
					let distance = mainPoint.vectorFrom(point: currentPoint).modulus
					let tempSeg = SegmentDistanceWrapper(previousPoint: currentPoint, segment: segment, linearDistance: distance, weight: weight)
					wrapperArray.append(tempSeg)
				}
				
				currentPoint = mainPoint
			}
			
			return wrapperArray
		}
	}
}

// MARK: -
public extension SubPathDescriptor {
	/// Returns the CGPath obtained from the current subpath.
	///
	/// - Returns: The CGPath obtained from the current subpath
	public func cgPath() -> CGPath {
		let path = CGMutablePath()
		path.move(to: startPoint)
		
		for segment in segments {
			switch segment.type {
			case .moveToPoint:
				path.move(to: segment.points[0])
			case .addLineToPoint:
				path.addLine(to: segment.points[0])
			case .addQuadCurveToPoint:
				path.addQuadCurve(to: segment.points[0], control: segment.points[1])
			case .addCurveToPoint:
				path.addCurve(to: segment.points[0], control1: segment.points[1], control2: segment.points[2])
			case .closeSubpath:
				break
			}
		}
		
		if isClosed {
			path.closeSubpath()
		}
		
		return path
	}
	
	/// A Boolean value indicating whether the subpath has segments.
	public var hasSegments: Bool {
		return !self.segments.isEmpty
	}
	
	/// The center of mass of the subpath.
	public var centroid: CGPoint {
		get {
			var points = segments
				.compactMap { $0.mainPoint }
			points = [startPoint] + points
			if isClosed {
				points = points + [endPoint]
			}
			
			return points.centroid
		}
		mutating set {
			let translationVector = newValue.vectorFrom(point: centroid)
			self = self.translating(by: translationVector)
		}
	}
	
	/// Returns the subpath by transforming all sengments to bezier paths with two control points.
	///
	/// - Returns: The subpath by transforming all sengments to bezier paths with two control points.
	public func standardDescriptor() -> SubPathDescriptor {
		var currentPath = self
		currentPath.segments = []
		var currentPoint = startPoint
		
		for segment in segments {
			let newSegment: PathSegmentDescriptor
			switch segment.type {
			case .moveToPoint:
				newSegment = segment
			case .addLineToPoint:
				let point1 = currentPoint
				let point2 = segment.points[0]
				
				let controlPoint1 = point1.goingTo(point: point2, atFactor: 1.0 / 3.0)
				let controlPoint2 = point1.goingTo(point: point2, atFactor: 2.0 / 3.0)
				
				newSegment = PathSegmentDescriptor(type: .addCurveToPoint,
													 points: [point2, controlPoint1, controlPoint2])
			case .addQuadCurveToPoint:
				let point1 = currentPoint
				let point2 = segment.points[0]
				
				let originalControlPoint = segment.points[1]
				let controlPoint1 = point1.goingTo(point: originalControlPoint, atFactor: 1.0 / 2.0)
				let controlPoint2 = originalControlPoint.goingTo(point: point2, atFactor: 1.0 / 2.0)
				
				newSegment = PathSegmentDescriptor(type: .addCurveToPoint,
													 points: [point2, controlPoint1, controlPoint2])
			case .addCurveToPoint:
				newSegment = segment
			case .closeSubpath:
				newSegment = segment
			}
			
			currentPoint = segment.mainPoint ?? .zero
			
			currentPath.segments.append(newSegment)
		}
		
		return currentPath
	}
	
	/// Returns the subpath by adding 'count' segments. The segments are added by splitting the segment with the largest weighed length.
	///
	/// - Parameters:
	///   - count: The number of segments to add.
	///   - weights: The weights of the segments used to decide which segments to split. The default weight of the segment is '1'.
	/// - Returns: The subpath by adding 'count' segments.
	public func addingSegments(numberOfSegmentsToAdd count: Int, weights:[Weight] = []) -> SubPathDescriptor {
		var path = self
//		let countRemeining = count
		let segmentsWanted = segments.count + count

		var wrapperArray = SegmentDistanceWrapper.wrapperArray(withStart: startPoint, segments: path.segments, weight: 1)
		// adding points and weights
		var currentDistance: CGFloat = 0
		let totalDistance = wrapperArray.reduce(0) { $0 + $1.linearDistance }
		var currentSegIndex = 0
		var currentWeightIndex = -1
		var currentWeight = Weight(startProcentage: 0, value: 1)
		while currentSegIndex < wrapperArray.count {
			let wrapperSeg = wrapperArray[currentSegIndex]
			let nextDistance = currentDistance + wrapperSeg.linearDistance
			
			let currentProcentage = currentDistance / totalDistance
			let nextProcentage = nextDistance / totalDistance
			
			let nextWeight: Weight
			if currentWeightIndex + 1 < weights.count {
				nextWeight = weights[currentWeightIndex + 1]
			} else {
				nextWeight = Weight(startProcentage: CGFloat.greatestFiniteMagnitude, value: 1)
			}
			
			if nextWeight.startProcentage < nextProcentage {
				let splittingFactor = (nextWeight.startProcentage - currentProcentage) / (nextProcentage - currentProcentage)
				
				guard splittingFactor > 0 && splittingFactor < 1 &&
				currentProcentage != nextProcentage else {
					currentWeightIndex += 1
					currentWeight = nextWeight
					
					continue
				}
				
				wrapperArray.remove(at: currentSegIndex)
				let newSegments = wrapperSeg.segment.segmentsBySplitting(withCurrentPoint: wrapperSeg.previousPoint, factors: [splittingFactor])
				let newWrapperSegments = SegmentDistanceWrapper.wrapperArray(withStart: wrapperSeg.previousPoint,
																			 segments: newSegments,
																			 weight: currentWeight.value)
				
				wrapperArray.insert(contentsOf: newWrapperSegments,
									at: currentSegIndex)
				
				currentWeightIndex += 1
				currentWeight = nextWeight
				
				currentSegIndex += 1
				currentDistance += newWrapperSegments.first?.linearDistance ?? 0
				
				continue
			}
			
			if wrapperSeg.weight != currentWeight.value {
				var newSeg = wrapperSeg
				newSeg.weight = currentWeight.value
				wrapperArray[currentSegIndex] = newSeg
			}
			
			currentSegIndex += 1
			currentDistance = nextDistance
		}

		while segmentsWanted > wrapperArray.count {
			guard let (maxIndex, maxValue) = wrapperArray.enumerated().max(by: { $0.element.weightedDistance < $1.element.weightedDistance }) else {
				
				break
			}
			
			wrapperArray.remove(at: maxIndex)
			let newSegments = maxValue.segment.segmentsBySplitting(withCurrentPoint: maxValue.previousPoint, factors: [0.5])
			let newWrapperSegments = SegmentDistanceWrapper.wrapperArray(withStart: maxValue.previousPoint,
																		 segments: newSegments,
																		 weight: maxValue.weight)
			
			wrapperArray.insert(contentsOf: newWrapperSegments,
								at: maxIndex)
			
			guard newSegments.count > 1 else {
				
				break
			}
		}
		
		path.segments = wrapperArray.map { $0.segment }
		
		return path
	}
	
	/// Returns the distance from the point at 'fromIndex' index to the point at 'toIndex' index.
	///
	/// - Parameters:
	///   - fromIndex: The index of the point from where the distance is calculated.
	///   - toIndex: The index of the point to where the distance is calculated.
	/// - Returns: The distance from the point at 'fromIndex' index to the point at 'toIndex' index.
	func distance(from fromIndex: Int, to toIndex: Int) -> CGFloat {
		let segments = self.segments[fromIndex..<toIndex]
		let currentPoint = fromIndex <= 0 ? startPoint : self.segments[fromIndex - 1].mainPoint!
		
		return segments
			.compactMap { $0.mainPoint }
			.reduce((0, currentPoint)) { (previousValue, point) -> (CGFloat, CGPoint) in
				let previousPoint = previousValue.1
				let previousSum = previousValue.0
				let distance = point.vectorFrom(point: previousPoint).modulus
				return (previousSum + distance, point)
			}
			.0
	}
	
	/// Returns a subpath obtained by shifting the start with 'shifts' indexes.
	///
	/// - Parameter shifts: The number of indexes to shift the subpath by.
	/// - Returns: A subpath obtained by shifting the start with 'shifts' indexes.
	public func shiftingStart(by shifts: Int) -> SubPathDescriptor {
		let count = segments.count
		
		guard isClosed && count > 0 && shifts != 0 else {
			
			return self
		}
		
		let shifts: Int = shifts < 0 ? count + (shifts % count) : shifts % count

		let newSegments = Array(
			segments[(segments.count - shifts)..<segments.count] +
			segments[0..<(segments.count - shifts)]
		)
		
		let newStartPoint = newSegments.last?.mainPoint ?? .zero
		
		var newPath = self
		newPath.segments = newSegments
		newPath.startPoint = newStartPoint
		
		return newPath
	}
	
	/// Returns the subpath translated by 'translation'.
	///
	/// - Parameter translation: The translation vector applied to the subpath.
	/// - Returns: Returns the subpath translated by 'translation'.
	func translating(by translation: CGVector) -> SubPathDescriptor {
		var newPath = self
		newPath.segments = newPath.segments.map { $0.translating(by: translation) }
		newPath.startPoint = newPath.startPoint + translation
		return newPath
	}
}
