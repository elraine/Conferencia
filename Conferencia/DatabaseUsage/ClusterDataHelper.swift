//
//  ClusterDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 29/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

class ClusterDataHelper {
    static let TABLE_NAME = "Clusters"
    
    static let table = Table(TABLE_NAME)
    
    static let clusterid = Expression<Int64>("clusterid")
    static let shorttitle = Expression<String>("shorttitle")
    static let description = Expression<String?>("description")
    
    typealias T = Cluster
    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
               
                t.column(clusterid, primaryKey: true)
                t.column(shorttitle)
                t.column(description)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.description != nil ) {
            let insert = table.insert(shorttitle <- item.shorttitle, description <- item.description)
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
        let query = table.filter(item.clusterid == clusterid)
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
    