#include "Platform.h"
#include "Errors.h"



#ifndef SSL_FUNC

    #ifdef OC_SSL_H
        #define SSL_FUNC(RETURN_TYPE, SSL_FunctionName, ARGS, STUB)
    #elif defined(OC_SSL_HAS_BACKEND)
        #define SSL_FUNC(RETURN_TYPE, SSL_FunctionName, ARGS, STUB) \
            RETURN_TYPE SSL_FunctionName ARGS;
    #else
        #define SSL_FUNC(RETURN_TYPE, SSL_FunctionName, ARGS, STUB) \
            static inline RETURN_TYPE SSL_FunctionName ARGS STUB
    #endif

#endif

CC_BEGIN_HEADER
/*
 * ClassiCube-compatible SSL header XMACRO
 */

SSL_FUNC(void, SSLBackend_Init, (cc_bool verifyCerts), { (void)verifyCerts; })
SSL_FUNC(cc_bool, SSLBackend_DescribeError, (cc_result res, cc_string* dst), { \
    (void)res; (void)dst; \
    return false; \
})

SSL_FUNC(cc_result, SSL_Init, (cc_socket socket, const cc_string* host, void** ctx), { \
    (void)socket; (void)host; (void)ctx; \
    return HTTP_ERR_NO_SSL; \
})

SSL_FUNC(cc_result, SSL_Read, (void* ctx, cc_uint8* data, cc_uint32 count, cc_uint32* read), { \
    (void)ctx; (void)data; (void)count; (void)read; \
    return ERR_NOT_SUPPORTED; \
})

SSL_FUNC(cc_result, SSL_Write, (void* ctx, const cc_uint8* data, cc_uint32 count, cc_uint32* sent), { \
    (void)ctx; (void)data; (void)count; (void)sent; \
    return ERR_NOT_SUPPORTED; \
})

SSL_FUNC(cc_result, SSL_Free, (void* ctx), { (void)ctx; return 0; })

CC_END_HEADER

#undef SSL_FUNC
#define OC_SSL_H 1
