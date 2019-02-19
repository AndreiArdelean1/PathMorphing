//
//  CGPoint+Extension.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 12/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import CoreGraphics

internal extension CGPoint {
	static func +(lhs: CGPoint, rhs: CGVector) -> CGPoint {
		return CGPoint(x: lhs.x + rhs.dx, y: lhs.y + rhs.dy)
	}
	
	/// Returns the point by goting to 'point' at the given factor between them.
	///
	/// - Parameters:
	///   - point:
	///   - factor:
	/// - Returns: The point by goting to 'point' at the given factor between them.
	func goingTo(point: CGPoint, atFactor factor: CGFloat) -> CGPoint {
		let vector = point.vectorFrom(point: self) * factor
		let newPoint = self + vector
		return newPoint
	}
	
	/// Returns the point on the circle with center 'center' and radius 'radius' obtained by extending the line between 'center' and self.
	///
	/// - Parameters:
	///   - center: The center of the circle.
	///   - radius: The radius of the circle.
	/// - Returns: Returns the point on the circle with center 'center' and radius 'radius' obtained by extending the line between 'center' and self.
	func normalized(withCenter center: CGPoint, radius: CGFloat) -> CGPoint {
		return CGVector.betweenPoints(start: center, end: self).point
	}
	
	/// Returns the vector from 'startPoint' to self.
	///
	/// - Parameter startPoint: 
	/// - Returns: The vector from 'startPoint' to self.
	func vectorFrom(point startPoint: CGPoint) -> CGVector {
		return CGVector.betweenPoints(start: startPoint, end: self)
	}
}
