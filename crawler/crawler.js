var request = require('request');
var cheerio = require('cheerio');
var async = require('async');
var fs = require('fs');
var createUrlForYear = function(year){
    return "https://www.grammy.com/nominees/search?artist=&field_nominee_work_value=&year="+ year +"&genre=All";
}

var csvValues = [];

var callback = function(error, response, body, year) {
    if(!error){
        $ = cheerio.load(body);
        $('tr').each(function(index, item) {
            var row = $(this);
            if(row.find('.views-field-category-code').text().trim(' ') == 'Song Of The Year'){
                var songTitle = row.find('.views-field-field-nominee-work').text().trim(' ');
                songTitle = songTitle.split('(')[0];
                console.log(year + ' - ' + songTitle);
                csvValues.push(year + ", " + songTitle);
            }
        });
    } else {
        console.log(error);
    }
}

var q = async.queue(function (task, func) {
    request(task.options, function() {
        var newArgs = [].slice.call(arguments);
        newArgs.push(task.year);
        func.apply(this, newArgs);
    });
}, 10);

for(var i = 0; i < 56; i++) {
    var year = 2015 - i;
    var options = {
        url: createUrlForYear(year),
        method: 'GET'
    }
    q.push({year: year, options: options}, callback);
}

q.drain = function() {
    csvValues.sort();
    csvContent = csvValues.join("\n");
    fs.writeFile("../grammys.csv", csvContent, function(err) {
        if(err) {
            return console.log(err);
        }

        console.log("The file was saved!");
    });
    /*
    var encodedUri = encodeURI(csvContent);
    global.open(encodedUri);*/
    console.log('all items have been processed');
}
