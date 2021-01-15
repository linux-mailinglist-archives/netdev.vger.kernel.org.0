Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6B62F7092
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 03:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732082AbhAOC22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 21:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726182AbhAOC21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 21:28:27 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86A84C061575;
        Thu, 14 Jan 2021 18:27:47 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id q25so7203624otn.10;
        Thu, 14 Jan 2021 18:27:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vsVE7oLZbgznex7yQ+E8rIoI4mqNZuXB4jx1JCYSde0=;
        b=vXWaUc2TfmNg04SdepiuT8FQzqEbT+tch5lAlnfiNhOFjecqfhZlM9Y6uJsn7J1uOt
         D4oMaUeixZgSvphD8cYOWhNi4Jz6sUlTw7osgSaeghumNIBIw3yBQnNjZrBGy4HVmg6+
         BAlEOPRquIqXSxS83hXsmG7uTvEuM9K8pRy1lO1MCWphHytLtCUH3hVQIjAePGtnDmhj
         P2g8PW6txWVBIeVdaamVk8OTr5JJEH0ldNRZ0Lqnu+809bAAnkQ7N6sd3qPWMrVVXI8g
         9qLEuQvi3i9PYYpsT/Nmu+jsFJtBCq23I0XTuoLIpqXhFtVE5QAxgdvdxQ+D0x1sBg7v
         0FFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vsVE7oLZbgznex7yQ+E8rIoI4mqNZuXB4jx1JCYSde0=;
        b=GZ9hko5uplqp59qxggQJOAjtJI8W2EtMGylYmoq6WxGLBc5h0XBp6DZpfsPwxxbwSn
         M61wJJmnhjHcY/yYgg4t0sMSVrx26I1GSORam7tLVGwKOSVERU+08qD2Q5gmJdhlvMcZ
         2LW5rIdtLbLqQ8Fk80xJcUQ7cP66bAM+84BrnVjT8A+8q/S1Wlbhxw3E8uLPAEVLzbxd
         GJUpz0nHjsHhcqDWC4TbJMV3gGQ5Tdltcgc93fzR7uvnj+7AKqvcQvH/k7003mM+e3FB
         xXnCMLLhRdNGWrDQIsLbwrl5YUYld07WDKXplR+J4E+KOHBTL683ZiO//dDtbsOuEgft
         P78Q==
X-Gm-Message-State: AOAM5320BvChumjsYNFtC1IJjO4jRSZLfDBwwGb88/PJpBFbIlvyVx5r
        GYgMGRobBBf2HV7TH32zWgo=
X-Google-Smtp-Source: ABdhPJzxJxWqrrMv9sRUQtacw7st+DP8TkLKHKnYiOpR18OW9HobSFKZKQXEWF9trfSao2Jm93fNbA==
X-Received: by 2002:a9d:5ad:: with SMTP id 42mr6688954otd.154.1610677666777;
        Thu, 14 Jan 2021 18:27:46 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.20.123.47])
        by smtp.googlemail.com with ESMTPSA id j10sm1513219otn.63.2021.01.14.18.27.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Jan 2021 18:27:45 -0800 (PST)
Subject: Re: [PATCH v1 net-next 1/1] Allow user to set metric on default route
 learned via Router Advertisement.
To:     Praveen Chaudhary <praveen5582@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Zhenggen Xu <zxu@linkedin.com>
References: <20210113015036.17674-1-pchaudhary@linkedin.com>
 <20210113015036.17674-2-pchaudhary@linkedin.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e894509c-e081-3682-7cc4-a20812f41984@gmail.com>
Date:   Thu, 14 Jan 2021 19:27:43 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210113015036.17674-2-pchaudhary@linkedin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/12/21 6:50 PM, Praveen Chaudhary wrote:
> For IPv4, default route is learned via DHCPv4 and user is allowed to change
> metric using config etc/network/interfaces. But for IPv6, default route can
> be learned via RA, for which, currently a fixed metric value 1024 is used.
> 
> Ideally, user should be able to configure metric on default route for IPv6
> similar to IPv4. This fix adds sysctl for the same.

This is a single patch set, so the details you have in the cover letter
should be in this description here. Also, please just 'ip' commands in
the patch description; 'route' command is a dinosaur that needs to be
retired.

> 
> Signed-off-by: Praveen Chaudhary<pchaudhary@linkedin.com>
> Signed-off-by: Zhenggen Xu<zxu@linkedin.com>
> 
> Changes in v1.
> ---
> 1.) Correct the call to rt6_add_dflt_router.
> ---
> 
> ---
>  Documentation/networking/ip-sysctl.rst | 18 ++++++++++++++++++
>  include/linux/ipv6.h                   |  1 +
>  include/net/ip6_route.h                |  3 ++-
>  include/uapi/linux/ipv6.h              |  1 +
>  include/uapi/linux/sysctl.h            |  1 +
>  net/ipv6/addrconf.c                    | 10 ++++++++++
>  net/ipv6/ndisc.c                       | 14 ++++++++++----
>  net/ipv6/route.c                       |  5 +++--
>  8 files changed, 46 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index dd2b12a32b73..384159081d91 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -1871,6 +1871,24 @@ accept_ra_defrtr - BOOLEAN
>  		- enabled if accept_ra is enabled.
>  		- disabled if accept_ra is disabled.
>  
> +accept_ra_defrtr_metric - INTEGER

Drop the 'accept' part; ra_defrtr_metric is sufficiently long. Since the
value is not from the RA, it is not really about accepting data from the RA.

> +	Route metric for default route learned in Router Advertisement. This
> +	value will be assigned as metric for the route learned via IPv6 Router
> +	Advertisement.
> +
> +	Possible values are:
> +		0:
> +			Use default value i.e. IP6_RT_PRIO_USER	1024.
> +		0xFFFFFFFF to -1:
> +			-ve values represent high route metric, value will be treated as
> +			unsigned value. This behaviour is inline with current IPv4 metric
> +			shown with commands such as "route -n" or "ip route list".
> +		1 to 0x7FFFFFF:
> +			+ve values will be used as is for route metric.

route metric is a u32, so these ranges should not be needed. 'ip route
list' shows metric as a positive number only.


> +
> +	Functional default: enabled if accept_ra_defrtr is enabled.
> +				disabled if accept_ra_defrtr is disabled.

Alignment problem, but I think this can be moved above to the
description and changed to something like 'only takes affect if
accept_ra_defrtr' is enabled.

> +
>  accept_ra_from_local - BOOLEAN
>  	Accept RA with source-address that is found on local machine
>  	if the RA is otherwise proper and able to be accepted.
> diff --git a/include/linux/ipv6.h b/include/linux/ipv6.h
> index dda61d150a13..19af90c77200 100644
> --- a/include/linux/ipv6.h
> +++ b/include/linux/ipv6.h
> @@ -31,6 +31,7 @@ struct ipv6_devconf {
>  	__s32		max_desync_factor;
>  	__s32		max_addresses;
>  	__s32		accept_ra_defrtr;
> +	__s32		accept_ra_defrtr_metric;

__u32 and drop the 'accept_' prefix.


>  	__s32		accept_ra_min_hop_limit;
>  	__s32		accept_ra_pinfo;
>  	__s32		ignore_routes_with_linkdown;
> diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
> index 2a5277758379..a470bdab2420 100644
> --- a/include/net/ip6_route.h
> +++ b/include/net/ip6_route.h
> @@ -174,7 +174,8 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
>  				     struct net_device *dev);
>  struct fib6_info *rt6_add_dflt_router(struct net *net,
>  				     const struct in6_addr *gwaddr,
> -				     struct net_device *dev, unsigned int pref);
> +				     struct net_device *dev, unsigned int pref,
> +				     unsigned int defrtr_usr_metric);

u32 for consistency

>  
>  void rt6_purge_dflt_routers(struct net *net);
>  
> diff --git a/include/uapi/linux/ipv6.h b/include/uapi/linux/ipv6.h
> index 13e8751bf24a..945de5de5144 100644
> --- a/include/uapi/linux/ipv6.h
> +++ b/include/uapi/linux/ipv6.h
> @@ -189,6 +189,7 @@ enum {
>  	DEVCONF_ACCEPT_RA_RT_INFO_MIN_PLEN,
>  	DEVCONF_NDISC_TCLASS,
>  	DEVCONF_RPL_SEG_ENABLED,
> +	DEVCONF_ACCEPT_RA_DEFRTR_METRIC,

Drop 'ACCEPT_'

>  	DEVCONF_MAX
>  };
>  
> diff --git a/include/uapi/linux/sysctl.h b/include/uapi/linux/sysctl.h
> index 458179df9b27..5e79c196e33c 100644
> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -571,6 +571,7 @@ enum {
>  	NET_IPV6_ACCEPT_SOURCE_ROUTE=25,
>  	NET_IPV6_ACCEPT_RA_FROM_LOCAL=26,
>  	NET_IPV6_ACCEPT_RA_RT_INFO_MIN_PLEN=27,
> +	NET_IPV6_ACCEPT_RA_DEFRTR_METRIC=28,

Drop 'ACCEPT_'

>  	__NET_IPV6_MAX
>  };
>  
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index eff2cacd5209..702ec4a33936 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -205,6 +205,7 @@ static struct ipv6_devconf ipv6_devconf __read_mostly = {
>  	.max_desync_factor	= MAX_DESYNC_FACTOR,
>  	.max_addresses		= IPV6_MAX_ADDRESSES,
>  	.accept_ra_defrtr	= 1,
> +	.accept_ra_defrtr_metric = 0,
>  	.accept_ra_from_local	= 0,
>  	.accept_ra_min_hop_limit= 1,
>  	.accept_ra_pinfo	= 1,
> @@ -260,6 +261,7 @@ static struct ipv6_devconf ipv6_devconf_dflt __read_mostly = {
>  	.max_desync_factor	= MAX_DESYNC_FACTOR,
>  	.max_addresses		= IPV6_MAX_ADDRESSES,
>  	.accept_ra_defrtr	= 1,
> +	.accept_ra_defrtr_metric = 0,
>  	.accept_ra_from_local	= 0,
>  	.accept_ra_min_hop_limit= 1,
>  	.accept_ra_pinfo	= 1,
> @@ -5475,6 +5477,7 @@ static inline void ipv6_store_devconf(struct ipv6_devconf *cnf,
>  	array[DEVCONF_MAX_DESYNC_FACTOR] = cnf->max_desync_factor;
>  	array[DEVCONF_MAX_ADDRESSES] = cnf->max_addresses;
>  	array[DEVCONF_ACCEPT_RA_DEFRTR] = cnf->accept_ra_defrtr;
> +	array[DEVCONF_ACCEPT_RA_DEFRTR_METRIC] = cnf->accept_ra_defrtr_metric;
>  	array[DEVCONF_ACCEPT_RA_MIN_HOP_LIMIT] = cnf->accept_ra_min_hop_limit;
>  	array[DEVCONF_ACCEPT_RA_PINFO] = cnf->accept_ra_pinfo;
>  #ifdef CONFIG_IPV6_ROUTER_PREF
> @@ -6667,6 +6670,13 @@ static const struct ctl_table addrconf_sysctl[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec,
>  	},
> +	{
> +		.procname	= "accept_ra_defrtr_metric",
> +		.data		= &ipv6_devconf.accept_ra_defrtr_metric,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= proc_dointvec,

proc_douintvec


> +	},
>  	{
>  		.procname	= "accept_ra_min_hop_limit",
>  		.data		= &ipv6_devconf.accept_ra_min_hop_limit,
> diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
> index 76717478f173..96ab202e95f9 100644
> --- a/net/ipv6/ndisc.c
> +++ b/net/ipv6/ndisc.c
> @@ -1180,6 +1180,7 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>  	unsigned int pref = 0;
>  	__u32 old_if_flags;
>  	bool send_ifinfo_notify = false;
> +	unsigned int defrtr_usr_metric = 0;

net coding style is reverse xmas tree - ie., longest to shortest. yes,
this function is old school, but new entries can be added in the right
place. Since you set before use, the initialization to 0 is not
necessary. And u32 for consistency.

>  
>  	__u8 *opt = (__u8 *)(ra_msg + 1);
>  
> @@ -1303,18 +1304,23 @@ static void ndisc_router_discovery(struct sk_buff *skb)
>  			return;
>  		}
>  	}
> -	if (rt && lifetime == 0) {
> +	/* Set default route metric if specified by user */
> +	defrtr_usr_metric = in6_dev->cnf.accept_ra_defrtr_metric;
> +	if (defrtr_usr_metric == 0)
> +		defrtr_usr_metric = IP6_RT_PRIO_USER;
> +	/* delete the route if lifetime is 0 or if metric needs change */
> +	if (rt && ((lifetime == 0) || (rt->fib6_metric != defrtr_usr_metric)))  {
>  		ip6_del_rt(net, rt, false);
>  		rt = NULL;
>  	}
>  
> -	ND_PRINTK(3, info, "RA: rt: %p  lifetime: %d, for dev: %s\n",
> -		  rt, lifetime, skb->dev->name);
> +	ND_PRINTK(3, info, "RA: rt: %p  lifetime: %d, metric: %d, for dev: %s\n",
> +		  rt, lifetime, defrtr_usr_metric, skb->dev->name);
>  	if (!rt && lifetime) {
>  		ND_PRINTK(3, info, "RA: adding default router\n");
>  
>  		rt = rt6_add_dflt_router(net, &ipv6_hdr(skb)->saddr,
> -					 skb->dev, pref);
> +					 skb->dev, pref, defrtr_usr_metric);
>  		if (!rt) {
>  			ND_PRINTK(0, err,
>  				  "RA: %s failed to add default route\n",
> diff --git a/net/ipv6/route.c b/net/ipv6/route.c
> index 188e114b29b4..5f177ae97e42 100644
> --- a/net/ipv6/route.c
> +++ b/net/ipv6/route.c
> @@ -4252,11 +4252,12 @@ struct fib6_info *rt6_get_dflt_router(struct net *net,
>  struct fib6_info *rt6_add_dflt_router(struct net *net,
>  				     const struct in6_addr *gwaddr,
>  				     struct net_device *dev,
> -				     unsigned int pref)
> +				     unsigned int pref,
> +				     unsigned int defrtr_usr_metric)

u32

>  {
>  	struct fib6_config cfg = {
>  		.fc_table	= l3mdev_fib_table(dev) ? : RT6_TABLE_DFLT,
> -		.fc_metric	= IP6_RT_PRIO_USER,
> +		.fc_metric	= defrtr_usr_metric ? defrtr_usr_metric : IP6_RT_PRIO_USER,

you can abbreviate that as:
		defrtr_usr_metric ? : IP6_RT_PRIO_USER,

>  		.fc_ifindex	= dev->ifindex,
>  		.fc_flags	= RTF_GATEWAY | RTF_ADDRCONF | RTF_DEFAULT |
>  				  RTF_UP | RTF_EXPIRES | RTF_PREF(pref),
> 

