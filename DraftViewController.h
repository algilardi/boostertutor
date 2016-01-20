//
//  DraftViewController.h
//  Booster Tutor
//
//  Created by Al Gilardi on 12/14/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@class MBProgressHUD;

@interface DraftViewController : UIViewController <UIScrollViewDelegate> {
    MBProgressHUD *HUD;
}

// Objects similar to PackOpenViewController, just with multiple of each
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView3;

@property (nonatomic, strong) NSString *packName;

@property Card *placeholder;

@property NSMutableArray *cards1;
@property NSMutableArray *cards2;
@property NSMutableArray *cards3;

@property NSArray *cardImages1;
@property NSArray *cardImages2;
@property NSArray *cardImages3;

@property NSMutableArray *cardViews1;
@property NSMutableArray *cardViews2;
@property NSMutableArray *cardViews3;

@property NSArray *jsonArr;
@property NSDictionary *jsonDictCard;

- (void)initPacks: (NSString*)packName;
- (void)loadVisiblePages;
- (void)loadPage:(NSInteger)page;

@end
