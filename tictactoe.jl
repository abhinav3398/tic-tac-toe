using LinearAlgebra, Random


const EMPTY = Int8(0)
is_empty = iszero
const X = Int8(1)
const O = Int8(-1)

"""
Returns starting state of the board.
"""
initial_state() = repeat([EMPTY], 3, 3)

"""
Returns player who has the next turn on a board.
"""
player(board) = any(is_empty, board) ? (if (sign∘sum)(board) == X O else X end) : EMPTY

"""
Returns set of all possible actions (i, j) available on the board.
"""
actions(board) = findall(is_empty, board)

"""
Returns the board that results from making move (i, j) on the board.
"""
function result(board, action)
  board_copy = copy(board)
  board_copy[action] = is_empty(board_copy[action]) ? player(board_copy) : board[board_copy]
  
  board_copy
end
result(board, action::Tuple{2}) = result(board, CartesianIndex(action))
result(board, i::T, j::T) where T <: Integer = result(board, CartesianIndex(i, j))

"""
Returns the winner of the game, if there is one.
"""
function winner(board)
  # go through board and find: 
  #   row sequence, col_sequence, diagonal sequence, cross diagonal sequence
  board_len = size(board, 1)
  diag_set, cross_diag_set = Vector{Int8}(undef, 3), Vector{Int8}(undef, 3)
  #   if any of the sequences is of length 3, return the player
  for i in 1:board_len
    diag_set[i], cross_diag_set[i] = board[i, i], board[i, board_len - i + 1]

    (sum(board[i, :]) == 3X || sum(board[:, i]) == 3X) && (return X)
    (sum(board[i, :]) == 3O || sum(board[:, i]) == 3O) && (return O)
  end
  (sum(diag_set) == 3X || sum(cross_diag_set) == 3X) && (return X)
  (sum(diag_set) == 3O || sum(cross_diag_set) == 3O) && (return O)
  #   if no sequences of length 3, return missing
  EMPTY
end

"""
Returns True if game is over, False otherwise.
"""
terminal(board) = winner(board) != EMPTY || EMPTY ∉ board

"""
Returns the optimal action for the current player on the board.
"""
function minimax(board; default_return_move=CartesianIndex(-1, -1))
  terminal(board) && (return default_return_move)
  # find which pllayer's turn it is in the board
  turn = player(board)
  # find the playable moves
  possible_moves = actions(board)
  # shuffle for randomness
  shuffle!(possible_moves)
  # an object to map value to optimised moves
  value_to_move = Vector{Tuple{Int8, CartesianIndex{2}}}(undef, length(possible_moves))
  # picks action a in ACTIONS(s) that produces optimal value of MIN/MAX-VALUE(RESULT(s, a))
  for (i, move) in enumerate(possible_moves)
    possible_board = result(board, move)
    score = alphabeta(possible_board, MINIMUM_SCORE, MAXIMUM_SCORE, turn != X)
    value_to_move[i] = (score, move)
  end
  # choose our optimizer function (min or max) based on which player is playing
  optimizer = turn == X ? argmax : argmin
  # return the optimised action from dict.values
  optimal_value, optimal_move = optimizer(x->x[1], value_to_move)
  optimal_move
end

const MINIMUM_SCORE = Int8(-10)
const MAXIMUM_SCORE = Int8(10)
""" min_/max_value function with alpha-beta pruning"""
function alphabeta(board, α, β, maximizingPlayer)
  terminal(board) && (return winner(board))

  score, optimizer = maximizingPlayer ? (MINIMUM_SCORE, max) : (MAXIMUM_SCORE, min)
  
  possible_moves = actions(board)

  for move in possible_moves
    child = result(board, move)
    
    score = optimizer(score, alphabeta(child, α, β, !maximizingPlayer))

    if maximizingPlayer
      α = optimizer(α, score)
    else
      β = optimizer(β, score)
    end
    
    (α >= β) && (break)
  end
  
  score
end