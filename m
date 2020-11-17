Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 597E42B55DF
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgKQAxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:53:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgKQAxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 19:53:48 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCD4C0613CF;
        Mon, 16 Nov 2020 16:53:47 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id y17so21402978ejh.11;
        Mon, 16 Nov 2020 16:53:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2o7OGn9WvKMhymvV8X+QwJfGVcJAh47V+GXc3f8k/CM=;
        b=n75iUk9KCZ7kcqeH/u8L7qaottus43VQZlB1CK5i/csJqK5ZYjzwWJupW71Oh7xtRV
         XnT/GsTQlBC5kbVKySBCr5a+aaOWZS0p3EhvBfYY3rnD8vE2IpRUNqAWyzXXE9+fhI2Y
         Y1rj/PAXUlv9OEVG3e54qenui7Egnl8Ph8Q+1B1qVD6gVpOTDcHITGWaHWGMcrD5/JFw
         vUJ9yJhtwRP4Kpjni9yGZBMqZAZECJw8phCkXh3/QBo692QCDxuXqgv8FXpcENn84IpM
         zwvLiiL5ydK95b5RCycbOw+NjRWVoxb6u7gBG1noUZipBEA4jPvxqM3WVBTbUIs7/6Vb
         zN8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2o7OGn9WvKMhymvV8X+QwJfGVcJAh47V+GXc3f8k/CM=;
        b=O0pubmncAcGNpRA8tGDbceOPLRw0HJIzGS5uj8MDH5UDLTLyO1jGsXPFbgQufVfd6y
         k4wZbIjLSKy813w3IIV0MgRuQJB2Ggm4ZQc7+CoKZpBASdq5JME49FdeyIukYa4whSqY
         Ks6hFUj5XmVlXj5S4yqu/9kTyAUkNTVHEJ8gKVc98E/KKMCbX6XoMmQXcxKhx7PdMJDE
         mw5DggYytHNOiraMcPnS8ivZK8c6AcutpOaCzR7ctZbJQhiDL1mOaz14mt5eIv9nezJP
         eYofzLegDTjkhWspGbP4X7EUCZYo5n858nuyHz4LwH9bp6/sQp466liY4JR0Jnc6D1uQ
         zDvw==
X-Gm-Message-State: AOAM530JxBgFU6/EibKETS1OXbb/B1xDQn0/29OvFPMHqdKFY0UCyRsK
        3wTWTbp1uHxYYQ3HyYrfv1mTxW5c/eo=
X-Google-Smtp-Source: ABdhPJxULt71uJuehbR8inIxbiHEUJCBnFRifuHJ4bsaUffjaO/jlVM4iOgMYzpJFBMKi0eSq1L3oQ==
X-Received: by 2002:a17:906:1945:: with SMTP id b5mr17004988eje.388.1605574426195;
        Mon, 16 Nov 2020 16:53:46 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id ew18sm1720718ejb.86.2020.11.16.16.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2020 16:53:45 -0800 (PST)
Date:   Tue, 17 Nov 2020 02:53:44 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201117005344.q2qosamyuib3xwy3@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019171746.991720-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 10:17:44AM -0700, Florian Fainelli wrote:
> DSA network devices rely on having their DSA management interface up and
> running otherwise their ndo_open() will return -ENETDOWN. Without doing
> this it would not be possible to use DSA devices as netconsole when
> configured on the command line. These devices also do not utilize the
> upper/lower linking so the check about the netpoll device having upper
> is not going to be a problem.
> 
> The solution adopted here is identical to the one done for
> net/ipv4/ipconfig.c with 728c02089a0e ("net: ipv4: handle DSA enabled
> master network devices"), with the network namespace scope being
> restricted to that of the process configuring netpoll.

Or to that of the swapper process, when netpoll_setup is called from
initcall context.

> 
> Fixes: 04ff53f96a93 ("net: dsa: Add netconsole support")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---

Tested-by: Vladimir Oltean <olteanv@gmail.com>

>  net/core/netpoll.c | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/netpoll.c b/net/core/netpoll.c
> index c310c7c1cef7..960948290001 100644
> --- a/net/core/netpoll.c
> +++ b/net/core/netpoll.c
> @@ -29,6 +29,7 @@
>  #include <linux/slab.h>
>  #include <linux/export.h>
>  #include <linux/if_vlan.h>
> +#include <net/dsa.h>
>  #include <net/tcp.h>
>  #include <net/udp.h>
>  #include <net/addrconf.h>
> @@ -657,15 +658,15 @@ EXPORT_SYMBOL_GPL(__netpoll_setup);
>  
>  int netpoll_setup(struct netpoll *np)
>  {
> -	struct net_device *ndev = NULL;
> +	struct net_device *ndev = NULL, *dev = NULL;
> +	struct net *net = current->nsproxy->net_ns;
>  	struct in_device *in_dev;
>  	int err;
>  
>  	rtnl_lock();
> -	if (np->dev_name[0]) {
> -		struct net *net = current->nsproxy->net_ns;
> +	if (np->dev_name[0])
>  		ndev = __dev_get_by_name(net, np->dev_name);
> -	}
> +
>  	if (!ndev) {
>  		np_err(np, "%s doesn't exist, aborting\n", np->dev_name);
>  		err = -ENODEV;
> @@ -673,6 +674,19 @@ int netpoll_setup(struct netpoll *np)
>  	}
>  	dev_hold(ndev);
>  
> +	/* bring up DSA management network devices up first */
> +	for_each_netdev(net, dev) {
> +		if (!netdev_uses_dsa(dev))
> +			continue;

Not amazing, but does the job.

> +
> +		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
> +		if (err < 0) {
> +			np_err(np, "%s failed to open %s\n",
> +			       np->dev_name, dev->name);
> +			goto put;
> +		}
> +	}
> +
>  	if (netdev_master_upper_dev_get(ndev)) {
>  		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
>  		err = -EBUSY;
> -- 
> 2.25.1
> 
