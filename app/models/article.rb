
class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :title, :content, :visible, :tags
  
  field :title
  # TODO will string data type be enough? check out mongodb documentation
  field :content, :type => String
  field :visible, :type => Boolean, :default => false
  field :published_at, :type => DateTime
  
  embeds_many :comments
  # TODO implement as relational reference?
  field :tags, :type => Array, :default => []
  
  validates_presence_of :title, :content
  validates_uniqueness_of :title
  validates_length_of :title, :minimum => 3, :maximum => 250
  
  # provide public interface for listing and searching articles
  # TODO convert to separate model, ArticleSearch?
  #
  def self.list(params = {})    
    params = self.sanitize_search_params(params)
    
    params[:page] ||= 1
    params[:per_page] ||= 10
    params[:show_hidden] ||= false
    params[:order] ||= "published_at"
    # TODO return errors on invalid dates - after conversion into ArticleSearch model
    params[:from] = (Date.parse(params[:from]) rescue nil) if params[:from]
    params[:to] = (Date.parse(params[:to]) rescue nil) if params[:to]

    q = self
    
    # show only visible articles
    q = q.where(:visible => true) unless params[:show_hidden]
    
    # show only articles for certain date range
    if params[:from] and params[:to]
      q = where(:published_at.gte => params[:from], :published_at.lte => params[:to])
    end
    
    # show only articles which have certain tag
    q = q.where(:tags => params[:tag]) if params[:tag]
    
    # set order
    q = q.descending(params[:order].to_sym)
    
    q.paginate(params)
  end

  # return recently published articles
  #
  def self.recent(nr = 5)
    self.list(:per_page => nr)
  end
  
  # make article visible to users
  def publish!
    self.visible = true
    self.published_at ||= Time.current
    self.save
  end
  
  # hide article from users
  def hide!
    self.visible = false
    self.save
  end
  
  protected
  
  ALLOWED_SEARCH_KEYS = %w{ page per_page tag from to show_hidden order } 
  
  # keep only allowed parameters and symbolize them
  #
  def self.sanitize_search_params(params = {})
    Hash[ params.to_a.map do |k,v|
      ALLOWED_SEARCH_KEYS.include?(k.to_s) ? [ k.to_sym, v ] : nil
    end.compact ]
  end
  
end
