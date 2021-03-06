
class Article
  include Mongoid::Document
  include Mongoid::Timestamps

  attr_accessible :title, :content, :visible, :tags
  
  field :title
  field :alias

  field :content, :type => String
  field :visible, :type => Boolean, :default => false
  field :published_at, :type => DateTime
  
  embeds_many :comments, :inverse_of => :article
  
  # TODO implement as relational reference?
  field :tags, :type => Array, :default => []

  before_save :update_alias
  
  validates_presence_of :title, :content
  validates_uniqueness_of :title
  validates_length_of :title, :minimum => 3, :maximum => 250

  def year
    self.published_at.year.to_s
  end

  def month
    sprintf("%02d", self.published_at.month)
  end

  def update_alias
    self.alias = self.title.to_s.parameterize
  end
  
  # finds article by its alias (= title.parameterize)
  # wrapper method, also checks if article is visible
  #
  def self.find_by_alias(an_alias)
    self.where(:alias => an_alias, :visible => true).first
  end
    
  # provide public interface for listing and searching articles
  # TODO convert to separate model, ArticleSearch?
  #
  def self.list(params = {})    
    params = self.sanitize_search_params(params)

    # transform :year and :month params to :from and :to params
    # OPTIMIZE why not search by year/month/day indexes instead?
    # TODO deal with incorrect dates that can't be parsed
    if params[:year].present? && (params[:year].to_s =~ /^\d{4}$/)
      if params[:month].present? && (params[:month].to_s =~ /^\d{2}$/)
        date_from = Date.parse("#{params[:year]}/#{params[:month]}/01")
        params[:from] = date_from.to_s
        params[:to] = date_from.end_of_month.to_s
      else
        date_from = Date.parse("#{params[:year]}/01/01")
        params[:from] = date_from.to_s
        params[:to] = date_from.end_of_year.to_s
      end
    end
    
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
  
  ALLOWED_SEARCH_KEYS = [ :page, :per_page, :tag, :from, :to, :show_hidden, :order, :year, :month ] 
  
  # keep only allowed parameters and symbolize their keys
  #
  def self.sanitize_search_params(params = {})
    params.symbolize_keys.select { |k,v| ALLOWED_SEARCH_KEYS.include?(k) }
  end
  
end
