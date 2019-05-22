Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E63FD270D9
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 22:31:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729828AbfEVUbs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 May 2019 16:31:48 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:38307 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729667AbfEVUbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 May 2019 16:31:48 -0400
Received: by mail-pg1-f196.google.com with SMTP id v11so1892261pgl.5
        for <netdev@vger.kernel.org>; Wed, 22 May 2019 13:31:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=fpkFgLDXP9G54C/sZJbieYYzraDLAAMg1nxNNXKmHNY=;
        b=Muv8DY4aJPn9Pko98aP+kWI5GnSS8OFovtdDGEXbfvS7OUldHHf8L8jfd2ZAIfsgzs
         D7xVZfCYH2G3UfZloA1Osj4Rr7qG13BcOnfPuOkrvjuRhXNSH/ofGCSMXC9g7jJWPc1C
         1+e9a5NB4kEoi91//vEE8OnbgGcLLNM37EWACwGpjPnOyySIK/sLU0WjgfIok1Nagls0
         EjT5nSyvh3NRpeIO3c3tFYGHQoEBFFBjry6tepuZQndzCpvfDPWHoKZdcberqV+WqVHy
         QKQbw+AqE9OTMyDqtdl/R0tyWVK1rpmPH003j8N2FmvHtzj305wig2CBy6u+u80oYkvL
         GyTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=fpkFgLDXP9G54C/sZJbieYYzraDLAAMg1nxNNXKmHNY=;
        b=PDP0vXPOIJxJVHaMcOMb4g8/SszIjecIyCZxcdJXTjRsWfseXthRwqJIuZS7XvFe+M
         fq0D5bi2CScTWx3o2dOKrbdnRYQsD7XjofTSKbm1WMT6igyiWEo/a0m76QJL0XyM3EOi
         qjSdJxhSsL0Ar+SpaNNQvDqWm2XLM+Ln+7KcMcWcw4gXOb2jXJ/t8+DprKfbHGsJT6rh
         ybpTYlKz6k6WJZbvlDCZEkmPXIN+35XEeFe7ShdZz9JLLoHndfk0FwbY9axaZrDIlidc
         spsLOeI4Ey5KvY/Bw8DdEEdk19MO9p/Q173lbNyHc/NP6Zb9ldSxhM2gR3DCYaSE2qB5
         lT8w==
X-Gm-Message-State: APjAAAW5yu2rfFCbInWWvRBGgCAgj5oxSFxDpfwe4659gb9tc5+ngRVQ
        zc0NfkamZpmrLrkYTsqGEiHEyQ==
X-Google-Smtp-Source: APXvYqzrh4YBM+F2gF3Hu/p++opWE8+uMjSkMc4PcjStgtb1i+ZW9/LwVHE3dztHlXDcAsv/6snmQw==
X-Received: by 2002:a62:470e:: with SMTP id u14mr98846208pfa.31.1558557107548;
        Wed, 22 May 2019 13:31:47 -0700 (PDT)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id v1sm26843649pgb.85.2019.05.22.13.31.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 May 2019 13:31:47 -0700 (PDT)
Date:   Wed, 22 May 2019 13:31:46 -0700
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     andrii.nakryiko@gmail.com, ast@fb.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 06/12] selftests/bpf: add tests for libbpf's
 hashmap
Message-ID: <20190522203146.GP10244@mini-arch>
References: <20190522195053.4017624-1-andriin@fb.com>
 <20190522195053.4017624-7-andriin@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522195053.4017624-7-andriin@fb.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/22, Andrii Nakryiko wrote:
> Test all APIs for internal hashmap implementation.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/testing/selftests/bpf/.gitignore     |   1 +
>  tools/testing/selftests/bpf/Makefile       |   2 +-
>  tools/testing/selftests/bpf/test_hashmap.c | 382 +++++++++++++++++++++
>  3 files changed, 384 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/bpf/test_hashmap.c
> 
> diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
> index dd5d69529382..138b6c063916 100644
> --- a/tools/testing/selftests/bpf/.gitignore
> +++ b/tools/testing/selftests/bpf/.gitignore
> @@ -35,3 +35,4 @@ test_sysctl
>  alu32
>  libbpf.pc
>  libbpf.so.*
> +test_hashmap
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
> index 66f2dca1dee1..ddae06498a00 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -23,7 +23,7 @@ TEST_GEN_PROGS = test_verifier test_tag test_maps test_lru_map test_lpm_map test
>  	test_align test_verifier_log test_dev_cgroup test_tcpbpf_user \
>  	test_sock test_btf test_sockmap test_lirc_mode2_user get_cgroup_id_user \
>  	test_socket_cookie test_cgroup_storage test_select_reuseport test_section_names \
> -	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl
> +	test_netcnt test_tcpnotify_user test_sock_fields test_sysctl test_hashmap
>  
>  BPF_OBJ_FILES = $(patsubst %.c,%.o, $(notdir $(wildcard progs/*.c)))
>  TEST_GEN_FILES = $(BPF_OBJ_FILES)
> diff --git a/tools/testing/selftests/bpf/test_hashmap.c b/tools/testing/selftests/bpf/test_hashmap.c
> new file mode 100644
> index 000000000000..b64094c981e3
> --- /dev/null
[..]
> +++ b/tools/testing/selftests/bpf/test_hashmap.c
Any reason against putting it in bpf/prog_tests? No need for your own
CHECK macro and no Makefile changes.

> @@ -0,0 +1,382 @@
> +// SPDX-License-Identifier: (LGPL-2.1 OR BSD-2-Clause)
> +
> +/*
> + * Tests for libbpf's hashmap.
> + *
> + * Copyright (c) 2019 Facebook
> + */
> +#include <stdio.h>
> +#include <errno.h>
> +#include <linux/err.h>
> +#include "hashmap.h"
> +
> +#define CHECK(condition, format...) ({					\
> +	int __ret = !!(condition);					\
> +	if (__ret) {							\
> +		fprintf(stderr, "%s:%d:FAIL ", __func__, __LINE__);	\
> +		fprintf(stderr, format);				\
> +	}								\
> +	__ret;								\
> +})
> +
> +size_t hash_fn(const void *k, void *ctx)
> +{
> +	return (long)k;
> +}
> +
> +bool equal_fn(const void *a, const void *b, void *ctx)
> +{
> +	return (long)a == (long)b;
> +}
> +
> +static inline size_t next_pow_2(size_t n)
> +{
> +	size_t r = 1;
> +
> +	while (r < n)
> +		r <<= 1;
> +	return r;
> +}
> +
> +static inline size_t exp_cap(size_t sz)
> +{
> +	size_t r = next_pow_2(sz);
> +
> +	if (sz * 4 / 3 > r)
> +		r <<= 1;
> +	return r;
> +}
> +
> +#define ELEM_CNT 62
> +
> +int test_hashmap_generic(void)
> +{
> +	struct hashmap_entry *entry, *tmp;
> +	int err, bkt, found_cnt, i;
> +	long long found_msk;
> +	struct hashmap *map;
> +
> +	fprintf(stderr, "%s: ", __func__);
> +
> +	map = hashmap__new(hash_fn, equal_fn, NULL);
> +	if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
> +		return 1;
> +
> +	for (i = 0; i < ELEM_CNT; i++) {
> +		const void *oldk, *k = (const void *)(long)i;
> +		void *oldv, *v = (void *)(long)(1024 + i);
> +
> +		err = hashmap__update(map, k, v, &oldk, &oldv);
> +		if (CHECK(err != -ENOENT, "unexpected result: %d\n", err))
> +			return 1;
> +
> +		if (i % 2) {
> +			err = hashmap__add(map, k, v);
> +		} else {
> +			err = hashmap__set(map, k, v, &oldk, &oldv);
> +			if (CHECK(oldk != NULL || oldv != NULL,
> +				  "unexpected k/v: %p=%p\n", oldk, oldv))
> +				return 1;
> +		}
> +
> +		if (CHECK(err, "failed to add k/v %ld = %ld: %d\n",
> +			       (long)k, (long)v, err))
> +			return 1;
> +
> +		if (CHECK(!hashmap__find(map, k, &oldv),
> +			  "failed to find key %ld\n", (long)k))
> +			return 1;
> +		if (CHECK(oldv != v, "found value is wrong: %ld\n", (long)oldv))
> +			return 1;
> +	}
> +
> +	if (CHECK(hashmap__size(map) != ELEM_CNT,
> +		  "invalid map size: %zu\n", hashmap__size(map)))
> +		return 1;
> +	if (CHECK(hashmap__capacity(map) != exp_cap(hashmap__size(map)),
> +		  "unexpected map capacity: %zu\n", hashmap__capacity(map)))
> +		return 1;
> +
> +	found_msk = 0;
> +	hashmap__for_each_entry(map, entry, bkt) {
> +		long k = (long)entry->key;
> +		long v = (long)entry->value;
> +
> +		found_msk |= 1ULL << k;
> +		if (CHECK(v - k != 1024, "invalid k/v pair: %ld = %ld\n", k, v))
> +			return 1;
> +	}
> +	if (CHECK(found_msk != (1ULL << ELEM_CNT) - 1,
> +		  "not all keys iterated: %llx\n", found_msk))
> +		return 1;
> +
> +	for (i = 0; i < ELEM_CNT; i++) {
> +		const void *oldk, *k = (const void *)(long)i;
> +		void *oldv, *v = (void *)(long)(256 + i);
> +
> +		err = hashmap__add(map, k, v);
> +		if (CHECK(err != -EEXIST, "unexpected add result: %d\n", err))
> +			return 1;
> +
> +		if (i % 2)
> +			err = hashmap__update(map, k, v, &oldk, &oldv);
> +		else
> +			err = hashmap__set(map, k, v, &oldk, &oldv);
> +
> +		if (CHECK(err, "failed to update k/v %ld = %ld: %d\n",
> +			       (long)k, (long)v, err))
> +			return 1;
> +		if (CHECK(!hashmap__find(map, k, &oldv),
> +			  "failed to find key %ld\n", (long)k))
> +			return 1;
> +		if (CHECK(oldv != v, "found value is wrong: %ld\n", (long)oldv))
> +			return 1;
> +	}
> +
> +	if (CHECK(hashmap__size(map) != ELEM_CNT,
> +		  "invalid updated map size: %zu\n", hashmap__size(map)))
> +		return 1;
> +	if (CHECK(hashmap__capacity(map) != exp_cap(hashmap__size(map)),
> +		  "unexpected map capacity: %zu\n", hashmap__capacity(map)))
> +		return 1;
> +
> +	found_msk = 0;
> +	hashmap__for_each_entry_safe(map, entry, tmp, bkt) {
> +		long k = (long)entry->key;
> +		long v = (long)entry->value;
> +
> +		found_msk |= 1ULL << k;
> +		if (CHECK(v - k != 256,
> +			  "invalid updated k/v pair: %ld = %ld\n", k, v))
> +			return 1;
> +	}
> +	if (CHECK(found_msk != (1ULL << ELEM_CNT) - 1,
> +		  "not all keys iterated after update: %llx\n", found_msk))
> +		return 1;
> +
> +	found_cnt = 0;
> +	hashmap__for_each_key_entry(map, entry, (void *)0) {
> +		found_cnt++;
> +	}
> +	if (CHECK(!found_cnt, "didn't find any entries for key 0\n"))
> +		return 1;
> +
> +	found_msk = 0;
> +	found_cnt = 0;
> +	hashmap__for_each_key_entry_safe(map, entry, tmp, (void *)0) {
> +		const void *oldk, *k;
> +		void *oldv, *v;
> +
> +		k = entry->key;
> +		v = entry->value;
> +
> +		found_cnt++;
> +		found_msk |= 1ULL << (long)k;
> +
> +		if (CHECK(!hashmap__delete(map, k, &oldk, &oldv),
> +			  "failed to delete k/v %ld = %ld\n",
> +			  (long)k, (long)v))
> +			return 1;
> +		if (CHECK(oldk != k || oldv != v,
> +			  "invalid deleted k/v: expected %ld = %ld, got %ld = %ld\n",
> +			  (long)k, (long)v, (long)oldk, (long)oldv))
> +			return 1;
> +		if (CHECK(hashmap__delete(map, k, &oldk, &oldv),
> +			  "unexpectedly deleted k/v %ld = %ld\n",
> +			  (long)oldk, (long)oldv))
> +			return 1;
> +	}
> +
> +	if (CHECK(!found_cnt || !found_msk,
> +		  "didn't delete any key entries\n"))
> +		return 1;
> +	if (CHECK(hashmap__size(map) != ELEM_CNT - found_cnt,
> +		  "invalid updated map size (already deleted: %d): %zu\n",
> +		  found_cnt, hashmap__size(map)))
> +		return 1;
> +	if (CHECK(hashmap__capacity(map) != exp_cap(hashmap__size(map)),
> +		  "unexpected map capacity: %zu\n", hashmap__capacity(map)))
> +		return 1;
> +
> +	hashmap__for_each_entry_safe(map, entry, tmp, bkt) {
> +		const void *oldk, *k;
> +		void *oldv, *v;
> +
> +		k = entry->key;
> +		v = entry->value;
> +
> +		found_cnt++;
> +		found_msk |= 1ULL << (long)k;
> +
> +		if (CHECK(!hashmap__delete(map, k, &oldk, &oldv),
> +			  "failed to delete k/v %ld = %ld\n",
> +			  (long)k, (long)v))
> +			return 1;
> +		if (CHECK(oldk != k || oldv != v,
> +			  "invalid old k/v: expect %ld = %ld, got %ld = %ld\n",
> +			  (long)k, (long)v, (long)oldk, (long)oldv))
> +			return 1;
> +		if (CHECK(hashmap__delete(map, k, &oldk, &oldv),
> +			  "unexpectedly deleted k/v %ld = %ld\n",
> +			  (long)k, (long)v))
> +			return 1;
> +	}
> +
> +	if (CHECK(found_cnt != ELEM_CNT || found_msk != (1ULL << ELEM_CNT) - 1,
> +		  "not all keys were deleted: found_cnt:%d, found_msk:%llx\n",
> +		  found_cnt, found_msk))
> +		return 1;
> +	if (CHECK(hashmap__size(map) != 0,
> +		  "invalid updated map size (already deleted: %d): %zu\n",
> +		  found_cnt, hashmap__size(map)))
> +		return 1;
> +
> +	found_cnt = 0;
> +	hashmap__for_each_entry(map, entry, bkt) {
> +		CHECK(false, "unexpected map entries left: %ld = %ld\n",
> +			     (long)entry->key, (long)entry->value);
> +		return 1;
> +	}
> +
> +	hashmap__free(map);
> +	hashmap__for_each_entry(map, entry, bkt) {
> +		CHECK(false, "unexpected map entries left: %ld = %ld\n",
> +			     (long)entry->key, (long)entry->value);
> +		return 1;
> +	}
> +
> +	fprintf(stderr, "OK\n");
> +	return 0;
> +}
> +
> +size_t collision_hash_fn(const void *k, void *ctx)
> +{
> +	return 0;
> +}
> +
> +int test_hashmap_multimap(void)
> +{
> +	void *k1 = (void *)0, *k2 = (void *)1;
> +	struct hashmap_entry *entry;
> +	struct hashmap *map;
> +	long found_msk;
> +	int err, bkt;
> +
> +	fprintf(stderr, "%s: ", __func__);
> +
> +	/* force collisions */
> +	map = hashmap__new(collision_hash_fn, equal_fn, NULL);
> +	if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
> +		return 1;
> +
> +
> +	/* set up multimap:
> +	 * [0] -> 1, 2, 4;
> +	 * [1] -> 8, 16, 32;
> +	 */
> +	err = hashmap__append(map, k1, (void *)1);
> +	if (CHECK(err, "failed to add k/v: %d\n", err))
> +		return 1;
> +	err = hashmap__append(map, k1, (void *)2);
> +	if (CHECK(err, "failed to add k/v: %d\n", err))
> +		return 1;
> +	err = hashmap__append(map, k1, (void *)4);
> +	if (CHECK(err, "failed to add k/v: %d\n", err))
> +		return 1;
> +
> +	err = hashmap__append(map, k2, (void *)8);
> +	if (CHECK(err, "failed to add k/v: %d\n", err))
> +		return 1;
> +	err = hashmap__append(map, k2, (void *)16);
> +	if (CHECK(err, "failed to add k/v: %d\n", err))
> +		return 1;
> +	err = hashmap__append(map, k2, (void *)32);
> +	if (CHECK(err, "failed to add k/v: %d\n", err))
> +		return 1;
> +
> +	if (CHECK(hashmap__size(map) != 6,
> +		  "invalid map size: %zu\n", hashmap__size(map)))
> +		return 1;
> +
> +	/* verify global iteration still works and sees all values */
> +	found_msk = 0;
> +	hashmap__for_each_entry(map, entry, bkt) {
> +		found_msk |= (long)entry->value;
> +	}
> +	if (CHECK(found_msk != (1 << 6) - 1,
> +		  "not all keys iterated: %lx\n", found_msk))
> +		return 1;
> +
> +	/* iterate values for key 1 */
> +	found_msk = 0;
> +	hashmap__for_each_key_entry(map, entry, k1) {
> +		found_msk |= (long)entry->value;
> +	}
> +	if (CHECK(found_msk != (1 | 2 | 4),
> +		  "invalid k1 values: %lx\n", found_msk))
> +		return 1;
> +
> +	/* iterate values for key 2 */
> +	found_msk = 0;
> +	hashmap__for_each_key_entry(map, entry, k2) {
> +		found_msk |= (long)entry->value;
> +	}
> +	if (CHECK(found_msk != (8 | 16 | 32),
> +		  "invalid k2 values: %lx\n", found_msk))
> +		return 1;
> +
> +	fprintf(stderr, "OK\n");
> +	return 0;
> +}
> +
> +int test_hashmap_empty()
> +{
> +	struct hashmap_entry *entry;
> +	int bkt;
> +	struct hashmap *map;
> +	void *k = (void *)0;
> +
> +	fprintf(stderr, "%s: ", __func__);
> +
> +	/* force collisions */
> +	map = hashmap__new(hash_fn, equal_fn, NULL);
> +	if (CHECK(IS_ERR(map), "failed to create map: %ld\n", PTR_ERR(map)))
> +		return 1;
> +
> +	if (CHECK(hashmap__size(map) != 0,
> +		  "invalid map size: %zu\n", hashmap__size(map)))
> +		return 1;
> +	if (CHECK(hashmap__capacity(map) != 0,
> +		  "invalid map capacity: %zu\n", hashmap__capacity(map)))
> +		return 1;
> +	if (CHECK(hashmap__find(map, k, NULL), "unexpected find\n"))
> +		return 1;
> +	if (CHECK(hashmap__delete(map, k, NULL, NULL), "unexpected delete\n"))
> +		return 1;
> +
> +	hashmap__for_each_entry(map, entry, bkt) {
> +		CHECK(false, "unexpected iterated entry\n");
> +		return 1;
> +	}
> +	hashmap__for_each_key_entry(map, entry, k) {
> +		CHECK(false, "unexpected key entry\n");
> +		return 1;
> +	}
> +
> +	fprintf(stderr, "OK\n");
> +	return 0;
> +}
> +
> +int main(int argc, char **argv)
> +{
> +	bool failed = false;
> +
> +	if (test_hashmap_generic())
> +		failed = true;
> +	if (test_hashmap_multimap())
> +		failed = true;
> +	if (test_hashmap_empty())
> +		failed = true;
> +
> +	return failed;
> +}
> -- 
> 2.17.1
> 
