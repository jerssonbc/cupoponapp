//
//  PerfilViewController.swift
//  Cupopon
//
//  Created by Jersson on 12/9/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class PerfilViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func toogleMenu(sender: AnyObject) {
        
        let principalPage = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerVC
        // gestiona la transicion com oun navigation controller
        let principalPageNav = UINavigationController(rootViewController: principalPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate
        appDelegate?.window??.rootViewController = principalPageNav
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
