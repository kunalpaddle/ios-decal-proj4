//
//  DiningHallSelectionTableViewController.h
//  dininghall
//
//  Created by Kunal Patel on 12/7/15.
//  Copyright © 2015 Kunal Patel. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol DiningHalDelegate;
@interface DiningHallSelectionTableViewController : UITableViewController
@property BOOL isNameList;
@property NSArray *nameList;
@property id<DiningHalDelegate> delegate;
@end

@protocol DiningHalDelegate <NSObject>

-(void)profileTappedWithObject:(id)object;

@end