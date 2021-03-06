//******************************************************************************
// Copyright (c) 2018, The Regents of the University of California (Regents).
// All Rights Reserved. See LICENSE for license details.
//------------------------------------------------------------------------------
#include "crypto.h"
#include "page.h"

void hash_init(hash_ctx* hash_ctx)
{
  sha3_init(hash_ctx, MDSIZE);
}

void hash_extend(hash_ctx* hash_ctx, const void* ptr, size_t len)
{
  sha3_update(hash_ctx, ptr, len);
}

void hash_extend_page(hash_ctx* hash_ctx, const void* ptr)
{
  sha3_update(hash_ctx, ptr, RISCV_PGSIZE);
}

void hash_finalize(void* md, hash_ctx* hash_ctx)
{
  sha3_final(md, hash_ctx);
}

void sign(void* sign, const void* data, size_t len, const unsigned char* public_key, const unsigned char* private_key)
{
  ed25519_sign(sign, data, len, public_key, private_key);
}
