//
//  ConnectionLayer.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation

import SQLite

enum DataAccessError: ErrorType {
    case Datastore_Connection_Error
    case Insert_Error
    case Delete_Error
    case Search_Error
    case Nil_In_Data
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
            CDB = try Connection(path)
        } catch _ {
            CDB = nil
        }
    }
    
    func createTables() throws{
        do {
            try ConferenceDataHelper.createTable()
            try LocationDataHelper.createTable()
            try ConferenceDataHelper.createTable()
            try EventDataHelper.createTable()
            try RoomDataHelper.createTable()
            try DocDataHelper.createTable()
            try AuthorDataHelper.createTable()
            try AffiliationDataHelper.createTable()
            try LocatedDataHelper.createTable()
            try ClusterDataHelper.createTable()
        } catch {
            throw DataAccessError.Datastore_Connection_Error
        }
    }
}