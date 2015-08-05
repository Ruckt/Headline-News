//
//  DetailViewController.h
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/4/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

