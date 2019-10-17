Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECE0DDABB0
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 14:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388686AbfJQMGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 08:06:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40382 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfJQMGX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 08:06:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id b24so2259261wmj.5
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 05:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LZzJ3I4tLtzy2FRgQwW42N1IgvvYvkv/+5HSMh5tJEU=;
        b=dbXRzSOkr+CnP0bAkyiJmt5n0ghKDURR6OUgO43dGLqINkfGGeN6t7p66AZlFgiaNP
         LiHELxgXu4RXpEBJ7mKezBJA+jnIUrR4eVgcqze58rVlykRGRW8CWLelMuV3OGVGadYO
         lo0S7yUZFryLWyQ9s3jo8UbXCg7CcGSC77mwVgjReE5+ArUbsUqeizAYNHC1QvyUYI/o
         8JWQmBMts5RzPMqQG/2DF+IAp6Y4aEtCtSJSPgZJriYlJQ8YLEESBNr6BwfhQrUmLO8e
         m3sY/HT9UK8mq6VpjyURRZKW0do3+UIiLOSOwiDFibVBmUpy7IR8wuClFrZRZhND1e7L
         eYpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LZzJ3I4tLtzy2FRgQwW42N1IgvvYvkv/+5HSMh5tJEU=;
        b=gaRJ7md88URD9UPpLMycoOZKD7nb3Du5EB9hSWr9jPNU952LjINUQsx4FL3dQcal+u
         RQBJV1W4SpkJzW/I7MDNh2jV4Dmkp/jIvasDlnkRbIkfg2I+mgW0KVFCzmFFOJgqvy4X
         1XAB4BjQZNNsZ0y8WuLi5ugWNfwutfsvi/39OrtTy5HViaJe4qvjSKTtcF7sh7FWVQWC
         bHNTDWXv1KYdjZvc5UnpT96Sj9dsDZgmL43tsW3ZVkS/lDjRZI2xyu/51gjaslFMH/mU
         hZak0+7Q3+abCwscStRBmLCWWI5Yl7fiaXwVEccusKrMmpzEBcfr63kt37lNgQqUkZO+
         5d/w==
X-Gm-Message-State: APjAAAXeoSR9okSm2ZQlvFGdFttMHbYswjSN4LZdvFYLI+dUDFOtKahx
        jHJqaeu2sWtgFxCzeTL9UcwZTQ==
X-Google-Smtp-Source: APXvYqxfkjwUUidP3f2qsZR5pT5FnPkFytKX8V4CfQIKvYK1jyhlwBxg8da1HjFexLHL0kfw0LKtTA==
X-Received: by 2002:a7b:cf0d:: with SMTP id l13mr2488556wmg.47.1571313980718;
        Thu, 17 Oct 2019 05:06:20 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id i18sm1879217wrx.14.2019.10.17.05.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 05:06:20 -0700 (PDT)
Date:   Thu, 17 Oct 2019 15:06:17 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     brouer@redhat.com, saeedm@mellanox.com, tariqt@mellanox.com,
        netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 04/10 net-next] page_pool: Add API to update numa node
 and flush page caches
Message-ID: <20191017120617.GA19322@apalos.home>
References: <20191016225028.2100206-1-jonathan.lemon@gmail.com>
 <20191016225028.2100206-5-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016225028.2100206-5-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Saeed,

On Wed, Oct 16, 2019 at 03:50:22PM -0700, Jonathan Lemon wrote:
> From: Saeed Mahameed <saeedm@mellanox.com>
> 
> Add page_pool_update_nid() to be called from drivers when they detect
> numa node changes.
> 
> It will do:
> 1) Flush the pool's page cache and ptr_ring.
> 2) Update page pool nid value to start allocating from the new numa
> node.
> 
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/net/page_pool.h | 10 ++++++++++
>  net/core/page_pool.c    | 16 +++++++++++-----
>  2 files changed, 21 insertions(+), 5 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 2cbcdbdec254..fb13cf6055ff 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -226,4 +226,14 @@ static inline bool page_pool_put(struct page_pool *pool)
>  	return refcount_dec_and_test(&pool->user_cnt);
>  }
>  
> +/* Only safe from napi context or when user guarantees it is thread safe */
> +void __page_pool_flush(struct page_pool *pool);

This should be called per packet right? Any noticeable impact on performance?

> +static inline void page_pool_update_nid(struct page_pool *pool, int new_nid)
> +{
> +	if (unlikely(pool->p.nid != new_nid)) {
> +		/* TODO: Add statistics/trace */
> +		__page_pool_flush(pool);
> +		pool->p.nid = new_nid;
> +	}
> +}
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..678cf85f273a 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -373,16 +373,13 @@ void __page_pool_free(struct page_pool *pool)
>  }
>  EXPORT_SYMBOL(__page_pool_free);
>  
> -/* Request to shutdown: release pages cached by page_pool, and check
> - * for in-flight pages
> - */
> -bool __page_pool_request_shutdown(struct page_pool *pool)
> +void __page_pool_flush(struct page_pool *pool)
>  {
>  	struct page *page;
>  
>  	/* Empty alloc cache, assume caller made sure this is
>  	 * no-longer in use, and page_pool_alloc_pages() cannot be
> -	 * call concurrently.
> +	 * called concurrently.
>  	 */
>  	while (pool->alloc.count) {
>  		page = pool->alloc.cache[--pool->alloc.count];
> @@ -393,6 +390,15 @@ bool __page_pool_request_shutdown(struct page_pool *pool)
>  	 * be in-flight.
>  	 */
>  	__page_pool_empty_ring(pool);
> +}
> +EXPORT_SYMBOL(__page_pool_flush);

A later patch removes this, do we actually need it here?

> +
> +/* Request to shutdown: release pages cached by page_pool, and check
> + * for in-flight pages
> + */
> +bool __page_pool_request_shutdown(struct page_pool *pool)
> +{
> +	__page_pool_flush(pool);
>  
>  	return __page_pool_safe_to_destroy(pool);
>  }
> -- 
> 2.17.1
> 


Thanks
/Ilias
