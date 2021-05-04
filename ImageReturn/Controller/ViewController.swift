//
//  ViewController.swift
//  ImageReturn
//
//  Created by GOZDE KARDAS on 2.05.2021.
//

import UIKit


class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var ImageView: UIImageView!
    
    var breeds : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        DogApi.requestBreedList( completionHandler: {(breeds, error) in
            
            self.breeds = breeds ?? []
            
            DispatchQueue.main.async {
                self.pickerView.reloadAllComponents()
                
            }
        })
    }
}

extension ViewController:
UIPickerViewDataSource,
    UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return breeds.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return breeds[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
            
        DogApi.requestRandomImage(breed: self.breeds[row], completionHandler: {(image, error) in
            
            DispatchQueue.main.async {
                self.ImageView.image = image
                
            }
        })
    }
}

