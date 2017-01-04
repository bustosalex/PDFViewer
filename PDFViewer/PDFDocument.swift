//
//  PDFDocument.swift
//  PDFViewer
//
//  Created by Alexander Bustos on 12/20/16.
//  Copyright © 2016 Alexander Bustos. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class PDFDocument{
    
    
    var fileName: String
    var pageCount: Int
    let coreDocuement: CGPDFDocument
    
    
    
    init?(url: URL) {
        self.fileName = url.lastPathComponent
        
        guard let doc = CGPDFDocument(url as CFURL) else { return nil }
        
        self.coreDocuement = doc
        self.pageCount = doc.numberOfPages
    }
    
    init? (data: Data) {
        let pdfData = data as CFData
        let provider = CGDataProvider(data: pdfData)
        guard let doc = CGPDFDocument(provider!) else { return nil }
        self.fileName = "N/A"
        
        self.coreDocuement = doc
        self.pageCount = doc.numberOfPages
    }
    
    func getImagesFromPDF() -> [UIImage]{
        var images: [UIImage] = []
        for index in 1...self.pageCount {
            if let image = imageOfPDF(at: index){
                images.append(image)
            }
        }
        return images
    }
    
    
    /// Gets an image of the pdf based on the page number of the pdf file
    ///
    /// - Parameter index: page number
    /// - Returns: image of pdf page
    func imageOfPDF(at index: Int)-> UIImage?{
        
        
        guard let page = coreDocuement.page(at: index) else { return nil }
        
        // Determine the size of the PDF page.
        let pageRect = page.getBoxRect(.mediaBox)
        UIGraphicsBeginImageContext(pageRect.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        
        // Set the background to white
        context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        context.fill(pageRect)
        
        // Flips pdf to be right side up
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1, y: -1)
        
        // renders the pdf page
        context.saveGState()
        context.drawPDFPage(page)
        context.restoreGState()
        
        defer { UIGraphicsEndImageContext() }
        // get image of pdf
        guard let currentImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        
        return currentImage

    }
    
    func save(_ image: UIImage){
        let fileManager = FileManager.default
        var paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let pngData = UIImagePNGRepresentation(image)
        
        let path = paths[0].appendingPathComponent("image.png")
        do{
            try pngData?.write(to: path)
            print("Successfully written to file: \(path.absoluteString)")
        }
        catch {
            print("Error trying to write to file: \(path.absoluteString)")
        }

        
    }
}
