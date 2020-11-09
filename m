Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B09742AC948
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 00:24:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731484AbgKIXYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 18:24:09 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27741 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729740AbgKIXYJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 18:24:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604964247;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=df6GgZofTI8funW/rqAogEbQfm18H83dbgf811td3hg=;
        b=eJtIHDpewL+eg/BBSziTPaoDY3IKkwh76k5tYCdMwhP/A+IV+YZm2b3UvrBC1gdQHclItE
        bBYFMzS7OWsnaB49vwYpSgo4a4jtKxsLJI0AOC4V1j1Wf8m4zt/bu7jb7goWHSJEa/eoqk
        2OhueFJZEV2DEVWgaihjk7EgZGlPqQk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-171-LbmHNetSMFyj7HVSfivqcQ-1; Mon, 09 Nov 2020 18:24:06 -0500
X-MC-Unique: LbmHNetSMFyj7HVSfivqcQ-1
Received: by mail-wm1-f69.google.com with SMTP id h2so417383wmm.0
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 15:24:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=df6GgZofTI8funW/rqAogEbQfm18H83dbgf811td3hg=;
        b=X7xT6ikOow3V2pfy+QQc22BopKEdILWc+bZawfRl4VftQVIKDoy2eF9KfzC+MEl9kc
         HqYt6FNlQyrrtQuA5mdQxhiTSjdlXrzCDBcOdjsXBFo22pAZ04iZF5oFOROk0oKNCagZ
         PZUaed5A1jjJA3jEPMchv9FMSPo7qtvkxTr5jyxcK0U5lrwce5PGr3h3sd3S6M4emTx0
         WROVxjnYqWf7atWpenWvF7ph1T8FzwRqydJIb83ylmvfMAtCcGuOsRpNVarVmKN7zOLE
         3vnsvVl3tglaQn5pvd4ixL0CxUPNhCLgBD+kxBSEqjCLGqGYXYrrY96PAAqURxMVsyxe
         k/CQ==
X-Gm-Message-State: AOAM531ZQs60UWHShFek3zowKafaMoCF8tVPZv6TpDhV4owI5JDucprt
        r+F57hnjusH1R6bvjl6RC+ONtrVp/h+MmhGOGMwzPvkHB5Y4OSb7Q33vh/gGhim4ii8Nc6hltgD
        aXn1J700zjWKNqR29
X-Received: by 2002:a5d:438f:: with SMTP id i15mr20769026wrq.121.1604964244592;
        Mon, 09 Nov 2020 15:24:04 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwbdT7Ju4jMSmkfewDICOwHbAS5DiQ8A4WybJ++HMyazghudJkgYaLhUGBQ6merS8VO/KE9IA==
X-Received: by 2002:a5d:438f:: with SMTP id i15mr20769012wrq.121.1604964244401;
        Mon, 09 Nov 2020 15:24:04 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id g20sm949792wmh.20.2020.11.09.15.24.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 15:24:03 -0800 (PST)
Date:   Tue, 10 Nov 2020 00:24:01 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 1/2] ppp: add PPPIOCBRIDGECHAN ioctl
Message-ID: <20201109232401.GM2366@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201106181647.16358-2-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106181647.16358-2-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 06:16:46PM +0000, Tom Parkin wrote:
> This new ioctl allows two ppp channels to be bridged together: frames
> arriving in one channel are transmitted in the other channel and vice
> versa.
> 
> The practical use for this is primarily to support the L2TP Access
> Concentrator use-case.  The end-user session is presented as a ppp
> channel (typically PPPoE, although it could be e.g. PPPoA, or even PPP
> over a serial link) and is switched into a PPPoL2TP session for
> transmission to the LNS.  At the LNS the PPP session is terminated in
> the ISP's network.
> 
> When a PPP channel is bridged to another it takes a reference on the
> other's struct ppp_file.  This reference is dropped when the channel is
> unregistered: if the dereference causes the bridged channel's reference
> count to reach zero it is destroyed at that point.
> ---
>  drivers/net/ppp/ppp_generic.c  | 35 +++++++++++++++++++++++++++++++++-
>  include/uapi/linux/ppp-ioctl.h |  1 +
>  2 files changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> index 7d005896a0f9..d893bf4470f4 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -175,6 +175,7 @@ struct channel {
>  	struct net	*chan_net;	/* the net channel belongs to */
>  	struct list_head clist;		/* link in list of channels per unit */
>  	rwlock_t	upl;		/* protects `ppp' */
> +	struct channel *bridge;		/* "bridged" ppp channel */
>  #ifdef CONFIG_PPP_MULTILINK
>  	u8		avail;		/* flag used in multilink stuff */
>  	u8		had_frag;	/* >= 1 fragments have been sent */
> @@ -641,8 +642,9 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  	}
>  
>  	if (pf->kind == CHANNEL) {
> -		struct channel *pch;
> +		struct channel *pch, *pchb;
>  		struct ppp_channel *chan;
> +		struct ppp_net *pn;
>  
>  		pch = PF_TO_CHANNEL(pf);
>  
> @@ -657,6 +659,24 @@ static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  			err = ppp_disconnect_channel(pch);
>  			break;
>  
> +		case PPPIOCBRIDGECHAN:
> +			if (get_user(unit, p))
> +				break;
> +			err = -ENXIO;
> +			if (pch->bridge) {
> +				err = -EALREADY;
> +				break;
> +			}
> +			pn = ppp_pernet(current->nsproxy->net_ns);
> +			spin_lock_bh(&pn->all_channels_lock);
> +			pchb = ppp_find_channel(pn, unit);
> +			if (pchb) {
> +				refcount_inc(&pchb->file.refcnt);
> +				pch->bridge = pchb;

I think we shouldn't modify ->bridge if it's already set or if the
channel is already part of of a PPP unit  (that is, if pch->ppp or
pch->bridge is not NULL).

This also means that we have to use appropriate locking.

> +				err = 0;
> +			}
> +			spin_unlock_bh(&pn->all_channels_lock);
> +			break;
>  		default:
>  			down_read(&pch->chan_sem);
>  			chan = pch->chan;
> @@ -2100,6 +2120,12 @@ ppp_input(struct ppp_channel *chan, struct sk_buff *skb)
>  		return;
>  	}
>  
> +	if (pch->bridge) {
> +		skb_queue_tail(&pch->bridge->file.xq, skb);

The bridged channel might reside in a different network namespace.
So it seems that skb_scrub_packet() is needed before sending the
packet.

> +		ppp_channel_push(pch->bridge);

I'm not sure if the skb_queue_tail()/ppp_channel_push() sequence really
is necessary. We're not going through a PPP unit, so we have no risk of
recursion here. Also, if ->start_xmit() fails, I see no reason for
requeuing the skb, like __ppp_channel_push() does. I'd have to think
more about it, but I believe that we could call the channel's
->start_xmit() function directly (respecting the locking constraints
of course).

> +		return;
> +	}
> +
>  	read_lock_bh(&pch->upl);
>  	if (!ppp_decompress_proto(skb)) {
>  		kfree_skb(skb);
> @@ -2791,6 +2817,13 @@ ppp_unregister_channel(struct ppp_channel *chan)
>  	up_write(&pch->chan_sem);
>  	ppp_disconnect_channel(pch);
>  
> +	/* Drop our reference on a bridged channel, if any */
> +	if (pch->bridge) {
> +		if (refcount_dec_and_test(&pch->bridge->file.refcnt))
> +			ppp_destroy_channel(pch->bridge);
> +		pch->bridge = NULL;
> +	}
> +
>  	pn = ppp_pernet(pch->chan_net);
>  	spin_lock_bh(&pn->all_channels_lock);
>  	list_del(&pch->list);
> diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
> index 7bd2a5a75348..4b97ab519c19 100644
> --- a/include/uapi/linux/ppp-ioctl.h
> +++ b/include/uapi/linux/ppp-ioctl.h
> @@ -115,6 +115,7 @@ struct pppol2tp_ioc_stats {
>  #define PPPIOCATTCHAN	_IOW('t', 56, int)	/* attach to ppp channel */
>  #define PPPIOCGCHAN	_IOR('t', 55, int)	/* get ppp channel number */
>  #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
> +#define PPPIOCBRIDGECHAN _IOW('t', 53, int)	/* bridge one channel to another */
>  
>  #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
>  #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)	/* NEVER change this!! */
> -- 
> 2.17.1
> 

