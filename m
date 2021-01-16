Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430AD2F8E0F
	for <lists+netdev@lfdr.de>; Sat, 16 Jan 2021 18:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbhAPROO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Jan 2021 12:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728926AbhAPROJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Jan 2021 12:14:09 -0500
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC574C061574;
        Sat, 16 Jan 2021 09:13:28 -0800 (PST)
Received: by mail-oi1-x229.google.com with SMTP id l200so13097587oig.9;
        Sat, 16 Jan 2021 09:13:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JQYyHv7IM57vI890lYmuj/Cq36xklEeLDd0LywTovy4=;
        b=HsEOU9LhTmrMY5umpjFUy7M6AbjxsR96TayaPN8poWvcJ5Q3dJTYkPfhrZaonIPVCI
         N5ePDDkQ+4GEMV5Iz2AXnZZ0RLtTrSK01G9gBoVRgbRPmmj9E66JeGQWE5k02fcgpn8j
         y0eQQRKTtcDTSxzAkIbleO0Ob8c8FMAHYWsMfjUVXQJYYtGGpFkoQak2jtmB/m5rRXCE
         EsJB+f8ArwkmBStrUe13I2Wejh4scYfRYL5e1x/LCoIcG7+RLaMhtOvoSrfMa0SfWWR9
         hQnyQkPJ1rBbcHPL6UpnrJrTiaC2WkfFbJP8yiRZKEG/zWSCxf9yuKDstCk8nUQh1+QO
         f/cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JQYyHv7IM57vI890lYmuj/Cq36xklEeLDd0LywTovy4=;
        b=KQLQROiS6bXrrTHpZCZROOnA+0vbvHgg1bhJBAUqdXnN+esdClHuZMozWlqumCRaua
         6s3Mr8UQjDj2vdYeVZo0uzvbogHeM/IqRc/zgJIcIriySg9DYo6J2mOTKvDVBp+Lnigt
         p0gVmJwoRED2h9TpMLusNKWAr+TzQJM6myNy1aOuoAWg9qZym5kA7zizpx9fU7FmRHeX
         M2GjW+24g6QSCcYTGq97uij23FM/qHfi5X3/Cp64nX5z7TrhanAp0iSWqpeIY5nly5MS
         199OFprnutdDjYzUg00kM8loSHkQVLMvpZC/an4n9qYwJyoQU7YpMdAu6Lu8W2KHh+qn
         IyRg==
X-Gm-Message-State: AOAM533SuSxg9LVsPzaHMgOZTYkJIJKZW2p8L3wc85k5D+IeKvREiIzG
        pxl+Ojpo4pfkLe1bsrSJG9C50Mk2pxc=
X-Google-Smtp-Source: ABdhPJz2gXjXbLk831qAfBJ4HlYyzfZWNHw7t4HR18bJNH4EQQPtAX7xI4w33xt8twSiUEl/gO/tzA==
X-Received: by 2002:aca:5493:: with SMTP id i141mr9034379oib.82.1610817207734;
        Sat, 16 Jan 2021 09:13:27 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.23])
        by smtp.googlemail.com with ESMTPSA id t26sm2630620otm.17.2021.01.16.09.13.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Jan 2021 09:13:26 -0800 (PST)
Subject: Re: [PATCH v2 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
To:     Praveen Chaudhary <praveen5582@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>
References: <20210115080203.8889-1-pchaudhary@linkedin.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0f64942e-debd-81bd-b29c-7d2728a5bd4b@gmail.com>
Date:   Sat, 16 Jan 2021 10:13:23 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210115080203.8889-1-pchaudhary@linkedin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/21 1:02 AM, Praveen Chaudhary wrote:
> For IPv4, default route is learned via DHCPv4 and user is allowed to change
> metric using config etc/network/interfaces. But for IPv6, default route can
> be learned via RA, for which, currently a fixed metric value 1024 is used.
> 
> Ideally, user should be able to configure metric on default route for IPv6
> similar to IPv4. This fix adds sysctl for the same.
> 
> Signed-off-by: Praveen Chaudhary <pchaudhary@linkedin.com>
> Signed-off-by: Zhenggen Xu <zxu@linkedin.com>
> 
> Changes in v1.
> ---

your trying to be too fancy in the log messages; everything after this
first '---' is dropped. Just Remove all of the '---' lines and '```' tags.

> 1.) Correct the call to rt6_add_dflt_router.
> ---
> 
> Changes in v2.
> [Refer: lkml.org/lkml/2021/1/14/1400]
> ---
> 1.) Replace accept_ra_defrtr_metric to ra_defrtr_metric.
> 2.) Change Type to __u32 instead of __s32.
> 3.) Change description in Documentation/networking/ip-sysctl.rst.
> 4.) Use proc_douintvec instead of proc_dointvec.
> 5.) Code style in ndisc_router_discovery().
> 6.) Change Type to u32 instead of unsigned int.
> ---
> 
> Logs:
> ----------------------------------------------------------------
> For IPv4:
> ----------------------------------------------------------------
> 
> Config in etc/network/interfaces
> ----------------------------------------------------------------
> ```
> auto eth0
> iface eth0 inet dhcp
>     metric 4261413864

how does that work for IPv4? Is the metric passed to the dhclient and it
inserts the route with the given metric or is a dhclient script used to
replace the route after insert?


> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index dd2b12a32b73..c4b8d4b8d213 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1871,6 +1871,18 @@ accept_ra_defrtr - BOOLEAN
>  		- enabled if accept_ra is enabled.
>  		- disabled if accept_ra is disabled.
>  
> +ra_defrtr_metric - INTEGER
> +	Route metric for default route learned in Router Advertisement. This value
> +	will be assigned as metric for the default route learned via IPv6 Router
> +	Advertisement. Takes affect only if accept_ra_defrtr' is enabled.

stray ' after accept_ra_defrtr

> +
> +	Possible values are:
> +		0:
> +			default value will be used for route metric
> +			i.e. IP6_RT_PRIO_USER 1024.
> +		1 to 0xFFFFFFFF:
> +			current value will be used for route metric.
> +
>  accept_ra_from_local - BOOLEAN
>  	Accept RA with source-address that is found on local machine
>  	if the RA is otherwise proper and able to be accepted.



> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index eff2cacd5209..b13d3213e58f 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -205,6 +205,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
>  	.max_desync_factor	= MAX_DESYNC_FACTOR,
>  	.max_addresses		= IPV6_MAX_ADDRESSES,
>  	.accept_ra_defrtr	= 1,
> +	.ra_defrtr_metric = 0,

make the the '=' align column wise with the existing entries; seems like
your new line is missing a tab

>  	.accept_ra_from_local	= 0,
>  	.accept_ra_min_hop_limit= 1,
>  	.accept_ra_pinfo	= 1,
> @@ -260,6 +261,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
>  	.max_desync_factor	= MAX_DESYNC_FACTOR,
>  	.max_addresses		= IPV6_MAX_ADDRESSES,
>  	.accept_ra_defrtr	= 1,
> +	.ra_defrtr_metric = 0,

same here

>  	.accept_ra_from_local	= 0,
>  	.accept_ra_min_hop_limit= 1,
>  	.accept_ra_pinfo	= 1,
> @@ -5475,6 +5477,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
>  	array[DEVCONF_MAX_DESYNC_FACTOR] = cnf->max_desync_factor;
>  	array[DEVCONF_MAX_ADDRESSES] = cnf->max_addresses;
>  	array[DEVCONF_ACCEPT_RA_DEFRTR] = cnf->accept_ra_defrtr;
> +	array[DEVCONF_RA_DEFRTR_METRIC] = cnf->ra_defrtr_metric;
>  	array[DEVCONF_ACCEPT_RA_MIN_HOP_LIMIT] = cnf->accept_ra_min_hop_limit;
>  	array[DEVCONF_ACCEPT_RA_PINFO] = cnf->accept_ra_pinfo;
>  #ifdef CONFIG_IPV6_ROUTER_PREF
> @@ -6667,6 +6670,13 @@ static const struct ctl_table addrconf_sysctl[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "ra_defrtr_metric",
> +		.data		= &ipv6_devconf.ra_defrtr_metric,
> +		.maxlen		= sizeof(u32),
> +		.mode		= 0644,
> +		.proc_handler	= proc_douintvec,
> +	},
>  	{
>  		.procname	= "accept_ra_min_hop_limit",
>  		.data		= &ipv6_devconf.accept_ra_min_hop_limit,
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 76717478f173..2bffed49f5c0 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -1173,6 +1173,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>  	struct neighbour *neigh = NULL;
>  	struct inet6_dev *in6_dev;
>  	struct fib6_info *rt = NULL;
> +	u32 defrtr_usr_metric;
>  	struct net *net;
>  	int lifetime;
>  	struct ndisc_options ndopts;
> @@ -1303,18 +1304,23 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>  			return;
>  		}
>  	}
> -	if (rt && lifetime == 0) {
> +	/* Set default route metric if specified by user */
> +	defrtr_usr_metric = in6_dev->cnf.accept_ra_defrtr_metric;

this tells me you did not compile this version of the patch since the
'accept_' has been dropped. Always compile and test every patch before
sending.
