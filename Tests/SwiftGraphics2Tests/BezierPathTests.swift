//
//  File.swift
//  
//
//  Created by Emory Dunn on 5/3/22.
//

import Foundation
import XCTest
@testable import SwiftGraphics2

final class BezierPathTests: XCTestCase {
    
    func testBezier() {
        let path = BezierPath(
            Vector(55, 150),
            Vector(130, 40),
            Vector(200, 100)
        )
        
        measure {
            let point = path.bezier(0.8)
            XCTAssertEqual(point, Vector(171.8, 82.8))
        }
        
    }
    
    func testBezierCurve() {
        let path = BezierPath(
            Vector(55, 150),
            Vector(130, 40),
            Vector(200, 100)
        )
        
        let curve = Path(strideFrom: 0, through: 1, by: 0.1) {
            path.bezier($0)
        }
        
//        curve
        
        XCTAssertEqual(curve, Path(Vector (55.0, 150.0),
                                  Vector (69.95, 129.7),
                                  Vector (84.8, 112.8),
                                  Vector (99.55000000000001, 99.3),
                                  Vector (114.2, 89.2),
                                  Vector (128.75, 82.5),
                                  Vector (143.2, 79.19999999999999),
                                  Vector (157.55, 79.3),
                                  Vector (171.8, 82.8),
                                  Vector (185.95, 89.7),
                                  Vector (200.0, 100.0)))

    }
    
    func testBezierSplit() {
        let path = BezierPath(
            Vector(55, 150),
            Vector(130, 40),
            Vector(200, 100)
        )
        
        let paths = path.splitCurve(at: 0.8)

        XCTAssertEqual(paths.0.controlPoints, [Vector (55.0, 150.0), Vector (115.0, 62.0), Vector (171.8, 82.8)])
        XCTAssertEqual(paths.1.controlPoints, [Vector (171.8, 82.8), Vector (186.0, 88.0), Vector (200.0, 100.0)])

    }

    
//    func testMatrixBezier() {
//        let path = Path(
//            Vector(55, 150),
//            Vector(130, 40),
//            Vector(200, 100)
//        )
//
//        let point = path.matrixBezier(0.8)
//
//        XCTAssertEqual(point, Vector(171.8, 82.8))
//
//    }
    
}