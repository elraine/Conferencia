//
//  LocationDataHelper.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

class LocationDataHelper: DataHelperProtocol {
    static let TABLE_NAME = "Locations"
    
    static let table = Table(TABLE_NAME)
    static let place = Expression<String?>("place")
    static let city = Expression<String?>("city")
    static let country = Expression<String?>("country")
    static let lat = Expression<String>("lat")
    static let lng = Expression<String>("lng")
    
    
    typealias T = Location

    
    static func createTable() throws {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        do {
            let _ = try DB.run( table.create(ifNotExists: true) {t in
                t.column(place)
                t.column(city)
                t.column(country)
                t.column(lat)
                t.column(lng)
                t.primaryKey(lat,lng)
                })
            
        } catch _ {
            // Error throw if table already exists
        }
    }
    
    static func insert(item: T) throws -> Int64 {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        if (item.place != nil && item.city != nil && item.country != nil ) {
            let insert = table.insert(or: .Replace,place <- item.place!, city <- item.city!, country <- item.country!, lat <- item.lat, lng <- item.lng)

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
    
    
    static func deleteAll () throws -> Void {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        
        do {
            let tmp = try DB.run(table.delete())
            guard tmp == 1 else {
                throw DataAccessError.Delete_Error
            }
        } catch _ {
            throw DataAccessError.Delete_Error
        }
        
        
    }
    
    
    static func find(latId: String, lngId: String) throws -> T? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        let query = table.filter(latId == lat && lng == lngId)
    
        let items = try DB.prepare(query)
        for item in  items {
            return Location(place: item[place], city: item[city], country: item[country], lat: item[lat], lng: item[lng])
        }
        
        return nil
        
    }
    
    static func findAll() throws -> [T]? {
        guard let DB = SQLiteDataStore.sharedInstance.CDB else {
            throw DataAccessError.Datastore_Connection_Error
        }
        var retArray = [T]()
        let items = try DB.prepare(table)
        for item in items {
            retArray.append(Location(place: item[place], city: item[city], country: item[country], lat: item[lat], lng: item[lng]))
        }
        
        return retArray
        
    }
    
}









