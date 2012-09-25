module RelationsExtension::RelationsTags
  include Radiant::Taggable

  tag 'related_pages' do |tag|
    related_pages = tag.locals.page.related_pages
    tag.expand unless related_pages.empty?
  end
  desc %{
    Iterates over all related pages. Page relations should be declared via a Relations page part.
  }
  tag 'related_pages:each' do |tag|
    related_pages.inject('') do |result, related_page|
      tag.locals.page = related_page
      result + tag.expand
    end
  end
  
  desc %{ }
  tag 'related_pages:first' do |tag|
    tag.locals.page = related_pages.first
    tag.expand
  end
  desc %{ }
  tag 'related_pages:last' do |tag|
    tag.locals.page = related_pages.last
    tag.expand
  end
end