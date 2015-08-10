//
//  DetailViewController.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/4/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "DetailViewController.h"
#import "MBProgressHUD.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationBar;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)configureView {
    self.navigationBar.title =  self.article.source;
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.article.articleURL]];
    [self.webView loadRequest:request];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
    hud.labelText = @"News is loading";
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma - mark UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
    NSLog(@"Failed to load with error :%@",[error debugDescription]);
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving This Article"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"Ok"
                                              otherButtonTitles:nil];
    [alertView show];
}


@end
