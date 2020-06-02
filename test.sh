#!/usr/bin/env bash

duration="${1:-600}"

create() {
  curl 'http://localhost:3000/high_scores' \
  -H 'Content-Type: application/x-www-form-urlencoded' \
  --data-raw "high_score%5Bgame%5D=$(od -An -N32 -i /dev/random | shasum | awk '{print $1}')&high_score%5Bscore%5D=${RANDOM}&commit=Create+High+score" \
  --compressed
}

update() {
  id="${1}"
  curl "http://localhost:3000/high_scores/${id}" \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    --data-raw '_method=patch&high_score%5Bscore%5D=-1&commit=Update+High+score' \
    --compressed
}

test_create() {
  timeout=$(expr $(date +%s) + ${duration})
  while [ 1 ] ; do
    create &
    sleep 0.2
    if [[ $(date +%s) -gt ${timeout} ]]; then
      break
    fi
  done
}

test_index() {
  requests=$(expr ${duration} \* 5)
  timeout=$(expr $(date +%s) + ${duration})
  while [ 1 ] ; do
    ab -n ${requests} \
      -c 5 \
      -T 'application/x-www-form-urlencoded' \
      'http://localhost:3000/high_scores'
    if [[ $(date +%s) -gt ${timeout} ]]; then
      break
    fi
  done
}

test_update() {
  timeout=$(expr $(date +%s) + ${duration})
  while [ 1 ] ; do
    for id in $(docker-compose run --rm app rails runner "puts HighScore.select(:id).order(score: :desc).limit(25).map(&:id).join(' ')"); do
      update "${id}"
    done
    sleep 13
    if [[ $(date +%s) -gt ${timeout} ]]; then
      break
    fi
  done
}

test_destroy() {
  timeout=$(expr $(date +%s) + ${duration})
  while [ 1 ] ; do
    for id in $(docker-compose run --rm app rails runner "puts HighScore.select(:id).order(score: :asc).limit(10).map(&:id).join(' ')"); do
      curl -X DELETE "http://localhost:3000/high_scores/${id}"
    done
    sleep 7
    if [[ $(date +%s) -gt ${timeout} ]]; then
      break
    fi
  done
}

test_index &
test_create &
test_update &
test_destroy &

wait
