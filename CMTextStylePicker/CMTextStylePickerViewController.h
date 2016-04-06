//
//  CMTextStylePickerViewController.h
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
#import "RequiredFoundation.h"
#import <UIKit/UIKit.h>

#import "CMColourSelectTableViewController.h"
#import "CMFontSelectTableViewController.h"
#import "CMUpDownControl.h"

@class UIPopoverController;
@class CMColourBlockView;
@protocol CMTextStylePickerViewControllerDelegate;

@interface CMTextStylePickerViewController : UITableViewController <CMFontSelectTableViewControllerDelegate, CMColourSelectTableViewControllerDelegate> 

ARC_BEGIN_IVAR_DECL(CMTextStylePickerViewController)
ARC_IVAR_DECLAREAUTO(BOOL,defaultSettingsSwitchValue);
ARC_IVAR_DECLAREAUTO(UIColor*,selectedTextColour);
ARC_IVAR_DECLAREAUTO(UIColor*,selectedStrokeColour);
ARC_IVAR_DECLAREAUTO(UIFont*,selectedFont);
ARC_IVAR_DECLAREAUTO(NSArray*,tableLayout);
ARC_IVAR_DECLAREOUTLET(id<CMTextStylePickerViewControllerDelegate>,delegate);
ARC_IVAR_DECLAREOUTLET(UITableViewCell*,applyAsDefaultCell);
ARC_IVAR_DECLAREOUTLET(UIBarButtonItem*,doneButtonItem);
ARC_IVAR_DECLAREOUTLET(UITableViewCell*,colourCell);
ARC_IVAR_DECLAREOUTLET(UITableViewCell*,strokeColourCell);
ARC_IVAR_DECLAREOUTLET(CMColourBlockView*,colourView);
ARC_IVAR_DECLAREOUTLET(CMColourBlockView*,strokeColourView);
ARC_IVAR_DECLAREOUTLET(UITableViewCell*,defaultSettingsCell);
ARC_IVAR_DECLAREOUTLET(UISwitch*,defaultSettingsSwitch);
ARC_IVAR_DECLAREOUTLET(UITableViewCell*,fontCell);
ARC_IVAR_DECLAREOUTLET(CMUpDownControl*,fontSizeControl);
ARC_IVAR_DECLAREOUTLET(UITableViewCell*,sizeCell);
ARC_END_IVAR_DECL(CMTextStylePickerViewController)

@property (ARC_PROP_OUTLET)		id<CMTextStylePickerViewControllerDelegate> delegate;

@property (nonatomic, assign)	BOOL		defaultSettingsSwitchValue;
@property (ARC_PROP_STRONG)		UIColor		*selectedTextColour;
@property (ARC_PROP_STRONG)		UIColor		*selectedStrokeColour;
@property (ARC_PROP_STRONG)		UIFont		*selectedFont;

@property (ARC_PROP_OUTLET)		IBOutlet	UITableViewCell		*applyAsDefaultCell;
@property (ARC_PROP_OUTLET)		IBOutlet	UIBarButtonItem		*doneButtonItem;
@property (ARC_PROP_OUTLET)		IBOutlet	UITableViewCell		*colourCell;
@property (ARC_PROP_OUTLET)		IBOutlet	UITableViewCell		*strokeColourCell;
@property (ARC_PROP_OUTLET)		IBOutlet	CMColourBlockView	*colourView;
@property (ARC_PROP_OUTLET)		IBOutlet	CMColourBlockView	*strokeColourView;
@property (ARC_PROP_OUTLET)		IBOutlet	UITableViewCell		*defaultSettingsCell;
@property (ARC_PROP_OUTLET)		IBOutlet	UISwitch			*defaultSettingsSwitch;
@property (ARC_PROP_OUTLET)		IBOutlet	UITableViewCell		*fontCell;
@property (ARC_PROP_OUTLET)		IBOutlet	UILabel				*fontNameLabel;
@property (ARC_PROP_OUTLET)		IBOutlet	CMUpDownControl		*fontSizeControl;
@property (ARC_PROP_OUTLET)		IBOutlet	UITableViewCell		*sizeCell;

+ (CMTextStylePickerViewController *)textStylePickerViewController;
- (IBAction)doneAction;
- (IBAction)defaultTextSettingsAction:(UISwitch *)defaultSwitch;
- (IBAction)fontSizeValueChanged:(CMUpDownControl *)control;

- (UIPopoverController*)presentPopoverWithButtonBarItem:(UIBarButtonItem*)buttonBarItem popoverDelegate:(id<UIPopoverControllerDelegate>)popoverDelegate;

@end


@protocol CMTextStylePickerViewControllerDelegate <NSObject>
@optional
- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedFont:(UIFont *)font;
- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedTextColor:(UIColor *)textColor;
- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController userSelectedStrokeColor:(UIColor *)strokeColor;

- (void)textStylePickerViewControllerSelectedCustomStyle:(CMTextStylePickerViewController *)textStylePickerViewController;
- (void)textStylePickerViewControllerSelectedDefaultStyle:(CMTextStylePickerViewController *)textStylePickerViewController;

- (void)textStylePickerViewController:(CMTextStylePickerViewController *)textStylePickerViewController replaceDefaultStyleWithFont:(UIFont *)font textColor:(UIColor *)textColor strokeColor:(UIColor*)strokeColor;

- (void)textStylePickerViewControllerIsDone:(CMTextStylePickerViewController *)textStylePickerViewController;
@end
