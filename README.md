# Coconut

Coconut is a set of UIKit and Foundation extensions allowed by Futura library.
If you are looking for easy tu use reactive extensions for iOS or macOS you are in right place.

## Samples

Inputs and outputs for UILabel, UITextField, UITextView, UIButton UIViewController etc.

``` swift
class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let button: UIButton = .init()
        button.frame = .init(x: 50, y: 50, width: 250, height: 80)
        button.setTitle("BUTTON", for: .normal)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)

        let label: UILabel = .init()
        label.frame = .init(x: 50, y: 150, width: 250, height: 80)
        label.text = "LABEL"
        view.addSubview(label)

        let textField: UITextField = .init()
        textField.frame = .init(x: 50, y: 350, width: 250, height: 80)
        textField.text = "TEXT FIELD"
        textField.backgroundColor = .lightGray
        view.addSubview(textField)

        button.signalInput[titleFor: .normal] = textField.signal.text
        textField.signalInput.hidden =
            button.signal.tap
            .map { [weak textField] _ in !(textField?.isHidden ?? false) }
        label.signalInput.text =
            merge(
                textField.signal.text,
                button.signal.tap
                    .map { [weak textField] _ in textField?.text ?? "" }
            )
            .map { [weak textField] text in
                !(textField?.isHidden ?? false) ? text : "HIDDEN"
            }
    }
}

```

UIApplication, UIDevice and NotificationCenter support.

``` swift
 UIApplication.shared
    .signalOut.didBecomeActive
    .values { _ in
        print("Application active!")
    }

UIDevice.current
    .signalOut.orientation
    .values { orientation in
        print("Orientation change: \(orientation)")
    }

NotificationCenter.default
    .signalOut[notificationName: UIDevice.orientationDidChangeNotification]
    .values { notification in
        print("Orientation change notification: \(notification)")
    }
```

URLSession extension for better response support.

``` swift
let request: URLRequest = ...
URLSession.shared.dataTaskFuture(with: request)
    .value { response, data in
        print("Received response: \(response) with data: \(data)")
    }
    .error { _ in
        print("Received error")
    }
```