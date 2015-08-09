//
//  ArticleListTableViewCell.h
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/9/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListTableViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UIImageView *cellImageView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *summaryLabel;


//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier picture:(Picture *)picture;
//- (void)configureCellWithPicture:(Picture *)thePicture;


@end
