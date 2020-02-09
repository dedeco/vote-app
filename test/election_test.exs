defmodule ElectionTest do
  use ExUnit.Case
  doctest Election

setup do
  %{election: %Election{
    name: "San Francisco",
    candidates: [],
    next_id: 1
    },
    election_with_candidates: %Election{
      name: "San Francisco",
      candidates: [
          Candidate.new(1,"Cateano Veloso"),
          Candidate.new(2,"Chico Buarque")
        ],
      next_id: 3
      }
  }
end

test "updating election name from a command", ctx do
  command = "name San Francisco Mayor"
  election = Election.update(ctx.election, command)
  assert election == %Election{name: "San Francisco Mayor"}
end

test "adding a new candidate from a command", ctx do
  command = "add Donald Trump"
  election = Election.update(ctx.election, command)
  candidate = election.candidates
    |> Enum.find(fn x -> x.name == "Donald Trump" end)
  assert candidate.name ==  "Donald Trump"
end

test "voting for a candidate form a command", ctx do
  command = "vote 1"
  candidate = ctx.election_with_candidates.candidates
    |> Enum.find(fn x -> x.id == 1 end)
  election = Election.update(ctx.election_with_candidates, command)
  after_vote_candidate = election.candidates
    |> Enum.find(fn x -> x.id == 1 end)
  expected_votes = candidate.votes + 1
  assert expected_votes == after_vote_candidate.votes
end

test "invalid command", ctx do
  command = "xpto 1"
  election = Election.update(ctx.election, command)
  assert election == ctx.election
end

test "quitting the app", ctx do
  command = "quit"
  election = Election.update(ctx.election, command)
  assert election == :quit
end

end
