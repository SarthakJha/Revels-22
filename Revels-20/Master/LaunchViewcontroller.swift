//
//  ViewController.swift
//  uicollectionview
//
//  Created by Tushar Tapadia on 22/07/20.
//  Copyright © 2020 Tushar Tapadia. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 195, height: 191))
        imageView.image = UIImage(named: "logo_dark")
        return imageView
    }()
    
    private let bgview:UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 130, height: 130))
        view.backgroundColor = .black
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.CustomColors.Black.card
        view.addSubview(imageView)
       // view.addSubview(bgview)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        //bgview.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
            self.animate()
        })
    }
    
    private func animate(){
//        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut, animations: {
//       self.bgview.center.x += self.view.bounds.width
//       },completion: { done in
        UIView.animate(withDuration: 1, animations: {
            let size = self.view.frame.size.width * 2.3
            let diffx = size - self.view.frame.size.width
            let diffy = self.view.frame.size.height - size
            
            
            self.imageView.frame = CGRect(x: -(diffx/2), y: diffy/2, width: size, height: size)
            
            self.imageView.alpha = 0
        },completion: { done in
            if done{
                DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {let viewC = MasterTabBarController()
                viewC.modalTransitionStyle = .crossDissolve
                viewC.modalPresentationStyle = .fullScreen
                self.present(viewC, animated: true)
                })
                
            }
        }
    )
        
    
    let viewC = MasterTabBarController()
}
}
