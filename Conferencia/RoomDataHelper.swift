//
//  RoomDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

class RoomDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Rooms"
    
    static let table = Table(TABLE_NAME)
    static let roomid = Expression<Int64>("roomid")
    static let name = Expression<String>("name")
    static let capacity = Expression<String?>("capacity")
    static let decription = Expression<String?>("decription")
    
    
    typealias T = Room
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(roomid,primaryKey: true)
                t.column(name)
                t.column(capacity)
                t.column(decription)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        // fonction qui renvoie un booleen
        if (item.capacity != nil && item.decription != nil ) {
            // fonction
            let insert = table.insert(roomid <- item.roomid, name <- item.name, capacity <- item.capacity!, decription <- item.decription!)
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
        throw DataAccessError.Nil_In_Data
        
    }
    
    static func delete (item: T) throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        let query = table.filter(item.roomid == roomid)
        do {
            let tmp = try DB.run(query.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
  
        
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(Room(roomid: item[roomid], name: item[name], capacity: item[capacity], decription: item[decription]))
        }
        
        return retArray
        
    }
    
}

