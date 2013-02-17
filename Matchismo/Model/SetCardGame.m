//
//  SetCardGame.m
//  Matchismo
//
//  Created by Mario Russo on 2/13/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetCardGame.h"
#import "SetCard.h"

@interface SetCardGame()
@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *matchCards;
@property (strong, nonatomic) NSMutableArray *gameHistory;
@property (nonatomic) int score;
@property (nonatomic) int flipCount;
@end

@implementation SetCardGame

- (NSMutableArray *)cards
{
    if(!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)matchCards
{
    if(!_matchCards) _matchCards = [[NSMutableArray alloc] init];
    return _matchCards;
}

- (void)recordGameAction:(NSString *)gameMove
{
    [self.gameHistory addObject:gameMove];
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];
    
    if(self) {
        for(int i=0; i < cardCount; i++) {
            Card *card = [deck drawRandomCard];
            
            if(!card) {
                self = nil;
            } else {
                self.cards[i] = card;
            }
        }
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

// TODO: should probably check here for SetCards
- (int) numPlayableFaceUpCards
{
    int numCards = 0;
    
    for(Card *card in self.cards)
    {
        if(card.isFaceUp && !card.isUnplayable)
        {
            numCards++;
        }
    }
    
    return numCards;
}

#define FLIP_COST (-1)
#define MISMATCH_PENALTY (-6)
#define MATCH_BONUS (12)

- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if([card isKindOfClass:[SetCard class]])
    {
        SetCard *setCard = (SetCard *)card;
        
        if(!setCard.isUnplayable)
        {
            Boolean noAction = true;
            
            if(!setCard.isFaceUp)
            {                
                self.flipCount++;
                self.score += FLIP_COST;
                [self recordGameAction:[NSString stringWithFormat:@"Flipped: %@", setCard.contents]];
                
                if(self.numPlayableFaceUpCards == 2)
                {
                    // trigger for update below
                    noAction = false;
                    
                    NSMutableArray * selectedCards = [[NSMutableArray alloc] init];
                    
                    for(Card *thisCard in self.cards)
                    {
                        if(thisCard.isFaceUp && !thisCard.isUnplayable && ![setCard isEqual:thisCard])
                        {
                            [selectedCards addObject:thisCard];
                        }
                    }
                    
                    int matchScore = (MATCH_BONUS*[setCard matchCards:selectedCards]);
                    NSString * action = [[NSString alloc] init];
                    
                    if(matchScore > 0)
                    {
                        action = [NSString stringWithFormat:@"Matched: %@", setCard.contents];
                        setCard.faceUp = setCard.unplayable = YES;
                        
                        for(Card *c in selectedCards)
                        {
                            c.faceUp = c.unplayable = YES;
                            action = [action stringByAppendingFormat:@" %@", c.contents];
                        }
                        
                        action = [action stringByAppendingFormat:@" :%d pts!", matchScore];
                    }
                    else
                    {
                        matchScore = MISMATCH_PENALTY;
                        action = [NSString stringWithFormat:@"No Match For: %@", setCard.contents];
                        
                        for(Card *c in selectedCards)
                        {
                            c.faceUp = c.unplayable = NO;
                            action = [action stringByAppendingFormat:@" %@", c.contents];
                        }
                    }
                    
                    self.score += matchScore;
                    [self recordGameAction:action];
                    [selectedCards removeAllObjects];
                }
            }
        
            if(noAction)
                setCard.faceUp = !setCard.isFaceUp;
        }
    }
}

@end
