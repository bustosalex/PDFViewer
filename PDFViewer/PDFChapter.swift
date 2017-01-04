//
//  PDFChapter.swift
//  PDFViewer
//
//  Created by Alexander Bustos on 12/21/16.
//  Copyright © 2016 Alexander Bustos. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class PDFChapter{
    
    let chapterNumber: Int
    let document: PDFDocument
    

    init(chapterNumber: Int, document: PDFDocument){
        self.chapterNumber = chapterNumber
        self.document = document
    }
    
    func pdfForChapter(_ name: String) -> PDFDocument? {
        guard let documentPath =  Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
        return PDFDocument(url: documentPath)!
    }
    
    func pdfImagesForChapter() -> [UIImage] {
        let images = self.document.getImagesFromPDF()
        return images
    }
    
    func getAllPDFDocuments() -> [PDFDocument]{
        var totalPages = 0
        let base = "Chapter"
        var pdfDocuments: [PDFDocument] = []
        for number in 1...16 {
            let chapterName = base + String(number)
            if let pdf = pdfForChapter(chapterName){
                totalPages += pdf.pageCount
                pdfDocuments.append(pdf)
            }
        }
        
        return pdfDocuments
    }
    
}
