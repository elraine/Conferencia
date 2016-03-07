//
//  ModelLayer.swift
//  DataBase
//
//  Created by Angélique Blondel on 25/01/2016.
//  Copyright © 2016 Angélique Blondel. All rights reserved.
//

import Foundation
import SQLite

typealias Location = (
    place: String?,
    city: String?,
    country: String?,
    lat: String,
    lng: String
)

typealias Conference = (
    confid: Int64,
    link: String?,
    shortname: String?,
    name: String,
    description: String?,
    date_begin: String,
    date_end: String,
    date_creation: String,
    lat: String,
    lng: String
)

typealias Room = (
    roomid: Int64,
    name: String,
    capacity: String?,
    decription: String?
)

typealias Event = (
    eventid: Int64,
    date: String,
    time_start: String,
    time_end: String,
    type: String,
    shorttitle: String?,
    title: String,
    chairman: String?,
    roomid: Int64
)

typealias Doc = (
    docid: Int64,
    time_start: String,
    time_end: String,
    title: String,
    abstract: String?,
    link: String?,
    eventid: Int64
)

typealias Author = (
    lastname: String,
    firstname: String
)

typealias Affiliation = (
    shortname: String?,
    name: String
)

typealias Located = (
    lastname: String,
    firstname: String,
    docid: Int64,
    speaker: String
)

typealias Cluster = (
    clusterid: Int64,
    shorttitle: String,
    description: String?
)

typealias ComeFrom = (
    lastname: String,
    firstname: String,
    affiliationname: String
)