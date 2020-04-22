//
//  SetHeadCell.swift
//  RoutineTimer
//
//  Created by Mariah Baysic on 4/23/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class SetHeadCell: UITableViewHeaderFooterView {

        
    let setLbl = UILabel(frame: .zero)
    let collapseBtn = UIButton(type: .system)
    let addBtn = UIButton(type: .system)
    let rowBtn = UIButton(type: .system)

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        let view = UIView(frame: .zero)
        view.backgroundColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(view)
        view.addSubview(collapseBtn)
        view.addSubview(addBtn)
        view.addSubview(rowBtn)
        view.addSubview(setLbl)

        collapseBtn.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        collapseBtn.tintColor = .systemBackground
        collapseBtn.translatesAutoresizingMaskIntoConstraints = false
        
        setLbl.font = UIFont(name: "AvenirNext", size: 15)
        setLbl.textColor = .systemBackground
        setLbl.translatesAutoresizingMaskIntoConstraints = false

        addBtn.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        addBtn.tintColor = .link
        addBtn.translatesAutoresizingMaskIntoConstraints = false

        rowBtn.backgroundColor = .clear
        rowBtn.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collapseBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            collapseBtn.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            collapseBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            collapseBtn.widthAnchor.constraint(equalToConstant: 40),
            
            addBtn.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            addBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            addBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            addBtn.widthAnchor.constraint(equalToConstant: 40),
            
            rowBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            rowBtn.leadingAnchor.constraint(equalTo: collapseBtn.trailingAnchor, constant: 0),
            rowBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            rowBtn.trailingAnchor.constraint(equalTo: addBtn.leadingAnchor, constant: 0),
            
            setLbl.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0),
            setLbl.leadingAnchor.constraint(equalTo: collapseBtn.trailingAnchor, constant: 0),
            setLbl.trailingAnchor.constraint(equalTo: addBtn.leadingAnchor, constant: 0),

            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
