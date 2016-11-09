<!DOCTYPE html>
<html>
<body> 
<?php
		$port = 22;
		$timeout = 0.1;
		$results = array();
		$client = getenv('HTTP_CLIENT_IP')?:
		getenv('HTTP_X_FORWARDED_FOR')?:
		getenv('HTTP_X_FORWARDED')?:
		getenv('HTTP_FORWARDED_FOR')?:
		getenv('HTTP_FORWARDED')?:
		getenv('REMOTE_ADDR');
		list($b1, $b2, $b3, $b4) = explode('.', $client);
		$net = $b1.'.'.$b2.'.'.$b3.'.';
		echo '<p>Netz:'.$net.'0</p>';
		for ($i = 1; $i <= 240; $i++) {
			$ip = $net.$i;
			if($pf = @fsockopen($ip, $port, $err, $err_string, $timeout)) {
					$results[$ip] = true;
					fclose($pf);
			} else {
					$results[$ip] = false;
			}
		}
		foreach($results as $ip=>$val) {
			if($val) {
				echo "<span style=\"color:green\">$ip </span><br/>";
			}
			
		}
?>
</body>
</html>

