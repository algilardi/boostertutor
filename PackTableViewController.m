//
//  PackOpenTableViewController.m
//  Booster Tutor
//
//  Created by Al Gilardi on 12/13/15.
//  Copyright © 2015 Al Gilardi. All rights reserved.
//

#import "PackTableViewController.h"
#import "PackOpenViewController.h"

@interface PackTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *packTableView;

@end

@implementation PackTableViewController
{
    // Instance variables for the Table View and passing data to the next ViewController
    NSArray *packList;
    NSString *packN;
}



// Passes the selected pack name to the next ViewController, so the proper cards will be loaded
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"packSegue"]){
        PackOpenViewController *controller = (PackOpenViewController *)segue.destinationViewController;
        controller.packName = packN;
    }
}



// When a TableView cell is selected, perform the segue
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    packN = cell.textLabel.text;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self performSegueWithIdentifier:@"packSegue" sender:packN];
}



// TABLEVIEW SETUP
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [packList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"SimpleTableItem";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    
    cell.textLabel.text = [packList objectAtIndex:indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:@"Battle for Zendikar"]) {
        cell.imageView.image = [UIImage imageNamed:@"BFZ.png"];
    }
    else if ([cell.textLabel.text isEqualToString:@"Innistrad"]) {
        cell.imageView.image = [UIImage imageNamed:@"ISD.png"];
    }
    else if ([cell.textLabel.text isEqualToString:@"Return to Ravnica"]) {
        cell.imageView.image = [UIImage imageNamed:@"RTR.png"];
    }
    else if ([cell.textLabel.text isEqualToString:@"Magic Origins"]) {
        cell.imageView.image = [UIImage imageNamed:@"ORI.png"];
    }
    else {
        cell.imageView.image = [UIImage imageNamed:@"placeholder.png"];
    }
    return cell;
}
// TABLEVIEW SETUP



// Changes the TableView background color to match Dark Gray theme of the app
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor darkGrayColor];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    packList = [NSArray arrayWithObjects:@"Battle for Zendikar", @"Innistrad", @"Return to Ravnica", @"Magic Origins", nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}
@end
