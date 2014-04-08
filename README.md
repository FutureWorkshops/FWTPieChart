# FWTPieChart

The simplest way to include rich pie chart graphics in your iOS app.


## Installation

The best way to integrate FWTPieChart in your project is with CocoaPods. You can find more info about this dependency manager [here](http://cocoapods.org). Just add the following line to your **Podfile**.

```
pod 'FWTPieChart'
```

## How it works

You can init the view as usual, programatically or with the Xcode's interface builder. 

	FWTPieChartView *pieChartView = [[FWTPieChartView alloc] initWithFrame:pieChartFrame];

The next step is to add segments to the pie chart, segments which are represented by **FWTPieChartSegmentData** data structures containing the segment's value, color, inner text and outer text.

In the following example a 22% segment with blue color, "A" inner text and "2" outer text is initialized.

```
FWTPieChartSegmentData *firstSegment = [FWTPieChartSegmentData pieChartSegmentWithValue:@0.22f
                                                                                  color:[UIColor blueColor]
                                                                              innerText:@"A"
                                                                           andOuterText:@"2"];
```

*Note:* remember that the addition of all the values must be lower or equal than 1.f and the inner text must have one character length (inner and outer texts are optional).

Once the segments have been created just add them to the pie chart:

```
[pieChartView addSegment:firstSegment]
```

In addition, there are alternative ways to set a pie chart's segments:

- Setting the segments array

```
[pieChartView setSegments:@[firstSegment, secondSegment, thirdSegment]];
```
- If we don't want to keep track of the segments created, let the FWTPieChartView create the segments for us

```
[pieChartView addSegmentWithValue:@0.22f color:[UIColor blueColor] innerText:@"A" andouterText:@"2"];
``` 

In this moment the FWTPieChartView has everything it need to represent our data, you only need to refresh it to apply the changes:

```
[pieChartView reloadAnimated:NO withCompletionBlock:completionBlock];
```

As you can see this method has two parameters:

- The first one, **animated**, determines if the updated data must be presented performing an animation or not.
- The second and last parameter, **completionBlock**, is a non-mandatory block which will be called when the animation finishes. The following piece of code shows you an example of completion block:

```
void(^completionBlock)() = ^() {
    NSLog(@"Animation finished");
};
```

###Additional methods
Another useful methods to manage the pie chart's segments are:

- **- (void)removeSegment:(FWTPieChartSegmentData*)segmentData** : removes the given segment from the pie chart.
- **- (void)clearSegments** : removes all the segments in the pie chart.


## Customization
**FWTPieChartView** is a bit flexible, the following properties can be adjusted to make the component fit as much as possible into your app:

- **font**: UIFont used to draw the pie chart's texts. The font size provided doesn't matter as this is adjusted automatically.
- **shouldDrawSeparators**: Boolean value which determines if the line between segments must be drawn or not.
- **shouldDrawPercentages**: Boolean value which determines if the percentage underneath the outer text must be drawn or not.
- **innerCircleProportionalRadius**: Float value (between 0.f and 1.f) which defines the radius of the inner circle proportionally to the outer radius of the pie chart.
- **animationDuration**: float value which determines the duration of the animation in seconds.



# Screenshots

![](/Screenshots/screenshot-ios-1.png)
![](/Screenshots/screenshot-ios-2.png)

![](/Screenshots/screenshot-ios-4.png) 
![](/Screenshots/screenshot-ios-3.png) 
