<?php
$username="root";//change username 
$password=""; //change password
$host="localhost";
$db_name="kerp"; //change databasename

$connect=mysqli_connect($host,$username,$password,$db_name);

if(!$connect)
{
	echo json_encode("Connection Failed");
}

$username = mysqli_real_escape_string($connect, $_POST['username']);
$password = mysqli_real_escape_string($connect, $_POST['password']);
$pid = mysqli_real_escape_string($connect, $_POST['pid']);
$adminid = mysqli_real_escape_string($connect, $_POST['adminid']);
$isUser = mysqli_real_escape_string($connect, $_POST['isUser']);

    $query0="SELECT * FROM information_schema.tables WHERE table_name = '$adminid' AND table_schema='$db_name'";
    $result0=mysqli_query($connect,$query0);
    if($result0->num_rows>0 or $isUser==0){
        $query = "INSERT INTO accounts (username,password,pid,isUser,adminid)
                VALUES('$username','$password','$pid','$isUser','$adminid') ";
        $results = mysqli_query($connect, $query);
        if($results>0){
            $query3 ="INSERT INTO user (pid,isUser) VALUES ('$pid','$isUser')";
            $result3 = mysqli_query($connect, $query3);
            if($isUser==1){
                $query1 = "CREATE TABLE $pid (id INT AUTO_INCREMENT PRIMARY KEY, latitude NUMERIC(20,16), longitude NUMERIC(20,16), loc VARCHAR(100),Tdate DATE, isVisited INT(1) DEFAULt '0')"; 
                $query2 = "ALTER TABLE $pid AUTO_INCREMENT=1";
                $result1 = mysqli_query($connect, $query1);
                $result2 = mysqli_query($connect, $query2);
                $query4 = "INSERT INTO $adminid (pid) VALUES ('$pid')";
                $result4 = mysqli_query($connect, $query4);
            }
            else{
                $query1 = "CREATE TABLE $pid (id INT AUTO_INCREMENT PRIMARY KEY, pid VARCHAR(20) UNIQUE,isVerified INT(1) DEFAULT 0)"; 
                $query2 = "ALTER TABLE $pid AUTO_INCREMENT=1";
                $result1 = mysqli_query($connect, $query1);
                $result2 = mysqli_query($connect, $query2);}
    echo "user added successfully";
}}
else{
    echo "invalied";
}
    



?>