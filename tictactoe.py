"""
Tic Tac Toe Player
"""

import math
from copy import deepcopy
from random import choice, shuffle

X = "X"
O = "O"
EMPTY = None


def initial_state():
    """
    Returns starting state of the board.
    """
    return [[EMPTY, EMPTY, EMPTY],
            [EMPTY, EMPTY, EMPTY],
            [EMPTY, EMPTY, EMPTY]]


def player(board):
    """
    Returns player who has the next turn on a board.
    """
    player_X_turns ,player_O_turns = 0, 0
    for row in board:
        for tile in row:
            if tile == X:
                player_X_turns += 1
            elif tile == O:
                player_O_turns += 1
    
    if player_X_turns > player_O_turns:
        return O
    else:
        return X


def actions(board):
    """
    Returns set of all possible actions (i, j) available on the board.
    """
    # init moves set
    moves = set()
    # find len of row & col in board
    row, col = len(board), len(board[0])
    # find & add moves
    for i in range(row):
        for j in range(col):
            if board[i][j] == EMPTY:
                moves.add((i, j))

    return list(moves)


def result(board, action):
    """
    Returns the board that results from making move (i, j) on the board.
    """
    # copy board
    board_copy = deepcopy(board)
    # find which pllayer's turn is in the board
    turn = player(board)
    # try & make the move if possible on the copied board else raise exception
    i, j = action
    try:
        board_copy[i][j] = turn
    except IndexError:
        raise IndexError("Invalid move")
    
    return board_copy


def winner(board):
    """
    Returns the winner of the game, if there is one.
    """
    # bond dims
    board_len = len(board)
    # go through board and find: 
    #   row sequence, col_sequence, diagonal sequence, cross diagonal sequence
    #   if any
    diag, cross_diag = set(), set()
    for i in range(board_len):
        # reset the row, col sequences
        row_seq, col_seq = set(), set()
        for j in range(board_len):
            row_seq.add(board[i][j])
            col_seq.add(board[j][i])
            # find and add diagonal element in our set
            if i == j:
                diag.add(board[i][j])
                cross_diag.add(board[i][board_len-j-1])
        # return winner if any sequence of player is found(exclude empty sequence)
        if len(row_seq) == 1 and not EMPTY in row_seq:
            return row_seq.pop()
        elif len(col_seq) == 1 and not EMPTY in col_seq:
            return col_seq.pop()
    # check for sequence in diagonal elements & return if found
    if len(diag) == 1 and not EMPTY in diag:
        return diag.pop()
    elif len(cross_diag) == 1 and not EMPTY in cross_diag:
        return cross_diag.pop()
    else:
        return EMPTY


def terminal(board):
    """
    Returns True if game is over, False otherwise.
    """
    board_set = set([tile for row in board for tile in row])
    return not (EMPTY in board_set and winner(board) == None)


def utility(board):
    """
    Returns 1 if X has won the game, -1 if O has won, 0 otherwise.
    """
    Winner = winner(board)
    if Winner == X:
        return 1
    elif Winner == O:
        return -1
    else:
        return 0


def minimax(board):
    """
    Returns the optimal action for the current player on the board.
    """
    if terminal(board):
        return None
    # find which pllayer's turn it is in the board
    turn = player(board) == X
    # find the playable moves init dict to map value to optimised moves
    moves, v2action = actions(board), {}
    # shuffle for randomness
    shuffle(moves)

    minimum_score, maximum_score = -10, 10
    
    def alphabeta(b, alpha, beta, maximizingPlayer):
        """ min_/max_value function with alpha-beta pruning"""

        if terminal(b):
            return utility(b)

        else:
            score, optimizer = (minimum_score, max) if maximizingPlayer else (maximum_score, min)

            possible_moves = actions(b)

            for move in possible_moves:
                child = result(board=b, action=move)

                score = optimizer(score, alphabeta(b=child, alpha=alpha, beta=beta, maximizingPlayer=not maximizingPlayer))

                if maximizingPlayer:
                    alpha = optimizer(alpha, score)
                else:
                    beta = optimizer(beta, score)

                if alpha >= beta:
                    break

            return score
    
    # picks action a in ACTIONS(s) that produces optimal value of MIN/MAX-VALUE(RESULT(s, a))
    for move in moves:
        possible_board = result(board=board, action=move)
        v2action[alphabeta(b=possible_board, maximizingPlayer=not turn, alpha=minimum_score, beta=maximum_score)] = move
    # choose our optimizer function (min or max) based on which player is playing
    optimizer = max if turn else min
    # return the optimised action from dict.
    return v2action[optimizer(v2action)]