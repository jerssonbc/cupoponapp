//
//  RegistroViewController.swift
//  Cupopon
//
//  Created by Jersson on 10/22/15.
//  Copyright © 2015 iweb2015. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController {
    
    
    @IBOutlet weak var userDniTextField: UITextField!
    
    @IBOutlet weak var userApellidosTextField: UITextField!
    
    
    @IBOutlet weak var userNombreTextField: UITextField!
    
    
    @IBOutlet weak var userEmailTextField: UITextField!
    
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    @IBOutlet weak var userPasswordRepeatTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func CancelarButtonTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func registrarButtonTapped(sender: AnyObject) {
        let userDni = userDniTextField.text
        let userApellido = userApellidosTextField.text
        let userNombre = userNombreTextField.text
        let userEmail = userEmailTextField.text
        let userPassword = userPasswordTextField.text
        let userPasswordRepeat = userPasswordRepeatTextField.text
        
        if (userPassword != userPasswordRepeat)
        {
            desplegarAlertaMensaje("Los password no son iguales")
            return
        }
        
        if(userDni!.isEmpty || userApellido!.isEmpty || userNombre!.isEmpty
            || userEmail!.isEmpty || userPassword!.isEmpty ){
                desplegarAlertaMensaje("Todos los campos para completar son requeridos")
                return
        }
        // enviar HTTP post
        //http://localhost/appcupopon/scripts/registroCliente.php
      
        // objeto que represetna a una url que puede ser de un recuros remoto
        let myUrl = NSURL(string: "http://localhost:8080/appcupopon/scripts/registroCliente.php");
        // para cargar una peticion independientemente del protoclo y el esquema
        let request = NSMutableURLRequest(URL: myUrl!);

        
        request.HTTPMethod = "POST";
        
        let postString = "dniUser=\(userDni!)&apellidosUser=\(userApellido!)&nombreUser=\(userNombre!)&emailUser=\(userEmail!)&passwordUser=\(userPassword!)";
        //encodificacion del cuerpo de la peticion
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding);
        
        // clase de una api que permite descargar contendi via http,
        // shared .. returna un objeto sesion singleton s
        // data.. crea una peticion basada en la especifia url reques
        NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data: NSData?, response : NSURLResponse?, error : NSError?) -> Void in
            
            // lanzar la ejecucion de un bloque en dicha cola en segudno plano
            dispatch_async(dispatch_get_main_queue()){
                if error != nil {
                    self.desplegarAlertaMensaje(error!.localizedDescription)
                    return
                }
                
                //var err: NSError?
                
                //err = nil
                do{
                var json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json {
                    
                    var userId = parseJSON["usuarioId"] as? String
                    
                    
                    if (userId != nil)
                    {
                        var myAlerta = UIAlertController(title: "Alerta", message: "Registro Exitoso", preferredStyle: UIAlertControllerStyle.Alert);
                        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default){
                            (action) in self.dismissViewControllerAnimated(true, completion: nil)
                        }
                        myAlerta.addAction(okAction);
                        self.presentViewController(myAlerta, animated : true, completion:nil)
                        
                    }else{
                        let errorMessage = parseJSON["message"] as? String
                        
                        if( errorMessage != nil)
                        {
                            self.desplegarAlertaMensaje(errorMessage!)
                        }
                        
                    }
                    }
                }catch{
                    //print(error)
                    print("Existe un erro")
                }
                
            }
        
        }).resume()
        
        
    }
    func desplegarAlertaMensaje(userMensaje : String){
        var myAlert = UIAlertController(title: "Alerta", message: userMensaje, preferredStyle: UIAlertControllerStyle.Alert);
        var okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil);
        myAlert.addAction(okAction);
        
        self.presentViewController(myAlert, animated: true, completion: nil);
        
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
