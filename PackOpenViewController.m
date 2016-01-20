//
//  PackOpenViewController.m
//  boostertutor
//
//  Created by Al Gilardi on 11/19/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import "PackOpenViewController.h"
#import "Card.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>


@interface PackOpenViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *packImage;

@property (assign, nonatomic) SystemSoundID ripSoundID;


@end

@implementation PackOpenViewController



// Next 3 methods all set up the scroll view with the card images
// SCROLLVIEW SETUP
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page > 14) {
        return;
    }
    
    UIView *pageView = [self.cardViews objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.cardImages objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView addSubview:newPageView];
        [self.cardViews replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)loadVisiblePages {
    // Load pages in our range
    for (NSInteger i=0; i<15; i++) {
        [self loadPage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Load the pages that are now on screen
    [self loadVisiblePages];
    
}
// SCROLLVIEW SETUP



- (void) initPack:(NSString*)packName {
    NSString *URLstring;
    
    
    // 15 Card array to represent the pack
    // 0-9 = Common cards
    // 10-12 = Uncommon cards
    // 13 = Rare/Mythic Rare card
    // 14 = Land card
    
    // Sets up the proper json URL based on which pack was selected
    if ([packName isEqualToString:@"Battle for Zendikar"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/BFZ.json"];
        [self.packImage setImage:[UIImage imageNamed:@"BFZpack.png"]];
    }
    else if ([packName isEqualToString:@"Innistrad"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/ISD.json"];
        [self.packImage setImage:[UIImage imageNamed:@"ISDpack.png"]];
    }
    else if ([packName isEqualToString:@"Return to Ravnica"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/RTR.json"];
        [self.packImage setImage:[UIImage imageNamed:@"RTRpack.png"]];
    }
    else if ([packName isEqualToString:@"Magic Origins"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/ORI.json"];
        [self.packImage setImage:[UIImage imageNamed:@"ORIpack.png"]];
    }
    else {
        URLstring = [NSString stringWithFormat:@"http://google.com"];
        [self.packImage setImage:[UIImage imageNamed:@"placeholder.png"]];

    }
    
    // Prepares Json URL for the specific set
    NSURL *jsonURL = [NSURL URLWithString:URLstring];
    NSLog(@"%@", URLstring);
    
    // Plays the pack image animation
    [UIView animateWithDuration:1 delay:2 options:0 animations:^{
        self.packImage.alpha = 0.0f;
    } completion:^(BOOL finished) {
        self.packImage.hidden = YES;
    }];
    
    // Plays the pack opening rip sound
    if (_ripSoundID == 0) {
        NSURL *clickURL = [[NSBundle mainBundle]
                           URLForResource:@"rip"withExtension:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)clickURL, &_ripSoundID);
    }
    AudioServicesPlayAlertSound(_ripSoundID);
    
    // Gets json data
    [AppDelegate downloadDataFromURL:jsonURL withCompletionHandler: ^(NSData * data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                self.jsonArr = [returnedDict objectForKey:@"cards"];
                int randomindex = 0;
                int commonCount = 0;
                int uncommonCount = 10;
                BOOL rareCount = NO;
                BOOL landCount = NO;
                NSLog(@"#Cards: %lu", (unsigned long)[self.jsonArr count]);

                
                // Temporary variables for use in each iteration of the loop
                int tempID = 0;
                NSString *tempName = @"";
                NSString *tempRarity = @"";
                Card *tempCard;
                
                //NSLog(@"TOtal cards: %lu, Random Card: %i", (unsigned long)[self.jsonArr count], randomindex);
                
                // Creates the pack
                // Loop that checks if the total slots have been filled with cards
                while ((commonCount <= 9) || (uncommonCount <= 12) || (!rareCount) || (!landCount)) {
                    
                    // Gets a random card and sets the temporary variables
                    randomindex = arc4random_uniform((u_int32_t)[self.jsonArr count]);
                    self.jsonDictCard = [self.jsonArr objectAtIndex:randomindex];
                    tempRarity = [self.jsonDictCard objectForKey:@"rarity"];
                    tempName = [self.jsonDictCard objectForKey:@"name"];
                    tempID = (int)[[self.jsonDictCard objectForKey:@"multiverseid"] integerValue];
                    
                    // for testing
                    //NSLog(@"\nName: %@\nRarity: %@\nID: %i", tempName, tempRarity, tempID);
                    
                    if ([tempRarity isEqualToString:@"Common"] && (commonCount <= 9)) {
                        NSLog(@"common: %i", commonCount);
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards replaceObjectAtIndex:commonCount withObject:tempCard];
                        commonCount++;
                    }
                    if ([tempRarity isEqualToString:@"Uncommon"] && (uncommonCount <= 12)) {
                        NSLog(@"uncommon: %i", uncommonCount);
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards replaceObjectAtIndex:uncommonCount withObject:tempCard];                        uncommonCount++;
                    }
                    if ( ([tempRarity isEqualToString:@"Rare"] || [tempRarity isEqualToString:@"Mythic Rare"]) && (!rareCount) ) {
                        NSLog(@"rare");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards replaceObjectAtIndex:13 withObject:tempCard];
                        rareCount = YES;
                    }
                    if ([tempRarity isEqualToString:@"Basic Land"] && (!landCount)) {
                        NSLog(@"land");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards replaceObjectAtIndex:14 withObject:tempCard];
                        landCount = YES;
                    }
                }
                NSLog(@"cards added\nPart 1");
                for (int i = 0; i < 15; i++) {
                    [((Card*)[self.cards objectAtIndex:i]) printCard];
                }
            }
        }
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.placeholder = [[Card alloc] initWithCardID:382979 andRarity:@"Common" andName:@"Jace, the Mind Sculptor"];
    
    // Shows MBProgressHUD loader
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.labelText = @"Loading Pack...";
    [HUD show:YES];
    
    // Creates an empty array so cards can be placed properly based on rarity
    self.cards = [[NSMutableArray alloc] initWithCapacity:15];
    for (int i = 0; i < 15; i++) {
        [self.cards addObject:self.placeholder];
    }
    
    [self initPack:self.packName];
}



- (void) viewDidAppear:(BOOL)animated {
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Hides MBProgressHUD
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD hide:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    // loads card images
    _cardImages = [NSArray arrayWithObjects:((Card*)[self.cards objectAtIndex:0]).cardImage,
                   ((Card*)[self.cards objectAtIndex:1]).cardImage,
                   ((Card*)[self.cards objectAtIndex:2]).cardImage,
                   ((Card*)[self.cards objectAtIndex:3]).cardImage,
                   ((Card*)[self.cards objectAtIndex:4]).cardImage,
                   ((Card*)[self.cards objectAtIndex:5]).cardImage,
                   ((Card*)[self.cards objectAtIndex:6]).cardImage,
                   ((Card*)[self.cards objectAtIndex:7]).cardImage,
                   ((Card*)[self.cards objectAtIndex:8]).cardImage,
                   ((Card*)[self.cards objectAtIndex:9]).cardImage,
                   ((Card*)[self.cards objectAtIndex:10]).cardImage,
                   ((Card*)[self.cards objectAtIndex:11]).cardImage,
                   ((Card*)[self.cards objectAtIndex:12]).cardImage,
                   ((Card*)[self.cards objectAtIndex:13]).cardImage,
                   ((Card*)[self.cards objectAtIndex:14]).cardImage, nil];
    
    self.cardViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < 15; i++) {
        [self.cardViews addObject:[NSNull null]];
    }
    
    // Creates the scroll view with a height equal the the card image to disable vertical scrolling
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
    self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 15, ((UIImage*)_cardImages[0]).size.height);
    [self loadVisiblePages];
}



// Hides the scrollview when navigating away from the view, this was needed as it looked noticeably wrong without
-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        self.scrollView.hidden = YES;
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
