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
		
		let star1 = scaledPath(scale: scale, points: pointsPlane)
		let star2 = circleWithCenter(CGPoint(x: 150, y: 150), radius: 150)

		let cgpath1 = star1.cgPath
		let cgpath2 = star2.cgPath

		// ---------------------------------
		
		var path1Desc = cgpath1.pathDescriptor().standardDescriptor().subPaths.first!.shiftingStart(by: 6)
		var path2Desc = cgpath2.pathDescriptor().standardDescriptor().subPaths.first!.shiftingStart(by: 0)
		
		let segmentsWanted = max(path1Desc.segments.count, path2Desc.segments.count) * 3
		
		path1Desc = path1Desc.addingSegments(numberOfSegmentsToAdd: segmentsWanted - path1Desc.segments.count, weights: [
			SubPathDescriptor.Weight(startProcentage: 0.0, value: 0.5),
			SubPathDescriptor.Weight(startProcentage: 0.2, value: 1),
			])
		path2Desc = path2Desc.addingSegments(numberOfSegmentsToAdd: segmentsWanted - path2Desc.segments.count+2)
		
		let center = view.center
		path1Desc.centroid = center
		path2Desc.centroid = center
		
		path2Desc = path2Desc.translating(by: CGVector(dx: 0, dy: 0))
		
		// ---------------------------------
		
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
	
	let pointsPlane: [CGPoint] = [
		CGPoint(x: 8986.700, y: 4989.800),
		CGPoint(x: 8266.500, y: 4568.400),
		CGPoint(x: 7465.800, y: 3742.800),
		CGPoint(x: 6766.700, y: 3013.000),
		CGPoint(x: 6584.700, y: 3013.000),
		CGPoint(x: 3977.800, y: 3080.000),
		CGPoint(x: 936.100, y: 3118.300),
		CGPoint(x: 361.500, y: 2294.700),
		CGPoint(x: 420.900, y: 2003.600),
		CGPoint(x: 2539.300, y: 1248.900),
		CGPoint(x: 4604.100, y: 553.600),
		CGPoint(x: 3039.200, y: -1225.800),
		CGPoint(x: 2342.000, y: -1162.600),
		CGPoint(x: 1658.200, y: -1084.100),
		CGPoint(x: 1577.800, y: -1122.400),
		CGPoint(x: 541.600, y: -2030.300),
		CGPoint(x: 637.400, y: -2398.100),
		CGPoint(x: 1240.700, y: -2585.800),
		CGPoint(x: 1809.600, y: -2742.900),
		CGPoint(x: 1796.200, y: -2823.300),
		CGPoint(x: 1725.300, y: -3512.900),
		CGPoint(x: 2512.500, y: -3625.900),
		CGPoint(x: 2698.300, y: -3553.100),
		CGPoint(x: 2912.800, y: -4081.800),
		CGPoint(x: 3148.400, y: -4654.500),
		CGPoint(x: 3615.800, y: -4675.600),
		CGPoint(x: 4305.300, y: -3694.900),
		CGPoint(x: 4360.800, y: -3547.400),
		CGPoint(x: 4217.100, y: -2842.500),
		CGPoint(x: 4096.400, y: -2160.600),
		CGPoint(x: 4906.600, y: -1269.900),
		CGPoint(x: 5691.900, y: -411.800),
		CGPoint(x: 5724.500, y: -484.600),
		CGPoint(x: 7526.900, y: -4395.800),
		CGPoint(x: 7877.400, y: -4460.900),
		CGPoint(x: 8266.200, y: -4150.600),
		CGPoint(x: 8624.400, y: -3792.400),
		CGPoint(x: 8289.200, y: -927.000),
		CGPoint(x: 7911.900, y: 1913.500),
		CGPoint(x: 8565.100, y: 2756.300),
		CGPoint(x: 9494.100, y: 3953.400),
		CGPoint(x: 9656.900, y: 4545.300),
		CGPoint(x: 9474.900, y: 4964.800),
		CGPoint(x: 8986.700, y: 4989.800),
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
