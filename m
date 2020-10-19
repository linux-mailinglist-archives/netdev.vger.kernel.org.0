Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15AB7292F15
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 22:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728332AbgJSUDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 16:03:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726385AbgJSUDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 16:03:02 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE4D4C0613CE;
        Mon, 19 Oct 2020 13:03:01 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id z5so802583ejw.7;
        Mon, 19 Oct 2020 13:03:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=18BK5QABG5QnCnKw4efSXgYTiRd7IX1w5DP5yy+9I9I=;
        b=rFDnMP98hbleUk2ilEizlHXP674Bq3lV8+edQSDV3d11umzEPWtjx8SQmsPOSlZWEV
         yDTXSwJg9qZUAxfjAA98CYUBOQJWs0+RPJry16l8727hgHMJc1SaDjpT+cHnZNNGoUCh
         1Lluv4t5NPXLJpoVbn/OxAJEmguv1vLKfpxlwThO4J8lCmVKct06cv2k2wdXpgHn5GrM
         hGLM3Eo1Gmh5tZj/CuOvR1pyFXcdIBr8iJupLy6M9rWqzWb4fAOdlqdDw7LOXXTKLBwS
         +hQvI24VZiYj6QWwZlN2+VCV+F1bB4ZaB+h/35o/7iVrnd3+AJ9stXWE4eiNbcmBRRpr
         7Ckw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=18BK5QABG5QnCnKw4efSXgYTiRd7IX1w5DP5yy+9I9I=;
        b=PPi53IAMhUSoTVYs1+WU00aFZ0lg+LnfGB84nNOUY3baTWPithoPVTxLbRX0GmHXY8
         2aXjyNvZ3jPMddsit53mw/4F2yGZ5LnVJvi4uUmSqLZkTQxUdtjQPQuiHOAWPU2cvcdS
         VsCCPeVMMZ9EokrJBJ117LM8M5+SwHvWBVLigiCaWgcNuEwCV/cJge/iAJ5BjbP1AAtw
         C3x86uOn2VNUt2e2a6hZHofSqoI1T08ipwaclWrJAMEF42PIP79jDXczd6c8Eu2zKFr2
         U9hJ6GQp3Fy/YgFn8Rz9ql1+XT+RZtfvwkmqapJAw16T1fINcuS1U4gjPPgUbzZkU9PW
         Ogfg==
X-Gm-Message-State: AOAM533ZMcq3t8RAyXcRNC8VXdeirQfWyYHl3NZl2A0fqY5/SK5pJG9c
        8nJexTcDMd3TpLft7FGGqsk=
X-Google-Smtp-Source: ABdhPJzkCeWXmQnav763Ok076vRwgRnjdn4adsktoySJMo8mM09SCNxvBPJVR7s4jDoKLkHpD+5uWQ==
X-Received: by 2002:a17:906:95d1:: with SMTP id n17mr1605193ejy.75.1603137780335;
        Mon, 19 Oct 2020 13:03:00 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id v14sm834988edy.68.2020.10.19.13.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 13:02:59 -0700 (PDT)
Date:   Mon, 19 Oct 2020 23:02:58 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Yunjian Wang <wangyunjian@huawei.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: Have netpoll bring-up DSA management interface
Message-ID: <20201019200258.jrtymxikwrijkvpq@skbuf>
References: <20201019171746.991720-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201019171746.991720-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 10:17:44AM -0700, Florian Fainelli wrote:
> These devices also do not utilize the upper/lower linking so the
> check about the netpoll device having upper is not going to be a
> problem.

They do as of 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA
master to get rid of lockdep warnings"), don't they? The question is why
that doesn't work, and the answer is, I believe, that the linkage needs
to be the other way around than DSA has it.

> 
> The solution adopted here is identical to the one done for
> net/ipv4/ipconfig.c with 728c02089a0e ("net: ipv4: handle DSA enabled
> master network devices"), with the network namespace scope being
> restricted to that of the process configuring netpoll.

... and further restricted to the only network namespace that DSA
supports. As a side note, we should declare NETIF_F_NETNS_LOCAL_BIT for
DSA interfaces.

> 
> Fixes: 04ff53f96a93 ("net: dsa: Add netconsole support")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
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
> +
> +		err = dev_change_flags(dev, dev->flags | IFF_UP, NULL);
> +		if (err < 0) {
> +			np_err(np, "%s failed to open %s\n",
> +			       np->dev_name, dev->name);
> +			goto put;
> +		}
> +	}
> +

Completely crazy and outlandish idea, I know, but what's wrong with
doing this in DSA?

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 33788b5c1742..e5927c4498a2 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -68,8 +68,14 @@ static int dsa_slave_open(struct net_device *dev)
 	struct dsa_port *dp = dsa_slave_to_port(dev);
 	int err;
 
-	if (!(master->flags & IFF_UP))
-		return -ENETDOWN;
+	if (!(master->flags & IFF_UP)) {
+		err = dev_change_flags(master, master->flags | IFF_UP, NULL);
+		if (err < 0) {
+			netdev_err(dev, "failed to open master %s\n",
+				   master->name);
+			goto out;
+		}
+	}
 
 	if (!ether_addr_equal(dev->dev_addr, master->dev_addr)) {
 		err = dev_uc_add(master, dev->dev_addr);
-- 
2.25.1

It has the benefit that user space can now remove DSA-specific
workarounds, like systemd-networkd with BindCarrier:
https://github.com/systemd/systemd/issues/7478
And we could remove one of the 2 bullets in the "Common pitfalls using
DSA setups" chapter:
https://www.kernel.org/doc/Documentation/networking/dsa/dsa.txt
And....
We could remove the DSA workaround from net/ipv4/ipconfig.c as well.
Just saying.

>  	if (netdev_master_upper_dev_get(ndev)) {
>  		np_err(np, "%s is a slave device, aborting\n", np->dev_name);
>  		err = -EBUSY;
> -- 
> 2.25.1
> 
