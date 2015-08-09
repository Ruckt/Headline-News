//
//  NSDictionary+NewsItem.h
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/6/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NewsItem)

- (NSString *)title;
- (NSString *)descriptionHtml;

@end
