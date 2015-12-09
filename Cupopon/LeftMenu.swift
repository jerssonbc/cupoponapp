//
//  LeftMenu.swift
//  Cupopon
//
//  Created by Carlos Zarate on 11/30/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class LeftMenu: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var menuItems:[String] = ["Cupones","Mis Cupones","Mi Perfil","Cerrar Sesion"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menuItems.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) as!UITableViewCell
    	
        myCell.textLabel?.text = menuItems[indexPath.row]
    
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch(indexPath.row)
        {
        case 0:
            let principalPage = self.storyboard?.instantiateViewControllerWithIdentifier("ContainerVC") as! ContainerVC
            // gestiona la transicion com oun navigation controller
            let principalPageNav = UINavigationController(rootViewController: principalPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate?.window??.rootViewController = principalPageNav
            break
        case 1:
            break
        case 2:
            let perfilPage = self.storyboard?.instantiateViewControllerWithIdentifier("PerfilViewController") as! PerfilViewController
            let perfilPageNav = UINavigationController(rootViewController: perfilPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate
            appDelegate?.window??.rootViewController = perfilPageNav
            break
          
        case 3:
            NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioNombre")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioApellidos")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioEmail")
            NSUserDefaults.standardUserDefaults().removeObjectForKey("usuarioId")
            NSUserDefaults.standardUserDefaults().synchronize()
            
            let loginPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            let loginInNav = UINavigationController(rootViewController: loginPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate
            
            appDelegate?.window??.rootViewController=loginInNav
            
            break
        default:
            print("No existe la opcion")
            break
        }
    }
    

    

}
