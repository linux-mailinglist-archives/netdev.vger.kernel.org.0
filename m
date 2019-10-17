Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91CC0DA2EF
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 03:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388011AbfJQBPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 21:15:03 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:35046 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbfJQBPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 21:15:03 -0400
Received: by mail-lj1-f196.google.com with SMTP id m7so692397lji.2
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 18:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=2krbHMCfu14ORlk+dA0Xmo6kieS8ih6OuLMjHHpFx0M=;
        b=g4LtONhdSkCFlpR5XOVh7wzdZ/oiuCPI67SMVplYVSgJ9GdK7BBbkqg1VPt8udoVbA
         YdUInbNm8SDdqm0qVzY1Q01QPtatTL+kJIfGf0khcxyceRmxSaMn69I7XvlekrcwMWRC
         OmFoUN9RocZz9vd0JtfDzTZaSutf/kw5dsImQ6vfLA9EvPXqPUl5nHX5oH+YmpbfEZ6v
         H0919gA4hwsiMxgbKQ2h+OwODdSzq+UpfNdr6gEWLacARhV9I7cvKlh7Hen2v24px8WX
         /egDUK6ksLGhwrtjOb3smOtCrV0T5ovkyzrGsiBkVL0F2pO8i0gUvy2szMEYlpPOGVH0
         ybXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=2krbHMCfu14ORlk+dA0Xmo6kieS8ih6OuLMjHHpFx0M=;
        b=i1Dae4io1ngU607a+cte52myBCvgPQzEeXcwqjDrUbuQd+ePmcpAcPPwZgTe6Egb/p
         lGqadeuDi9OE1Bywnk1yoXFjwXNK5ALoCOH4IcjjsUsYF67GgrSOtM9BIMFwmRYmePT+
         CzGMpqcj12zcIVjj+O56uBjXxnEdlf2uxcVkdVVWes4T2634DeFieNgPfVFcSCEBAxwb
         Wz/Cfu2lylY6NYcFUUu1dmoREbcY/413s+Bi4rcK/QINp5KOWF/+uOK5dqvaUWtR8AcW
         GTiMtgXvK6ihIL3zKGCR6GYPWltomRySDeKD8ESIQrR/aTYVloX50X3Cqhy06PAyh2vB
         qR/Q==
X-Gm-Message-State: APjAAAVchtNpZfMxaMd+HEcnxIWZb/VouPgD7o3FJyxdsUCElNmkvkD4
        NNxeuhcKdftD7CqKI4cxBJ97wQ==
X-Google-Smtp-Source: APXvYqw+54o+wCmmTTn+PZZP3htX1F7z3fNAxmelaqg9mjj9r8aabphrTwcg/B1Rbs0U1/77LE9WAQ==
X-Received: by 2002:a2e:7312:: with SMTP id o18mr592456ljc.216.1571274900953;
        Wed, 16 Oct 2019 18:15:00 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x14sm203178lfe.3.2019.10.16.18.14.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2019 18:15:00 -0700 (PDT)
Date:   Wed, 16 Oct 2019 18:14:50 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com, mw@semihalf.com
Subject: Re: [PATCH v4 net-next 2/7] net: mvneta: introduce page pool API
 for sw buffer manager
Message-ID: <20191016181450.1729a2da@cakuba.netronome.com>
In-Reply-To: <c63e3b458e6b047f167322b31553d2ba384fd3d0.1571258792.git.lorenzo@kernel.org>
References: <cover.1571258792.git.lorenzo@kernel.org>
        <c63e3b458e6b047f167322b31553d2ba384fd3d0.1571258792.git.lorenzo@kernel.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 16 Oct 2019 23:03:07 +0200, Lorenzo Bianconi wrote:
> Use the page_pool api for allocations and DMA handling instead of
> __dev_alloc_page()/dma_map_page() and free_page()/dma_unmap_page().
> Pages are unmapped using page_pool_release_page before packets
> go into the network stack.
> 
> The page_pool API offers buffer recycling capabilities for XDP but
> allocates one page per packet, unless the driver splits and manages
> the allocated page.
> This is a preliminary patch to add XDP support to mvneta driver
> 
> Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/Kconfig  |  1 +
>  drivers/net/ethernet/marvell/mvneta.c | 77 ++++++++++++++++++++-------
>  2 files changed, 59 insertions(+), 19 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> index fb942167ee54..3d5caea096fb 100644
> --- a/drivers/net/ethernet/marvell/Kconfig
> +++ b/drivers/net/ethernet/marvell/Kconfig
> @@ -61,6 +61,7 @@ config MVNETA
>  	depends on ARCH_MVEBU || COMPILE_TEST
>  	select MVMDIO
>  	select PHYLINK
> +	select PAGE_POOL
>  	---help---
>  	  This driver supports the network interface units in the
>  	  Marvell ARMADA XP, ARMADA 370, ARMADA 38x and
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index 128b9fded959..9e4d828787fd 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -37,6 +37,7 @@
>  #include <net/ip.h>
>  #include <net/ipv6.h>
>  #include <net/tso.h>
> +#include <net/page_pool.h>
>  
>  /* Registers */
>  #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
> @@ -603,6 +604,10 @@ struct mvneta_rx_queue {
>  	u32 pkts_coal;
>  	u32 time_coal;
>  
> +	/* page_pool */
> +	struct page_pool *page_pool;
> +	struct xdp_rxq_info xdp_rxq;
> +
>  	/* Virtual address of the RX buffer */
>  	void  **buf_virt_addr;
>  
> @@ -1815,20 +1820,14 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
>  	dma_addr_t phys_addr;
>  	struct page *page;
>  
> -	page = __dev_alloc_page(gfp_mask);
> +	page = page_pool_alloc_pages(rxq->page_pool,
> +				     gfp_mask | __GFP_NOWARN);
>  	if (!page)
>  		return -ENOMEM;
>  
> -	/* map page for use */
> -	phys_addr = dma_map_page(pp->dev->dev.parent, page, 0, PAGE_SIZE,
> -				 DMA_FROM_DEVICE);
> -	if (unlikely(dma_mapping_error(pp->dev->dev.parent, phys_addr))) {
> -		__free_page(page);
> -		return -ENOMEM;
> -	}
> -
> -	phys_addr += pp->rx_offset_correction;
> +	phys_addr = page_pool_get_dma_addr(page) + pp->rx_offset_correction;
>  	mvneta_rx_desc_fill(rx_desc, phys_addr, page, rxq);
> +
>  	return 0;
>  }
>  
> @@ -1894,10 +1893,11 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
>  		if (!data || !(rx_desc->buf_phys_addr))
>  			continue;
>  
> -		dma_unmap_page(pp->dev->dev.parent, rx_desc->buf_phys_addr,
> -			       PAGE_SIZE, DMA_FROM_DEVICE);
> -		__free_page(data);
> +		page_pool_put_page(rxq->page_pool, data, false);
>  	}
> +	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
> +		xdp_rxq_info_unreg(&rxq->xdp_rxq);
> +	page_pool_destroy(rxq->page_pool);

I think you may need to set the page_pool pointer to NULL here, no?
AFAICT the ndo_stop in this driver has to be idempotent due to the
open/close-to-reconfigure dances.

>  }
>  
>  static void
> @@ -2029,8 +2029,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  				skb_add_rx_frag(rxq->skb, frag_num, page,
>  						frag_offset, frag_size,
>  						PAGE_SIZE);
> -				dma_unmap_page(dev->dev.parent, phys_addr,
> -					       PAGE_SIZE, DMA_FROM_DEVICE);
> +				page_pool_release_page(rxq->page_pool, page);
>  				rxq->left_size -= frag_size;
>  			}
>  		} else {
> @@ -2060,9 +2059,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  						frag_offset, frag_size,
>  						PAGE_SIZE);
>  
> -				dma_unmap_page(dev->dev.parent, phys_addr,
> -					       PAGE_SIZE, DMA_FROM_DEVICE);
> -
> +				page_pool_release_page(rxq->page_pool, page);
>  				rxq->left_size -= frag_size;
>  			}
>  		} /* Middle or Last descriptor */
> @@ -2829,11 +2826,53 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
>  	return rx_done;
>  }
>  
> +static int mvneta_create_page_pool(struct mvneta_port *pp,
> +				   struct mvneta_rx_queue *rxq, int size)
> +{
> +	struct page_pool_params pp_params = {
> +		.order = 0,
> +		.flags = PP_FLAG_DMA_MAP,
> +		.pool_size = size,
> +		.nid = cpu_to_node(0),
> +		.dev = pp->dev->dev.parent,
> +		.dma_dir = DMA_FROM_DEVICE,
> +	};
> +	int err;
> +
> +	rxq->page_pool = page_pool_create(&pp_params);
> +	if (IS_ERR(rxq->page_pool)) {
> +		err = PTR_ERR(rxq->page_pool);
> +		rxq->page_pool = NULL;
> +		return err;
> +	}
> +
> +	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, rxq->id);
> +	if (err < 0)
> +		goto err_free_pp;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 rxq->page_pool);
> +	if (err)
> +		goto err_unregister_rxq;
> +
> +	return 0;
> +
> +err_unregister_rxq:
> +	xdp_rxq_info_unreg(&rxq->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(rxq->page_pool);

ditto

> +	return err;
> +}
> +
>  /* Handle rxq fill: allocates rxq skbs; called when initializing a port */
>  static int mvneta_rxq_fill(struct mvneta_port *pp, struct mvneta_rx_queue *rxq,
>  			   int num)
>  {
> -	int i;
> +	int i, err;
> +
> +	err = mvneta_create_page_pool(pp, rxq, num);
> +	if (err < 0)
> +		return err;

Note that callers of mvneta_rxq_fill() never check the return code.
Some form of error print or such could be justified here.. although
actually propagating the error code all the way back to user space is
even better.

IMHO on device start the fill ring should be required to be filled up
completely, but that's just an opinion.

>  	for (i = 0; i < num; i++) {
>  		memset(rxq->descs + i, 0, sizeof(struct mvneta_rx_desc));
