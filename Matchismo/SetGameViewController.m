//
//  SetGameControllerViewController.m
//  Matchismo
//
//  Created by Mario Russo on 2/13/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "SetCardGame.h"
#import "SetCard.h"
#import <QuartzCore/QuartzCore.h>

@interface SetGameViewController ()

@end

@implementation SetGameViewController

-(Class) deckClassToInit
{
    return [SetCardDeck class];
}

-(Class) cardGameClassToInit
{
    return [SetCardGame class];
}

-(NSUInteger) startingCardCount
{
    return 20;
}

// TODO: does the getCardAtIndex() method really need to care about generic Cards here?
//-(void) updateUI
//{
//    for (UIButton *cardButton in self.allCards) {
//        Card *card = [self.game cardAtIndex:[self.allCards indexOfObject:cardButton]];
//        
//        if( [card isKindOfClass:[SetCard class]] )
//        {
//            SetCard *setCard = (SetCard *)card;
//            
//            [cardButton setAttributedTitle:[self getAttributedStringToRepresentCardWithRank:setCard.rank andShape:setCard.shape andFill:setCard.fillPattern andColor:setCard.color] forState:UIControlStateNormal];
//            
//            UIColor *borderColor = [UIColor grayColor];
//            CGFloat borderWidth = 1;
//            CGFloat cardAlpha = 1;
//            
//            if(card.isFaceUp)
//            {
//                borderColor = [UIColor greenColor];
//                borderWidth = 2;
//                cardAlpha = 0.35;
//            }
//            if (card.isUnplayable)
//            {
//                cardAlpha = 0.1;
//            }
//
//            cardButton.selected = card.isFaceUp;
//            cardButton.enabled = !card.isUnplayable;
//            cardButton.alpha = cardAlpha;
//            [[cardButton layer] setBorderWidth:borderWidth];
//            [[cardButton layer] setBorderColor:borderColor.CGColor];
//        }
//    }
//}

-(NSAttributedString *) getPrettyPlayByPlayForSetGameHistory: (NSString *)recentGameHistory
{    
    NSArray * words = [recentGameHistory componentsSeparatedByString:@" "];
    NSMutableAttributedString *prettyString = [[NSMutableAttributedString alloc] init];
    
    for (NSString *word in words)
    {
        SetCard *possibleCard = [SetCard initCardFromDehydratedString:word];
        if(possibleCard)
        {
            NSAttributedString *cardRepresentationToMakePretty = [self getAttributedStringToRepresentCardWithRank:possibleCard.rank andShape:possibleCard.shape andFill:possibleCard.fillPattern andColor:possibleCard.color];
            
            [prettyString appendAttributedString:cardRepresentationToMakePretty];
        }
        else
        {
            NSAttributedString *attr = [[NSAttributedString alloc] initWithString:word];
            [prettyString appendAttributedString:attr];
        }
        
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:@" "];
        [prettyString appendAttributedString:attr];
    }
    
    return prettyString;
}

-(NSAttributedString *)getAttributedStringToRepresentCardWithRank:(NSUInteger)rank andShape:(NSString *)shapeId andFill:(NSString *)fillPatternID andColor:(NSString *)colorId
{
    NSString *shapes = [self getShapeStringToRepresentCardWithRank:rank andShape:shapeId];
    NSDictionary *attribs = @{};
    
    if( [fillPatternID isEqualToString: @"Empty"] )
    {
        attribs = @{NSForegroundColorAttributeName: [self getUIColorWithAlphaToRepresentCardWithColorId:colorId andFillPattern:fillPatternID], NSStrokeWidthAttributeName: @7};
    }
    else if( [fillPatternID isEqualToString: @"Partial"] )
    {
        attribs = @{NSForegroundColorAttributeName : [self getUIColorWithAlphaToRepresentCardWithColorId:colorId andFillPattern:fillPatternID], NSStrokeWidthAttributeName: @-7};
    }
    else if( [fillPatternID isEqualToString: @"Solid"] )
    {
        attribs = @{NSForegroundColorAttributeName : [self getUIColorWithAlphaToRepresentCardWithColorId:colorId andFillPattern:fillPatternID], NSStrokeWidthAttributeName: @-3};
    }
    
    return [[NSAttributedString alloc] initWithString:shapes attributes:attribs];
}

// TODO: reference Shape color in SetCard class
-(UIColor *)getUIColorWithAlphaToRepresentCardWithColorId: (NSString *)colorId andFillPattern:(NSString *)fillPatternId
{
    UIColor *shapeColor = [UIColor grayColor];

    if( [colorId isEqualToString: @"Red"] ) shapeColor = [UIColor redColor];
    else if( [colorId isEqualToString: @"Blue"] ) shapeColor = [UIColor blueColor];
    else if( [colorId isEqualToString: @"Purple"] ) shapeColor = [UIColor purpleColor];
    
    return [shapeColor colorWithAlphaComponent: [self getAlphaValueForFillPattern:fillPatternId]];
}

-(CGFloat)getAlphaValueForFillPattern: (NSString *)fillPatternId
{
    if( [fillPatternId isEqualToString: @"Partial"] ) { return 0.4; }
    else { return 1; }
}

// TODO: reference Shape title in SetCard class
-(NSString *)getShapeStringToRepresentCardWithRank: (NSUInteger)rank andShape: (NSString *)shapeId
{
    NSString *baseShape = @"";
    
    if( [shapeId isEqualToString: @"Square"] ) baseShape = @"■";
    else if( [shapeId isEqualToString: @"Circle"] ) baseShape = @"●";
    else if( [shapeId isEqualToString:@"Triangle"] )baseShape = @"▲";
    
    return [@"" stringByPaddingToLength:rank withString:baseShape startingAtIndex:0];
}

@end
