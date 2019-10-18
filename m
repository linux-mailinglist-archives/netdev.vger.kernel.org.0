Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55EA9DD592
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 01:37:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387567AbfJRXhh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 19:37:37 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40914 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726986AbfJRXhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 19:37:36 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so3575469pll.7
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 16:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=AbQTW5Wzl1EsQax1FDTUtE+wc6z3h2TymO4XeJvWEro=;
        b=MG1j8WUmJcKYorgqt4qxNz5HDVBCjPT+tYyN1lbwum7Y5yV6kqG+b76fX5Qs6GCN9j
         OuPXH77hIH4niqAZcPob1KvzpIWuXIcrgh7BS/mZ4We5wNZEapWKE8JUV3HixQF/hKZG
         fcFm+abOZ4BnVB6jPLSoCekN/5omd5aVFJzD5HF/16AdesLil7K2zVJhCyxBUojtZI/V
         1lrMpR9izVh4WZWphms26dRJInm2fDfpO1HJFMsuPI+6C+qLOxOStUgsBqu694IbQOyr
         Q8TuK+aekji81/eEovasmHvTwxQeLiioH7T9FfUqAlAZUaA14PYYjzSgqxvrxOwO7oXm
         wOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=AbQTW5Wzl1EsQax1FDTUtE+wc6z3h2TymO4XeJvWEro=;
        b=N/r2DwduQ9VAUlIeY1uS2xO/C1KMeNebJUmq3Fb+o1XjWydk54y9VubwLEvIhHEe2k
         XBY/PxTUV+TjIfUBLqNLT84MnQCXPeuhViOo98FdyvJKBPd5oQKooy2cyq+2RgKWpZmD
         Dil4c1qaafSysehUWGh4MGDl/bYpecYaPngRpEp5DSVhAXBjFpNPy1EwQ0BKaqY3oDGc
         UXOIrsW5HDb+umRbpk4sFtzvKHWr7ERdpAUp6rzvRvo4xbqBRK0oqA8bPsX+W6CjXkq7
         I21+DOHO7xviZgoyKtX0mGpY7PdSqjkVR88SYrKSIZJjPaLt6XBq6Q/557XyIEAyN2aj
         +ihA==
X-Gm-Message-State: APjAAAW/opstJl1KQcuzkqbYInu5BYxnTAYsbMsN+yMRU0pixumyM3YO
        R9LAUTVFj7c0neLKFJzU1ec=
X-Google-Smtp-Source: APXvYqz5etaceF5OorsUC+vzQcAM0OKAFvLiFw+FVylW6e8MfSmQjWnaU+AhRv0QRzV8+yIOoohWAw==
X-Received: by 2002:a17:902:690a:: with SMTP id j10mr12468386plk.173.1571441855922;
        Fri, 18 Oct 2019 16:37:35 -0700 (PDT)
Received: from [172.20.162.151] ([2620:10d:c090:180::d0dd])
        by smtp.gmail.com with ESMTPSA id w12sm9222260pfq.138.2019.10.18.16.37.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 16:37:35 -0700 (PDT)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Saeed Mahameed" <saeedm@mellanox.com>
Cc:     ilias.apalodimas@linaro.org, "Tariq Toukan" <tariqt@mellanox.com>,
        brouer@redhat.com, kernel-team@fb.com, netdev@vger.kernel.org
Subject: Re: [PATCH 08/10 net-next] page_pool: Add statistics
Date:   Fri, 18 Oct 2019 16:37:34 -0700
X-Mailer: MailMate (1.13r5655)
Message-ID: <A370C7C4-FC02-4FC7-B215-585F6909A72A@gmail.com>
In-Reply-To: <1425b143f8ede0a5bea08c6ef45a78b41115b9d1.camel@mellanox.com>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-9-jonathan.lemon@gmail.com>
 <1425b143f8ede0a5bea08c6ef45a78b41115b9d1.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 18 Oct 2019, at 14:29, Saeed Mahameed wrote:

> On Wed, 2019-10-16 at 15:50 -0700, Jonathan Lemon wrote:
>> Add statistics to the page pool, providing visibility into its
>> operation.
>>
>> Callers can provide a location where the stats are stored, otherwise
>> the page pool will allocate a statistic area.
>>
>> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
>> ---
>>  include/net/page_pool.h | 21 +++++++++++++---
>>  net/core/page_pool.c    | 55 +++++++++++++++++++++++++++++++++++--
>> ----
>>  2 files changed, 65 insertions(+), 11 deletions(-)
>>
>> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
>> index fc340db42f9a..4f383522b141 100644
>> --- a/include/net/page_pool.h
>> +++ b/include/net/page_pool.h
>> @@ -34,8 +34,11 @@
>>  #include <linux/ptr_ring.h>
>>  #include <linux/dma-direction.h>
>>
>> -#define PP_FLAG_DMA_MAP 1 /* Should page_pool do the DMA map/unmap
>> */
>> -#define PP_FLAG_ALL	PP_FLAG_DMA_MAP
>> +#define PP_FLAG_DMA_MAP		BIT(0) /* page_pool does the
>> DMA map/unmap */
>> +#define PP_FLAG_ALL		(PP_FLAG_DMA_MAP)
>> +
>> +/* internal flags, not expoed to user */
>> +#define PP_FLAG_INTERNAL_STATS	BIT(8)
>>
>>  /*
>>   * Fast allocation side cache array/stack
>> @@ -57,6 +60,17 @@
>>  #define PP_ALLOC_POOL_DEFAULT	1024
>>  #define PP_ALLOC_POOL_LIMIT	32768
>>
>> +struct page_pool_stats {
>> +	u64 cache_hit;
>> +	u64 cache_full;
>> +	u64 cache_empty;
>> +	u64 ring_produce;
>> +	u64 ring_consume;
>> +	u64 ring_return;
>> +	u64 flush;
>> +	u64 node_change;
>> +};
>> +
>>  struct page_pool_params {
>>  	unsigned int	flags;
>>  	unsigned int	order;
>> @@ -65,6 +79,7 @@ struct page_pool_params {
>>  	int		nid;  /* Numa node id to allocate from pages
>> from */
>>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
>>  	struct device	*dev; /* device, for DMA pre-mapping purposes
>> */
>> +	struct page_pool_stats *stats; /* pool stats stored externally
>> */
>>  };
>>
>>  struct page_pool {
>> @@ -230,8 +245,8 @@ static inline bool page_pool_put(struct page_pool
>> *pool)
>>  static inline void page_pool_update_nid(struct page_pool *pool, int
>> new_nid)
>>  {
>>  	if (unlikely(pool->p.nid != new_nid)) {
>> -		/* TODO: Add statistics/trace */
>>  		pool->p.nid = new_nid;
>> +		pool->p.stats->node_change++;
>>  	}
>>  }
>>  #endif /* _NET_PAGE_POOL_H */
>> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
>> index f8fedecddb6f..ea6202813584 100644
>> --- a/net/core/page_pool.c
>> +++ b/net/core/page_pool.c
>> @@ -20,9 +20,10 @@
>>
>>  static int page_pool_init(struct page_pool *pool)
>>  {
>> +	int size;
>>
>>  	/* Validate only known flags were used */
>> -	if (pool->p.flags & ~(PP_FLAG_ALL))
>> +	if (pool->p.flags & ~PP_FLAG_ALL)
>>  		return -EINVAL;
>>
>>  	if (!pool->p.pool_size)
>> @@ -40,8 +41,16 @@ static int page_pool_init(struct page_pool *pool)
>>  	    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>>  		return -EINVAL;
>>
>> +	if (!pool->p.stats) {
>> +		size  = sizeof(struct page_pool_stats);
>> +		pool->p.stats = kzalloc_node(size, GFP_KERNEL, pool-
>>> p.nid);
>> +		if (!pool->p.stats)
>> +			return -ENOMEM;
>> +		pool->p.flags |= PP_FLAG_INTERNAL_STATS;
>> +	}
>> +
>>  	if (ptr_ring_init(&pool->ring, pool->p.pool_size, GFP_KERNEL) <
>> 0)
>> -		return -ENOMEM;
>> +		goto fail;
>>
>>  	atomic_set(&pool->pages_state_release_cnt, 0);
>>
>> @@ -52,6 +61,12 @@ static int page_pool_init(struct page_pool *pool)
>>  		get_device(pool->p.dev);
>>
>>  	return 0;
>> +
>> +fail:
>> +	if (pool->p.flags & PP_FLAG_INTERNAL_STATS)
>> +		kfree(pool->p.stats);
>> +
>> +	return -ENOMEM;
>>  }
>>
>>  struct page_pool *page_pool_create(const struct page_pool_params
>> *params)
>> @@ -98,9 +113,11 @@ static struct page *__page_pool_get_cached(struct
>> page_pool *pool)
>>  	if (likely(in_serving_softirq())) {
>>  		if (likely(pool->alloc_count)) {
>>  			/* Fast-path */
>> +			pool->p.stats->cache_hit++;
>>  			page = pool->alloc_cache[--pool->alloc_count];
>>  			return page;
>>  		}
>> +		pool->p.stats->cache_empty++;
>
> this is problematic for 32bit SMP archs, you need to use
> u64_stats_sync API.
> in mlx5 we only support 64bits, unlike page cache which must be
> protected here.

Oooh, hmm.

I think Apple had the right idea and discarded 32-bits
along with the iPhone 5.

Tempted to just make stats a NOP on 32-bit machines.
-- 
Jonathan


>
>>  		refill = true;
>>  	}
>>
>> @@ -113,10 +130,13 @@ static struct page
>> *__page_pool_get_cached(struct page_pool *pool)
>>  	 */
>>  	spin_lock(&r->consumer_lock);
>>  	page = __ptr_ring_consume(r);
>> -	if (refill)
>> +	if (refill) {
>>  		pool->alloc_count = __ptr_ring_consume_batched(r,
>>  							pool-
>>> alloc_cache,
>>  							PP_ALLOC_CACHE_
>> REFILL);
>> +		pool->p.stats->ring_consume += pool->alloc_count;
>> +	}
>> +	pool->p.stats->ring_consume += !!page;
>>  	spin_unlock(&r->consumer_lock);
>>  	return page;
>>  }
>> @@ -266,15 +286,23 @@ static void __page_pool_return_page(struct
>> page_pool *pool, struct page *page)
>>  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
>>  				   struct page *page)
>>  {
>> +	struct ptr_ring *r = &pool->ring;
>>  	int ret;
>>
>> -	/* BH protection not needed if current is serving softirq */
>>  	if (in_serving_softirq())
>> -		ret = ptr_ring_produce(&pool->ring, page);
>> +		spin_lock(&r->producer_lock);
>>  	else
>> -		ret = ptr_ring_produce_bh(&pool->ring, page);
>> +		spin_lock_bh(&r->producer_lock);
>>
>> -	return (ret == 0) ? true : false;
>> +	ret = __ptr_ring_produce(r, page);
>> +	pool->p.stats->ring_produce++;
>> +
>> +	if (in_serving_softirq())
>> +		spin_unlock(&r->producer_lock);
>> +	else
>> +		spin_unlock_bh(&r->producer_lock);
>> +
>> +	return ret == 0;
>>  }
>>
>>  /* Only allow direct recycling in special circumstances, into the
>> @@ -285,8 +313,10 @@ static bool __page_pool_recycle_into_ring(struct
>> page_pool *pool,
>>  static bool __page_pool_recycle_into_cache(struct page *page,
>>  					   struct page_pool *pool)
>>  {
>> -	if (unlikely(pool->alloc_count == pool->p.cache_size))
>> +	if (unlikely(pool->alloc_count == pool->p.cache_size)) {
>> +		pool->p.stats->cache_full++;
>>  		return false;
>> +	}
>>
>>  	/* Caller MUST have verified/know (page_ref_count(page) == 1)
>> */
>>  	pool->alloc_cache[pool->alloc_count++] = page;
>> @@ -343,6 +373,7 @@ EXPORT_SYMBOL(__page_pool_put_page);
>>  static void __page_pool_empty_ring(struct page_pool *pool)
>>  {
>>  	struct page *page;
>> +	int count = 0;
>>
>>  	/* Empty recycle ring */
>>  	while ((page = ptr_ring_consume_bh(&pool->ring))) {
>> @@ -351,8 +382,11 @@ static void __page_pool_empty_ring(struct
>> page_pool *pool)
>>  			pr_crit("%s() page_pool refcnt %d violation\n",
>>  				__func__, page_ref_count(page));
>>
>> +		count++;
>>  		__page_pool_return_page(pool, page);
>>  	}
>> +
>> +	pool->p.stats->ring_return += count;
>>  }
>>
>>  static void __warn_in_flight(struct page_pool *pool)
>> @@ -381,6 +415,9 @@ void __page_pool_free(struct page_pool *pool)
>>  	if (!__page_pool_safe_to_destroy(pool))
>>  		__warn_in_flight(pool);
>>
>> +	if (pool->p.flags & PP_FLAG_INTERNAL_STATS)
>> +		kfree(pool->p.stats);
>> +
>>  	ptr_ring_cleanup(&pool->ring, NULL);
>>
>>  	if (pool->p.flags & PP_FLAG_DMA_MAP)
>> @@ -394,6 +431,8 @@ static void page_pool_flush(struct page_pool
>> *pool)
>>  {
>>  	struct page *page;
>>
>> +	pool->p.stats->flush++;
>> +
>>  	/* Empty alloc cache, assume caller made sure this is
>>  	 * no-longer in use, and page_pool_alloc_pages() cannot be
>>  	 * called concurrently.
