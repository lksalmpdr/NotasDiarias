//
//  ListarAnotacoesTableViewController.swift
//  Notas Diarias
//
//  Created by Pedro Lucas de Almeida on 09/09/22.
//

import UIKit
import CoreData

class ListarAnotacoesTableViewController: UITableViewController {

    var context: NSManagedObjectContext!
    var anotacoes: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        context = appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.recuperarAnontacoes()
    }
    
    func recuperarAnontacoes() {
        let requisicao = NSFetchRequest<NSFetchRequestResult>(entityName: "Anotacao")
        let ordenacao = NSSortDescriptor(key: "data", ascending: false)
        
        requisicao.sortDescriptors = [ordenacao]
        
        do{
            let anotacoesRecuperadas = try context.fetch(requisicao)
            
            self.anotacoes = anotacoesRecuperadas as! [NSManagedObject]
            self.tableView.reloadData()
            
        }catch let erro {
            print("Erro ao recuperar anotacoes \(erro.localizedDescription)")
        }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.anotacoes.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        let anotacao = self.anotacoes[indexPath.row]
        
        self.performSegue(withIdentifier: "verNota", sender: anotacao)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verNota" {
            let viewDestino = segue.destination as! AnotacaoViewController
            viewDestino.anotacao = sender as? NSManagedObject
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)

        let anotacao = self.anotacoes[indexPath.row]
        let texto = anotacao.value(forKey: "texto")
        let data = anotacao.value(forKey: "data")
        
        let dateFromatter = DateFormatter()
        dateFromatter.dateFormat = "dd/MM/yyyy hh:mm"
        let dataFormatada = dateFromatter.string(from: data as! Date)
        
        
        celula.textLabel?.text = texto as? String
        celula.detailTextLabel?.text = String(describing: dataFormatada)

        return celula
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let indice = indexPath.row
            //recuperando a anotação
            let anotacao = self.anotacoes[indice]
            //removendo do banco de dados
            self.context.delete(anotacao)
            //removendo do array do programa
            self.anotacoes.remove(at: indice)
            //removendo da tabela sem reloadData
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            
            do{
                try self.context.save()
            }catch let erro {
                print("Erro ao remover o item \(erro.localizedDescription)")
            }
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
