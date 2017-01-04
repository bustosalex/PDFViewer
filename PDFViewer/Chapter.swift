//
//  Chapter.swift
//  PDFViewer
//
//  Created by Alexander Bustos on 12/26/16.
//  Copyright © 2016 Alexander Bustos. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Chapter: Object{
    dynamic var id = 0

    var imageNames: [String]{
        get {
            return names.map {
                $0.string
            }
        }
        set {
            names.removeAll()
            names.append(objectsIn: newValue.map({ RealmString(value: [$0]) }))
        }
    }
    
    let names = List<RealmString>()
    dynamic var path = ""
    
    override static func ignoredProperties() -> [String] {
        return ["imageNames"]
    }
    
    override static func primaryKey() -> String?{
        return "id"
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        let nextLocation: Array = Array(realm.objects(Chapter.self).sorted(byProperty: "id"))
        let last = nextLocation.last
        if nextLocation.count > 0 {
            let currentID = last?.value(forKey: "id") as? Int
            return currentID! + 1
        }
        else {
            return 1
        }
    }
    
}
