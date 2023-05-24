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

$table = mysqli_real_escape_string($connect, $_POST['tablename']);
$latitude = mysqli_real_escape_string($connect, $_POST['latitude']);
$longitude = mysqli_real_escape_string($connect, $_POST['longitude']);
$loc = mysqli_real_escape_string($connect, $_POST['loc']);
$Tdate = mysqli_real_escape_string($connect, $_POST['Tdate']);
$isChanged = mysqli_real_escape_string($connect, $_POST['isChanged']);
$id = mysqli_real_escape_string($connect, $_POST['id']);

if($isChanged==0){
    $query = "INSERT INTO $table (latitude,longitude,loc,Tdate)
            VALUES('$latitude', '$longitude','$loc','$Tdate')";
            $results = mysqli_query($connect, $query);}
else if($isChanged==1){
    $query0=" DELETE FROM $table WHERE id = '$id' ";
    $query = "INSERT INTO $table (latitude,longitude,loc,Tdate)
            VALUES('$latitude', '$longitude','$loc','$Tdate')";
            $result = mysqli_query($connect, $query0);
            $results = mysqli_query($connect, $query);
}else{
    $query0=" DELETE FROM $table WHERE id = '$id' ";
            $result = mysqli_query($connect, $query0); 
}

if($results>0)
{
    echo "data added successfully";
}

?>