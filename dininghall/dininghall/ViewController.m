//
//  ViewController.m
//  dininghall
//
//  Created by Kunal Patel on 12/7/15.
//  Copyright © 2015 Kunal Patel. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import "DiningHallSelectionTableViewController.h"
@interface ViewController (){
    UIAlertController *controller;
    UIImage *selectedImage;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated{
    if ([PFUser currentUser][@"photo"]) {
        [self loginUser];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signinTapped:(id)sender {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            [self loginUser];
                                            // Do stuff after successful login.
                                        } else {
                                            NSString *errorString = [error userInfo][@"error"];
                                            UIAlertController * alert=   [UIAlertController
                                                                          alertControllerWithTitle:@"Error"
                                                                          message:errorString
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                                            
                                            UIAlertAction* ok = [UIAlertAction
                                                                 actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                                                 {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                     
                                                                 }];
                                            
                                            
                                            [alert addAction:ok];
                                            [self presentViewController:alert animated:YES completion:nil];                                        }
                                    }];
}

- (IBAction)signedUpTapped:(id)sender {
    PFUser *user = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email= self.usernameField.text;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {   // Hooray! Let them use the app now.
            [self presentViewController:[self alertWithText] animated:YES completion:nil];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Error"
                                          message:errorString
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
        }
    }];
}

- (UIAlertController *)alertWithText {
    
    
        // create an alert controller
    if (!controller) {
        controller = [UIAlertController alertControllerWithTitle:@"Name" message:@"Enter your name." preferredStyle:UIAlertControllerStyleAlert];
        
        // create the actions handled by each button
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"User Input was %@", [self accessAlertTextField]);
            PFUser *current = [PFUser currentUser];
            current[@"name"] = [self accessAlertTextField];
            [current saveInBackground];
            [self takePicture];
        }];
        

        
        [controller addAction:action1];
    
        [controller addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeDefault;
            textField.keyboardAppearance = UIKeyboardAppearanceDark;
        }];
    }
    return controller;
}

- (NSString *)accessAlertTextField {
    
    return [controller.textFields lastObject].text;
}

-(void)takePicture{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"Photos"
                                          message:@"Choose Source"
                                          preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *selectAction = [UIAlertAction actionWithTitle:@"Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhoto];
    }];
    
    [alertController addAction:selectAction];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {

        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pickPhoto];
        }];
        [alertController addAction:cameraAction];

    }
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)pickPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

- (void)selectPhoto{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    selectedImage = chosenImage;
    NSData *imageData = UIImagePNGRepresentation(chosenImage);
    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    PFUser *currentUser = [PFUser currentUser];
    currentUser[@"photo"] = imageFile;
    [currentUser saveInBackground];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self loginUser];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    [self takePicture];
}

-(void)loginUser{

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    
    DiningHallSelectionTableViewController *diningHall = (DiningHallSelectionTableViewController*)[mainStoryboard
                                                       instantiateViewControllerWithIdentifier: @"DiningHall"];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:diningHall];
    [self presentViewController:navController animated:YES completion:^{
        
    }];
}

@end
