//
//  CheckInViewController.m
//  dininghall
//
//  Created by Kunal Patel on 12/7/15.
//  Copyright © 2015 Kunal Patel. All rights reserved.
//

#import "CheckInViewController.h"
#import <Parse/Parse.h>
#import "DiningHallSelectionTableViewController.h"
#import "ProfileViewController.h"
@interface CheckInViewController ()<DiningHalDelegate>{
    PFUser *currentUser;
    DiningHallSelectionTableViewController *diningHall;
}
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation CheckInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    currentUser = [PFUser currentUser];
    [self.headerImageView setImage:self.headerImage];
    // Do any additional setup after loading the view.
}
-(void)viewDidAppear:(BOOL)animated{
    [self setupTableView];

}

-(void)setupTableView{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];

    diningHall = (DiningHallSelectionTableViewController*)[mainStoryboard
                                                                                                   instantiateViewControllerWithIdentifier: @"DiningHall"];
    diningHall.isNameList = YES;
    diningHall.delegate =self;
    [self addChildViewController:diningHall];
    [diningHall.view setFrame:self.backgroundView.frame];
    [self.view addSubview:diningHall.view];
    
    [self loadData];
}

-(void)loadData{
    PFQuery *query = [PFQuery queryWithClassName:@"checkIn"];
    [query whereKey:@"name" equalTo:self.name];
    [query whereKey:@"current" equalTo:@YES];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        diningHall.nameList = objects;
        
        [diningHall.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)checkInSellPressed:(id)sender {
    [self checkInWithBuying:NO];
}


- (IBAction)checkInBuyButtonPressed:(id)sender {
    [self checkInWithBuying:YES];
}

-(void)updateCheckInsForUser:(PFUser *)current withCompletion:(void (^)(void))completion{
    PFQuery *query = [PFQuery queryWithClassName:@"checkIn"];
    [query whereKey:@"owner" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSMutableArray *holder = [NSMutableArray new];
        for (PFObject *object  in objects) {
            object[@"current"] = @NO;
            [holder addObject:object];
        }
        [PFObject saveAllInBackground:holder block:^(BOOL succeeded, NSError * _Nullable error) {
            completion();
        }];
    }];
}

-(void)checkInWithBuying:(BOOL)buying{
    [self updateCheckInsForUser:[PFUser currentUser] withCompletion:^{
        
        PFObject *checkInObject = [PFObject objectWithClassName:@"checkIn"];
        checkInObject[@"owner"] = [PFUser currentUser];
        checkInObject[@"ownerName"] = [PFUser currentUser][@"name"];
        checkInObject[@"buying"] = [NSNumber numberWithBool:buying];
        checkInObject[@"current"] = @YES;
        [checkInObject saveInBackground];
        [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint * _Nullable geoPoint, NSError * _Nullable error) {
            checkInObject[@"location"] = geoPoint;
            checkInObject[@"name"] = self.name;
            currentUser[@"currentLocation"]= checkInObject;
            [checkInObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    
                    UIAlertController * alert=   [UIAlertController
                                                  alertControllerWithTitle:@"Checked In"
                                                  message:[NSString stringWithFormat:@"Checked into %@!",self.name]
                                                  preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                                             [alert dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    
                    [alert addAction:ok];
                    [self presentViewController:alert animated:YES completion:nil];
                    [self loadData];
                }
            }];
            [currentUser saveInBackground];
        }];
    }];

}

-(void)profileTappedWithObject:(id)object{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention" message:@"Find the person on the following screen and proceed" preferredStyle:UIAlertControllerStyleAlert];
    
    // create the actions handled by each button
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"Perfect!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                 bundle: nil];
        
        ProfileViewController *pvc = (ProfileViewController*)[mainStoryboard
                                                              instantiateViewControllerWithIdentifier: @"ProfileVC"];
        PFUser *owner = object[@"owner"];
        [owner fetchIfNeeded];
        
        [self.navigationController pushViewController:pvc animated:YES];
        
        
        PFFile *userImageFile = owner[@"photo"];
        [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:imageData];
                [pvc.profileImage setImage:image];
                [pvc.nameLabel setText:object[@"ownerName"]];
                [pvc.profileImage setContentMode:UIViewContentModeScaleAspectFit];
            }
        }];
    }];
    

    // add actions to our alert
    [alert addAction:action1];
    
    // display the alert controller
    [self presentViewController:alert animated:YES completion:nil];

    
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
