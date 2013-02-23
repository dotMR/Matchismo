//
//  CardView.m
//  SetGame
//
//  Created by Mario Russo on 2/21/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "CardView.h"

@implementation CardView

-(void)setSuit:(NSString *)suit
{
    _suit = suit;
    [self setNeedsDisplay];
}

-(void)setRank:(NSUInteger)rank
{
    _rank = rank;
    [self setNeedsDisplay];
}

-(void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

- (UIBezierPath *) createContainingCardPath
{
    return [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:5.0];
}

- (void)drawRect:(CGRect)rect
{
    // ##########################
    // draw actual card
    // ##########################
    UIBezierPath *roundedRect = [self createContainingCardPath];
    [roundedRect addClip];
    
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if(self.faceUp)
    {
        [self drawCorners];
    }
    else
    {
        [[UIImage imageNamed:@"bear.jpg"] drawInRect:self.bounds];
    }
    
//    UIImage *cardBackImage = [UIImage imageNamed:@"bear.jpg"];
//    UIImage *emptyImage = [UIImage imageNamed:@"1x1-pixel.png"];
//    [cardButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
//    [cardButton setImage:cardBackImage forState:UIControlStateNormal];
//    [cardButton setImage:emptyImage forState:UIControlStateSelected];
//    [cardButton setImage:emptyImage forState:UIControlStateDisabled|UIControlStateSelected];
}

-(void) drawCorners
{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont systemFontOfSize:self.bounds.size.width * 0.20];
    
    NSAttributedString *cornerText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : cornerFont}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake(2.0, 2.0);
    textBounds.size = [cornerText size];
    [cornerText drawInRect:textBounds];
    
    [self pushContextAndRotateUpsideDown];
    [cornerText drawInRect:textBounds];
    [self popContext];
}

-(void)pushContextAndRotateUpsideDown
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}

-(void)popContext
{
    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

-(NSString *) rankAsString
{
    return [[self rankStrings] objectAtIndex:[self rank]];
}

-(NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

-(void) setup
{
    // init goes here
}

-(void) awakeFromNib
{
    [self setup];
}

@end
