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
        let label: UILabel = .init()
        let textField: UITextField = .init()

        /*...*/

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

Simple to use TableViewDataSource with auto diffing and signal support.

``` swift
class ViewController: UIViewController {
    let timer: TimedEmitter = .init(interval: 3)
    var dataSource: TableViewDataSource<String> = .init { (value) -> UITableViewCell in
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = value
        return cell
    }

    override func loadView() {
        let tableView: UITableView = .init()
        view = tableView

        dataSource.setup(tableView: tableView)

        dataSource.model =
            [
                ["Section 1 - Row 1", "Section 1 - Row 2", "Section 1 - Row 3"],
                ["Section 2 - Row 1"],
                ["Section 3 - Row 1", "Section 3 - Row 2"],
            ]

        dataSource.signalIn.model =
            timer.map { _ in
                (0 ... arc4random_uniform(4)).map { section in
                    (0 ... arc4random_uniform(20)).map { row in
                        return "Random \(section)-\(row) \(arc4random_uniform(3))"
                    }
                }
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