//
//  CuponGeneradoViewController.swift
//  Cupopon
//
//  Created by Jersson on 11/29/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class CuponGeneradoViewController: UIViewController {
    
    @IBOutlet weak var codigoCuponLabel: UILabel!
    
   
    var codigoCupon :String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        codigoCuponLabel.text = codigoCupon
        
        
    }
   
    @IBAction func toggleMenu(sender: AnyObject) {
        //SNotificationCenter.defaultCenter().postNotificationName("toggleMenu", object: nil)
        let principalPage = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerVC
        self.presentViewController(principalPage, animated: true, completion: nil)
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
