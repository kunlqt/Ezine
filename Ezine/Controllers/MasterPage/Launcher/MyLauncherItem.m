//
//  MyLauncherItem.m
//  Ezine
//
//  Created by PDG2 on 7/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyLauncherItem.h"
#import "EzineAppDelegate.h"
#import "NSString+HTML.h"

@implementation MyLauncherItem
@synthesize delegate, targetController, title, image, closeButton, controllerStr;
@synthesize isAddButton;
@synthesize siteID;
@synthesize imageLoadingOperation;
@synthesize logoSite,itemLabel;
@synthesize _sourcemoder;
@synthesize _titleSiteTop1,_titleSiteTop2,_titleSiteTop3;
@synthesize _isSiteTop;

-(void)setTitleToSiteTop{
    _titleSiteTop1 = [[UILabel alloc] initWithFrame:CGRectMake(10,self.bounds.size.height-100, self.bounds.size.width, 30)];
    _titleSiteTop1.backgroundColor = [UIColor clearColor];
    [_titleSiteTop1 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
    _titleSiteTop1.textColor = [UIColor whiteColor];
    _titleSiteTop1.textAlignment = UITextAlignmentLeft;
    _titleSiteTop1.lineBreakMode = UILineBreakModeTailTruncation;
    _titleSiteTop1.text = @"";
    _titleSiteTop1.numberOfLines = 2;
    
    _titleSiteTop2 = [[UILabel alloc] initWithFrame:CGRectMake(10,self.bounds.size.height-70, self.bounds.size.width, 30)];
    _titleSiteTop2.backgroundColor = [UIColor clearColor];
    [_titleSiteTop2 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
    _titleSiteTop2.textColor = [UIColor whiteColor];
    _titleSiteTop2.textAlignment = UITextAlignmentLeft;
    _titleSiteTop2.lineBreakMode = UILineBreakModeTailTruncation;
    _titleSiteTop2.text = @"";
    _titleSiteTop2.numberOfLines = 2;
    
    _titleSiteTop3 = [[UILabel alloc] initWithFrame:CGRectMake(10,self.bounds.size.height-40, self.bounds.size.width, 30)];
    _titleSiteTop3.backgroundColor = [UIColor clearColor];
    [_titleSiteTop3 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
    _titleSiteTop3.textColor = [UIColor whiteColor];
    _titleSiteTop3.textAlignment = UITextAlignmentLeft;
    _titleSiteTop3.lineBreakMode = UILineBreakModeTailTruncation;
    _titleSiteTop3.text =@"";
    _titleSiteTop3.numberOfLines = 2;
    
    
}
///----------
-(id)initWithTitle:(NSString *)_title image:(NSString *)_image target:(NSString *)_controllerStr deletable:(BOOL)_deletable
{
	if((self = [super init]))
	{
		dragging = NO;
		deletable = _deletable;
		
		title = _title;
		image = _image;
		controllerStr = _controllerStr;
		closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		closeButton.hidden = YES;
        inforButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
//        self.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1].CGColor;
//        self.layer.borderWidth = 2.0f;
         
        
	}
	return self;
}

-(id)initWithSourceModel:(SourceModel *)model{
    if((self = [super init]))
	{
        self._sourcemoder=[model retain];
		dragging = NO;
        deletable = !model.isAddButton;
        inforable = !model.isAddButton;
        isAddButton = model.isAddButton;
        
		title = model.title;
		image = model.image;
        siteID=model.sourceId;
        _ArticleIdLatest=0;
        NSLog(@"layoutItem : %@",self._sourcemoder.image);
        
		closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
		closeButton.hidden = YES;
        inforButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _spinner.autoresizingMask =UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin
        | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,self.bounds.size.height-30, self.bounds.size.width, 30)];
        itemLabel.backgroundColor = [UIColor clearColor];
        itemLabel.font = [UIFont fontWithName:@"UVNHongHaHepBold" size:17+XAppDelegate.appFontSize];
        itemLabel.textColor = [UIColor whiteColor];
        itemLabel.textAlignment = UITextAlignmentLeft;
        itemLabel.lineBreakMode = UILineBreakModeTailTruncation;
        itemLabel.text = [title uppercaseString];
        itemLabel.numberOfLines = 2;
        [self addSubview:itemLabel];
        [self setTitleToSiteTop];
//        self.layer.borderColor = [UIColor colorWithRed:196.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1].CGColor;
//        self.layer.borderWidth = 2.0f;
	}
    return self;
}

#pragma mark---ActivityIndicator

/*
 * This method shows the activity indicator and
 * deactivates the table to avoid user input.
 */
- (void)showActivityIndicator {
    if (![_spinner isAnimating]) {
        [_spinner startAnimating];
    }
}

/*
 * This method hides the activity indicator
 * and enables user interaction once more.
 */
- (void)hideActivityIndicator {
    if ([_spinner isAnimating]) {
        [_spinner stopAnimating];
    }
    
}
#pragma mark--------
-(void)reloadViewData:(SourceModel *)model{
    title = model.title;
    image = model.image;
    siteID=model.sourceId;
}

-(void)setFrame:(CGRect)frame
{
	[super setFrame:frame];
}

-(void)layoutItem
{
    EzineAppDelegate *appdelegate=(EzineAppDelegate*)[[UIApplication sharedApplication]delegate];
	if(!image)
		return;
	[self showActivityIndicator];
	for(id subview in [self subviews])
		[subview removeFromSuperview];
    
    
    logoSite=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height)];
    logoSite.userInteractionEnabled=YES;
    [logoSite setBackgroundColor:[UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1]];
    self.logoSite.layer.borderColor= [UIColor colorWithRed:196.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1].CGColor;
    self.logoSite.layer.borderWidth =2.0f;

    //[logoSite setImage:[UIImage imageNamed:@"Ezine-loading-V1.png"]];
    if (isAddButton) {
        [logoSite setImage:[UIImage imageNamed:@"btn_addSite.png"]];
        [self hideActivityIndicator];
    }else{
        if ([image isEqualToString:@"addSite"]) {
            NSLog(@"update to latest");
            [self updateLatest];
        }else{
            if ((NSNull*)image ==[NSNull null]) {
                image =@"";
                [self hideActivityIndicator];
                
            }else{
                self.imageLoadingOperation = [appdelegate.serviceEngine imageAtURL:[NSURL URLWithString:self.image]
                                                                      onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                                          if([self.image isEqualToString:[url absoluteString]]) {
                                                                              
                                                                              if (isInCache) {
                                                                                  logoSite.image = fetchedImage;
                                                                                  [self hideActivityIndicator];
                                                                              } else {
                                                                                  logoSite.image = fetchedImage;
                                                                                  logoSite.alpha = 1;
                                                                                  [self hideActivityIndicator];
                                                                              }
                                                                          }
                                                                          
                                                                      }];
               // [self hideActivityIndicator];

            }
                       
        }
        
    }
    
    [self addSubview:logoSite];
    
	if(deletable)
	{
		closeButton.frame = CGRectMake(-10,-10, 30, 30);
		[closeButton setImage:[UIImage imageNamed:@"close_x"] forState:UIControlStateNormal];
		closeButton.backgroundColor = [UIColor clearColor];
        closeButton.showsTouchWhenHighlighted=YES;
		[closeButton addTarget:self action:@selector(closeItem:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:closeButton];
	}
	
	if (self._sourcemoder.isTopSource) {
        _isSiteTop=YES;
        
        [_titleSiteTop1 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
        [_titleSiteTop2 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
        [_titleSiteTop3 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
        
        
        itemLabel.shadowColor = [UIColor blackColor];
        itemLabel.shadowOffset = CGSizeMake(0, 1);
        _titleSiteTop1.shadowColor = [UIColor blackColor];
        _titleSiteTop1.shadowOffset = CGSizeMake(0, 1);
        _titleSiteTop2.shadowColor = [UIColor blackColor];
        _titleSiteTop2.shadowOffset = CGSizeMake(0, 1);
        _titleSiteTop3.shadowColor = [UIColor blackColor];
        _titleSiteTop3.shadowOffset = CGSizeMake(0, 1);
        
        
        _titleSiteTop1.text=[[self._sourcemoder.articleList objectAtIndex:0] objectForKey:@"Title"];
        _titleSiteTop2.text=[[self._sourcemoder.articleList objectAtIndex:1] objectForKey:@"Title"];
        _titleSiteTop3.text=[[self._sourcemoder.articleList objectAtIndex:2] objectForKey:@"Title"];
        itemLabel.text =@"TRANG TIN NỔI BẬT";
        
        [_titleSiteTop1 sizeToFit];
        _titleSiteTop1.numberOfLines=0;
        [_titleSiteTop2 sizeToFit];
        _titleSiteTop2.numberOfLines=0;
        [_titleSiteTop3 sizeToFit];
        _titleSiteTop3.numberOfLines=0;
        [itemLabel sizeToFit];
        itemLabel.numberOfLines=0;
        
        [_titleSiteTop3 setFrame:CGRectMake(10,self.bounds.size.height-_titleSiteTop3.frame.size.height-15, self.bounds.size.width-30, _titleSiteTop3.frame.size.height)];
        
        [_titleSiteTop2 setFrame:CGRectMake(10,_titleSiteTop3.frame.origin.y-_titleSiteTop2.frame.size.height, self.bounds.size.width-30, _titleSiteTop2.frame.size.height)];
        [_titleSiteTop1 setFrame:CGRectMake(10,_titleSiteTop2.frame.origin.y-_titleSiteTop1.frame.size.height, self.bounds.size.width-30, _titleSiteTop1.frame.size.height)];
        
        [itemLabel setFrame:CGRectMake(10,_titleSiteTop1.frame.origin.y-itemLabel.frame.size.height, self.bounds.size.width, itemLabel.frame.size.height)];

        
        
        [self addSubview:itemLabel];
        [self addSubview:_titleSiteTop1];
        [self addSubview:_titleSiteTop2];
        [self addSubview:_titleSiteTop3];
        
    }else{
        [itemLabel setFrame:CGRectMake(10,self.bounds.size.height-30, self.bounds.size.width, 30)];
        itemLabel.shadowColor = [UIColor blackColor];
        itemLabel.shadowOffset = CGSizeMake(0, 1);
        
        itemLabel.text = [title uppercaseString];
        itemLabel.numberOfLines = 2;
        [self addSubview:itemLabel];
        
    }
    
    if (inforable) {
        inforButton.frame = CGRectMake(self.bounds.size.width-31,5,26,26);
        [inforButton setImage:[UIImage imageNamed:@"btn_detail_masterpage_n"] forState:UIControlStateNormal];
        inforButton.backgroundColor = [UIColor clearColor];
        inforButton.showsTouchWhenHighlighted=YES;
        [inforButton addTarget:self action:@selector(inforItem:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:inforButton];
        
        //add spinner
        _spinner.frame =CGRectMake(self.bounds.size.width-31,self.bounds.size.height-30,26,26);
        [self addSubview:_spinner];
    }
}

-(void)inforItem:(id)sender{
    [[self delegate] didInforClick:self];
}

-(void)closeItem:(id)sender{
    if (_isSiteTop) {
        return;
    }
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 self.alpha = 0;
						 self.transform = CGAffineTransformMakeScale(0.00001, 0.00001);
					 }
					 completion:nil];
	
	[[self delegate] didDeleteItem:self];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesBegan:touches withEvent:event];
	[[self nextResponder] touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesMoved:touches withEvent:event];
	[[self nextResponder] touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

-(void)setDragging:(BOOL)flag{
	if(dragging == flag)
		return;
	
	dragging = flag;
	[self.superview bringSubviewToFront:self];
	[UIView animateWithDuration:0.1
						  delay:0
						options:UIViewAnimationOptionCurveEaseIn
					 animations:^{
						 if(dragging) {
							 self.alpha = 0.7;
						 }
						 else {
							 self.transform = CGAffineTransformIdentity;
							 self.alpha = 1;
						 }
					 }
					 completion:nil];
}

-(BOOL)dragging{
	return dragging;
}

-(BOOL)deletable{
	return deletable;
}


- (void)dealloc {
	[closeButton release];
	[super dealloc];
}
#pragma mark---resetFrameItem
-(void)resetFrameItem{
    [logoSite setFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.height)];
    self.logoSite.layer.borderColor= [UIColor colorWithRed:196.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1].CGColor;
    self.logoSite.layer.borderWidth =2.0f;

    if (_isSiteTop) {
        [_titleSiteTop3 setFrame:CGRectMake(10,self.bounds.size.height-_titleSiteTop3.frame.size.height-15, self.bounds.size.width-30, _titleSiteTop3.frame.size.height)];
        
        [_titleSiteTop2 setFrame:CGRectMake(10,_titleSiteTop3.frame.origin.y-_titleSiteTop2.frame.size.height, self.bounds.size.width-30, _titleSiteTop2.frame.size.height)];
        [_titleSiteTop1 setFrame:CGRectMake(10,_titleSiteTop2.frame.origin.y-_titleSiteTop1.frame.size.height, self.bounds.size.width-30, _titleSiteTop1.frame.size.height)];
        
        [itemLabel setFrame:CGRectMake(10,_titleSiteTop1.frame.origin.y-itemLabel.frame.size.height, self.bounds.size.width, itemLabel.frame.size.height)];
        
    }else{
        [itemLabel setFrame:CGRectMake(10,self.bounds.size.height-30, self.bounds.size.width, 30)];
    }
    inforButton.frame = CGRectMake(self.bounds.size.width-31,5,26,26);
    
}
#pragma mark----- reload font size

-(void) reloadFontSize{
    [_titleSiteTop1 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
    [_titleSiteTop2 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
    [_titleSiteTop3 setFont:[UIFont fontWithName:@"UVNHongHaHepBold" size:11+XAppDelegate.appFontSize]];
    itemLabel.font = [UIFont fontWithName:@"UVNHongHaHepBold" size:17+XAppDelegate.appFontSize];
    [self resetFrameItem];
}

#pragma mark--- update latest article
-(void)updateLatest{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy HH:mm:ss"];
    NSDate *now = [[NSDate alloc] init];
    
    NSString *dateString = [dateFormat stringFromDate:now];
    
    NSLog(@"datestring=== %@ ",dateString);
    
    [XAppDelegate.serviceEngine getListArticleInsite:siteID FromTime:dateString numberOffPage:1 onCompletion:^(NSDictionary* data) {
        
       // NSLog(@"latest article===%@",data);
        NSMutableArray *dataUpdate=[data objectForKey:@"ListPage"];
        if (dataUpdate&&dataUpdate.count>0) {
            NSDictionary *dataArticle1=[dataUpdate objectAtIndex:0];
            NSMutableArray *dataArticle2=[dataArticle1 objectForKey:@"ListArticle"];
            NSDictionary *dataArticle=[dataArticle2 objectAtIndex:0];
            int aricleID=[[dataArticle objectForKey:@"ArticleID"] integerValue];
            if (aricleID==_ArticleIdLatest) {
                return ;
            }
            _ArticleIdLatest=aricleID;
            NSDictionary *dataArticle3=[dataArticle objectForKey:@"ArticleLandscape"];
            NSString *urlImage=[dataArticle3 objectForKey:@"HeadImageUrl"];
            NSLog(@"latest article  %@   %d",dataArticle,_ArticleIdLatest);

            if ((NSNull *)urlImage==[NSNull null]) {
                urlImage=@"";
                image=urlImage;
            }else{

                self.image=urlImage;
                self.imageLoadingOperation = [XAppDelegate.serviceEngine imageAtURL:[NSURL URLWithString:self.image]
                                                                      onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
                                                                          if([self.image isEqualToString:[url absoluteString]]) {
                                                                              
                                                                              if (isInCache) {
                                                                                  logoSite.image = fetchedImage;
                                                                                  [self hideActivityIndicator];
                                                                              } else {
                                                                                  logoSite.image = fetchedImage;
                                                                                  logoSite.alpha = 1;
                                                                                  [self hideActivityIndicator];
                                                                              }
                                                                          }
                                                                          
                                                                      }];

            }
     }
     
     } onError:^(NSError* error) {
         
     }];
    
}
#pragma mark========Show activity========Reload
-(void)reloadImage{
    
    [self showActivityIndicator];
}

-(void)checkReload{
    //NSLog(@"%@",self._sourcemoder);
    NSLog(@"check reload");
    [self hideActivityIndicator];

}
@end
