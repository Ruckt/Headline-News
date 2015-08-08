//
//  ArticlesProvider.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/5/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "ArticlesProvider.h"
#import <AFNetworking.h>
#import "NSDictionary+NewsItem.h"

static NSString *articlesEndpoint = @"http://news.google.com/?output=rss";

@interface ArticlesProvider ()

@property(nonatomic, strong) NSMutableDictionary *currentDictionary;   // current section being parsed
@property(nonatomic, strong) NSMutableDictionary *xmlGoogleNews;          // completed parsed xml response
@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSMutableString *outstring;

@end

@implementation ArticlesProvider

+ (ArticlesProvider *)sharedArticleProvider
{
    static ArticlesProvider *provider;
    @synchronized(self) {
        if (!provider)
            provider = [[self alloc] init];
    }
    return provider;
}

- (void)requestArticlesFromFeed {
    
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
        
        for (NSDictionary *item in [self.xmlGoogleNews objectForKey:@"articles"]) {
            
            NSLog(@"Title : %@",[item objectForKey:@"title"]);
            //NSLog(@"DESCRPITON : %@",[item objectForKey:@"description"]);
            NSString *description = [item objectForKey:@"description"];
            NSString *imageHTML = [self scanString:description startTag:@"<img src=" endTag:@">"];
            NSLog(@"IMAGE HTML: %@", imageHTML);
            NSString *summary = [self scanString:description startTag:@"</b></font><br><font size=\"-1\">" endTag:@"</font>"];
            NSLog(@"SUMMARY: %@", summary);
        }
    
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
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




#pragma mark - Regex
-(void)retrieveImageLinkRegexFrom:(NSString *)string {
    
    NSRange range = NSMakeRange(0, string.length);
    NSString *pattern = @"<img src=[^>]+>";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Couldn't create regex with given string and options");
    }
    
    NSTextCheckingResult *result = [regex firstMatchInString:string options:0 range:range];
    NSString *firstMatch = [string substringWithRange:[result rangeAtIndex:0]];
    
    NSLog(@"Image: %@", firstMatch);
}


-(void)retrieveSummaryRegexFrom:(NSString *)string {
    
    NSRange range = NSMakeRange(0, string.length);
    NSString *pattern = @"<br>[^>]+</font>";
                                         
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"Couldn't create regex with given string and options");
    }
    
//    NSTextCheckingResult *result = [regex firstMatchInString:string options:0 range:range];
    NSArray *matches = [regex matchesInString:string options:0 range:range];
    if ([matches count]) {
        NSTextCheckingResult *result = [matches objectAtIndex:0];
        NSString *firstMatch = [string substringWithRange:[result rangeAtIndex:0]];
        
        NSLog(@"SUMMARY : %@", firstMatch);
    } else {
        NSLog(@"Couldn't find a matching regex");
    }
    
    
    
}




- (NSRegularExpression *)regularExpressionWithString:(NSString *)string {
    
    // Create a regular expression
    BOOL isCaseSensitive = NO;
    BOOL isWholeWords = NO;
    
    NSError *error = NULL;
    NSRegularExpressionOptions regexOptions = isCaseSensitive ? 0 : NSRegularExpressionCaseInsensitive;
    
    NSString *placeholder = isWholeWords ? @"\\b%@\\b" : @"%@";
    NSString *pattern = [NSString stringWithFormat:placeholder, string];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:regexOptions error:&error];
    if (error) {
        NSLog(@"Couldn't create regex with given string and options");
    }
    
    return regex;
}




    
- (void)searchAndReplaceText:(NSString *)searchString withText:(NSString *)replacementString inDescription:(NSString *)description
{
        // Text before replacement
        NSString *beforeText = description;
        
        // Create a range for it. We do the replacement on the whole
        // range of the text view, not only a portion of it.
        NSRange range = NSMakeRange(0, beforeText.length);
        
        // Call the convenient method to create a regex for us with the options we have
        NSRegularExpression *regex = [self regularExpressionWithString:searchString];
        
        // Call the NSRegularExpression method to do the replacement for us
        NSString *afterText = [regex stringByReplacingMatchesInString:beforeText options:NSMatchingReportCompletion range:range withTemplate:replacementString];
        
        // Update UI
        description = afterText;
    NSLog(@"Description: %@", afterText);
}



//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer = [AFXMLParserResponseSerializer new];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
//    
//    [manager GET:articlesEndpoint parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//         NSLog(@"Dictionary dictionary: %@", responseObject);
////        NSDictionary *responseDictionary = (NSDictionary *)responseObject;
////        
////        NSArray *articleResponse = [self articlesObjectsFromResponse:responseDictionary];
//        if (completionHandler) {
//            completionHandler(responseObject,nil);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
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






+ (NSArray *)articlesObjectsFromResponse:(NSDictionary *)dictionary {
    NSLog(@"Response Dictionary count: %lu, data: %@", (unsigned long)[dictionary count], dictionary);
    NSMutableArray *articlesArray = [[NSMutableArray alloc] init];
    
//    for (NSDictionary *oneClinic in dictionary) {
//        
//        ClinicDataObject *clinic = [[ClinicDataObject alloc] init];
//        clinic.name = oneClinic[@"name"];
//        clinic.phoneNumber = oneClinic[@"phone_number"];
//        clinic.address1 = oneClinic[@"address_1"];
//        clinic.address2 = oneClinic[@"address_2"];
//        clinic.city = oneClinic[@"city"];
//        clinic.state = oneClinic[@"state"];
//        clinic.zipCode = oneClinic[@"zip_code"];
//        clinic.servicesOffered = oneClinic[@"services_offered"];
//        clinic.appointmentHours = oneClinic[@"appointments_hours"];
//        
//        NSDictionary *locationDictionary = oneClinic[@"location"];
//        clinic.latitude = [locationDictionary[@"latitude"] floatValue];
//        clinic.longitude = [locationDictionary[@"longitude"] floatValue];
//        clinic.humanAddress = locationDictionary[@"human_address"];
//        [clinicsArray addObject:clinic];
//    }
    return articlesArray;
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
    
    NSLog(@"Parser did end document");//: %@", [self.xmlGoogleNews objectForKey:@"category"]);
//    self.weather = @{@"data": self.xmlWeather};
//    self.title = @"XML Retrieved";
//    [self.tableView reloadData];
}


@end

