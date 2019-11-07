//
//  AppDelegate.swift
//  BaybeeBundles
//
//  Created by Chris Dias on 2019-10-14.
//  Copyright © 2019 Chris Dias. All rights reserved.
//

import UIKit
import CoreData


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    @available(iOS 13.0, *)
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //Save the data before the app terminates
    func applicationWillTerminate(_ application: UIApplication) {
        self.save()
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CartItems")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var dbHelper: DBHelper = {
       let dbHelper = DBHelper()
        dbHelper.persistentContainer = self.persistentContainer
        return dbHelper
    }()

    // MARK: - Core Data Saving support
    func save() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            // attempt to save
            do {
                try context.save()
            } catch let error {
                fatalError("Unresolved error when saving - \(error.localizedDescription)")
            }
        }
    }

}

