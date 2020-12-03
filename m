Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3CEC2CCAFA
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 01:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727303AbgLCAYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 19:24:52 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53644 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgLCAYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 19:24:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606955004;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=890UvkCpPGwf3KrLihC74HIUdm2V+g0jFohstf8ZK9Y=;
        b=T5i6no/x+k8mkI3pgdzWu5C1PLmpZbGNsTMPWcZ6QCJIuYWRuAyc0b9rFVgTcKx9IjklrI
        ZEBhKADMD5QB2SN/po8LgRGHLNEEfy+E1jl0D9jGeJSyDnG2XbgFV6ODzh+5gIOD+282BO
        0/in54J+kxE3a2Zrr+n9sc7KMSGvW6o=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-334-Kmp9xmQ6M3ypHOvvcQByKg-1; Wed, 02 Dec 2020 19:23:22 -0500
X-MC-Unique: Kmp9xmQ6M3ypHOvvcQByKg-1
Received: by mail-wr1-f69.google.com with SMTP id w17so287362wrp.11
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 16:23:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=890UvkCpPGwf3KrLihC74HIUdm2V+g0jFohstf8ZK9Y=;
        b=c8YP42O/0znDBSgROn0c5ayIVXR/TRYZU70YCFsc4hcBzzKW1rblzPBtgCy65i+ydV
         26pRumXtdfubJp98lFp3VRCD050ZXVt0aD8GfQqICQUq9er0CnN0/GWRoFdzAmRcd4gG
         W+Kno5NfGt4wOlfz2NtsKEXnX9VZq3ULgUIAWfoxpRZ1SuZDTd3+UWaMIZJqKvO4P5w3
         yEpLKj17Z9Y5f3DZhqT264zS6DXVVEh9yyK6EVEZPVORiXOueMcCAgbKuHoyRc/NduRd
         MButFu3X0+eqycZPgIK1gschcgkSROq8/ztF6npL+NapXZ4YUyF7NZhOWwpvfB4dkHPu
         xm4g==
X-Gm-Message-State: AOAM533tvsUie0bhm8kvTqVgkmIdQ/c3vhkqIAIAzCiAo/HMaFd4Xysh
        vgUgTuzaJqDIpUoPzk2UWgZuHxEiF4xvm8xG3ux1SI1GyF5mQAQOYmTVm0B1ZyF2NUYXdnAg0rJ
        J29HoUqzuJ5kB1ASV
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr447011wmf.134.1606955001457;
        Wed, 02 Dec 2020 16:23:21 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyoXZSc0wIPdo6MC73ZevMgf0frnJINFbVf8hCwXmBS1Jjr4QLdEPaNvO4uIab+4yG0HwZk+A==
X-Received: by 2002:a1c:1fc2:: with SMTP id f185mr446992wmf.134.1606955001135;
        Wed, 02 Dec 2020 16:23:21 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z22sm184868wml.1.2020.12.02.16.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 16:23:20 -0800 (PST)
Date:   Thu, 3 Dec 2020 01:23:18 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [PATCH v2 net-next 1/2] ppp: add PPPIOCBRIDGECHAN and
 PPPIOCUNBRIDGECHAN ioctls
Message-ID: <20201203002318.GA31867@linux.home>
References: <20201201115250.6381-1-tparkin@katalix.com>
 <20201201115250.6381-2-tparkin@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201201115250.6381-2-tparkin@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 01, 2020 at 11:52:49AM +0000, Tom Parkin wrote:
> This new ioctl pair allows two ppp channels to be bridged together:
> frames arriving in one channel are transmitted in the other channel
> and vice versa.
> 
> The practical use for this is primarily to support the L2TP Access
> Concentrator use-case.  The end-user session is presented as a ppp
> channel (typically PPPoE, although it could be e.g. PPPoA, or even PPP
> over a serial link) and is switched into a PPPoL2TP session for
> transmission to the LNS.  At the LNS the PPP session is terminated in
> the ISP's network.
> 
> When a PPP channel is bridged to another it takes a reference on the
> other's struct ppp_file.  This reference is dropped when the channels
> are unbridged, which can occur either explicitly on userspace calling
> the PPPIOCUNBRIDGECHAN ioctl, or implicitly when either channel in the
> bridge is unregistered.
> 
> In order to implement the channel bridge, struct channel is extended
> with a new field, 'bridge', which points to the other struct channel
> making up the bridge.
> 
> This pointer is RCU protected to avoid adding another lock to the data
> path.
> 
> To guard against concurrent writes to the pointer, the existing struct
> channel lock 'upl' coverage is extended rather than adding a new lock.
> 
> The 'upl' lock is used to protect the existing unit pointer.  Since the
> bridge effectively replaces the unit (they're mutually exclusive for a
> channel) it makes coding easier to use the same lock to cover them
> both.
> 
> Signed-off-by: Tom Parkin <tparkin@katalix.com>
> ---
>  drivers/net/ppp/ppp_generic.c  | 139 ++++++++++++++++++++++++++++++++-
>  include/uapi/linux/ppp-ioctl.h |   2 +
>  2 files changed, 138 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
> index 7d005896a0f9..5babf0aff840 100644
> --- a/drivers/net/ppp/ppp_generic.c
> +++ b/drivers/net/ppp/ppp_generic.c
> @@ -174,7 +174,8 @@ struct channel {
>  	struct ppp	*ppp;		/* ppp unit we're connected to */
>  	struct net	*chan_net;	/* the net channel belongs to */
>  	struct list_head clist;		/* link in list of channels per unit */
> -	rwlock_t	upl;		/* protects `ppp' */
> +	rwlock_t	upl;		/* protects `ppp' and 'bridge' */
> +	struct channel __rcu *bridge;	/* "bridged" ppp channel */
>  #ifdef CONFIG_PPP_MULTILINK
>  	u8		avail;		/* flag used in multilink stuff */
>  	u8		had_frag;	/* >= 1 fragments have been sent */
> @@ -606,6 +607,73 @@ static struct bpf_prog *compat_ppp_get_filter(struct sock_fprog32 __user *p)
>  #endif
>  #endif
>  
> +/* Bridge one PPP channel to another.
> + * When two channels are bridged, ppp_input on one channel is redirected to
> + * the other's ops->start_xmit handler.
> + * In order to safely bridge channels we must reject channels which are already
> + * part of a bridge instance, or which form part of an existing unit.
> + * Once successfully bridged, each channel holds a reference on the other
> + * to prevent it being freed while the bridge is extant.
> + */
> +static int ppp_bridge_channels(struct channel *pch, struct channel *pchb)
> +{
> +	write_lock_bh(&pch->upl);
> +	if (pch->ppp || pch->bridge) {

Since ->bridge is RCU protected, it should be dereferenced with
rcu_dereference_protected() here:
rcu_dereference_protected(pch->bridge, lockdep_is_held(&pch->upl)).

> +		write_unlock_bh(&pch->upl);
> +		return -EALREADY;
> +	}
> +	rcu_assign_pointer(pch->bridge, pchb);
> +	write_unlock_bh(&pch->upl);
> +
> +	write_lock_bh(&pchb->upl);
> +	if (pchb->ppp || pchb->bridge) {

Same here (with adaptation of the lockdep part of course).

> +		write_unlock_bh(&pchb->upl);
> +		goto err_unset;
> +	}
> +	rcu_assign_pointer(pchb->bridge, pch);
> +	write_unlock_bh(&pchb->upl);
> +
> +	refcount_inc(&pch->file.refcnt);
> +	refcount_inc(&pchb->file.refcnt);
> +
> +	return 0;
> +
> +err_unset:
> +	write_lock_bh(&pch->upl);
> +	RCU_INIT_POINTER(pch->bridge, NULL);
> +	write_unlock_bh(&pch->upl);
> +	synchronize_rcu();
> +	return -EALREADY;
> +}
> +
> +static int ppp_unbridge_channels(struct channel *pch)
> +{
> +	struct channel *pchb;
> +
> +	write_lock_bh(&pch->upl);
> +	pchb = rcu_dereference(pch->bridge);

It'd make more sense to use rcu_dereference_protected() here too.

> +	if (!pchb) {
> +		write_unlock_bh(&pch->upl);
> +		return -EINVAL;

I'm not sure I'd consider this case as an error.
If there's no bridged channel, there's just nothing to do.
Furthermore, there might be situations where this is not really an
error (see the possible race below).

> +	}
> +	RCU_INIT_POINTER(pch->bridge, NULL);
> +	write_unlock_bh(&pch->upl);
> +
> +	write_lock_bh(&pchb->upl);
> +	RCU_INIT_POINTER(pchb->bridge, NULL);
> +	write_unlock_bh(&pchb->upl);
> +
> +	synchronize_rcu();
> +
> +	if (refcount_dec_and_test(&pch->file.refcnt))
> +		ppp_destroy_channel(pch);

I think that we could have a situation where pchb->bridge could be
different from pch.
If ppp_unbridge_channels() was also called concurrently on pchb, then
pchb->bridge might have been already reset. And it might have dropped
the reference it had on pch. In this case, we'd erroneously decrement
the refcnt again.

In theory, pchb->bridge might even have been reassigned to a different
channel. So we'd reset pchb->bridge, but without decrementing the
refcnt of the channel it pointed to (and again, we'd erroneously
decrement pch's refcount instead).

So I think we need to save pchb->bridge to a local variable while we
hold pchb->upl, and then drop the refcount of that channel, instead of
assuming that it's equal to pch.

> +	if (refcount_dec_and_test(&pchb->file.refcnt))
> +		ppp_destroy_channel(pchb);
> +
> +	return 0;
> +}
> +
>  static long ppp_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct ppp_file *pf;

snip

> @@ -3270,7 +3403,7 @@ ppp_connect_channel(struct channel *pch, int unit)
>  		goto out;
>  	write_lock_bh(&pch->upl);
>  	ret = -EINVAL;
> -	if (pch->ppp)
> +	if (pch->ppp || pch->bridge)

rcu_dereference_protected().

>  		goto outl;
>  
>  	ppp_lock(ppp);
> diff --git a/include/uapi/linux/ppp-ioctl.h b/include/uapi/linux/ppp-ioctl.h
> index 7bd2a5a75348..8dbecb3ad036 100644
> --- a/include/uapi/linux/ppp-ioctl.h
> +++ b/include/uapi/linux/ppp-ioctl.h
> @@ -115,6 +115,8 @@ struct pppol2tp_ioc_stats {
>  #define PPPIOCATTCHAN	_IOW('t', 56, int)	/* attach to ppp channel */
>  #define PPPIOCGCHAN	_IOR('t', 55, int)	/* get ppp channel number */
>  #define PPPIOCGL2TPSTATS _IOR('t', 54, struct pppol2tp_ioc_stats)
> +#define PPPIOCBRIDGECHAN _IOW('t', 53, int)	/* bridge one channel to another */
> +#define PPPIOCUNBRIDGECHAN _IO('t', 54)	/* unbridge channel */
>  
>  #define SIOCGPPPSTATS   (SIOCDEVPRIVATE + 0)
>  #define SIOCGPPPVER     (SIOCDEVPRIVATE + 1)	/* NEVER change this!! */
> -- 
> 2.17.1
> 

