//
//  localStorageHelper.swift
//  Conferencia
//
//  Created by Alexis Chan on 03/04/2016.
//
//

import UIKit




class localStorageHelper{
    let d :[Int] = []
    
    func start(){
        NSUserDefaults.standardUserDefaults().setObject(d, forKey: "myPlanning")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
//    func saveFav(d:Array<Int>){
//        _ = NSUserDefaults.standardUserDefaults().setObject(d, forKey: "myPlanning")
//        NSUserDefaults.standardUserDefaults().synchronize()
//    }
    
    
    func addItem(eventID:Int){
        if(dict.indexOf(eventID) == nil){
            dict.append(eventID)
        }
        print("did append")
        print(dict)
    }
    
    func removeItem(eventID:Int) throws{
        let t = dict.indexOf(eventID)
        if(t < dict.count){
            dict.removeAtIndex(t!)
        }else{
            print("cant remove")
        }
    }
    
    func dCount() ->Int{
        return dict.count
       
    }
    
    func getDict()->Array<Int>{
        return dict
    }
    
    func deleteDict(){
        dict = []
    }
    
}