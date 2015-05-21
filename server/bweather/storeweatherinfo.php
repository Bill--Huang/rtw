<?php
	$paramArray = $_GET;

	// http://120.26.115.186:8080/storeweatherinfo.php?uuid=12345&location=11,22&city=shanghai&temperature=1&humidity=1&pm25=1&date=2015-12-12
	$uuid = $paramArray["uuid"];
	$location = $paramArray["location"];
	$city = $paramArray["city"];
	$temperature = $paramArray["temperature"];
	$humidity = $paramArray["humidity"];
	$pm25 = $paramArray["pm25"];
	$date = $paramArray["date"];

	$servername = "localhost";
	$username = "root";
	$password = "root";
	$database = "bweather";

	$conn = new mysqli($servername, $username, $password, $database);

	if ($conn->connect_error) {
	    returnErrorMessage("Connection failed: " . $conn->connect_error);
	}
	//insertData($conn, $uuid, $location, $city, $temperature, $humidity, $pm25, $date);
	if(isUUIDExist($conn, $uuid)) {
		// update
		update($conn, $uuid, $location, $city, $temperature, $humidity, $pm25, $date);
		
	} else {
		// insert
		insertData($conn, $uuid, $location, $city, $temperature, $humidity, $pm25, $date);
	}

	// get the average data
	getAverageData($conn, $uuid);

	$conn->close();

	function isUUIDExist($c, $u) {
		$sql = "SELECT * FROM weatherinfo WHERE uuid = '$u'";

		$result = $c->query($sql);

		if ($result->num_rows > 0) {
		    return true;
		} else {
		    return false;
		}
	}

	function insertData($c, $u, $l, $n, $t, $h, $p, $d) {
		$sql = "INSERT INTO weatherinfo (uuid, location, name, temperature, humidity, pm25, datestr, count) VALUES ('$u', '$l', '$n', $t, $h, $p, '$d', '1')";
		$result = $c->query($sql);
		if ($result === true) {
		    // echo "New record created successfully";
		    // return true;
		} else {
		    returnErrorMessage("Error: InsertData <br>" . $c->error);
		}
	}

	function update($c, $u, $l, $n, $t, $h, $p, $d) {
		// check if in the same day
		$sql = "SELECT * FROM weatherinfo WHERE uuid = '$u'";
		$result = $c->query($sql);

		if ($result->num_rows > 0) {
			$row = $result->fetch_array();
			$tempTemperature = $row['temperature'] + $t;
			$tempHumidity = $row['humidity'] + $h;
			$tempPM25 = $row['pm25'] + $p;
			$tempCount = $row['count'] + 1;

			if ($row['datestr'] == $d) {
				// echo "yes: add new record and count++ <br>";
			} else {
				$tempTemperature = $t;
				$tempHumidity = $h;
				$tempPM25 = $p;
				$tempCount = 1;
				// echo "no: update, change date, count = 1 <br>";
			}

			updateData($c, $u, $l, $n, $tempTemperature, $tempHumidity, $tempPM25, $d, $tempCount);
		} else {
			returnErrorMessage("Error: UpdateData <br>");
		}
	}

	function updateData($c, $u, $l, $n, $t, $h, $p, $d, $count) {
		$sql = "UPDATE weatherinfo SET location = '$l', name = '$n', temperature = '$t', humidity = '$h', pm25 = '$p', datestr = '$d', count = '$count' WHERE uuid = '$u'";

		$result = $c->query($sql);
		if ($c->query($sql) === true) {
		    // echo "Update record successfully";
		} else {
		    returnErrorMessage("Error: UpdatetData <br>" . $c->error);
		}
	}

	function getAverageData($c, $u) {
		$sql = "SELECT * FROM weatherinfo WHERE uuid = '$u'";
		$result = $c->query($sql);

		if ($result->num_rows > 0) {
			$row = $result->fetch_array();
			$tempCount = $row['count'];

			$tempTemperature = $row['temperature'] / $tempCount ;
			$tempHumidity = $row['humidity'] / $tempCount;
			$tempPM25 = $row['pm25'] / $tempCount;
			// $data = "data";
			$data = Array('location' => $row['location'],
				'city' => $row['name'],
				'temperature' => $tempTemperature,
				'humidity' => $tempHumidity,
				'pm25' => $tempPM25,
				'date' => $row['datestr']);

			$arr = Array('result' => 'success', 'data' => $data);
			sendResponse(200, json_encode($arr));
			// echo "test";
		} else {
			returnErrorMessage("Error: GetAverageData <br>");
		}
	}

	function returnErrorMessage($message) {
		$conn->close();

		$arr = Array('result' => 'error', 'data' => $message);
		sendResponse(200, json_encode($arr));

		// exit;
	}

	function sendResponse($status = 200, $body = '', $content_type = 'text/html') {
	    $status_header = 'HTTP/1.1 ' . $status . ' ' . getStatusCodeMessage($status);
	    header($status_header);
	    header('Content-type: ' . $content_type);
	    echo $body;
	}

	// Helper method to get a string description for an HTTP status code
	// From http://www.gen-x-design.com/archives/create-a-rest-api-with-php/ 
	function getStatusCodeMessage($status) {
	    // these could be stored in a .ini file and loaded
	    // via parse_ini_file()... however, this will suffice
	    // for an example
	    $codes = Array(
	        100 => 'Continue',
	        101 => 'Switching Protocols',
	        200 => 'OK',
	        201 => 'Created',
	        202 => 'Accepted',
	        203 => 'Non-Authoritative Information',
	        204 => 'No Content',
	        205 => 'Reset Content',
	        206 => 'Partial Content',
	        300 => 'Multiple Choices',
	        301 => 'Moved Permanently',
	        302 => 'Found',
	        303 => 'See Other',
	        304 => 'Not Modified',
	        305 => 'Use Proxy',
	        306 => '(Unused)',
	        307 => 'Temporary Redirect',
	        400 => 'Bad Request',
	        401 => 'Unauthorized',
	        402 => 'Payment Required',
	        403 => 'Forbidden',
	        404 => 'Not Found',
	        405 => 'Method Not Allowed',
	        406 => 'Not Acceptable',
	        407 => 'Proxy Authentication Required',
	        408 => 'Request Timeout',
	        409 => 'Conflict',
	        410 => 'Gone',
	        411 => 'Length Required',
	        412 => 'Precondition Failed',
	        413 => 'Request Entity Too Large',
	        414 => 'Request-URI Too Long',
	        415 => 'Unsupported Media Type',
	        416 => 'Requested Range Not Satisfiable',
	        417 => 'Expectation Failed',
	        500 => 'Internal Server Error',
	        501 => 'Not Implemented',
	        502 => 'Bad Gateway',
	        503 => 'Service Unavailable',
	        504 => 'Gateway Timeout',
	        505 => 'HTTP Version Not Supported'
	    );
	 
	    return (isset($codes[$status])) ? $codes[$status] : '';
	}
?>