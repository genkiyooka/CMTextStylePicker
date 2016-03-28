//
//  iPadDemoViewController.m
//  CMTextStylePickerDemo
//
//  Created by Chris Miles on 19/11/10.
//  Copyright (c) Chris Miles 2010.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "IPadDemoViewController.h"

@interface  IPadDemoViewController ()
@property (nonatomic,assign) CGFloat mainTextViewOriginalHeight;
@property (ARC_PROP_STRONG)	UIPopoverController	*currentPopoverController;
@property (ARC_PROP_STRONG)	UIFont				*defaultFont;
@property (ARC_PROP_STRONG)	UIColor				*defaultTextColor;
@end


@implementation IPadDemoViewController

ARC_SYNTHESIZEAUTO(mainTextView);
ARC_SYNTHESIZEAUTO(mainTextViewOriginalHeight);
ARC_SYNTHESIZEAUTO(currentPopoverController);
ARC_SYNTHESIZEAUTO(defaultFont);
ARC_SYNTHESIZEAUTO(defaultTextColor);

- (IBAction)actionsButtonPressed:(id)sender {
	if (self.currentPopoverController) {
		[self.currentPopoverController dismissPopoverAnimated:YES];
		self.currentPopoverController = nil;
	}
	else {
		CMTextStylePickerViewController *textStylePickerViewController = [CMTextStylePickerViewController textStylePickerViewController];
		textStylePickerViewController.delegate = self;
		textStylePickerViewController.selectedTextColour = self.mainTextView.textColor;
		textStylePickerViewController.selectedFont = self.mainTextView.font;
		if ([self.mainTextView.textColor isEqual:self.defaultTextColor] && [self.mainTextView.font isEqual:self.defaultFont]) {
			textStylePickerViewController.defaultSettingsSwitchValue = YES;
		}
		else {
			textStylePickerViewController.defaultSettingsSwitchValue = NO;
		}
		
		UINavigationController *actionsNavigationController = ARC_AUTORELEASE([[UINavigationController alloc] initWithRootViewController:textStylePickerViewController]);
		Class classPopoverController = NSClassFromString(@"UIPopoverController");
		if (classPopoverController) {
			UIPopoverController *popoverController = ARC_AUTORELEASE([[classPopoverController alloc] initWithContentViewController:actionsNavigationController]);
			popoverController.delegate = self;
			[popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem *)sender
									  permittedArrowDirections:UIPopoverArrowDirectionAny
													  animated:YES];
			
			self.currentPopoverController = popoverController;
		}
	}
}

- (void)resizeTextViewForKeyboard:(NSNotification *)aNotification up:(BOOL)up {
	NSDictionary* userInfo = [aNotification userInfo];
	
	// Get animation info from userInfo
	NSTimeInterval animationDuration;
	UIViewAnimationCurve animationCurve;
	
	CGRect keyboardEndFrame;
	
	[[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
	[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
	
	
	[[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
	
	
	// Animate up or down
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDuration:animationDuration];
	[UIView setAnimationCurve:animationCurve];
	
	CGRect newFrame = self.mainTextView.frame;
	CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
	
	if (up) {
		self.mainTextViewOriginalHeight = newFrame.size.height;
		newFrame.size.height -= keyboardFrame.size.height;
	}
	else {
		newFrame.size.height = self.mainTextViewOriginalHeight;
	}
	
	self.mainTextView.frame = newFrame;
	
	[UIView commitAnimations];
}


#pragma mark -
#pragma mark CMTextStylePickerViewControllerDelegate methods

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedFont:(UIFont *)font {
	self.mainTextView.font = font;
}

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedTextColor:(UIColor *)textColor {
	self.mainTextView.textColor = textColor;
}

- (void)textStylePickerViewControllerSelectedCustomStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
	// Use custom text style
	self.mainTextView.font = textStylePickerViewController.selectedFont;
	self.mainTextView.textColor = textStylePickerViewController.selectedTextColour;
}

- (void)textStylePickerViewControllerSelectedDefaultStyle:(CMTextStylePickerViewController *)textStylePickerViewController {
	// Use default text style
	self.mainTextView.font = self.defaultFont;
	self.mainTextView.textColor = self.defaultTextColor;
}

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController replaceDefaultStyleWithFont:(UIFont *)font textColor:(UIColor *)textColor {
	self.defaultFont = font;
	self.defaultTextColor = textColor;
}


#pragma mark -
#pragma mark UIPopoverControllerDelegate methods

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	self.currentPopoverController = nil;
}


#pragma mark -
#pragma mark Keyboard Notifications

- (void)keyboardWillShow:(NSNotification *)aNotification {
    [self resizeTextViewForKeyboard:aNotification up:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
	[self resizeTextViewForKeyboard:aNotification up:NO]; 
}


#pragma mark -
#pragma mark UIViewController methods

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.defaultFont = self.mainTextView.font;
	self.defaultTextColor = self.mainTextView.textColor;
	
	// Subscribe to keyboard visible notifications (so we can adjust the text view scrollable area)
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillShow:)
												 name:UIKeyboardWillShowNotification
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(keyboardWillHide:)
												 name:UIKeyboardWillHideNotification
											   object:nil];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];

    // Release any retained subviews of the main view.
	self.mainTextView = nil;
}


- (void)dealloc {
	ARC_DEALLOC_NIL(self.mainTextView);
	ARC_DEALLOC_NIL(self.currentPopoverController);
	ARC_DEALLOC_NIL(self.defaultFont);
	ARC_DEALLOC_NIL(self.defaultTextColor);
	ARC_SUPERDEALLOC(self);
}


@end
