Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8C2E830F
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 09:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728799AbfJ2IS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 04:18:57 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45885 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727331AbfJ2IS5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 04:18:57 -0400
Received: by mail-wr1-f66.google.com with SMTP id q13so12528267wrs.12
        for <netdev@vger.kernel.org>; Tue, 29 Oct 2019 01:18:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4SdJTSbyb8mN2+LRJYTgl7Evh8BicYYlmI3cP+T4BvE=;
        b=ha2Pt2hZhoat7c0KsH/UfUE+KoRr+rj4dV0Y4pCai/LBKc7R79WOMJ1VQSDkQ2NCK5
         4reLScctjAGfLFsR5+nBDu63fIfjhtiESltVDTQhjay9SmY/+ArbS6GmTzOVbG2foI9J
         qQYELmGQFbho1YA+kSE/lX413uGxTzeM0VKxrxpbpvquNhDA6+6hcg6KGXK4+9cAUMhf
         gDV/kmFi2ige+EkdvUelS9OTAn9rl21yc4YF8QifwY/JVAQK29wLYNLljQh/FT1V/mC2
         f6LNiqNiU6Lc4WWJaAtJqpuPAyGZt7cEfR+e0oXLvDZBquilUbVSBbAhYmZnHVohKzwF
         B9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4SdJTSbyb8mN2+LRJYTgl7Evh8BicYYlmI3cP+T4BvE=;
        b=DTMKXFL8IvlH9ZUFRVFXtjjq5U6KhRwOhuxPQzZM3y0NOYVEflC4Oe05tRrmdohvxP
         9MVTcFB9q6j3axqx/7Q0D+qIh97G+x6fOoKq9xPdYpgaVZVjiCyoHvingj4puuxY7mWw
         wNk1LQHBBdJTMtI08KuZiQRflvdu/tq6DoQQNa/U7G4xV4z4V25sUmnJ++K4c49fCJNc
         YB6Xx1FIO/39wBhJoCqtWJ5LnjR8czikOfXujYLHIC+CzvQKsPxNyM5wISvxYSePhhq4
         cCZSGHnEYlthB39KaRyoPiW6gBucR27uh+P0EDI3uA+5+H6eAl+3MQax7LLYNgRm2LAk
         QChw==
X-Gm-Message-State: APjAAAUJyBNIZbZq+LrR8ZvvrR6LHa/AHOeq1yHTtdnxWilsXFH78Zcz
        uSPZODW568duVGR0ugiUF8GMHA==
X-Google-Smtp-Source: APXvYqwWnix7WKFdfbqQnOih7xbWatpnTi+pztweIFWprvBMb49JaRljdnHL/Sl0i/wvyIBKz0Ts6w==
X-Received: by 2002:adf:ea8c:: with SMTP id s12mr17315119wrm.301.1572337134983;
        Tue, 29 Oct 2019 01:18:54 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id x7sm28842139wrg.63.2019.10.29.01.18.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 01:18:54 -0700 (PDT)
Date:   Tue, 29 Oct 2019 09:18:52 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Yangchun Fu <yangchun@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>
Subject: Re: [PATCH net] gve: Fixes DMA synchronization.
Message-ID: <20191029081851.GA23615@netronome.com>
References: <20191028182309.73313-1-yangchun@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191028182309.73313-1-yangchun@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yungchun,

thanks for your patch.

On Mon, Oct 28, 2019 at 11:23:09AM -0700, Yangchun Fu wrote:
> Synces the DMA buffer properly in order for CPU and device to see
> the most up-to-data data.
> 
> Signed-off-by: Yangchun Fu <yangchun@google.com>
> Reviewed-by: Catherine Sullivan <csully@google.com>
> ---
>  drivers/net/ethernet/google/gve/gve_rx.c |  2 ++
>  drivers/net/ethernet/google/gve/gve_tx.c | 26 ++++++++++++++++++++++--
>  2 files changed, 26 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
> index 59564ac99d2a..edec61dfc868 100644
> --- a/drivers/net/ethernet/google/gve/gve_rx.c
> +++ b/drivers/net/ethernet/google/gve/gve_rx.c
> @@ -289,6 +289,8 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
>  
>  	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
>  	page_info = &rx->data.page_info[idx];
> +	dma_sync_single_for_cpu(&priv->pdev->dev, rx->data.qpl->page_buses[idx],
> +				PAGE_SIZE, DMA_FROM_DEVICE);
>  
>  	/* gvnic can only receive into registered segments. If the buffer
>  	 * can't be recycled, our only choice is to copy the data out of
> diff --git a/drivers/net/ethernet/google/gve/gve_tx.c b/drivers/net/ethernet/google/gve/gve_tx.c
> index 778b87b5a06c..d8342b7b9764 100644
> --- a/drivers/net/ethernet/google/gve/gve_tx.c
> +++ b/drivers/net/ethernet/google/gve/gve_tx.c
> @@ -390,7 +390,23 @@ static void gve_tx_fill_seg_desc(union gve_tx_desc *seg_desc,
>  	seg_desc->seg.seg_addr = cpu_to_be64(addr);
>  }
>  
> -static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
> +static inline void gve_dma_sync_for_device(struct gve_priv *priv,

It seems that only priv->pdev->dev is used in this function.  Perhaps it
would be better to pass it to this function rather than all of priv.

> +					   dma_addr_t *page_buses,
> +					   u64 iov_offset, u64 iov_len)
> +{
> +	u64 addr;
> +	dma_addr_t dma;
> +
> +	for (addr = iov_offset; addr < iov_offset + iov_len;
> +	     addr += PAGE_SIZE) {
> +		dma = page_buses[addr / PAGE_SIZE];
> +		dma_sync_single_for_device(&priv->pdev->dev, dma, PAGE_SIZE,
> +					   DMA_TO_DEVICE);
> +	}
> +}
> +
> +static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb,
> +			  struct gve_priv *priv)
>  {
>  	int pad_bytes, hlen, hdr_nfrags, payload_nfrags, l4_hdr_offset;
>  	union gve_tx_desc *pkt_desc, *seg_desc;
> @@ -432,6 +448,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
>  	skb_copy_bits(skb, 0,
>  		      tx->tx_fifo.base + info->iov[hdr_nfrags - 1].iov_offset,
>  		      hlen);
> +	gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
> +				info->iov[hdr_nfrags - 1].iov_offset,
> +				info->iov[hdr_nfrags - 1].iov_len);
>  	copy_offset = hlen;
>  
>  	for (i = payload_iov; i < payload_nfrags + payload_iov; i++) {
> @@ -445,6 +464,9 @@ static int gve_tx_add_skb(struct gve_tx_ring *tx, struct sk_buff *skb)
>  		skb_copy_bits(skb, copy_offset,
>  			      tx->tx_fifo.base + info->iov[i].iov_offset,
>  			      info->iov[i].iov_len);
> +		gve_dma_sync_for_device(priv, tx->tx_fifo.qpl->page_buses,
> +					info->iov[i].iov_offset,
> +					info->iov[i].iov_len);
>  		copy_offset += info->iov[i].iov_len;
>  	}
>  
> @@ -473,7 +495,7 @@ netdev_tx_t gve_tx(struct sk_buff *skb, struct net_device *dev)
>  		gve_tx_put_doorbell(priv, tx->q_resources, tx->req);
>  		return NETDEV_TX_BUSY;
>  	}
> -	nsegs = gve_tx_add_skb(tx, skb);
> +	nsegs = gve_tx_add_skb(tx, skb, priv);
>  
>  	netdev_tx_sent_queue(tx->netdev_txq, skb->len);
>  	skb_tx_timestamp(skb);
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 
