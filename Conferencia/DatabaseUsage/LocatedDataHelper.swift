//
//  LocatedDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

class LocatedDataHelper {
    static let TABLE_NAME = "Located"
    
    static let table = Table(TABLE_NAME)
    static let lastname = Expression<String>("lastname")
    static let firstname = Expression<String>("firstname")
    static let docid = Expression<Int64>("docid")
    static let speaker = Expression<String>("speaker")
    
    
    typealias T = Located
    
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(lastname)
                t.column(firstname)
                t.column(docid)
                t.column(speaker)
                t.primaryKey(lastname, firstname, docid)

                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    static func find(doc : Int64? = -1, item : T? = nil) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        var query = table.filter(doc! == self.docid)
        
        if doc == -1 {
            query = table.filter(item!.lastname == lastname && item!.firstname == firstname && item!.docid == docid)
        }
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(Located(lastname: item[lastname], firstname: item[firstname], docid: item[docid], speaker: item[speaker]))
        }
        
        return retArray
        
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let insert = table.insert(or: .Replace, lastname <- item.lastname, firstname <- item.firstname, docid <- item.docid, speaker <- item.speaker)
        do {
            let rowId = try DB.run(insert)
            guard rowId > 0 else {
                throw DataAccessError.Insert_Error
            }
            return rowId
        } catch _ {
            throw DataAccessError.Insert_Error
        }
        
        
    }
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(item.lastname == lastname && item.docid == docid && item.firstname == firstname)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
        
        
    }
    
    static func find(firstname : String, lastname : String) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let query = table.filter(firstname == self.firstname && lastname == self.lastname)
        let items = try DB.prepare(query)
        for item in items {
            retArray.append(Located(lastname: item[self.lastname], firstname: item[self.firstname], docid: item[docid], speaker: item[speaker]))
        }
        
        return retArray
        
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(Located(lastname: item[lastname], firstname: item[firstname], docid: item[docid], speaker: item[speaker]))
        }
        
        return retArray
        
    }
    
    
}
