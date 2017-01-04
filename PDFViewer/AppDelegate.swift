//
//  AppDelegate.swift
//  PDFViewer
//
//  Created by Alexander Bustos on 12/20/16.
//  Copyright © 2016 Alexander Bustos. All rights reserved.
//

import UIKit

let baseUrl = "http://lifebookbuilder.cloudapp.net:3000/api"
let testingToken = "JWT eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1cGRhdGVkIjoiMjAxNi0wNy0yN1QwMDo1OToyMy43ODdaIiwiY3JlYXRlZCI6IjIwMTYtMDctMjdUMDA6NTk6MjMuNzg3WiIsInVzZXJuYW1lIjoiYm9yazEyMyIsInBhc3N3b3JkIjoiJDJhJDEwJEtrbi56T21CblRxbklmU21SbURobi5scU8vWjdmQUROSklzNlZybFNIZnRVV1NFSnNVNVp1IiwiX2lkIjoiNTc5ODA3NmJjMjA5NzFjYzBkMTExNTdlIiwidmVyc2lvbiI6MCwiY2hhcHRlcnMiOnsiQ2hhcHRlcl8xNiI6bnVsbCwiQ2hhcHRlcl8xNSI6bnVsbCwiQ2hhcHRlcl8xNCI6bnVsbCwiQ2hhcHRlcl8xMyI6bnVsbCwiQ2hhcHRlcl8xMiI6bnVsbCwiQ2hhcHRlcl8xMSI6bnVsbCwiQ2hhcHRlcl8xMCI6bnVsbCwiQ2hhcHRlcl8wOSI6bnVsbCwiQ2hhcHRlcl8wOCI6bnVsbCwiQ2hhcHRlcl8wNyI6bnVsbCwiQ2hhcHRlcl8wNiI6bnVsbCwiQ2hhcHRlcl8wNCI6bnVsbCwiQ2hhcHRlcl8wMyI6bnVsbCwiQ2hhcHRlcl8wMiI6bnVsbCwiQ2hhcHRlcl8wMSI6bnVsbH0sImlkIjoiNTc5ODA3NmJjMjA5NzFjYzBkMTExNTdlIn0.uq2FD1bKPHKt6e2jWTlihpJYz_rgb59bW0R4OGyICyc"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

