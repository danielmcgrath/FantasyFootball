require 'hpricot'
require 'open-uri'

class FantasyFootball
    def initialize(api_key)
        @url = "http://api.fantasyfootballnerd.com/"
        @api_key = "?apiKey=" + api_key
    end
    
    def parseXML(action)
        load = @url + action + @api_key
        xml = open(load).read()
        return Hpricot(xml)
    end

    def getSchedule
        results = Array.new
        # Using stored local copy of results while testing
        # doc = parseXML("ffnScheduleXML.php")
        doc = parseXML("/Users/daniel/Desktop/sample_nfl_data.xml")
        
        (doc/"game").each do |game|
            curr = { 
                "gameId"   => game.attributes['gameid'],
                "week"     => game.attributes['week'],
                "gameDate" => game.attributes['gamedate'],
                "awayTeam" => game.attributes['awayteam'],
                "hometeam" => game.attributes['hometeam'],
                "gametime" => game.attributes['gametime']
            }
            results << curr
        end
        
        return results
    end
end