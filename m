Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF4BF8D374
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 14:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbfHNMtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 08:49:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:40574 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfHNMtH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 08:49:07 -0400
Received: by mail-wm1-f66.google.com with SMTP id v19so4350112wmj.5
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 05:49:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wtXCP3PVNeR7Ixq9R2seOhJ3HvM9g/McbRDIf16ibpI=;
        b=h8+fI3D0ryfekfRo8WRoZoM2SfMkds84oziHmShqFdIOjG9tmNUc2LyX6INzEVzI90
         fZ9eRxZNw3FiMy6KbCgUKL9iVLOWZj9Hw7Jf6aXJN/XNUa+bO2nzCcxTdClXZTxr5wVP
         Ihq6FSLGj8MqxgcEtOGKEngKo+lkT+8o2N6ac9hJxnyLhRYfpmKcgeSB8EqXHgK5qCTW
         xAwJaqr7M8ksO0Sm55HQtcnRKlGv3W0JsStAzLUDySTy+zHfCdMhboE4xy6Pi8PheVjd
         X72zViWzyVRAZprznkRJE6GpPNH6xFx2B4rA4cHT4lzhB3fJtKZcmORNKHvM7Dc4kUsS
         rkIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wtXCP3PVNeR7Ixq9R2seOhJ3HvM9g/McbRDIf16ibpI=;
        b=uaEuogl0QKJvE7f3iDxnKZN1v4pEaO6Rj6Aa3J/8m2Josq1mxJ8J92Mu1N+8unLkUM
         RRQTIoEIb4A/4spmv3P1D5J/c+oWsNAkeGAfEoK/HmClCZB+rGT6w3G0l1U1tDH2BbQf
         1s34/o7iNay9qgyKw3agiNkNBosh5KmKivG2poINm43HY2S0AHKD57Hio8Y8ID/hV2JR
         fmg6TRnMGtWCd3Hz+QgNv542ig2onpqf8AHzW/0Ia0MSTyc69nEa6nsdOiCHREJSI7Qn
         J5notncEuqxsbhcpetrzvvUbHOmPRQKmFDZDyNexmvCEPyIBFFh0IGmB4I/AWoR71OrU
         GdSw==
X-Gm-Message-State: APjAAAXzvH8J2uiZIVriPABVCANxBI8b06dtfMX3NIiRt9go4DixjMkO
        //fExhrVgV/Hlxy1XmCN2aictA==
X-Google-Smtp-Source: APXvYqw49vYEPjD+JueGthzRc/HgnPIiougHTzvjdZ7QheaIsQMr7ouTWTIk/2DNDfPFOFenmR/PEw==
X-Received: by 2002:a7b:c441:: with SMTP id l1mr8201142wmi.170.1565786944528;
        Wed, 14 Aug 2019 05:49:04 -0700 (PDT)
Received: from apalos (ppp-94-65-205-206.home.otenet.gr. [94.65.205.206])
        by smtp.gmail.com with ESMTPSA id v23sm5178081wmj.32.2019.08.14.05.49.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 05:49:03 -0700 (PDT)
Date:   Wed, 14 Aug 2019 15:49:01 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, brouer@redhat.com,
        saeedm@mellanox.com, ttoukan.linux@gmail.com, kernel-team@fb.com
Subject: Re: [PATCH net-next] page_pool: fix logic in __page_pool_get_cached
Message-ID: <20190814124901.GA25587@apalos>
References: <20190813174509.494723-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813174509.494723-1-jonathan.lemon@gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jonathan,

Thanks!

On Tue, Aug 13, 2019 at 10:45:09AM -0700, Jonathan Lemon wrote:
> __page_pool_get_cached() will return NULL when the ring is
> empty, even if there are pages present in the lookaside cache.
> 
> It is also possible to refill the cache, and then return a
> NULL page.
> 
> Restructure the logic so eliminate both cases.

Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>
> ---
>  net/core/page_pool.c | 39 ++++++++++++++++-----------------------
>  1 file changed, 16 insertions(+), 23 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 68510eb869ea..de09a74a39a4 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -82,12 +82,9 @@ EXPORT_SYMBOL(page_pool_create);
>  static struct page *__page_pool_get_cached(struct page_pool *pool)
>  {
>  	struct ptr_ring *r = &pool->ring;
> +	bool refill = false;
>  	struct page *page;
>  
> -	/* Quicker fallback, avoid locks when ring is empty */
> -	if (__ptr_ring_empty(r))
> -		return NULL;
> -
>  	/* Test for safe-context, caller should provide this guarantee */
>  	if (likely(in_serving_softirq())) {
>  		if (likely(pool->alloc.count)) {
> @@ -95,27 +92,23 @@ static struct page *__page_pool_get_cached(struct page_pool *pool)
>  			page = pool->alloc.cache[--pool->alloc.count];
>  			return page;
>  		}
> -		/* Slower-path: Alloc array empty, time to refill
> -		 *
> -		 * Open-coded bulk ptr_ring consumer.
> -		 *
> -		 * Discussion: the ring consumer lock is not really
> -		 * needed due to the softirq/NAPI protection, but
> -		 * later need the ability to reclaim pages on the
> -		 * ring. Thus, keeping the locks.
> -		 */
> -		spin_lock(&r->consumer_lock);
> -		while ((page = __ptr_ring_consume(r))) {
> -			if (pool->alloc.count == PP_ALLOC_CACHE_REFILL)
> -				break;
> -			pool->alloc.cache[pool->alloc.count++] = page;
> -		}
> -		spin_unlock(&r->consumer_lock);
> -		return page;
> +		refill = true;
>  	}
>  
> -	/* Slow-path: Get page from locked ring queue */
> -	page = ptr_ring_consume(&pool->ring);
> +	/* Quicker fallback, avoid locks when ring is empty */
> +	if (__ptr_ring_empty(r))
> +		return NULL;
> +
> +	/* Slow-path: Get page from locked ring queue,
> +	 * refill alloc array if requested.
> +	 */
> +	spin_lock(&r->consumer_lock);
> +	page = __ptr_ring_consume(r);
> +	if (refill)
> +		pool->alloc.count = __ptr_ring_consume_batched(r,
> +							pool->alloc.cache,
> +							PP_ALLOC_CACHE_REFILL);
> +	spin_unlock(&r->consumer_lock);
>  	return page;
>  }
>  
> -- 
> 2.17.1
> 
