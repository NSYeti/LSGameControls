/*
 * LSGameControls: https://github.com/NSYeti/LSGameControls
 *
 * Copyright (c) 2012 Lee Scott
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#import <Foundation/Foundation.h>
#import "LSControl.h"


enum {
    LSButtonTypeNormal,
    LSButtonTypeToggle
};
typedef int LSButtonType;


//
//  DIGITAL BUTTON CLASS
//  --------------------
//

@interface LSButton : LSControl <CCTargetedTouchDelegate> {
    
    CGSize wins;
    
    LSButtonType type;
    
    int touchHash;
    int tapCount;
    
    NSTimeInterval startDuration;
    NSTimeInterval tapDuration;
    
    CGRect rect;
    
    CCSprite *normalSprite;
    CCSprite *selectedSprite;
    CCSprite *disabledSprite;
    
    int repeatRate;
    
    BOOL isSelected;
    BOOL isEnabled;
    
    BOOL willRepeat;

}

// The type of button.
@property (nonatomic, readonly) LSButtonType type;

// Whether the button is currently selected.
@property (nonatomic, assign) BOOL selected;

// Whether the button is currently disabled.
@property (nonatomic, assign) BOOL enabled;

// How many times the button was pressed for the last touch sequence.
@property (nonatomic, readonly) int tapCount;

// How long the button was held down for the last touch sequence.
@property (nonatomic, readonly) NSTimeInterval tapDuration;

// How many times per second the button will repeat (autofire). Set to 0 to disable. Maximum rate will be capped to 60.
// Has no effect if button type is LSButtonTypeToggle.
@property (nonatomic, assign) int repeatRate;

// The image used when the item is not selected.
@property (nonatomic, readonly) CCSprite *normalSprite;

// The image used when the item is selected.
@property (nonatomic, readonly) CCSprite *selectedSprite;

// The image used when the item is disabled.
@property (nonatomic, readonly) CCSprite *disabledSprite;

// Default inititializers.
// nil can be optionally passed in for both the selected and disabled sprites.
+ (id)buttonWithType:(LSButtonType)buttonType normalSprite:(CCSprite *)normal selectedSprite:(CCSprite *)selected disabledSprite:(CCSprite *)disabled;
- (id)initWithType:(LSButtonType)buttonType normalSprite:(CCSprite *)normal selectedSprite:(CCSprite *)selected disabledSprite:(CCSprite *)disabled;

@end
