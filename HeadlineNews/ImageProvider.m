//
//  ImageProvider.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/9/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "ImageProvider.h"
#import <AFNetworking.h>


@implementation ImageProvider

+ (void)downloadImageWithURL:(NSString *)urlString withCompletionHandler:(void (^)(UIImage *image, NSError *error))completionHandler {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    requestOperation.responseSerializer = [AFImageResponseSerializer serializer];
    
    
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
 
        UIImage *image = responseObject;
        
        if (completionHandler) {
            completionHandler(image, nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Image error: %@", error);
        
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
    [requestOperation start];
}

@end
