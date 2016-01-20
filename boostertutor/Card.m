//
//  Card.m
//  Booster Tutor
//
//  Created by Al Gilardi on 12/12/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import "Card.h"
#import "AppDelegate.h"

@implementation Card

// Card init functions
- (id) init {
    return [self initWithCardID:74284 andRarity:@"Common" andName:@"Aesthetic Consultation"];
}

- (id) initWithCardID:(int)cardID {
    return [self initWithCardID:cardID andRarity:@"Common" andName:@"Aesthetic Consultation"];
}

- (id) initWithCardID:(int)cardID andRarity:(NSString *)rarity andName:(NSString *)name {
    if (self = [super init]) {
        _cardID = cardID;
        _rarity = rarity;
        _cardName = name;
        NSString *url = [NSString stringWithFormat:
                        @"http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=%i&type=card", cardID];
        _cardImage = [UIImage imageWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString:url]]];
    }
    return self;
}

// Prints info about the card, for testing
- (void) printCard {
    NSLog(@"\nCard Name: %@\nMultiverseID: %i\nRarity: %@", _cardName, _cardID, _rarity);
}

@end
