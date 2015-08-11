//
//  ArticleProviderTest.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/10/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ArticlesProvider.h"
#import "ConstantsForTests.h"
//#import "ArticleDataStore.h"


@interface ArticlesProvider (Testing)

-(NSString *)extractImageURLFromHTML:(NSString *)html;
-(NSString *)extractArticleURLFromHTML:(NSString *)html;

@end

@interface ArticleProviderTest : XCTestCase

@property (strong ,nonatomic) ConstantsForTests *constants;
@property (strong, nonatomic) ArticlesProvider *articleProvider;
//@property (strong, nonatomic) ArticleDataStore *sharedDatastore;

@end

@implementation ArticleProviderTest

- (void)setUp {
    [super setUp];
    self.constants = [[ConstantsForTests alloc] init];
    self.articleProvider = [[ArticlesProvider alloc] init];
//    self.sharedDatastore = [ArticleDataStore sharedArticleDataStore];
}


- (void)tearDown {
    [super tearDown];
}


- (void)testExtratImageLink {
    NSString *knownImageLink = self.constants.imageHTML;
    NSString *imageLinkVerfiy = [self.articleProvider extractImageURLFromHTML:self.constants.stringWithImageHTML];
    
    XCTAssertEqualObjects(knownImageLink, imageLinkVerfiy, @"The image html extraction method failed");
                           
}

- (void)testextractArticleURLFromHTML {
    NSString *knownArticleLink = self.constants.articleHTML;
    NSString *articleLinkVerfiy = [self.articleProvider extractArticleURLFromHTML:self.constants.stringWithArticleHTML];
    
    XCTAssertEqualObjects(knownArticleLink, articleLinkVerfiy, @"The article html extraction method failed");
}


- (void)testrequestArticlesFromFeedWithCompletionHandler {

    XCTestExpectation *expectation = [self expectationWithDescription:@"Request articles from Google news feed"];
    
    [self.articleProvider requestArticlesFromFeedWithCompletionHandler:^(NSArray *articles, NSError *error) {
    
        XCTAssertNil(error, @"requestArticlesFromFeedWithCompletionHandler error %@", error);
        
        
        XCTAssert(articles, @"Data nil");
        
        NSLog(@"The number of articles returned in the request: %lu", (unsigned long)[articles count]);
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

                          
                          
@end
