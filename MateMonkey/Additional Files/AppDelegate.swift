//
//  AppDelegate.swift
//  MateMonkey
//
//  Created by Peter on 29.01.17.
//  Copyright © 2017 Jurassic Turtle. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        // The homepage's URL is in this format: https://matemonkey.com/map/dealer/wexelwirken-haerten?@=15,48.519689,9.123008
        // We can disregard the last part with the coordinates, but should check for dealer and then get the slug.
        
        var dealerSlug: String?
        
        for item in url.pathComponents {
            if item == "/" || item == "map" || item == "dealer" {
                // These should be part of the url, but they give us no new information
            } else {
                // Whatever is not one of the above parts of the url, should be the slug (short ID) of the dealer
                dealerSlug = item
            }
        }
        
        // FIXME: Since there is virtually no way to test this before the app hits the AppStore, we will not publish this entirely, but limit it to one certain dealer, test it first, then release this feature in a later version.
        if dealerSlug == "wexelwirken-haerten" {
            
            if let slug = dealerSlug {
                let fetcher = MMDealerFetcher()
                fetcher.delegate = self
                
                fetcher.queryForDealerSlug(slug)
                return true
            }
        }
        
        return false
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
extension AppDelegate: MMDealerFetcherDelegate {
    func queryCompleted(sender: MMDealerFetcher) {
        
        if sender.results.isEmpty || sender.results.count > 1 {
            // We have either too many dealers or to little :(
            print("We should have exactly one dealer, but we haven't: \(sender.results)")
        } else {
            DispatchQueue.main.async {
                let dealerToPresent = sender.results.first!
                let dealerDetailVC = DealerDetailViewController()
                dealerDetailVC.dealerToDisplay = dealerToPresent
                
                let navController = UINavigationController()
                navController.pushViewController(dealerDetailVC, animated: false)
                
                UIApplication.topViewController()?.present(navController, animated: false, completion: nil)
            }
        }
        
    }
}
