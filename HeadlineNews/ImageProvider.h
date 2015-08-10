//
//  ImageProvider.h
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/9/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageProvider : NSObject

+ (void)downloadImageWithURL:(NSString *)urlString withCompletionHandler:(void (^)(UIImage *image, NSError *error))completionHandler;

@end
