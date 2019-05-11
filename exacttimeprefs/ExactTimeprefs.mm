#import <Preferences/PSListController.h>

@interface ExactTimeprefsListController: PSListController {
}
@end

@implementation ExactTimeprefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ExactTimeprefs" target:self] retain];
	}
	return _specifiers;
}

-(void)apply{
[self.view endEditing:YES];
}
@end

// vim:ft=objc
