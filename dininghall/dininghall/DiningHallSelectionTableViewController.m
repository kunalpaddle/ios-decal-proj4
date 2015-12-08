//
//  DiningHallSelectionTableViewController.m
//  dininghall
//
//  Created by Kunal Patel on 12/7/15.
//  Copyright © 2015 Kunal Patel. All rights reserved.
//

#import "DiningHallSelectionTableViewController.h"
#import "CheckInViewController.h"
@interface DiningHallSelectionTableViewController (){
    NSArray *images;
    NSArray *names;
}

@end

@implementation DiningHallSelectionTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    images = @[@"foothill_logo", @"crossroads_logo", @"ckc_logo", @"cafe_3_logo"];
    names = @[@"Foothill", @"Crossroads", @"Clark Kerr", @"Cafe 3"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isNameList) {
        if (self.nameList.count == 0) {
            return 1;
        }
        return self.nameList.count;
    }
    return images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isNameList) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"name" forIndexPath:indexPath];
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        if (self.nameList.count == 0) {
            [label setText:@"No One Checked In"];
        }
        else{
            
            if ([self.nameList[indexPath.row][@"buying"] boolValue]) {
                [label setText:[NSString stringWithFormat:@"%@ is buying meal points",self.nameList[indexPath.row][@"ownerName"]]];
            }
            else{
                [label setText:[NSString stringWithFormat:@"%@ is selling meal points",self.nameList[indexPath.row][@"ownerName"]]];
            }
        }
        
        return cell;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DiningCell" forIndexPath:indexPath];
    UIImageView *image = (UIImageView *)[cell viewWithTag:2];
    [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",[images objectAtIndex:indexPath.row]]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isNameList && self.nameList.count > 0) {
        [self.delegate profileTappedWithObject:self.nameList[indexPath.row]];
        return;
    }
    else if (self.isNameList){
        return;
    }
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    CheckInViewController *checkinPage = (CheckInViewController*)[mainStoryboard
                                                                  instantiateViewControllerWithIdentifier: @"CheckInPage"];
    checkinPage.headerImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.gif",[images objectAtIndex:indexPath.row]]];
    checkinPage.name = [names objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:checkinPage animated:YES];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
