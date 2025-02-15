import Foundation
//hello world would i like to see this,pending,date\nhello world would i like to see this,pending,date


extension [Int : Task]{
    func maxKey () -> Int {
        var max = 0;
        guard !self.isEmpty else {
            return 0
        }
        for  (id, _ ) in self {
            if id > max{
                max = id
            }
        }
        
        return max
    }
}
enum FileStatus:Error {
    case AlreadyThere
}
enum TaskStatus:String {
    case completed = "completed", pending = "pending", unknown = "unknown"
}

struct Task {
    var title: String
    var status: TaskStatus
    var dueDate: Date
    
    init( title: String, status: TaskStatus = .pending, dueDate: Date) {
        self.title = title
        self.status = status
        self.dueDate = dueDate
    }
}

class TaskManager {
    var task:  [Int:Task] = [:]
    func addTask (newTask taskMember:Task){
        task[task.maxKey() + 1] = taskMember
    }
    func addTask (title: String, status: TaskStatus = .pending, dueDate: Date, id: Int = -5 ) {
        let newTask = Task(title: title, status: status, dueDate: dueDate)
        if (id == -5){
            task[task.maxKey() + 1] = newTask
        } else {
            task[id] = newTask
        }
    }
}

func createFile() throws -> Int32{
    let path = "/Users/youssefashraf/Downloads/finalProject/tasks.txt"
    let fd = open(path, O_CREAT | O_RDWR , S_IRUSR | S_IWUSR | S_IRGRP | S_IROTH)
    if fd == -1 {
        throw FileStatus.AlreadyThere
    } else {
        return fd
    }
}

func openFile() -> Int32{
    let path = "/Users/youssefashraf/Downloads/finalProject/tasks.txt"
    var fd: Int32
    do {
       fd =  try createFile()
        
    } catch {
        
        fd = open(path, O_RDWR )
    }
    
    return fd
}

func fetchAllTask (content fullContent: String, taskManager: inout TaskManager){

    let allTask = fullContent.split(separator: "\n")
    
    for task in allTask {
        let tmp = task.split(separator: ",")
        let title = tmp[0]
        var status: TaskStatus
        switch tmp[1].lowercased() {
        case "pending":
            status = .pending
        case "completed":
            status = .completed
        default:
            status = .unknown
        }
        let dateList = tmp[2].split(separator: "/")
        var dateComponent = DateComponents()
        dateComponent.day = Int(dateList[0])
        dateComponent.month = Int(dateList[1])
        dateComponent.year = Int(dateList[2])
        let calendar = Calendar.current
        guard let dueDate = calendar.date(from: dateComponent) else { return }
        let id = Int(tmp[3]) ?? 0
        taskManager.addTask(title: String(title), status: status, dueDate: dueDate, id: id)
    }
}

func printDataToUser(manager: TaskManager){
    guard !manager.task.isEmpty else {
        print("\n                                       [ NO DATA TO SHOW ] ")

        return
    }
    var i = 1
    for task in manager.task {
        let calendar = Calendar.current
        let date = calendar.dateComponents([.year,.month,.day], from: task.value.dueDate)
        var dateInText = ""
        dateInText += "\(String(date.day ?? 0))/\(String(date.month ?? 0))/\(String(date.year ?? 0))"
        print("\(i)     \(task.value.title)", terminator: "")
        
        for _ in task.value.title.count ..< 43 {
            print(" ", terminator: "")
        }
        print("\(task.value.status)", terminator: "")
        for _ in task.value.status.rawValue.count ..< 16 {
            print(" ", terminator: "")
        }
        print("\(date.day ?? 0)/\(date.month ?? 0)/\(date.year ?? 0)",terminator: "")
        
        for _ in dateInText.count ..< 14 {
            print(" ", terminator: "")
        }
        print("|========   \(task.key)", terminator: "\n")
        i+=1
    }

}

func writeToFile (fd: Int32, taskManager: TaskManager){
    ftruncate(fd, 0)
    lseek(fd, 0, SEEK_SET)
    var content = ""
    
    for task in taskManager.task {
        let calendar = Calendar.current
        let dueDate = calendar.dateComponents([.year, .month, .day], from: task.value.dueDate)

        content += task.value.title + ","
        content += task.value.status.rawValue + ","
        content += "\(dueDate.day ?? 0)/\(dueDate.month ?? 0)/\(dueDate.year ?? 0),"
        content += String(task.key) + "\n"
    }
    
    let buffer = Array(content.utf8)
    write(fd, buffer, buffer.count)
}


let path = "/Users/youssefashraf/Downloads/finalProject/tasks.txt"
var fd = openFile()
var buffer = [UInt8](repeating: 0, count: 512)
var fullContent = ""
var bytesRead: Int
repeat {
     bytesRead = read(fd, &buffer, buffer.count)
    
    if bytesRead > 0 {
        if let content = String(bytes: buffer.prefix(bytesRead), encoding: .utf8) {
            fullContent += content
        }
    }
} while bytesRead > 0

var taskManager: TaskManager = TaskManager()
fetchAllTask(content: fullContent, taskManager: &taskManager)

var choice = 9


while choice != -1 {
    switch choice{
    case 1:
        print("--------------------------------------------------------------------------------------------------------" )
        print("+ Enter id to delete ", terminator: "")
        var id:Int
        var foundTask: Task? = nil
        var title: String = ""
        repeat {
            id = Int(readLine() ?? "") ?? -1
            foundTask = taskManager.task[id]
            
            if let task = foundTask {
                title = task.title
              taskManager.task[id] = nil
            } else {
                print("Please enter a valid id: ", terminator: "")
            }
        } while foundTask == nil
        print("[ Task with title: \"\(title)\" removed! ]")
    case 3:
        print("--------------------------------------------------------------------------------------------------------" )
        print("+ Enter id to Mark: ", terminator: "")
        var id:Int
        var foundTask: Task? = nil
        repeat {
            id = Int(readLine() ?? "") ?? -1
            foundTask = taskManager.task[id]
            
            if var task = foundTask {
                task.status = .completed
            } else {
                print("Please enter a valid id: ", terminator: "")
            }
        } while foundTask == nil
    case 0 :

        print("--------------------------------------------------------------------------------------------------------" )
        print("+     Title:       ", terminator: "")
        var title = readLine()
        print("")
        while (title?.count ?? 1) > 50 {
            print("+     !Enter smaller title:       ", terminator: "")
             title = readLine()
            print("")
        }
        
        print("+     Due Date: (day/month/year)       ", terminator: "")
        var date = readLine()?.split(separator: "/")
        
        var dateComonent = DateComponents()
        dateComonent.day = Int(date?[0] ?? "0")
        dateComonent.month = Int(date?[1] ?? "0")
        dateComonent.year = Int(date?[2] ?? "0")
        let calendar = Calendar.current
        
        while (Int(dateComonent.day ?? 0) == 0), Int(dateComonent.day ?? 0) < 0, Int(dateComonent.day ?? 0) > 31  {
            print("Please enter a valid date: ", terminator: "")
            date = readLine()?.split(separator: "/")
            
            var dateComonent = DateComponents()
            dateComonent.day = Int(date?[0] ?? "0")
            dateComonent.month = Int(date?[1] ?? "0")
            dateComonent.year = Int(date?[2] ?? "0")
        }

        while (Int(dateComonent.month ?? 0) == 0), Int(dateComonent.month ?? 0) < 0, Int(dateComonent.month ?? 0) > 12  {
            print("Please enter a valid month: ", terminator: "")
            date = readLine()?.split(separator: "/")
            
            var dateComonent = DateComponents()
            dateComonent.day = Int(date?[0] ?? "0")
            dateComonent.month = Int(date?[1] ?? "0")
            dateComonent.year = Int(date?[2] ?? "0")
        }
        
        while (Int(dateComonent.year ?? 0) == 0), Int(dateComonent.day ?? 0) < 0{
            print("Please enter a valid year: ", terminator: "")
            date = readLine()?.split(separator: "/")
            
            var dateComonent = DateComponents()
            dateComonent.day = Int(date?[0] ?? "0")
            dateComonent.month = Int(date?[1] ?? "0")
            dateComonent.year = Int(date?[2] ?? "0")
        }
        
        var dueDate = calendar.date(from: dateComonent)
        while dueDate ?? Date() < Date(){
            print("Please enter a valid date: ", terminator: "")
            date = readLine()?.split(separator: "/")
            
            var dateComonent = DateComponents()
            dateComonent.day = Int(date?[0] ?? "0")
            dateComonent.month = Int(date?[1] ?? "0")
            dateComonent.year = Int(date?[2] ?? "0")
            dueDate = calendar.date(from: dateComonent)
        }
        
         dueDate = calendar.date(from: dateComonent)
        print("")
        
        if let dueDate = dueDate, let title = title {
            taskManager.addTask(title: title, dueDate: dueDate)
        }
        
        
        fallthrough
        
        
    default:
    break
}
    print("--------------------------------------------------------------------------------------------------------",terminator: "\n\n")
    print("+     Title:                                     Status:         Due Date:     |======== [ TaskId: ]  ==")
    printDataToUser(manager:taskManager)
    print(" ")
    print("--------------------------------------------------------------------------------------------------------")
    print("=| Add Task: 0 |=====| Remove Task: 1 |==============| Mark As Complete: 3 |======== [ EXIT: -1 ] ==")
    print("--------------------------------------------------------------------------------------------------------")
    writeToFile(fd: fd, taskManager: taskManager)
    if let c = Int(readLine() ?? "9"), c < 4 && c > -2 {
        choice = c
    }
    
    
    
    }


