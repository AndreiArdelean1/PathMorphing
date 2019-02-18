//
//  ViewController.swift
//  iOS Example
//
//  Created by Andrei Ardelean on 18/02/2019.
//  Copyright © 2019 Andrei Ardelean. All rights reserved.
//

import UIKit
import PathMorphing

class ViewController: UIViewController {
	
	override var prefersStatusBarHidden: Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		view.backgroundColor = .white
		
		let shape = CAShapeLayer()
		shape.frame = view.bounds
		shape.fillColor = UIColor.orange.withAlphaComponent(0.3).cgColor
		shape.strokeColor = UIColor.orange.cgColor
		shape.lineWidth = 3
		view.layer.addSublayer(shape)
		
		let scale: CGFloat = min(view.bounds.width, view.bounds.height) * 0.5
		
		let star1 = scaledPath(scale: scale, points: pointsS)
		
		let star2 = circleWithCenter(CGPoint(x: 150, y: 150), radius: 50)
		
		var path1Desc = star1.cgPath.pathDescriptor().standardDescriptor().subPaths.first!.shiftingStart(by: 0)
		var path2Desc = star2.cgPath.pathDescriptor().standardDescriptor().subPaths.first!.shiftingStart(by: 2)
		
		let maxSegments = max(path1Desc.segments.count, path2Desc.segments.count) * 3
		
		path1Desc = path1Desc.addingSegments(numberOfSegmentsToAdd: maxSegments - path1Desc.segments.count, weights: [
			SubPathDescriptor.Weight(startProcentage: 0.0, value: 10),
			SubPathDescriptor.Weight(startProcentage: 0.25, value: 1),
			])
		path2Desc = path2Desc.addingSegments(numberOfSegmentsToAdd: maxSegments - path2Desc.segments.count + 2)
		
		let center = view.center
		let path1OffCenter = CGVector(dx: center.x - path1Desc.centroid.x, dy: center.y - path1Desc.centroid.y)
		let path2OffCenter = CGVector(dx: center.x - path2Desc.centroid.x, dy: center.y - path2Desc.centroid.y)
		
		path1Desc = path1Desc.translating(by: path1OffCenter)
		path2Desc = path2Desc.translating(by: path2OffCenter)
		
		shape.path = path1Desc.cgPath()
		
		//: Create the animation from star1 to star2 (infinitely repeat, autoreverse)
		let animation = CABasicAnimation(keyPath: "path")
		animation.fromValue = path1Desc.cgPath()
		animation.toValue = path2Desc.cgPath()
		animation.duration = 1
		animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
		animation.fillMode = CAMediaTimingFillMode.both
		animation.repeatCount = .greatestFiniteMagnitude // Infinite repeat
		animation.autoreverses = true
		animation.isRemovedOnCompletion = false
		
		shape.add(animation, forKey: animation.keyPath)
		
	}
	
	func circleWithCenter(_ center: CGPoint, radius: CGFloat) -> UIBezierPath {
		let shape = UIBezierPath(ovalIn: CGRect.init(x: center.x - radius, y: center.y - radius, width: radius * 2, height: radius * 2))
		
		shape.close()
		
		return shape
	}
	
	let pointsZ: [CGPoint] = [
		CGPoint(x: 10, y: 20),
		CGPoint(x: 40, y: 20),
		CGPoint(x: 20, y: 10),
		CGPoint(x: 60, y: 10),
		CGPoint(x: 60, y: 70),
		CGPoint(x: 10, y: 70)
	]
	
	let pointsS: [CGPoint] = [
		CGPoint(x: 0, y: 0),
		CGPoint(x: 10, y: 0),
		CGPoint(x: 10, y: 10),
		CGPoint(x: 0, y: 10)
	]
	
	let pointsT: [CGPoint] = [
		CGPoint(x: 10, y: 0),
		CGPoint(x: 10, y: 10),
		CGPoint(x: 0, y: 10)
	]
	
	func scaledPoints(scale: CGFloat, points: [CGPoint]) -> [CGPoint] {
		let points = points
		
		let minx = points.map { $0.x }.min()!
		let miny = points.map { $0.y }.min()!
		let maxx = points.map { $0.x }.max()!
		let maxy = points.map { $0.y }.max()!
		
		let scaleX0: CGFloat = 1.0 / (maxx - minx)
		let scaleY0: CGFloat = 1.0 / (maxy - miny)
		let scale0 = min(scaleX0, scaleY0)
		
		return points.map { CGPoint(x: ($0.x - minx) * (scale * scale0), y: ($0.y - miny) * (scale * scale0)) }
	}
	
	func scaledPath(scale: CGFloat, points: [CGPoint]) -> UIBezierPath {
		let shape = UIBezierPath()
		
		let scaledPoints = self.scaledPoints(scale: scale, points: points)
		
		shape.move(to: scaledPoints.first!)
		
		for point in scaledPoints {
			shape.addLine(to: point)
		}
		
		shape.close()
		
		return shape
	}
	
}
