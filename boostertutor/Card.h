//
//  Card.h
//  Booster Tutor
//
//  Created by Al Gilardi on 12/12/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Card object to represent Magic Cards
@interface Card : NSObject

    // Basic properties of a card
    @property int cardID;
    @property NSString *rarity;
    @property NSString *cardName;
    @property UIImage *cardImage;

// init functions
- (id) init;
- (id) initWithCardID: (int)cardID;
- (id) initWithCardID: (int)cardID andRarity: (NSString*)rarity andName: (NSString*)name;

// print function for testing
- (void) printCard;

@end
