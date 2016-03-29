//
//  CMTextStylePickerViewController.m
//  CMTextStylePicker
//
//  Created by Chris Miles on 18/10/10.
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

#import "CMTextStylePickerViewController.h"

#import "CMColourBlockView.h"
#import "CMUpDownControl.h"

CGSize CMTextStylePickerViewControllerContentSizeForViewInPopover = {320,330};

static inline void UIViewControllerSetContentSizeForViewInPopover(UIViewController* vc) {
	if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
		{
#ifdef __IPHONE_7_0
		vc.preferredContentSize = CMTextStylePickerViewControllerContentSizeForViewInPopover;
#else
		vc.contentSizeForViewInPopover = CMTextStylePickerViewControllerContentSizeForViewInPopover;
#endif
		}
}


#define kDisabledCellAlpha		0.4


#pragma mark -
#pragma mark Private Interface

@interface CMTextStylePickerViewController ()
@property (ARC_PROP_STRONG)	NSArray		*tableLayout;
@end


#pragma mark -
#pragma mark Implementation

@implementation CMTextStylePickerViewController

ARC_SYNTHESIZEAUTO(defaultSettingsSwitchValue);
ARC_SYNTHESIZEAUTO(selectedTextColour);
ARC_SYNTHESIZEAUTO(selectedFont);
ARC_SYNTHESIZEAUTO(tableLayout);
ARC_SYNTHESIZEOUTLET(delegate);
ARC_SYNTHESIZEOUTLET(applyAsDefaultCell);
ARC_SYNTHESIZEOUTLET(doneButtonItem);
ARC_SYNTHESIZEOUTLET(colourCell);
ARC_SYNTHESIZEOUTLET(colourView);
ARC_SYNTHESIZEOUTLET(defaultSettingsCell);
ARC_SYNTHESIZEOUTLET(fontCell);
ARC_SYNTHESIZEOUTLET(fontSizeControl);
ARC_SYNTHESIZEOUTLET(fontNameLabel);
ARC_SYNTHESIZEOUTLET(sizeCell);
ARC_SYNTHESIZEOUTLET(defaultSettingsSwitch);

+ (CMTextStylePickerViewController *)textStylePickerViewController {
	CMTextStylePickerViewController *textStylePickerViewController = [[CMTextStylePickerViewController alloc] initWithNibName:@"CMTextStylePickerViewController" bundle:nil];
	return ARC_AUTORELEASE(textStylePickerViewController);
}

- (void)notifyDelegateSelectedFontChanged {
	if (REQUIRED_DELEGATE_SEL(self,textStylePickerViewController:userSelectedFont:))
		[self.delegate textStylePickerViewController:self userSelectedFont:self.selectedFont];
}

- (void)notifyDelegateSelectedTextColorChanged {
	if (REQUIRED_DELEGATE_SEL(self,textStylePickerViewController:userSelectedTextColor:))
		[self.delegate textStylePickerViewController:self userSelectedTextColor:self.selectedTextColour];
}

- (void)enableTextOptionCells {
	// Undo the "disabled" look and enable user interaction
	[UIView beginAnimations:nil context:NULL];
	
	for (UITableViewCell *cell in [self.tableLayout objectAtIndex:1]) {
		cell.userInteractionEnabled = YES;
		if (cell != self.sizeCell) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		}
		
		cell.contentView.alpha = 1.0;
	}
	
	self.applyAsDefaultCell.contentView.alpha = 1.0;
	self.applyAsDefaultCell.userInteractionEnabled = YES;
	
	[UIView commitAnimations];
}

- (void)disableTextOptionCells {
	// Make cells look "disabled" and disable user interaction
	[UIView beginAnimations:nil context:NULL];
	
	for (UITableViewCell *cell in [self.tableLayout objectAtIndex:1]) {
		cell.userInteractionEnabled = NO;
		cell.accessoryType = UITableViewCellAccessoryNone;
		
		cell.contentView.alpha = kDisabledCellAlpha;
	}
	
	self.applyAsDefaultCell.contentView.alpha = kDisabledCellAlpha;
	self.applyAsDefaultCell.userInteractionEnabled = NO;
	
	[UIView commitAnimations];
}

- (void)replaceDefaultSettings {
	if (REQUIRED_DELEGATE_SEL(self,textStylePickerViewController:replaceDefaultStyleWithFont:textColor:))
		[self.delegate textStylePickerViewController:self replaceDefaultStyleWithFont:self.selectedFont textColor:self.selectedTextColour];
	
	self.defaultSettingsSwitchValue = YES;
	[self.defaultSettingsSwitch setOn:YES animated:YES];
	[self disableTextOptionCells];
}

- (void)updateFontColourSelections {
	self.fontNameLabel.text = self.selectedFont.fontName;
	self.fontSizeControl.value = self.selectedFont.pointSize;
}

- (IBAction)doneAction {
	if (REQUIRED_DELEGATE_SEL(self,textStylePickerViewControllerIsDone:))
		[self.delegate textStylePickerViewControllerIsDone:self];
}

- (IBAction)defaultTextSettingsAction:(UISwitch *)defaultSwitch {
	self.defaultSettingsSwitchValue = defaultSwitch.on;
		
	if (self.defaultSettingsSwitchValue) {
		// Use default text style
		if (REQUIRED_DELEGATE_SEL(self,textStylePickerViewControllerSelectedDefaultStyle:))
			[self.delegate textStylePickerViewControllerSelectedDefaultStyle:self];
		[self disableTextOptionCells];
	}
	else {
		// Use custom text style
		if (REQUIRED_DELEGATE_SEL(self,textStylePickerViewControllerSelectedCustomStyle:))
			[self.delegate textStylePickerViewControllerSelectedCustomStyle:self];
		[self enableTextOptionCells];
	}
	
	[self updateFontColourSelections];
}

- (IBAction)fontSizeValueChanged:(CMUpDownControl *)control {
	CGFloat size = (CGFloat)control.value;
	UIFont *textFont = [UIFont fontWithName:self.selectedFont.fontName size:size];
	self.selectedFont = textFont;
	
	[self notifyDelegateSelectedFontChanged];
}


#pragma mark  -
#pragma mark ColourSelectTableViewControllerDelegate methods

- (void)colourSelectTableViewController:(CMColourSelectTableViewController *)colourSelectTableViewController didSelectColour:(UIColor *)colour {
	self.selectedTextColour = colour;
	self.colourView.colour = colour;	// Update the colour swatch
	[self notifyDelegateSelectedTextColorChanged];
}


#pragma mark -
#pragma mark FontSelectTableViewControllerDelegate methods

- (void)fontSelectTableViewController:(CMFontSelectTableViewController *)fontSelectTableViewController didSelectFont:(UIFont *)textFont {
	self.selectedFont = textFont;
	self.fontNameLabel.text = [textFont fontName];
	[self notifyDelegateSelectedFontChanged];
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = @"Text Style";
		
	self.fontSizeControl.minimumAllowedValue = 8;
	self.fontSizeControl.maximumAllowedValue = 72;
	
	[self updateFontColourSelections];
	
	self.tableLayout = [NSArray arrayWithObjects:
						[NSArray arrayWithObjects:
						 self.defaultSettingsCell,
						 nil],
						[NSArray arrayWithObjects:
						 self.sizeCell,
						 self.fontCell,
						 self.colourCell,
						 nil],
						[NSArray arrayWithObjects:
						 self.applyAsDefaultCell,
						 nil],
						nil];
	
	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		// iPhone UI
		self.navigationItem.rightBarButtonItem = self.doneButtonItem;
	}
	else {
		// iPad UI
		self.contentSizeForViewInPopover = CMTextStylePickerViewControllerContentSizeForViewInPopover;
	}
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.tableLayout count];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[self.tableLayout objectAtIndex:section] count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	UITableViewCell *cell = [[self.tableLayout objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    return cell;
}



#pragma mark -
#pragma mark UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[self.tableLayout objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	return cell.bounds.size.height;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSIndexPath *selectedIndexPath = indexPath;
	UITableViewCell *cell = [[self.tableLayout objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if (cell == self.sizeCell || cell == self.defaultSettingsCell) {
		// Disable selection of cell
		selectedIndexPath = nil;
	}
	
	return selectedIndexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[self.tableLayout objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
	
	if (cell == self.fontCell) {
		CMFontSelectTableViewController *fontSelectTableViewController = [[CMFontSelectTableViewController alloc] initWithNibName:@"CMFontSelectTableViewController" bundle:nil];
		fontSelectTableViewController.delegate = self;
		fontSelectTableViewController.selectedFont = self.selectedFont;
		UIViewControllerSetContentSizeForViewInPopover(fontSelectTableViewController);
		[self.navigationController pushViewController:fontSelectTableViewController animated:YES];
		ARC_RELEASE(fontSelectTableViewController);
	}
	else if (cell == self.colourCell) {
		CMColourSelectTableViewController *colourSelectTableViewController = [[CMColourSelectTableViewController alloc] initWithNibName:@"CMColourSelectTableViewController" bundle:nil];
		colourSelectTableViewController.delegate = self;
		colourSelectTableViewController.selectedColour = self.selectedTextColour;
		UIViewControllerSetContentSizeForViewInPopover(colourSelectTableViewController);
		[self.navigationController pushViewController:colourSelectTableViewController animated:YES];
		ARC_RELEASE(colourSelectTableViewController);
	}
	else if (cell == self.applyAsDefaultCell) {
		// "Replace default settings"
		[self replaceDefaultSettings];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (cell == self.colourCell) {
		self.colourView.colour = self.selectedTextColour;
	}

	if (self.defaultSettingsSwitchValue == NO) {
		// Custom text style is active
		if (cell == self.defaultSettingsCell) {
			self.defaultSettingsSwitch.on = NO;
		}
		else {
			cell.contentView.alpha = 1.0;
			cell.userInteractionEnabled = YES;
		}

	}
	else {
		// Text style is default
		if (cell == self.defaultSettingsCell) {
			self.defaultSettingsSwitch.on = YES;
		}
		else {
			cell.contentView.alpha = kDisabledCellAlpha;
			cell.userInteractionEnabled = NO;
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	
	self.applyAsDefaultCell = nil;
	self.colourCell = nil;
	self.colourView = nil;
	self.defaultSettingsCell = nil;
	self.defaultSettingsSwitch = nil;
	self.doneButtonItem = nil;
	self.fontCell = nil;
	self.fontNameLabel = nil;
	self.fontSizeControl = nil;
	self.sizeCell = nil;
}

#pragma mark -

-(UIPopoverController*) presentPopoverWithButtonBarItem:(UIBarButtonItem*)buttonBarItem popoverDelegate:(id<UIPopoverControllerDelegate>)popoverDelegate {
UIPopoverController* popoverController = nil;
UINavigationController *actionsNavigationController = ARC_AUTORELEASE([[UINavigationController alloc] initWithRootViewController:self]);
Class classUIPopoverController = NSClassFromString(@"UIPopoverController");
	if (REQUIRED_NOT_NIL(classUIPopoverController)) {
		popoverController = ARC_AUTORELEASE([[classUIPopoverController alloc] initWithContentViewController:actionsNavigationController]);
		if (REQUIRED_NOT_NIL(popoverController))
			{
			popoverController.delegate = popoverDelegate;
			[popoverController presentPopoverFromBarButtonItem:(UIBarButtonItem*)buttonBarItem
									  permittedArrowDirections:UIPopoverArrowDirectionAny
													  animated:YES];
			}
		}
	return popoverController;
}			


- (void)dealloc {
	ARC_DEALLOC_NIL(self.applyAsDefaultCell);
	ARC_DEALLOC_NIL(self.colourCell);
	ARC_DEALLOC_NIL(self.colourView);
	ARC_DEALLOC_NIL(self.defaultSettingsCell);
	ARC_DEALLOC_NIL(self.defaultSettingsSwitch);
	ARC_DEALLOC_NIL(self.doneButtonItem);
	ARC_DEALLOC_NIL(self.fontCell);
	ARC_DEALLOC_NIL(self.fontNameLabel);
	ARC_DEALLOC_NIL(self.fontSizeControl);
	ARC_DEALLOC_NIL(self.selectedTextColour);
	ARC_DEALLOC_NIL(self.selectedFont);
	ARC_DEALLOC_NIL(self.sizeCell);
	ARC_DEALLOC_NIL(self.tableLayout);
	ARC_SUPERDEALLOC(self);
}


@end

