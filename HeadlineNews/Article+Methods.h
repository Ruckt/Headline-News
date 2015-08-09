//
//  Article+Methods.h
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/9/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "Article.h"

@interface Article (Methods)

+ (Article *) articleTitle:(NSString *)title
                      date:(NSDate *)date
                   summary:(NSString *)summary
                articleURL:(NSString *)articleURL
                  imageURL:(NSString *)imageURL
                     image:(id)image
    inManagedObjectContext:(NSManagedObjectContext *)context;
@end
