#!/bin/bash

if [[ -z "$srcdir" ]]; then
  srcdir=.
fi

### Addressbook message main tests.
rm -f t/addressbook.c.data

if [[ ! -f t/addressbook.c.text ]]; then
  exit 77
fi
if ! ./t/c-parse t/addressbook.c.data < t/addressbook.c.text; then
  exit 1;
fi

if ! cmp t/addressbook.c.data $srcdir/t/addressbook.data; then
  exit 1;
fi

rm -f t/broken_parse.data
for text in $srcdir/t/broken/*.text; do
  ./t/c-parse t/broken_parse.data < $text > t/broken_parse.out
  if ! $GREP ERROR t/broken_parse.out > /dev/null 2>&1; then
    echo "./t/c-parse t/broken_parse.data < $text"
    echo "This didn't fail as expected."
    exit 1;
  fi
  if [[ -f t/broken_parse.data ]]; then
    echo "Parse for $text worked but shouldn't have."
    exit 1;
  fi
done

### Tutorial Test message main tests.
rm -f t/tutorial_test.c.data

if [[ ! -f t/tutorial_test.c.text ]]; then
  exit 77
fi
if ./t/c-parse t/tutorial_test.c.data < t/tutorial_test.c.text > /dev/null; then
  echo "./t/c-parse t/tutorial_test.c.data < t/tutorial_test.c.text"
  echo "ERROR: should have failed."
  exit 1;
fi
if ! ./t/c-parse2 t/tutorial_test.c.data < t/tutorial_test.c.text; then
  echo "./t/c-parse2 t/tutorial_test.c.data < t/tutorial_test.c.text"
  echo "ERROR: should NOT have failed."
  exit 1;
fi

if ! cmp t/tutorial_test.c.data $srcdir/t/tutorial_test.data; then
  exit 1;
fi

rm -f t/broken_parse.data
for text in $srcdir/t/broken2/*.text; do
  ./t/c-parse2 t/broken_parse.data < $text > t/broken_parse.out
  if ! $GREP ERROR t/broken_parse.out > /dev/null 2>&1; then
    echo "./t/c-parse2 t/broken_parse.data < $text"
    echo "This didn't fail as expected."
    exit 1;
  fi
  if [[ -f t/broken_parse.data ]]; then
    echo "Parse for $text worked but shouldn't have."
    exit 1;
  fi
done

### Malloc failure tests.

echo -n "Testing broken malloc"
i=0
exit_code=1
#while [[ $exit_code -ne 0 && $i -lt 100 ]]; do
while [[ $i -lt 300 ]]; do
  echo -n .
  rm -f t/broken_parse.out t/broken_parse.data
  BROKEN_MALLOC=$i ./t/c-parse t/broken_parse.data \
    < t/addressbook.c.text > t/broken_parse.out
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    if ! $GREP ERROR t/broken_parse.out > /dev/null 2>&1; then
      cat << EOF
ERROR: This should have failed.
Debug:
BROKEN_MALLOC=$i gdb ./t/c-parse
run t/broken_parse.data < t/addressbook.c.text
EOF
      exit 1
    fi
  fi

  BROKEN_MALLOC=$i ./t/c-parse2 t/broken_parse.data \
    < t/tutorial_test.c.text > t/broken_parse.out
  exit_code=$?
  if [[ $exit_code -ne 0 ]]; then
    if ! $GREP ERROR t/broken_parse.out > /dev/null 2>&1; then
      cat << EOF
ERROR: This should have failed.
Debug:
BROKEN_MALLOC=$i gdb ./t/c-parse2
run t/broken_parse.data < t/tutorial_test.c.text
EOF
      exit 1
    fi
  fi

  i=$(($i + 1))
done
echo