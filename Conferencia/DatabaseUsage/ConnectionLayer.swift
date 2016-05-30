//
//  ConnectionLayer.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

var endFirstLayer = false{
    didSet{
        LoadingOverlay.shared.hideOverlayView()
    }
}

import Foundation

import SQLite

enum DataAccessError: ErrorType {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
    case Update_Error
}

class SQLiteDataStore {
    static let sharedInstance = SQLiteDataStore()
    let CDB: Connection?
    
    private init() {
        
        var path = "ConferenceDB.sqlite"
        
        if let dirs: [NSString] = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.AllDomainsMask, true) as [NSString] {
                
                let dir = dirs[0]
                path = dir.stringByAppendingPathComponent("ConferenceDB.sqlite");
        }
        
        do {
           //path = "/Users/Angelique/Desktop/ConferenceDB.sqlite"
            CDB = try Connection(path)
        } catch _ {
            CDB = nil
        }
    }
    
    func createTables() throws{
        do {
            try CDB!.run(Table("Conferences").drop(ifExists: true))
            try CDB!.run(Table("Locations").drop(ifExists: true))
            try CDB!.run(Table("Events").drop(ifExists: true))
            try CDB!.run(Table("Rooms").drop(ifExists: true))
            try CDB!.run(Table("Docs").drop(ifExists: true))
            try CDB!.run(Table("Authors").drop(ifExists: true))
            try CDB!.run(Table("Affiliations").drop(ifExists: true))
            try CDB!.run(Table("Located").drop(ifExists: true))
            try CDB!.run(Table("Clusters").drop(ifExists: true))
            try CDB!.run(Table("ComeFrom").drop(ifExists: true))
            
            try ConferenceDataHelper.createTable()
            try LocationDataHelper.createTable()
            try EventDataHelper.createTable()
            try RoomDataHelper.createTable()
            try DocDataHelper.createTable()
            try AuthorDataHelper.createTable()
            try AffiliationDataHelper.createTable()
            try LocatedDataHelper.createTable()
            try ClusterDataHelper.createTable()
            try ComeFromDataHelper.createTable()
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
        endFirstLayer = true
    }
    
   
}