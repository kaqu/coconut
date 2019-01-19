//
//  TableViewDataSource.swift
//  Coconut
//
//  Created by Kacper Kaliński on 19/01/2019.
//

import Futura
import UIKit

/// Simple UITableViewDataSource and TableViewDataSourceProtocol implementation with auto diffing and signals support.
public final class TableViewDataSource<Element>: NSObject, UITableViewDelegate, UITableViewDataSource, TableViewDataSourceProtocol {
    /// Data model backing associated table view.
    /// It will automatically make diff with previous model and update table view.
    /// You have to update it on main thread.
    public var model: [[Element]] {
        didSet {
            dispatchPrecondition(condition: .onQueue(.main))
            guard let tableView = tableView else { return }
            let (sectionDiff, inserts, updates, deletes) = diff(oldValue, model, match: elementMatch)
            tableView.performBatchUpdates({
                if sectionDiff > 0 {
                    tableView.insertSections(IndexSet(oldValue.count ..< (oldValue.count + sectionDiff)), with: .automatic)
                } else if sectionDiff < 0 {
                    tableView.deleteSections(IndexSet((oldValue.count + sectionDiff) ..< oldValue.count), with: .automatic)
                } else { /* nothing */ }
                if !updates.isEmpty {
                    tableView.reloadRows(at: updates, with: .automatic)
                } else { /* nothing */ }
                if !deletes.isEmpty {
                    tableView.deleteRows(at: deletes, with: .automatic)
                } else { /* nothing */ }
                if !inserts.isEmpty {
                    tableView.insertRows(at: inserts, with: .automatic)
                } else { /* nothing */ }
            })
        }
    }
    
    private var modelInputSignalCollector: SubscriptionCollector?
    /// - Warning: This field is public due to lack of Swift generics functionalities, do not use it directly
    /// please use signalIn.model instead
    public var modelInputSignal: Signal<[[Element]]>? {
        didSet {
            guard let modelInputSignal = modelInputSignal else { return modelInputSignalCollector = nil }
            let collector: SubscriptionCollector = .init()
            modelInputSignalCollector = collector

            modelInputSignal
                .collect(with: collector)
                .switch(to: OperationQueue.main)
                .values { [weak self] model in
                    guard let self = self else { return }
                    self.model = model
                }
        }
    }

    private weak var tableView: UITableView?
    private let elementMatch: (Element, Element) -> Bool
    private let cellBuilder: (Element) -> UITableViewCell

    
    /// Prepare data source
    ///
    /// - Parameters:
    ///   - initialData: data initially visible in table view
    ///   - elementMatch: function used to match elements when finding model diffs, `==` is default for Equatable elements
    ///   - cellBuilder: function used to transform data into cells
    public init(initialData: [[Element]] = [[]],
                elementMatch: @escaping (Element, Element) -> Bool,
                cellBuilder: @escaping (Element) -> UITableViewCell) {
        self.model = initialData
        self.elementMatch = elementMatch
        self.cellBuilder = cellBuilder
        super.init()
    }

    
    /// Setup given UITableView instance with this TableViewDataSource as data source
    /// and delegate. It takes all control of UITableView, do not change its data source or delegate
    /// manually. There can be only one active tableView at the time, setting new one disables previous usage.
    /// You have to update it on main thread.
    ///
    /// - Parameter tableView: tableView that will be set up
    public func setup(tableView: UITableView) {
        dispatchPrecondition(condition: .onQueue(.main))
        self.tableView?.dataSource = nil
        self.tableView?.delegate = nil
        tableView.dataSource = self
        tableView.reloadData()
        tableView.delegate = self
        self.tableView = tableView
    }

    public func numberOfSections(in _: UITableView) -> Int {
        return model.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard model.count > section else { return 0 }
        return model[section].count
    }

    public func tableView(_: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard model.count > indexPath.section else { return UITableViewCell() }
        guard model[indexPath.section].count > indexPath.row else { return UITableViewCell() }
        return cellBuilder(model[indexPath.section][indexPath.row])
    }
}

extension TableViewDataSource where Element: Equatable {
    public convenience init(initialData: [[Element]] = [[]],
                            cellBuilder: @escaping (Element) -> UITableViewCell) {
        self.init(initialData: initialData, elementMatch: ==, cellBuilder: cellBuilder)
    }
}

/// This a little hack to resolve generic parameter in where clause
/// `extension SignalConsumerAdapter where Subject: TableViewDataSource<Element>`
/// should not be used
public protocol TableViewDataSourceProtocol: class {
    associatedtype Element
    var modelInputSignal: Signal<[[Element]]>? { get set }
}

extension SignalConsumerAdapter where Subject: TableViewDataSourceProtocol {
    /// Model signal input - swaps current table view model.
    /// It automatically makes diff with previous model and updates table view.
    /// Yo don't have to use main thread for this signal, it will be forced internally.
    ///
    /// Assigning Signal to this property binds its output to subject property.
    /// If you assign signal while there was already any assigned signal the previous one
    /// will be replaced with new one.
    public var model: Signal<[[Subject.Element]]>? {
        get {
            return subject.modelInputSignal
        }
        set {
            subject.modelInputSignal = newValue
        }
    }
}
