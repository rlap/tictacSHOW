class MovesController < ApplicationController

#Create new move from click on links on the board
  def new
    @game = Game.find(params[:game_id])

    if @game.moves.length == 0 || @game.moves.length.even?
      current_player_id = @game.player1_id
    else
      current_player_id = @game.player2_id
    end

    if current_player_id == current_user.id
      @move = Move.create(
        :position => params[:position],
        :user_id => current_user.id,
        :game_id => params[:game_id]
        )
    end
    redirect_to game_path(params[:game_id])
  end


# link_to(position, new_move_path(@move, :position => position, :user_id => current_user, :game_id => @game.id))

  # GET /moves
  # GET /moves.json
  def index
    @moves = Move.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @moves }
    end
  end

  # GET /moves/1
  # GET /moves/1.json
  def show
    @move = Move.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @move }
    end
  end



  # GET /moves/1/edit
  def edit
    @move = Move.find(params[:id])
  end

  # PUT /moves/1
  # PUT /moves/1.json
  def update
    @move = Move.find(params[:id])

    respond_to do |format|
      if @move.update_attributes(params[:move])
        format.html { redirect_to @move, notice: 'move was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @move.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /moves/1
  # DELETE /moves/1.json
  def destroy
    @move = Move.find(params[:id])
    @move.destroy

    respond_to do |format|
      format.html { redirect_to moves_url }
      format.json { head :no_content }
    end
  end
end
