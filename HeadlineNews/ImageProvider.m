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


//+ (void)requestImageFromURL:(NSString *) urlString WithCompletionHandler: (void(^)(NSArray* articles, NSError *error))completionHandler{
//    
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
//    
//    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
//    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        
//        [self parseMethodsOfObject:responseObject];
//        
//        NSArray *arrayOfArticles = [self createArrayOfArticleObjectsFrom:self.xmlGoogleNews];
//        
//        NSLog(@"ATTEND TO ISSUES ABOVE: date, imageHTML, image, articleHTML");
//        
//        if (completionHandler) {
//            completionHandler(arrayOfArticles,nil);
//        }
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        
//        NSLog(@"Error: %@", error);
//        
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"Ok"
//                                                  otherButtonTitles:nil];
//        [alertView show];
//        
//        if (completionHandler) {
//            completionHandler(nil, error);
//        }
//    }];
//    
//    [operation start];
//}



@end
