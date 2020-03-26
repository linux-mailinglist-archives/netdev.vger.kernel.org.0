Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF4091945A6
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 18:39:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgCZRjO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 13:39:14 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33890 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727541AbgCZRjN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 13:39:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id 26so7986761wmk.1;
        Thu, 26 Mar 2020 10:39:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HpNuF66K0DwGIA2W7BsAFtvMAN5a4ZcafM59XWZDNzw=;
        b=kqojkeDOTK2W9h5Sy+09ys68xx80S80Uf/X1IBo3l4i4cH5F4emJ3JeXQtt2Eoq73B
         WflWJocUIKpX3GAmYD5CxWKnvYr/M3py8QFdHD17ud6saxlThWWEjR6jAg85Spk39ks2
         4JsXQKtvqsp/JTKtbYNVd4IRE4AL4S6A0ETd/Q/3sZAsLgXXdcgFlUq98c3NV52LKRkD
         hKDKuP2ro+wD4DmVT1BxbAGE4WrugBwyxjvIy7He9vKCats9jM0OB/kuS+fI8vT0/fkQ
         rdkLLJiI5t9h89/2GGXQ2e5/g35NPpcSUsjXcQLgr1oyIuPjWHTPtBXXL6kfVZiI+GyB
         M0YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HpNuF66K0DwGIA2W7BsAFtvMAN5a4ZcafM59XWZDNzw=;
        b=eZHBW7oejwa0yx6OEqRRcZRB3omKyS8V+EMu7mbmoG/KYk9ZalKsBiqovnwgBoLgS4
         ZZ22ucnYr4k1t3CE0eMoEEVBlU4VpXISVGh/1B5nN/BkUAK+AhiwlJG0T2IqOyeOOt1r
         DURQLI3sICCqEutvbmlul5vtW0Dp9bP50jb2gEBQBtsVrJxmiiULI5seSUb3MNuUkAXh
         jMSy2GUNy/70GWV7SzshF1p3bXM5H6akqBHlbyuYvyvM4MxL/OdKNDNsjS/W2ltUKI8e
         JoqsXkyMYeXYbkO0TziLFcyxmAhqWd46UHdadBdLU9HGisKI+z1lJfgrImCSGl1EAk4k
         uJbg==
X-Gm-Message-State: ANhLgQ15Bl/aKCf4W1/IC5UkzkzanGv3CQZvjSkMdAUSWsf9EIWrztt/
        Bdx0Uxa/lSTi3NZmsY9LnZ8=
X-Google-Smtp-Source: ADFU+vufbLUwN19BQJGQ//UtXe37wcvKBLYq5YbRQfK92fMa0Gl9hLO0BL4sWPG/AcG/ZXgaQjLTSQ==
X-Received: by 2002:a05:600c:54f:: with SMTP id k15mr1038530wmc.76.1585244351188;
        Thu, 26 Mar 2020 10:39:11 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:d031:3b7b:1a72:8f94? (p200300EA8F296000D0313B7B1A728F94.dip0.t-ipconnect.de. [2003:ea:8f29:6000:d031:3b7b:1a72:8f94])
        by smtp.googlemail.com with ESMTPSA id b11sm4497416wrq.26.2020.03.26.10.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Mar 2020 10:39:10 -0700 (PDT)
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH] net: core: provide devm_register_netdev()
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200326131721.6404-1-brgl@bgdev.pl>
Message-ID: <c71a132d-dc33-0b8a-29e0-9cf93056ef52@gmail.com>
Date:   Thu, 26 Mar 2020 18:39:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200326131721.6404-1-brgl@bgdev.pl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.03.2020 14:17, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> 
> Create a new source file for networking devres helpers and provide
> devm_register_netdev() - a managed variant of register_netdev().
> 
> Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> ---
> I'm writing a new ethernet driver and I realized there's no devres
> variant for register_netdev(). Since this is the only function I need
> to get rid of the remove() callback, I thought I'll just go ahead and
> add it and send it even before the driver to make it available to other
> drivers.
> 

Such a new functionality typically is accepted as part of series adding
at least one user only. Therefore best submit it together with the new
network driver.

>  .../driver-api/driver-model/devres.rst        |  3 ++
>  include/linux/netdevice.h                     |  1 +
>  net/core/Makefile                             |  2 +-
>  net/core/devres.c                             | 41 +++++++++++++++++++
>  4 files changed, 46 insertions(+), 1 deletion(-)
>  create mode 100644 net/core/devres.c
> 
> diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
> index 46c13780994c..11a03b65196e 100644
> --- a/Documentation/driver-api/driver-model/devres.rst
> +++ b/Documentation/driver-api/driver-model/devres.rst
> @@ -372,6 +372,9 @@ MUX
>    devm_mux_chip_register()
>    devm_mux_control_get()
>  
> +NET
> +  devm_register_netdev()
> +
>  PER-CPU MEM
>    devm_alloc_percpu()
>    devm_free_percpu()
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 6c3f7032e8d9..710a7bcfc3dc 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -4196,6 +4196,7 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>  			 count)
>  
>  int register_netdev(struct net_device *dev);
> +int devm_register_netdev(struct device *dev, struct net_device *ndev);
>  void unregister_netdev(struct net_device *dev);
>  
>  /* General hardware address lists handling functions */
> diff --git a/net/core/Makefile b/net/core/Makefile
> index 3e2c378e5f31..f530894068d2 100644
> --- a/net/core/Makefile
> +++ b/net/core/Makefile
> @@ -8,7 +8,7 @@ obj-y := sock.o request_sock.o skbuff.o datagram.o stream.o scm.o \
>  
>  obj-$(CONFIG_SYSCTL) += sysctl_net_core.o
>  
> -obj-y		     += dev.o dev_addr_lists.o dst.o netevent.o \
> +obj-y		     += dev.o devres.o dev_addr_lists.o dst.o netevent.o \
>  			neighbour.o rtnetlink.o utils.o link_watch.o filter.o \
>  			sock_diag.o dev_ioctl.o tso.o sock_reuseport.o \
>  			fib_notifier.o xdp.o flow_offload.o
> diff --git a/net/core/devres.c b/net/core/devres.c
> new file mode 100644
> index 000000000000..3c080abd1935
> --- /dev/null
> +++ b/net/core/devres.c

Why a new source file and not just add the function to net/core/dev.c?


> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0-only
> +/*
> + * Copyright (C) 2020 BayLibre SAS
> + * Author: Bartosz Golaszewski <bgolaszewski@baylibre.com>
> + */
> +
> +#include <linux/device.h>
> +#include <linux/netdevice.h>
> +
> +struct netdevice_devres {
> +	struct net_device *ndev;
> +};
> +

Adding such a struct isn't strictly needed.

> +static void devm_netdev_release(struct device *dev, void *res)
> +{
> +	struct netdevice_devres *this = res;
> +
> +	unregister_netdev(this->ndev);
> +}
> +
> +int devm_register_netdev(struct device *dev, struct net_device *ndev)
> +{

In this function you'd need to consider the dependency on a previous
call to devm_alloc_etherdev(). If the netdevice is allocated non-managed,
then free_netdev() would be called whilst the netdevice is still
registered, what would trigger a BUG_ON(). Therefore devm_register_netdev()
should return an error if the netdevice was allocated non-managed.
The mentioned scenario would result from a severe programming error
of course, but there are less experienced driver authors and the net core
should deal gently with wrong API usage.

An example how this could be done you can find in the PCI subsystem,
see pcim_release() and related functions like pcim_enable() and
pcim_set_mwi().

> +	struct netdevice_devres *devres;
> +	int ret;
> +
> +	devres = devres_alloc(devm_netdev_release, sizeof(*devres), GFP_KERNEL);
> +	if (!devres)
> +		return -ENOMEM;
> +
> +	ret = register_netdev(ndev);
> +	if (ret) {
> +		devres_free(devres);
> +		return ret;
> +	}
> +
> +	devres->ndev = ndev;
> +	devres_add(dev, devres);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL(devm_register_netdev);
> 

