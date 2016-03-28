//
//  CMFontStyleSelectTableViewController.m
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

#import "CMFontStyleSelectTableViewController.h"

#define kSelectedLabelTag		1001
#define kFontNameLabelTag		1002


@implementation CMFontStyleSelectTableViewController

ARC_SYNTHESIZEOUTLET(delegate);
ARC_SYNTHESIZEAUTO(fontFamilyName);
ARC_SYNTHESIZEAUTO(fontNames);
ARC_SYNTHESIZEAUTO(selectedFont);

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];

	if (REQUIRED_NOT_NIL(self.fontFamilyName))
		{
		self.fontNames = [[UIFont fontNamesForFamilyName:self.fontFamilyName]
						  sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
		}
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
    return [self.fontNames count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
static NSString* const CellIdentifier = @"FontStyleSelectTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		if (REQUIRED_NOT_NIL(cell))
			{
			ARC_AUTORELEASE(cell);
		CGRect frame = CGRectMake(10.0, 5.0, 25.0, cell.frame.size.height-5.0);
		UILabel *selectedLabel = [[UILabel alloc] initWithFrame:frame];
			selectedLabel.tag = kSelectedLabelTag;
			selectedLabel.font = [UIFont systemFontOfSize:24.0];
			[cell.contentView addSubview:selectedLabel];
			ARC_RELEASE(selectedLabel);
			
			frame = CGRectMake(35.0, 5.0, cell.frame.size.width-70.0, cell.frame.size.height-5.0);
			UILabel *fontNameLabel = [[UILabel alloc] initWithFrame:frame];
			fontNameLabel.tag = kFontNameLabelTag;
			[cell.contentView addSubview:fontNameLabel];
			ARC_RELEASE(fontNameLabel);
			}
    }
    
    // Configure the cell...
	NSString *fontName = [self.fontNames objectAtIndex:indexPath.row];
	
	UILabel *fontNameLabel = (UILabel *)[cell viewWithTag:kFontNameLabelTag];
	fontNameLabel.text = fontName;
	fontNameLabel.font = [UIFont fontWithName:fontName size:16.0];
	
	UILabel *selectedLabel = (UILabel *)[cell viewWithTag:kSelectedLabelTag];
	if ([self.selectedFont.fontName isEqualToString:fontName]) {
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
	NSString *fontName = [self.fontNames objectAtIndex:indexPath.row];
	self.selectedFont = [UIFont fontWithName:fontName size:self.selectedFont.pointSize];
	
	if (REQUIRED_DELEGATE_SEL(self,fontStyleSelectTableViewController:didSelectFont:))
		[self.delegate fontStyleSelectTableViewController:self didSelectFont:self.selectedFont];
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
	ARC_DEALLOC_NIL(self.fontFamilyName);
	ARC_DEALLOC_NIL(self.fontNames);
	ARC_DEALLOC_NIL(self.selectedFont);
	ARC_SUPERDEALLOC(self);
}


@end

