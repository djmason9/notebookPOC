//
//  Etext2CustomEditUIButton.m
//  NotebookPOC
//
//  Created by Mason, Darren J on 10/28/15.
//  Copyright (c) 2015 Mason, Darren J. All rights reserved.
//

#import "Etext2CustomEditUIButton.h"

@implementation Etext2CustomEditUIButton

-(id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        _userInfo = [NSMutableDictionary new];
        _userInfo[BUTTON_SELECTED]= @(NO); //default
    }
    return self;
}




@end
