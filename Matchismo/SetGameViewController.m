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
            
            [cardButton setAttributedTitle:[self getAttributedStringForCard:setCard] forState:UIControlStateNormal];
            
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
    self.lbl_PlayByPlay.text = self.game.gameHistory.lastObject;
}

-(NSAttributedString *)getAttributedStringForCard: (SetCard *)card
{
    NSString *shapes = [self getShapeStringForCard:card];
    NSDictionary *attribs = @{};

    if( [card.fillPattern isEqualToString: @"Empty"] )
    {
        attribs = @{NSForegroundColorAttributeName: [self getColorForCard:card],
                    NSStrokeWidthAttributeName: @7};
    }
    else if( [card.fillPattern isEqualToString: @"Partial"] )
    {
        attribs = @{NSForegroundColorAttributeName : [self getColorForCard:card],
                    NSStrokeWidthAttributeName: @-7};
    }
    else if( [card.fillPattern isEqualToString: @"Solid"] )
    {
        attribs = @{NSForegroundColorAttributeName : [self getColorForCard:card],
                    NSStrokeWidthAttributeName: @-3};
    }
    
    return [[NSAttributedString alloc] initWithString:shapes attributes:attribs];
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

- (UIColor *)getColorForCard: (SetCard *)card
{
    UIColor *shapeColor = [UIColor grayColor];
    
    // TODO: reference Shape color in SetCard class
    if( [card.color isEqualToString: @"Red"] ) shapeColor = [UIColor redColor];
    else if( [card.color isEqualToString: @"Blue"] ) shapeColor = [UIColor blueColor];
    else if( [card.color isEqualToString: @"Purple"] ) shapeColor = [UIColor purpleColor];
    
    return [shapeColor colorWithAlphaComponent: [self getAlphaForCard:card]];
}

- (NSString *) getShapeStringForCard: (SetCard *)card
{
    NSString *baseShape = @"";
    
    // TODO: reference Shape title in SetCard class
    if( [card.shape isEqualToString: @"Square"] ) baseShape = @"■";
    else if( [card.shape isEqualToString: @"Circle"] ) baseShape = @"●";
    else if( [card.shape isEqualToString:@"Triangle"] )baseShape = @"▲";
    
    return [@"" stringByPaddingToLength:card.rank withString:baseShape startingAtIndex:0];
}

- (CGFloat) getAlphaForCard: (SetCard *)card
{
    if( [card.fillPattern isEqualToString: @"Partial"] ) { return 0.4; }
    else { return 1; }
}

@end
