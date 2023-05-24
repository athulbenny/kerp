<?php
$connect = new mysqli("localhost", "root", "", "kerp");

if($connect === false){
	die("ERROR: Could not connect. "
			. $connect->connect_error);
}
$pid = mysqli_real_escape_string($connect, $_POST['pid']);
$adminid = mysqli_real_escape_string($connect, $_POST['adminid']);
$sql = "UPDATE accounts SET isVerified=1 WHERE pid='$pid'";
$sql2 = "UPDATE $adminid SET isVerified=1 WHERE pid='$pid'";
if($connect->query($sql) === true && $connect->query($sql2)){
	//echo "Records was updated successfully.";
} else{
	echo "ERROR: Could not able to execute $sql. "
										. $connect->error;
}
$table = "accounts";
$sql1 = "SELECT pid from $table ";
$db_data = array();

$result = $connect->query($sql1);
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




?>