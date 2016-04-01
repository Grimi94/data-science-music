var request = require('request');
var cheerio = require('cheerio');
var createUrlForYear = function(year){
    return "https://www.grammy.com/nominees/search?artist=&field_nominee_work_value=&year="+ year +"&genre=All";
}

var options = {
    url: createUrlForYear(2014),
    mehtod: 'GET'
}

var callback = function(error, response, body) {
    if(!error){
        $ = cheerio.load(body);
        $('tr').each(function(index, item){
            var row = $(this);
            //console.log(row.find('.views-field-category-code').text().trim(' '));
            if(row.find('.views-field-category-code').text().trim(' ') == 'Song Of The Year'){
                var songTitle = row.find('.views-field-field-nominee-work').text().trim(' ');
                console.log(songTitle.split('(')[0])
            }
        });
    } else {
        console.log(error);
    }
}

for(var i = 0; i < 56; i++){
    options.url = createUrlForYear(2015 - i);
     request(options, callback);
}
