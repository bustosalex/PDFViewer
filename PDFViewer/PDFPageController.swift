//
//  PDFPageController.swift
//  PDFViewer
//
//  Created by Alexander Bustos on 12/20/16.
//  Copyright © 2016 Alexander Bustos. All rights reserved.
//

import UIKit
import RealmSwift


/// Page View Controller manages the pages to flip and updates the pages when 
/// necessary
class PDFPageController: UIPageViewController {
    
    var pdfControllers: [UIViewController] = []
    var pdfImages: [UIImage]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // remove everything from the realm database. This is has to be removed
        // after testing
        let realm = try! Realm()
        try! realm.write {
            realm.deleteAll()
        }
        
        dataSource = self
        setup()
        
        // set the first view controller to be displayed
        if let firstViewController = pdfControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true,completion: nil)
        }
    }
    
    
    func setup(){
        
        //checkEmptyDirectories()
        
        //createOrUpdateRealm()
        
        
        // if there is anything in realm it's going to load those pages first
        // otherwise it's going to display an error message
        loadData()
        
        // makes and api call to get the pdf for the chapter
        hitAPI(forChapter: 1)
        hitAPI(forChapter: 2)
        
        //reloadData()
    }
    
    func checkEmptyDirectories(){
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        for number in 1...16{
            let folderName = "Chapter"+String(number)
            let path = documentDirectory.appendingPathComponent(folderName, isDirectory: true)
            if !fileManager.fileExists(atPath: path.absoluteString){
                createFolder(at: path, fileManager: fileManager)
            }
            
            var content: [String] = []
            do{
                content = try fileManager.contentsOfDirectory(atPath: path.absoluteString)
                print(content)
            }
            catch{
                print("Empty")
                let url = Bundle.main.url(forResource: folderName, withExtension: "pdf")
                if let doc = PDFDocument(url: url!){
                    addChapter(number: number, path: path, fileManager: fileManager, pdf: doc)
                }
            }
        }
    }

    func createOrUpdateRealm(forChapter number: Int, withDocument document: PDFDocument){
        let fileManager = FileManager.default
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        
        // New
        let folderName = "Chapter" + String(number)
        let path = documentDirectory.appendingPathComponent(folderName, isDirectory: true)
        
        if fileManager.fileExists(atPath: path.absoluteString){
            addChapter(number: number, path: path, fileManager: fileManager, pdf: document)

        }
        else {
            createFolder(at: path, fileManager: fileManager)
            addChapter(number: number, path: path, fileManager: fileManager, pdf: document)

        }
    }
    
    /// Adds pdf for a specific chapter
    ///
    /// - Parameters:
    ///   - chapter: chapter to add it pdf to
    ///   - path: the file path to where the images are being stored
    ///   - fileManager: file manager that handles reads and writes
    ///   - pdf: the actual pdf document that will be reformatted
    func addChapter(number chapter: Int, path: URL, fileManager: FileManager, pdf: PDFDocument){
        removeContentsOfFolder(path: path, fileManager: fileManager)
        let chapterDoc = PDFChapter(chapterNumber: chapter, document: pdf)
        var imageNumber = 0
        var imageNames: [String] = []
        for image in chapterDoc.pdfImagesForChapter(){
            imageNumber += 1
            let png = UIImagePNGRepresentation(image)
            let imageName = "image"+String(imageNumber)+".png"
            let imagePath = path.appendingPathComponent(imageName)
            do{
                try png?.write(to: imagePath)
                imageNames.append(imageName)
                print(imagePath.absoluteString)
            }
            catch {
                print("Error trying to write to file: \(imagePath.absoluteString)")
            }
        }
        
        let chapter = Chapter()
        chapter.id = chapter.incrementID()
        chapter.imageNames = imageNames
        chapter.path = path.absoluteString
        
        let realm = try! Realm()
        try! realm.write {
            realm.add(chapter)
        }
    
    



    }
    // remove anything that is in the folder if it's been updated
    func removeContentsOfFolder(path: URL, fileManager: FileManager){
        if let enumerator = fileManager.enumerator(at: path, includingPropertiesForKeys: nil){
            while let item = enumerator.nextObject(){
                if let itemURL = item as? URL{
                    do{
                        try fileManager.removeItem(at: itemURL)
                        
                    }
                    catch {
                        print("Error removing file at: \(itemURL.absoluteString)")
                    }
                }
            }
        }

    }
    // Creates folder if it doesn't exists for a chapter
    func createFolder(at path: URL, fileManager: FileManager){
        do {
            try fileManager.createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
        }
        catch {
            print("Error trying to create directory")
        }
    }
    
    
    /// Gets the pdf from the servre then refreshes the page view controller to display the new pdf
    ///
    /// - Parameter chapter: Chapter number for pdf
    func hitAPI(forChapter chapter: Int){
        
        //let url = URL(string: "\(Crednetials.baseUrl)/chapters/\(chapter)/pdf")
        let url = URL(string: "http://tutorial.math.lamar.edu/pdf/Calculus_Cheat_Sheet_All.pdf")
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue(Crednetials.token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            if data != nil && error == nil {
                // This is where im actually setting the data for pdfs that im getting from online
                if let document = PDFDocument(data: data!){
                    self.createOrUpdateRealm(forChapter: chapter, withDocument: document)
                    self.reloadData()
                }
                else {
                    print("Couldn't get pdf for chapter \(chapter) from server")
                }
            }
            else {
                print("Error connecting to url")
            }
            
        })
        task.resume()

        
    }
    
    // reload the page view controller if any of the pdfs were updated
    func reloadData(){
        self.dataSource = nil
        self.dataSource = self
        loadData()
        print("Still works")
        if pdfControllers.count != 0 {
            let first = [pdfControllers[0]]
            DispatchQueue.main.async {
                self.setViewControllers(first, direction: .forward, animated: true) { (Bool) in
                    print("test")
                }
            }
            
        }
        
    }
    
    /// This method gets images for each pdf online and loads them into their view controllers
    func loadData(){
        pdfControllers = []
        let realm = try! Realm()
        let chapters = realm.objects(Chapter.self)
        if chapters.count != 0 {
            var chapterNumber = 0
            for chapter in chapters{
                chapterNumber += 1
                let chapterFolder = chapter.path
                var page = 0
                for image in chapter.imageNames{
                    page += 1
                    let completePath = chapterFolder + image
                    let url = URL(string: completePath)
                    do {
                        let data = try Data(contentsOf: url!)
                        let controller = storyboard?.instantiateViewController(withIdentifier: "PDFViewController") as! PDFViewController
                        controller.pdfPageImage = UIImage(data: data)
                        controller.chapter = chapterNumber
                        controller.index = page
                        pdfControllers.append(controller)
                        //print("Successfully loaded image located at: \(url!.absoluteString)")
                    }
                    catch {
                        print("Error getting data from \(url?.absoluteString)")
                    }

                }
            }
        }
        else {
            print("There's nothing in the realm database")
        }

    }
    
    
    
    func document(_ name: String) -> PDFDocument? {
        guard let documentURL = Bundle.main.url(forResource: name, withExtension: "pdf") else { return nil }
        return PDFDocument(url: documentURL)!
    }
    
    
    

}

extension PDFPageController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pdfControllers.index(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        // User is on the first view controller and swiped left to loop to
        // the last view controller.
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard pdfControllers.count > previousIndex else {
            return nil
        }
        
        return pdfControllers[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pdfControllers.index(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = pdfControllers.count
        

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        
        return pdfControllers[nextIndex]
    }
    
    
    
    
}
