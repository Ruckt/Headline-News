//
//  NSDictionary+NewsItem.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/6/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "NSDictionary+NewsItem.h"

@implementation NSDictionary (NewsItem)


- (NSString *)title {
    NSString *string = self[@"title"];
    return string;
}

- (NSString *)descriptionHtml {
    NSString *string = self[@"description"];
    return string;
}


@end
