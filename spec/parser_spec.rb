require_relative '../parser.rb'
require "test/unit"
require 'json'

class TestParser < Test::Unit::TestCase
  
  def setup
  @testData="<!-- Generated HTML --><html><head><title>Now Playing</title><link rel=\"stylesheet\" href=\"http://192.168.50.146:80/style.css\" type=\"text/css\" media=\"all\"><link rel=\"alternate\" type=\"text/xml\" title=\"RSS 2.0\" href=\"http://192.168.50.146:80/rss/nowplaying.xml\"><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body><img src=\"http://192.168.50.146:80/images/tivodance.gif\" align=\"right\"><h1>Now Playing</h1><table cellpadding=\"7\" width=\"100%\"><tr bgcolor=\"E5E5C5\"><th width=\"1%\"><th width=\"1%\">Source</th><th>Description</th><th width=\"5%\">Date</th><th width=\"5%\">Size</th><th width=\"5%\">Links</th></tr><tr bgcolor=\"F5F595\"><td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-66500.png\" alt=\"FXXHD\"></td><td align=\"left\" valign=\"top\"><b>After Earth</b><br>With his father trapped in the wreckage of their spacecraft, a youth treks across Earth's now-hostile terrain to recover their rescue beacon and signal for help. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Wed<br>4/27</td><td align=\"center\" valign=\"top\" nowrap>1:59:55<br>7.86 GB</td><td align=\"center\" valign=\"top\" nowrap><i>Protected</i></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>The Outer Limits</b></td><td align=\"center\" valign=\"top\" nowrap>Wed<br>4/27</td><td align=\"center\" valign=\"top\">16 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F17030\">folder</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>A Chef's Life</b></td><td align=\"center\" valign=\"top\" nowrap>Wed<br>4/27</td><td align=\"center\" valign=\"top\">23 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F279030631\">folder</a></td></tr><tr bgcolor=\"F5F5B5\"><td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-66500.png\" alt=\"FXXHD\"></td><td align=\"left\" valign=\"top\"><b>The Simpsons: &quot;The Bart of War&quot;</b><br>When Homer and Marge enroll Bart in an activities club, he wages war against Milhouse, who belongs to a different one. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Wed<br>4/27</td><td align=\"center\" valign=\"top\" nowrap>0:30:01<br>1.97 GB</td><td align=\"center\" valign=\"top\" nowrap><i>Protected</i></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>Kitchen Nightmares</b></td><td align=\"center\" valign=\"top\" nowrap>Mon<br>4/25</td><td align=\"center\" valign=\"top\">2 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F97868152\">folder</a></td></tr></table>18 items, <a href=\"index.html?Recurse=Yes\">classic</a>.<p><font size=\"-2\">This feature is not supported. The TiVo license agreement allows you to transfer content to up to ten devices within your household, but not outside your household.  Unauthorized transfers or distribution of copyrighted works outside of your home may constitute a copyright infringement. TiVo reserves the right to terminate the TiVo service accounts of users who transfer or distribute content in violation of this Agreement. </font></body></html>"
  @testData2="<!-- Generated HTML --><html><head><title>Now Playing</title><link rel=\"stylesheet\" href=\"http://192.168.50.146:80/style.css\" type=\"text/css\" media=\"all\"><link rel=\"alternate\" type=\"text/xml\" title=\"RSS 2.0\" href=\"http://192.168.50.146:80/rss/nowplaying.xml\"><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body><img src=\"http://192.168.50.146:80/images/tivodance.gif\" align=\"right\"><h1>Now Playing</h1><table cellpadding=\"7\" width=\"100%\"><tr bgcolor=\"E5E5C5\"><th width=\"1%\"><th width=\"1%\">Source</th><th>Description</th><th width=\"5%\">Date</th><th width=\"5%\">Size</th><th width=\"5%\">Links</th></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/in-progress-folder.png\"></td><td><td valign=\"top\"><b>South Park</b></td><td align=\"center\" valign=\"top\" nowrap>Sun<br>5/15</td><td align=\"center\" valign=\"top\">5 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F15340\">folder</a></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/in-progress-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-66630.png\" alt=\"FREFMHD\"></td><td align=\"left\" valign=\"top\"><b>Monsters University</b><br>Back in their college days, Mike Wazowski's fierce rivalry with natural-born Scarer Sulley gets them both kicked out of Monster University's elite Scare Program. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Sun<br>5/15</td><td align=\"center\" valign=\"top\" nowrap>0:00:00<br>990 MB</td><td align=\"center\" valign=\"top\" nowrap><i>Recording</i></td></tr><tr bgcolor=\"F5F595\"><td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65556.png\" alt=\"WCMHDT\"></td><td align=\"left\" valign=\"top\"><b>Saturday Night Live: &quot;Drake&quot;</b><br>Drake hosts and performs. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Sun<br>5/15</td><td align=\"center\" valign=\"top\" nowrap>1:33:00<br>9.23 GB</td><td align=\"center\" valign=\"top\" nowrap><a href=\"http://192.168.50.146:80/download/Saturday%20Night%20Live.TiVo?Container=%2FNowPlaying&amp;id=31075&amp;Format=video/x-tivo-mpeg\">Download MPEG-PS</a><br><a href=\"http://192.168.50.146:80/download/Saturday%20Night%20Live.TiVo?Container=%2FNowPlaying&amp;id=31075&amp;Format=video/x-tivo-mpeg-ts\">Download MPEG-TS</a></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>The Amazing Race</b></td><td align=\"center\" valign=\"top\" nowrap>Sat<br>5/14</td><td align=\"center\" valign=\"top\">12 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F3897567\">folder</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/expired-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-66198.png\" alt=\"FXHD\"></td><td align=\"left\" valign=\"top\"><b>Turbo</b><br>A snail gets the chance to escape his slow-paced life and race in the Indianapolis 500 when a freak accident gives him the power of superspeed. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Fri<br>5/13</td><td align=\"center\" valign=\"top\" nowrap>1:59:59<br>7.78 GB</td><td align=\"center\" valign=\"top\" nowrap><i>Protected</i></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/wishlist-folder.png\"></td><td><td valign=\"top\"><b>Avett Brothers</b></td><td align=\"center\" valign=\"top\" nowrap>Thu<br>5/12</td><td align=\"center\" valign=\"top\">4 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;amp;Container=%2FNowPlaying%2F19%2F13230\">folder</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>Diners, Drive-Ins and Dives</b></td><td align=\"center\" valign=\"top\" nowrap>Sat<br>5/7</td><td align=\"center\" valign=\"top\">9 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F92294758\">folder</a></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>A Chef's Life</b></td><td align=\"center\" valign=\"top\" nowrap>Fri<br>5/6</td><td align=\"center\" valign=\"top\">16 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F279030631\">folder</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/expired-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65558.png\" alt=\"WOSUDT\"></td><td align=\"left\" valign=\"top\"><b>This Land Is Your Land (My Music Presents)</b><br>The Smothers Brothers and Judy Collins host a look at the evolution of modern American folk music; performers include Glenn Yarborough, the Highwaymen, the Kingston Trio and the Limeliters. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Tue<br>3/22</td><td align=\"center\" valign=\"top\" nowrap>1:30:00<br>7.24 GB</td><td align=\"center\" valign=\"top\" nowrap><a href=\"http://192.168.50.146:80/download/This%20Land%20Is%20Your%20Land%20(My%20Music%20Presents).TiVo?Container=%2FNowPlaying&amp;id=21266&amp;Format=video/x-tivo-mpeg\">Download MPEG-PS</a><br><a href=\"http://192.168.50.146:80/download/This%20Land%20Is%20Your%20Land%20(My%20Music%20Presents).TiVo?Container=%2FNowPlaying&amp;id=21266&amp;Format=video/x-tivo-mpeg-ts\">Download MPEG-TS</a></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/expired-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65557.png\" alt=\"WTTEDT\"></td><td align=\"left\" valign=\"top\"><b>The Passion</b><br>A musical, modern retelling of Jesus Christ's betrayal, death and resurrection; Tyler Perry narrates. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Mon<br>3/21</td><td align=\"center\" valign=\"top\" nowrap>1:59:55<br>11.65 GB</td><td align=\"center\" valign=\"top\" nowrap><a href=\"http://192.168.50.146:80/download/The%20Passion.TiVo?Container=%2FNowPlaying&amp;id=20926&amp;Format=video/x-tivo-mpeg\">Download MPEG-PS</a><br><a href=\"http://192.168.50.146:80/download/The%20Passion.TiVo?Container=%2FNowPlaying&amp;id=20926&amp;Format=video/x-tivo-mpeg-ts\">Download MPEG-TS</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>Junk Food Flip</b></td><td align=\"center\" valign=\"top\" nowrap>Sat<br>2/27</td><td align=\"center\" valign=\"top\">12 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F322759704\">folder</a></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/expired-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65558.png\" alt=\"WOSUDT\"></td><td align=\"left\" valign=\"top\"><b>The Human Face of Big Data</b><br>The promise and peril of the knowledge revolution. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Thu<br>2/25</td><td align=\"center\" valign=\"top\" nowrap>1:00:00<br>4.73 GB</td><td align=\"center\" valign=\"top\" nowrap><a href=\"http://192.168.50.146:80/download/The%20Human%20Face%20of%20Big%20Data.TiVo?Container=%2FNowPlaying&amp;id=14925&amp;Format=video/x-tivo-mpeg\">Download MPEG-PS</a><br><a href=\"http://192.168.50.146:80/download/The%20Human%20Face%20of%20Big%20Data.TiVo?Container=%2FNowPlaying&amp;id=14925&amp;Format=video/x-tivo-mpeg-ts\">Download MPEG-TS</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/expired-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65564.png\" alt=\"TCMHD\"></td><td align=\"left\" valign=\"top\"><b>Sense and Sensibility</b><br>Suitors romance, then abandon, sisters left destitute by their father's death in late-1800s England. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Sat<br>1/23</td><td align=\"center\" valign=\"top\" nowrap>2:29:57<br>9.80 GB</td><td align=\"center\" valign=\"top\" nowrap><i>Protected</i></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>Mexico: One Plate at a Time With Rick Bayless</b></td><td align=\"center\" valign=\"top\" nowrap>Wed<br>11/11</td><td align=\"center\" valign=\"top\">26 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F1686382\">folder</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/expired-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65558.png\" alt=\"WOSUDT\"></td><td align=\"left\" valign=\"top\"><b>Austin City Limits: &quot;The Lumineers; Shovels &amp; Rope&quot;</b><br>The Lumineers perform Americana music including hits &quot;Ho Hey&quot; and &quot;Stubborn Love&quot;; South Carolina's Shovels &amp; Rope. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Sat<br>1/9</td><td align=\"center\" valign=\"top\" nowrap>1:00:00<br>4.85 GB</td><td align=\"center\" valign=\"top\" nowrap><a href=\"http://192.168.50.146:80/download/Austin%20City%20Limits.TiVo?Container=%2FNowPlaying&amp;id=2351&amp;Format=video/x-tivo-mpeg\">Download MPEG-PS</a><br><a href=\"http://192.168.50.146:80/download/Austin%20City%20Limits.TiVo?Container=%2FNowPlaying&amp;id=2351&amp;Format=video/x-tivo-mpeg-ts\">Download MPEG-TS</a></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/expired-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65558.png\" alt=\"WOSUDT\"></td><td align=\"left\" valign=\"top\"><b>Front and Center: &quot;The Avett Brothers&quot;</b><br>Scott and Seth Avett performance at the McKittrick Hotel includes &quot;I and Love and You&quot; and songs from &quot;Magpie and the Dandelion.&quot; Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Fri<br>1/8</td><td align=\"center\" valign=\"top\" nowrap>1:00:00<br>4.80 GB</td><td align=\"center\" valign=\"top\" nowrap><a href=\"http://192.168.50.146:80/download/Front%20and%20Center.TiVo?Container=%2FNowPlaying&amp;id=2339&amp;Format=video/x-tivo-mpeg\">Download MPEG-PS</a><br><a href=\"http://192.168.50.146:80/download/Front%20and%20Center.TiVo?Container=%2FNowPlaying&amp;id=2339&amp;Format=video/x-tivo-mpeg-ts\">Download MPEG-TS</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/suggestions-in-progress-folder.png\"></td><td><td valign=\"top\"><b>TiVo Suggestions</b></td><td align=\"center\" valign=\"top\" nowrap>Sun<br>5/15</td><td align=\"center\" valign=\"top\">121 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F0\">folder</a></td></tr></table>17 items, <a href=\"index.html?Recurse=Yes\">classic</a>.<p><font size=\"-2\">This feature is not supported. The TiVo license agreement allows you to transfer content to up to ten devices within your household, but not outside your household.  Unauthorized transfers or distribution of copyrighted works outside of your home may constitute a copyright infringement. TiVo reserves the right to terminate the TiVo service accounts of users who transfer or distribute content in violation of this Agreement. </font></body></html>"
    @one_recording_and_one_suggestion="<!-- Generated HTML --><html><head><title>Kitchen Nightmares</title><link rel=\"stylesheet\" href=\"http://192.168.50.146:80/style.css\" type=\"text/css\" media=\"all\"><link rel=\"alternate\" type=\"text/xml\" title=\"RSS 2.0\" href=\"http://192.168.50.146:80/rss/nowplaying.xml\"><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body><img src=\"http://192.168.50.146:80/images/tivodance.gif\" align=\"right\"><h1>Kitchen Nightmares</h1><table cellpadding=\"7\" width=\"100%\"><tr bgcolor=\"E5E5C5\"><th width=\"1%\"><th width=\"1%\">Source</th><th>Description</th><th width=\"5%\">Date</th><th width=\"5%\">Size</th><th width=\"5%\">Links</th></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/suggestion-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65725.png\" alt=\"BBCA\"></td><td align=\"left\" valign=\"top\"><b>Kitchen Nightmares: &quot;Sam's Mediterranean Kabob Room&quot;</b><br>Ramsay travels to Sam's Mediterranean Kabob Room in Monrovia, Calif., where the owner has only been able to keep his own children on as employees. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Mon<br>4/25</td><td align=\"center\" valign=\"top\" nowrap>0:59:58<br>3.93 GB</td><td align=\"center\" valign=\"top\" nowrap><i>Protected</i></td></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/save-until-i-delete-recording.png\" width=\"30\" height=\"30\"></td><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/ChannelLogo/logo-65725.png\" alt=\"BBCAHD\"></td><td align=\"left\" valign=\"top\"><b>Kitchen Nightmares: &quot;Mangia Mangia Pt. 2&quot;</b><br>Ramsay travels to Woodland Park, Colo., to save Mangia Mangia, an Italian restaurant saddled with tension between the owner and her staff, and problems with the food, atmosphere and service. Copyright Tribune Media Services, Inc.</td><td align=\"center\" valign=\"top\" nowrap>Thu<br>4/21</td><td align=\"center\" valign=\"top\" nowrap>0:09:58<br>1024.0 MB</td><td align=\"center\" valign=\"top\" nowrap><i>Protected</i></td></tr></table>2 items, <a href=\"index.html?Recurse=Yes\">classic</a>.<p><font size=\"-2\">This feature is not supported. The TiVo license agreement allows you to transfer content to up to ten devices within your household, but not outside your household.  Unauthorized transfers or distribution of copyrighted works outside of your home may constitute a copyright infringement. TiVo reserves the right to terminate the TiVo service accounts of users who transfer or distribute content in violation of this Agreement. </font></body></html>"
  end

  def test_can_parse_titles
    data = Parser.new.parse(@testData)
    assert_equal("After Earth", data["title"][0])
    assert_equal("The Simpsons: \"The Bart of War\"", data["title"][1])
  end

  def test_can_parse_descriptions
    firstDescription="With his father trapped in the wreckage of their spacecraft, a youth treks across Earth's now-hostile terrain to recover their rescue beacon and signal for help. Copyright Tribune Media Services, Inc."
    secondDescription="When Homer and Marge enroll Bart in an activities club, he wages war against Milhouse, who belongs to a different one. Copyright Tribune Media Services, Inc."
    data = Parser.new.parse(@testData)
    assert_equal(firstDescription, data["description"][0])
    assert_equal(secondDescription, data["description"][1])
  end

  def test_can_parse_folders
    firstFolder ="TiVoConnect?Command=QueryContainer&Container=%2FNowPlaying%2F17%2F17030"
    secondFolder="TiVoConnect?Command=QueryContainer&Container=%2FNowPlaying%2F17%2F279030631"
    thirdFolder ="TiVoConnect?Command=QueryContainer&Container=%2FNowPlaying%2F17%2F97868152"
    data = Parser.new.parse(@testData)
    assert_equal(3, data["folders"].length)
    assert_equal(firstFolder, data["folders"][0])
    assert_equal(secondFolder, data["folders"][1])
    assert_equal(thirdFolder, data["folders"][2]) 
  end

  def test_will_not_parse_tivo_suggestions_folder
    only_one_valid_folder = "<!-- Generated HTML --><html><head><title>Now Playing</title><link rel=\"stylesheet\" href=\"http://192.168.50.146:80/style.css\" type=\"text/css\" media=\"all\"><link rel=\"alternate\" type=\"text/xml\" title=\"RSS 2.0\" href=\"http://192.168.50.146:80/rss/nowplaying.xml\"><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\"></head><body><img src=\"http://192.168.50.146:80/images/tivodance.gif\" align=\"right\"><h1>Now Playing</h1><table cellpadding=\"7\" width=\"100%\"><tr bgcolor=\"E5E5C5\"><th width=\"1%\"><th width=\"1%\">Source</th><th>Description</th><th width=\"5%\">Date</th><th width=\"5%\">Size</th><th width=\"5%\">Links</th></tr><tr bgcolor=\"F5F5B5\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/folder.png\"></td><td><td valign=\"top\"><b>A Chef's Life</b></td><td align=\"center\" valign=\"top\" nowrap>Wed<br>2/10</td><td align=\"center\" valign=\"top\">13 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F17%2F279030631\">folder</a></td></tr><tr bgcolor=\"F5F595\"><td align=\"center\" valign=\"top\"><img src=\"http://192.168.50.146:80/images/suggestions-in-progress-folder.png\"></td><td><td valign=\"top\"><b>TiVo Suggestions</b></td><td align=\"center\" valign=\"top\" nowrap>Mon<br>6/6</td><td align=\"center\" valign=\"top\">104 items<br></td><td align=\"center\" valign=\"top\"><a href=\"TiVoConnect?Command=QueryContainer&amp;Container=%2FNowPlaying%2F0\">folder</a></td></tr></table>15 items, <a href=\"index.html?Recurse=Yes\">classic</a>.<p><font size=\"-2\">This feature is not supported. The TiVo license agreement allows you to transfer content to up to ten devices within your household, but not outside your household.  Unauthorized transfers or distribution of copyrighted works outside of your home may constitute a copyright infringement. TiVo reserves the right to terminate the TiVo service accounts of users who transfer or distribute content in violation of this Agreement. </font></body></html>"
    data = Parser.new.parse(only_one_valid_folder)
    assert_equal(1, data["folders"].length)
    assert_equal("TiVoConnect?Command=QueryContainer&Container=%2FNowPlaying%2F17%2F279030631", data["folders"][0])
    
  end

  def test_can_parse_channel
    data = Parser.new.parse(@testData2)
    assert_equal(["WCMHDT","FXHD","WOSUDT","WTTEDT","WOSUDT","TCMHD","WOSUDT","WOSUDT"], data["channels"])
  end

  def test_can_parse_size_if_not_recording
    data = Parser.new.parse(@testData2)
    assert_equal([9.23,7.78,7.24,11.65,4.73,9.80,4.85,4.80], data["size"])
  end

  def test_calling_parse_causes_averages_to_be_calculated
     if File.exist?("averages.json")
       File.delete("averages.json")
     end
     Parser.new.parse(@testData2)
     h = JSON.parse(File.read('averages.json'))
     assert_equal({"FXHD"=>3.8905403528267817,"TCMHD"=>3.9213071023674564,"WCMHDT"=>5.95483870967742,"WOSUDT"=>4.807083333333333,"WTTEDT"=>5.829047949965254}, h)
  end

  def test_calling_parse_will_ignore_tivo_suggestions
    data = Parser.new.parse(@one_recording_and_one_suggestion)
    assert_equal(["Kitchen Nightmares: \"Mangia Mangia Pt. 2\""], data["title"])
    assert_equal(["Ramsay travels to Woodland Park, Colo., to save Mangia Mangia, an Italian restaurant saddled with tension between the owner and her staff, and problems with the food, atmosphere and service. Copyright Tribune Media Services, Inc."], data["description"])
    assert_equal(["BBCAHD"], data["channels"])
  end

  def test_size_parses_correctly_if_in_MB
    data = Parser.new.parse(@one_recording_and_one_suggestion)
    assert_equal([1.00], data["size"])
  end

  def test_can_parse_multiple_times
    parser = Parser.new
    parser.parse(@testData)
    data = parser.parse(@one_recording_and_one_suggestion)
    assert_equal("After Earth", data["title"][0])
    assert_equal("The Simpsons: \"The Bart of War\"", data["title"][1])
    assert_equal("Kitchen Nightmares: \"Mangia Mangia Pt. 2\"", data["title"][2])
  end
end
