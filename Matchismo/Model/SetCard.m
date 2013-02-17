//
//  SetCard.m
//  Matchismo
//
//  Created by Mario Russo on 2/13/13.
//  Copyright (c) 2013 theNumberTwo. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

- (NSString *)contents
{
    return [self dehydrateCardToString];
}

- (NSString *) dehydrateCardToString
{
    return [NSString stringWithFormat: @"[%d_%@_%@_%@]", self.rank, self.shape, self.fillPattern, self.color];
}

+ (SetCard *) initCardFromDehydratedString: (NSString *)dehydratedCard
{
    SetCard *newCard = nil;
    
    if( [dehydratedCard hasPrefix:@"["] && [dehydratedCard hasSuffix:@"]"])
    {
        NSRange startRange = [dehydratedCard rangeOfString:@"["];
        NSRange endRange = [dehydratedCard rangeOfString:@"]"];
        
        NSString *sub = [dehydratedCard substringWithRange: NSMakeRange(startRange.location+1, endRange.location-1)];
        
        // if string contains 3 '_' characters with non nill strings in between
        NSArray *parts = [sub componentsSeparatedByString:@"_"];
        
        if(parts.count == 4)
        {
            NSUInteger rank = [parts[0] integerValue];
            NSString *shapeId = (NSString *) parts[1];
            NSString *fillId = (NSString *) parts[2];
            NSString *colorId = (NSString *) parts[3];
            
            newCard = [[SetCard alloc] init];
            newCard.rank = rank;
            newCard.shape = shapeId;
            newCard.fillPattern = fillId;
            newCard.color = colorId;
            
            return newCard;
        }
    }
    
    return newCard;
}

+ (NSArray *)validRanks
{
    return @[@1, @2, @3];
}

+ (NSArray *)validColors
{
    return @[@"Red", @"Blue", @"Purple"];
}

+ (NSArray *)validFillPatterns
{
    return @[@"Empty", @"Partial", @"Solid"];
}

+ (NSArray *)validShapes
{
    return @[@"Circle", @"Square", @"Triangle"];
}

+ (NSUInteger)maxRank { return [self validRanks].count; }

- (int)matchCards:(NSArray *)cardsToCompare
{
    int score = 0;
    if( [cardsToCompare count] == 2)
    {
        SetCard *cardComp1 = cardsToCompare[0];
        SetCard *cardComp2 = cardsToCompare[1];
     
        if(cardComp1 && cardComp2)
        {
            Boolean ranksAreEqual = (self.rank == cardComp1.rank == cardComp2.rank);
            
            // TODO: This is not working right (3,2,3 is passing)
            Boolean ranksAreNotEqual = (self.rank != cardComp1.rank != cardComp2.rank);
            
            Boolean shapesAreEqual = [self isString1:[self shape] EqualToString2:[cardComp1 shape] EqualToString3:[cardComp2 shape]];
            Boolean shapesAreNotEqual = [self isString1:[self shape] NotEqualToString2:[cardComp1 shape] NotEqualToString3:[cardComp2 shape]];
            
            Boolean colorsAreEqual = [self isString1:[self color] EqualToString2:[cardComp1 color] EqualToString3:[cardComp2 color]];
            Boolean colorsAreNotEqual = [self isString1:[self color] NotEqualToString2:[cardComp1 color] NotEqualToString3:[cardComp2 color]];
            
            Boolean fillPatternsAreEqual = [self isString1:[self fillPattern] EqualToString2:[cardComp1 fillPattern] EqualToString3:[cardComp2 fillPattern]];
            Boolean fillPatternsAreNotEqual = [self isString1:[self fillPattern] NotEqualToString2:[cardComp1 fillPattern] NotEqualToString3:[cardComp2 fillPattern]];
            
            if(ranksAreEqual || ranksAreNotEqual)
            {
               if(shapesAreEqual || shapesAreNotEqual)
               {
                   if(colorsAreEqual || colorsAreNotEqual)
                   {
                       if(fillPatternsAreEqual || fillPatternsAreNotEqual)
                       {
                           score = 1;
                       }
                   }
               }
           }
        }
    }
    
    return score;
}

- (Boolean)isString1:(NSString *)str1 EqualToString2:(NSString *)str2 EqualToString3:(NSString *)str3
{
    return ([str1 isEqualToString:str2] && [str2 isEqualToString:str3]);
}

- (Boolean)isString1:(NSString *)str1 NotEqualToString2:(NSString *)str2 NotEqualToString3:(NSString *)str3
{
    return (![str1 isEqualToString:str2] && ![str2 isEqualToString:str3]);
}

@end
