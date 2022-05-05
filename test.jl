using Test
includet("tictactoe.jl")

@testset "initial state of the game" begin
  @test iszero(EMPTY) && is_empty(EMPTY) && !iszero(1) && !is_empty(1)
  @test X == 1 && O == -1

  _initial_state = initial_state()
  @test size(_initial_state) == (3, 3)
  @test all(is_empty, _initial_state)
end

@testset "testing player's actions" begin
  @testset "X's turn" begin
    @test X == player([X X X; O O EMPTY; O EMPTY EMPTY])
    @test X == player([O O EMPTY; X X X; O EMPTY EMPTY])
    @test X == player([EMPTY EMPTY O; O O EMPTY; X X X])
    @test X == player([X O EMPTY; X O EMPTY; X EMPTY O])
    @test X == player([O X EMPTY; O X EMPTY; X O EMPTY])
    @test X == player([EMPTY O X; O X EMPTY; X EMPTY O])
    @test X == player([X O EMPTY; O X EMPTY; EMPTY O X])
  end

  @testset "O's turn" begin
    @test O == player([X X X; O O EMPTY; EMPTY EMPTY EMPTY])
    @test O == player([O O EMPTY; X X X; EMPTY EMPTY EMPTY])
    @test O == player([EMPTY EMPTY O; O EMPTY EMPTY; X X X])
    @test O == player([X O EMPTY; X O EMPTY; EMPTY EMPTY X])
    @test O == player([O X EMPTY; EMPTY X EMPTY; X O EMPTY])
    @test O == player([EMPTY EMPTY X; O X EMPTY; X EMPTY O])
    @test O == player([X O EMPTY; EMPTY X EMPTY; EMPTY O X])
  end
  
  @test EMPTY == player([X X X; O O O; X X X])
end



# for winner testset
# @test X == actions([X X X; O O EMPTY; EMPTY EMPTY EMPTY])
# @test X == actions([O O EMPTY; X X X; O EMPTY EMPTY])
# @test X == actions([EMPTY EMPTY EMPTY; O O EMPTY; X X X])
# @test X == actions([X O EMPTY; X O EMPTY; X EMPTY EMPTY])
# @test X == actions([O X EMPTY; O X EMPTY; X O EMPTY])
# @test X == actions([EMPTY O X; O X EMPTY; X EMPTY O])
# @test X == actions([X O EMPTY; O X EMPTY; EMPTY O X])