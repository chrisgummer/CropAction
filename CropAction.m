//
//  CropAction.m
//  CropAction
//
//  Created by Chris Gummer on 29/05/10.
//  Copyright (c) 2010 Chris Gummer, All Rights Reserved.
//

#import "CropAction.h"
#import <Quartz/Quartz.h>

@implementation CropAction

static CGSize iPhonePortrait;
static CGSize iPhoneLandscape;
static CGSize iPhone4Portrait;
static CGSize iPhone4Landscape;
static CGSize iPhone5Portrait;
static CGSize iPhone5Landscape;
static CGSize iPadPortrait;
static CGSize iPadLandscape;
static CGSize iPadRetinaPortrait;
static CGSize iPadRetinaLandscape;
static CGFloat cropHeight;

- (void)cropImageAtPath:(NSString *)sourceImagePath {
	
	CGImageRef imageRef = [[[[NSImage alloc] initWithContentsOfFile:sourceImagePath]autorelease] CGImageForProposedRect:NULL context:NULL hints:NULL];
	CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
	if (CGSizeEqualToSize(imageSize, iPhonePortrait) ||
		CGSizeEqualToSize(imageSize, iPhoneLandscape) ||
		CGSizeEqualToSize(imageSize, iPhone4Portrait) ||
		CGSizeEqualToSize(imageSize, iPhone4Landscape) ||
		CGSizeEqualToSize(imageSize, iPadPortrait) ||
		CGSizeEqualToSize(imageSize, iPadLandscape) ||
		CGSizeEqualToSize(imageSize, iPadRetinaPortrait) ||
		CGSizeEqualToSize(imageSize, iPadRetinaLandscape) ||
        CGSizeEqualToSize(imageSize, iPhone5Portrait) ||
        CGSizeEqualToSize(imageSize, iPhone5Landscape)) {
        cropHeight = 20.0f;
        if (CGSizeEqualToSize(imageSize, iPhone4Portrait) ||
            CGSizeEqualToSize(imageSize, iPhone4Landscape) ||
            CGSizeEqualToSize(imageSize, iPhone5Portrait) ||
            CGSizeEqualToSize(imageSize, iPhone5Landscape) ||
            CGSizeEqualToSize(imageSize, iPadRetinaPortrait) ||
            CGSizeEqualToSize(imageSize, iPadRetinaLandscape)) {
            cropHeight *= 2.0f;
        }

		imageRef = CGImageCreateWithImageInRect(imageRef, CGRectMake(0.0f, cropHeight, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)));

		NSString *pathExtension = [sourceImagePath pathExtension];
		NSString *fileNameSuffix = [[self parameters] objectForKey:@"fileNameSuffix"];
		NSString *editImagePath = sourceImagePath;
		if (fileNameSuffix) {
			editImagePath = [[[sourceImagePath stringByDeletingPathExtension] stringByAppendingString:fileNameSuffix] stringByAppendingPathExtension:pathExtension];
		}
		NSURL *url = [NSURL fileURLWithPath:editImagePath];
		CGImageDestinationRef destination = CGImageDestinationCreateWithURL((CFURLRef)url, kUTTypePNG, 1, NULL);
		CGImageDestinationAddImage(destination, imageRef, NULL);
		CGImageDestinationFinalize(destination);
		CFRelease(destination);
	}
}

- (id)runWithInput:(id)input fromAction:(AMAction *)anAction error:(NSDictionary **)errorInfo {
	iPhonePortrait = CGSizeMake(320.0f, 480.0f);
	iPhoneLandscape = CGSizeMake(480.0f, 320.0f);
	iPhone4Portrait = CGSizeMake(640.0f, 960.0f);
	iPhone4Landscape = CGSizeMake(960.0f, 640.0f);
	iPhone5Portrait = CGSizeMake(640.0f, 1136.0f);
	iPhone5Landscape = CGSizeMake(1136.0f, 640.0f);
	iPadPortrait = CGSizeMake(768.0f, 1024.0f);
	iPadLandscape = CGSizeMake(1024.0f, 768.0f);
	iPadRetinaPortrait = CGSizeMake(1536.0f, 2048.0f);
	iPadRetinaLandscape = CGSizeMake(2048.0f, 1536.0f);
	
	NSArray *acceptedImageExtensions = [NSArray arrayWithObjects:@"png", @"tiff", @"jpg", @"jpeg", nil];
	
	// Add your code here, returning the data to be passed to the next action.
	for (NSString *path in input) {
		NSString *pathExtension = [[path pathExtension] lowercaseString];
		if ([acceptedImageExtensions containsObject:pathExtension]) {
			[self cropImageAtPath:path];
		}
	}
		
	return input;
}

@end
