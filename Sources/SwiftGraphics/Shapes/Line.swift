//
//  Line.swift
//  Processing
//
//  Created by Emory Dunn on 5/17/20.
//  Copyright © 2020 Lost Cause Photographic, LLC. All rights reserved.
//

import Foundation

/// Represents a line between two points
public class Line: Shape, Intersectable {
    
    /// The starting point of the line
    public var start: Vector
    
    /// The ending point of the line
    public var end: Vector
    
    /// The length of the line
    public var length: Double { end.dist(start) }
    
    /// The midpoint of the line
    public var center: Vector {
        return Vector(
            (end.x + start.x) / 2,
            (end.y + start.y) / 2
        )
    }
    
    /// Instantiate a new `Line`
    /// - Parameters:
    ///   - start: Starting point
    ///   - end: Ending point
    public init(_ start: Vector, _ end: Vector) {
        self.start = start
        self.end = end
    }
    
    /// Instantiate a new `Line` from coordinates
    /// - Parameters:
    ///   - x1: Starting X coordinate
    ///   - y1: Starting Y coordinate
    ///   - x2: Ending X coordinate
    ///   - y2: Ending Y coordinate
    public init(_ x1: Double, _ y1: Double, _ x2: Double, _ y2: Double) {
        self.start = Vector(x1, y1)
        self.end = Vector(x2, y2)
    }
    
    /// Determine whether a point is on the line
    /// - Parameter point: Whether the point is on the line
    public func pointIsOnLine(_ point: Vector) -> Bool {
        let lineDot = start.x * -end.y + start.y * end.x
        let dot = start.x * -point.y + start.y * point.x
        
        if (lineDot > 0 && dot > 0) {
            return true
        } else if (lineDot < 0 && dot < 0) {
            return true
        } else {
            return false
        }
    }
    
    /// Calculate the vector normal of the line
    ///
    /// - Returns: A `Vector` whose heading is perpendicular to the line
    public func normal() -> Vector {
        //calculate base top normal
        let baseDelta = Vector.sub(end, start)
        baseDelta.normalize()
        let normal = Vector(-baseDelta.y, baseDelta.x)

        return normal
    }
    

    /// Find any intersecting points with the specified line
    ///
    /// Adapted from https://stackoverflow.com/a/1968345
    /// - Parameter line: Other line to intersect
    public func lineIntersection(_ line: Line) -> [Vector] {
        // p0 -> self.start
        // p1 -> self.end
        // p2 -> line.start
        // p3 -> line.end
        let s1_x = self.end.x - self.start.x
        let s1_y = self.end.y - self.start.y
        let s2_x = line.end.x - line.start.x
        let s2_y = line.end.y - line.start.y
        
        let s = (-s1_y * (self.start.x - line.start.x) + s1_x * (self.start.y - line.start.y)) / (-s2_x * s1_y + s1_x * s2_y)
        let t = ( s2_x * (self.start.y - line.start.y) - s2_y * (self.start.x - line.start.x)) / (-s2_x * s1_y + s1_x * s2_y)
        
        var intersections = [Vector]()
        if (s >= 0 && s <= 1 && t >= 0 && t <= 1) {
            // Collision detected
            let i_x = self.start.x + (t * s1_x)
            let i_y = self.start.y + (t * s1_y)
            
            intersections.append(Vector(i_x, i_y))

        }

        return intersections
    }
    
}

extension Line: CGDrawable {
    public func draw(in context: CGContext) {
        context.strokeLineSegments(between: [start.cgPoint, end.cgPoint])
    }
    
    
    /// Draw a debug representation of the line
    public func debugDraw(in context: CGContext) {
        let normal = self.normal()
        
        context.setStrokeColor(.init(red: 255, green: 0, blue: 128, alpha: 1))
        Line(
            center.x,
            center.y,
            center.x - normal.x * 50,
            center.y - normal.y * 50
        ).draw()
        
        context.setStrokeColor(.init(gray: 0.5, alpha: 1))
        self.draw(in: context)
        
    }
}

extension Line: SVGDrawable {
    public func svgElement() -> XMLElement {
        let element = XMLElement(kind: .element)
        element.name = "line"
        element.setAttributesWith([
            "x1": String(self.start.x),
            "y1": String(self.start.y),
            "x2": String(self.end.x),
            "y2": String(self.end.y),
            "stroke": "#000",
            "stroke-width": "4"
        ])
        
        return element
    }
}