//
//  PackOpenViewController.h
//  boostertutor
//
//  Created by Al Gilardi on 11/19/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@class MBProgressHUD;

@interface PackOpenViewController : UIViewController <UIScrollViewDelegate> {
    MBProgressHUD *HUD;
}

// View Items
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSString *packName;

// placeholder card
@property Card *placeholder;

// For loading the pack with the correct data
@property NSMutableArray *cards;
@property NSArray *cardImages;
@property NSMutableArray *cardViews;

// "temp" variables used when parsin the JSON
@property NSArray *jsonArr;
@property NSDictionary *jsonDictCard;

- (void)initPack: (NSString*)packName;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;

@end
