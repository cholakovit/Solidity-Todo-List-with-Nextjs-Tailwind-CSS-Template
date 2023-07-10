// SPDX-License-Identifier: MIT
pragma solidity 0.8.15;

// task: { id: 0, taskText: 'clean', isDeleted: false }

contract TaskContract {
  event AddTask(address recepient, uint taskId);
  event DeleteTask(uint taskId, bool isDeleted);

  struct Task {
    uint id;
    string taskText;
    bool isDeleted;
  }

  Task[] private tasks;
  mapping(uint256 => address) taskToOwner;
  // {0: '0xqazi..7a'}
  // {1: '0xdavid..7a'}

  function addTask(string memory taskText, bool isDeleted) external {
    uint taskId = tasks.length;
    tasks.push(Task(taskId, taskText, isDeleted));
    taskToOwner[taskId] = msg.sender;
    emit AddTask(msg.sender, taskId);
  }

  // get tasks that are mine and not yet deleted
  function getMyTasks() external view returns (Task[] memory) {
    Task[] memory temporary = new Task[](tasks.length);
    uint counter = 0;

    // temporary [{taskText: 'hello', isDeleted: false}, empty]
    for(uint i = 0; i < tasks.length; i++) {
      if(taskToOwner[i] == msg.sender && tasks[i].isDeleted == false) {
        temporary[counter] = tasks[i];
        counter++;
      }
    }
    Task[] memory result = new Task[](counter);
    for(uint i = 0; i < counter; i++) {
      result[i] = temporary[i];
    }
    return result;
  }

  function deleteTask(uint taskId, bool isDeleted) external {
    if(taskToOwner[taskId] == msg.sender) {
      tasks[taskId].isDeleted = isDeleted;
      emit DeleteTask(taskId, isDeleted);
    }
  }
}

// TaskContract.addTask('walk the dog', false)