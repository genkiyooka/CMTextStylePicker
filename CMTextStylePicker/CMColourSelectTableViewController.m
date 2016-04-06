//
//  CMColourSelectTableViewController.m
//  CMTextStylePicker
//
//  Created by Chris Miles on 20/10/10.
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

#import "CMColourSelectTableViewController.h"

#import "CMColourBlockView.h"

#define kSelectedLabelTag	1001
#define kcolourViewTag		1002


@implementation CMColourSelectTableViewController

ARC_SYNTHESIZEOUTLET(delegate);
ARC_SYNTHESIZEAUTO(availableColours);
ARC_SYNTHESIZEAUTO(selectedColour);
ARC_SYNTHESIZEAUTO(identifier);

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	if (nil == self.title) {
		self.title = @"Text Colour";
	}
	
	self.availableColours = [NSArray arrayWithObjects:
							  [UIColor blackColor],
							  [UIColor darkGrayColor],
							  [UIColor grayColor],
							  [UIColor lightGrayColor],
							  [UIColor blueColor],
							  [UIColor redColor],
							  [UIColor greenColor],
							  [UIColor cyanColor],
							  [UIColor orangeColor],
							  [UIColor purpleColor],
							  [UIColor brownColor],
							  nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.availableColours count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
static NSString* const CellIdentifier = @"ColourSelectTableCell";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = ARC_AUTORELEASE([[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]);
		if (REQUIRED_NOT_NIL(cell))
			{
			CGRect frame = CGRectMake(15.0, 5.0, 25.0, cell.frame.size.height-10.0);
			UILabel *selectedLabel = [[UILabel alloc] initWithFrame:frame];
			selectedLabel.tag = kSelectedLabelTag;
			selectedLabel.font = [UIFont systemFontOfSize:24.0];
			selectedLabel.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.0];	// transparent
			[cell.contentView addSubview:selectedLabel];
			ARC_RELEASE(selectedLabel);
			
			frame = CGRectMake(55.0, 5.0, cell.frame.size.width-85.0, cell.frame.size.height-10.0);
			CMColourBlockView *colourView = [[CMColourBlockView alloc] initWithFrame:frame];
			colourView.tag = kcolourViewTag;
			[cell.contentView addSubview:colourView];
			ARC_RELEASE(colourView);
			}
    }
    
    // Configure the cell...
	UIColor *cellColour = [self.availableColours objectAtIndex:indexPath.row];
	CMColourBlockView *colourView = (CMColourBlockView *)[cell viewWithTag:kcolourViewTag];
	colourView.colour = cellColour;

	UILabel *selectedLabel = (UILabel *)[cell viewWithTag:kSelectedLabelTag];
	if ([self.selectedColour isEqual:cellColour]) {
		selectedLabel.text = @"✔";
	}
	else {
		selectedLabel.text = @"";
	}
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	self.selectedColour = [self.availableColours objectAtIndex:indexPath.row];
	
	if (REQUIRED_DELEGATE_SEL(self,colourSelectTableViewController:didSelectColour:))
		[self.delegate colourSelectTableViewController:self didSelectColour:self.selectedColour];
	[tableView reloadData];
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
}


- (void)dealloc {
	ARC_DEALLOC_NIL(self.availableColours);
	ARC_DEALLOC_NIL(self.selectedColour);
	ARC_SUPERDEALLOC(self);
}


@end

