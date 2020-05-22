//
//  SVGContext.swift
//  
//
//  Created by Emory Dunn on 5/21/20.
//

import Foundation

public class SVGContext: DrawingContext {
    
    public var width: Int
    public var height: Int
    
    public var shapes: [SVGDrawable] = []
    
    public init(width: Int, height: Int) {
        self.width = width
        self.height = height
    }
    
    public convenience init(sketch: SketchView) {
        self.init(
            width: Int(sketch.bounds.width),
            height: Int(sketch.bounds.height)
        )
    }
    
    
    public func addShape(_ shape: SVGDrawable) {
        shapes.append(shape)
    }
    
    public func makeDoc() -> XMLDocument {
        
        // Set up the SVG root element
        let svgRoot = XMLElement(kind: .element)
        svgRoot.name = "svg"
        svgRoot.setAttributesWith([
            "width": String(width),
            "height": String(height),
            "xmlns": "http://www.w3.org/2000/svg"
        ])
        
        
        // Transform the shapes into XML elements and add them to the root
        let nodes = shapes.map {
            $0.svgElement()
        }
        svgRoot.setChildren(nodes)
        
        let doc = XMLDocument(kind: .document)
        doc.setRootElement(svgRoot)
        
        return doc
    }
    
}
