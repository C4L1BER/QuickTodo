//
//  AppDelegate.swift
//  QuickTodo
//
//  Created by Chinmay Deshpande on 02/06/19.
//  Copyright © 2019 Chinmay Deshpande. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do {
            
            _ = try Realm()
        }
        catch {
            
            print("Error initializing new Realm: \(error)")
        }
        
        return true
    }
}
