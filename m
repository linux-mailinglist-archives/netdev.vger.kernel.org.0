Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8AC8D15935E
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 16:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgBKPkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 10:40:45 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:33968 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgBKPko (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 10:40:44 -0500
Received: by mail-wm1-f68.google.com with SMTP id s144so2537597wme.1
        for <netdev@vger.kernel.org>; Tue, 11 Feb 2020 07:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LgluzUZ4uwMBISIfpXssyf7lk8mCiobr/vdhSW1oW+U=;
        b=oa3WF+1weYNHavkOC4LgnqEpH752NIbrNvAKQpj7+lBnl7E3xAMUVRNF7gTbJ08Syu
         itvsTZAmGMZQPfAx8P8pNMqOQXMV/HqH5DeFwfj7jKQPXVFxz3QJM5BiIlGvS2Er6pR1
         8JMVB3BEBcc0aG52Vx/ppmwrH64sgXIcJJzodvo7J7NsIhOKbYPr7cIr6CzlRnw4vYDT
         UL6z2ztVJUz6OJMxDBtVSvM/i3Bj9wKP9qwb0HYWZaTCqCbE5yal7/Ka9Ea7XeY0PBw+
         HuYqd5mKzJ/MpFMgtEAD5M4DyHVRFAYgLIuAfCcgfBcVIhYDsvG3WUe8VjLwM9mk5Oo3
         wQqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LgluzUZ4uwMBISIfpXssyf7lk8mCiobr/vdhSW1oW+U=;
        b=L8F0+f5AcPTStv0pqDevot/kZEN21jBpdk49nwzKXwBxGjsBnviYNbkZgQnRkSjFPo
         L6vA9lawUE/q5WcUXx0JrfxiBgDTpTL4b1Vf2R0zxJoBdvv4cZtZLnVfTjZ1ygAT4Iij
         Ssg7dXyEhrgNRSeXHJdDDdWm1fl0BV9u7osIPq12WG7vrMLJdsZaeMBSl1liJ4O2hhZ3
         i9IskNASVm52CDRvwNkJGE/+Dk5jarUqkaetFI/zZl7mTTQV7z7ApAYmmcTRVbmnOohQ
         Wtmp4quFum1UxHacEwDBEIDPyhRriWKnEX6mJd68vdkkgdCJG65962J/pwDkbIUBCG2d
         35OQ==
X-Gm-Message-State: APjAAAWev7stG/bQSMA9qPwNywMOkFJZGNTaO8tg4vXilEyyQGCbrwRE
        0Mm4T3JwbXVaYtJolG9DG2kVMxl9K+4=
X-Google-Smtp-Source: APXvYqxNtYeXseLeIbWPn3BhGfeKZnyufvwRE/XdjBEZERSL4kyVq2HzPI5/bSuWu1nKSkc2uJ4u0A==
X-Received: by 2002:a1c:5401:: with SMTP id i1mr5846673wmb.99.1581435641979;
        Tue, 11 Feb 2020 07:40:41 -0800 (PST)
Received: from apalos.home (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id q130sm4574205wme.19.2020.02.11.07.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Feb 2020 07:40:41 -0800 (PST)
Date:   Tue, 11 Feb 2020 17:40:38 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     brouer@redhat.com, lorenzo@kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: page_pool: Add documentaion and examples on API
 usage
Message-ID: <20200211154038.GA1169429@apalos.home>
References: <20200211153746.1169339-1-ilias.apalodimas@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200211153746.1169339-1-ilias.apalodimas@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I accidentally send a wrong version.

Please igjnore this i'll send the proper one in a few minutes. 
Sorry for the noise.

On Tue, Feb 11, 2020 at 05:37:46PM +0200, Ilias Apalodimas wrote:
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> ---
>  Documentation/networking/page_pool.rst | 148 +++++++++++++++++++++++++
>  1 file changed, 148 insertions(+)
>  create mode 100644 Documentation/networking/page_pool.rst
> 
> diff --git a/Documentation/networking/page_pool.rst b/Documentation/networking/page_pool.rst
> new file mode 100644
> index 000000000000..877fc5332983
> --- /dev/null
> +++ b/Documentation/networking/page_pool.rst
> @@ -0,0 +1,148 @@
> +=============
> +Page Pool API
> +=============
> +
> +The page_pool allocator is optimized for the XDP mode that uses one frame 
> +per-page, but it can fallback on the regular page allocator APIs.
> +
> +Basic use involve replacing alloc_pages() calls with the
> +page_pool_alloc_pages() call.  Drivers should use page_pool_dev_alloc_pages() 
> +replacing dev_alloc_pages().
> +
> +API keeps track of in-flight pages, in-order to let API user know
> +when it is safe to free a page_pool object.  Thus, API users
> +must run page_pool_release_page() when a page is leaving the page_pool or
> +call page_pool_put_page() where appropriate in order to maintain correct
> +accounting.
> +
> +API user must call page_pool_put_page() once on a page, as it
> +will either recycle the page, or in case of refcnt > 1, it will
> +release the DMA mapping and in-flight state accounting.
> +
> +Architecture overview
> +=====================
> +
> +.. code-block:: none
> +
> +    +------------------+
> +    |       Driver     | 
> +    +------------------+
> +            ^ 
> +            |
> +            |
> +            |
> +            v
> +    +--------------------------------------------+
> +    |                request memory              | 
> +    +--------------------------------------------+
> +        ^                                  ^
> +        |                                  |
> +        | Pool empty                       | Pool has entries
> +        |                                  |
> +        v                                  v
> +    +-----------------------+     +------------------------+       
> +    | alloc (and map) pages |     |  get page from cache   |
> +    +-----------------------+     +------------------------+
> +                                    ^                    ^
> +                                    |                    |
> +                                    | in-softirq         |
> +                                    |                    |
> +                                    v                    v
> +                          +-----------------+     +------------------+  
> +                          |     Fast cache  |     |  ptr-ring cache  | 
> +                          +-----------------+     +------------------+
> +
> +API interface
> +=============
> +Ideally the number of pools created should match the number of hardware queuesm
> +unless other hardware restriction make that impossible. 
> +
> +* page_pool_create(): Create a pool.
> +    * flags:      PP_FLAG_DMA_MAP, PP_FLAG_DMA_SYNC_DEV
> +    * pool_size:  size of the ptr_ring
> +    * nid:        preferred NUMA node for allocation
> +    * dev:        struct device. Used on DMA operations
> +    * dma_dir:    DMA direction
> +    * max_len:    max DMA sync memory size
> +    * offset:     DMA address offset
> +
> +* page_pool_put_page(): The outcome of this depends on the page refcnt. If the
> +  driver uses refcnt > 1 this will unmap the page. If the pool object is
> +  responsible for DMA operations and account for the in-flight counting. 
> +  If the refcnt is 1, the allocator owns the page and will try to recycle and 
> +  sync it to be re-used by the device using dma_sync_single_range_for_device().
> +
> +* page_pool_release_page(): Unmap the page (if mapped) and account for it on
> +  inflight counters.
> +
> +* page_pool_dev_alloc_pages(): Get a page from the page allocator or page_pool 
> +  caches.
> +
> +* page_pool_get_dma_addr(): Retrieve the stored DMA address.
> +
> +* page_pool_get_dma_dir(): Retrieve the stored DMA direction.
> +
> +* page_pool_recycle_direct(): Recycle the page immediately. Must be used under
> +  NAPI context
> +
> +Coding examples
> +===============
> +
> +Registration
> +------------
> +
> +.. code-block:: c
> +
> +    /* Page pool registration */
> +    struct page_pool_params pp_params = { 0 };
> +    struct xdp_rxq_info xdp_rxq;
> +    int err;
> +
> +    pp_params.order = 0;
> +    /* internal DMA mapping in page_pool */
> +    pp_params.flags = PP_FLAG_DMA_MAP;
> +    pp_params.pool_size = DESC_NUM;
> +    pp_params.nid = NUMA_NO_NODE;
> +    pp_params.dev = priv->dev;
> +    pp_params.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE;
> +    page_pool = page_pool_create(&pp_params);
> +
> +    err = xdp_rxq_info_reg(&xdp_rxq, ndev, 0);
> +    if (err)
> +        goto err_out;
> +    
> +    err = xdp_rxq_info_reg_mem_model(&xdp_rxq, MEM_TYPE_PAGE_POOL, page_pool);
> +    if (err)
> +        goto err_out;
> +    
> +NAPI poller
> +-----------
> +
> +
> +.. code-block:: c
> +
> +    /* NAPI Rx poller */
> +    enum dma_data_direction dma_dir;
> +
> +    dma_dir = page_pool_get_dma_dir(dring->page_pool);
> +    while (done < budget) {
> +        if (some error)
> +            page_pool_recycle_direct(page_pool, page);
> +        if (packet_is_xdp) {
> +            if XDP_DROP:
> +                page_pool_recycle_direct(page_pool, page);
> +        } else (packet_is_skb) {
> +            page_pool_release_page(page_pool, page);
> +            new_page = page_pool_dev_alloc_pages(page_pool);
> +        }
> +    }
> +    
> +Driver unload
> +-------------
> +
> +.. code-block:: c
> +    
> +    /* Driver unload */
> +    page_pool_put_page(page_pool, page, false);
> +    xdp_rxq_info_unreg(&xdp_rxq);
> +    page_pool_destroy(page_pool);
> -- 
> 2.25.0
> 
