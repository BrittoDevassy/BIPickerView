# BIPickerView

An action sheet style gallery picker view.

## ScreenShots
![enter image description here](https://github.com/BrittoDevassy/BIPickerView/blob/master/screenshot.png)


## Usage

**create BIPickerView  object**

```objective-c
BIPickerView *picker = [[BIPickerView alloc]initWithTitle:@"Select an Option" addLibraryTitle:@"Attach Photo" alternateTitle:@"Attach %ld photo" withActionTitles:@[@"Attach Video",@"Attach File"] cancelTitle:@"Cancel"];
picker.myPickerDelegate = self;
picker.maximunSelection = 5;
```

**show picker view**

```objective-c
[picker presentInView:self.view withCallback:^(BOOL success) {

}];
```


