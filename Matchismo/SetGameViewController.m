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
@property (strong, nonatomic) SetCardGame *game;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Score;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Flips;
@property (weak, nonatomic) IBOutlet UILabel *lbl_PlayByPlay;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allCards;
@end

@implementation SetGameViewController

- (SetCardGame *)game
{
    if(!_game) _game = [[SetCardGame alloc] initWithCardCount:self.allCards.count usingDeck:[[SetCardDeck alloc] init]];
    
    return _game;
}

- (void) setAllCards:(NSArray *)allCards
{
    _allCards = allCards;
    [self updateUI];
}

// TODO: does the getCardAtIndex() method really need to care about generic Cards here?
- (void) updateUI
{
    for (UIButton *cardButton in self.allCards) {
        Card *card = [self.game cardAtIndex:[self.allCards indexOfObject:cardButton]];
        
        if( [card isKindOfClass:[SetCard class]] )
        {
            SetCard *setCard = (SetCard *)card;
            
            [cardButton setAttributedTitle:[self getAttributedStringToRepresentCardWithRank:setCard.rank andShape:setCard.shape andFill:setCard.fillPattern andColor:setCard.color] forState:UIControlStateNormal];
            
            UIColor *borderColor = [UIColor grayColor];
            CGFloat borderWidth = 1;
            CGFloat cardAlpha = 1;
            
            if(card.isFaceUp)
            {
                borderColor = [UIColor greenColor];
                borderWidth = 2;
                cardAlpha = 0.35;
            }
            if (card.isUnplayable)
            {
                cardAlpha = 0.1;
            }

            cardButton.selected = card.isFaceUp;
            cardButton.enabled = !card.isUnplayable;
            cardButton.alpha = cardAlpha;
            [[cardButton layer] setBorderWidth:borderWidth];
            [[cardButton layer] setBorderColor:borderColor.CGColor];
        }
    }
    
    self.lbl_Score.text = [NSString stringWithFormat:@"Score: %d",self.game.score];
    self.lbl_Flips.text = [NSString stringWithFormat:@"Flips: %d",self.game.flipCount];
    self.lbl_PlayByPlay.attributedText = [self getPrettyPlayByPlayForSetGameHistory:self.game.gameHistory.lastObject];
}

- (NSAttributedString *) getPrettyPlayByPlayForSetGameHistory: (NSString *)recentGameHistory
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
- (UIColor *)getUIColorWithAlphaToRepresentCardWithColorId: (NSString *)colorId andFillPattern:(NSString *)fillPatternId
{
    UIColor *shapeColor = [UIColor grayColor];

    if( [colorId isEqualToString: @"Red"] ) shapeColor = [UIColor redColor];
    else if( [colorId isEqualToString: @"Blue"] ) shapeColor = [UIColor blueColor];
    else if( [colorId isEqualToString: @"Purple"] ) shapeColor = [UIColor purpleColor];
    
    return [shapeColor colorWithAlphaComponent: [self getAlphaValueForFillPattern:fillPatternId]];
}

- (CGFloat)getAlphaValueForFillPattern: (NSString *)fillPatternId
{
    if( [fillPatternId isEqualToString: @"Partial"] ) { return 0.4; }
    else { return 1; }
}

// TODO: reference Shape title in SetCard class
- (NSString *)getShapeStringToRepresentCardWithRank: (NSUInteger)rank andShape: (NSString *)shapeId
{
    NSString *baseShape = @"";
    
    if( [shapeId isEqualToString: @"Square"] ) baseShape = @"■";
    else if( [shapeId isEqualToString: @"Circle"] ) baseShape = @"●";
    else if( [shapeId isEqualToString:@"Triangle"] )baseShape = @"▲";
    
    return [@"" stringByPaddingToLength:rank withString:baseShape startingAtIndex:0];
}

- (IBAction)dealCards
{
    self.game = nil;
    [self updateUI];
}

- (IBAction)flipCard:(id)sender
{
    [self.game flipCardAtIndex:[self.allCards indexOfObject:sender]];
    [self updateUI];
}

@end
