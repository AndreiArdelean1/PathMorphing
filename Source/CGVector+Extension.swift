//
//  CGVector+Extension.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 12/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import UIKit

infix operator •

internal extension CGVector {
	static func +(lhs: CGVector, rhs: CGVector) -> CGVector {
		return CGVector(dx: lhs.dx + rhs.dx, dy: lhs.dy + rhs.dy)
	}
	
	static func -(lhs: CGVector, rhs: CGVector) -> CGVector {
		return lhs + (rhs * (-1.0))
	}
	
	static func *(lhs: CGVector, rhs: CGFloat) -> CGVector {
		return CGVector(dx: lhs.dx * rhs, dy: lhs.dy * rhs)
	}
	
	static func /(lhs: CGVector, rhs: CGFloat) -> CGVector {
		return CGVector(dx: lhs.dx / rhs, dy: lhs.dy / rhs)
	}
	
	/// Returns the dot product of two vectors
	///
	/// - Parameters:
	///   - lhs: The first operand
	///   - rhs: The second operand
	/// - Returns: The dot product of two vectors
	static func •(lhs: CGVector, rhs: CGVector) -> CGFloat {
		return lhs.dx * rhs.dx + lhs.dy * rhs.dy
	}
	
	/// Returns the vector from the center of the coordinate system to the given point.
	///
	/// - Parameter point:
	/// - Returns: The vector from the center of the coordinate system to the given point
	static func toPoint(_ point: CGPoint) -> CGVector {
		return CGVector(dx: point.x, dy: point.y)
	}
	
	/// Returns the vector from the startPoint to the endPoint.
	///
	/// - Parameters:
	///   - startPoint: The vector start point.
	///   - endPoint: The vector end point.
	/// - Returns: The vector from the startPoint to the endPoint
	static func betweenPoints(start startPoint: CGPoint, end endPoint: CGPoint) -> CGVector {
		return CGVector(dx: endPoint.x - startPoint.x, dy: endPoint.y - startPoint.y)
	}
	
	/// Returns the unit vector corresponding to a zero degree angle.
	static var zeroRotationVector: CGVector {
		return CGVector(dx: 1, dy: 0)
	}

	/// Returns the unit vector of the same angle.
	var unit: CGVector {
		let modulus = self.modulus
		guard modulus > 0 else {
			
			return .zero
		}
		
		return self / modulus
	}
	
	/// Returns the length of the vector.
	var modulus: CGFloat {
		return sqrt(dx * dx + dy * dy)
	}
	
	var point: CGPoint {
		return CGPoint(x: dx, y: dy)
	}
	
	/// Returns the perpendicular vector to self.
	var normal: CGVector {
		return CGVector(dx: dy, dy: -dx)
	}
	
	func pointFrom(point startPoint: CGPoint) -> CGPoint {
		return startPoint + self
	}
	
	/// Returns the angle to 'vector'.
	///
	/// - Parameter vector: The vector to which the angle is calculated.
	/// - Returns: The angle between self and 'vector'
	func angleTo(vector: CGVector) -> CGFloat {
		let cosAngle = (self • vector) / (self.modulus * vector.modulus)
		return acos(cosAngle)
	}
}
