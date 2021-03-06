class RMQViewData
  attr_accessor :events, :built, :is_screen_root_view, :screen, :cached_rmq #, :cache_queries

  def screen_root_view?
    !@is_screen_root_view.nil?
  end

  def cleanup
    clear_query_cache
    if @cached_rmq
      @cached_rmq.selectors = nil
      @cached_rmq.parent_rmq = nil
      @cached_rmq = nil
    end
    @events = nil
    @screen = nil
    @_tags = nil
    @_styles = nil
    @_validation_errors = nil
    @validation_errors = nil
    @is_screen_root_view = false
    @built = false
    nil
  end

  def query_cache
    @_query_cache ||= {}
  end

  def clear_query_cache
    @query_cache = {}
  end

  def activity
    if @screen
      @screen.getActivity
    end
  end

  # @return [Hash] Array of tag names assigned to to this view
  def tags
    @_tags ||= {}
  end

  # @return [Array] Array of tag names assigned to to this view
  def tag_names
    tags.keys
  end

  # *Do not* use this, use {RMQ#tag} instead:
  # @example
  #   rmq(my_view).tag(:foo)
  def tag(*tag_or_tags)
    tag_or_tags.flatten!
    tag_or_tags = tag_or_tags.first if tag_or_tags.length == 1

    if tag_or_tags.is_a?(Array)
      tag_or_tags.each do |tag_name|
        tags[tag_name] = 1
      end
    elsif tag_or_tags.is_a?(Hash)
      tag_or_tags.each do |tag_name, tag_value|
        tags[tag_name] = tag_value
      end
    elsif tag_or_tags.is_a?(Symbol)
      tags[tag_or_tags] = 1
    end
  end

  # *Do not* use this, use {RMQ#untag} instead:
  # @example
  #   rmq(my_view).untag(:foo, :bar)
  # Do nothing if no tag supplied or tag not present
  def untag(*tag_or_tags)
    tag_or_tags.flatten.each do |tag_name|
      tags.delete tag_name
    end
  end

  # Check if this view contains a specific tag
  #
  # @param tag_name name of tag to check
  # @return [Boolean] true if this view has the tag provided
  def has_tag?(tag_name = nil)
    if tag_name
      tags.include?(tag_name)
    else
      RMQ.is_blank?(@_tags)
    end
  end

  def style_name
    self.styles.first
  end

  # Sets first style name, this is only here for backwards compatibility and as
  # a convenience method
  def style_name=(value)
    self.styles[0] = value
  end

  #view.rmq_data.styles
  def styles
    @_styles ||= []
  end

  #view.rmq_data.has_style?(:style_name_here)
  def has_style?(name = nil)
    if name
      self.styles.include?(name)
    else
      RMQ.is_blank?(@_styles)
    end
  end

  def validation_errors; @_validation_errors ||= {}; end
  def validation_errors=(value); @_validation_errors = value; end
  def validations; @_validations ||= []; end
  def validations=(value); @_validations = value; end
end
