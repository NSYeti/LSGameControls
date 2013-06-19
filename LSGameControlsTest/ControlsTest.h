//
//  ControlsTest.h
//  LSJoystickTest
//
//  Created by LS on 16/09/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "LSGameControls.h"


@interface ControlsTest : CCLayer {
    
    CGSize wins;
    
    LSJoypad *leftPad;
    LSJoystick *rightStick;
    LSButton *button1;
    LSButton *button2;
    
    float x;
    float y;
    
}

+ (CCScene *)scene;

@end
