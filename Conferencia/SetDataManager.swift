//
//  SetData.swift
//  DataBase
//
//  Created by Angélique Blondel on 03/02/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation

import Alamofire
import SQLite
import SwiftyJSON

let NO_ROOM : Int64  = -1

class SetDataManager {
    
    init(id: Int){
        setDataFileConf(id)
        setDataFileEvent(id)
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
    
    func setDataFileEvent(id: Int){
        Alamofire.request(.GET, "http://api.sciencesconf.org/program/events/confid/\(id)/").validate().responseJSON {  responseData -> Void in
            switch responseData.result {
            case .Success:
                if let value = responseData.result.value {
                    let json = JSON(value)
                    if let eventArray = json[].array {
                        for eventDict in eventArray {
                            self.setDataEvent(eventDict)
                            
                            if eventDict["room"] != nil {
                                self.setDataRoom(eventDict)
                            }
                            let eventid : Int = Int(eventDict["eventid"].string!)!
                            
                            self.setDataFileDoc(id,eventid: eventid)
                        }
                    }
                }
            case .Failure(let error):
                print(error)
            }
        }
        
    }
    
    func setDataFileDoc(id: Int, eventid: Int){
        Alamofire.request(.GET, "http://api.sciencesconf.org/program/comm/confid/\(id)/eventid/\(eventid)").validate().responseJSON {  responseData -> Void in
            switch responseData.result {
            case .Success:
                if let value = responseData.result.value {
                    let json = JSON(value)
                    
                    if let docArray = json[].array {
                        for docDict in docArray {
                            self.setDataDoc(docDict)
                            
                            let docidJ: Int64 = Int64(docDict["docid"].string!)!
                            
                            if let authorArray = docDict["authors"].array{
                                for authorDict in authorArray{
                                    let lastnameJ: String = authorDict["lastname"].string!
                                    let firstnameJ: String = authorDict["firstname"].string!
                                    self.setDataAuthor(authorDict, docidJ: docidJ, lastnameJ: lastnameJ, firstnameJ: firstnameJ)
                                    
                                    if let affiliationArray = authorDict["affiliations"].array{
                                        for affiliationDict in affiliationArray{
                                            
                                            self.setDataAffiliation(affiliationDict, lastnameJ: lastnameJ, firstnameJ: firstnameJ)
                                        }
                                    }
                                }
                            }
                            
                        }
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
                print(conference)
                let confId = try ConferenceDataHelper.insert(conference)
                print(confId)
                
            } catch _{print("insertion failed Conference")}
        }
    }
    
    
    
    func setDataLocation(json: JSON) {
        
        if let placeJ = json["location","place"].string , cityJ = json["location","city"].string, countryJ = json["location","country","labels","en"].string, latJ = json["location","lat"].string, lngJ = json["location","lng"].string {
            do {
                let locId = try LocationDataHelper.insert(
                    Location(
                        place: placeJ,
                        city: cityJ,
                        country: countryJ,
                        lat: latJ,
                        lng: lngJ)
                )
                print(locId)
            } catch _{print("insertion failed location")}
            
        }
    }
    
    
    func setDataEvent(eventDict: JSON) {
        
        let eventidJ : Int64 = Int64(eventDict["eventid"].string!)!
        let dateJ : String = eventDict["date"].string!
        let time_startJ : String = eventDict["time_start"].string!
        let time_endJ : String = eventDict["time_end"].string!
        let typeJ : String = eventDict["type"].string!
        let shorttitleJ : String? = eventDict["shorttitle"].string ?? ""
        let titleJ : String = eventDict["title"]["en"].string!
        let chairmanJ : String? = eventDict["chairman"].string ?? ""
        
        var roomidJ : Int64 = NO_ROOM
        
        
        if eventDict["room"] != nil {
            roomidJ = Int64(eventDict["room"]["roomid"].string!)!
        }
        
        do {
            let _ = try EventDataHelper.insert(
                Event(
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
            )
            
        } catch _{
            print("insertion failed event")}
    }
    
    func setDataRoom(eventDict: JSON) {
        
        let roomidJ = Int64(eventDict["room"]["roomid"].string!)!
        let nameJ: String = eventDict["room"]["name"].string!
        let capacityJ: String? = eventDict["room"]["capacity"].string ?? ""
        let decriptionJ: String? = eventDict["room"]["decription"].string ?? ""
        
        do {
            _ = try RoomDataHelper.insert(
                Room(
                    roomid: roomidJ,
                    name: nameJ,
                    capacity: capacityJ,
                    decription: decriptionJ
                )
            )
            
        } catch _{
            print("insertion failed room")}
    }
    
    
    
    func setDataDoc(docDict: JSON) {
        
        let docidJ: Int64 = Int64(docDict["docid"].string!)!
        let time_startJ: String = docDict["time_start"].string!
        let time_endJ: String = docDict["time_end"].string!
        let titleJ: String = docDict["title"].string!
        let abstractJ: String? = docDict["abstract"].string ?? ""
        let linkJ: String? = docDict["file"]["link"].string ?? ""
        let eventidJ: Int64 = Int64(docDict["eventid"].string!)!
        
        do {
            _ = try DocDataHelper.insert(
                Doc(
                    docid: docidJ,
                    time_start: time_startJ,
                    time_end: time_endJ,
                    title: titleJ,
                    abstract: abstractJ,
                    link: linkJ,
                    eventid: eventidJ
                )
            )
            
        }catch _{
            print("insertion failed doc")}
    }
    
    func setDataAuthor(authorDict: JSON, docidJ: Int64, lastnameJ: String, firstnameJ: String) {
        
        let speakerJ: String = authorDict["speaker"].string!
        
        // located
        
        do {
            let _ = try LocatedDataHelper.insert(
                Located(
                    lastname: lastnameJ,
                    firstname: firstnameJ,
                    docid: docidJ,
                    speaker: speakerJ
                )
            )
            
        }catch _{
            print("insertion failed located")}
        
        
        // ajout auteur
        do {
            let _ = try AuthorDataHelper.insert(
                Author(
                    lastname: lastnameJ,
                    firstname: firstnameJ
                )
            )
        }catch _{
            print("insertion failed Author")}
    }
    
    func setDataAffiliation(affiliationDict: JSON, lastnameJ: String, firstnameJ: String){
        
        // affiliation
        
        let shortnameJ: String? = affiliationDict["shortname"].string ?? ""
        let nameJ: String = affiliationDict["name"].string!
        
        
        do {
            _ = try AffiliationDataHelper.insert(
                Affiliation(
                    shortname: shortnameJ,
                    name: nameJ
                )
            )
        }catch _{
            print("insertion failed affiliation")}
        
        do {
            let _ = try ComeFromDataHelper.insert(
                ComeFrom(
                    lastname: lastnameJ,
                    firstname: firstnameJ,
                    affiliationname: nameJ
                )
            )
            
        }catch _{
            print("insertion failed ComeFrom")}
        
    }
}
