//
//  CustomTableViewController.swift
//  SnapshotSharingSession
//
//  Created by Ambar Septian on 19/02/20.
//  Copyright © 2020 Ambar Septian. All rights reserved.
//

import UIKit

class CustomTableViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let tableView = CustomTableView(cellColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1))
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


class CustomTableView: UITableView {
    let cellColor: UIColor
    var count = 50

    init(cellColor: UIColor) {
        self.cellColor = cellColor
        super.init(frame: .zero, style: .plain)
        
        dataSource = self
        register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CustomTableView: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = cellColor
        cell.textLabel?.text = "\(indexPath.row)"
        cell.textLabel?.frame.origin.x = 40

        return cell
    }
}
