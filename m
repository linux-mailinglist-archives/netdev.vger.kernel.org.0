Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F75FF570D
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389724AbfKHTQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:16:46 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44597 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbfKHTQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:16:46 -0500
Received: by mail-pg1-f193.google.com with SMTP id f19so4526342pgk.11
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 11:16:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvlN34Wj8F3p3Rp4+zPhD3Iza6mz+Zo9zKKsYvWGiEU=;
        b=YAN7Jc+A/aJbJNrbF+tY30kxNVtkVytBzStZ9d6lTcqLcS1waAsCEWR2ocXkdmuJ9s
         ZzYI2OlF4nb26y+7BcZ9EehOLu05H4eLvupy/+2NDfXN+2idA65aujU429rlBvVmxewm
         SuUFHkjPcaLHpBdBk+WGZQiWbE+8W04ElKMfxFgb8wTxC8j8QsCy0oq3gsbPjOQoJmv5
         ImSruE6FI7c7HX+jExqomEwu8rV2SKx95gwBUJG4MIPY3kFEMuokln9OewWF83oMBe6p
         xXEgz8UYugLB5+C+qpsCRxVjRrSV9uhXbqyVG/UgSjj4EfYEimshoacwr/v27NYaOd6x
         FvSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvlN34Wj8F3p3Rp4+zPhD3Iza6mz+Zo9zKKsYvWGiEU=;
        b=sUTwdoqgZtnJgtXe8ilqJqZHagFaAS9bIGA9UZCc35s059I15jtWUyOwcHauPTyz6z
         p7qVqU4kkCS47GQlrR7sw/SoUkCMzmsivt1XuZw0mYFm7pd/kP7if4yZGi9Kt2aja+qz
         pckfRw4c38UuqKsgNuuYP3qXHJLURzSUcR+Onf5hqpsZXkOAVycnhsAU6LdT5BFjmfQ9
         XuTPxkh0Rk04hfpf53wSXJiNvKd+mvZKHI0XAhewMhOk7Uq4GmEKRNDsCCWYLEypPbqD
         oAVxoDX5eZ5hwMsLht5x3xB6IRN6OqSTRuMXWNEypmNjWO94pPDAws6U8pdy05CKV7R/
         dBsg==
X-Gm-Message-State: APjAAAWR+ogniAK7I1AeUT6Wt7HVd1ENAGZ/IM76THGy8vxW8AkQcRBC
        EYO3rgAQMe2hbtOJKMSfErI=
X-Google-Smtp-Source: APXvYqwjUbZPhXSfv1/Aa9w34sf0VIeZizidr21HGQWbx4qoLBbwG3l/LStGU2nmOdtsuDcsuwNL/w==
X-Received: by 2002:a63:2226:: with SMTP id i38mr13706087pgi.50.1573240604487;
        Fri, 08 Nov 2019 11:16:44 -0800 (PST)
Received: from [172.20.40.253] ([2620:10d:c090:200::3:c214])
        by smtp.gmail.com with ESMTPSA id t13sm7224386pfh.12.2019.11.08.11.16.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Nov 2019 11:16:43 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Jesper Dangaard Brouer" <brouer@redhat.com>
Cc:     "Toke =?utf-8?b?SMO4aWxhbmQtSsO4cmdlbnNlbg==?=" <toke@redhat.com>,
        netdev@vger.kernel.org,
        "Ilias Apalodimas" <ilias.apalodimas@linaro.org>,
        "Saeed Mahameed" <saeedm@mellanox.com>,
        "Matteo Croce" <mcroce@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        "Tariq Toukan" <tariqt@mellanox.com>
Subject: Re: [net-next v1 PATCH 1/2] xdp: revert forced mem allocator removal
 for page_pool
Date:   Fri, 08 Nov 2019 11:16:43 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <80027E83-6C82-4238-AF7E-315F09457F43@gmail.com>
In-Reply-To: <157323722276.10408.11333995838112864686.stgit@firesoul>
References: <157323719180.10408.3472322881536070517.stgit@firesoul>
 <157323722276.10408.11333995838112864686.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 Nov 2019, at 10:20, Jesper Dangaard Brouer wrote:

> Forced removal of XDP mem allocator, specifically related to 
> page_pool, turned
> out to be a wrong approach.  Special thanks to Jonathan Lemon for 
> convincing me.
> This patch is a partial revert of commit d956a048cd3f (“xdp: force 
> mem allocator
> removal and periodic warning”).
>
> It is much better to provide a guarantee that page_pool object stays 
> valid
> until 'inflight' pages reach zero, making it safe to remove.
>
> We keep the periodic warning via a work-queue, but increased interval 
> to
> 5-minutes. The reason is to have a way to catch bugs, where inflight
> pages/packets never reach zero, indicating some kind of leak. These 
> kind of
> bugs have been observed while converting drivers over to use page_pool 
> API.
>
> Details on when to crash the kernel. If page_pool API is misused and
> somehow __page_pool_free() is invoked while there are still inflight
> frames, then (like before) a WARN() is triggered and not a BUG(). This 
> can
> potentially lead to use-after-free, which we try to catch via 
> poisoning the
> page_pool object memory with some NULL pointers. Doing it this way,
> pinpoint both the driver (likely) prematurely freeing page_pool via 
> WARN(),
> and crash-dump for inflight page/packet show who to blame for late 
> return.
>
> Fixes: d956a048cd3f (“xdp: force mem allocator removal and periodic 
> warning”)
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  include/trace/events/xdp.h |   35 +++--------------------------------
>  net/core/page_pool.c       |    8 ++++++--
>  net/core/xdp.c             |   36 
> +++++++++++++-----------------------
>  3 files changed, 22 insertions(+), 57 deletions(-)
>
> diff --git a/include/trace/events/xdp.h b/include/trace/events/xdp.h
> index c7e3c9c5bad3..a3ead2b1f00e 100644
> --- a/include/trace/events/xdp.h
> +++ b/include/trace/events/xdp.h
> @@ -318,9 +318,9 @@ __MEM_TYPE_MAP(__MEM_TYPE_TP_FN)
>  TRACE_EVENT(mem_disconnect,
>
>  	TP_PROTO(const struct xdp_mem_allocator *xa,
> -		 bool safe_to_remove, bool force),
> +		 bool safe_to_remove),
>
> -	TP_ARGS(xa, safe_to_remove, force),
> +	TP_ARGS(xa, safe_to_remove),
>
>  	TP_STRUCT__entry(
>  		__field(const struct xdp_mem_allocator *,	xa)
> @@ -328,7 +328,6 @@ TRACE_EVENT(mem_disconnect,
>  		__field(u32,		mem_type)
>  		__field(const void *,	allocator)
>  		__field(bool,		safe_to_remove)
> -		__field(bool,		force)
>  		__field(int,		disconnect_cnt)
>  	),
>
> @@ -338,17 +337,15 @@ TRACE_EVENT(mem_disconnect,
>  		__entry->mem_type	= xa->mem.type;
>  		__entry->allocator	= xa->allocator;
>  		__entry->safe_to_remove	= safe_to_remove;
> -		__entry->force		= force;
>  		__entry->disconnect_cnt	= xa->disconnect_cnt;
>  	),
>
>  	TP_printk("mem_id=%d mem_type=%s allocator=%p"
> -		  " safe_to_remove=%s force=%s disconnect_cnt=%d",
> +		  " safe_to_remove=%s disconnect_cnt=%d",
>  		  __entry->mem_id,
>  		  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
>  		  __entry->allocator,
>  		  __entry->safe_to_remove ? "true" : "false",
> -		  __entry->force ? "true" : "false",
>  		  __entry->disconnect_cnt
>  	)
>  );
> @@ -387,32 +384,6 @@ TRACE_EVENT(mem_connect,
>  	)
>  );
>
> -TRACE_EVENT(mem_return_failed,
> -
> -	TP_PROTO(const struct xdp_mem_info *mem,
> -		 const struct page *page),
> -
> -	TP_ARGS(mem, page),
> -
> -	TP_STRUCT__entry(
> -		__field(const struct page *,	page)
> -		__field(u32,		mem_id)
> -		__field(u32,		mem_type)
> -	),
> -
> -	TP_fast_assign(
> -		__entry->page		= page;
> -		__entry->mem_id		= mem->id;
> -		__entry->mem_type	= mem->type;
> -	),
> -
> -	TP_printk("mem_id=%d mem_type=%s page=%p",
> -		  __entry->mem_id,
> -		  __print_symbolic(__entry->mem_type, __MEM_TYPE_SYM_TAB),
> -		  __entry->page
> -	)
> -);
> -
>  #endif /* _TRACE_XDP_H */
>
>  #include <trace/define_trace.h>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..226f2eb30418 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -346,7 +346,7 @@ static void __warn_in_flight(struct page_pool 
> *pool)
>
>  	distance = _distance(hold_cnt, release_cnt);
>
> -	/* Drivers should fix this, but only problematic when DMA is used */
> +	/* BUG but warn as kernel should crash later */
>  	WARN(1, "Still in-flight pages:%d hold:%u released:%u",
>  	     distance, hold_cnt, release_cnt);
>  }
> @@ -360,12 +360,16 @@ void __page_pool_free(struct page_pool *pool)
>  	WARN(pool->alloc.count, "API usage violation");
>  	WARN(!ptr_ring_empty(&pool->ring), "ptr_ring is not empty");
>
> -	/* Can happen due to forced shutdown */
>  	if (!__page_pool_safe_to_destroy(pool))
>  		__warn_in_flight(pool);

If it's not safe to destroy, we shouldn't be getting here.



>  	ptr_ring_cleanup(&pool->ring, NULL);
>
> +	/* Make sure kernel will crash on use-after-free */
> +	pool->ring.queue = NULL;
> +	pool->alloc.cache[PP_ALLOC_CACHE_SIZE - 1] = NULL;
> +	pool->alloc.count = PP_ALLOC_CACHE_SIZE;

The pool is going to be freed.  This is useless code; if we're
really concerned about use-after-free, the correct place for catching
this is with the memory-allocator tools, not scattering things like
this ad-hoc over the codebase.


> +
>  	if (pool->p.flags & PP_FLAG_DMA_MAP)
>  		put_device(pool->p.dev);
>
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 20781ad5f9c3..8673f199d9f4 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -85,7 +85,7 @@ static void __xdp_mem_allocator_rcu_free(struct 
> rcu_head *rcu)
>  	kfree(xa);
>  }
>
> -static bool __mem_id_disconnect(int id, bool force)
> +static bool __mem_id_disconnect(int id)
>  {
>  	struct xdp_mem_allocator *xa;
>  	bool safe_to_remove = true;
> @@ -104,30 +104,26 @@ static bool __mem_id_disconnect(int id, bool 
> force)
>  	if (xa->mem.type == MEM_TYPE_PAGE_POOL)
>  		safe_to_remove = page_pool_request_shutdown(xa->page_pool);
>
> -	trace_mem_disconnect(xa, safe_to_remove, force);
> +	trace_mem_disconnect(xa, safe_to_remove);
>
> -	if ((safe_to_remove || force) &&
> +	if ((safe_to_remove) &&

Remove extra parenthesis.
-- 
Jonathan
