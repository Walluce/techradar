class Starter
  DEFAULT_NOTES = "techradar.io is a great tool for tracking interesting technologies in software development".freeze

  def user_created(user)
    radar_name = "Personal Radar for #{Date::MONTHNAMES[Time.zone.today.month]} #{Time.zone.today.year}"
    radar = user.add_radar(name: radar_name)
    topic = Topic.techradar
    Blip.create!(topic: topic, quadrant: "tools", ring: "assess", notes: DEFAULT_NOTES, radar: radar)
  end

  private

  attr_reader :user
end
