<?php      
    $host = "localhost";  
    $user = "root";  
    $password = '';  
    $db_name = "kerp";  
      
    $connect = mysqli_connect($host, $user, $password, $db_name);  
    if(mysqli_connect_errno()) {  
        die("Failed to connect with MySQL: ". mysqli_connect_error());  
    }  


    $username = $_POST['username'];  
    $password = $_POST['password'];  
      
        //to prevent from mysqli injection  
        $username = stripcslashes($username);  
        $password = stripcslashes($password);  
        $username = mysqli_real_escape_string($connect, $username);  
        $password = mysqli_real_escape_string($connect, $password);  
      
        $sql = "select pid,isUser from accounts where username = '$username' and password = '$password'";  
        $result = mysqli_query($connect, $sql);  
        $row = mysqli_fetch_array($result, MYSQLI_ASSOC);  
        $count = mysqli_num_rows($result);  

        $db_data = array();

        $result = $connect->query($sql);
        if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        // Send back the complete records as a json
        
    }
          
        if($count == 1){  
            echo json_encode($db_data);  
        }  
        else{  
             
        } 
?>