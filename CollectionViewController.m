//
//  CollectionViewController.m
//  Booster Tutor
//
//  Created by Al Gilardi on 12/14/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import "CollectionViewController.h"
#import "Card.h"
#import "AppDelegate.h"
#import "CardViewController.h"


@interface CollectionViewController ()
@property (weak, nonatomic) IBOutlet UITableView *cardTableView;
@property (weak, nonatomic) IBOutlet UILabel *packLabel;

@end

@implementation CollectionViewController
{
    // Instance variables for the Table View and passing data to the next ViewController
    NSString *cardN;
    NSString *cardID;
}



// Passes the selected pack name to the next ViewController, so the proper cards will be loaded
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"cardSegue"]){
        CardViewController *controller = (CardViewController *)segue.destinationViewController;
        controller.cardNumber = sender;
    }
}



// When a card is selected, the segue is called and passes the next view the cardID, which is what is needed to load the correct image
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    cardID = [self.cardIDList objectAtIndex:indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"cardSegue" sender:cardID];
}



// Fills the cardList array with the names of all the cards, based on the selected pack
- (void) getCardsForPack:(NSString *)packName {
    NSString *URLstring;
    
    // Sets up the proper json URL based on which pack was selected to view
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
    //NSLog(@"%@", URLstring);
    
    // Creates the arrays that will hold the card names and corresponding card IDs
    // Didn't want to create the card objects themself, because loading the images would take too long
    self.cardList = [NSMutableArray array];
    self.cardIDList = [NSMutableArray array];
    
    [AppDelegate downloadDataFromURL:jsonURL withCompletionHandler: ^(NSData * data) {
        if (data != nil) {
            NSError *error;
            NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            
            if (error != nil) {
                NSLog(@"%@", [error localizedDescription]);
            }
            else {
                // Gets the JSON card info and populates the cardList and cardIDList arrays
                self.jsonArr = [returnedDict objectForKey:@"cards"];
                for (int i = 0; i < [self.jsonArr count]; i++) {
                    self.jsonDictCard = [self.jsonArr objectAtIndex:i];
                    //NSLog(@"Card: %@ __ ID:%@", [self.jsonDictCard objectForKey:@"name"],[self.jsonDictCard objectForKey:@"multiverseid"]);
                    [self.cardList addObject:[self.jsonDictCard objectForKey:@"name"]];
                    //NSLog(@"Card: %@", [self.cardList objectAtIndex:i]);
                    [self.cardIDList addObject:[self.jsonDictCard objectForKey:@"multiverseid"]];
                    [self.cardTableView reloadData];
                }
            }
        }
    }];
}



// TABLEVIEW SETUP
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cardList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.cardList objectAtIndex:indexPath.row]];
    return cell;
}

// Changes the TableView background color to match Dark Gray theme of the app
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor lightGrayColor];
}
// TABLEVIEW SETUP



- (void)viewDidLoad {
    [super viewDidLoad];
    [self getCardsForPack:self.packName];
    self.packLabel.text = self.packName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
