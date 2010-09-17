require 'hpricot'
require 'open-uri'

class FantasyFootball
    def initialize(api_key)
        @url = "http://api.fantasyfootballnerd.com/"
        @api_key = "?apiKey=" + api_key
    end
    
    def parseXML(action, params)
        path = @url + action + @api_key + (params unless params.nil?)
        resp = open(path).read()
        return Hpricot(resp)
    end

    def getSchedule
        results = Array.new
        doc = parseXML("ffnScheduleXML.php", "")
        
        (doc/"game").each do |game|
            results << { 
                "gameId"   => game.attributes['gameid'],
                "week"     => game.attributes['week'],
                "gameDate" => game.attributes['gamedate'],
                "awayTeam" => game.attributes['awayteam'],
                "hometeam" => game.attributes['hometeam'],
                "gametime" => game.attributes['gametime']
            }
        end
        
        return results
    end
    
    # I believe this suffers the same problem as getInjuries, since the season is 
    # not yet underway. Sample data for this would be amazing.
    def getProjection(week, position)
        results = Array.new
        doc = parseXML("ffnSitStartXML.php", "&week=" + week + "&position=" + position)
        return doc # Haven't bothered parsing yet
    end
    
    def getInjuries(week)
        results = Array.new
        doc = parseXML("ffnInjuriesXML.php", "&week=" + week)
        if doc/"error" 
            return (doc/"error").inner_html
        else
            (doc/"injury").each do |injury|
                results << {
                    # Since the season hasn't started and I can't get an
                    # injury report, I'm not sure what the data format for
                    # this is. Hopefully I can find a sample somewhere
                }
            end
        end
    end
    
    def getAllPlayers
        players = Array.new
        doc = parseXML("ffnPlayersXML.php", "")
        
        (doc/"player").each do |p|
            players << {
                "name"     => p['name'],
                "position" => p['position'],
                "team"     => p['team'],
                "playerID" => p['playerid']
            }
        end
    end
    
    def getPlayerDetails(playerId)
        results = Array.new
        doc = parseXML("ffnPlayerDetailsXML.php", "&playerId=" + playerId)
        
        results << {
            "firstName" => (doc/"firstname").inner_html,
            "lastName"  => (doc/"lastname").inner_html,
            "team"      => (doc/"team").inner_html,
            "position"  => (doc/"position").inner_html    
        }
        
        (doc/"article").each do |article|
            results << { 
                "title"     => (article/"title").inner_html,
                "source"    => (article/"source").inner_html,
                "published" => (article/"published").inner_html
            }
        end
    end
    
    def getDraftRankings(position, limit, sos)
       results = Array.new
       params = "&position=" + position + "&limit=" + limit + "&sos=" + sos
       doc = parseXML("ffnRankingsXML.php", params)

       (doc/"player").each do |player|
           results << {
               "name"         => player.attributes['name'],
               "byeweek"      => player.attributes['byeweek'],
               "positionrank" => player.attributes['positionrank'],
               "overallrank"  => player.attributes['overallrank'],
               "team"         => player.attributes['team'],
               "playerid"     => player.attributes['playerid']
           } 
       end
    end
end