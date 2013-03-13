//
//  SHViewController.m
//  TWReverseAuthExample
//
//  Created by Seivan Heidari on 3/13/13.
//  Copyright (c) 2013 Seivan Heidari. All rights reserved.
//

#import "SHViewController.h"
#import "TWAPIManager.h"
@interface SHViewController ()
<UIAlertViewDelegate>

-(void)showError:(NSError *)theError;
-(void)performReverseAuthWithAccount:(ACAccount *)theAccount;


@end

@implementation SHViewController

-(void)viewDidLoad; {
  [super viewDidLoad];

}
-(void)viewDidAppear:(BOOL)animated; {
  [super viewDidAppear:animated];
  [[[UIAlertView alloc] initWithTitle:@"Sample" message:@"Tap 'OK' login with twitter now" delegate:self
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil] show];
  
}

-(void)didReceiveMemoryWarning; {
  [super didReceiveMemoryWarning];
  
}

-(void)performReverseAuthWithAccount:(ACAccount *)theAccount; {
 [TWAPIManager performReverseAuthForAccount:theAccount withHandler:^(NSData *responseData, NSError *error) {
   if(error) [self showError:error];
   else {
     NSString *responseStr = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
     NSArray *parts = [responseStr componentsSeparatedByString:@"&"];
     NSString *lined = [parts componentsJoinedByString:@"\n"];
     
     dispatch_async(dispatch_get_main_queue(), ^{
       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:lined delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
       [alert show];
     });
   }
 }];
}

-(void)showError:(NSError *)theError; {
  NSString * title   = theError.localizedDescription;
  NSString * message = theError.localizedRecoverySuggestion;
  NSLog(@"ERROR %@", theError.userInfo);
  NSLog(@"ERROR %@", theError.localizedDescription);
  NSLog(@"ERROR %@", theError.localizedFailureReason);
  NSLog(@"ERROR %@", theError.localizedRecoveryOptions);
  NSLog(@"ERROR %@", theError.localizedRecoverySuggestion);
  
  if(title == nil)   title   = @"Error";
  if(message == nil) message = @"Somethin' ain't right, son.";

  [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil
                    cancelButtonTitle:@"OK"
                    otherButtonTitles:nil, nil] show];
}

#pragma mark -
#pragma <UIAlertViewDelegate>
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
  ACAccountStore * acStore = [[ACAccountStore alloc] init];
  ACAccountType  * acType  = [acStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
  [acStore requestAccessToAccountsWithType:acType options:nil completion:^(BOOL granted, NSError *error) {
    if (granted) {
      NSArray * accounts = [acStore accountsWithAccountType:acType];
      if(accounts.count > 0) {
        ACAccount * account = accounts.lastObject;
        account.accountType = acType;
        [self performReverseAuthWithAccount:account];
      }
      
      else
        [self showError:nil];
    }
    else
      [self showError:nil];
  }];
 
}

@end
