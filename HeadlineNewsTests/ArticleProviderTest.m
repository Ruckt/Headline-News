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

@interface ArticlesProvider (Testing)

-(NSString *)extractImageURLFromHTML:(NSString *)html;

@end

@interface ArticleProviderTest : XCTestCase

@property (strong ,nonatomic) ConstantsForTests *constants;
@property (strong, nonatomic) ArticlesProvider *articleProvider;

@end

@implementation ArticleProviderTest

- (void)setUp {
    [super setUp];
    self.constants = [[ConstantsForTests alloc] init];
    self.articleProvider = [[ArticlesProvider alloc] init];
    

}


- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testExtratImageLink {
    NSString *knownImageLink = self.constants.imageHTML;
    NSString *imageLinkVerfiy = [self.articleProvider extractImageURLFromHTML:self.constants.stringWithImageHTML];
    
    NSLog(@"Knowna: %@", knownImageLink);
    NSLog(@"Verify: %@", imageLinkVerfiy);
    
    XCTAssertEqualObjects(knownImageLink, imageLinkVerfiy, @"The image html extraction method failed");
                           
}
                          
                          
@end
