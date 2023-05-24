<?php
   
    $servername = "localhost";

    // Give your username and password
    $username = "root";
    $password = "";

   // Give your Database name
    $dbname = "kerp";

  // Give your table name
    $table = "accounts"; // lets create a table named Employees.
     
    // Create Connection
    $connect = new mysqli($servername, $username, $password, $dbname);
    // Check Connection
    if($connect->connect_error){
        die("Connection Failed: " . $connect->connect_error);
        return;
    }
 
    // Get all records from the database
    $pid = mysqli_real_escape_string($connect, $_POST['pid']);
    $sql = "SELECT username,pid,adminid from $table where pid = '$pid' ";
    $db_data = array();

    $result = $connect->query($sql);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        // Send back the complete records as a json
        echo json_encode($db_data);
    }else{
        echo "error";
    }
    $connect->close();
    
    return;
 
?>