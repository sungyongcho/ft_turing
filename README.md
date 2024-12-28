# ft_turing

## Resources

- [Designing a universal Turing machine](https://ftlsid.com/Computation/Designing+a+universal+Turing+machine)

## Calculate Time complexity

1. Infinite

실행 단계가 1,000,000 이상이면 복잡도를 무한으로 설정.

2. Linear (O(n)):

총 단계(steps)와 테이프 길이(tape_length)가 비슷한 경우.

3. Exponential (O(2^n)):

특정 상태의 방문 횟수(max_visits)가 테이프 길이의 두 배 이상인 경우.

4. Quadratic (O(n^2)):

특정 상태의 방문 횟수(max_visits)가 테이프 길이 이상인 경우.

5. Constant (O(1)):

위의 조건을 만족하지 않는 단순한 상태 변화.
