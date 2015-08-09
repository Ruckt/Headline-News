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
                    source:(NSString *)source
                      date:(NSString *)date
                   summary:(NSString *)summary
                articleURL:(NSString *)articleURL
                  imageURL:(NSString *)imageURL
    inManagedObjectContext:(NSManagedObjectContext *)context;
@end
