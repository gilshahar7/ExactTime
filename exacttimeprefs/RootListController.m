#include "RootListController.h"

@implementation RootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Root" target:self] retain];
	}

	return _specifiers;
}

-(void)apply{
    [self.view endEditing:YES];
}

@end
