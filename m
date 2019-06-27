Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C92A58455
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 16:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfF0OSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 10:18:32 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39602 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfF0OSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 10:18:31 -0400
Received: by mail-pl1-f194.google.com with SMTP id b7so1388062pls.6
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 07:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Sw7zcTVH/uL8w4Y1RmhYHHbDHWtbrkw+kfd4sQFTYg=;
        b=eqEZKPziswq2QWFFI/+Uac0jmT9dKQUU0ZwxlhMY4G2izK2hFEHTOhsKnSp7lyxsqq
         NVng1NDxSWYAWKgoSGAYJ/ntOuJMTLkodahG0uXw4+onKsMBL+mvjYtDSgRecvGGliMH
         ndztI7rCYPx8jCaxfXud3xx8/W3401W/HJZJ5qqvqrRoOR+KHIUKswg90qXQwOcGOehP
         kA8882BlguNbLtM4VvvixiNEzxuHObsgtilvA7MEWdfFQWTdTuRvN0Ql4+7SO0LsCeQQ
         CJjHWgJHwUwK4gr/23kUeY0/etVKrw1t2ppoyJQocM4AEeQptq/gz2EhQHhxMDkA7mEs
         wTNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Sw7zcTVH/uL8w4Y1RmhYHHbDHWtbrkw+kfd4sQFTYg=;
        b=Op71c/CTFp/hlhQ+dMMN3dSQH7zaiMNTt8MrQK8FPG0yCOiBkpLQCXOLmC/VJ+fdeg
         ucjR7nLBGO6j6H+2IixG7XKJx0XSK1cgfw+gCbxstC5j5LrpwwlvfOwsnrSlRRlUQhLG
         iW43+I3/1YqNB9PCYxCF2Q/VAaPEFmZkdinGwCwQnG5UcO55mHLJrtcSGlLEue5d8Ily
         aXQGRTtDbgSR9GFMIrhmwm1fO4hOUHzFik203MptKevDqYtWIDgBZv5d3jYlnp/iOofc
         9oVfKNTczoPv8+MeNUE99/wTqmlVpT0qaGTwKGz2pCcOVsVr+EeXX6sxv4ALqsV7Yazr
         MFcw==
X-Gm-Message-State: APjAAAW7ST6MTmbhNF1lHUkcrTH2ZnhQqhY9Q7T+jnqxcsSsln7Cpz0l
        jtOXgj71jyfzqQ/upmM0tL0=
X-Google-Smtp-Source: APXvYqz9YSHv65eE9Q+80EU3nZXp/pA2QieulWEPEMUD76gU+v07fTENtFE/ZJGY+lRO96NJwxfIqQ==
X-Received: by 2002:a17:902:44f:: with SMTP id 73mr5059434ple.192.1561645110820;
        Thu, 27 Jun 2019 07:18:30 -0700 (PDT)
Received: from localhost ([192.55.54.43])
        by smtp.gmail.com with ESMTPSA id t26sm2161202pgu.43.2019.06.27.07.18.27
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 27 Jun 2019 07:18:30 -0700 (PDT)
Date:   Thu, 27 Jun 2019 16:18:16 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net
Subject: Re: [RFC, PATCH 2/2, net-next] net: netsec: add XDP support
Message-ID: <20190627161816.0000645a@gmail.com>
In-Reply-To: <1561475179-7686-3-git-send-email-ilias.apalodimas@linaro.org>
References: <1561475179-7686-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561475179-7686-3-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 18:06:19 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

Hi Ilias,

> +/* The current driver only supports 1 Txq, this should run under spin_lock() */
> +static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
> +				struct xdp_frame *xdpf, bool is_ndo)
> +
> +{
> +	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
> +	struct page *page = virt_to_page(xdpf->data);
> +	struct netsec_tx_pkt_ctrl tx_ctrl = {};
> +	struct netsec_desc tx_desc;
> +	dma_addr_t dma_handle;
> +	u16 filled;
> +
> +	if (tx_ring->head >= tx_ring->tail)
> +		filled = tx_ring->head - tx_ring->tail;
> +	else
> +		filled = tx_ring->head + DESC_NUM - tx_ring->tail;
> +
> +	if (DESC_NUM - filled <= 1)
> +		return NETSEC_XDP_CONSUMED;
> +
> +	if (is_ndo) {
> +		/* this is for ndo_xdp_xmit, the buffer needs mapping before
> +		 * sending
> +		 */
> +		dma_handle = dma_map_single(priv->dev, xdpf->data, xdpf->len,
> +					    DMA_TO_DEVICE);
> +		if (dma_mapping_error(priv->dev, dma_handle))
> +			return NETSEC_XDP_CONSUMED;
> +		tx_desc.buf_type = TYPE_NETSEC_XDP_NDO;
> +	} else {
> +		/* This is the device Rx buffer from page_pool. No need to remap
> +		 * just sync and send it
> +		 */
> +		dma_handle = page_pool_get_dma_addr(page) +
> +			NETSEC_RXBUF_HEADROOM;
> +		dma_sync_single_for_device(priv->dev, dma_handle, xdpf->len,
> +					   DMA_BIDIRECTIONAL);
> +		tx_desc.buf_type = TYPE_NETSEC_XDP_TX;
> +	}
> +	tx_ctrl.cksum_offload_flag = false;
> +	tx_ctrl.tcp_seg_offload_flag = false;
> +	tx_ctrl.tcp_seg_len = 0;

Aren't these three lines redundant? tx_ctrl is zero initialized.

> +
> +	tx_desc.dma_addr = dma_handle;
> +	tx_desc.addr = xdpf->data;
> +	tx_desc.len = xdpf->len;
> +
> +	netsec_set_tx_de(priv, tx_ring, &tx_ctrl, &tx_desc, xdpf);
> +
> +	return NETSEC_XDP_TX;
> +}
> +
> +static u32 netsec_xdp_xmit_back(struct netsec_priv *priv, struct xdp_buff *xdp)
> +{
> +	struct netsec_desc_ring *tx_ring = &priv->desc_ring[NETSEC_RING_TX];
> +	struct xdp_frame *xdpf = convert_to_xdp_frame(xdp);
> +	u32 ret;
> +
> +	if (unlikely(!xdpf))
> +		return NETSEC_XDP_CONSUMED;
> +
> +	spin_lock(&tx_ring->lock);
> +	ret = netsec_xdp_queue_one(priv, xdpf, false);
> +	spin_unlock(&tx_ring->lock);
> +
> +	return ret;
> +}
> +
> +static u32 netsec_run_xdp(struct netsec_priv *priv, struct bpf_prog *prog,
> +			  struct xdp_buff *xdp)
> +{
> +	u32 ret = NETSEC_XDP_PASS;
> +	int err;
> +	u32 act;
> +
> +	rcu_read_lock();
> +	act = bpf_prog_run_xdp(prog, xdp);
> +
> +	switch (act) {
> +	case XDP_PASS:
> +		ret = NETSEC_XDP_PASS;
> +		break;
> +	case XDP_TX:
> +		ret = netsec_xdp_xmit_back(priv, xdp);
> +		if (ret != NETSEC_XDP_TX)
> +			xdp_return_buff(xdp);
> +		break;
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(priv->ndev, xdp, prog);
> +		if (!err) {
> +			ret = NETSEC_XDP_REDIR;
> +		} else {
> +			ret = NETSEC_XDP_CONSUMED;
> +			xdp_return_buff(xdp);
> +		}
> +		break;
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +		/* fall through */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(priv->ndev, prog, act);
> +		/* fall through -- handle aborts by dropping packet */
> +	case XDP_DROP:
> +		ret = NETSEC_XDP_CONSUMED;
> +		xdp_return_buff(xdp);
> +		break;
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return ret;
> +}
> +
>  static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  {
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_RX];
> +	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);

Reading BPF prog should be RCU protected. There might be a case where RCU
callback that destroys BPF prog is executed during the bottom half handling and
you have the PREEMPT_RCU=y in your kernel config. I've just rephrased Brenden's
words here, so for further info, see:

https://lore.kernel.org/netdev/20160904042958.8594-1-bblanco@plumgrid.com/

So either expand the RCU section or read prog pointer per each frame, under the
lock, as it seems that currently we have these two schemes in drivers that
support XDP.

>  	struct net_device *ndev = priv->ndev;
>  	struct netsec_rx_pkt_info rx_info;
> -	struct sk_buff *skb;
> +	struct sk_buff *skb = NULL;
> +	u16 xdp_xmit = 0;
> +	u32 xdp_act = 0;
>  	int done = 0;
>  
>  	while (done < budget) {
> @@ -727,8 +903,10 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  		struct netsec_de *de = dring->vaddr + (DESC_SZ * idx);
>  		struct netsec_desc *desc = &dring->desc[idx];
>  		struct page *page = virt_to_page(desc->addr);
> +		u32 xdp_result = XDP_PASS;
>  		u16 pkt_len, desc_len;
>  		dma_addr_t dma_handle;
> +		struct xdp_buff xdp;
>  		void *buf_addr;
>  
>  		if (de->attr & (1U << NETSEC_RX_PKT_OWN_FIELD)) {
> @@ -773,7 +951,23 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  					DMA_FROM_DEVICE);
>  		prefetch(desc->addr);
>  
> +		xdp.data_hard_start = desc->addr;
> +		xdp.data = desc->addr + NETSEC_RXBUF_HEADROOM;
> +		xdp_set_data_meta_invalid(&xdp);
> +		xdp.data_end = xdp.data + pkt_len;
> +		xdp.rxq = &dring->xdp_rxq;
> +
> +		if (xdp_prog) {
> +			xdp_result = netsec_run_xdp(priv, xdp_prog, &xdp);
> +			if (xdp_result != NETSEC_XDP_PASS) {
> +				xdp_act |= xdp_result;
> +				if (xdp_result == NETSEC_XDP_TX)
> +					xdp_xmit++;
> +				goto next;
> +			}
> +		}
>  		skb = build_skb(desc->addr, desc->len + NETSEC_RX_BUF_NON_DATA);
> +
>  		if (unlikely(!skb)) {
>  			/* If skb fails recycle_direct will either unmap and
>  			 * free the page or refill the cache depending on the
> @@ -787,27 +981,30 @@ static int netsec_process_rx(struct netsec_priv *priv, int budget)
>  		}
>  		page_pool_release_page(dring->page_pool, page);
>  
> -		/* Update the descriptor with the new buffer we allocated */
> -		desc->len = desc_len;
> -		desc->dma_addr = dma_handle;
> -		desc->addr = buf_addr;
> -
> -		skb_reserve(skb, NETSEC_SKB_PAD);
> -		skb_put(skb, pkt_len);
> +		skb_reserve(skb, xdp.data - xdp.data_hard_start);
> +		skb_put(skb, xdp.data_end - xdp.data);
>  		skb->protocol = eth_type_trans(skb, priv->ndev);
>  
>  		if (priv->rx_cksum_offload_flag &&
>  		    rx_info.rx_cksum_result == NETSEC_RX_CKSUM_OK)
>  			skb->ip_summed = CHECKSUM_UNNECESSARY;
>  
> -		if (napi_gro_receive(&priv->napi, skb) != GRO_DROP) {
> +next:
> +		if ((skb && napi_gro_receive(&priv->napi, skb) != GRO_DROP) ||
> +		    xdp_result & NETSEC_XDP_RX_OK) {
>  			ndev->stats.rx_packets++;
> -			ndev->stats.rx_bytes += pkt_len;
> +			ndev->stats.rx_bytes += xdp.data_end - xdp.data;
>  		}
>  
> +		/* Update the descriptor with fresh buffers */
> +		desc->len = desc_len;
> +		desc->dma_addr = dma_handle;
> +		desc->addr = buf_addr;
> +
>  		netsec_rx_fill(priv, idx, 1);
>  		dring->tail = (dring->tail + 1) % DESC_NUM;
>  	}
> +	netsec_finalize_xdp_rx(priv, xdp_act, xdp_xmit);
>  
>  	return done;
>  }
