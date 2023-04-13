//
//  AnotacaoViewController.swift
//  Notas Diarias
//
//  Created by Pedro Lucas de Almeida on 09/09/22.
//

import UIKit
import CoreData

class AnotacaoViewController: UIViewController {
    @IBOutlet weak var texto: UITextView!
    
    var context: NSManagedObjectContext!
    
    var anotacao: NSManagedObject!
    
    @IBAction func salvar(_ sender: Any) {
        if anotacao != nil { //atualização
            self.atualizarAnotacao()
        }else{
            self.salvarAnotacao()
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func salvarAnotacao()  {
        let novaAnotacao = NSEntityDescription.insertNewObject(forEntityName: "Anotacao", into: context)
        novaAnotacao.setValue( self.texto.text, forKey: "texto" )
        novaAnotacao.setValue( Date(), forKey: "data" )
        
        do{
            try context.save()
            print("Sucesso ao salvar anotacao!")
        } catch let erro {
            print("Erro ao salvar anotacao: \(erro.localizedDescription)")
        }
    }
    
    func atualizarAnotacao() {
        anotacao.setValue(self.texto.text, forKey: "texto")
        anotacao.setValue(Date(), forKey: "data")
        
        do{
            try context.save()
            print("Sucesso ao atualizar anotacao!")
        } catch let erro {
            print("Erro ao atualizar anotacao: \(erro.localizedDescription)")
        }
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.texto.becomeFirstResponder()
        
        if anotacao != nil {
            if let textoRecuperado = anotacao.value(forKey: "texto"){
                self.texto.text = String(describing: textoRecuperado)
            }
        }else{
            self.texto.text = ""
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext

    }
    


}
