Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36702C463D
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 05:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729816AbfJBDmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 23:42:01 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43169 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729782AbfJBDmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 23:42:01 -0400
Received: by mail-wr1-f65.google.com with SMTP id q17so17809167wrx.10
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 20:41:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ZjrlrCnkOabqBZzeTYx4Hi+gkhDlQaviJ5sMpxHTifc=;
        b=jnCdG+GbkoBiLOrHSoArh3ZOwv1R3CG2P+itpPpeUz/fIh8SZ58Sl7gQKomBsvYsqB
         QtvVSnS2ZvLWTszHCdWMwtax0jLNgPGIJRG3d2Xydqmmz0moouDezpZ83muqLwLfatZe
         0JKstqfTcY1pNK6VbRLGyFE4VE5sVvpoc3SAotA82X4NgGk7gf2K7k7cq1ChBR5lgx2i
         PQTaGjDmAMEmVat9l7FmjatiXhN0r69GsHwDggilt9V/QY+8ufmmPOVGjMJBO2TkgE54
         eI4tv/zNpHawCfSvwdFmbepnaxgWDTJvP8rZIprnyD0QCl/rR2L+vwz1sh/bc8fR/o8G
         DsAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ZjrlrCnkOabqBZzeTYx4Hi+gkhDlQaviJ5sMpxHTifc=;
        b=IhoS/pHmXl3wZti45gEJ4iNEE1+byqy3IiLe8HC/QwrSe3GgnOPKPE3i+1Yl1Y9at1
         7r13x+wuG6jK2vxWUmIXHMQ++RFsqlpVJTACjYRu64h+Rg9Y8Tak0+iO7HL72kt7NyfA
         01K2s+NvW3/fZ1C20Ss4vxZ1FNmjy3YAheGZ/DNSv0Qgkhg8Qx1WWHxsJ2Bk44E0xo5F
         lw9cea9G/mh/0xzTqRKyG3AaYUWCKZjz3Ovy9Wx2BsdzVmlVNMOxKAHZmuNp/zjy3TnY
         LPjWZYlrYDCnje6/9+vLTyjBRoB9xCYZ7cTb5F2UJTMSCAzgWvNzOq33QNpW7yNtPT9o
         B53w==
X-Gm-Message-State: APjAAAUbW9JWozVu9IobNVEjMrmLDdioOJZP5288HEcmcKCP0v9ORqqM
        gOKtKqbaTkk5Kww20CzxkDVUBw==
X-Google-Smtp-Source: APXvYqyEn81EqfLl4NOTReQgKQnTqAnrO99CxINEIuh+8rm/rxZHlgx/rP6hhhy6SfHSpSn/oneWzw==
X-Received: by 2002:adf:fa05:: with SMTP id m5mr688521wrr.70.1569987718272;
        Tue, 01 Oct 2019 20:41:58 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id 79sm6388626wmb.7.2019.10.01.20.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 20:41:57 -0700 (PDT)
Date:   Wed, 2 Oct 2019 06:41:54 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, mcroce@redhat.com
Subject: Re: [RFC 3/4] net: mvneta: add basic XDP support
Message-ID: <20191002034154.GA15959@apalos.home>
References: <cover.1569920973.git.lorenzo@kernel.org>
 <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5119bf5e9c33205196cf0e8b6dc7cf0d69a7e6e9.1569920973.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 11:24:43AM +0200, Lorenzo Bianconi wrote:
> Add basic XDP support to mvneta driver for devices that rely on software
> buffer management. Currently supported verdicts are:
> - XDP_DROP
> - XDP_PASS
> - XDP_REDIRECT
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
[...]
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

I think this should be part of patch [1/4], adding page pol support. 
Jesper introduced the changes to track down inflight packets [1], so you need
those changes in place when implementing page_pool

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
> -- 
> 2.21.0
> 

[1] https://lore.kernel.org/netdev/156086304827.27760.11339786046465638081.stgit@firesoul/


Regards
/Ilias
