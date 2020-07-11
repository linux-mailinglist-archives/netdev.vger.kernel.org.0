Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C41D421C678
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgGKVlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 17:41:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726779AbgGKVlQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:41:16 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A74DCC08C5DD;
        Sat, 11 Jul 2020 14:41:16 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id q17so3725307pls.9;
        Sat, 11 Jul 2020 14:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K5r0unjDrj7c7bbClLz+p5FRdGiOoHAE8bKO85ozu7w=;
        b=Z1/rOWU2E1B4h77negVEPZBLUNDJJTjAWmNu5f6KTel15gnXAf2ABtaXnQO84m4U50
         /5rKmcblCU3vm/PRr41F/y1AxyiFdvI07SOKQWmyaT6yRC9mZGrdhf2M+qfuY/Mo4R6L
         uoJQnf3zbDxwNkFoadiA2o/Hry/OQ0Cf30rrguzYDUGSjCgIXj/wM/vr9GxIOh7MRjiy
         HyOqquN3Kre3UTJSfKShKA5KCKKugC/HF1OEoFKLpnuqERcZeUZdwTVVCuP79GrVK64C
         x3vWa9VG1lnQFUHt73zjgLaVrD7xfvBvKjd63HngyybnMysHBTiJ1xFbzGwpk2ZhSrn1
         gW4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K5r0unjDrj7c7bbClLz+p5FRdGiOoHAE8bKO85ozu7w=;
        b=Pe+BxoWQZbO+LEbzuPr8PtOjoEmt3RFLzi0V/X0/J+3iwnrO+jOE6Qeex/SDCNdsq4
         kHwsbd2Nto+yGxAaiamkf9RfpcjwzRzMVvbyfmQy2ibxzkq0IJuZim/Tl/j0FR6xSxb1
         MbuchI/E/V/2ecrBKDqDuyDTfTbbStSOaw3tRQICaEazcjAs1Xq1jIdLLGrqZwrk8Abz
         zTvf/I/GySV/wtOB6sofr+oyRJTef5VEihVxMeo/0oGcWuD5lKXk0NogdwpwYlZnbzyL
         Kzfw7hNUHuaZqtbfA92Odz8cob+m40t2xJRyIMsJ9yw2KHu1Ku6VaBD3p7gqImQUeikH
         mHOA==
X-Gm-Message-State: AOAM531M9RcAQWc4p0oMlZPnLHkG8B8hSpjriNmgiCQC0t/QROsXmxW8
        X4Uge8h5rZ68rKu8NOHQh6Q9aCZz
X-Google-Smtp-Source: ABdhPJz5n/2NvZmoqaBVenjvM3d0vzSTcwey4+9RN1zYoZpbRsuiqi3vxadCofEwWzpeMbGtPGkG5Q==
X-Received: by 2002:a17:90a:30ea:: with SMTP id h97mr12387740pjb.32.1594503675581;
        Sat, 11 Jul 2020 14:41:15 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:108c:a2dd:75d1:a903? ([2001:470:67:5b9:108c:a2dd:75d1:a903])
        by smtp.gmail.com with ESMTPSA id j10sm9049343pgh.28.2020.07.11.14.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 14:41:14 -0700 (PDT)
Subject: Re: [net-next PATCH v6 4/6] net: phy: introduce
 phy_find_by_mdio_handle()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200711065600.9448-1-calvin.johnson@oss.nxp.com>
 <20200711065600.9448-5-calvin.johnson@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <931b7557-fefb-52c5-61dd-6ab13f7b5396@gmail.com>
Date:   Sat, 11 Jul 2020 14:41:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711065600.9448-5-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 11:55 PM, Calvin Johnson wrote:
> The PHYs on an mdiobus are probed and registered using mdiobus_register().
> Later, for connecting these PHYs to MAC, the PHYs registered on the
> mdiobus have to be referenced.
> 
> For each MAC node, a property "mdio-handle" is used to reference the
> MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.
> 
> Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
> to given mii_bus fwnode.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> ---
> 
> Changes in v6: None
> Changes in v5:
> - rename phy_find_by_fwnode() to phy_find_by_mdio_handle()
> - add docment for phy_find_by_mdio_handle()
> - error out DT in phy_find_by_mdio_handle()
> - clean up err return
> 
> Changes in v4:
> - release fwnode_mdio after use
> - return ERR_PTR instead of NULL
> 
> Changes in v3:
> - introduce fwnode_mdio_find_bus()
> - renamed and improved phy_find_by_fwnode()
> 
> Changes in v2: None
> 
>  drivers/net/phy/mdio_bus.c   | 25 ++++++++++++++++++++++
>  drivers/net/phy/phy_device.c | 40 ++++++++++++++++++++++++++++++++++++
>  include/linux/phy.h          |  2 ++
>  3 files changed, 67 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 8610f938f81f..d9597c5b55ae 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -435,6 +435,31 @@ struct mii_bus *of_mdio_find_bus(struct device_node *mdio_bus_np)
>  }
>  EXPORT_SYMBOL(of_mdio_find_bus);
>  
> +/**
> + * fwnode_mdio_find_bus - Given an mii_bus fwnode, find the mii_bus.
> + * @mdio_bus_fwnode: fwnode of the mii_bus.
> + *
> + * Returns a reference to the mii_bus, or NULL if none found.  The
> + * embedded struct device will have its reference count incremented,
> + * and this must be put once the bus is finished with.
> + *
> + * Because the association of a fwnode and mii_bus is made via
> + * mdiobus_register(), the mii_bus cannot be found before it is
> + * registered with mdiobus_register().
> + *
> + */
> +struct mii_bus *fwnode_mdio_find_bus(struct fwnode_handle *mdio_bus_fwnode)
> +{
> +	struct device *d;
> +
> +	if (!mdio_bus_fwnode)
> +		return NULL;
> +
> +	d = class_find_device_by_fwnode(&mdio_bus_class, mdio_bus_fwnode);
> +	return d ? to_mii_bus(d) : NULL;
> +}
> +EXPORT_SYMBOL(fwnode_mdio_find_bus);
> +
>  /* Walk the list of subnodes of a mdio bus and look for a node that
>   * matches the mdio device's address with its 'reg' property. If
>   * found, set the of_node pointer for the mdio device. This allows
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 7cda95330aea..00b2ade9714f 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -23,8 +23,10 @@
>  #include <linux/mm.h>
>  #include <linux/module.h>
>  #include <linux/netdevice.h>
> +#include <linux/of.h>
>  #include <linux/phy.h>
>  #include <linux/phy_led_triggers.h>
> +#include <linux/platform_device.h>
>  #include <linux/property.h>
>  #include <linux/sfp.h>
>  #include <linux/skbuff.h>
> @@ -964,6 +966,44 @@ struct phy_device *phy_find_first(struct mii_bus *bus)
>  }
>  EXPORT_SYMBOL(phy_find_first);
>  
> +/**
> + * phy_find_by_mdio_handle - get phy device from mdio-handle and phy-channel
> + * @fwnode: a pointer to a &struct fwnode_handle  to get mdio-handle and
> + * phy-channel
> + *
> + * Find fwnode_mdio using mdio-handle reference. Using fwnode_mdio get the
> + * mdio bus. Property phy-channel provides the phy address on the mdio bus.
> + * Pass mdio bus and phy address to mdiobus_get_phy() and get corresponding
> + * phy_device. This method is used for ACPI and not for DT.
> + *
> + * Returns pointer to the phy device on success, else ERR_PTR.
> + */
> +struct phy_device *phy_find_by_mdio_handle(struct fwnode_handle *fwnode)
> +{
> +	struct fwnode_handle *fwnode_mdio;
> +	struct mii_bus *mdio;
> +	int addr;
> +	int err;
> +
> +	if (is_of_node(fwnode))
> +		return ERR_PTR(-EINVAL);
> +
> +	fwnode_mdio = fwnode_find_reference(fwnode, "mdio-handle", 0);

I would export the positional argument here to phy_find_by_mdio_handle()
but have no strong opinion if this is not done right now and punted to
when another users comes in.

> +	mdio = fwnode_mdio_find_bus(fwnode_mdio);
> +	fwnode_handle_put(fwnode_mdio);
> +	if (!mdio)
> +		return ERR_PTR(-ENODEV);
> +
> +	err = fwnode_property_read_u32(fwnode, "phy-channel", &addr);
> +	if (err)
> +		return ERR_PTR(err);
> +	if (addr < 0 || addr >= PHY_MAX_ADDR)

Can an u32 ever be < 0?
-- 
Florian
