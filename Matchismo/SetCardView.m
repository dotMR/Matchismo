//
//  SetCardView.m
//  Matchismo
//
//  Created by Mario Russo on 2/23/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

-(void)setShape:(NSString *)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

-(void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
}

-(void)setFillPattern:(NSString *)fillPattern
{
    _fillPattern = fillPattern;
    [self setNeedsDisplay];
}

// TODO: update constant names, reference back to model rather than hard-code here
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    UIBezierPath *shapeToDraw;
    UIColor *colorToDraw;
    
    if( [self.color isEqualToString: @"Red"] ) colorToDraw = [UIColor redColor];
    else if( [self.color isEqualToString: @"Blue"] ) colorToDraw = [UIColor blueColor];
    else if( [self.color isEqualToString: @"Purple"] ) colorToDraw = [UIColor greenColor];
    
    if( [self.shape isEqualToString:@"Square"] ) { shapeToDraw = [self createDiamondCardPath]; }
    else if( [self.shape isEqualToString:@"Circle"] ) { shapeToDraw = [self createPillCardPath]; }
    else if( [self.shape isEqualToString:@"Triangle"] ){ shapeToDraw = [self createSquiggleCardPath]; }
    
    // DEBUG CODE
//    [self drawRankInCorner];
    
    if( [self.fillPattern isEqualToString:@"Solid"] )
    {
        [colorToDraw setFill];
        [shapeToDraw fill];
    }
    else if ( [self.fillPattern isEqualToString:@"Empty"] || [self.fillPattern isEqualToString:@"Partial"] )
    {
        [colorToDraw setStroke];
        [shapeToDraw setLineWidth:2];
        [shapeToDraw stroke];
        
        if( [self.fillPattern isEqualToString:@"Partial"] )
        {
            [shapeToDraw addClip];
            
            UIBezierPath *stripes = [self createStripeBackgroundPath];
            [stripes setLineWidth:0.5];
            [stripes stroke];
        }
    }
}

- (UIBezierPath *) createPillShapePathWithMidPoint:(CGPoint) midPoint width:(CGFloat)width height:(CGFloat)height
{
    CGFloat pillRadius = 12;
    return [UIBezierPath bezierPathWithRoundedRect:CGRectMake(midPoint.x-width/2, midPoint.y-height/2, width, height) cornerRadius:pillRadius];
}

- (UIBezierPath *) createDiamondShapePathWithMidPoint:(CGPoint) midPoint width:(CGFloat)width height:(CGFloat)height
{    
    UIBezierPath *diamond = [UIBezierPath bezierPath];
    [diamond moveToPoint:CGPointMake(midPoint.x, midPoint.y-height/2)];
    [diamond addLineToPoint:CGPointMake(midPoint.x+width/2, midPoint.y)];
    [diamond addLineToPoint:CGPointMake(midPoint.x, midPoint.y+height/2)];
    [diamond addLineToPoint:CGPointMake(midPoint.x-width/2, midPoint.y)];
    [diamond closePath];
    
    return diamond;
}

- (UIBezierPath *) createSquiggleShapePathWithMidPoint: (CGPoint)midPoint width:(CGFloat)width height:(CGFloat)height
{
    UIBezierPath *squiggle = [UIBezierPath bezierPath];
    
    // ---------------------------
    //     x1    x2   x3     x4
    // y1: |-----------|
    //     |           |
    // y2: |------|    |
    //            |    |
    // y3:        |    |------|
    //            |           |
    // y4:        |-----------|
    //
    // ---------------------------
    
    CGFloat modifier_shape_width = 0.32;
    CGFloat modifier_shape_height = 0.42;
    
    CGFloat y1 = midPoint.y - height/2;
    CGFloat y2 = y1 + (height*modifier_shape_height);
    CGFloat y4 = y1 + height;
    CGFloat y3 = y4 - (height*modifier_shape_height);
    
    CGFloat x1 = midPoint.x - width/2;
    CGFloat x2 = x1 + (width*modifier_shape_width);
    CGFloat x4 = x1 + width;
    CGFloat x3 = x4 - (width*modifier_shape_width);
    
    [squiggle moveToPoint:CGPointMake(x1,y1)];
    [squiggle addLineToPoint:CGPointMake(x3,y1)];
    [squiggle addLineToPoint:CGPointMake(x3,y3)];
    [squiggle addLineToPoint:CGPointMake(x4,y3)];
    [squiggle addLineToPoint:CGPointMake(x4,y4)];
    [squiggle addLineToPoint:CGPointMake(x2,y4)];
    [squiggle addLineToPoint:CGPointMake(x2,y2)];
    [squiggle addLineToPoint:CGPointMake(x1,y2)];
    [squiggle closePath];
    
    return squiggle;
}

// for debugging purposes
-(void) drawRankInCorner
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * 0.20];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", self.rank] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(2.0, 2.0);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
}

-(UIBezierPath *) createSquiggleCardPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat squiggleWidth = 44;
    CGFloat squiggleHeight = 18;
    
    for(int n=1;n<(self.rank+1);n=n+1)
    {
        CGPoint midPoint = CGPointMake(self.bounds.size.width/2,(n*self.bounds.size.height/(self.rank+1)));
        UIBezierPath *squiggle = [self createSquiggleShapePathWithMidPoint:midPoint width:squiggleWidth height:squiggleHeight];
        [path appendPath:squiggle];
    }
    
    return path;
}

- (UIBezierPath *) createPillCardPath
{
    CGFloat pillWidth = 44;
    CGFloat pillHeight = 18;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(int n=1;n<(self.rank+1);n=n+1)
    {
        CGPoint midPoint = CGPointMake(self.bounds.size.width/2,(n*self.bounds.size.height/(self.rank+1)));
        UIBezierPath *pill = [self createPillShapePathWithMidPoint:midPoint width:pillWidth height:pillHeight];
        [path appendPath:pill];
    }
    
    return path;
}

-(UIBezierPath *) createDiamondCardPath
{
    CGFloat diamondWidth = 44;
    CGFloat diamondHeight = 18;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    for(int n=1;n<(self.rank+1);n=n+1)
    {
        CGPoint midPoint = CGPointMake(self.bounds.size.width/2,(n*self.bounds.size.height/(self.rank+1)));
        UIBezierPath *diamond = [self createDiamondShapePathWithMidPoint:midPoint width:diamondWidth height:diamondHeight];
        [path appendPath:diamond];
    }
    
    return path;
}

-(UIBezierPath *) createStripeBackgroundPath
{
    UIBezierPath *stripes = [UIBezierPath bezierPath];
    
    for(int y=0;y<(self.bounds.size.height-3);y=y+3)
    {
        [stripes moveToPoint:CGPointMake(0, y)];
        [stripes addLineToPoint:CGPointMake(self.bounds.size.width, y)];
    }
    
    return stripes;
}


@end
