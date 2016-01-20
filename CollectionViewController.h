//
//  CollectionViewController.h
//  Booster Tutor
//
//  Created by Al Gilardi on 12/14/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSString *packName;

// Used when setting up the tableview
@property NSMutableArray *cardList;
@property NSMutableArray *cardIDList;

// "temp" varibles for parsing the JSON
@property NSArray *jsonArr;
@property NSDictionary *jsonDictCard;

- (void) getCardsForPack: (NSString*)packName;
@end
