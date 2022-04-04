
//  SignUpViewController.swift
//  TechTetva-19
//
//  Created by Naman Jain on 27/09/19.
//  Copyright © 2019 Naman Jain. All rights reserved.
//

import UIKit


struct RegisterResponse: Decodable{
    let success: Bool
    let msg : String?
}

enum msgResponse{
    case string(String)
    case array([String])
}
struct LeaveResponse: Decodable{
    let succes: Bool
    let msg: String
}


class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    var loginViewController: LoginViewController?
    
    lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Revels-Logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var nameField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var emailField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var phoneField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var collegeField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var courseName: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var branchName: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var passwordField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var regNo: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    lazy var registerButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Register", for: UIControl.State())
        button.backgroundColor = UIColor.CustomColors.Theme.themeColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return button
    }()
    
    lazy var guestButton: LoadingButton = {
        let button = LoadingButton(type: .system)
        button.setTitle("Continue as Guest", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.CustomColors.Theme.themeColor, for: UIControl.State())
        if isSmalliPhone(){
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        }else{
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        }
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var driveLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "Note: Enter publicly shareable google drive link with college ID uploaded for verification"
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = .systemRed
        return label
    }()
//
   
    var collegeSearchearchController = collegeSearchTableViewController()
    var searchController = UISearchController()
    var stateSearchController = StateTableViewController()
//    let navController = UINavigationController(rootViewController: stateSearchController)
    
    var colleges = [String]()
    var maheColleges = [String]()
    var filteredColleges = [String]()

    // MARK: - Table view data source Set Up College
    func setupColleges(){
//        let apiStruct = ApiStruct(url: collegeDataURL, method: .get, body: nil)
//        WSManager.shared.getJSONResponse(apiStruct: apiStruct, success: { (map: collegeDataResponse) in
//            if map.success{
//                for i in map.data{
//                    self.colleges.append(i.name)
//                    if(i.MAHE == 1)
//                    {
//                        self.maheColleges.append(i.name)
//                    }
//                }
//                self.colleges.sort()
//                self.maheColleges.sort()
//                self.filteredColleges = self.colleges
//            }
//        }) { (error) in
//            print(error)
//        }
        let collegeDetails = Caching.sharedInstance.getCollegesFromCache()
        //var name = [String]()
        for i in 0...(collegeDetails.count-1){
            colleges.append(collegeDetails[i+1]?.name ?? "Other Colleges")
            colleges.sort()
         
        }
        print("College Names: \(colleges)")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == collegeField {
            hideKeyboard()
            collegeSearchearchController.collegeDelegate = self
            collegeSearchearchController.colleges = self.colleges
            collegeSearchearchController.maheColleges = self.maheColleges
            collegeSearchearchController.filteredColleges = self.filteredColleges
            searchController = UISearchController(searchResultsController: collegeSearchearchController)
            searchController.searchResultsUpdater = collegeSearchearchController
            searchController.searchBar.barStyle = .blackTranslucent
            searchController.searchBar.backgroundImage = UIImage.init(color: .clear)
            searchController.searchBar.barTintColor = .black
            searchController.dimsBackgroundDuringPresentation = false
            searchController.hidesNavigationBarDuringPresentation = false

            present(searchController, animated: true, completion: nil)
            searchController.searchResultsController?.view.isHidden = false
            return false
        }
        
//        if textField == branchName{
//            hideKeyboard()
//            stateSearchController.stateDelegate = self
//            present(stateSearchController, animated: true, completion: nil)
////            searchController.searchResultsController?.view.isHidden = false
//            return false
//        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.CustomColors.Black.background
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        observeKeyboardNotifications()
        setupViews()
        setupColleges()
    }
    
    //MARK: -Set Up Ui
    func setupViews(){
        //Make the bordercolor changes here for the registration page
        //The logo looks blurry , get a high quality image to replace it
        nameField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Theme.themeColor,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        nameField.keyboardType = .default
        nameField.autocorrectionType = .no
        nameField.clipsToBounds = true
        nameField.delegate = self
        nameField.tag = 0
        nameField.attributedPlaceholder = NSAttributedString(string: "Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        emailField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Theme.themeColor,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        emailField.keyboardType = .emailAddress
        emailField.autocorrectionType = .no
        emailField.autocapitalizationType = .none
        emailField.clipsToBounds = true
        emailField.delegate = self
        emailField.tag = 1
        emailField.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        passwordField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Theme.themeColor,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        passwordField.keyboardType = .emailAddress
        passwordField.autocorrectionType = .no
        passwordField.autocapitalizationType = .none
        passwordField.clipsToBounds = true
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        passwordField.tag = 2
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        phoneField.configure(color: .white,
                             font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                             cornerRadius: isSmalliPhone() ? 20 : 25,
                             borderColor: UIColor.CustomColors.Theme.themeColor,
                             backgroundColor: UIColor.CustomColors.Black.background,
                             borderWidth: 1.0)
        phoneField.keyboardType = .phonePad
        phoneField.autocorrectionType = .no
        phoneField.autocapitalizationType = .none
        phoneField.clipsToBounds = true
        phoneField.delegate = self
        phoneField.tag = 3
        phoneField.attributedPlaceholder = NSAttributedString(string: "Phone Number", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        collegeField.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Theme.themeColor,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        collegeField.adjustsFontSizeToFitWidth = true
        collegeField.keyboardType = .default
        collegeField.autocorrectionType = .no
        collegeField.clipsToBounds = true
        collegeField.delegate = self
        collegeField.tag = 4
        collegeField.attributedPlaceholder = NSAttributedString(string: "College Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        branchName.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Theme.themeColor,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        branchName.keyboardType = .default
        branchName.autocorrectionType = .no
        branchName.clipsToBounds = true
        branchName.delegate = self
        branchName.tag = 5
        branchName.attributedPlaceholder = NSAttributedString(string: "Enter your branch Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        courseName.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Theme.themeColor,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        courseName.keyboardType = .default
        courseName.autocorrectionType = .no
        courseName.clipsToBounds = true
        courseName.delegate = self
        courseName.tag = 6
        courseName.attributedPlaceholder = NSAttributedString(string: "Enter course Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        regNo.configure(color: .white,
                            font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18),
                            cornerRadius: isSmalliPhone() ? 20 : 25,
                            borderColor: UIColor.CustomColors.Theme.themeColor,
                            backgroundColor: UIColor.CustomColors.Black.background,
                            borderWidth: 1.0)
        regNo.keyboardType = .numberPad
        regNo.autocorrectionType = .no
        regNo.clipsToBounds = true
        regNo.delegate = self
        regNo.tag = 6
        regNo.attributedPlaceholder = NSAttributedString(string: "Enter Registeration Number", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: isSmalliPhone() ? UIFont.systemFont(ofSize: 15) : UIFont.systemFont(ofSize: 18)
            ])
        
        
        
        
        if isSmalliPhone(){
//            view.addSubview(logoImageView)
//            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 70, heightConstant: 70)
            driveLabel.font = UIFont.systemFont(ofSize: 13)
            view.addSubview(nameField)
            _ = nameField.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 70, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            view.addSubview(emailField)
            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(passwordField)
            _ = passwordField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
//
            view.addSubview(phoneField)
            _ = phoneField.anchor(top: passwordField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(collegeField)
            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(branchName)
            _ = branchName.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(courseName)
            _ = courseName.anchor(top: branchName.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
            view.addSubview(regNo)
            _ = regNo.anchor(top: courseName.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 40)
            
        
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
            
            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 8, rightConstant: 32, widthConstant: 0, heightConstant: 40)
            
        }else{
            view.addSubview(logoImageView)
            _ = logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 32, leftConstant: 32, bottomConstant: 32, rightConstant: 32, widthConstant: 100, heightConstant: 100)
            view.addSubview(nameField)
            _ = nameField.anchor(top: logoImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 48, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(emailField)
            _ = emailField.anchor(top: nameField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(passwordField)
            _ = passwordField.anchor(top: emailField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)

            
            view.addSubview(phoneField)
            _ = phoneField.anchor(top: passwordField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            view.addSubview(collegeField)
            _ = collegeField.anchor(top: phoneField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(branchName)
            _ = branchName.anchor(top: collegeField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(courseName)
            _ = courseName.anchor(top: branchName.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(regNo)
            _ = regNo.anchor(top: courseName.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 40, bottomConstant: 0, rightConstant: 40, widthConstant: 0, heightConstant: 50)
            
            view.addSubview(guestButton)
            _ = guestButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 30)
            
            view.addSubview(registerButton)
            _ = registerButton.anchor(top: nil, left: view.leftAnchor, bottom: guestButton.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 32, bottomConstant: 16, rightConstant: 32, widthConstant: 0, heightConstant: 50)
            
        }
    }
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
//    @objc func keyboardHide(notification: NSNotification) {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
//            self.logoImageView.alpha = 1
//        }, completion: nil)
//        if self.view.frame.origin.y != 0 {
//               self.view.frame.origin.y = 0
//           }
//    }
    
//    @objc func keyboardShow(notification: NSNotification) {
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//
//            var y: CGFloat = -90
//            if self.isSmalliPhone(){
//                y = -50
//            }
//            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
//            self.logoImageView.alpha = 0
//        }, completion: nil)
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0 {
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                
                if nameField.isEditing{
                    self.view.frame.origin.y = 0
                }
                if emailField.isEditing{
                    self.view.frame.origin.y = 0
                }
                if passwordField.isEditing{
                    self.view.frame.origin.y = 0
                }
                if collegeField.isEditing{
                    self.view.frame.origin.y -= keyboardSize.height
                }
                if branchName.isEditing{
                    self.view.frame.origin.y -= keyboardSize.height
                }
                if courseName.isEditing{
                    self.view.frame.origin.y -= keyboardSize.height
                }
                if regNo.isEditing{
                    self.view.frame.origin.y -= keyboardSize.height

                }
                
                
                
             //   self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.tag)
        switch textField.tag {
        case 0:
            emailField.becomeFirstResponder()
            break
        case 1:
            passwordField.becomeFirstResponder()
            break
        case 2:
            phoneField.becomeFirstResponder()
            
            break
        case 3:
            collegeField.becomeFirstResponder()
            break
        case 4:
            //Made changes here
            branchName.becomeFirstResponder()
            break
        case 5:
            courseName.becomeFirstResponder()
            break
        case 6:
            regNo.becomeFirstResponder()
        case 7:
        hideKeyboard()
        default: break
        }
        return true
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    @objc func handleDismiss(){
        self.dismiss(animated: true)
    }
    
    //MARK: -Register Function
    @objc func handleRegister(){
        guard let name = nameField.text else { return }
        guard let email = emailField.text else { return }
        guard let password = passwordField.text else {return}
        guard let phone = phoneField.text else { return }
        guard let college = collegeField.text else { return }
        guard let branch = branchName.text else {return}
        guard let course = courseName.text else { return }
        guard let reg = regNo.text else {return}
        
        if name == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your Details", Color: .red, onPresentation: {
                self.nameField.becomeFirstResponder()
            }) {}
            return
        }
        
        if email == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Email Address", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        if validateEmail(enteredEmail: email) == false{
            FloatingMessage().floatingMessage(Message: "Invalid Email Address", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        if password == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Password", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        if validatePassword(enteredPassword: password) == false{
            FloatingMessage().floatingMessage(Message: "Password is too short", Color: .red, onPresentation: {
                self.emailField.becomeFirstResponder()
            }) {}
            return
        }
        
        
        
        if phone == ""{
            FloatingMessage().floatingMessage(Message: "Please enter Phone Number", Color: .red, onPresentation: {
                self.phoneField.becomeFirstResponder()
            }) {}
            return
        }
        
        if validatePhoneNumber(enteredNumber: phone) == false {
            FloatingMessage().floatingMessage(Message: "Invalid Phone Number", Color: .red, onPresentation: {
                self.phoneField.becomeFirstResponder()
            }) {}
            return
        }
        
        if college == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your College Name", Color: .red, onPresentation: {
                self.collegeField.becomeFirstResponder()
            }) {}
            return
        }
        
        if course == ""{
            FloatingMessage().floatingMessage(Message: "Please enter the course name", Color: .red, onPresentation: {
                self.courseName.becomeFirstResponder()
            }) {}
            return
        }
        
        if branch == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your branch", Color: .red, onPresentation: {
                self.branchName.becomeFirstResponder()
            }) {}
            return
        }
        
        if reg == ""{
            FloatingMessage().floatingMessage(Message: "Please enter your registeration no", Color: .red, onPresentation: {
                self.branchName.becomeFirstResponder()
            }) {}
            return
        }
        
        
        registerButton.showLoading()
        registerButton.activityIndicator.color = .white
        
        Networking.sharedInstance.registerUserWithDetails(name: name, email: email,mobile: phone, password:password, collname: college,course:course,regno: Int64(reg)!,branch:branch, dataCompletion: { (successString) in
            print(successString)
            FloatingMessage().longFloatingMessage(Message: "Successfully Registered", Color: UIColor.CustomColors.Purple.register, onPresentation: {
                self.hideKeyboard()
            }) {
                self.loginViewController?.emailField.text = email
                self.loginViewController?.passwordField.text = password
                self.navigationController?.popViewController(animated: true)
            }
            self.registerButton.hideLoading()
        },errorCompletion:{ (errorString) in
            FloatingMessage().floatingMessage(Message: errorString, Color: .red, onPresentation: {
            }) {}
            print(errorString)
            self.registerButton.hideLoading()
            return
        })
    }
    
    func validateEmail(enteredEmail: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func validatePhoneNumber(enteredNumber: String) -> Bool {
        let phoneNumberRegex = "^[6-9]\\d{9}$"
        let phonePredicate = NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex)
        return phonePredicate.evaluate(with: enteredNumber)
    }
    
    func validatePassword(enteredPassword: String) -> Bool {
        if(enteredPassword.count<8){
            return false
        }
        return true
    }
    
}


protocol collegeSelected
{
    func collegeTapped(name:String)
}

extension SignUpViewController: collegeSelected
{
    func collegeTapped(name: String) {
        
        searchController.dismiss(animated: true) {
            self.collegeField.text = name
            self.branchName.becomeFirstResponder()
        }
        
        searchController.dismiss(animated: false, completion: nil)
    }
}

extension SignUpViewController: StateSelected{
    
    func stateSelected(state: String) {
        stateSearchController.dismiss(animated: true) {
            self.branchName.text = state
            self.courseName.becomeFirstResponder()
        }
        stateSearchController.dismiss(animated: false, completion: nil)
        
    }
    
    
}

