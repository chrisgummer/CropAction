//
//  CropAction.h
//  CropAction
//
//  Created by Chris Gummer on 29/05/10.
//  Copyright (c) 2010 Chris Gummer, All Rights Reserved.
//

#import <Cocoa/Cocoa.h>
#import <Automator/AMBundleAction.h>

@interface CropAction : AMBundleAction 
{
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo;

@end
