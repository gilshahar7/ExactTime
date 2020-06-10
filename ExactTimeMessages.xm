@interface UIDateLabel : UILabel
@property (nonatomic, strong) NSDate *date;
@end
static bool is24h;
static NSString *settingsPath = @"/var/mobile/Library/Preferences/com.gilshahar7.exacttimeprefs.plist";
static bool enabled;

%hook CKConversationListCell
-(void)layoutSubviews{
	%orig;
	if(enabled){
		if(MSHookIvar<UIDateLabel *>(self, "_dateLabel")){
			UIDateLabel *dateLabel = MSHookIvar<UIDateLabel *>(self, "_dateLabel");
			if(![dateLabel.text containsString:@":"]){
				NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
				if(is24h){
					[dateFormatter setDateFormat:@" • HH:mm"];
				}else{
					[dateFormatter setDateFormat:@" • h:mm a"];
				}
				dateLabel.text = [dateLabel.text stringByAppendingString:[dateFormatter stringFromDate:dateLabel.date]];
			}
		}
	}
}
%end

%ctor{

	NSMutableDictionary *prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:settingsPath];
 	enabled =  [[prefs objectForKey:@"messages"] boolValue];

	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setLocale:[NSLocale currentLocale]];
	[formatter setDateStyle:NSDateFormatterNoStyle];
	[formatter setTimeStyle:NSDateFormatterShortStyle];
	NSString *dateString = [formatter stringFromDate:[NSDate date]];
	NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
	NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
	is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
}
