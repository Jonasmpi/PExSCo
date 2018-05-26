pragma solidity ^0.4.22;

contract ContractCollaborationManager{
    
    address supervisor;
    uint taskcount;
    uint collabcount;
    
    enum Tasktype { TASK,AND,OR}

    struct Collaborator {
        address resource;
        string organisation;
    }
    
    struct Task {
        address taskresource;
        bool completed;
        string activity;
        Tasktype tasktype;
        uint[] requirements;
    }    
    
    mapping(uint => Task) tasks;
    uint[] public tasksArray;    
    
    mapping(uint => Collaborator) collaborators;
    uint[] public collaboratorArray;
    
    
    function getCollaboratorById(uint _id) public view returns(address resource, string organisation){
        return(collaborators[_id].resource,collaborators[_id].organisation);
    }
    
    /*
    * @param: Address of the Collaborator and his Organisation
    */
    function addCollaborator(address _collaborator, string _organisation) public {
        //Only ContractOwner can add collaborators
        require(msg.sender == supervisor);
        Collaborator storage collaborator = collaborators[collabcount++];
        collaborator.resource = _collaborator;
        collaborator.organisation = _organisation;
        collaboratorArray.push(collaboratorArray.length);
    }
    /*
    * @Param: Creates a Task 
    */
    function createTask(string _activity,address _taskresource, Tasktype _tasktype, uint[] _requirements) public {
        require(msg.sender == supervisor);
        Task storage task = tasks[taskcount++];
        task.taskresource = _taskresource;
        task.completed = false;
        task.activity = _activity;
        task.tasktype = _tasktype;
        task.requirements = _requirements;
        tasksArray.push(taskcount)-1;
    }
    
    function getTasks() view public returns(uint[]){
        return tasksArray;
    }
    
    function getCollaborators() view public returns(uint[]){
        return collaboratorArray;
    }
    /*
    * @Param: sets a Task on completed if resource equal to taskresource
    */
    function setTaskOnCompleted(uint _id) public returns(bool success){
        uint tempcount;
        require(tasks[_id].taskresource == msg.sender);
        uint[] temprequire = tasks[_id].requirements;
        //START
        if(temprequire.length == 0){
            tasks[_id].completed = true;
            return true;
        }
        //TASK
        if(tasks[_id].tasktype == Tasktype.TASK){
            if(isTaskCompletedById(temprequire[0]) == true){
                tasks[_id].completed = true;
                return true;
            }
            else{
                return false;
            }
        }
        // AND
        if(tasks[_id].tasktype == Tasktype.AND){
            for(uint i = 0; i < temprequire.length ; i++){
                if(isTaskCompletedById(temprequire[i])==true){
                    tempcount++;
                }
            }
            if(tempcount == temprequire.length){
                tasks[_id].completed = true;
                return true;
            }
            else{ 
                return false;
                
            }
        }
        // OR
        if(tasks[_id].tasktype == Tasktype.OR){
            for(uint j = 0; j < temprequire.length ; j++){
                if(isTaskCompletedById(temprequire[j])==true){
                    tempcount++;
                }                
            }   
            if(tempcount > 0){
                tasks[_id].completed = true;
                return true;
            }
            else{
                return false;
            }
        }
    }
    /*
    * @param: ID of a Task
    * @returns: bool value if task is completed
    */    
    function isTaskCompletedById(uint _id) public view returns (bool success){
        if(tasks[_id].completed == true){
            return true;
        }
        else return false;
    }
    /*
    * @param: Id of a State
    * @returns: status and description of the Task
    */
    function getTaskById(uint _id) public view returns(bool status,
    string description,address stateowner, Tasktype tasktype,
    uint[] requirements){
        return(tasks[_id].completed,tasks[_id].activity,tasks[_id].taskresource,tasks[_id].tasktype,tasks[_id].requirements);
        
    }
    
    function getCollaboratorCount() public view returns (uint){
        return collabcount;
    }
    /*
    * @Returns: Amout of States in the Collaboration
    */
    function getTaskCount() public view returns(uint){
        return taskcount;
    }
 
    /*
    * Initialise the contract with 0 tasks and saves the creator as owner
    */
    constructor() public{
        taskcount = 0;
        supervisor = msg.sender;
    }
}
