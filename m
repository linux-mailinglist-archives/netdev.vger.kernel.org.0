Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5157DCB23F
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 01:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731018AbfJCXV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 19:21:29 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:38478 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727452AbfJCXV2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 19:21:28 -0400
Received: by mail-qt1-f194.google.com with SMTP id j31so6091663qta.5
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 16:21:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=bDGFVKN18wriUwk6FxdwjN0VtjasCQxZD6jHLFTJDxY=;
        b=TD4fM3Cg8v9ivFHYV7rsNthzKHHR3PzyaQn7gIeh23XiU6qpT4l+J2loragRrtZqiK
         y4g6pwRzSDS4u84OCUTP8o5/XV87aJXBLNsvYZCZNtaFQ5FRBL8V6MQOWR6K7ROX68q7
         6RZl+vdUj6V3bF3hIqvUpXcZ4vkJPzExRunTxAtqCIIiTZamhIaDtcDMoxOCJH/I9+bM
         tMavd6oDI9WV0e1Ia/tMAeGEo+SgvLyXXysk7u9qKRaGyPTgs25mNDYVAFRhfV5CpK3a
         smFRj+xcXDRdJS/fYoQhH8s8hVGVMyc5Abs3TH3Lk3IaE1FL380OuXQget+ccxbwMIi2
         6CMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=bDGFVKN18wriUwk6FxdwjN0VtjasCQxZD6jHLFTJDxY=;
        b=jCrZuaPG8xJFGuheDndBcNOV2syQWhbl5hrK/snW4O+WmSg7efEPVT9EHC+zC54ZDk
         xHxbjt3ISlCQOAlwKifQS2rXbLibmaegx2XxmVkFMnXo1NvPEB+9i9utEMtOM5IOsjbP
         Cnq8hvnqRUxBNC1RM74pGDbXsiLEtSXbuE0XEQyRmpCZyQWie7dzpi9IvwdUUMPOoHWf
         ZpRZEqP8LC2d77n2qp/yX4iwu8xuePs9++hnz4+fg/fS4x9Crdap7FZLb7TNtXLYwV2M
         ui/rzaeFcoSWxXJ6Ap6BfaycNY7B9FEsqY23Slvpi+xsMco+T+VrRKcMweoqhH0fNh6h
         8aGw==
X-Gm-Message-State: APjAAAXDu2nhc8h6YsDKlf6mFMUhLdiD3bznxij5wxTika1ALP/5AbLn
        fWBzjUVvVgP2t9Os0Uy6u6s/qQ==
X-Google-Smtp-Source: APXvYqyzCfr1681XYI4w9T9PUf17nF28+zeWQHmhu5NOdIsO6QneRR5DF/uj3hpkt7xDETLsWfgxqw==
X-Received: by 2002:a0c:fa85:: with SMTP id o5mr11237683qvn.183.1570144887907;
        Thu, 03 Oct 2019 16:21:27 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b50sm2593626qte.48.2019.10.03.16.21.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2019 16:21:27 -0700 (PDT)
Date:   Thu, 3 Oct 2019 16:21:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@mellanox.com,
        dsahern@gmail.com, tariqt@mellanox.com, saeedm@mellanox.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, shuah@kernel.org,
        mlxsw@mellanox.com
Subject: Re: [patch net-next v3 12/15] netdevsim: register port netdevices
 into net of device
Message-ID: <20191003162121.0bfd2576@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191003094940.9797-13-jiri@resnulli.us>
References: <20191003094940.9797-1-jiri@resnulli.us>
        <20191003094940.9797-13-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Oct 2019 11:49:37 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Register newly created port netdevice into net namespace
> that the parent device belongs to.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>

> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netdev.c
> index 0740940f41b1..2908e0a0d6e1 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -290,6 +290,7 @@ nsim_create(struct nsim_dev *nsim_dev, struct nsim_dev_port *nsim_dev_port)
>  	if (!dev)
>  		return ERR_PTR(-ENOMEM);
>  
> +	dev_net_set(dev, nsim_dev_net(nsim_dev));
>  	ns = netdev_priv(dev);
>  	ns->netdev = dev;
>  	ns->nsim_dev = nsim_dev;
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
> index 702d951fe160..198ca31cec94 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -164,6 +164,11 @@ struct nsim_dev {
>  	struct devlink_region *dummy_region;
>  };
>  
> +static inline struct net *nsim_dev_net(struct nsim_dev *nsim_dev)
> +{
> +	return devlink_net(priv_to_devlink(nsim_dev));
> +}

Slight overkill to have a single-use helper for this? ;)

>  int nsim_dev_init(void);
>  void nsim_dev_exit(void);
>  int nsim_dev_probe(struct nsim_bus_dev *nsim_bus_dev);

