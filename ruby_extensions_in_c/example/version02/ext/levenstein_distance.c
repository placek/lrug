#include "ruby.h"

long minimum(long a, long b, long c)
{
  if(a >= b)
    if(b >= c)
      return c;
    else
      return b;
  else
    if(c >= a)
      return a;

  return c;
}

/**
 * @brief This function calculatesthe Levenstein distance.
 * The arguments should be members of String ruby class.
 * Raises exception if not.
 * @author placek@ragnarson.com
 * @param left the first word
 * @param right the second word
 * @return Levenstein distance between two words
 */
static VALUE levenstein_distance(int argc, VALUE* argv)
{
  /* declarations */
  VALUE v_left, v_right;
  long left_length, right_length, i, j, cost, result;
  long ** distance;

  /* parameters validation */
  rb_scan_args(argc, argv, "20", &v_left, &v_right);
  Check_Type(v_left, T_STRING);
  Check_Type(v_right, T_STRING);

  /* initialization of calculation array */
  left_length = RSTRING_LEN(v_left);
  right_length = RSTRING_LEN(v_right);
  distance = (long**) malloc((left_length + 1) * sizeof(long*));

  for (i = 0; i <= left_length; i++)
  {
    distance[i] = (long*) malloc((right_length + 1) * sizeof(long));
    distance[i][0] = i;
  }
  for (j = 1; j <= right_length; j++)
  {
    distance[0][j] = j;
  }

  /* main algorithm */
  for(i = 1; i <= left_length; i++)
  {
    for(j = 1; j <= right_length; j++)
    {
      if(rb_str_cmp(rb_str_substr(v_left, i - 1, 1), rb_str_substr(v_right, j - 1, 1)) == 0)
        cost = 0;
      else
        cost = 1;

      distance[i][j] = minimum(distance[i - 1][j] + 1,
                               distance[i][j - 1] + 1,
                               distance[i - 1][j - 1] + cost);
    }
  }
  result = distance[left_length][right_length];

  /* cleaning up memory */
  for(i = 0; i <= left_length; i++)
  {
    free(distance[i]);
  }
  free(distance);

  return INT2NUM(result);
}

VALUE L;
void Init_levenstein_distance()
{
  L = rb_define_module("LevensteinDistance");
  rb_define_private_method(L, "leven", levenstein_distance, -1);
}
