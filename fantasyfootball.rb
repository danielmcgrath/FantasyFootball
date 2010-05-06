require 'hpricot'
require 'open-uri'

class FantasyFootball
    def initialize(api_key)
        @url = "http://api.fantasyfootballnerd.com/"
        @api_key = "?apiKey=" + api_key
    end
    
    def parseXML(action, params)
        load = @url + action + @api_key + params
        xml = open(load).read()
        return Hpricot(xml)
    end

    def getSchedule
        results = Array.new
        doc = parseXML("ffnScheduleXML.php")
        
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
    
    # TODO: getProjection doesn't seem to actually return position
    # projections. Bad API call or bad API?
    def getProjection(week, position)
        results = Array.new
        doc = parseXML("ffnSitStartXML.php", "&week=" + week + "&position=" + position)
        return doc # Haven't bothered parsing yet
    end
    
    def getInjuries(week)
        results = Array.new
        doc = parseXML("ffnInjuriesXML.php", "&week=" + week)
        if doc/"error" 
            puts (doc/"error").inner_html
        else
            (doc/"injury").each do |injury|
                curr = {
                    # Since the season hasn't started and I can't get an
                    # injury report, I'm not sure what the data format for
                    # this is. Hopefully I can find a sample somewhere
                }
                results << curr
            end
        end
        
        return results
    end
    
    def getAllPlayers
        
    end
    
    def getPlayerDetails(playerId)
        
    end
    
    def getDraftRankings(position, limit, sos)
       results = Array.new
       params = "&position=" + position + "&limit=" + limit + "&sos=" + sos
       doc = parseXML("ffnRankingsXML.php", params)

       (doc/"player").each do |player|
           curr = {
               "name"         => player.attributes['name'],
               "byeweek"      => player.attributes['byeweek'],
               "positionrank" => player.attributes['positionrank'],
               "overallrank"  => player.attributes['overallrank'],
               "team"         => player.attributes['team'],
               "playerid"     => player.attributes['playerid']
           }
           results << curr
       end
       
       return results
    end
end