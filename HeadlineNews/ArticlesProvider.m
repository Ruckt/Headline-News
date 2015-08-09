//
//  ArticlesProvider.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/5/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "ArticlesProvider.h"
#import "ArticleDataStore.h"
#import "Article+Methods.h"
#import <AFNetworking.h>
#import "NSDictionary+NewsItem.h"

static NSString *articlesEndpoint = @"http://news.google.com/?output=rss";

@interface ArticlesProvider ()

@property(nonatomic, strong) ArticleDataStore *dataStore;
@property(nonatomic, strong) NSMutableArray *articlesArray;

@property(nonatomic, strong) NSMutableDictionary *currentDictionary;   // current section being parsed
@property(nonatomic, strong) NSMutableDictionary *xmlGoogleNews;          // completed parsed xml response
@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSMutableString *outstring;

@end

@implementation ArticlesProvider

+ (ArticlesProvider *)sharedArticleProvider {
    
    static ArticlesProvider *provider;
    @synchronized(self) {
        if (!provider)
            provider = [[self alloc] init];
    }
    return provider;
}

- (id)init {
    _dataStore = [ArticleDataStore sharedArticleDataStore];
    return self;
}

- (void)requestArticlesFromFeedWithCompletionHandler: (void(^)(NSArray* articles, NSError *error))completionHandler{
    
    NSURL *url = [NSURL URLWithString:articlesEndpoint];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
        [XMLParser setShouldProcessNamespaces:YES];
        
         XMLParser.delegate = self;
         [XMLParser parse];
        
        self.articlesArray = [[NSMutableArray alloc] init];
        
        for (NSDictionary *item in [self.xmlGoogleNews objectForKey:@"articles"]) {

            NSString *title = item.title;
            NSString *desciptionHtml = item.descriptionHtml;
            NSString *articleURL = @"BIG LONG URL";
            NSString *imageHTML = [self scanString:desciptionHtml startTag:@"<img src=" endTag:@">"];
            NSString *summary = [self scanString:desciptionHtml startTag:@"</b></font><br><font size=\"-1\">" endTag:@"</font>"];
            
            
            NSDate *date = [NSDate date];
            UIImage *image = [[UIImage alloc] init];

            Article *article = [Article articleTitle:title date:date summary:summary articleURL:articleURL imageURL:imageHTML image:image inManagedObjectContext:self.dataStore.managedObjectContext];
            
            [self.articlesArray addObject:article];
            
            NSLog(@"IMAGE HTML: %@", imageHTML);
            NSLog(@"Title : %@", article.title);
            NSLog(@"SUMMARY: %@", summary);
        }
        
        NSLog(@"ATTEND TO ISSUES ABOVE: date, imageHTML, image, articleHTML");
        
        if (completionHandler) {
            completionHandler(self.articlesArray,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        if (completionHandler) {
            completionHandler(nil, error);
        }
    }];
    
    [operation start];
}

#pragma mark - HTML Parsing methods
- (NSString *)scanString:(NSString *)string startTag:(NSString *)startTag endTag:(NSString *)endTag {
    
    NSString* scanString = @"";
    
    if (string.length > 0) {
        
        NSScanner* scanner = [[NSScanner alloc] initWithString:string];
        
        @try {
            [scanner scanUpToString:startTag intoString:nil];
            scanner.scanLocation += [startTag length];
            [scanner scanUpToString:endTag intoString:&scanString];
        }
        @catch (NSException *exception) {
            return nil;
        }
        @finally {
            return scanString;
        }
        
    }
    return scanString;
}


#pragma mark - XML Parser

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.xmlGoogleNews = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    self.elementName = qName;
    
    if([qName isEqualToString:@"item"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    
    self.outstring = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    if (!self.elementName) {
        return;
    }
    
    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {

    if ([qName isEqualToString:@"item"]) {

        NSMutableArray *array = self.xmlGoogleNews[@"articles"] ?: [NSMutableArray array];
        [array addObject:self.currentDictionary];
        self.xmlGoogleNews[@"articles"] = array;
        self.currentDictionary = nil;
    }
    else if (qName) {
        self.currentDictionary[qName] = self.outstring;
    }
    self.elementName = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"Parser did end document");
}


@end

