//
//  Article+Methods.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/9/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "Article+Methods.h"

@implementation Article (Methods)

+(Article *)articleTitle:(NSString *)title
                    date:(NSDate *)date
                 summary:(NSString *)summary
              articleURL:(NSString *)articleURL
                imageURL:(NSString *)imageURL
                   image:(id)image
  inManagedObjectContext:(NSManagedObjectContext *)context {
    
    Article *article = nil;
    article =[NSEntityDescription insertNewObjectForEntityForName:@"Article" inManagedObjectContext:context];
    article.title = title;
    article.date = date;
    article.summary = summary;
    article.articleURL = articleURL;
    article.imageURL = imageURL;
    article.image = image;
    
    
    return article;
}

@end
