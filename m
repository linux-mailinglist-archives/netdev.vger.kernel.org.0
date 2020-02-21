Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 221BC167012
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 08:13:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbgBUHNB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 02:13:01 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35811 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgBUHNA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 02:13:00 -0500
Received: by mail-wm1-f68.google.com with SMTP id b17so552344wmb.0
        for <netdev@vger.kernel.org>; Thu, 20 Feb 2020 23:12:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PhFfdTwDXpPikpaVyPBZxGv4NKL4I6GEFhIiAHj3uZ8=;
        b=imvfsasF2yvo+vTK8t9U4Mb5mXxGtnR4RWTTHnlJ0d/ijPjTde0qDmVioz8Diewb89
         zDaKGJdOWkjqXmJZQgkwqwNcJ9L5xYa7UoLC9qQfBPpbg8L9WsRrup14+B2P8zOd1QwM
         +yKfBEKbvyibSYlcxldekYJ5dXJhikLEQ/Crp/tmCE2Udnvj3O+odvF0T9NhJ1ZIzhT3
         o09dVVt+TFUg6jSK1Dp/WuVvulr/Q7fuhl5D+UIUUM/y7YLQFe1hMAVz4GAC3q3DdvDf
         uT6HlharLXWaSCHai8YsdBGLDJNbd1DDMa8VvqXyLMPyt1+nP3XuId6s7pQABGtQH4+b
         GDWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PhFfdTwDXpPikpaVyPBZxGv4NKL4I6GEFhIiAHj3uZ8=;
        b=iniPy7vVf9vUdamzBKE6Vb1hKpIAIovBQS2HsyBN1NJyc6lNpARoJO7vlWLMyca3GI
         gXOA2GsJM3RNDijBzoaxeQxTOJdCOilrY+CquASgmisYCFnCOsIERpeYr/N0TykBqDvK
         YSCoVasK16Pk90FnK4PXst5mD5aZO56WWKMSC4dJ28eYtlXPHZTu4+H7SrRpUBT1UXZT
         iN4PKIkS0cGSkJOQzEOH6Em6Y0YBoX6ZSLPj8V16TEwcpQajiJzRsW7omOL22ftCv/ka
         EPCB54huLq4+Jgsm3WHzj7owNq47Kjv6uETKFNh64a9xBjGAMlDZm01wlm4hoe/bTsH3
         edRg==
X-Gm-Message-State: APjAAAUrqNAa/iP1ZRWqvfrskQmmL4A2J0zFDDdzuFaQ9yYY5dTCfkRF
        50YJ2d2q2CpFdIPDW4+taFdUqziNalE=
X-Google-Smtp-Source: APXvYqwwo1I9zyJUV/xFKRmdiSAbNS0HOulHqXlu/IYkxv9F7aSw92+JQWSNcez5WkAHScP0EPk1Jw==
X-Received: by 2002:a1c:6189:: with SMTP id v131mr1893014wmb.185.1582269178736;
        Thu, 20 Feb 2020 23:12:58 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id 5sm2789979wrc.75.2020.02.20.23.12.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 23:12:57 -0800 (PST)
Date:   Fri, 21 Feb 2020 09:12:55 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     brouer@redhat.com, davem@davemloft.net, netdev@vger.kernel.org,
        lorenzo@kernel.org, toke@redhat.com
Subject: Re: [PATCH net-next] net: page_pool: Add documentation for page_pool
 API
Message-ID: <20200221071255.GA863284@apalos.home>
References: <20200220182521.859730-1-ilias.apalodimas@linaro.org>
 <0bfe362b-276d-21ad-24b9-67813c0cd50a@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bfe362b-276d-21ad-24b9-67813c0cd50a@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Randy, 
On Thu, Feb 20, 2020 at 04:14:00PM -0800, Randy Dunlap wrote:
> Hi again Ilias,
> 
> On 2/20/20 10:25 AM, Ilias Apalodimas wrote:
> > Add documentation explaining the basic functionality and design
> > principles of the API
> > 
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > ---
> >  Documentation/networking/page_pool.rst | 159 +++++++++++++++++++++++++
> >  1 file changed, 159 insertions(+)
> >  create mode 100644 Documentation/networking/page_pool.rst
> > 
> > diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
> > new file mode 100644
> > index 000000000000..098d339ef272
> > --- /dev/null
> > +++ b/Documentation/networking/page_pool.rst
> > @@ -0,0 +1,159 @@
> > +.. SPDX-License-Identifier: GPL-2.0
> > +
> > +=============
> > +Page Pool API
> > +=============
> > +
> > +The page_pool allocator is optimized for the XDP mode that uses one frame
> > +per-page, but it can fallback on the regular page allocator APIs.
> > +
> > +Basic use involve replacing alloc_pages() calls with the
> 
>              involves
> 

Ok

> > +page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages()
> > +replacing dev_alloc_pages().
> > +
> ...
> 
> > +
> > +Architecture overview
> > +=====================
> > +
> > +.. code-block:: none
> > +
> ...
> 
> > +
> > +API interface
> > +=============
> > +The number of pools created **must** match the number of hardware queues
> > +unless hardware restrictions make that impossible. This would otherwise beat the
> > +purpose of page pool, which is allocate pages fast from cache without locking.
> > +This lockless guarantee naturally comes from running under a NAPI softirq.
> > +The protection doesn't strictly have to be NAPI, any guarantee that allocating
> > +a page will cause no race conditions is enough.
> > +
> > +* page_pool_create(): Create a pool.
> > +    * flags:      PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV
> > +    * order:      order^n pages on allocation
> 
> what is "n" above?
> My quick reading of mm/page_alloc.c suggests that order is the power of 2
> that should be used for the memory allocation... ???

Yes this must change to 2^order

> 
> > +    * pool_size:  size of the ptr_ring
> > +    * nid:        preferred NUMA node for allocation
> > +    * dev:        struct device. Used on DMA operations
> > +    * dma_dir:    DMA direction
> > +    * max_len:    max DMA sync memory size
> > +    * offset:     DMA address offset
> > +
> ...
> 
> > +
> > +Coding examples
> > +===============
> > +
> > +Registration
> > +------------
> > +
> > +.. code-block:: c
> > +
> > +    /* Page pool registration */
> > +    struct page_pool_params pp_params = { 0 };
> > +    struct xdp_rxq_info xdp_rxq;
> > +    int err;
> > +
> > +    pp_params.order = 0;
> 
> so 0^n?

See above!

> 
> > +    /* internal DMA mapping in page_pool */
> > +    pp_params.flags = PP_FLAG_DMA_MAP;
> > +    pp_params.pool_size = DESC_NUM;
> > +    pp_params.nid = NUMA_NO_NODE;
> > +    pp_params.dev = priv->dev;
> > +    pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> > +    page_pool = page_pool_create(&pp_params);
> > +
> > +    err = xdp_rxq_info_reg(&xdp_rxq, ndev, 0);
> > +    if (err)
> > +        goto err_out;
> > +
> > +    err = xdp_rxq_info_reg_mem_model(&xdp_rxq, MEM_TYPE_PAGE_POOL, page_pool);
> > +    if (err)
> > +        goto err_out;
> > +
> > +NAPI poller
> > +-----------
> 
> thanks.

Thanks again for taking the time

> -- 
> ~Randy
> 

Cheers
/Ilias
