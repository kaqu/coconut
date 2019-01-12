//: A UIKit based Playground for presenting user interface
  
import UIKit
import Futura
import Coconut
import PlaygroundSupport

class ViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

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
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = ViewController()
