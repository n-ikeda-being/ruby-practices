for (let cnt = 1; cnt <= 20; cnt++) {
  if (cnt % 15 === 0) {
    console.log('fizzBuzz')
  } else if (cnt % 5 === 0) {
    console.log('Buzz')
  } else if (cnt % 3 === 0) {
    console.log('Fizz')
  } else {
    console.log(cnt)
  }
}
