//
//  Polygom.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 13/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import CoreGraphics

extension Array where Iterator.Element == CGPoint {
	
	/// Returns the center of mass corresponding to the polygon bounded by the array of points.
	var centroid: CGPoint {
		var points = self
		
		var px: CGFloat = 0
		var py: CGFloat = 0
		
		var totalWeight: CGFloat = 0
		while points.count >= 3 {
			let triangle = Array(points[0..<3])
			let weight = triangle.area
			let point = triangle.averagePoint
			
			px += weight * point.x
			py += weight * point.y
			
			totalWeight += weight
			
			points.remove(at: 1)
		}
		
		return CGPoint(x: px / totalWeight, y: py / totalWeight)
	}
	
	var averagePoint: CGPoint {
		return CGPoint(x: map { $0.x }.reduce(0.0, +) / CGFloat(count),
					   y: map { $0.y }.reduce(0.0, +) / CGFloat(count))
	}
	
	/// Returns the area corresponding to the polygon bounded by the array of points.
	var area: CGFloat {
		guard var previousPoint = self.last else {
			
			return 0
		}
		
		var area: CGFloat = 0.0
		for point in self {
			area += (previousPoint.x * point.y - previousPoint.y * point.x) / 2
			previousPoint = point
		}
		
		return area
	}
}
