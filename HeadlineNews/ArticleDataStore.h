//
//  ArticleDataStore.h
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/8/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ArticleDataStore : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSMutableArray *articleArray;

+ (ArticleDataStore *)sharedArticleDataStore;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (NSArray *)fetchSavedArticles;
- (void)removePreviouslySavedArticles;

@end
