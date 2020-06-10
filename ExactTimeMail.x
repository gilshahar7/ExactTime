@interface UIDateLabel : UILabel
@property (nonatomic, strong) NSDate *date;
@end

@interface MessageListCellView : UIView
@property (nonatomic, strong) UIDateLabel *dateLabel;
@end

static bool is24h;
static NSString *settingsPath = @"/var/mobile/Library/Preferences/com.gilshahar7.exacttimeprefs.plist";
static bool enabled;

%hook MessageListCellView
-(void)layoutSubviews{
	%orig;
	if(enabled){
		if(![self.dateLabel.text containsString:@":"]){
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			if(is24h){
				[dateFormatter setDateFormat:@" • HH:mm"];
			}else{
				[dateFormatter setDateFormat:@" • h:mm a"];
			}

			self.dateLabel.textAlignment = 1;
			self.dateLabel.numberOfLines = 1;
			self.dateLabel.text = [self.dateLabel.text stringByAppendingString:[dateFormatter stringFromDate:self.dateLabel.date]];
			[self.dateLabel sizeToFit];
			//calling %orig again is not the best thing to do but the label was not positioned correctly after sizing it to fit the new string. If you feel like helping me with this, send a pull request!
			%orig;
		}
	}
}
%end

%ctor{

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
 	enabled =  [[prefs objectForKey:@"mail"] boolValue];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [formatter stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
	is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
}
