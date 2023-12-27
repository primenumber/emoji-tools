#!/usr/bin/env ruby

source = ARGV[0]
width = `identify -format "%w" #{source}`.to_i
height = `identify -format "%h" #{source}`.to_i
length = Math.sqrt(width ** 2 + height ** 2)
mh = (length - height) / 2
mw = (length - width) / 2

steps = 21
steps.times { |i|
  deg = 360 * i / steps
  out_file_name = sprintf("tmp/rot-%03d.png", deg)
  `convert -rotate #{deg} -extent #{length}x#{length} -gravity center #{source} #{out_file_name}`
}
`mogrify +repage tmp/rot-???.png`
`mogrify -crop #{width}x#{height}+#{mw}+#{mh} tmp/rot-???.png`
`mogrify +repage tmp/rot-???.png`
`convert -delay 10 tmp/rot-???.png anim.gif`
