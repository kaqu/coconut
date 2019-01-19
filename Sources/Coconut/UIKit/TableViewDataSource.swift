//
//  TableViewDataSource.swift
//  Coconut
//
//  Created by Kacper Kaliński on 19/01/2019.
//

import Futura
import UIKit

fileprivate let reusableCellIdentifier: String = "coconut.reusableCell"

/// Simple UITableViewDataSource and TableViewDataSourceProtocol implementation with auto diffing and signals support.
public final class TableViewDataSource<Element>: NSObject, UITableViewDelegate, UITableViewDataSource, TableViewDataSourceProtocol {
    public typealias Model = [[Element]]
    internal typealias Update = (model: Model, diff: TableViewDiff)

    /// Data model backing associated table view.
    /// It will automatically make diff with previous model and update table view.
    /// Changing model is thread safe operation.
    public var model: Model {
        get {
            Mutex.lock(mtx)
            defer { Mutex.unlock(mtx) }
            return _model
        }
        set {
            Mutex.lock(mtx)
            defer { Mutex.unlock(mtx) }
            updateFuture?.cancel()
            updateFuture =
                future(on: updateQueue) { () -> Update in
                    Mutex.lock(self.mtx)
                    defer { Mutex.unlock(self.mtx) }
                    return (model: newValue, diff: tableViewDiff(self._model, newValue, match: self.elementMatch))
                }
                .switch(to: DispatchQueue.main)
                .value { update in
                    Mutex.lock(self.mtx)
                    defer { Mutex.unlock(self.mtx) }
                    self._model = update.model
                    self.updateTableViewWith(diff: update.diff)
                }
        }
    }

    /// - Warning: This field is public due to lack of Swift generics functionalities, do not use it directly
    /// please use signalIn.model instead
    public var modelInputSignal: Signal<Model>? {
        didSet {
            guard let modelInputSignal = modelInputSignal else { return modelInputSignalCollector = nil }
            let collector: SubscriptionCollector = .init()
            modelInputSignalCollector = collector

            modelInputSignal
                .collect(with: collector)
                .values { [weak self] model in
                    guard let self = self else { return }
                    self.model = model
                }
        }
    }

    private var modelInputSignalCollector: SubscriptionCollector?

    private var updateFuture: Future<Update>?
    private let updateQueue: DispatchQueue = .init(label: "coconut.table.update.queue", qos: .userInteractive)

    private let mtx: Mutex.Pointer = Mutex.make(recursive: true)
    private var _model: Model = []
    private let elementMatch: (Element, Element) -> Bool
    private let cellSetup: (Element, UITableViewCell) -> UITableViewCell
    private let reusableCellClass: AnyClass
    private weak var tableView: UITableView?

    /// Prepare data source
    ///
    /// - Parameters:
    ///   - initialData: data initially visible in table view
    ///   - elementMatch: function used to match elements when finding model diffs, `==` is default for Equatable elements
    ///   - reusableCellClass: reusable cell class dequeued for setup from model, default is UITableViewCell
    ///   - cellBuilder: function used to transform data into cells
    public init(initialData: Model = [[]],
                elementMatch: @escaping (Element, Element) -> Bool,
                reusableCellClass: AnyClass = UITableViewCell.self,
                cellSetup: @escaping (Element, UITableViewCell) -> UITableViewCell) {
        self._model = initialData
        self.elementMatch = elementMatch
        self.reusableCellClass = reusableCellClass
        self.cellSetup = cellSetup
        super.init()
    }

    /// Setup given UITableView instance with this TableViewDataSource as data source
    /// and delegate. It takes all control of UITableView, do not change its data source or delegate
    /// manually. There can be only one active tableView at the time, setting new one disables previous usage.
    /// It registers given reusableCellClass for internal identifier for each used table view.
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
        tableView.register(reusableCellClass, forCellReuseIdentifier: reusableCellIdentifier)
        self.tableView = tableView
    }

    public func numberOfSections(in _: UITableView) -> Int {
        let model = self.model
        return model.count
    }

    public func tableView(_: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model = self.model
        guard model.count > section else { return 0 }
        return model[section].count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = self.model
        guard model.count > indexPath.section else { return UITableViewCell() }
        guard model[indexPath.section].count > indexPath.row else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableCellIdentifier, for: indexPath)
        return cellSetup(model[indexPath.section][indexPath.row], cell)
    }

    private func updateTableViewWith(diff: TableViewDiff) {
        guard let tableView = tableView else { return }
        let (sectionDiff, inserts, updates, deletes) = diff
        tableView.performBatchUpdates({
            switch sectionDiff {
                case .none: break
                case let .insert(indexSet):
                    tableView.insertSections(indexSet, with: .automatic)
                case let .delete(indexSet):
                    tableView.deleteSections(indexSet, with: .automatic)
            }
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

extension TableViewDataSource where Element: Equatable {
    /// Prepare data source for Equatable elements. `==` is default elementMatch function for Equatable elements.
    ///
    /// - Parameters:
    ///   - initialData: data initially visible in table view
    ///   - reusableCellClass: reusable cell class dequeued for setup from model, default is UITableViewCell
    ///   - cellBuilder: function used to transform data into cells
    public convenience init(initialData: Model = [[]],
                            reusableCellClass: AnyClass = UITableViewCell.self,
                            cellSetup: @escaping (Element, UITableViewCell) -> UITableViewCell) {
        self.init(initialData: initialData, elementMatch: ==, reusableCellClass: reusableCellClass, cellSetup: cellSetup)
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
