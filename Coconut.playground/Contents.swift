//: A UIKit based Playground for presenting user interface

import Foundation
import Coconut
import Futura
import PlaygroundSupport
import UIKit

class ViewController: UIViewController {
    let timer: TimedEmitter = .init(interval: 3)
    var dataSource: TableViewDataSource<String> = .init { (value) -> UITableViewCell in
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        cell.textLabel?.text = value
        return cell
    }
    
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let tableView: UITableView = .init()
        tableView.frame = .init(x: 0, y: 200, width: 400, height: 400)
        view.addSubview(tableView)
        
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

        let button: UIButton = .init()
        button.frame = .init(x: 50, y: 50, width: 250, height: 50)
        button.setTitle("BUTTON", for: .normal)
        button.setTitleColor(.black, for: .normal)
        view.addSubview(button)

        let label: UILabel = .init()
        label.frame = .init(x: 50, y: 100, width: 250, height: 50)
        label.text = "LABEL"
        view.addSubview(label)

        let textField: UITextField = .init()
        textField.frame = .init(x: 50, y: 150, width: 250, height: 50)
        textField.text = "TEXT FIELD"
        textField.backgroundColor = .lightGray
        view.addSubview(textField)

        button.signalIn[titleFor: .normal] = textField.signalOut.text
        textField.signalIn.hidden =
            button.signalOut.tap
            .map { [weak textField] _ in !(textField?.isHidden ?? false) }
        label.signalIn.text =
            merge(textField.signalOut.text,
                  button.signalOut.tap
                      .map { [weak textField] _ in textField?.text ?? "" })
            .map { [weak textField] text in
                !(textField?.isHidden ?? false) ? text : "HIDDEN"
            }
        self.view = view
    }
}

 PlaygroundPage.current.liveView = ViewController()
