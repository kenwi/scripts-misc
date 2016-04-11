
function getThreadId(thread) {
    var regexp = /\d{6}/;
    var num = regexp.exec(thread.split("t=")[1]);
    
    return num;
}

function getPostCount(thread) {
    return thread.children('td.alt1').children('.smallfont').children('b').text().replace("(", "").replace(")", "");
}

function getForumName(thread) {
    return thread.children('td.alt1').children('.smallfont').children('a').text();
}

function getDate(thread) {
    return thread.children('td.alt2').children('.smallfont').text();
}

function getText(thread) {
    return thread.children('td.alt1').children('a.irs').text();
}

function getLink(thread) {
    return thread.children('td.alt1').children('a').attr('href');
}

function getTime(thread) {
    return thread.children('td.alt2').children('.smallfont').children('.time').text();
}

function getUser(thread) {
    return thread.children('td.alt2').children('.smallfont').children('a').text();
}

function getThreadLink(threadId) {
    return "http://freak.no/forum/showthread.php?t=" + threadId + "&goto=newpost";
}

module.exports = function (robot) {
    var updateId = null;
    var debug = false;
    var i = 0;
    
    robot.respond(/debug off/i, function (msg) {
        robot.brain.set("debug", false);
        msg.reply("Debug off");
    });
    
    robot.respond(/debug on/i, function (msg) {
        robot.brain.set("debug", true);
        msg.reply("Debug on");
    });
    
    robot.respond(/debug status/i, function (msg) {
        msg.reply(robot.brain.get("debug"));
    });
    
    robot.respond(/timer off/i, function (msg) {
        msg.reply("Cleared timer");
        clearInterval(this.updateId);
    });
    
    robot.respond(/freak on/i, function (msg) {
        msg.reply("Get your freak on!");
        
        msg.update = function () {
            var request = require("request");
            var cheerio = require("cheerio");
            
            if (robot.brain.get("debug") == true) {
                msg.send("-");
            }
            
            request({ uri: "http://freak.no" }, function (error, response, body) {
                var $ = cheerio.load(body);
                var i = 0;
                $("tbody#collapseobj_module_5 tr").each(function () {
                    if (i++ >= 5)
                        return;
                    
                    var e = $(this);
                    var text = getText(e);
                    var link = getLink(e);
                    if (text == "")
                        return;
                    
                    var forum = getForumName(e);
                    var postcount = getPostCount(e);
                    var date = getDate(e);
                    var time = getTime(e);
                    var threadId = getThreadId(link);
                    var user = getUser(e);
                    
                    var numPosts = robot.brain.get("id" + threadId);
                    
                    if (robot.brain.get("debug") == true) {
                        msg.send("Thread: " + text + " Link: " + getThreadLink(threadId) + " Saved: " + numPosts + " Real: " + postcount);
                    }
                    
                    if (numPosts == null && postcount == 0) {
                        msg.send(":: Ny tråd [" + forum + "] [" + user + "] [" + getThreadLink(threadId) + "] [" + text + "]");
                    }
                    
                    if (postcount > numPosts || (numPosts == null && postcount > 0)) {
                        msg.send(":: Nytt innlegg [" + forum + "] [" + user + "] [" + getThreadLink(threadId) + "] [" + text + "]");
                    }
                    robot.brain.set("id" + threadId, postcount);
                });
            });
        };
        
        if (this.updateId == null) {
            this.updateId = setInterval(msg.update, 60 * 1000);
            msg.send("Setting time interval for loop");
        }
        msg.send("Started watching forum for new threads and posts");
    });
}
