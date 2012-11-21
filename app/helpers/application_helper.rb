module ApplicationHelper

  def bar(name)
    "#{name}bar"
  end

  def category_to_tags(category)
    pubcat = @publisher.category_for(category)
    return pubcat.tags.split(",")
  end

  def get_perspectives(user, category)
    tags = category_to_tags(category).join(" ")

    if @lat && @lng
      return Perspective.query_near_for_user(user, @lat, @lng, tags)
    else
      return Perspective.query_near_for_user(user, user.loc[0], user.loc[1], tags)
    end
  end




end
