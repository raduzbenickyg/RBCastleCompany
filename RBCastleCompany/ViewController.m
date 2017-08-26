//
//  ViewController.m
//  RBCastleCompany
//
//  Created by Raduz Benicky on 2017-08-25.
//  Copyright © 2017 Raduz Benicky. All rights reserved.
//

#import "ViewController.h"

static NSString *const kRBCastleBuiltByDefault = @"RBCastleBuiltByDefault";
static NSString *const kRBCastleBuiltOnValley = @"RBCastleBuiltOnValley";
static NSString *const kRBCastleBuiltOnPeak = @"RBCastleBuiltOnPeak";

typedef NS_ENUM(NSInteger, RBCastleLandType) {
    RBCastleLandTypePeak,
    RBCastleLandTypeValley,
};

@interface ViewController ()
@property (nonatomic, strong) NSMutableDictionary *streaks;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@end

@implementation ViewController

-(NSMutableDictionary *)streaks {
    if (!_streaks) {
        _streaks = [NSMutableDictionary new];
    }
    return _streaks;
}

int previousNumber = -1;
int peakStreak = 0;
int valleyStreak = 0;

- (int) fullCastlesCountFromArray: (NSDictionary *) dict {
    int defaultCastle = [[dict objectForKey:kRBCastleBuiltByDefault] intValue];
    int peakCastles = [[dict objectForKey:kRBCastleBuiltOnPeak] intValue];
    int valleyCastles = [[dict objectForKey:kRBCastleBuiltOnValley] intValue];
    return defaultCastle + peakCastles + valleyCastles;
}

- (int) castlesToBuildOnArea: (NSArray <NSNumber *> *) area {
    
    
    for (int counter = 0; counter < [area count]; counter = counter + 1) {
        
        NSNumber *obj = [area objectAtIndex:counter];
        int newNumber = obj.intValue;
        
        if (previousNumber == -1) {
            previousNumber = newNumber;
            [self.streaks setObject:@1 forKey:kRBCastleBuiltByDefault];
            continue;
        }
        
        else if (newNumber != previousNumber) {
            
            if (newNumber > previousNumber) {
                [self checkStreaksAndRecordFor:RBCastleLandTypeValley];
                peakStreak = peakStreak + 1;
            }
            else if (newNumber < previousNumber) {
                [self checkStreaksAndRecordFor:RBCastleLandTypePeak];
                valleyStreak = valleyStreak + 1;
            }
        }
        
        else if (newNumber == previousNumber) {
            
            if (peakStreak > 0) {
                peakStreak = peakStreak + 1;
                valleyStreak = 0;
            }
            else if (valleyStreak > 0) {
                valleyStreak = valleyStreak + 1;
                peakStreak = 0;
            }
        }
        
        previousNumber = newNumber;
    }
    
    int castlesCount = [self fullCastlesCountFromArray:self.streaks];
    return castlesCount;
}

- (void) checkStreaksAndRecordFor: (RBCastleLandType) type {
    
    switch (type) {
        case RBCastleLandTypePeak:
        {
            if (peakStreak > 0) {
                // peak streaks ends, record it. then reset.
                NSNumber *currentPeakStreaks = [self.streaks objectForKey:kRBCastleBuiltOnPeak];
                NSNumber *newPeakStreak = [NSNumber numberWithInteger:currentPeakStreaks.intValue + 1];
                [self.streaks setObject:newPeakStreak forKey:kRBCastleBuiltOnPeak];
                peakStreak = 0;
            }
        }
            break;
        case RBCastleLandTypeValley:
        {
            if (valleyStreak > 0) {
                // valley streaks ends, record it. then reset.
                NSNumber *currentValleyStreaks = [self.streaks objectForKey:kRBCastleBuiltOnValley];
                NSNumber *newValleyStreak = [NSNumber numberWithInteger:currentValleyStreaks.intValue + 1];
                [self.streaks setObject:newValleyStreak forKey:kRBCastleBuiltOnValley];
                valleyStreak = 0;
            }
        }
            break;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSArray *area = @[@2,@6,@6,@6,@3];
//    NSArray *area = @[@8,@5,@5,@8];
//    NSArray *area = @[@6,@1,@4];
//    NSArray *area = @[@8,@5,@5,@8,@2,@6,@6,@6,@3];
//    NSArray *area = @[@3, @3, @4, @8, @8, @5, @5, @7, @7, @8, @8, @6, @6, @6, @7, @5, @7, @5, @9];
    NSArray *area = @[@1, @2, @4, @4, @6, @1, @3, @3, @1, @1, @7, @8, @9, @9, @1, @3, @3, @2, @3, @5, @5, @5, @1, @1, @9];
    
    int castlesToBuild = [self castlesToBuildOnArea:area];
    NSString *resultString = [NSString stringWithFormat:@"Castles to build: %d", castlesToBuild];
    NSLog(@"resultString: %@", resultString);
    self.resultLabel.text = resultString;
}

@end
