Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E84E29A3
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 06:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408364AbfJXEuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 00:50:18 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45755 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406616AbfJXEuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 00:50:18 -0400
Received: by mail-wr1-f65.google.com with SMTP id q13so19424292wrs.12
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 21:50:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=y06Q/Nj0TUEUAKdrTl1QQFk37DR/57Jv6PraOWaNT1E=;
        b=gHzYSjLNNaVyeKtodWnu83f5LTAt50lmVwGyGUQ/wQXCVQohHlTlKd4p8UO9iMsfjA
         MpwWFl8ZKA5UNlaDPq/b+UhZP77BD1d5aistpva7SGtdjHmVM/vPNuNAA3MAIGqFfweN
         4hJ55yQrPeaxONan7Fmw1+pF7B/QflIMColr8rP9hTNp195ZhU99ldw7JFPQ76fNY3t+
         e8cYfXhKaP2W3LNjjOPTntCDnxiJ20/J6y2l4srHKxfFxQhqjnyDgTbNlmewXVIWsdzg
         SfU/zbsm9/eiYTxDPOPdn4m+AzTWmjJHQ5GhgW7NshguSIT/y9VY1m1LhPhQL0ZIyLtv
         OGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=y06Q/Nj0TUEUAKdrTl1QQFk37DR/57Jv6PraOWaNT1E=;
        b=FLtkNU0OPT8wsvLpueWNKymQ1hhtHIK4UwHlbpUurYy7ZMj6EOkHsJzCOJvXe5tMbZ
         paJBR3+1lGdV3byH0icYK0aN3H05UXp7Ce4Sp8vccX6wrMmpxSzaWYDiNcPExl5vSI+G
         XW02MQyxznjM5tUrxrG4FSkoMCHHx/XGS1BnnEdvdFMdk3hKnLqAKnX3EH75N85/Nqbc
         OC7WkSqKnan8T6WwpHk4otI0bKmaNxZnALAipV3cElsf+1Pc0w56hKHk+kVkDsuix/NI
         7F0/3pitUtJq2CXk9ezcj0NEWY4HuOr4F+0j9YZnRPLtGXjCg+S5ql0du8VtBebBMHPF
         xdTw==
X-Gm-Message-State: APjAAAWlfcDHNQNbvDXCtKQbml4Hry9mxubYe7HdafmFlzG4ximXvisz
        uBb8ENHSLQVE67rw0CSjFxKIEg==
X-Google-Smtp-Source: APXvYqz3/lQlhb3Yk0ZiNEjtrJu/QGj8J60QMyw6l53mquOP6zYNVr+7ot937dAd+QMy0eCFJrlMqQ==
X-Received: by 2002:a05:6000:92:: with SMTP id m18mr1923965wrx.105.1571892615871;
        Wed, 23 Oct 2019 21:50:15 -0700 (PDT)
Received: from apalos.home (ppp-94-65-92-5.home.otenet.gr. [94.65.92.5])
        by smtp.gmail.com with ESMTPSA id 200sm1826030wme.32.2019.10.23.21.50.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 21:50:15 -0700 (PDT)
Date:   Thu, 24 Oct 2019 07:50:13 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: Re: [PATCH net-nex V2 1/3] page_pool: Add API to update numa node
Message-ID: <20191024045013.GA537@apalos.home>
References: <20191023193632.26917-1-saeedm@mellanox.com>
 <20191023193632.26917-2-saeedm@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023193632.26917-2-saeedm@mellanox.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 07:36:58PM +0000, Saeed Mahameed wrote:
> Add page_pool_update_nid() to be called by page pool consumers when they
> detect numa node changes.
> 
> It will update the page pool nid value to start allocating from the new
> effective numa node.
> 
> This is to mitigate page pool allocating pages from a wrong numa node,
> where the pool was originally allocated, and holding on to pages that
> belong to a different numa node, which causes performance degradation.
> 
> For pages that are already being consumed and could be returned to the
> pool by the consumer, in next patch we will add a check per page to avoid
> recycling them back to the pool and return them to the page allocator.
> 
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  include/net/page_pool.h          |  7 +++++++
>  include/trace/events/page_pool.h | 22 ++++++++++++++++++++++
>  net/core/page_pool.c             |  8 ++++++++
>  3 files changed, 37 insertions(+)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 2cbcdbdec254..f46b78408e44 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -226,4 +226,11 @@ static inline bool page_pool_put(struct page_pool *pool)
>  	return refcount_dec_and_test(&pool->user_cnt);
>  }
>  
> +/* Caller must provide appropriate safe context, e.g. NAPI. */
> +void page_pool_update_nid(struct page_pool *pool, int new_nid);
> +static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
> +{
> +	if (unlikely(pool->p.nid != new_nid))
> +		page_pool_update_nid(pool, new_nid);
> +}
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/include/trace/events/page_pool.h b/include/trace/events/page_pool.h
> index 47b5ee880aa9..b58b6a3a3e57 100644
> --- a/include/trace/events/page_pool.h
> +++ b/include/trace/events/page_pool.h
> @@ -81,6 +81,28 @@ TRACE_EVENT(page_pool_state_hold,
>  		  __entry->pool, __entry->page, __entry->hold)
>  );
>  
> +TRACE_EVENT(page_pool_update_nid,
> +
> +	TP_PROTO(const struct page_pool *pool, int new_nid),
> +
> +	TP_ARGS(pool, new_nid),
> +
> +	TP_STRUCT__entry(
> +		__field(const struct page_pool *, pool)
> +		__field(int,			  pool_nid)
> +		__field(int,			  new_nid)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->pool		= pool;
> +		__entry->pool_nid	= pool->p.nid;
> +		__entry->new_nid	= new_nid;
> +	),
> +
> +	TP_printk("page_pool=%p pool_nid=%d new_nid=%d",
> +		  __entry->pool, __entry->pool_nid, __entry->new_nid)
> +);
> +
>  #endif /* _TRACE_PAGE_POOL_H */
>  
>  /* This part must be outside protection */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..953af6d414fb 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -397,3 +397,11 @@ bool __page_pool_request_shutdown(struct page_pool *pool)
>  	return __page_pool_safe_to_destroy(pool);
>  }
>  EXPORT_SYMBOL(__page_pool_request_shutdown);
> +
> +/* Caller must provide appropriate safe context, e.g. NAPI. */
> +void page_pool_update_nid(struct page_pool *pool, int new_nid)
> +{
> +	trace_page_pool_update_nid(pool, new_nid);
> +	pool->p.nid = new_nid;
> +}
> +EXPORT_SYMBOL(page_pool_update_nid);
> -- 
> 2.21.0
> 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
