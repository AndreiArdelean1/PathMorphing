//
//  CGPathSegmentDescriptor.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 13/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import CoreGraphics

/// The descriptor for a segment
public struct PathSegmentDescriptor {
	/// Segment type
	public let type: CGPathElementType
	
	/// The point at the end of the segment and the control points.
	public let points: [CGPoint]
	
	/// A Boolean value indicating whether the segment is splittable.
	public var isSplittable: Bool {
		switch type {
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
	}
	
	/// Point at the end of the segment.
	public var mainPoint: CGPoint? {
		return self.points.first
	}
	
	/// Returns the segments by splitting the current segment at multiple factors.
	///
	/// - Parameters:
	///   - currentPoint: The start point of the segment.
	///   - factors: The factors at which the segment is split.
	/// - Returns: The segments by splitting the current segment at multiple factors.
	public func segmentsBySplitting(withCurrentPoint currentPoint: CGPoint, factors: [CGFloat]) -> [PathSegmentDescriptor] {
		let bezierPath: BezierPath

		guard let firstPoint = points.first, isSplittable else {
			
			return [self]
		}
		
		bezierPath = BezierPath(points: [currentPoint] + points.dropFirst() + [firstPoint])
		
		let paths: [BezierPath] = bezierPath.pathsBySplitting(atFactors: factors)

		let segments = paths.compactMap { (path) -> PathSegmentDescriptor? in
			guard !path.points.isEmpty else {
				
				return nil
			}
			var points = path.points.dropFirst().map { $0 }
			if let lastPoint = points.last {
				points = [lastPoint] + points.dropLast()
			}
			
			return PathSegmentDescriptor(type: type, points: points)
		}

		return segments
	}
	
	/// Returns the segment translated by 'translation'.
	///
	/// - Parameter translation: The translation vector applied to the segment.
	/// - Returns: Returns the segment translated by 'translation'.
	public func translating(by translation: CGVector) -> PathSegmentDescriptor {
		return PathSegmentDescriptor(type: type, points: points.map { $0 + translation })
		
	}
}
