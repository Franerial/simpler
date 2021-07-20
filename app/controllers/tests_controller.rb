class TestsController < Simpler::Controller
  def index
    @time = Time.now
    render "tests/index"
  end

  def create
    status 201
    render plain: "Create method in action!"
  end

  def plain
    render plain: "Plain text responce example"
    status 200
  end

  def show
    @id = params[:id]
  end

  def question
    @id = params[:id]
    render plain: "This is an object with test id #{@id} and with question id #{params[:question_id]}"
  end
end
