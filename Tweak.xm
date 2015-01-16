#import <substrate.h>
#import <UIKit/UIKit.h>

// Code used from SpotlightSiri
// https://github.com/MohammadAG/iOS-SpotlightSiri
@interface SBSearchHeader
@property(readonly, retain, nonatomic) UITextField *searchField;
@end


@interface SBSearchViewController
- (void)_searchFieldEditingChanged;
@end


%hook SBSearchViewController
- (void)_searchFieldReturnPressed {
	SBSearchHeader *_searchHeader = MSHookIvar<SBSearchHeader*>(self, "_searchHeader");
	UITextField *searchField = _searchHeader.searchField;
	NSString *searchString = [searchField.text lowercaseString];
	NSString *myUrl = @"";
	NSString *my_bool = @"no";
	if ([searchString hasPrefix:[[@"g" lowercaseString] stringByAppendingString:@" "]])
	{
		searchString = [searchString stringByReplacingOccurrencesOfString:[[@"g" lowercaseString] stringByAppendingString:@" "] withString:@""];
		myUrl = @"http://www.google.com/search?q=";
		my_bool = @"search";

	}
	else if ([searchString hasPrefix:[[@"w" lowercaseString] stringByAppendingString:@" "]])
	{
		searchString = [searchString stringByReplacingOccurrencesOfString:[[@"w" lowercaseString] stringByAppendingString:@" "] withString:@""];
		myUrl = @"http://en.wikipedia.org/wiki/";
		my_bool = @"search";

	}

	if([my_bool isEqualToString: @"no"])
	{
		myUrl = searchString;
		%orig;
	}else if([my_bool isEqualToString: @"search"])
	{
		if (![[searchString stringByReplacingOccurrencesOfString:@" " withString:@""] isEqual:@""])
		{
			searchString=	[searchString stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
			myUrl=[myUrl stringByAppendingString:searchString];
			Class aClass = objc_getClass("UIApplication");
			[[aClass sharedApplication] openURL:[NSURL URLWithString:myUrl]];
			searchField.text = @"";
			[self _searchFieldEditingChanged];
		}
		else{
		searchString = myUrl;
		%orig;
		}
	}
	else
	{

	}
}

%end

