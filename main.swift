/**

Welcome to GDB Online.
GDB online is an online compiler and debugger tool for C, C++, Python, Java, PHP, Ruby, Perl,
C#, VB, Swift, Pascal, Fortran, Haskell, Objective-C, Assembly, HTML, CSS, JS, SQLite, Prolog.
Code, Compile, Run and Debug online from anywhere in world.

*/
import Foundation

infix operator ^^
extension Bool {
    static func ^^(lhs:Bool, rhs:Bool) -> Bool {
        if (lhs && !rhs) || (!lhs && rhs) {
            return true
        }
        return false
    }
}


class Todo {
    static var allTodos = [Int : Todo]()
    static var lastId: Int = 0;
    
    var id: Int
    var title: String
    var content: String
    var priority: Int
    var creationTime: Date
    var categoryName: String?
    
    init(_ title: String, _ content: String, _ priority: Int){
    self.id = Todo.lastId + 1;
    self.title = title
    self.content = content
    self.priority = priority
    self.creationTime = Date()
    self.categoryName = nil
    }
    
    static func createTodo(_ title: String, _ content: String, _ priority: Int) {
    let todo = Todo(title, content, priority)
    lastId += 1
    allTodos[lastId] = todo
    }
    
    static func getAllTodos() -> [Todo] {
        return Array(allTodos.values)
    }
    
    static func getTodoById(_ id: Int) -> Todo? {
        return allTodos[id]
    }
    
    func delete() {
        if let lastName = categoryName {
            if let category = Category.getCategoryByName(lastName) {
                category.removeTodo(id)
            }
        }
        Todo.allTodos[id] = nil
    }
    
    func setCategory(_ name: String) {
        if let lastName = categoryName {
            if let category = Category.getCategoryByName(lastName) {
                category.removeTodo(id)
            }
        }
        
        categoryName = name
    }

}

class Category {
    static var allCategories = [String : Category]()
    
    var name: String
    var todoIds: [Int]
    
    init(_ name: String) {
        self.name = name
        self.todoIds = [Int]()
    }
    
    static func createCategory(_ name: String) throws {
        if getCategoryByName(name) != nil {
            throw exception.invalidCategoryName
        }
        
        let category = Category(name)
        allCategories[name] = category
    }
    
    static func getCategoryByName(_ name: String) -> Category?{
        return allCategories[name]
    }
    
    func getTodos() -> [Todo]{
        var todos = [Todo]()
        for id in todoIds {
            if let todo = Todo.getTodoById(id) {
                todos.append(todo)
            }
        }
        
        return todos
    }
    
    func removeTodo(_ todoId: Int) {
        if let index = todoIds.firstIndex(of: todoId) {
            todoIds.remove(at: index)
        }
    }
    
    func isInCategory(_ searchTodoId: Int) -> Bool{
        for todoId in todoIds{
            if(todoId == searchTodoId){
                return true
            }
        }
        return false
    }
    
    func addTodo(_ todoId: Int){
        if(isInCategory(todoId)) {return}
        
        
        if let todo = Todo.getTodoById(todoId) {
            todoIds.append(todoId)
            todo.setCategory(name)
        }
    }
}

enum exception: Error {
    case invalidCategoryName
    case invalidTodoId
}

class Controller{

    var todoList = [Todo]()
    
    func createTodo(){
    
        print("Please enter title: ", terminator:"")
        let title = (readLine())!
        
        print("Please enter content: ", terminator:"")
        let content = (readLine())!
        
        print("Please enter priority: ", terminator:"")
        let priority_str = (readLine())!
        guard let priority = Int(priority_str) else {
            print("Priority should be a number!")
            return
        }
        
        Todo.createTodo(title, content, priority)
        
    }
    
    func showAllTodos() -> Bool{
        todoList = Todo.getAllTodos()
        return(showList())
    }
    
    func showAllCategories() -> Bool{
        let allCategories = Category.allCategories.keys
        if (allCategories.isEmpty) {
            print("there are no categories to show!")
            return false
        }
        
        
        
        print("----------------------------")
        var i = 1
        for name in allCategories {
            print("\(i). \(name)")
            i += 1
        }
        print("----------------------------")
        print("")
        
        return true
    }
    
    func editTodo(){
        if(!showAllTodos()) {return}
        
        print("Choose a todo (enter it's index): ", terminator:"")
        let index_str = (readLine())!
        guard let index = Int(index_str) else {
            print("Index should be a number!")
            return  
        }
        
        guard let todo = Todo.getTodoById(todoList[index-1].id) else {
            print("invalid id!")
            return
        }
        
        print("Which field do you want to change?(enter a number)")
        print("1.Title")
        print("2.Content")
        print("3.Priority")
        let fieldNum_str = (readLine())!
        guard let fieldNum = Int(fieldNum_str) else {
            print("your choice should be a number!")
            return  
        }
        
        
        print("please enter the new value: ", terminator:"")
        let newValue = (readLine())!
        
        switch fieldNum {
            case 1:
                todo.title = newValue
            case 2:
                todo.content = newValue
            case 3:
                guard let newPriority = Int(newValue) else {
                    print("Priority should be a number!")
                    return  
                }
                todo.priority = Int(newPriority)
            default:
            print("your choice is out of range")
        }
    }
    
    func deleteTodo(){
        if(!showAllTodos()) {return}
        
        print("Choose a todo (enter it's index): ", terminator:"")
        let index_str = (readLine())!
        guard let index = Int(index_str) else {
            print("Index should be a number!")
            return  
        }
        
        if let todo = Todo.getTodoById(todoList[index-1].id) {
            todo.delete()
        }
        
    }
    
    func sortList(){
        print("How do you prefer to sort the list? (enter a number)")
        print("1. By title")
        print("2. By priority")
        print("3. By date")
        let sortMethod_str = (readLine())!
        guard let sortMethod = Int(sortMethod_str) else {
            print("your choice should be a number!")
            return  
        }
        
        print("Do you want to sort the list in ascending order? (yes/ no)")
        let direction_str = (readLine())!
        var direction: Bool
        switch direction_str {
            case "yes":
                direction = false
            case "no":
                direction = true
            default:
                print("invalid input!")
                return
        }
        
        switch sortMethod{
            case 1://sort by title in ascending order
                todoList.sort{
                    ($0.title < $1.title)^^direction
                }
            case 2://sort by priority in ascending order
                todoList.sort{
                    ($0.priority < $1.priority)^^direction
                }
            case 3://sort by date in ascending order
                todoList.sort{
                    ($0.creationTime < $1.creationTime)^^direction
                }
            default://sort by date in ascending order
                todoList.sort{
                    ($0.creationTime < $1.creationTime)^^direction
                }
        }
        
        showList()
    }
    
    func createCategory(){
        print("Please enter the category name: ", terminator:"")
        let categoryName = (readLine())!
        do{
            try Category.createCategory(categoryName)
        }catch exception.invalidCategoryName {
            print("There ia another category with name: \(categoryName)")
        }catch{
            print("Undefined error!")
        }
    }
    
    func addTodoToCategory(){
        if(!showAllTodos()) {return}
        
        print("Choose a todo (enter it's index): ", terminator:"")
        let index_str = (readLine())!
        guard let index = Int(index_str) else {
            print("Index should be a number!")
            return  
        }
        
        if(!showAllCategories()) {return}
        print("Choose a category (enter its name)")
        let categoryName = (readLine())!
        
        if let category = Category.getCategoryByName(categoryName) {
            category.addTodo(todoList[index-1].id)    
        } else {
            print("invalid category name")
            return
        }
        
    }
    
    func showCategory(){
        if (!showAllCategories()) {return}
        
        print("Please enter the category name:")
        let categoryName = (readLine())!
        
        if let category = Category.getCategoryByName(categoryName) {
            todoList = category.getTodos()
            showList()
        } else {
            print("invalid category name")
        }
        
    }
    
    func showList() -> Bool{
        if todoList.isEmpty {
            print("There are no todos to show!")
            return false
        }
        
        print("----------------------------")
        var i = 1
        for todo in todoList{
            print("\(i). \(todo.title) (\(todo.priority))")
            print(todo.content)
            print("")
            i += 1
        }
        print("----------------------------")
        return true
    }
    
    
    func help(){
        print("Choose one of the following commands:")
        print("----------------------------")
        print("create todo")
        print("show all todos")
        print("edit todo")
        print("delete todo")
        print("sort list")
        print("create category")
        print("show all categories")
        print("show category")
        print("add todo to catgeory")
        print("help")
        print("exit")
        print("----------------------------")
    }

}

func main(){
    let controller = Controller()
    controller.help()
    var command = (readLine())!
    while command != "exit"{
        print("")
        switch command{
            case "create todo":
                controller.createTodo()
            case "show all todos":
                controller.showAllTodos()
            case "edit todo":
                controller.editTodo()
            case "delete todo":
                controller.deleteTodo()
            case "sort list":
                controller.sortList()
            case "create category":
                controller.createCategory()
            case "show all categories":
                controller.showAllCategories()
            case "show category":
                controller.showCategory()
            case "add todo to category":
                controller.addTodoToCategory()
            case "help":
                controller.help()
            default :
                print("Your command is invalid!")
                print("For showing valid commands, please enter help")
                print("")
        }
        
        command = (readLine())!
    }
    
    print("The executaion is finished!")
}

main()