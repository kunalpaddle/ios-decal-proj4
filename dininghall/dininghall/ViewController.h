//
//  ViewController.h
//  dininghall
//
//  Created by Kunal Patel on 12/7/15.
//  Copyright © 2015 Kunal Patel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)signinTapped:(id)sender;
- (IBAction)signedUpTapped:(id)sender;

@end

