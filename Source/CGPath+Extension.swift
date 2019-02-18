//
//  CGPath+Extension.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 12/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import UIKit

extension CGPath {
	internal func forEach( body: @escaping @convention(block) (CGPathElement) -> Void) {
		typealias Body = @convention(block) (CGPathElement) -> Void
		let callback: @convention(c) (UnsafeMutableRawPointer, UnsafePointer<CGPathElement>) -> Void = { (info, element) in
			let body = unsafeBitCast(info, to: Body.self)
			body(element.pointee)
		}

		let unsafeBody = unsafeBitCast(body, to: UnsafeMutableRawPointer.self)
		self.apply(info: unsafeBody, function: unsafeBitCast(callback, to: CGPathApplierFunction.self))
	}

	/// Returns the path descriptor of the path.
	///
	/// - Returns: Returns the path descriptor of the path.
	public func pathDescriptor() -> PathDescriptor {
		var rawSegments = [PathSegmentDescriptor]()
		
		self.forEach { element in
			switch (element.type) {
			case .moveToPoint:
				rawSegments.append(PathSegmentDescriptor(type: element.type,
														   points: [
															element.points[0]
					]
				))
			case .addLineToPoint:
				rawSegments.append(PathSegmentDescriptor(type: element.type,
														   points: [
															element.points[0]
					]
				))
			case .addQuadCurveToPoint:
				rawSegments.append(PathSegmentDescriptor(type: element.type,
														   points: [
															element.points[1],
															element.points[0],
					]
				))
			case .addCurveToPoint:
				rawSegments.append(PathSegmentDescriptor(type: element.type,
														   points: [
															element.points[2],
															element.points[0],
															element.points[1],
					]
				))
				
			case .closeSubpath:
				rawSegments.append(PathSegmentDescriptor(type: element.type,
														   points: []
				))
			}
		}
				
		return PathDescriptor(segments: rawSegments)
	}
}
