//
//  OneContactViewController.swift
//  TelDir-redux
//
//  Created by Diana Princess on 21.02.2023.
//

import UIKit
import SnapKit
import MessageUI
import ReSwift

class OneContactViewController: UIViewController {
    
    @IBOutlet private weak var contactImageView: UIImageView!
    @IBOutlet private weak var fullNameLabel: UILabel!
    @IBOutlet private weak var phoneLabel: UILabel!
    @IBOutlet private weak var cellLabel: UILabel!
    @IBOutlet private weak var mailLabel: UILabel!
    @IBOutlet private weak var imageLoadingActivityIndicator: UIActivityIndicatorView!
    private var imageURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageLoadingActivityIndicator.hidesWhenStopped = true
    }
    
    private func updateInfo(contactInfo: ContactDetailedInfo) {
        contactImageView.image = UIImage(systemName: "person.fill")
        fullNameLabel.text = contactInfo.fullname
        phoneLabel.text = "Телефон: +"+contactInfo.phone
        cellLabel.text = "Мобильный: +"+contactInfo.cell
        mailLabel.text = contactInfo.email
        imageURL = contactInfo.imageURL
        let action = HTTPRequest(resource: contactInfo.imageURL,method: .get, dataType: .imageData(.large))
        mainStore.dispatch(action)
    }
    // MARK: IBACtions for buttons
    @IBAction private func callPhoneNumber(_ sender: UIButton) {
        //presenter?.makeACall(type: .regular)
    }
    
    @IBAction private func callCellNumber(_ sender: UIButton) {
        //presenter?.makeACall(type: .cell)
    }
    
    @IBAction private func sendSMSToCellNumber(_ sender: UIButton) {
        //presenter?.sendSMS(type: .cell)
    }
    
    @IBAction private func sendSMSToPhoneNumber(_ sender: UIButton) {
        //presenter?.sendSMS(type: .regular)
    }
    
    // MARK: function for TapGestureRecognizer
    @objc private func enlargeImage(_ sender: UITapGestureRecognizer) {
        DispatchQueue.main.async {
            let vc = CustomModalViewController()
            guard let image = self.contactImageView.image else { return }
            vc.addImage(image: image)
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
    }
    
    func setRequestFailureView() {
        let alert = UIAlertController(title: "Не удалось загрузить изображение", message:  "Пожалуйста, проверьте подключение.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Повторить попытку", style: UIAlertAction.Style.default){_ in
            let action = HTTPRequest(resource: self.imageURL,method: .get, dataType: .imageData(.large))
            mainStore.dispatch(action)
        })
        self.present(alert, animated: true, completion: nil)
    }
}

extension OneContactViewController: StoreSubscriber {
    typealias StoreSubscriberStateType = OneContactState
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mainStore.subscribe(self) {
            $0.select {
                $0.oneContactState
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainStore.unsubscribe(self)
    }
    
    func newState(state: OneContactState) {
        switch state.contactInfoOptions {
        case .initial:
            break
        case .updated(let detailedInfo):
            updateInfo(contactInfo: detailedInfo)
        }
        switch state.image.state {
        case .notDownloaded:
            imageLoadingActivityIndicator.startAnimating()
        case .downloaded(let data):
            imageLoadingActivityIndicator.stopAnimating()
            guard let image = UIImage(data: data) else { return }
            self.contactImageView.image = image
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.enlargeImage(_:)))
            tapGestureRecognizer.numberOfTouchesRequired = 1
            self.contactImageView.isUserInteractionEnabled = true
            self.contactImageView.addGestureRecognizer(tapGestureRecognizer)
        case .failed:
            imageLoadingActivityIndicator.stopAnimating()
            setRequestFailureView()
        }
        
    }
}
