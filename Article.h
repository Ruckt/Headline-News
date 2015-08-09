//
//  Article.h
//  
//
//  Created by Edan Lichtenstein on 8/9/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Article : NSManagedObject

@property (nonatomic, retain) NSString * articleURL;
@property (nonatomic, retain) NSString * date;
@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSString * imageURL;
@property (nonatomic, retain) NSString * summary;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * source;

@end
