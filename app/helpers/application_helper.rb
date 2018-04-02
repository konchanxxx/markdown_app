module ApplicationHelper
  def markdown(text)
    MarkdownParser.instance.parse(text)
  end
end
