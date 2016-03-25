//
//  SetData.swift
//  DataBase
//
//  Created by Angélique Blondel on 03/02/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.


import Foundation

import Alamofire
import SQLite
import SwiftyJSON

let NO_ROOM : Int64  = -1

class SetDataManager {
    
    var id : Int?
    
    init(id: Int){
        self.id = id
        
    }
    
    func firstConnection() -> Int{
        setDataFileConf(id!)
        setDataFileEvent(id!)
        return 1
    }
    
    func update()-> Int{
    
        setDataFileConf(id!)
        setDataFileEvent(id!, update: true)
        return 1
    }
    
    func setDataFileConf(id: Int){
        Alamofire.request(.GET, "http://api.sciencesconf.org/conference/info/q/\(id)/").validate().responseJSON {  responseData -> Void in
            
            switch responseData.result {
            case .Success:
                if let value = responseData.result.value {
                    let json = JSON(value)
                    
                    self.setDataConference(json)
                    self.setDataLocation(json)
                    
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func setDataFileEvent(id: Int, update : Bool? = false){
        Alamofire.request(.GET, "http://api.sciencesconf.org/program/events/confid/\(id)/").validate().responseJSON {  responseData -> Void in
            switch responseData.result {
            case .Success:
                if let value = responseData.result.value {
                    let json = JSON(value)
                    if let eventArray = json[].array {
                        var eventsid = [Int64]()
                        for eventDict in eventArray {
                            eventsid.append(Int64(eventDict["eventid"].string!)!)
                            
                            self.setDataEvent(eventDict, update: update)
                            
                            if eventDict["room"] != nil {
                                self.setDataRoom(eventDict)
                            }
                            let eventid : Int = Int(eventDict["eventid"].string!)!
                            
                        
                            self.setDataFileDoc(id,eventid: eventid, update: update)
                        }
                        
                        // if a event is deleted
                        do{
                            let eventsData = try EventDataHelper.findAll()
                            for event in eventsData!{
                                if !eventsid.contains(event.eventid){
                                    try EventDataHelper.delete(event)
                                }
                            }
                        }catch{}
                        
                        // if a room is deleted
                        do{
                            let rooms = try RoomDataHelper.findAll()
                            for r in rooms! {
                                if  try EventDataHelper.find( roomid: r.roomid) == nil {
                                    try RoomDataHelper.delete(r)
                                }
                            }
                        } catch {
                            print(error)}
                        
                        // if a author is deleted
                        do{
                            let authors = try AuthorDataHelper.findAll()
                            for a in authors! {
                                if  try LocatedDataHelper.find(a.firstname, lastname: a.lastname) == nil {
                                    try AuthorDataHelper.delete(a)
                                }
                            }
                        } catch {
                            print(error)}
                        
                        // if a affilation is deleted
                        do{
                            let affiliations = try AffiliationDataHelper.findAll()
                            for a in affiliations! {
                                if  try ComeFromDataHelper.find(affiliationname: a.name) == nil {
                                    try AffiliationDataHelper.delete(a)
                                }
                            }
                        } catch {
                            print(error)}
                        
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
        
    }
    
    func setDataFileDoc(id: Int, eventid: Int, update : Bool? = false){
        Alamofire.request(.GET, "http://api.sciencesconf.org/program/comm/confid/\(id)/eventid/\(eventid)").validate().responseJSON {  responseData -> Void in
            switch responseData.result {
            case .Success:
                if let value = responseData.result.value {
                    let json = JSON(value)
                
                    if let docArray = json[].array {
                        var docsid = [Int64]()
                        
                        
                        for docDict in docArray {
                            var authors = [String]()
                            
                            self.setDataDoc(docDict, update: update)
                            
                            let docidJ: Int64 = Int64(docDict["docid"].string!)!
                            
                            docsid.append(docidJ)
                            
                            if let authorArray = docDict["authors"].array{
                                for authorDict in authorArray{
                                    
                                    var affilationsname = [String]()
                                    
                                    let lastnameJ: String = authorDict["lastname"].string!.uppercaseString
                                    let firstnameJ: String = authorDict["firstname"].string!
                                    
                                    authors.append("\(lastnameJ),\(firstnameJ)")
                                    
                                    self.setDataAuthor(authorDict, docidJ: docidJ, lastnameJ: lastnameJ, firstnameJ: firstnameJ)
                                    
                                    if let affiliationArray = authorDict["affiliations"].array{
                                        for affiliationDict in affiliationArray{
                                            affilationsname.append(affiliationDict["name"].string!)
                                            self.setDataAffiliation(affiliationDict, lastnameJ: lastnameJ, firstnameJ: firstnameJ)
                                        }
                                    }
                                    
                                    // if a affilation is deleted for a author
                                    do{
                                        let affilationData = try ComeFromDataHelper.find(firstnameJ, lastname: lastnameJ)
                                        for a in affilationData!{
                                           var af = affilationsname.contains(a.affiliationname)
                                                print("name \(firstnameJ), \(lastnameJ) : \(a.affiliationname)")
                                                print(af ? "yes" : "no")
                                            
                                            //    try ComeFromDataHelper.delete(a)
                                            
                                        }
                                    }catch{print("affiliation deleted : \(error)")}
                                }

                            
                            }
                            
                            // if a author is deleted in a doc
                            do{
                                let authorsData = try LocatedDataHelper.find(Int64(docidJ))
                                for a in authorsData!{
                                    if authors.contains("\(a.lastname),\(a.firstname)") == false {
                                            try LocatedDataHelper.delete(a)
                                        }
                                    }
                            }catch{}
                            
                            
                        
                        }
                        
                        // if a doc is deleted
                        do{
                            let docsData = try DocDataHelper.findByEvent(Int64(eventid))
                            for doc in docsData!{
                                if !docsid.contains(doc.docid){
                                    try DocDataHelper.delete(doc)
                                }
                            }
                        }catch{}

                       
                        
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
    func setDataConference(json: JSON) {
        
        if let confidJ =  json["confid"].string, linkJ = json["link"].string, shortnameJ = json["shortname"].string, nameJ = json["name"].string, descriptionJ = json["description"].string, date_beginJ = json["date_begin"].string, date_endJ = json["date_end"].string, date_creationJ = json["date_creation"].string, lngJ = json["location"]["lng"].string, latJ = json["location"]["lat"].string {
            
            do {
                let conference = Conference(
                    confid: Int64(confidJ)!,
                    link: linkJ,
                    shortname: shortnameJ,
                    name: nameJ,
                    description: descriptionJ,
                    date_begin: date_beginJ,
                    date_end: date_endJ,
                    date_creation: date_creationJ,
                    lat: latJ,
                    lng: lngJ)
                
                _ = try ConferenceDataHelper.insert(conference)
        
                
            } catch _{print("insertion/update failed Conference")}
        }
    }
    
    
    
    func setDataLocation(json: JSON) {
        
        if let placeJ = json["location","place"].string , cityJ = json["location","city"].string, countryJ = json["location","country","labels","en"].string, latJ = json["location","lat"].string, lngJ = json["location","lng"].string {
            do {
                let location = Location(
                    place: placeJ,
                    city: cityJ,
                    country: countryJ,
                    lat: latJ,
                    lng: lngJ)
                _ = try LocationDataHelper.insert(location)
            } catch _{print("insertion failed location")}
            
        }
    }
    
    
    func setDataEvent(eventDict: JSON,  update : Bool? = false) {
        
        let eventidJ : Int64 = Int64(eventDict["eventid"].string!)!
        let dateJ : String = eventDict["date"].string!
        let time_startJ : String = eventDict["time_start"].string!
        let time_endJ : String = eventDict["time_end"].string!
        let typeJ : String = eventDict["type"].string!
        let shorttitleJ : String? = eventDict["shorttitle"].string ?? ""
        let titleJ : String = eventDict["title"]["en"].string ?? ""
        let chairmanJ : String? = eventDict["chairman"].string ?? ""
        
        var roomidJ : Int64 = NO_ROOM
        
        
        if eventDict["room"] != nil {
            roomidJ = Int64(eventDict["room"]["roomid"].string!)!
        }
        
        do {
            let event = Event(
                eventid: eventidJ,
                date: dateJ,
                time_start: time_startJ,
                time_end: time_endJ,
                type: typeJ,
                shorttitle: shorttitleJ,
                title: titleJ,
                chairman: chairmanJ,
                roomid: roomidJ
            )
            
            if update == false{
                 _ = try EventDataHelper.insert(event)
            }else{
                 _ = try EventDataHelper.upDate(event)
            }
            
        } catch _{
            print("insertion/update failed event")}
    }
    
    func setDataRoom(eventDict: JSON) {
        
        let roomidJ = Int64(eventDict["room"]["roomid"].string!)!
        let nameJ: String = eventDict["room"]["name"].string!
        let capacityJ: String? = eventDict["room"]["capacity"].string ?? ""
        let decriptionJ: String? = eventDict["room"]["decription"].string ?? ""
        
        do {
            _ = try RoomDataHelper.insert(Room(
                roomid: roomidJ,
                name: nameJ,
                capacity: capacityJ,
                decription: decriptionJ
                ))
            
            
        } catch _{
            print("insertion/update failed room")}
      
    }
    
    
    
    func setDataDoc(docDict: JSON, update : Bool? = false) {
        
        let docidJ: Int64 = Int64(docDict["docid"].string!)!
        let time_startJ: String = docDict["time_start"].string!
        let time_endJ: String = docDict["time_end"].string!
        let titleJ: String = docDict["title"].string!
        let abstractJ: String? = docDict["abstract"].string ?? ""
        let linkJ: String? = docDict["file"]["link"].string ?? ""
        let eventidJ: Int64 = Int64(docDict["eventid"].string!)!
        
        do {
            let doc = Doc(
                docid: docidJ,
                time_start: time_startJ,
                time_end: time_endJ,
                title: titleJ,
                abstract: abstractJ,
                link: linkJ,
                eventid: eventidJ
            )
            if update == false {
                _ = try DocDataHelper.insert(doc)
            }else{
                _ = try DocDataHelper.upDate(doc)
            }
            
        }catch _{
            print("insertion failed doc")}
    }
    
    func setDataAuthor(authorDict: JSON, docidJ: Int64, lastnameJ: String, firstnameJ: String) {
        
        let speakerJ: String = authorDict["speaker"].string!
    
        // located
        
        do {
            let located = Located(
                lastname: lastnameJ,
                firstname: firstnameJ,
                docid: docidJ,
                speaker: speakerJ
            )
            let l = try LocatedDataHelper.find(item : located)
            if l!.count == 0 {
                let _ = try LocatedDataHelper.insert(located)
            }
            
        }catch _{
            print("insertion failed located")}
        
        
        // ajout auteur
        do {
            let author = Author(
                lastname: lastnameJ,
                firstname: firstnameJ
            )
            let a = try AuthorDataHelper.find(author)
            if a!.count == 0 {
                let _ = try AuthorDataHelper.insert(author)
            }
        }catch _{
            print("insertion failed Author")}
    }
    
    
    func setDataAffiliation(affiliationDict: JSON, lastnameJ: String, firstnameJ: String){
        
        // affiliation
        
        let shortnameJ: String? = affiliationDict["shortname"].string ?? ""
        let nameJ: String = affiliationDict["name"].string!
        
        
        do {
            let affiliation =  Affiliation(
                shortname: shortnameJ,
                name: nameJ
            )
            
            let aff = try AffiliationDataHelper.find(affiliation)
            if aff!.count == 0{
                _ = try AffiliationDataHelper.insert(affiliation)
            }
            
        }catch _{
            print("insertion failed affiliation")}
        
        do {
            let comeFrom = ComeFrom(
                lastname: lastnameJ,
                firstname: firstnameJ,
                affiliationname: nameJ
            )
            
            let cf = try ComeFromDataHelper.find(comeFrom)
            if cf!.count == 0 {
                _ = try ComeFromDataHelper.insert(comeFrom)
            }
            
        }catch _{
            print("insertion failed ComeFrom")}
        
    }
}
