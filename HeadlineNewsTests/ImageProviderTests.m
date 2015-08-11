//
//  ImageProviderTests.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/11/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "ImageProvider.h"


@interface ImageProviderTests : XCTestCase


@end

@implementation ImageProviderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testdownloadImageWithURLWithCompletionHandler {
    
    NSString *imageString = @"https://raw.githubusercontent.com/Ruckt/Headline-News/master/Screenshots/DetailShot.png";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Download an image"];
    
    [ImageProvider downloadImageWithURL:imageString withCompletionHandler:^(UIImage *image, NSError *error) {
        
        XCTAssertNil(error, @"downloadImageWithURLCompletionHandler error %@", error);
        
        XCTAssert(image, @"Data nil");
        
        [expectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];
}

- (void)testImageDownloadWithDefectiveURL {
    
    NSString *imageString = @"https://github.com/Ruckt";
    
    XCTestExpectation *expectation = [self expectationWithDescription:@"Defective image url test"];
    
    [ImageProvider downloadImageWithURL:imageString withCompletionHandler:^(UIImage *image, NSError *error) {
        
        if (error == nil) {
            XCTFail(@"Test designed to fail with defective url");
        } else {
            NSLog(@"Error: %@", error);
            [expectation fulfill];
        }
        
    }];
    
    [self waitForExpectationsWithTimeout:10.0 handler:nil];

}

@end
