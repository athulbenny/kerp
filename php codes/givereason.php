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

$loc = mysqli_real_escape_string($connect, $_POST['loc']);
$tdate = mysqli_real_escape_string($connect, $_POST['tdate']);
$reason = mysqli_real_escape_string($connect, $_POST['reason']);
$pid = mysqli_real_escape_string($connect, $_POST['pid']);
$sep = mysqli_real_escape_string($connect, $_POST['sep']);

if($sep==0){
$query = "INSERT INTO failedreason (pid,tdate,loc,reason)
            VALUES('$pid', '$tdate','$loc','$reason')";
$results = mysqli_query($connect, $query);}
else{
$sql = " SELECT * FROM failedreason " ;
$db_data = array();

    $result = $connect->query($sql);
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $db_data[] = $row;
        }
        // Send back the complete records as a json
        echo json_encode($db_data);}}

?>