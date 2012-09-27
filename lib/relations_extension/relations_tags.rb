module RelationsExtension::RelationsTags
  include Radiant::Taggable

  tag 'related_pages' do |tag|
    tag.locals.related_pages = tag.locals.page.related_pages
    if tag.attr['from_ancestor']
      ancestor_path = Page.find(tag.attr['from_ancestor']).path
      tag.locals.related_pages.delete_if{|p| not p.path =~ /^#{ancestor_path}/ }
    end
    tag.expand unless tag.locals.related_pages.empty?
  end
  desc %{
    Iterates over all related pages. Page relations should be declared via a Relations page part.
    You can limit the results by use of a @from_ancestor@ attribute. 
    For example: &lt;r:related_pages from_ancestor="8"&gt;&lt;r:each:link/&gt;&lt;/r:related_pages&gt; where 8 is a page id
    The from_ancestor attribute accepts only one page id.
  }
  tag 'related_pages:each' do |tag|
    tag.locals.related_pages.inject('') do |result, related_page|
      tag.locals.page = related_page
      result + tag.expand
    end
  end
  
  desc %{ }
  tag 'related_pages:first' do |tag|
    tag.locals.page = tag.locals.related_pages.first
    tag.expand
  end
  desc %{ }
  tag 'related_pages:last' do |tag|
    tag.locals.page = tag.locals.related_pages.last
    tag.expand
  end
end