module RelationsHelper
  def relation_options(selected = nil)
    options = []
    options << [t('support.select.prompt'), nil]
    if @page && @page.field('relations_target_parent_id')
      options.concat build_tree(Page.find(@page.field('relations_target_parent_id').content), [])
    else
      options.concat build_tree(Page.root, [])
    end
    options_for_select(options, selected)
  end
  
  def build_tree(page, list, level = 0)
    label = "#{'-'*level} #{page.title}"
    id = page.id
    list << [label, id]

    return list if page.fields.select{|f| f.name == "exclude_children_from_relations_target"}.any?
    return list if Radiant::Config["relations.exclude_archive_children"] && page.class_name =~ /ArchivePage/

    page.children.each do |p|
      build_tree p, list, level + 1
    end
    list
  end
end