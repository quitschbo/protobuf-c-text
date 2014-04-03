/** \file
 * Internal utility header file.
 * Macros used by the generator and parser parts of the library.
 *
 * \author Kevin Lyda <kevin@ie.suberic.net>
 * \date   March 2014
 */

/** \defgroup internal Internal API
 *
 * These are the functions and data structures used internally.  They are
 * not exported and are not useable by users of \c libprotobuf-c-text.
 */

#ifndef PROTOBUF_C_UTIL_H
#define PROTOBUF_C_UTIL_H

/* These are lifted from the protobuf-c lib */

#define STRUCT_MEMBER_P(struct_p, struct_offset) \
      ((void *) ((uint8_t *) (struct_p) + (struct_offset)))

#define STRUCT_MEMBER(member_type, struct_p, struct_offset) \
      (*(member_type *) STRUCT_MEMBER_P((struct_p), (struct_offset)))

#define STRUCT_MEMBER_PTR(member_type, struct_p, struct_offset) \
      ((member_type *) STRUCT_MEMBER_P((struct_p), (struct_offset)))

#endif /* PROTOBUF_C_UTIL_H */