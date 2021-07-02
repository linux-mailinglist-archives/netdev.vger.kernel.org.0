Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D564D3B9C43
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 08:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbhGBGps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 02:45:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:50625 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbhGBGpq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Jul 2021 02:45:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625208194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NIZKTtb1jwEZjcV4ldpwwLBX6Xr32O8eSrh/qCluvFg=;
        b=cNGroAR+BcQ2RVnn8AxyFRCe1hta5PrW3LoLab8F1Pb0ZDyUj09CNrw7JhvavvoD5Z5mew
        dat2uQlpMSKjuv12kWrAAFBRVqSlfpM/RYFDW1/cE3JSwjpPV+LmtEQhBO114nDvETOOJb
        Q26rrO8NkyBfXzUBS7JnPhRURfGmUa0=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-EWQxFPWCOISsWEOoe9YL3w-1; Fri, 02 Jul 2021 02:43:13 -0400
X-MC-Unique: EWQxFPWCOISsWEOoe9YL3w-1
Received: by mail-pf1-f197.google.com with SMTP id d22-20020a056a0024d6b0290304cbae6fdcso5653361pfv.21
        for <netdev@vger.kernel.org>; Thu, 01 Jul 2021 23:43:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=NIZKTtb1jwEZjcV4ldpwwLBX6Xr32O8eSrh/qCluvFg=;
        b=r8GehPLtR4bkY9IUn3GnYcx2/vfAjjj2icNDax12+YY6hHDowFN8IrXdU65Vl0xS8W
         LZQsVziZQebuo74yXchMkvheuKSzVxyck4oN32CjVXzFRy1L46B6qSUsmU6fzqElDHQm
         hVGW7GCkhyZ4IavctwKr9aIOC6ME4K1VTUL31v7S3nuYsy9cuTFNuHd1bv92+NFB0h1y
         i8aiMo8yONQFy49XfVfUfOawJedboXbRcX6f3CsKnJ4ZlQiZ/GR00Ght/aRvJ9ffjclu
         Qia+fKt76OMFV1FnuNfW+on50J+As5RJKfhOGZrMZS9cTJphfDRaoCPfsdhoavNcV0TN
         DAzg==
X-Gm-Message-State: AOAM531VbyCHTR2hMKgLgz9JhgkwinmQ/IV41DcnQncdcqJm6rH4x6uN
        1+AnPAmSe+IxFDFC8Yd5HRi66T54jn3mtdJ3cPyCFfGAZCC+bdBWd0pJifOHDmTSukcLz/XJd0h
        ml40OG5+y6oZeGXRR
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr13829494pjs.47.1625208192480;
        Thu, 01 Jul 2021 23:43:12 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy8RBqMWjGesXmA7QADFcA80JK/C9xfE+4ue9p0+hy9GwBlzNiE8EMod0Nsdpmp7E2oSK8xqA==
X-Received: by 2002:a17:90a:bf03:: with SMTP id c3mr13829482pjs.47.1625208192174;
        Thu, 01 Jul 2021 23:43:12 -0700 (PDT)
Received: from wangxiaodeMacBook-Air.local ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j15sm2167117pfh.194.2021.07.01.23.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Jul 2021 23:43:11 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/3] selftests/ptr_ring: add benchmark
 application for ptr_ring
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, mst@redhat.com
Cc:     brouer@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        will@kernel.org, shuah@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linuxarm@openeuler.org
References: <1625142402-64945-1-git-send-email-linyunsheng@huawei.com>
 <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e1ec4577-a48f-ff56-b766-1445c2501b9f@redhat.com>
Date:   Fri, 2 Jul 2021 14:43:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1625142402-64945-2-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


ÔÚ 2021/7/1 ÏÂÎç8:26, Yunsheng Lin Ð´µÀ:
> Currently ptr_ring selftest is embedded within the virtio
> selftest, which involves some specific virtio operation,
> such as notifying and kicking.
>
> As ptr_ring has been used by various subsystems, it deserves
> it's owner selftest in order to benchmark different usecase
> of ptr_ring, such as page pool and pfifo_fast qdisc.
>
> So add a simple application to benchmark ptr_ring performance.
> Currently two test mode is supported:
> Mode 0: Both producing and consuming is done in a single thread,
>          it is called simple test mode in the test app.
> Mode 1: Producing and consuming is done in different thread
>          concurrently, also known as SPSC(single-producer/
>          single-consumer) test.
>
> The multi-producer/single-consumer test for pfifo_fast case is
> not added yet, which can be added if using CAS atomic operation
> to enable lockless multi-producer is proved to be better than
> using r->producer_lock.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V3: Remove timestamp sampling, use standard C library as much
>      as possible.
> ---
>   MAINTAINERS                                      |   5 +
>   tools/testing/selftests/ptr_ring/Makefile        |   6 +
>   tools/testing/selftests/ptr_ring/ptr_ring_test.c | 224 +++++++++++++++++++++++
>   tools/testing/selftests/ptr_ring/ptr_ring_test.h | 130 +++++++++++++
>   4 files changed, 365 insertions(+)
>   create mode 100644 tools/testing/selftests/ptr_ring/Makefile
>   create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.c
>   create mode 100644 tools/testing/selftests/ptr_ring/ptr_ring_test.h
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cc375fd..1227022 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14847,6 +14847,11 @@ F:	drivers/net/phy/dp83640*
>   F:	drivers/ptp/*
>   F:	include/linux/ptp_cl*
>   
> +PTR RING BENCHMARK
> +M:	Yunsheng Lin <linyunsheng@huawei.com>
> +L:	netdev@vger.kernel.org
> +F:	tools/testing/selftests/ptr_ring/
> +
>   PTRACE SUPPORT
>   M:	Oleg Nesterov <oleg@redhat.com>
>   S:	Maintained
> diff --git a/tools/testing/selftests/ptr_ring/Makefile b/tools/testing/selftests/ptr_ring/Makefile
> new file mode 100644
> index 0000000..346dea9
> --- /dev/null
> +++ b/tools/testing/selftests/ptr_ring/Makefile
> @@ -0,0 +1,6 @@
> +# SPDX-License-Identifier: GPL-2.0
> +LDLIBS = -lpthread
> +
> +TEST_GEN_PROGS := ptr_ring_test
> +
> +include ../lib.mk
> diff --git a/tools/testing/selftests/ptr_ring/ptr_ring_test.c b/tools/testing/selftests/ptr_ring/ptr_ring_test.c
> new file mode 100644
> index 0000000..4a5312f
> --- /dev/null
> +++ b/tools/testing/selftests/ptr_ring/ptr_ring_test.c
> @@ -0,0 +1,224 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2021 HiSilicon Limited.
> + */
> +
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <string.h>
> +#include <errno.h>
> +#include <malloc.h>
> +#include <stdbool.h>
> +
> +#include "ptr_ring_test.h"
> +#include "../../../../include/linux/ptr_ring.h"
> +
> +#define MIN_RING_SIZE	2
> +#define MAX_RING_SIZE	10000000
> +
> +static struct ptr_ring ring ____cacheline_aligned_in_smp;
> +
> +struct worker_info {
> +	pthread_t tid;
> +	int test_count;
> +	bool error;
> +};
> +
> +static void *produce_worker(void *arg)
> +{
> +	struct worker_info *info = arg;
> +	unsigned long i = 0;
> +	int ret;
> +
> +	while (++i <= info->test_count) {
> +		while (__ptr_ring_full(&ring))
> +			cpu_relax();
> +
> +		ret = __ptr_ring_produce(&ring, (void *)i);
> +		if (ret) {
> +			fprintf(stderr, "produce failed: %d\n", ret);
> +			info->error = true;
> +			return NULL;
> +		}
> +	}
> +
> +	info->error = false;
> +
> +	return NULL;
> +}
> +
> +static void *consume_worker(void *arg)
> +{
> +	struct worker_info *info = arg;
> +	unsigned long i = 0;
> +	int *ptr;
> +
> +	while (++i <= info->test_count) {
> +		while (__ptr_ring_empty(&ring))
> +			cpu_relax();


Any reason for not simply use __ptr_ring_consume() here?


> +
> +		ptr = __ptr_ring_consume(&ring);
> +		if ((unsigned long)ptr != i) {
> +			fprintf(stderr, "consumer failed, ptr: %lu, i: %lu\n",
> +				(unsigned long)ptr, i);
> +			info->error = true;
> +			return NULL;
> +		}
> +	}
> +
> +	if (!__ptr_ring_empty(&ring)) {
> +		fprintf(stderr, "ring should be empty, test failed\n");
> +		info->error = true;
> +		return NULL;
> +	}
> +
> +	info->error = false;
> +	return NULL;
> +}
> +
> +/* test case for single producer single consumer */
> +static void spsc_test(int size, int count)
> +{
> +	struct worker_info producer, consumer;
> +	pthread_attr_t attr;
> +	void *res;
> +	int ret;
> +
> +	ret = ptr_ring_init(&ring, size, 0);
> +	if (ret) {
> +		fprintf(stderr, "init failed: %d\n", ret);
> +		return;
> +	}
> +
> +	producer.test_count = count;
> +	consumer.test_count = count;
> +
> +	ret = pthread_attr_init(&attr);
> +	if (ret) {
> +		fprintf(stderr, "pthread attr init failed: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = pthread_create(&producer.tid, &attr,
> +			     produce_worker, &producer);
> +	if (ret) {
> +		fprintf(stderr, "create producer thread failed: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = pthread_create(&consumer.tid, &attr,
> +			     consume_worker, &consumer);
> +	if (ret) {
> +		fprintf(stderr, "create consumer thread failed: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = pthread_join(producer.tid, &res);
> +	if (ret) {
> +		fprintf(stderr, "join producer thread failed: %d\n", ret);
> +		goto out;
> +	}
> +
> +	ret = pthread_join(consumer.tid, &res);
> +	if (ret) {
> +		fprintf(stderr, "join consumer thread failed: %d\n", ret);
> +		goto out;
> +	}
> +
> +	if (producer.error || consumer.error) {
> +		fprintf(stderr, "spsc test failed\n");
> +		goto out;
> +	}
> +
> +	printf("ptr_ring(size:%d) perf spsc test produced/comsumed %d items, finished\n",
> +	       size, count);
> +out:
> +	ptr_ring_cleanup(&ring, NULL);
> +}
> +
> +static void simple_test(int size, int count)
> +{
> +	struct timeval start, end;
> +	int i = 0;
> +	int *ptr;
> +	int ret;
> +
> +	ret = ptr_ring_init(&ring, size, 0);
> +	if (ret) {
> +		fprintf(stderr, "init failed: %d\n", ret);
> +		return;
> +	}
> +
> +	while (++i <= count) {
> +		ret = __ptr_ring_produce(&ring, &count);
> +		if (ret) {
> +			fprintf(stderr, "produce failed: %d\n", ret);
> +			goto out;
> +		}
> +
> +		ptr = __ptr_ring_consume(&ring);
> +		if (ptr != &count)  {
> +			fprintf(stderr, "consume failed: %p\n", ptr);
> +			goto out;
> +		}
> +	}
> +
> +	printf("ptr_ring(size:%d) perf simple test produced/consumed %d items, finished\n",
> +	       size, count);
> +
> +out:
> +	ptr_ring_cleanup(&ring, NULL);
> +}
> +
> +int main(int argc, char *argv[])
> +{
> +	int count = 1000000;
> +	int size = 1000;
> +	int mode = 0;
> +	int opt;
> +
> +	while ((opt = getopt(argc, argv, "N:s:m:h")) != -1) {
> +		switch (opt) {
> +		case 'N':
> +			count = atoi(optarg);
> +			break;
> +		case 's':
> +			size = atoi(optarg);
> +			break;
> +		case 'm':
> +			mode = atoi(optarg);
> +			break;
> +		case 'h':
> +			printf("usage: ptr_ring_test [-N COUNT] [-s RING_SIZE] [-m TEST_MODE]\n");
> +			return 0;
> +		default:
> +			return -1;
> +		}
> +	}
> +
> +	if (count <= 0) {
> +		fprintf(stderr, "invalid test count, must be > 0\n");
> +		return -1;
> +	}
> +
> +	if (size < MIN_RING_SIZE || size > MAX_RING_SIZE) {
> +		fprintf(stderr, "invalid ring size, must be in %d-%d\n",
> +			MIN_RING_SIZE, MAX_RING_SIZE);
> +		return -1;
> +	}
> +
> +	switch (mode) {
> +	case 0:
> +		simple_test(size, count);
> +		break;
> +	case 1:
> +		spsc_test(size, count);
> +		break;
> +	default:
> +		fprintf(stderr, "invalid test mode\n");
> +		return -1;
> +	}
> +
> +	return 0;
> +}
> diff --git a/tools/testing/selftests/ptr_ring/ptr_ring_test.h b/tools/testing/selftests/ptr_ring/ptr_ring_test.h
> new file mode 100644
> index 0000000..32bfefb
> --- /dev/null
> +++ b/tools/testing/selftests/ptr_ring/ptr_ring_test.h


Let's reuse ptr_ring.c in tools/virtio/ringtest. Nothing virt specific 
there.

Thanks


> @@ -0,0 +1,130 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
> +#ifndef _TEST_PTR_RING_TEST_H
> +#define _TEST_PTR_RING_TEST_H
> +
> +#include <assert.h>
> +#include <stdatomic.h>
> +#include <pthread.h>
> +
> +/* Assuming the cache line size is 64 for most cpu,
> + * change it accordingly if the running cpu has different
> + * cache line size in order to get more accurate result.
> + */
> +#define SMP_CACHE_BYTES	64
> +
> +#define cpu_relax()	sched_yield()
> +#define smp_release()	atomic_thread_fence(memory_order_release)
> +#define smp_acquire()	atomic_thread_fence(memory_order_acquire)
> +#define smp_wmb()	smp_release()
> +#define smp_store_release(p, v)	\
> +		atomic_store_explicit(p, v, memory_order_release)
> +
> +#define READ_ONCE(x)		(*(volatile typeof(x) *)&(x))
> +#define WRITE_ONCE(x, val)	((*(volatile typeof(x) *)&(x)) = (val))
> +#define cache_line_size		SMP_CACHE_BYTES
> +#define unlikely(x)		(__builtin_expect(!!(x), 0))
> +#define likely(x)		(__builtin_expect(!!(x), 1))
> +#define ALIGN(x, a)		(((x) + (a) - 1) / (a) * (a))
> +#define SIZE_MAX		(~(size_t)0)
> +#define KMALLOC_MAX_SIZE	SIZE_MAX
> +#define spinlock_t		pthread_spinlock_t
> +#define gfp_t			int
> +#define __GFP_ZERO		0x1
> +
> +#define ____cacheline_aligned_in_smp \
> +		__attribute__((aligned(SMP_CACHE_BYTES)))
> +
> +static inline void *kmalloc(unsigned int size, gfp_t gfp)
> +{
> +	void *p;
> +
> +	p = memalign(64, size);
> +	if (!p)
> +		return p;
> +
> +	if (gfp & __GFP_ZERO)
> +		memset(p, 0, size);
> +
> +	return p;
> +}
> +
> +static inline void *kzalloc(unsigned int size, gfp_t flags)
> +{
> +	return kmalloc(size, flags | __GFP_ZERO);
> +}
> +
> +static inline void *kmalloc_array(size_t n, size_t size, gfp_t flags)
> +{
> +	if (size != 0 && n > SIZE_MAX / size)
> +		return NULL;
> +	return kmalloc(n * size, flags);
> +}
> +
> +static inline void *kcalloc(size_t n, size_t size, gfp_t flags)
> +{
> +	return kmalloc_array(n, size, flags | __GFP_ZERO);
> +}
> +
> +static inline void kfree(void *p)
> +{
> +	free(p);
> +}
> +
> +#define kvmalloc_array		kmalloc_array
> +#define kvfree			kfree
> +
> +static inline void spin_lock_init(spinlock_t *lock)
> +{
> +	int r = pthread_spin_init(lock, 0);
> +
> +	assert(!r);
> +}
> +
> +static inline void spin_lock(spinlock_t *lock)
> +{
> +	int ret = pthread_spin_lock(lock);
> +
> +	assert(!ret);
> +}
> +
> +static inline void spin_unlock(spinlock_t *lock)
> +{
> +	int ret = pthread_spin_unlock(lock);
> +
> +	assert(!ret);
> +}
> +
> +static inline void spin_lock_bh(spinlock_t *lock)
> +{
> +	spin_lock(lock);
> +}
> +
> +static inline void spin_unlock_bh(spinlock_t *lock)
> +{
> +	spin_unlock(lock);
> +}
> +
> +static inline void spin_lock_irq(spinlock_t *lock)
> +{
> +	spin_lock(lock);
> +}
> +
> +static inline void spin_unlock_irq(spinlock_t *lock)
> +{
> +	spin_unlock(lock);
> +}
> +
> +static inline void spin_lock_irqsave(spinlock_t *lock,
> +				     unsigned long f)
> +{
> +	spin_lock(lock);
> +}
> +
> +static inline void spin_unlock_irqrestore(spinlock_t *lock,
> +					  unsigned long f)
> +{
> +	spin_unlock(lock);
> +}
> +
> +#endif

