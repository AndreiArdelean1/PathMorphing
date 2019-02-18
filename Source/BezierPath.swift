//
//  BezierPath.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 14/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import UIKit

struct BezierPath {
	/// The points of the bezier path. The first and last point corresponds to the starting and ending point of the path, while the points in between are control points.
	let points: [CGPoint]
	
	/// The order of the bezier path
	var order: Int {
		return points.count
	}
	
	/// Returns a bezier path, by splitting the segments at a given factor. By successively simplifying a path until a single point is obtaind, results in the corresponding point on the original path at the given factor.
	///
	/// - Parameter k: The factor by which the segments are split.
	/// - Returns: The simplified bezier path.
	func simplifiedPath(atFactor k: CGFloat) -> BezierPath? {
		guard let first = points.first else {
			
			return nil
		}
		
		var lastPoint = first
		var newPoints = [CGPoint]()
		for point in points.dropFirst() {
			let newPoint = lastPoint.goingTo(point: point, atFactor: k)
			newPoints.append(newPoint)
			
			lastPoint = point
		}
		
		return BezierPath(points: newPoints)
	}
	
	/// Returns the corresponding point on the bezier path at the given factor.
	///
	/// - Parameter k: The factor by which the segments are split.
	/// - Returns: The corresponding point on the bezier path at the given factor
	func point(atFactor k: CGFloat) -> CGPoint? {
		var path = self
		var point = points.first
		while let newPath = path.simplifiedPath(atFactor: k), let newPoint = newPath.points.first {
			path = newPath
			point = newPoint
		}
		
		return point
	}
	
	/// Returns the paths obtained by spliting the bezier path into the given factors.
	///
	/// - Parameter factors: The factors at which to split the path. If the factors are not in ascending order, the paths returned will have overlapping regions. A factor value of '0' coresponds to the start of the path and '1' to the end of the path. The factors can have any value and are not bound by start or end.
	/// - Returns: Returns the paths obtained by spliting the bezier path into the given factors.
	func pathsBySplitting(atFactors factors: [CGFloat]) -> [BezierPath] {
		guard !factors.isEmpty, let k = factors.first else {
			
			return [self]
		}
		
		let path1: BezierPath
		let path2: BezierPath
		
		(path1, path2) = pathsBySplitting(atFactor: k)
		let nextFactors = factors.dropFirst().map { $0 * (1.0 - k) }
		return [path1] + path2.pathsBySplitting(atFactors: nextFactors)
	}
	
	/// Returns the paths obtained by spliting the bezier path into the given factor.
	///
	/// - Parameter k: The factor by which the paths are split.
	/// - Returns: Returns the two paths obtained by spliting the bezier path into the given factor.
	private func pathsBySplitting(atFactor k: CGFloat) -> (BezierPath, BezierPath) {
		var points1 = [CGPoint]()
		var points2 = [CGPoint]()
		
		var tempPath: BezierPath? = self
		
		while let oldFirst = tempPath?.points.first,
			let oldLast = tempPath?.points.last {
				points1.append(oldFirst)
				points2.insert(oldLast, at: 0)
				tempPath = tempPath?.simplifiedPath(atFactor: k)
		}
		
		return (BezierPath(points: points1), BezierPath(points: points2))
	}
}
