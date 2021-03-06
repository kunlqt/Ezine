//
//  LastestCell.m
//  Ezine
//
//  Created by PDG2 on 7/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LastestCell.h"
#import "Utils.h"

@implementation LastestCell

@synthesize titleLabel = titleLabel_;
@synthesize thumbnailImage = thumbnailImage_;
@synthesize loadingImageURLString = loadingImageURLString_;
@synthesize imageLoadingOperation = imageLoadingOperation_;
@synthesize timeArticle;
//=========================================================== 
// + (BOOL)automaticallyNotifiesObserversForKey:
//
//=========================================================== 
+ (BOOL)automaticallyNotifiesObserversForKey: (NSString *)theKey 
{
    BOOL automatic;
    
    if ([theKey isEqualToString:@"thumbnailImage"]) {
        automatic = NO;
    } else {
        automatic = [super automaticallyNotifiesObserversForKey:theKey];
    }
    
    return automatic;
}

-(void) prepareForReuse {
    
    self.thumbnailImage.image = nil;
    [self.imageLoadingOperation cancel];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setData:(NSDictionary *)data {
    self.titleLabel.text = [data objectForKey:@"Title"];
    self.loadingImageURLString =[data objectForKey:@"HeadImageUrl"];
    self.timeArticle.text=[Utils dateStringFromTimestamp:[data objectForKey:@"PublishTime"]];
    self.tag = [[data objectForKey:@"ArticleID"] integerValue];
    if ((NSNull *)self.loadingImageURLString==[NSNull null]) {
        self.loadingImageURLString=@"";
    }
    self.imageLoadingOperation = [XAppDelegate.serviceEngine imageAtURL:[NSURL URLWithString:self.loadingImageURLString]
    onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        if([self.loadingImageURLString isEqualToString:[url absoluteString]]) {
            if (isInCache) {
                self.thumbnailImage.image = fetchedImage;
            }else{
                UIImageView *loadedImageView = [[UIImageView alloc] initWithImage:fetchedImage];
                loadedImageView.frame = self.thumbnailImage.frame;
                loadedImageView.alpha = 0;
                [self.contentView addSubview:loadedImageView];
                [UIView animateWithDuration:0.4 animations:^{
                    loadedImageView.alpha = 1;
                    self.thumbnailImage.alpha = 0;
                }completion:^(BOOL finished){
                    self.thumbnailImage.image = fetchedImage;
                    self.thumbnailImage.alpha = 1;
                    [loadedImageView removeFromSuperview];}];
                }
            }
        }];
}

- (void)dealloc {
    [timeArticle release];
    [super dealloc];
}
@end
