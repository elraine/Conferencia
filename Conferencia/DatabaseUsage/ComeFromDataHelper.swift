//
//  ComeFromDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 05/02/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

class ComeFromDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "ComeFrom"
    
    static let table = Table(TABLE_NAME)
    static let cfid = Expression<Int64>("cfid")
    static let affiliationname = Expression<String>("affiliationname")
    static let lastname = Expression<String>("lastname")
    static let firstname = Expression<String>("firstname")
    
    typealias T = ComeFrom
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(ComeFrom(lastname: item[lastname], firstname: item[firstname], affiliationname: item[affiliationname]))
        }
        
        return retArray
        
    }
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(cfid,primaryKey: true)
                t.column(affiliationname)
                t.column(lastname)
                t.column(firstname)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    static func find(firstname: String, lastname: String) throws -> String? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(firstname == self.firstname && lastname == self.lastname)
        
        let items = try DB.prepare(query)
        var res : String?
        for item in items {
            res = item[affiliationname]
        }
        if res == nil {
            res = ""
        }
        return res
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(affiliationname <- item.affiliationname, lastname <- item.lastname, firstname <- item.firstname)
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
        let query = table.filter(item.affiliationname == affiliationname && item.lastname == lastname && item.firstname == firstname)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
        
        
    }
    
    
    
}

