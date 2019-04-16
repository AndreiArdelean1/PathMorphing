//
//  PathDescriptor.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 14/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import Foundation

public struct PathDescriptor {
	/// The subpaths in the path
	public var subPaths: [SubPathDescriptor]
	
	/// Return a path formed with the 'segments'.
	///
	/// - Parameter segments: A path formed with the 'segments'.
	init(segments: [PathSegmentDescriptor]) {
		self.subPaths = segments.subPaths
	}
	
	/// Return a path formed with the 'subPaths'.
	///
	/// - Parameter segments: A path formed with the 'subPaths'.
	init(subPaths: [SubPathDescriptor]) {
		self.subPaths = subPaths
	}
}

public extension PathDescriptor {
	/// Returns the path by transforming all sengments to bezier paths with two control points.
	///
	/// - Returns: The path by transforming all sengments to bezier paths with two control points.
	func standardDescriptor() -> PathDescriptor {
		var path = self
		path.subPaths = subPaths.map { $0.standardDescriptor() }
		return path
	}
}
