//
//  ConstantsForTests.m
//  HeadlineNews
//
//  Created by Edan Lichtenstein on 8/10/15.
//  Copyright (c) 2015 Ruckt. All rights reserved.
//

#import "ConstantsForTests.h"


@implementation ConstantsForTests


-(NSString *)stringWithImageHTML {
    
    return @"<a href=\"http://news.google.com/news/url?sa=t&amp;fd=R&amp;ct2=us&amp;usg=AFQjCNG-G7krDrSk5H9us8YLbyMw2ocS4w&amp;clid=c3a7d30bb8a4878e06b80cf16b898331&amp;cid=52778921492287&amp;ei=NxzJVYy1C5PD3AGUnoGgDA&amp;url=http://www.reuters.com/article/2015/08/10/us-ferguson-anniversary-idUSKCN0QE0HI20150810\"><img src=\"//t3.gstatic.com/images?q=tbn:ANd9GcRvWK5V3lhFyLw7K1gMrRMcqmbFkPYN1T1xrGZPvgW19568vtF1MRJT4DxRwgoMZMHJOVr6Yeg6\" border=1 width=80 height=80><br><font size=-2>Reuters</font></a></font></td><td valign=top class=j><font style=font-size:85%;font-family:arial,sans-serif";
}

-(NSString *)imageHTML {
    
    return @"http://t3.gstatic.com/images?q=tbn:ANd9GcRvWK5V3lhFyLw7K1gMrRMcqmbFkPYN1T1xrGZPvgW19568vtF1MRJT4DxRwgoMZMHJOVr6Yeg6";
}


-(NSString *)articleHTML {
    return @"http://www.nytimes.com/2015/08/11/technology/google-alphabet-restructuring.html";
}


-(NSString *)stringWithArticleHTML {

    return @"<table border=\"0\" cellpadding=\"2\" cellspacing=\"7\" style=\"vertical-align:top;\"><tr><td width=\"80\" align=\"center\" valign=\"top\"><font style=\"font-size:85%;font-family:arial,sans-serif\"><a href=\"http://news.google.com/news/url?sa=t&amp;fd=R&amp;ct2=us&amp;usg=AFQjCNE2uq5Cf-MLpWXWbp-mSpcYDDU5EA&amp;clid=c3a7d30bb8a4878e06b80cf16b898331&amp;cid=52778922568232&amp;ei=Rm_JVYiSB8L83QGtxK-oBg&amp;url=http://www.nytimes.com/2015/08/11/technology/google-alphabet-restructuring.html\"><img src=\"//t1.gstatic.com/images?q=tbn:ANd9GcTmbddziw-9jN0nyS08A1mNFf1ZpqiGefYf5GsZcICgfie6jOBP9ydtQsQ5no5HNk25bNF0se8\" alt=\"\" border=\"1\" width=\"80\" height=\"80\"><br><font size=\"-2\">New York Times</font></a></font></td><td valign=\"top\" class=\"j\"><font style=\"font-size:85%;font-family:arial,sans-serif\"><br><div style=\"padding-top:0.8em;\"><img alt=\"\" height=\"1\" width=\"1\"></div><div class=\"lh\"><a href=\"http://news.google.com/news/url?sa=t&amp;fd=R&amp;ct2=us&amp;usg=AFQjCNE2uq5Cf-MLpWXWbp-mSpcYDDU5EA&amp;clid=c3a7d30bb8a4878e06b80cf16b898331&amp;cid=52778922568232&amp;ei=Rm_JVYiSB8L83QGtxK-oBg&amp;url=http://www.nytimes.com/2015/08/11/technology/google-alphabet-restructuring.html\"><b>Google to Reorganize in Move to Keep Its Lead as an Innovator</b></a><br><font size=\"-1\"><b><font color=\"#6f6f6f\">New York Times</font></b></font><br><font size=\"-1\">SAN FRANCISCO — Google was founded as a company that did Internet search. Over time, it has broadened into areas as varied as drones, pharmaceuticals and venture capital, none of which make much money, and some of which have spooked investors.</font><br><font size=\"-1\">";
}



@end
