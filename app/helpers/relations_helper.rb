module RelationsHelper
  def relation_options(selected = nil)
    options = []
    options << [t('support.select.prompt'), nil]
    if @page && @page.field('relations_target_parent_id')
      Page.find(@page.field('relations_target_parent_id').content).children.each do |p| 
        options << [p.title, p.id]
      end
    else
      Page.all.each do |p| 
        options << [p.title, p.id]
      end
    end
    options_for_select(options, selected)
  end
end