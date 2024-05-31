//
//  SettingsTableViewCell.swift
//  PhotoEditor
//
//  Created by Василий Вырвич on 30.05.24.
//

import UIKit
import SnapKit

final class SettingsTableViewCell: UITableViewCell {
    
    //MARK: - Variables
    static let key = "SettingsTableViewCell"
    
    private var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()

    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    private func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = 10
        addSubview(iconImageView)
        addSubview(titleLabel)
    }
    
    public func setUpCell(withModel text: TableModel) {
        iconImageView.image = UIImage(systemName: text.iconText)
        titleLabel.text = text.titleText
    }
    
    //MARK: - Contraints
    override func updateConstraints() {
        super.updateConstraints()
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(32)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
