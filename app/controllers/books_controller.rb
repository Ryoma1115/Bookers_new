class BooksController < ApplicationController
  before_action :authenticate_user!
  def index
    @books = Book.all.order(id: "DESC")

    #投稿部分
    @user = User.find(current_user.id)
    @book = Book.new
  end

  def create
    book = current_user.books.new(book_params)
    if book.save
      redirect_to book_path(book)
      flash[:notice] = "You have creatad book successfully."
    else
      @book = book
      @user = User.find(current_user.id)
      @books = Book.all.order(id: "DESC")
      render :index
    end
  end

  def show
    #bookで定義していたら投稿欄のところと重複した
    @book_detail = Book.find(params[:id])
    # 子から親を参照している
    @user = @book_detail.user
    @book = Book.new
  end

  def edit
    @book = Book.find(params[:id])
    if current_user.id != @book.user_id
      redirect_to books_path
    end
  end

  def update
    book = Book.find(params[:id])
    if book.update(book_params)
      redirect_to book_path(book)
      flash[:notice] = "You have update book successfully"
    else
      @book = book
      @user = User.find(current_user.id)
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

private
  def book_params
    params.require(:book).permit(:title,:body)
  end
end
