//
//  ArrayPathDescriptors+Extension.swift
//  BezierPathCircleMorph
//
//  Created by Andrei Ardelean on 13/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element == PathSegmentDescriptor {
	/// Returns the subpaths of the curent segments array.
	var subPaths: [SubPathDescriptor] {
		var paths = [SubPathDescriptor]()
		var currentPath = SubPathDescriptor(segments: [])
		
		for segment in self {
			if segment.type == .moveToPoint {
				if currentPath.hasSegments {
					paths.append(currentPath)
				}
				
				currentPath = SubPathDescriptor(segments: [])
				currentPath.startPoint = segment.mainPoint ?? .zero
				
				continue
			}
			
			if segment.type == .closeSubpath {
				guard currentPath.hasSegments else {
					currentPath = SubPathDescriptor(segments: [])
					
					continue
				}
				
				if currentPath.segments.last?.mainPoint != currentPath.startPoint {
					currentPath.segments.append(PathSegmentDescriptor(type: .addLineToPoint, points: [currentPath.startPoint]))
				}
				
				currentPath.isClosed = true
				paths.append(currentPath)
				
				let currentPoint = currentPath.endPoint
				currentPath = SubPathDescriptor(segments: [])
				currentPath.startPoint = currentPoint
				
				continue
			}
			
			currentPath.segments.append(segment)
		}
		
		if currentPath.hasSegments {
			paths.append(currentPath)
		}
		
		currentPath = SubPathDescriptor(segments: [])

		return paths
	}
}
