//
//  Article+Methods.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/9/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "Article+Methods.h"

@implementation Article (Methods)

+ (Article *) articleTitle:(NSString *)title
                    source:(NSString *)source
                      date:(NSString *)date
                   summary:(NSString *)summary
                articleURL:(NSString *)articleURL
                  imageURL:(NSString *)imageURL
    inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Article *article = nil;
    article =[NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
    article.title = title;
    article.date = date;
    article.summary = summary;
    article.articleURL = articleURL;
    article.imageURL = imageURL;
    article.source = source;
    
    
    return article;
}

@end
