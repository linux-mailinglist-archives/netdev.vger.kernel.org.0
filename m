Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B25D1614CF
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 15:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgBQOiI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 09:38:08 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41257 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbgBQOiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 09:38:08 -0500
Received: by mail-wr1-f67.google.com with SMTP id c9so20041349wrw.8
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 06:38:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2bOJfWV4gkThTRndYSzTQKJ4MSm0tlziBcoysPU4TPY=;
        b=mGX4ZDLlRdfjzvrF1tiqZhZGW3txxFkyOTZI+wm4fg9sCQxTThMyOsi7lqShEGc0l6
         prYJjK5XRkFGcZC7O42qisBYnNBPCj1O2rDQ+SIKy07bz7EFqXV9dvGo97jWOjupb/Wi
         XAouu+NrYtwsmyuLyb7jnnKgO4rIIUKrJ6nJXlTzgbVuPQVVESasqg19zPf6IV7FISnr
         ncV5LjrlruS3DGs2/AQTRAyYcN+8zBGs0rr4KPHzR3PDTLliawurI8DPirES8GMvxDt5
         JPkKIGvoB3hnBr7Dc6bSptoYarDaBU2MXGplMnk2bKokK4fpTpkTg/UnFgL5lTkhVccy
         9Trw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2bOJfWV4gkThTRndYSzTQKJ4MSm0tlziBcoysPU4TPY=;
        b=MqWnBQjQUCWOKxTYCNLsd+BDnpR9aygHIAbVizW7uC/l/LS8gFA51oDe73WDUObWH+
         CRL2BzRKO5jZIoYNoPuM0dEV4qbsZkxqyz/oaGqWAzXsoSqiGdEh4Dx3dC08bMErGmrA
         x4vi7cHvewBh/MUP7Zj1vEl325zVsAT/yvxDKhcY9JIxkrICWu6dCXQWj8GZOy1TdhSr
         fN+M1Gl732/UEFQF+V2Em2IqkNbBn9t7tjHx5lSoavlds+OBSyhEorCqt5rUKgUeQomw
         Nzop5pqIJ/lLGJcxoGZiwDsUEv8yZQaw9kluQYdO9tWTm15XAMzNowXgm4CUuN1+FbGU
         CBKQ==
X-Gm-Message-State: APjAAAV9Kr8SvoruYIfUfr7aRyQbCKPk0tZFPtg5VrwNNYo8Ptn8LlrN
        MudyiH01SMdy7eXBtQyCG4cdIdmaHcA=
X-Google-Smtp-Source: APXvYqxxT/1489jBG+aP39h4KH8IH4o4mhDuInuDhQojO567hUIaRd9gqbQt7MKLfGHCH97Nr98mwg==
X-Received: by 2002:adf:fd0e:: with SMTP id e14mr22244399wrr.127.1581950284367;
        Mon, 17 Feb 2020 06:38:04 -0800 (PST)
Received: from Iliass-MacBook-Pro.local (ppp-2-87-54-32.home.otenet.gr. [2.87.54.32])
        by smtp.gmail.com with ESMTPSA id n1sm1324558wrw.52.2020.02.17.06.38.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Feb 2020 06:38:03 -0800 (PST)
Date:   Mon, 17 Feb 2020 16:38:00 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] xen-netfront: add basic XDP support
Message-ID: <20200217143800.GA11285@Iliass-MacBook-Pro.local>
References: <1581944657-13384-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1581944657-13384-1-git-send-email-kda@linux-powerpc.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Denis, 

On Mon, Feb 17, 2020 at 04:04:17PM +0300, Denis Kirjanov wrote:
> the patch adds a basic xdp logic to the netfront driver
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>
> ---
>  drivers/net/xen-netfront.c | 125 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 125 insertions(+)
> 
> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
> index 482c6c8..06dd088 100644
> --- a/drivers/net/xen-netfront.c
> +++ b/drivers/net/xen-netfront.c
> @@ -44,6 +44,8 @@
>  #include <linux/mm.h>
>  #include <linux/slab.h>
>  #include <net/ip.h>
> +#include <linux/bpf.h>
> +#include <linux/bpf_trace.h>
>  
>  #include <xen/xen.h>
>  #include <xen/xenbus.h>
> @@ -102,6 +104,8 @@ struct netfront_queue {
>  	char name[QUEUE_NAME_SIZE]; /* DEVNAME-qN */
>  	struct netfront_info *info;
>  
> +	struct bpf_prog __rcu *xdp_prog;
> +
>  	struct napi_struct napi;
>  
>  	/* Split event channels support, tx_* == rx_* when using
> @@ -778,6 +782,53 @@ static int xennet_get_extras(struct netfront_queue *queue,
>  	return err;
>  }
>  
> +u32 xennet_run_xdp(struct netfront_queue *queue, struct page *pdata,
> +		   struct xen_netif_rx_response *rx, struct bpf_prog *prog,
> +		   struct xdp_buff *xdp)
> +{
> +	void *data = page_address(pdata);
> +	u32 len = rx->status;
> +	struct page *page = NULL;
> +	u32 act = XDP_PASS;
> +
> +	page = alloc_page(GFP_ATOMIC);

This is not how XDP is supposed to work. You should minimize allocations/free during XDP 
processing, since it's one of the reasons XDP is so fast. 
The skb->data allocated memory should be allocated either via page_pool API or with any 
helper that allocates pages before entering this function.

> +	if (!page) {
> +		act = XDP_DROP;
> +		goto out;
> +	}
> +
> +	xdp->data_hard_start = page_address(page);
> +	xdp->data = xdp->data_hard_start + 256;

Please don't use magic numbers like '256', all those are well defined in the 
xdp headers.

> +	xdp_set_data_meta_invalid(xdp);
> +	xdp->data_end = xdp->data + len;
> +	xdp->handle = 0;
> +
> +	memcpy(xdp->data, data, len);

Again this should be allocated before, instead of copying it.

> +
> +	act = bpf_prog_run_xdp(prog, xdp);
> +	switch (act) {
> +	case XDP_PASS:
> +	case XDP_TX:
> +	case XDP_DROP:
> +		break;
> +

missing XDP_REDIRECT and .ndo_xdp_xmit, 

> +	case XDP_ABORTED:
> +		trace_xdp_exception(queue->info->netdev, prog, act);
> +		break;
> +
> +	default:
> +		bpf_warn_invalid_xdp_action(act);
> +	}
> +
> +out:
> +	if (page && act != XDP_PASS && act != XDP_TX) {
> +		__free_page(page);
> +		xdp->data_hard_start = NULL;
> +	}
> +
> +	return act;
> +}
> +
>  static int xennet_get_responses(struct netfront_queue *queue,
>  				struct netfront_rx_info *rinfo, RING_IDX rp,
>  				struct sk_buff_head *list)
> @@ -792,6 +843,9 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  	int slots = 1;
>  	int err = 0;
>  	unsigned long ret;
> +	struct bpf_prog *xdp_prog;
> +	struct xdp_buff xdp;
> +	u32 verdict;
>  
>  	if (rx->flags & XEN_NETRXF_extra_info) {
>  		err = xennet_get_extras(queue, extras, rp);
> @@ -827,6 +881,21 @@ static int xennet_get_responses(struct netfront_queue *queue,
>  
>  		gnttab_release_grant_reference(&queue->gref_rx_head, ref);
>  
> +		rcu_read_lock();
> +		xdp_prog = rcu_dereference(queue->xdp_prog);
> +		if (xdp_prog) {
> +			WARN_ON_ONCE(skb_shinfo(skb)->nr_frags != 1);
> +			verdict = xennet_run_xdp(queue,
> +				       skb_frag_page(&skb_shinfo(skb)->frags[0]),

This should run on a single page and not a page fragment. You can check the netsec and mvneta 
drivers. They are relatively simple and can give you and idea on how to allocate/recycle pages
properly for XDP.

> +				       rx, xdp_prog, &xdp);
> +
> +			if (verdict != XDP_PASS && verdict != XDP_TX) {
> +				err = -EINVAL;
> +				goto next;
> +			}
> +
> +		}
> +		rcu_read_unlock();
>  		__skb_queue_tail(list, skb);
>  
>  next:
> @@ -1261,6 +1330,61 @@ static void xennet_poll_controller(struct net_device *dev)
>  }
>  #endif
>  
> +static int xennet_xdp_set(struct net_device *dev, struct bpf_prog *prog,
> +			struct netlink_ext_ack *extack)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	struct bpf_prog *old_prog;
> +	unsigned int i;
> +
> +	old_prog = rtnl_dereference(np->queues[0].xdp_prog);
> +	if (!old_prog && !prog)
> +		return 0;
> +
> +	if (prog)
> +		bpf_prog_add(prog, dev->real_num_tx_queues);
> +
> +	for (i = 0; i < dev->real_num_tx_queues; ++i)
> +		rcu_assign_pointer(np->queues[i].xdp_prog, prog);
> +
> +	if (old_prog)
> +		for (i = 0; i < dev->real_num_tx_queues; ++i)
> +			bpf_prog_put(old_prog);
> +
> +	return 0;
> +}
> +
> +static u32 xennet_xdp_query(struct net_device *dev)
> +{
> +	struct netfront_info *np = netdev_priv(dev);
> +	unsigned int num_queues = dev->real_num_tx_queues;
> +	unsigned int i;
> +	struct netfront_queue *queue;
> +	const struct bpf_prog *xdp_prog;
> +
> +	for (i = 0; i < num_queues; ++i) {
> +		queue = &np->queues[i];
> +		xdp_prog = rtnl_dereference(queue->xdp_prog);
> +		if (xdp_prog)
> +			return xdp_prog->aux->id;
> +	}
> +
> +	return 0;
> +}
> +
> +static int xennet_xdp(struct net_device *dev, struct netdev_bpf *xdp)
> +{
> +	switch (xdp->command) {
> +	case XDP_SETUP_PROG:
> +		return xennet_xdp_set(dev, xdp->prog, xdp->extack);
> +	case XDP_QUERY_PROG:
> +		xdp->prog_id = xennet_xdp_query(dev);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
>  static const struct net_device_ops xennet_netdev_ops = {
>  	.ndo_open            = xennet_open,
>  	.ndo_stop            = xennet_close,
> @@ -1272,6 +1396,7 @@ static void xennet_poll_controller(struct net_device *dev)
>  	.ndo_fix_features    = xennet_fix_features,
>  	.ndo_set_features    = xennet_set_features,
>  	.ndo_select_queue    = xennet_select_queue,
> +	.ndo_bpf            = xennet_xdp,
>  #ifdef CONFIG_NET_POLL_CONTROLLER
>  	.ndo_poll_controller = xennet_poll_controller,
>  #endif
> -- 
> 1.8.3.1
> 

Regards
/Ilias
