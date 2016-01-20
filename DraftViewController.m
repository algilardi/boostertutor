//
//  DraftViewController.m
//  Booster Tutor
//
//  Created by Al Gilardi on 12/14/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//


#import "DraftViewController.h"
#import "Card.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface DraftViewController ()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@end

@implementation DraftViewController {
    int activePack;
}

// Changes packs when cards are selected
- (IBAction)selectButtonPressed:(id)sender {
    [self updateActivePack];
}


- (void) updateActivePack {
    if (activePack == 1) {
        activePack = 2;
        self.scrollView1.hidden = YES;
        self.scrollView3.hidden = YES;
        self.scrollView2.hidden = NO;
    }
    else if (activePack == 2){
        activePack = 3;
        self.scrollView2.hidden = YES;
        self.scrollView1.hidden = YES;
        self.scrollView3.hidden = NO;
    }
    else {
        activePack = 1;
        self.scrollView2.hidden = YES;
        self.scrollView3.hidden = YES;
        self.scrollView1.hidden = NO;
    }
    NSLog(@"pack: %i", activePack);
}

// Next 3 methods all set up the scroll view with the card images
// SCROLLVIEW SETUP
- (void)loadPage:(NSInteger)page {
    if (page < 0 || page > 14) {
        return;
    }
    
    UIView *pageView = [self.cardViews1 objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView1.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.cardImages1 objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView1 addSubview:newPageView];
        [self.cardViews1 replaceObjectAtIndex:page withObject:newPageView];
    }
    
    pageView = [self.cardViews2 objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView2.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.cardImages2 objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView2 addSubview:newPageView];
        [self.cardViews2 replaceObjectAtIndex:page withObject:newPageView];
    }
    
    pageView = [self.cardViews3 objectAtIndex:page];
    if ((NSNull*)pageView == [NSNull null]) {
        CGRect frame = self.scrollView3.bounds;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0.0f;
        frame = CGRectInset(frame, 10.0f, 0.0f);
        
        UIImageView *newPageView = [[UIImageView alloc] initWithImage:[self.cardImages3 objectAtIndex:page]];
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        newPageView.frame = frame;
        [self.scrollView3 addSubview:newPageView];
        [self.cardViews3 replaceObjectAtIndex:page withObject:newPageView];
    }
}

- (void)loadVisiblePages {
    // Load pages in our range
    for (NSInteger i=0; i<15; i++) {
        [self loadPage:i];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView1 {
    // Load the pages that are now on screen
    [self loadVisiblePages];
    
}
// SCROLLVIEW SETUP


- (void) initPacks:(NSString*)packName {
    NSString *URLstring;
    
    
    // 15 Card array to represent the pack
    // 0-9 = Common cards
    // 10-12 = Uncommon cards
    // 13 = Rare/Mythic Rare card
    // 14 = Land card
    
    // Sets up the proper json URL based on which pack was selected
    if ([packName isEqualToString:@"Battle for Zendikar"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/BFZ.json"];
    }
    else if ([packName isEqualToString:@"Innistrad"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/ISD.json"];
    }
    else if ([packName isEqualToString:@"Return to Ravnica"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/RTR.json"];
    }
    else if ([packName isEqualToString:@"Magic Origins"]) {
        URLstring = [NSString stringWithFormat:@"http://mtgjson.com/json/ORI.json"];
    }
    else {
        URLstring = [NSString stringWithFormat:@"http://google.com"];
    }
    
    // Prepares Json URL for the specific set
    NSURL *jsonURL = [NSURL URLWithString:URLstring];
    NSLog(@"%@", URLstring);

    
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
                
                // Creates pack 1
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
                        [self.cards1 replaceObjectAtIndex:commonCount withObject:tempCard];
                        commonCount++;
                    }
                    if ([tempRarity isEqualToString:@"Uncommon"] && (uncommonCount <= 12)) {
                        NSLog(@"uncommon: %i", uncommonCount);
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards1 replaceObjectAtIndex:uncommonCount withObject:tempCard];                        uncommonCount++;
                    }
                    if ( ([tempRarity isEqualToString:@"Rare"] || [tempRarity isEqualToString:@"Mythic Rare"]) && (!rareCount) ) {
                        NSLog(@"rare");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards1 replaceObjectAtIndex:13 withObject:tempCard];
                        rareCount = YES;
                    }
                    if ([tempRarity isEqualToString:@"Basic Land"] && (!landCount)) {
                        NSLog(@"land");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards1 replaceObjectAtIndex:14 withObject:tempCard];
                        landCount = YES;
                    }
                }
                NSLog(@"cards added\nPart 1");
                for (int i = 0; i < 15; i++) {
                    [((Card*)[self.cards1 objectAtIndex:i]) printCard];
                }
                
                
                randomindex = 0;
                commonCount = 0;
                uncommonCount = 10;
                rareCount = NO;
                landCount = NO;

                // Creates pack 2
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
                        [self.cards2 replaceObjectAtIndex:commonCount withObject:tempCard];
                        commonCount++;
                    }
                    if ([tempRarity isEqualToString:@"Uncommon"] && (uncommonCount <= 12)) {
                        NSLog(@"uncommon: %i", uncommonCount);
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards2 replaceObjectAtIndex:uncommonCount withObject:tempCard];                        uncommonCount++;
                    }
                    if ( ([tempRarity isEqualToString:@"Rare"] || [tempRarity isEqualToString:@"Mythic Rare"]) && (!rareCount) ) {
                        NSLog(@"rare");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards2 replaceObjectAtIndex:13 withObject:tempCard];
                        rareCount = YES;
                    }
                    if ([tempRarity isEqualToString:@"Basic Land"] && (!landCount)) {
                        NSLog(@"land");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards2 replaceObjectAtIndex:14 withObject:tempCard];
                        landCount = YES;
                    }
                }
                NSLog(@"cards added\nPart 2");
                for (int i = 0; i < 15; i++) {
                    [((Card*)[self.cards2 objectAtIndex:i]) printCard];
                }
                
                randomindex = 0;
                commonCount = 0;
                uncommonCount = 10;
                rareCount = NO;
                landCount = NO;
                
                // Creates pack 3
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
                        [self.cards3 replaceObjectAtIndex:commonCount withObject:tempCard];
                        commonCount++;
                    }
                    if ([tempRarity isEqualToString:@"Uncommon"] && (uncommonCount <= 12)) {
                        NSLog(@"uncommon: %i", uncommonCount);
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards3 replaceObjectAtIndex:uncommonCount withObject:tempCard];                        uncommonCount++;
                    }
                    if ( ([tempRarity isEqualToString:@"Rare"] || [tempRarity isEqualToString:@"Mythic Rare"]) && (!rareCount) ) {
                        NSLog(@"rare");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards3 replaceObjectAtIndex:13 withObject:tempCard];
                        rareCount = YES;
                    }
                    if ([tempRarity isEqualToString:@"Basic Land"] && (!landCount)) {
                        NSLog(@"land");
                        tempCard = [[Card alloc] initWithCardID:tempID andRarity:tempRarity andName:tempName];
                        [self.cards3 replaceObjectAtIndex:14 withObject:tempCard];
                        landCount = YES;
                    }
                }
                NSLog(@"cards added\nPart 3");
                for (int i = 0; i < 15; i++) {
                    [((Card*)[self.cards3 objectAtIndex:i]) printCard];
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
    HUD.labelText = @"Preparing Draft...";
    HUD.detailsLabelText = @"Please be patient";
    [HUD show:YES];
    
    // Sets "active pack" variable to the first pack and hides the other packs
    activePack = 1;
    self.selectButton.hidden = YES;
    self.scrollView2.hidden = YES;
    self.scrollView3.hidden = YES;
    
    //Customizes the button slightly
    self.selectButton.layer.cornerRadius = 10;
    
    // Creates empty arrays for the packs
    self.cards1 = [[NSMutableArray alloc] initWithCapacity:15];
    self.cards2 = [[NSMutableArray alloc] initWithCapacity:15];
    self.cards3 = [[NSMutableArray alloc] initWithCapacity:15];


    for (int i = 0; i < 15; i++) {
        [self.cards1 addObject:self.placeholder];
        [self.cards2 addObject:self.placeholder];
        [self.cards3 addObject:self.placeholder];

    }
    
    [self initPacks:self.packName];
}

- (void) viewWillAppear:(BOOL)animated {
    
}

- (void) viewDidAppear:(BOOL)animated {
    self.automaticallyAdjustsScrollViewInsets = NO;
    // Hides MBProgressHUD
    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD hide:YES];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    });
    
    // Displays button
    self.selectButton.hidden = NO;
    
    // loads card images
    _cardImages1 = [NSArray arrayWithObjects:((Card*)[self.cards1 objectAtIndex:0]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:1]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:2]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:3]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:4]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:5]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:6]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:7]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:8]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:9]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:10]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:11]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:12]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:13]).cardImage,
                   ((Card*)[self.cards1 objectAtIndex:14]).cardImage, nil];
    
    _cardImages2 = [NSArray arrayWithObjects:((Card*)[self.cards2 objectAtIndex:0]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:1]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:2]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:3]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:4]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:5]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:6]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:7]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:8]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:9]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:10]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:11]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:12]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:13]).cardImage,
                    ((Card*)[self.cards2 objectAtIndex:14]).cardImage, nil];
    
    _cardImages3 = [NSArray arrayWithObjects:((Card*)[self.cards3 objectAtIndex:0]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:1]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:2]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:3]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:4]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:5]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:6]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:7]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:8]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:9]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:10]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:11]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:12]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:13]).cardImage,
                    ((Card*)[self.cards3 objectAtIndex:14]).cardImage, nil];
    
    
    self.cardViews1 = [[NSMutableArray alloc] init];
    self.cardViews2 = [[NSMutableArray alloc] init];
    self.cardViews3 = [[NSMutableArray alloc] init];

    for (int i = 0; i < 15; i++) {
        [self.cardViews1 addObject:[NSNull null]];
        [self.cardViews2 addObject:[NSNull null]];
        [self.cardViews3 addObject:[NSNull null]];
    }

    
    // Creates the scroll view with a height equal the the card image to disable vertical scrolling
    [self.scrollView1 setContentOffset:CGPointMake(0,0) animated:YES];
    self.scrollView1.contentSize = CGSizeMake(self.scrollView1.frame.size.width * 15, ((UIImage*)_cardImages1[0]).size.height);
    [self loadVisiblePages];
    
    // Creates the scroll view with a height equal the the card image to disable vertical scrolling
    [self.scrollView2 setContentOffset:CGPointMake(0,0) animated:YES];
    self.scrollView2.contentSize = CGSizeMake(self.scrollView2.frame.size.width * 15, ((UIImage*)_cardImages2[0]).size.height);
    [self loadVisiblePages];
        
    // Creates the scroll view with a height equal the the card image to disable vertical scrolling
    [self.scrollView3 setContentOffset:CGPointMake(0,0) animated:YES];
    self.scrollView3.contentSize = CGSizeMake(self.scrollView3.frame.size.width * 15, ((UIImage*)_cardImages3[0]).size.height);
    [self loadVisiblePages];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        self.scrollView1.hidden = YES;
        self.scrollView2.hidden = YES;
        self.scrollView3.hidden = YES;
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

