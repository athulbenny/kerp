<?php
   
    $host = "localhost";

    // Give your username and password
    $username = "root";
    $password = "";

   // Give your Database name
    $dbname = "kerp";
   
    $connect=mysqli_connect($host,$username,$password,$dbname);
    // Check Connection
    if($connect->connect_error){
        die("Connection Failed: " . $connect->connect_error);
        return;
    }
 
    // Get all records from the database
    $table = mysqli_real_escape_string($connect, $_POST['tablename']);
    $id = mysqli_real_escape_string($connect, $_POST['id']);
    $sql = "UPDATE $table SET isVisited=1 WHERE id=$id ";
    $db_data = array();

    $result = $connect->query($sql);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        // Send back the complete records as a json
        echo json_encode($db_data);
    }else{
        //echo "error";
    }
    $connect->close();
    
    return;
 
?>