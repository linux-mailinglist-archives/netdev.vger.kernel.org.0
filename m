Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4BFC2EFA
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 10:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733067AbfJAIhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 04:37:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39102 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727957AbfJAIhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 04:37:13 -0400
Received: by mail-wm1-f65.google.com with SMTP id v17so2203883wml.4
        for <netdev@vger.kernel.org>; Tue, 01 Oct 2019 01:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TEHfuX0cI1Wr5KwrKRmgtfXJ1asDiD2DnvGUlZqIp/0=;
        b=Xa33FQ01NdUZLJ5/MJP19J06b4/uaOZUnzgzLPU/8GK+xa9i+PqF0WzbvbQD0BuMmC
         7KjsJQ3L0mIosnSqa5jyJNviM7hpVO8m05lysRG4G70oURKQO7ak4oxpKGnqkr00PYxU
         Lf5WcjvJhR0R0fL6uMTgtOPfE/Z+WgNuMmNI8lZWHGfrC5mSypqnMLHuHPs3tkXD6ZUX
         B34TV6jT/ludNw34J0JGXbbqoQUSOVo75VyMUSuLwEwTPQLuP8rWcCKqzhR9GOVmGLRB
         yeJBP+2cPFI7G6sT8QcDi67YgnCxNIeaSIhV5kjrKAHFc3XhotQyq+7wkHjjFh3nxWFX
         Kqbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TEHfuX0cI1Wr5KwrKRmgtfXJ1asDiD2DnvGUlZqIp/0=;
        b=n7bh/wR3+IBz780/WfDo7IWft5iEr47DXIdrMSK3YwQhr9LvKaOHK4nlN+X33P43l1
         7QPkwGpFOChE5XwbIUVPpMq4zeagH/Ywx/hr2Q5QhehnHAdq6AjBr86pHP5xYGqvHtqo
         PlNnyntBDdoKk+qv0VtzjJ9KHkBGl0W9nNt4WTPTEn6M1drlVrl/F7691qH72L/3b0ay
         HC/UWNZ4SJiWo03bY80XlYpv2K2s3EJ7nhpQLsGg2Gkznel1B2DzuSlFU8I0kl6xxqYY
         XjaSy2VxDc5BfTfKM+vzCP9RN8ZnBsnNkoz6YhsAw39xrdpxVpE8emG2k4sT6KWa9V3d
         t8yQ==
X-Gm-Message-State: APjAAAUrJ+pQOOXQ27WcnJSEW6DCVW8VDrkM5h0dGRosfAwelMXIjsE9
        qTUKOqoB1Z/nJi7ucyNNhX+DmQ==
X-Google-Smtp-Source: APXvYqyNxI8VxR//ok7T7+y9s/aBzCvmJluQwcD67TVGmSbvZCZZLkGBhRPPKUtsC4PaByDdhi/YFw==
X-Received: by 2002:a05:600c:2290:: with SMTP id 16mr2504994wmf.161.1569919030405;
        Tue, 01 Oct 2019 01:37:10 -0700 (PDT)
Received: from apalos.home (ppp-94-65-93-45.home.otenet.gr. [94.65.93.45])
        by smtp.gmail.com with ESMTPSA id u4sm2845603wmg.41.2019.10.01.01.37.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 01:37:09 -0700 (PDT)
Date:   Tue, 1 Oct 2019 11:37:07 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net] net: socionext: netsec: always grab descriptor lock
Message-ID: <20191001083707.GA3850@apalos.home>
References: <24b0644bf4e2c1de36e774a8cd95bd39697f9b12.1569918386.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24b0644bf4e2c1de36e774a8cd95bd39697f9b12.1569918386.git.lorenzo@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 01, 2019 at 10:33:51AM +0200, Lorenzo Bianconi wrote:
> Always acquire tx descriptor spinlock even if a xdp program is not loaded
> on the netsec device since ndo_xdp_xmit can run concurrently with
> netsec_netdev_start_xmit and netsec_clean_tx_dring. This can happen
> loading a xdp program on a different device (e.g virtio-net) and
> xdp_do_redirect_map/xdp_do_redirect_slow can redirect to netsec even if
> we do not have a xdp program on it.
> 
> Fixes: ba2b232108d3 ("net: netsec: add XDP support")
> Tested-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  drivers/net/ethernet/socionext/netsec.c | 30 ++++++-------------------
>  1 file changed, 7 insertions(+), 23 deletions(-)
> 
> diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
> index 55db7fbd43cc..f9e6744d8fd6 100644
> --- a/drivers/net/ethernet/socionext/netsec.c
> +++ b/drivers/net/ethernet/socionext/netsec.c
> @@ -282,7 +282,6 @@ struct netsec_desc_ring {
>  	void *vaddr;
>  	u16 head, tail;
>  	u16 xdp_xmit; /* netsec_xdp_xmit packets */
> -	bool is_xdp;
>  	struct page_pool *page_pool;
>  	struct xdp_rxq_info xdp_rxq;
>  	spinlock_t lock; /* XDP tx queue locking */
> @@ -634,8 +633,7 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  	unsigned int bytes;
>  	int cnt = 0;
>  
> -	if (dring->is_xdp)
> -		spin_lock(&dring->lock);
> +	spin_lock(&dring->lock);
>  
>  	bytes = 0;
>  	entry = dring->vaddr + DESC_SZ * tail;
> @@ -682,8 +680,8 @@ static bool netsec_clean_tx_dring(struct netsec_priv *priv)
>  		entry = dring->vaddr + DESC_SZ * tail;
>  		cnt++;
>  	}
> -	if (dring->is_xdp)
> -		spin_unlock(&dring->lock);
> +
> +	spin_unlock(&dring->lock);
>  
>  	if (!cnt)
>  		return false;
> @@ -799,9 +797,6 @@ static void netsec_set_tx_de(struct netsec_priv *priv,
>  	de->data_buf_addr_lw = lower_32_bits(desc->dma_addr);
>  	de->buf_len_info = (tx_ctrl->tcp_seg_len << 16) | desc->len;
>  	de->attr = attr;
> -	/* under spin_lock if using XDP */
> -	if (!dring->is_xdp)
> -		dma_wmb();
>  
>  	dring->desc[idx] = *desc;
>  	if (desc->buf_type == TYPE_NETSEC_SKB)
> @@ -1123,12 +1118,10 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
>  	u16 tso_seg_len = 0;
>  	int filled;
>  
> -	if (dring->is_xdp)
> -		spin_lock_bh(&dring->lock);
> +	spin_lock_bh(&dring->lock);
>  	filled = netsec_desc_used(dring);
>  	if (netsec_check_stop_tx(priv, filled)) {
> -		if (dring->is_xdp)
> -			spin_unlock_bh(&dring->lock);
> +		spin_unlock_bh(&dring->lock);
>  		net_warn_ratelimited("%s %s Tx queue full\n",
>  				     dev_name(priv->dev), ndev->name);
>  		return NETDEV_TX_BUSY;
> @@ -1161,8 +1154,7 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
>  	tx_desc.dma_addr = dma_map_single(priv->dev, skb->data,
>  					  skb_headlen(skb), DMA_TO_DEVICE);
>  	if (dma_mapping_error(priv->dev, tx_desc.dma_addr)) {
> -		if (dring->is_xdp)
> -			spin_unlock_bh(&dring->lock);
> +		spin_unlock_bh(&dring->lock);
>  		netif_err(priv, drv, priv->ndev,
>  			  "%s: DMA mapping failed\n", __func__);
>  		ndev->stats.tx_dropped++;
> @@ -1177,8 +1169,7 @@ static netdev_tx_t netsec_netdev_start_xmit(struct sk_buff *skb,
>  	netdev_sent_queue(priv->ndev, skb->len);
>  
>  	netsec_set_tx_de(priv, dring, &tx_ctrl, &tx_desc, skb);
> -	if (dring->is_xdp)
> -		spin_unlock_bh(&dring->lock);
> +	spin_unlock_bh(&dring->lock);
>  	netsec_write(priv, NETSEC_REG_NRM_TX_PKTCNT, 1); /* submit another tx */
>  
>  	return NETDEV_TX_OK;
> @@ -1262,7 +1253,6 @@ static int netsec_alloc_dring(struct netsec_priv *priv, enum ring_id id)
>  static void netsec_setup_tx_dring(struct netsec_priv *priv)
>  {
>  	struct netsec_desc_ring *dring = &priv->desc_ring[NETSEC_RING_TX];
> -	struct bpf_prog *xdp_prog = READ_ONCE(priv->xdp_prog);
>  	int i;
>  
>  	for (i = 0; i < DESC_NUM; i++) {
> @@ -1275,12 +1265,6 @@ static void netsec_setup_tx_dring(struct netsec_priv *priv)
>  		 */
>  		de->attr = 1U << NETSEC_TX_SHIFT_OWN_FIELD;
>  	}
> -
> -	if (xdp_prog)
> -		dring->is_xdp = true;
> -	else
> -		dring->is_xdp = false;
> -
>  }
>  
>  static int netsec_setup_rx_dring(struct netsec_priv *priv)
> -- 
> 2.21.0
> 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
