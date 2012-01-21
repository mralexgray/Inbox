/*
 *
 * Copyright (c) 2012 Simon Watiau.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import "LoginController.h"
#import "AppDelegate.h"
#import "DeskController.h"
#import "GmailModel.h"
@implementation LoginController
@synthesize desk;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        shouldResetModelOnDisappear = NO;
    }
    return self;
}

- (void)dealloc {
    self.desk = nil;
    [emailField release];
    [passwordField release];
    [submitButton release];
    [emailField release];
    [super dealloc];
}

- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@gmail\\.com";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark - IBActions

- (IBAction)onLogin:(id)sender {
    if (![self validateEmail:emailField.text]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login.invalidemail.title", @"title of the alert shown when the login email is invalid") message:NSLocalizedString(@"login.invalidemail.message", @"message of the alert shown when the login email is invalid") delegate:nil cancelButtonTitle:NSLocalizedString(@"login.invalidemail.button", @"button title of the alert shown when the login email is invalid") otherButtonTitles:nil];
        [alert show];
        [alert release];
        
    }else if ([passwordField.text isEqualToString:@""]){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"login.emptypassword.title","title of the alert shown when the login password is empty") message:NSLocalizedString(@"login.emptypassword.message", @"message of the alert shown when the login password is empty") delegate:nil cancelButtonTitle:NSLocalizedString(@"login.emptypassword.button", @"button title of the alert shown when the login password is empty") otherButtonTitles:nil];
        [alert show];
        [alert release];
    }else{
        NSString* plistPath = [(AppDelegate*)[UIApplication sharedApplication].delegate plistPath];
        NSMutableDictionary* plistDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
        if (!plistDic){
            plistDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        }
        [plistDic setValue:emailField.text forKey:@"email"];
        [plistDic setValue:passwordField.text forKey:@"password"];
        [plistDic writeToFile:plistPath atomically:YES];
        [plistDic release];
        shouldResetModelOnDisappear = YES;
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - View's lifecycle

- (void)viewDidLoad{
    NSString* plistPath = [(AppDelegate*)[UIApplication sharedApplication].delegate plistPath];
    NSMutableDictionary* plistDic = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    if (plistPath){
        emailField.text = [plistDic valueForKey:@"email"];
        passwordField.text = [plistDic valueForKey:@"password"];
    }
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (shouldResetModelOnDisappear){
        [self.desk resetModel];
    }
}

- (void)viewDidUnload{
    [passwordField release];
    passwordField = nil;
    [submitButton release];
    submitButton = nil;
    [emailField release];
    emailField = nil;
    [super viewDidUnload];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation==UIInterfaceOrientationLandscapeRight));
}


@end
