#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>

@interface PSListController (iOS12Plus)
-(BOOL)containsSpecifier:(id)arg1;
@end

@interface ExactTimeprefsListController : PSListController
@property (nonatomic, retain) NSMutableDictionary *savedSpecifiers;
@end

@implementation ExactTimeprefsListController

- (id)readPreferenceValue:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	return (settings[specifier.properties[@"key"]]) ?: specifier.properties[@"default"];
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSString *path = [NSString stringWithFormat:@"/var/mobile/Library/Preferences/%@.plist", specifier.properties[@"defaults"]];
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:path]];
	[settings setObject:value forKey:specifier.properties[@"key"]];
	[settings writeToFile:path atomically:YES];
	CFStringRef notificationName = (CFStringRef)specifier.properties[@"PostNotification"];
	if (notificationName) {
		CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), notificationName, NULL, NULL, YES);
	}

	//Here we check if the switch is on based of the key of the PSSwitchCell, then hide the specifier
	//We then hide the cell using the id of it. If its already hidden we reinsert the cell below a certain specifier based on its ID
	NSString *key = [specifier propertyForKey:@"key"];
		if([key isEqualToString:@"notifications"]) {
			if([value boolValue]) {
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"96"]] afterSpecifierID:@"95" animated:YES];
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"97"]] afterSpecifierID:@"96" animated:YES];
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"98"]] afterSpecifierID:@"97" animated:YES];
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"99"]] afterSpecifierID:@"98" animated:YES];
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"100"]] afterSpecifierID:@"99" animated:YES];
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"101"]] afterSpecifierID:@"100" animated:YES];
				[self insertContiguousSpecifiers:@[self.savedSpecifiers[@"102"]] afterSpecifierID:@"101" animated:YES];
			} else if([self containsSpecifier:self.savedSpecifiers[@"96"]]) {
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"96"]] animated:YES];
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"97"]] animated:YES];
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"98"]] animated:YES];
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"99"]] animated:YES];
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"100"]] animated:YES];
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"101"]] animated:YES];
				[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"102"]] animated:YES];
		}
	}
}

- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"ExactTimeprefs" target:self] retain];
	}
	//Code to save certain specifiers
	//Add the id of the specifier to the chosenIDs array.
	//Only add the IDs of the specifiers you want to hide
	NSArray *chosenIDs = @[@"96", @"97", @"98", @"99", @"100", @"101", @"102"];
	self.savedSpecifiers = (!self.savedSpecifiers) ? [[NSMutableDictionary alloc] init] : self.savedSpecifiers;
	 for(PSSpecifier *specifier in _specifiers) {
		if([chosenIDs containsObject:[specifier propertyForKey:@"id"]]) {
		 [self.savedSpecifiers setObject:specifier forKey:[specifier propertyForKey:@"id"]];
		}
	}
	return _specifiers;
}

-(void)viewDidLoad {
  [super viewDidLoad];

  //From my testing, at this point we can't get the value of a specifier yet as they haven't loaded
  //Instead you can just read your switch value from your preferences file

  NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.gilshahar7.exacttimeprefs.plist"];
  if(![preferences[@"notifications"] boolValue] == true) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"96"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"97"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"98"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"99"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"100"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"101"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"102"]] animated:NO];
  }
}

-(void)reloadSpecifiers {
  [super reloadSpecifiers];

  //This will look the exact same as step 5, where we only check if specifiers need to be removed
  NSDictionary *preferences = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.gilshahar7.exacttimeprefs.plist"];
  if([preferences[@"notifications"] boolValue] == false) {
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"96"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"97"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"98"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"99"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"100"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"101"]] animated:NO];
		[self removeContiguousSpecifiers:@[self.savedSpecifiers[@"102"]] animated:NO];
  }
}

- (void)loadView {
    [super loadView];
    ((UITableView *)[self table]).keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
}

-(void)_returnKeyPressed:(id)arg1 { [self.view endEditing:YES]; }

-(void)apply{
	[self.view endEditing:YES];
}

- (void)sourceLink
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/gilshahar7/ExactTime"]];
}

- (void)donationLink
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.paypal.me/gilshahar7"]];
}


- (void)openTwitterWithUsername:(NSString*)username
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://twitter.com/%@", username]]];
}
- (void)openTwitter
{
    [self openTwitterWithUsername:@"gilshahar7"];
}

- (void)reddit {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.reddit.com/user/gilshahar7/"]];
}

- (void)sendEmail {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:gilshahardex99@gmail.com?subject=ExactTime"]];
}

@end

// vim:ft=objc
