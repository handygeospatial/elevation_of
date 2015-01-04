require 'json'
require 'open-uri'

#def elevation_of(lng, lat)
#  e = JSON.parse(open("http://cyberjapandata2.gsi.go.jp/general/dem/scripts/getelevation.php?lon=#{lng}&lat=#{lat}&outtype=JSON").read)['elevation']
#  raise 'elevation not found' if e === '-----'
#  e
#end

module Math
  def self.sec(x)
    1.0 / cos(x)
  end
end

def lnglat2xy(lng, lat, z)
  n = 2 ** z
  rad = lat * 2 * Math::PI / 360
  [n * ((lng.to_f + 180) / 360),
   n * (1 - (Math::log(Math::tan(rad) +
   Math::sec(rad)) / Math::PI)) / 2]
end

$buf = {}
def elevation_of(lng, lat)
  (xf, yf) = lnglat2xy(lng, lat, 14)
  xy = "#{xf.to_i}/#{yf.to_i}"
  url = "http://cyberjapandata.gsi.go.jp/xyz/dem/14/#{xy}.txt"
  if $buf[xy].nil?
    $buf[xy] = []
    open(url).each_line {|l|
      $buf[xy] << l.strip.split(',').map{|v| v.to_f}
    }
  end
  $buf[xy][(yf % 1 * 256).to_i][(xf % 1 * 256).to_i]
end
