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

#import "EmailController.h"
#import "AppDelegate.h"
#import "GANTracker.h"
@implementation EmailController
-(id)initWithEmail:(NSManagedObjectID*)email{
    if (self = [super initWithNibName:@"EmailView" bundle:nil]){
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close)];
    
        emailId = [email retain];
    }
    return self;
}
-(void)dealloc{
    [webView release];
    [emailId release];
    [super dealloc];
}

#pragma mark - View lifecycle

- (void)viewDidLoad{
    [super viewDidLoad];
    NSManagedObjectContext* context = [((AppDelegate*)[UIApplication sharedApplication].delegate) newManagedObjectContext];
    EmailModel* email = (EmailModel*)[context objectWithID:emailId];
    [webView loadHTMLString:email.htmlBody baseURL:nil];
    self.navigationController.navigationBar.barStyle=UIBarStyleBlack;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[GANTracker sharedTracker] trackPageview:@"/show_email" withError:nil];
}

- (void)viewDidUnload{
    [super viewDidUnload];
    [webView release];
    webView = nil;
}

-(void)close{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return ((interfaceOrientation == UIInterfaceOrientationLandscapeLeft)||(interfaceOrientation==UIInterfaceOrientationLandscapeRight));
}

@end
