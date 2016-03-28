//
//  CMColourBlockView.m
//  CMTextStylePicker
//
//  Created by Chris Miles on 16/11/10.
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

#import "CMColourBlockView.h"

@interface CMColourBlockView()
@property (ARC_PROP_STRONG) UIColor* color;
@end

@implementation CMColourBlockView

ARC_SYNTHESIZEAUTO(color);
ARC_SYNTHESIZEAUTO(cornerRadius);

@dynamic colour;

- (void)setColour:(UIColor*)newColour {
	self.color = newColour;
	[self setNeedsDisplay];
}

- (UIColor*)colour {
	return self.color;
}

#pragma mark -

- (void)setCornerRadius:(CGFloat)newCornerRadius {
	_cornerRadius = newCornerRadius;
	[self setNeedsDisplay];
}

- (void)assignDefaults {
	_cornerRadius = 7.0;		// default
	self.opaque = NO;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])!=nil) {
        [self assignDefaults];
		}
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])!=nil) {
        [self assignDefaults];
		}
    return self;
}

- (void)drawRect:(CGRect)rect {
	UIColor*fillColor = self.colour;
	if (nil == fillColor) {
		fillColor = [UIColor blackColor];
	}
	
	CGContextRef c = UIGraphicsGetCurrentContext(); 
	CGPoint origin = self.bounds.origin;
	CGSize size = self.bounds.size;

const CGFloat cornerRadius = _cornerRadius;
	CGContextMoveToPoint(c, origin.x+size.width-cornerRadius, origin.y);
	CGContextAddArcToPoint(c, origin.x+size.width, origin.y, origin.x+size.width, origin.y+cornerRadius, cornerRadius);
	CGContextAddLineToPoint(c, origin.x+size.width, origin.y+size.height-cornerRadius);
	CGContextAddArcToPoint(c, origin.x+size.width, origin.y+size.height, origin.x+size.width-cornerRadius, origin.y+size.height, cornerRadius);
	CGContextAddLineToPoint(c, origin.x+cornerRadius, origin.y+size.height);
	CGContextAddArcToPoint(c, origin.x, origin.y+size.height, origin.x, origin.y+size.height-cornerRadius, cornerRadius);
	CGContextAddLineToPoint(c, origin.x, origin.y+cornerRadius);
	CGContextAddArcToPoint(c, origin.x, origin.y, origin.x+cornerRadius, origin.y, cornerRadius);
	CGContextClosePath(c);
	
	CGColorRef color = [fillColor CGColor];
	CGContextSetFillColorSpace(c, CGColorGetColorSpace(color));
	CGContextSetFillColor(c, CGColorGetComponents(color));
	CGContextDrawPath(c, kCGPathFill);
}

- (void)dealloc {
	ARC_DEALLOC_NIL(self.color);
	ARC_SUPERDEALLOC(self);
}

@end
