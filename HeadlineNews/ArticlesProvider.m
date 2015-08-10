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
       
        [self parseMethodsOfObject:responseObject];
        NSArray *arrayOfArticles = [self createArrayOfArticleObjectsFrom:self.xmlGoogleNews];
        
        if (completionHandler) {
            completionHandler(arrayOfArticles,nil);
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving The Latest News"
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


-(NSArray *)createArrayOfArticleObjectsFrom:(NSDictionary *)dictionary {
 
    [self.dataStore removePreviouslySavedArticles];

    for (NSDictionary *item in [dictionary objectForKey:@"articles"]) {
        
        
        NSArray *titleParts = [item.title componentsSeparatedByString:@" - "];
        
        NSString *title = @"";
        NSString *source = @"";
        
        for (NSInteger i = 0; i< [titleParts count]; i++) {
            if (i < [titleParts count]-1) {
                title = [title stringByAppendingString:[titleParts objectAtIndex:i]];
            } else {
                source = [titleParts  objectAtIndex:i];
            }
        }
        
        NSString *desciptionHtml = item.descriptionHtml;
        
        NSString *pubDate = item.pubDate;
        NSString *articleURL = [self extractArticleURLFromHTML:desciptionHtml];
        NSString *imageURL = [self extractImageURLFromHTML:desciptionHtml];
        NSString *summary = [self scanString:desciptionHtml startTag:@"</b></font><br><font size=\"-1\">" endTag:@"</font>"];
        NSString *date = [self extractDateFrom:pubDate];
        
        Article *article = [Article articleTitle:title source:source date:date summary:summary articleURL:articleURL imageURL:imageURL inManagedObjectContext:self.dataStore.managedObjectContext];
        
        NSLog(@"Description %@", desciptionHtml);
        NSLog(@"ImageURL: %@", imageURL);
        [self.dataStore.articleArray addObject:article];
    }
    
    [self.dataStore saveContext];
    return self.dataStore.articleArray;
}

-(NSString *)extractImageURLFromHTML:(NSString *)html {
    NSString *imgTag =[self scanString:html startTag:@"<img src=" endTag:@">"];
    NSString *imgAddress = [self scanString:imgTag startTag:@"\"" endTag:@"\""];
    
    return [NSString stringWithFormat:@"%@%@", @"http:", imgAddress];
}

//The first href in the description tag includes first the google rss link feed followed by the article link
-(NSString *)extractArticleURLFromHTML:(NSString *)html {
    NSString *href = [self scanString:html startTag:@"<a href=" endTag:@"\">"];
    NSArray *twoLinks = [href componentsSeparatedByString:@"url="];
    return [twoLinks objectAtIndex:1];
}

//Change date into common used format
-(NSString *)extractDateFrom:(NSString *)string {
    NSArray *dateParts = [string componentsSeparatedByString:@" "];
    NSString *weekDay = [dateParts objectAtIndex:0];
    NSString *day = [dateParts objectAtIndex:1];
    NSString *month = [dateParts objectAtIndex:2];
    NSString *year = [dateParts objectAtIndex:3];
    
    NSString *dateString = @"";
    dateString = [dateString stringByAppendingFormat:@"%@ %@ %@, %@",weekDay,month,day,year];

    return dateString;
}


#pragma mark - HTML Parsing methods
//This method always returns the first instance it finds with the included parameters
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

-(void)parseMethodsOfObject:(NSXMLParser *)object {
    
    NSXMLParser *XMLParser = (NSXMLParser *)object;
    [XMLParser setShouldProcessNamespaces:YES];
    
    XMLParser.delegate = self;
    [XMLParser parse];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    self.xmlGoogleNews = [NSMutableDictionary dictionary];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    self.elementName = qName;
    
    if([qName isEqualToString:@"item"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    
//    else if ([qName isEqualToString:@"pubDate"]) {
//        self.currentDictionary = [NSMutableDictionary dictionary];
//    }
    
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

