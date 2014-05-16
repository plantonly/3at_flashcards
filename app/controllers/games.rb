
get '/game' do
  @game = Game.find(session[:game_id])
  @game_score = @game.score
  @card = Card.find(session[:game_deck].last)
  @score_correct = session[:last_answer]
  erb :game
end

post '/setgame' do
  game_id = session[:game_id]
  @game = Game.find(game_id)
  @card = Card.find(session[:game_deck].last)
  if params[:guess] == @card.answer
    @game.score += 5
    session[:last_answer] = "correct"
    @game.save
  else
    @game.score -= 2
    session[:last_answer] = "incorrect"
    @game.save
  end
  session[:game_deck].pop
  redirect to '/gameover' if session[:game_deck].empty?
  redirect to "/game"
end

post '/skipcard' do
  lcard=session[:game_deck].pop
  session[:game_deck].unshift(lcard)
  @game.score -= 1
  redirect '/game'
end

get '/gameover' do
  session[:last_answer]=nil
  'game over'
end