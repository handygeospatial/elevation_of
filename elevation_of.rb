require 'json'
require 'open-uri'

def elevation_of(lng, lat)
  e = JSON.parse(open("http://cyberjapandata2.gsi.go.jp/general/dem/scripts/getelevation.php?lon=#{lng}&lat=#{lat}&outtype=JSON").read)['elevation']
  raise 'elevation not found' if e === '-----'
  e
end
