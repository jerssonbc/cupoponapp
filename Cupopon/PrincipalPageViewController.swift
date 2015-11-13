//
//  PrincipalPageViewController.swift
//  Cupopon
//
//  Created by Jersson on 10/30/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class PrincipalPageViewController: UIViewController {
    
    @IBOutlet weak var usuarioNombreCompletoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let usuarioNombre = NSUserDefaults.standardUserDefaults().stringForKey("usuarioNombre")
        let usuarioApellidos = NSUserDefaults.standardUserDefaults().stringForKey("usuarioApellidos")
        var usuarioNombreCompelto = usuarioNombre! + " " + usuarioApellidos!
        usuarioNombreCompletoLabel.text = usuarioNombreCompelto
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cerrarSesionTapped(sender: AnyObject) {
        NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioNombre")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioApellidos")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioEmail")
        NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioId")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        let loginInNav = UINavigationController(rootViewController: loginPage)
        
        let appDelegate = UIApplication.sharedApplication().delegate
        
        appDelegate?.window??.rootViewController=loginInNav
        
        
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
