//
//  CardNameViewController.m
//  Matchismo
//
//  Created by Mario Russo on 2/5/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "MatchismoViewController.h"
#import "PlayingCardDeck.h"
#import "MatchismoCardGame.h"

@interface MatchismoViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allCards;
@end

@implementation MatchismoViewController

-(Deck *) createDeck
{
    return [[PlayingCardDeck alloc] init];
}

-(NSUInteger) startingCardCount
{
    return 16;
}

-(Class) cardGameClass
{
    return [MatchismoCardGame class];
}

-(void) setAllCards:(NSArray *)allCards
{
    _allCards = allCards;
    [self updateUI];
}

- (void) updateUI
{
    for (UIButton *cardButton in self.allCards) {
        Card *card = [self.game cardAtIndex:[self.allCards indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        UIImage *cardBackImage = [UIImage imageNamed:@"bear.jpg"];
        UIImage *emptyImage = [UIImage imageNamed:@"1x1-pixel.png"];
        [cardButton setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        [cardButton setImage:emptyImage forState:UIControlStateSelected];
        [cardButton setImage:emptyImage forState:UIControlStateDisabled|UIControlStateSelected];
    }
    
    [self updateScoreLabel:[NSString stringWithFormat:@"Score: %d",self.game.score]];
    [self updateFlipsLabel:[NSString stringWithFormat:@"Flips: %d",self.game.flipCount]];
    
    [self updateGameMessageLabel: [[NSAttributedString alloc] initWithString:self.game.gameHistory.lastObject]];
}

- (void) handleDealButtonPressed
{
    [super handleDealButtonPressed];
    [self updateUI];
}

- (IBAction)flipCard:(UIButton *)sender
{
    [self.game flipCardAtIndex:[self.allCards indexOfObject:sender]];
    [self updateUI];
}

@end
