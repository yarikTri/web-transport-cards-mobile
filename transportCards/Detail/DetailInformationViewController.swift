//
//  DetailInformationViewController.swift
//  yourProjectName
//
//  Created by Yaroslav on 11.12.2023.
//

import UIKit

class DetailInformationViewController: UIViewController {
    private let titleLabel: UILabel = UILabel()
    private let descriptionLabel: UILabel = UILabel()
    private let capacityLabel: UILabel = UILabel()
    private let scheduleLabel: UILabel = UILabel()
    private let routeLabel: UILabel = UILabel()
    private let intervalLabel: UILabel = UILabel()
    private let photoImageView = CustomImageView()
    private let detailInformatioModel = DetailInformatioModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemGray6
        [
            photoImageView,
            descriptionLabel,
            titleLabel,
            scheduleLabel,
            routeLabel,
            intervalLabel,
            capacityLabel,
        ]
            .forEach {
                view.addSubview($0)
            }
        
        setVisualAppearance()
        setupImage()
        setDescriptionLabel()
        setTitleLabel()
        setRouteLabel()
        setIntervalLabel()
        setScheduleLabel()
        setCapacityLabel()
    }
}

//MARK: - methods
extension DetailInformationViewController {
    func datailConfigure(with id: Int) {
        loadData(with: id)
    }
}

//MARK: - private methods
private extension DetailInformationViewController {
    func loadData(with id: Int) {
        detailInformatioModel.loadDetailInformation(with: id) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let route):
                DispatchQueue.main.async {
                    self.titleLabel.text = route.name
                    self.descriptionLabel.text = route.description
                    self.routeLabel.text = "Едет от \"\(route.start_station)\" до \"\(route.end_station)\""
                    self.scheduleLabel.text = "Расписание: с \(route.start_time) до \(route.end_time)"
                    self.intervalLabel.text = "Интервал - \(route.interval_minutes) минут"
                    self.capacityLabel.text = "Вместимость - \(route.capacity) человек"
                    
                    let imageUUID = if (route.image_uuid == "00000000-0000-0000-0000-000000000000") {
                        route.image_uuid + ".jpeg"
                    } else {
                        route.image_uuid
                    }
                    
                    let imageUrl = "http://192.168.1.9:9000/images/\(imageUUID)"
                    guard let photoUrl = URL(string: imageUrl) else {
                        return
                    }
                    
                    self.photoImageView.loadImage(with: photoUrl)
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
    func setVisualAppearance() {
        photoImageView.contentMode = .scaleAspectFit // обрезаем фото
        photoImageView.clipsToBounds = true
        [descriptionLabel, titleLabel].forEach {
            $0.numberOfLines = 0
            $0.font = UIFont(name: "Roboto", size: 20) // меняем шрифт
        }
    }
    
    func setupImage() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25).isActive = true
        photoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        photoImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
    }
    
    func setTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 15).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        titleLabel.sizeToFit()
    }
    
    func setDescriptionLabel() {
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        descriptionLabel.sizeToFit()
    }
    
    func setScheduleLabel() {
        scheduleLabel.translatesAutoresizingMaskIntoConstraints = false
        scheduleLabel.topAnchor.constraint(equalTo: routeLabel.bottomAnchor, constant: 10).isActive = true
        scheduleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        scheduleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        scheduleLabel.sizeToFit()
    }
    
    func setRouteLabel() {
        routeLabel.translatesAutoresizingMaskIntoConstraints = false
        routeLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10).isActive = true
        routeLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        routeLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        routeLabel.sizeToFit()
    }
    
    func setIntervalLabel() {
        intervalLabel.translatesAutoresizingMaskIntoConstraints = false
        intervalLabel.topAnchor.constraint(equalTo: scheduleLabel.bottomAnchor, constant: 10).isActive = true
        intervalLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        intervalLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        intervalLabel.sizeToFit()
    }
    
    func setCapacityLabel() {
        capacityLabel.translatesAutoresizingMaskIntoConstraints = false
        capacityLabel.topAnchor.constraint(equalTo: intervalLabel.bottomAnchor, constant: 10).isActive = true
        capacityLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        capacityLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        capacityLabel.sizeToFit()
    }
}
