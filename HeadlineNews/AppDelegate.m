//
//  AppDelegate.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/4/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "AppDelegate.h"
#import "DetailViewController.h"
#import "ArticleListViewController.h"
#import "MBProgressHUD.h"
#import "ArticlesProvider.h"
#import "Article.h"


@interface AppDelegate ()

@property (strong, atomic) UINavigationController *navigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.navigationController = (UINavigationController *)self.window.rootViewController;
    [self fetchDataInView:self.navigationController.view];
    
    //MainViewController *controller = (MainViewController *)navigationController.topViewController;
    //controller.managedObjectContext = self.managedObjectContext;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}

#pragma mark - Networking

-(void)fetchDataInView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = @"We're finding your news";
    
    [[ArticlesProvider sharedArticleProvider] requestArticlesFromFeedWithCompletionHandler:^(NSArray *articles, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        }
        for (Article *article in articles) {
            NSLog(@"AppDelegate article title: %@", article.title);
        }
        
        
        ArticleListViewController *controller = (ArticleListViewController *)self.navigationController.topViewController;
        controller.articles = articles;
        [controller.tableView reloadData];
        
        [MBProgressHUD hideHUDForView:view animated:YES];
    }];
    
}


@end
