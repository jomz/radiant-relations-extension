module RelationsExtension::RelationsTags
  include Radiant::Taggable

  class TagError < StandardError; end

  tag 'related_pages' do |tag|
    tag.locals.related_pages = tag.locals.page.related_pages.dup
    if tag.attr['from_ancestor']
      ancestor_path = Page.find(tag.attr['from_ancestor']).path
      tag.locals.related_pages.delete_if{|p| not p.path =~ /^#{ancestor_path}/ }
    end
    if tag.attr['order']
      attr = tag.attr['order']
      by, order = attr.strip.split(" ")
      raise TagError, "Can not order related pages by #{by}: not a valid attribute." unless Page.column_names.include?(by)
      tag.locals.related_pages.sort_by(&by.to_sym)
      if(order && order.downcase == 'desc')
        tag.locals.related_pages.reverse!
      end
    end
    tag.expand unless tag.locals.related_pages.empty?
  end
  desc %{
    Iterates over all related pages. Page relations should be declared via a Relations page part.
    You can limit the results by use of a @from_ancestor@ attribute.
    For example: &lt;r:related_pages from_ancestor="8"&gt;&lt;r:each:link/&gt;&lt;/r:related_pages&gt; where 8 is a page id
    The from_ancestor attribute accepts only one page id.

    You can change the order of the results by use of a @order@ attribute.
    For example: &lt;r:related_pages order="title"&gt;&lt;r:each:link/&gt;&lt;/r:related_pages&gt;
    By default the order will be ascending, you can reverse it 'SQL style' by adding " desc" to the order attribute.
  }
  tag 'related_pages:each' do |tag|
    tag.locals.previous_headers = {}
    tag.locals.related_pages.inject('') do |result, related_page|
      tag.locals.page = related_page
      result + tag.expand
    end
  end

  desc %{ Expands only if there are related pages. }
  tag 'if_related_pages' do |tag|
    tag.locals.related_pages = tag.locals.page.related_pages.dup
    if tag.attr['from_ancestor']
      ancestor_path = Page.find(tag.attr['from_ancestor']).path
      tag.locals.related_pages.delete_if{|p| not p.path =~ /^#{ancestor_path}/ }
    end
    tag.expand unless tag.locals.related_pages.empty?
  end

  desc %{ Expands only if there are no related pages. }
  tag 'unless_related_pages' do |tag|
    tag.locals.related_pages = tag.locals.page.related_pages.dup
    if tag.attr['from_ancestor']
      ancestor_path = Page.find(tag.attr['from_ancestor']).path
      tag.locals.related_pages.delete_if{|p| not p.path =~ /^#{ancestor_path}/ }
    end
    tag.expand if tag.locals.related_pages.empty?
  end

  desc %{ Sets the scope to the first related page. }
  tag 'related_pages:first' do |tag|
    tag.locals.page = tag.locals.related_pages.first
    tag.expand
  end

  desc %{ Sets the scope to the last related page. }
  tag 'related_pages:last' do |tag|
    tag.locals.page = tag.locals.related_pages.last
    tag.expand
  end

  desc %{ Expands if the current page in related_pages:each is the first one. }
  tag 'related_pages:each:if_first' do |tag|
    tag.expand if tag.locals.page == tag.locals.related_pages.first
  end
  tag 'related_pages:each:unless_first' do |tag|
    tag.expand unless tag.locals.page == tag.locals.related_pages.first
  end
  desc %{ Expands if the current page in related_pages:each is the last one. }
  tag 'related_pages:each:if_last' do |tag|
    tag.expand if tag.locals.page == tag.locals.related_pages.last
  end
  tag 'related_pages:each:unless_last' do |tag|
    tag.expand unless tag.locals.page == tag.locals.related_pages.last
  end
  desc %{
    Renders the tag contents only if the contents do not match the previous header.

    If you would like to use several header blocks you may use the @name@ attribute to
    name the header. When a header is named it will not restart until another header of
    the same name is different.

    Using the @restart@ attribute you can cause other named headers to restart when the
    present header changes. Simply specify the names of the other headers in a semicolon
    separated list.

    *Usage:*

    <pre><code><r:related_pages:each>
      <r:header [name="header_name"] [restart="name1[;name2;...]"]>
        ...
      </r:header>
    </r:related_pages:each>
    </code></pre>
  }
  tag 'related_pages:each:header' do |tag|
    previous_headers = tag.locals.previous_headers
    name = tag.attr['name'] || :unnamed
    restart = (tag.attr['restart'] || '').split(';')
    header = tag.expand
    unless header == previous_headers[name]
      previous_headers[name] = header
      unless restart.empty?
        restart.each do |n|
          previous_headers[n] = nil
        end
      end
      header
    end
  end
end
