//
//  CatalogTableViewCell.swift
//  yourProjectName
//
//  Created by Yaroslav on 04.12.2023.
//

import UIKit

final class CatalogTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = UILabel()
    private let photoImageView = CustomImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        [photoImageView, titleLabel].forEach {
            addSubview($0)
        }
        setVisualAppearance()
        setupImage()
        setupTitle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Life circle
extension CatalogTableViewCell {
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }
}

//MARK: - methods
extension CatalogTableViewCell {
    func cellConfigure(with route: CatalogUIModel) {
        let imageUUID = if (route.imageUUID == "00000000-0000-0000-0000-000000000000") {
            route.imageUUID + ".jpeg"
        } else {
            route.imageUUID
        }
        
        let imageUrl = "http://192.168.1.9:9000/images/\(imageUUID)"
        guard let photoUrl = URL(string: imageUrl) else {
            return
        }
        
        photoImageView.loadImage(with: photoUrl)
        titleLabel.text = route.name
    }
}

//MARK: - private methods
private extension CatalogTableViewCell {
    func setVisualAppearance() {
        photoImageView.contentMode = .scaleAspectFit // обрезаем фото
        photoImageView.clipsToBounds = true
        [titleLabel].forEach {
            $0.textAlignment = .center
            $0.numberOfLines = 0
            $0.font = UIFont(name: "Roboto", size: 17) // меняем шрифт
        }

        titleLabel.font = UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
    }

    func setupImage() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        photoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.4).isActive = true
    }

    func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 0).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 50).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -50).isActive = true
        titleLabel.sizeToFit()
    }
}
