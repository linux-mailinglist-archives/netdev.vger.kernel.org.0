Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2581C31CE
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731330AbfJAKxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:53:01 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44823 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfJAKxB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:53:01 -0400
Received: by mail-pf1-f196.google.com with SMTP id q21so7646004pfn.11
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 03:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GkEDNAOxnRVP9ORXw1YtmCVsJlYbo0Pae7NRR27Kx68=;
        b=ft0jUNKgdv1cwWl15Afb6/uHfKKSjJL8AgBHnckgvyVvdeuXd5Bownk4QLnjzmWxwh
         MA3JdkRM/hyZJBBM9Pa7IuX0+2O+JqkdC/xvNldu8+4ApgVz97lhfvGghGBHk03Rabqg
         RZ4wJvQdiDLFOcL53PDEqltfl9hSwH+c4jYvOWyMTW6CQymWadADHTbcmx3CaZ9QYfd9
         zCFZZoKzNgfLsP4gHzCSYfoFinCwuOfEzdJ4C4IF85+L5t3LdEfKuAK+6SCjTk/4NpHj
         wgxJlvtOHpEHkzlKt1dLjoyjhaSUBH48XsvTxTTmD2tUCKZkFZrNJ5daTHsh16J+nE12
         1AQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GkEDNAOxnRVP9ORXw1YtmCVsJlYbo0Pae7NRR27Kx68=;
        b=QX+WwYp54AHKwspSUQTLSLbEwXM1rZ/TupCJlcBX40DJMBG5mD8+5w4AGLIGG+qiM5
         N/iRW9Tj4rWcJCVStVLVj6Dddgsc1WSXM4Y6PHsgQNW5xWYEjWqY9l2S4ZOv6V+RbiX0
         QDD9ukaZYQ2Vu/rtls1spCJxGDrt2viOIb91hLcb4Yc1tnCW/AOVSSyya2vIo3j/z73J
         PUfMcdrOCUklZp46h0COHezHELItckAe3LvxGpgTef3RoqbE+NONeUQenF00PZCgvCP1
         8dPSDiOQZfYGntCVJxSXyMn0qfe0hFsl5c9HGZ8Zpfp+sUdpOnx474FluyexLKoA5AzW
         1Iyw==
X-Gm-Message-State: APjAAAXBNbSkV+4DYORyju+63+NYVxN551ZqA/yRIxtYXQ7vvDuDl9VY
        MXTynMgomkQOxBpZegZy33k=
X-Google-Smtp-Source: APXvYqwSjnlLTNBJ+j/jiup6xboExjltunO/+RRNlDNyQsQy7a2C+lxCuQSPBdE1A/KzY1ahQLbtHw==
X-Received: by 2002:a17:90a:258c:: with SMTP id k12mr4876302pje.11.1569927180486;
        Tue, 01 Oct 2019 03:53:00 -0700 (PDT)
Received: from localhost ([192.55.55.45])
        by smtp.gmail.com with ESMTPSA id h2sm26033542pfq.108.2019.10.01.03.52.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 01 Oct 2019 03:53:00 -0700 (PDT)
Date:   Tue, 1 Oct 2019 12:52:46 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com, mcroce@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
Message-ID: <20191001125246.0000230a@gmail.com>
In-Reply-To: <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
References: <cover.1569920973.git.lorenzo@kernel.org>
        <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Oct 2019 11:24:43 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Add basic XDP support to mvneta driver for devices that rely on software
> buffer management. Currently supported verdicts are:
> - XDP_DROP
> - XDP_PASS
> - XDP_REDIRECT

You're supporting XDP_ABORTED as well :P any plans for XDP_TX?

> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/marvell/mvneta.c | 145 ++++++++++++++++++++++++--
>  1 file changed, 136 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
> index e842c744e4f3..f2d12556efa8 100644
> --- a/drivers/net/ethernet/marvell/mvneta.c
> +++ b/drivers/net/ethernet/marvell/mvneta.c
> @@ -38,6 +38,7 @@
>  #include <net/ipv6.h>
>  #include <net/tso.h>
>  #include <net/page_pool.h>
> +#include <linux/bpf_trace.h>
>  
>  /* Registers */
>  #define MVNETA_RXQ_CONFIG_REG(q)                (0x1400 + ((q) << 2))
> @@ -323,8 +324,10 @@
>  	      ETH_HLEN + ETH_FCS_LEN,			     \
>  	      cache_line_size())
>  
> +#define MVNETA_SKB_HEADROOM	(max(XDP_PACKET_HEADROOM, NET_SKB_PAD) + \
> +				 NET_IP_ALIGN)
>  #define MVNETA_SKB_PAD	(SKB_DATA_ALIGN(sizeof(struct skb_shared_info) + \
> -			 NET_SKB_PAD))
> +			 MVNETA_SKB_HEADROOM))
>  #define MVNETA_SKB_SIZE(len)	(SKB_DATA_ALIGN(len) + MVNETA_SKB_PAD)
>  #define MVNETA_MAX_RX_BUF_SIZE	(PAGE_SIZE - MVNETA_SKB_PAD)
>  
> @@ -352,6 +355,11 @@ struct mvneta_statistic {
>  #define T_REG_64	64
>  #define T_SW		1
>  
> +#define MVNETA_XDP_PASS		BIT(0)
> +#define MVNETA_XDP_CONSUMED	BIT(1)
> +#define MVNETA_XDP_TX		BIT(2)
> +#define MVNETA_XDP_REDIR	BIT(3)
> +
>  static const struct mvneta_statistic mvneta_statistics[] = {
>  	{ 0x3000, T_REG_64, "good_octets_received", },
>  	{ 0x3010, T_REG_32, "good_frames_received", },
> @@ -431,6 +439,8 @@ struct mvneta_port {
>  	u32 cause_rx_tx;
>  	struct napi_struct napi;
>  
> +	struct bpf_prog *xdp_prog;
> +
>  	/* Core clock */
>  	struct clk *clk;
>  	/* AXI clock */
> @@ -611,6 +621,7 @@ struct mvneta_rx_queue {
>  
>  	/* page_pool */
>  	struct page_pool *page_pool;
> +	struct xdp_rxq_info xdp_rxq;
>  
>  	/* Virtual address of the RX buffer */
>  	void  **buf_virt_addr;
> @@ -1897,6 +1908,8 @@ static void mvneta_rxq_drop_pkts(struct mvneta_port *pp,
>  
>  		page_pool_put_page(rxq->page_pool, data, false);
>  	}
> +	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
> +		xdp_rxq_info_unreg(&rxq->xdp_rxq);
>  	page_pool_destroy(rxq->page_pool);
>  }
>  
> @@ -1925,16 +1938,52 @@ int mvneta_rx_refill_queue(struct mvneta_port *pp, struct mvneta_rx_queue *rxq)
>  	return i;
>  }
>  
> +static int
> +mvneta_run_xdp(struct mvneta_port *pp, struct bpf_prog *prog,
> +	       struct xdp_buff *xdp)
> +{
> +	u32 ret = bpf_prog_run_xdp(prog, xdp);
> +	int err;
> +
> +	switch (ret) {
> +	case XDP_PASS:
> +		return MVNETA_XDP_PASS;
> +	case XDP_REDIRECT:
> +		err = xdp_do_redirect(pp->dev, xdp, prog);
> +		if (err) {
> +			xdp_return_buff(xdp);
> +			return MVNETA_XDP_CONSUMED;
> +		}
> +		return MVNETA_XDP_REDIR;
> +	default:
> +		bpf_warn_invalid_xdp_action(ret);
> +		/* fall through */
> +	case XDP_ABORTED:
> +		trace_xdp_exception(pp->dev, prog, ret);
> +		/* fall through */
> +	case XDP_DROP:
> +		xdp_return_buff(xdp);
> +		return MVNETA_XDP_CONSUMED;
> +	}
> +}
> +
>  static int
>  mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  		     struct mvneta_rx_desc *rx_desc,
>  		     struct mvneta_rx_queue *rxq,
> +		     struct bpf_prog *xdp_prog,
>  		     struct page *page)
>  {
>  	unsigned char *data = page_address(page);
>  	int data_len = -MVNETA_MH_SIZE, len;
>  	struct net_device *dev = pp->dev;
>  	enum dma_data_direction dma_dir;
> +	struct xdp_buff xdp = {
> +		.data_hard_start = data,
> +		.data = data + MVNETA_SKB_HEADROOM,
> +		.rxq = &rxq->xdp_rxq,
> +	};
> +	xdp_set_data_meta_invalid(&xdp);
>  
>  	if (MVNETA_SKB_SIZE(rx_desc->data_size) > PAGE_SIZE) {
>  		len = MVNETA_MAX_RX_BUF_SIZE;
> @@ -1943,13 +1992,24 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  		len = rx_desc->data_size;
>  		data_len += (len - ETH_FCS_LEN);
>  	}
> +	xdp.data_end = xdp.data + data_len;
>  
>  	dma_dir = page_pool_get_dma_dir(rxq->page_pool);
>  	dma_sync_single_range_for_cpu(dev->dev.parent,
>  				      rx_desc->buf_phys_addr, 0,
>  				      len, dma_dir);
>  
> -	rxq->skb = build_skb(data, PAGE_SIZE);
> +	if (xdp_prog) {
> +		int ret;
> +
> +		ret = mvneta_run_xdp(pp, xdp_prog, &xdp);
> +		if (ret != MVNETA_XDP_PASS) {

Nit: you could have it written as:
if (mvneta_run_xdp(...)) {
	//blah
}

since MVNETA_XDP_PASS is 0. The 'ret' variable is not needed here.

> +			rx_desc->buf_phys_addr = 0;
> +			return -EAGAIN;
> +		}
> +	}
> +
> +	rxq->skb = build_skb(xdp.data_hard_start, PAGE_SIZE);
>  	if (unlikely(!rxq->skb)) {
>  		netdev_err(dev,
>  			   "Can't allocate skb on queue %d\n",
> @@ -1959,8 +2019,9 @@ mvneta_swbm_rx_frame(struct mvneta_port *pp,
>  		return -ENOMEM;
>  	}
>  
> -	skb_reserve(rxq->skb, MVNETA_MH_SIZE + NET_SKB_PAD);
> -	skb_put(rxq->skb, data_len);
> +	skb_reserve(rxq->skb,
> +		    MVNETA_MH_SIZE + xdp.data - xdp.data_hard_start);
> +	skb_put(rxq->skb, xdp.data_end - xdp.data);
>  	mvneta_rx_csum(pp, rx_desc->status, rxq->skb);
>  
>  	page_pool_release_page(rxq->page_pool, page);
> @@ -1995,7 +2056,7 @@ mvneta_swbm_add_rx_fragment(struct mvneta_port *pp,
>  		/* refill descriptor with new buffer later */
>  		skb_add_rx_frag(rxq->skb,
>  				skb_shinfo(rxq->skb)->nr_frags,
> -				page, NET_SKB_PAD, data_len,
> +				page, MVNETA_SKB_HEADROOM, data_len,
>  				PAGE_SIZE);
>  
>  		page_pool_release_page(rxq->page_pool, page);
> @@ -2011,10 +2072,14 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  {
>  	int rcvd_pkts = 0, rcvd_bytes = 0;
>  	int rx_todo, rx_proc = 0, refill;
> +	struct bpf_prog *xdp_prog;
>  
>  	/* Get number of received packets */
>  	rx_todo = mvneta_rxq_busy_desc_num_get(pp, rxq);
>  
> +	rcu_read_lock();
> +	xdp_prog = READ_ONCE(pp->xdp_prog);
> +
>  	/* Fairness NAPI loop */
>  	while (rcvd_pkts < budget && rx_proc < rx_todo) {
>  		struct mvneta_rx_desc *rx_desc = mvneta_rxq_next_desc_get(rxq);
> @@ -2029,6 +2094,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  		prefetch(data);
>  
>  		rxq->refill_num++;
> +		rcvd_pkts++;
>  		rx_proc++;
>  
>  		if (rx_desc->status & MVNETA_RXD_FIRST_DESC) {
> @@ -2042,7 +2108,8 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  				continue;
>  			}
>  
> -			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq, page);
> +			err = mvneta_swbm_rx_frame(pp, rx_desc, rxq,
> +						   xdp_prog, page);
>  			if (err < 0)
>  				continue;
>  		} else {
> @@ -2066,7 +2133,6 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  			rxq->skb = NULL;
>  			continue;
>  		}
> -		rcvd_pkts++;
>  		rcvd_bytes += rxq->skb->len;
>  
>  		/* Linux processing */
> @@ -2077,6 +2143,7 @@ static int mvneta_rx_swbm(struct napi_struct *napi,
>  		/* clean uncomplete skb pointer in queue */
>  		rxq->skb = NULL;
>  	}
> +	rcu_read_unlock();
>  
>  	if (rcvd_pkts) {
>  		struct mvneta_pcpu_stats *stats = this_cpu_ptr(pp->stats);
> @@ -2836,14 +2903,16 @@ static int mvneta_poll(struct napi_struct *napi, int budget)
>  static int mvneta_create_page_pool(struct mvneta_port *pp,
>  				   struct mvneta_rx_queue *rxq, int size)
>  {
> +	struct bpf_prog *xdp_prog = READ_ONCE(pp->xdp_prog);
>  	struct page_pool_params pp_params = {
>  		.order = 0,
>  		.flags = PP_FLAG_DMA_MAP,
>  		.pool_size = size,
>  		.nid = cpu_to_node(0),
>  		.dev = pp->dev->dev.parent,
> -		.dma_dir = DMA_FROM_DEVICE,
> +		.dma_dir = xdp_prog ? DMA_BIDIRECTIONAL : DMA_FROM_DEVICE,
>  	};
> +	int err;
>  
>  	rxq->page_pool = page_pool_create(&pp_params);
>  	if (IS_ERR(rxq->page_pool)) {
> @@ -2851,7 +2920,22 @@ static int mvneta_create_page_pool(struct mvneta_port *pp,
>  		return PTR_ERR(rxq->page_pool);
>  	}
>  
> +	err = xdp_rxq_info_reg(&rxq->xdp_rxq, pp->dev, 0);
> +	if (err < 0)
> +		goto err_free_pp;
> +
> +	err = xdp_rxq_info_reg_mem_model(&rxq->xdp_rxq, MEM_TYPE_PAGE_POOL,
> +					 rxq->page_pool);
> +	if (err)
> +		goto err_unregister_pp;

err_unregister_rxq?

> +
>  	return 0;
> +
> +err_unregister_pp:
> +	xdp_rxq_info_unreg(&rxq->xdp_rxq);
> +err_free_pp:
> +	page_pool_destroy(rxq->page_pool);
> +	return err;
>  }
>  
>  /* Handle rxq fill: allocates rxq skbs; called when initializing a port */
> @@ -3291,6 +3375,11 @@ static int mvneta_change_mtu(struct net_device *dev, int mtu)
>  		mtu = ALIGN(MVNETA_RX_PKT_SIZE(mtu), 8);
>  	}
>  
> +	if (pp->xdp_prog && mtu > MVNETA_MAX_RX_BUF_SIZE) {
> +		netdev_info(dev, "Illegal MTU value %d for XDP mode\n", mtu);
> +		return -EINVAL;
> +	}
> +
>  	dev->mtu = mtu;
>  
>  	if (!netif_running(dev)) {
> @@ -3960,6 +4049,43 @@ static int mvneta_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
>  	return phylink_mii_ioctl(pp->phylink, ifr, cmd);
>  }
>  
> +static int mvneta_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
> +			    struct netlink_ext_ack *extack)
> +{
> +	struct mvneta_port *pp = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +
> +	if (prog && dev->mtu > MVNETA_MAX_RX_BUF_SIZE) {
> +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> +		return -EOPNOTSUPP;
> +	}
> +
> +	mvneta_stop(dev);
> +
> +	old_prog = xchg(&pp->xdp_prog, prog);
> +	if (old_prog)
> +		bpf_prog_put(old_prog);
> +
> +	mvneta_open(dev);
> +
> +	return 0;
> +}
> +
> +static int mvneta_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	struct mvneta_port *pp = netdev_priv(dev);
> +
> +	switch (xdp->command) {
> +	case XDP_SETUP_PROG:
> +		return mvneta_xdp_setup(dev, xdp->prog, xdp->extack);
> +	case XDP_QUERY_PROG:
> +		xdp->prog_id = pp->xdp_prog ? pp->xdp_prog->aux->id : 0;
> +		return 0;
> +	default:

NL_SET_ERR_MSG_MOD(xdp->extack, "Unknown XDP command"); ?

> +		return -EINVAL;
> +	}
> +}
> +
>  /* Ethtool methods */
>  
>  /* Set link ksettings (phy address, speed) for ethtools */
> @@ -4356,6 +4482,7 @@ static const struct net_device_ops mvneta_netdev_ops = {
>  	.ndo_fix_features    = mvneta_fix_features,
>  	.ndo_get_stats64     = mvneta_get_stats64,
>  	.ndo_do_ioctl        = mvneta_ioctl,
> +	.ndo_bpf	     = mvneta_xdp,
>  };
>  
>  static const struct ethtool_ops mvneta_eth_tool_ops = {
> @@ -4646,7 +4773,7 @@ static int mvneta_probe(struct platform_device *pdev)
>  	SET_NETDEV_DEV(dev, &pdev->dev);
>  
>  	pp->id = global_port_id++;
> -	pp->rx_offset_correction = NET_SKB_PAD;
> +	pp->rx_offset_correction = MVNETA_SKB_HEADROOM;
>  
>  	/* Obtain access to BM resources if enabled and already initialized */
>  	bm_node = of_parse_phandle(dn, "buffer-manager", 0);

