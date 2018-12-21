var string = msg.payload;


// Constants
mac_addresses =  
{"000D6F0003BD6969":'01',
"000D6F0003BD8974": '02',
"000D6F0002C0DDDB": '03',
"000D6F000416DD83": '04',
"000D6F0003BD5FE2": '05',
"000D6F0003561FC7": '06',
"000D6F0004B1EC41": '07',
"000D6F0002C0E746": '08',
"000D6F0000469B3E": '09',
"000D6F0004B613A8": '10',
"000D6F0004A29FA3": '11',
"000D6F0002C0EFF3": '12',}


//Splitting the payload 
var split = string.split(',');
var timestamp = Number(split[1].slice(5, 15));
var mac = split[2].slice(7, 23);
var power = split[3];
// Removing } on end of string
power = power.replace('}', '');
power = power.slice(8,18);
//console.log('power: %s', power);

//Changing timestampformat 
// Since I live in Norway and this experiment is conducted in the winter time, an hour has to be added. 
console.log('timestamp before adjustment: %s', timestamp);
var extra_hour = 3600;
timestamp = timestamp+extra_hour
console.log('timestamp after adjustment: %s', timestamp);

function convertUNIXTimestampToTime (input) {
var time = new Date(input * 1000);
var year = time.getFullYear();
var month = time.getMonth()+1;
var date = time.getDate();
// Adding 0 for lower numbers to match smart meter data
if (date < 10){
  date = "0" +date
}
var hr = time.getHours();
var m = "0" + time.getMinutes();
var s = "0" + time.getSeconds();
//return time+'-'+hr+ ':' + m.substr(-2) + ':' + s.substr(-2); 
return year+'-'+month+'-'+date+'T'+time.toLocaleTimeString('nn-NO');
}
timestamp = convertUNIXTimestampToTime(timestamp)



// Mac address
var mac = split[2].slice(7, 23);




// Lag en sortering av mac-addresser
// Send til den outputen som jeg vil av 12 forskjellige


//console.log(timestamp);
//console.log(mac);
//console.log(power)
//console.log('String: %s', split[2]);

data_to_csv = {time: timestamp, power_used: power}
msg.payload = data_to_csv;
return msg;