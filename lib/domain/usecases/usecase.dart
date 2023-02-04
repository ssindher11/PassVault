abstract class IUseCase<INPUT, RETURN>{
  RETURN execute(INPUT input);
}