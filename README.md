<p align="center">
  <img width="300" height="300" src="https://caribesphaneron.com/wp-content/uploads/2024/04/capture_box_logo_v1.png">
</p>

## CaptureBox

&nbsp;&nbsp;&nbsp;&nbsp; **CaptureBox** is a package that turns your custom widgets into an image or a document file. It does this by wrapping your custom widget with a **RepaintBoundary** and converting the bytelist obtained from its rendering into centain file types (currently PNG, JPG and PDF).

&nbsp;&nbsp;&nbsp;&nbsp; You can either take the in-memory binary data for further usages or save them to a local directory by using the methods that start with "save". 

&nbsp;&nbsp;&nbsp;&nbsp; When it comes to PDFs, it's possible to make the rendered content available for printing. You can do that by calling "printPdf" method.

## Setup

&nbsp;&nbsp;&nbsp;&nbsp; **CaptureBox** is on [**_Pub_**](https://pub.dev/packages/capture_box). You can use it in your project by adding it to your `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  capture_box: ^1.0.0
```

&nbsp;&nbsp;&nbsp;&nbsp; Then, you install the plugin by executing the following command from inside your project directory:

```console
flutter pub get
```

## Examples

&nbsp;&nbsp;&nbsp;&nbsp; Let's say you want to generate a PNG image file from a red `Container` with a text saying "Example" in the middle. In order to to that, you need to import the `capture_box` library first:

```dart
import 'package:capture_box/capture_box.dart';
```   

&nbsp;&nbsp;&nbsp;&nbsp; Then, you need to declare a new `CaptureBoxController`:

```dart
final CaptureBoxController controller = CaptureBoxController();
```

&nbsp;&nbsp;&nbsp;&nbsp; After that, you can wrap a `Container` with a `CaptureBox` like such:

```dart
...
CaptureBox(
    controller: controller, 
    child: Container(
        color: Colors.red,
        child: const Text("Example"),
    )
),
...
```

&nbsp;&nbsp;&nbsp;&nbsp; Finally, you can execute the following method to generate the image file and save it to a user-defined directory:

```dart
controller.trySavePng(
    fileName: "example",
    onError: () => print("failed")
);
```

## Support for Apple Devices

&nbsp;&nbsp;&nbsp;&nbsp; Currently, there's no forecast for adding support to IOS ans MacOS platforms. There's no way to assure that the library's resources will work on Apple devices when the core developer of this package doesn't have access to these techlonogies for the purpose of testing.

&nbsp;&nbsp;&nbsp;&nbsp; Apple devices tend to be quite expensive, especially on countries under development. If you'd like to see this project having support for IOS and MacOS platforms, consider **sponsoring** this project. Check the `Sponsor` button at the top of this repository's page to see how.
  
## Support the Project

### Contributing

&nbsp;&nbsp;&nbsp;&nbsp; This project is being maintained by a **_sole developer_**. For now, there are no resources available to keep a frequent **_development_** and **_code review_** routine to guarantee that the code pulled by other developers won't compromise the library's principles.

&nbsp;&nbsp;&nbsp;&nbsp; Despite that, you can help this project by giving a **donation**. That way, this **_one-person_** _DevTeam_ can dedicate its time and effort to collaborate with the community by developing **_free_** and **_open-source_** software.

### Donating

&nbsp;&nbsp;&nbsp;&nbsp; If this package has helped adding value to your software or if you appreciated the initiative, consider giving a **_donation_** to help this project keep being **maintained** and **improved**.

&nbsp;&nbsp;&nbsp;&nbsp; When submitting a donation, you can leave a comment telling _us_ how this package has helped you and what could be done to make it even better. That would be much appreciated.

- **PayPal**   
    [![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif)](https://www.paypal.com/donate/?hosted_button_id=CXX5CKLZHNK3C)
- **Buy me a Coffee**   
    [!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/guscaribe)

...
