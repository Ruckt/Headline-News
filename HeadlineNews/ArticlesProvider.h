//
//  ArticlesProvider.h
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/5/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticlesProvider : NSObject <NSXMLParserDelegate>

+ (ArticlesProvider *)sharedArticleProvider;

- (void)requestArticlesFromFeedWithCompletionHandler: (void(^)(NSArray* articles, NSError *error))completionHandler;

@end


