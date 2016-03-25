//
//  AuthorDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//


import Foundation
import SQLite

class AuthorDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Authors"
    
    static let table = Table(TABLE_NAME)
    static let lastname = Expression<String>("lastname")
    static let firstname = Expression<String>("firstname")
    
    typealias T = Author
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(lastname)
                t.column(firstname)
                t.primaryKey(lastname, firstname)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let insert = table.insert(lastname <- item.lastname, firstname <- item.firstname)
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
        
        
        
        let query = table.filter(item.lastname == lastname && item.firstname == firstname )
        
        // delete the row of ComeFrom
        do{
            let comeFroms =  try ComeFromDataHelper.find(item.firstname, lastname: item.lastname)
            for c in comeFroms! {
                try ComeFromDataHelper.delete(c)
            }
        }catch{}
        
        
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
        
        
    }
    
    static func find(item: T) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let query = table.filter(item.lastname == lastname && item.firstname == firstname )
        let items = try DB.prepare(query.order(lastname))
        for item in items {
            retArray.append(Author(lastname: item[lastname], firstname: item[firstname]))
        }
        
        return retArray
        
    }
    
    static func find(lastname : String, firstname : String) throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let query = table.filter(self.lastname == lastname && self.firstname == firstname )
        let items = try DB.prepare(query.order(lastname))
        for item in items {
            retArray.append(Author(lastname: item[self.lastname], firstname: item[self.firstname]))
        }
        
        return retArray
        
    }

    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table.order(lastname))
        for item in items {
            retArray.append(Author(lastname: item[lastname], firstname: item[firstname]))
        }
        
        return retArray
        
    }
}

