//
//  MainViewController.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/4/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "ArticleListViewController.h"
#import "DetailViewController.h"
#import "ArticleDataStore.h"
#import "Article.h"
#import "ArticleListTableViewCell.h"
#import "ImageProvider.h"

@interface ArticleListViewController ()

@property (strong, nonatomic) ArticleDataStore *dataStore;

@end

@implementation ArticleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataStore = [ArticleDataStore sharedArticleDataStore];
    self.articles = [self.dataStore fetchSavedArticles];
    self.navigationItem.title = @"Headlines";
    NSLog(@"Number of articles: %lu", (unsigned long)[self.articles count]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Article *article = [self.articles objectAtIndex:indexPath.row];
        [[segue destinationViewController] setArticle:article];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ArticleListTableViewCell *cell = (ArticleListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    [self configureCell:cell atIndexPath:indexPath];

    return cell;
}


- (void)configureCell:(ArticleListTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Article *article = [self.articles objectAtIndex:indexPath.row];
    cell.titleLabel.text = article.title;
    cell.sourceLabel.text = article.source;
    cell.summaryLabel.text = article.summary;
    
    if (article.image) {
        cell.cellImageView.image =  article.image;
    } else {
        cell.cellImageView.image = [UIImage imageNamed:@"ImagePlaceholder"];
        [ImageProvider downloadImageWithURL:article.imageURL withCompletionHandler:^(UIImage *image, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                article.image = image;
                cell.cellImageView.image = image;
            }
        
        }];
    }
    
}




@end
