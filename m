Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C69063069
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 08:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725913AbfGIG1w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 02:27:52 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43304 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfGIG1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 02:27:52 -0400
Received: by mail-wr1-f65.google.com with SMTP id p13so439737wru.10
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 23:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v9n0VPjCG4CLC/xP/RIoyw4SMfXZlFvt1sPyiWaXrpM=;
        b=CLnZsfiZQJ/WSDb7t5XV9WjZYNU6LHAskeGdaLiJ6fApoX8qoSmno7y7pjGISI9z0E
         lomq+KUChej3SzayfesdMd2nJDi21CAdcphKZrEgEnJEqizceN4nvAKebmWfHbZwQ9w9
         p3uK1BqPrul3/EaLKtapHMsMYYgOP/KNMP4zstR7RqopjqhmxlySMbGV49P7kVZ+kEhk
         WF5VrDOT36qiMG4beM8aDyxDhEFdbWyzC6Tz5wZTTXzCrx3rtTEOED4WzaCb+tYpIsmk
         5ajam5k+Du5jldHE5cQG1ylWkKBerdSKGIGncYPdcPx4r+H1MIH7m63/niSkqvSTzSCQ
         iztw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=v9n0VPjCG4CLC/xP/RIoyw4SMfXZlFvt1sPyiWaXrpM=;
        b=PEi+dIkhnr6OmTNt3FFxZoaYDC4cygTCSRbON0eSMfYudzxlqw/WvNn2dDeXjViAk2
         U7zRVJ6icgNfGDs8MTIq6xjpr1kTBVIeYD1vDNQGotihLQ4Mdm7umxvyGMC4MdFpqxDP
         LC1mGHaIf2Z86JtCaV1kO2NImsx5Tj30wrNOgBgW/KHmFZ1MFG/ixr8OMUVvUGTtpy8J
         YvHRLYcTa+uw7QEXwZXPPQamEcqFtJsmtTqWDo92F0W//YADxhCdq4MhcKvEKM3u7AfR
         v9U2cL13xZHrdufdcBGPodA4I2QAR42SyIHSOWqHVzon5Yt+2tLQ7fkVgrdl7coCR82d
         ru/A==
X-Gm-Message-State: APjAAAUdbC0R/k3SiStXlJtGjdHwBxcC0CJQJx3mOPYvFjkugK5H29a/
        DCTsrZPUXCP8KmeqgTrGwOX7Ww==
X-Google-Smtp-Source: APXvYqwvhEzwLqcRhJnecWr/fFaaFr1xLYM3gXIoWxhthLSpLdARnoPGftpuuWw2PlA+MakwVL5+3w==
X-Received: by 2002:a5d:428c:: with SMTP id k12mr23826484wrq.81.1562653669183;
        Mon, 08 Jul 2019 23:27:49 -0700 (PDT)
Received: from apalos (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id y16sm17768286wru.28.2019.07.08.23.27.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 08 Jul 2019 23:27:48 -0700 (PDT)
Date:   Tue, 9 Jul 2019 09:27:46 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, gospo@broadcom.com, netdev@vger.kernel.org,
        hawk@kernel.org, ast@kernel.org
Subject: Re: [PATCH net-next v2 4/4] bnxt_en: add page_pool support
Message-ID: <20190709062746.GA621@apalos>
References: <1562622784-29918-1-git-send-email-michael.chan@broadcom.com>
 <1562622784-29918-5-git-send-email-michael.chan@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562622784-29918-5-git-send-email-michael.chan@broadcom.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andy, Michael,

On Mon, Jul 08, 2019 at 05:53:04PM -0400, Michael Chan wrote:
> From: Andy Gospodarek <gospo@broadcom.com>
> 
> This removes contention over page allocation for XDP_REDIRECT actions by
> adding page_pool support per queue for the driver.  The performance for
> XDP_REDIRECT actions scales linearly with the number of cores performing
> redirect actions when using the page pools instead of the standard page
> allocator.
> 
> v2: Fix up the error path from XDP registration, noted by Ilias Apalodimas.
> 
> Signed-off-by: Andy Gospodarek <gospo@broadcom.com>
> Signed-off-by: Michael Chan <michael.chan@broadcom.com>
> ---
>  drivers/net/ethernet/broadcom/Kconfig         |  1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c     | 47 +++++++++++++++++++++++----
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h     |  3 ++
>  drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c |  3 +-
>  4 files changed, 47 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/Kconfig b/drivers/net/ethernet/broadcom/Kconfig
> index 2e4a8c7..e9017ca 100644
> --- a/drivers/net/ethernet/broadcom/Kconfig
> +++ b/drivers/net/ethernet/broadcom/Kconfig
> @@ -199,6 +199,7 @@ config BNXT
>  	select FW_LOADER
>  	select LIBCRC32C
>  	select NET_DEVLINK
> +	select PAGE_POOL
>  	---help---
>  	  This driver supports Broadcom NetXtreme-C/E 10/25/40/50 gigabit
>  	  Ethernet cards.  To compile this driver as a module, choose M here:
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> index d8f0846..d25bb38 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
> @@ -54,6 +54,7 @@
>  #include <net/pkt_cls.h>
>  #include <linux/hwmon.h>
>  #include <linux/hwmon-sysfs.h>
> +#include <net/page_pool.h>
>  
>  #include "bnxt_hsi.h"
>  #include "bnxt.h"
> @@ -668,19 +669,20 @@ static void bnxt_tx_int(struct bnxt *bp, struct bnxt_napi *bnapi, int nr_pkts)
>  }
>  
>  static struct page *__bnxt_alloc_rx_page(struct bnxt *bp, dma_addr_t *mapping,
> +					 struct bnxt_rx_ring_info *rxr,
>  					 gfp_t gfp)
>  {
>  	struct device *dev = &bp->pdev->dev;
>  	struct page *page;
>  
> -	page = alloc_page(gfp);
> +	page = page_pool_dev_alloc_pages(rxr->page_pool);
>  	if (!page)
>  		return NULL;
>  
>  	*mapping = dma_map_page_attrs(dev, page, 0, PAGE_SIZE, bp->rx_dir,
>  				      DMA_ATTR_WEAK_ORDERING);
>  	if (dma_mapping_error(dev, *mapping)) {
> -		__free_page(page);
> +		page_pool_recycle_direct(rxr->page_pool, page);
>  		return NULL;
>  	}
>  	*mapping += bp->rx_dma_offset;
> @@ -716,7 +718,8 @@ int bnxt_alloc_rx_data(struct bnxt *bp, struct bnxt_rx_ring_info *rxr,
>  	dma_addr_t mapping;
>  
>  	if (BNXT_RX_PAGE_MODE(bp)) {
> -		struct page *page = __bnxt_alloc_rx_page(bp, &mapping, gfp);
> +		struct page *page =
> +			__bnxt_alloc_rx_page(bp, &mapping, rxr, gfp);
>  
>  		if (!page)
>  			return -ENOMEM;
> @@ -2360,7 +2363,7 @@ static void bnxt_free_rx_skbs(struct bnxt *bp)
>  				dma_unmap_page_attrs(&pdev->dev, mapping,
>  						     PAGE_SIZE, bp->rx_dir,
>  						     DMA_ATTR_WEAK_ORDERING);
> -				__free_page(data);
> +				page_pool_recycle_direct(rxr->page_pool, data);
>  			} else {
>  				dma_unmap_single_attrs(&pdev->dev, mapping,
>  						       bp->rx_buf_use_size,
> @@ -2497,6 +2500,8 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
>  		if (xdp_rxq_info_is_reg(&rxr->xdp_rxq))
>  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
>  
> +		rxr->page_pool = NULL;
> +
>  		kfree(rxr->rx_tpa);
>  		rxr->rx_tpa = NULL;
>  
> @@ -2511,6 +2516,26 @@ static void bnxt_free_rx_rings(struct bnxt *bp)
>  	}
>  }
>  
> +static int bnxt_alloc_rx_page_pool(struct bnxt *bp,
> +				   struct bnxt_rx_ring_info *rxr)
> +{
> +	struct page_pool_params pp = { 0 };
> +
> +	pp.pool_size = bp->rx_ring_size;
> +	pp.nid = dev_to_node(&bp->pdev->dev);
> +	pp.dev = &bp->pdev->dev;
> +	pp.dma_dir = DMA_BIDIRECTIONAL;
> +
> +	rxr->page_pool = page_pool_create(&pp);
> +	if (IS_ERR(rxr->page_pool)) {
> +		int err = PTR_ERR(rxr->page_pool);
> +
> +		rxr->page_pool = NULL;
> +		return err;
> +	}
> +	return 0;
> +}
> +
>  static int bnxt_alloc_rx_rings(struct bnxt *bp)
>  {
>  	int i, rc, agg_rings = 0, tpa_rings = 0;
> @@ -2530,14 +2555,24 @@ static int bnxt_alloc_rx_rings(struct bnxt *bp)
>  
>  		ring = &rxr->rx_ring_struct;
>  
> +		rc = bnxt_alloc_rx_page_pool(bp, rxr);
> +		if (rc)
> +			return rc;
> +
>  		rc = xdp_rxq_info_reg(&rxr->xdp_rxq, bp->dev, i);
> -		if (rc < 0)
> +		if (rc < 0) {
> +			page_pool_free(rxr->page_pool);

commit 1da4bbeffe41ba318812d7590955faee8636668b has been merged. Can you please
change this to page_pool_destroy(). Please note that this jhas to change for the
'normal' shutdown path as well (calling page_pool_destroy after
xdp_rxq_info_unreg)

> +			rxr->page_pool = NULL;
>  			return rc;
> +		}
>  
>  		rc = xdp_rxq_info_reg_mem_model(&rxr->xdp_rxq,
> -						MEM_TYPE_PAGE_SHARED, NULL);
> +						MEM_TYPE_PAGE_POOL,
> +						rxr->page_pool);
>  		if (rc) {
>  			xdp_rxq_info_unreg(&rxr->xdp_rxq);
> +			page_pool_free(rxr->page_pool);

ditto

> +			rxr->page_pool = NULL;
>  			return rc;
>  		}
>  
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> index 8ac51fa..16694b7 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> @@ -26,6 +26,8 @@
>  #include <net/xdp.h>
>  #include <linux/dim.h>
>  
> +struct page_pool;
> +
>  struct tx_bd {
>  	__le32 tx_bd_len_flags_type;
>  	#define TX_BD_TYPE					(0x3f << 0)
> @@ -799,6 +801,7 @@ struct bnxt_rx_ring_info {
>  	struct bnxt_ring_struct	rx_ring_struct;
>  	struct bnxt_ring_struct	rx_agg_ring_struct;
>  	struct xdp_rxq_info	xdp_rxq;
> +	struct page_pool	*page_pool;
>  };
>  
>  struct bnxt_cp_ring_info {
> diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> index 12489d2..c6f6f20 100644
> --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
> @@ -15,6 +15,7 @@
>  #include <linux/bpf.h>
>  #include <linux/bpf_trace.h>
>  #include <linux/filter.h>
> +#include <net/page_pool.h>
>  #include "bnxt_hsi.h"
>  #include "bnxt.h"
>  #include "bnxt_xdp.h"
> @@ -191,7 +192,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
>  
>  		if (xdp_do_redirect(bp->dev, &xdp, xdp_prog)) {
>  			trace_xdp_exception(bp->dev, xdp_prog, act);
> -			__free_page(page);
> +			page_pool_recycle_direct(rxr->page_pool, page);
>  			return true;
>  		}
>  
> -- 
> 2.5.1
> 

Thanks and sorry for the inconvenience :(
/Ilias
