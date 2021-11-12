Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61EA344EFF7
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 00:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhKLXTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 18:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhKLXTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 18:19:31 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCF64C061766;
        Fri, 12 Nov 2021 15:16:40 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id m15so5356142pgu.11;
        Fri, 12 Nov 2021 15:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=o42iCIyKTE0wGh5uE7Fre4OwYvIXk4RRf46useFLA9U=;
        b=i+Zu61kHw0GzD5zlA0Rn+AEonWgE4Eazdxfyqr+06xsm4IabPpSTYEN57zfxRxGytl
         /NbYL9itVlFqF8g4n132z86u6uhvpaj2vmSvu/DAW8W97ThepowrPS1AHkgdSQmoRNIe
         zK/jyjIG3wpe2zGpKJbodcUoXgLoABEMH36ixS4LD8MbR0JVW8X6nDH3A0xoPZVLfsLD
         0hz7IhzGgGFpDh/Vvg1EJbKBBP5T8HEBFSeKmR329kXEjynGq4+3ArPBBr2erOF24ImP
         I9/GGbg6imZ1ph4vAHQhxfRUc5rGFuT+uVlejJVqqJoZLjv3lT+pQZN9aQpWKTVFDhCQ
         uudg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o42iCIyKTE0wGh5uE7Fre4OwYvIXk4RRf46useFLA9U=;
        b=Kj4VIBMdoNBJ2czY+dWNAAWftbjjjoLOy7kOO+zCK3WoRv9U1m7yvzOXFglY0pIwQ9
         zgCM+q+uX2A9YZ/6Yfk3oSiqBMY7pxmiqAaVzr09k48PPjUwv79/b/p3PKxUUtwKUVz5
         BV4JHPkMIldC0feacdBz9mQGjtt9pzgyEgwBYSARm1qvnJuC6Pl7FHUD3+zqKoFirbrW
         3s9FJvXj5TcB+lUrsv3ThuWkbpk0/FuKnZoV3SStTtWte4sciz6HyFm5z1ABSiFoAmcL
         Q3bA041tcELZsvvwamJgUxD0pCWfJEpRp/pZUAXZFzcNupDH/fF+Z/cl8yU9vzkzyywh
         cdwg==
X-Gm-Message-State: AOAM5305t91FLLzYSsJD00BUSqPBdKh4xV+3QEq88Ab5NR39zbzEAF/n
        FPecmNCMO4bdzTxnU+pOUWo=
X-Google-Smtp-Source: ABdhPJyHwcW30qnndB+fgKgbwVE1y/aaXFVVoZGpiPodrAVNNsjXWjxVPqUiul7ArgHmxeaDZxtN6g==
X-Received: by 2002:a05:6a00:cc8:b0:49f:c4a9:b9f1 with SMTP id b8-20020a056a000cc800b0049fc4a9b9f1mr17156385pfv.32.1636759000167;
        Fri, 12 Nov 2021 15:16:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d2sm7897172pfj.42.2021.11.12.15.16.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Nov 2021 15:16:39 -0800 (PST)
Subject: Re: [PATCH v2 2/2] net: ethernet: Add driver for Sunplus SP7021
To:     Wells Lu <wellslutw@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        p.zabel@pengutronix.de
Cc:     vincent.shih@sunplus.com, Wells Lu <wells.lu@sunplus.com>
References: <cover.1635936610.git.wells.lu@sunplus.com>
 <cover.1636620754.git.wells.lu@sunplus.com>
 <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a8c656b8-a564-6aa6-7ca4-50e7a0bd65a1@gmail.com>
Date:   Fri, 12 Nov 2021 15:16:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <519b61af544f4c6920012d44afd35a0f8761b24f.1636620754.git.wells.lu@sunplus.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/11/21 1:04 AM, Wells Lu wrote:
> Add driver for Sunplus SP7021.
> 
> Signed-off-by: Wells Lu <wells.lu@sunplus.com>
> ---

[snip]

> +u32 mdio_read(struct sp_mac *mac, u32 phy_id, u16 regnum)
> +{
> +	int ret;
> +
> +	ret = hal_mdio_access(mac, MDIO_READ_CMD, phy_id, regnum, 0);
> +	if (ret < 0)
> +		return -EOPNOTSUPP;
> +
> +	return ret;
> +}
> +
> +u32 mdio_write(struct sp_mac *mac, u32 phy_id, u32 regnum, u16 val)
> +{
> +	int ret;
> +
> +	ret = hal_mdio_access(mac, MDIO_WRITE_CMD, phy_id, regnum, val);
> +	if (ret < 0)
> +		return -EOPNOTSUPP;
> +
> +	return 0;
> +}

You should not be exposing these functions, if you do, that means
another part of your code performs MDIO bus read/write operations
without using the appropriate layer, so no.

> +
> +static int mii_read(struct mii_bus *bus, int phy_id, int regnum)
> +{
> +	struct sp_mac *mac = bus->priv;
> +
> +	return mdio_read(mac, phy_id, regnum);
> +}
> +
> +static int mii_write(struct mii_bus *bus, int phy_id, int regnum, u16 val)
> +{
> +	struct sp_mac *mac = bus->priv;
> +
> +	return mdio_write(mac, phy_id, regnum, val);
> +}
> +
> +u32 mdio_init(struct platform_device *pdev, struct net_device *ndev)

Those function names need to be prefixed with sp_ to denote the driver
local scope, this applies for your entire patch set.

[snip]

> diff --git a/drivers/net/ethernet/sunplus/sp_mdio.h b/drivers/net/ethernet/sunplus/sp_mdio.h
> new file mode 100644
> index 0000000..d708624
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/sp_mdio.h
> @@ -0,0 +1,20 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#ifndef __SP_MDIO_H__
> +#define __SP_MDIO_H__
> +
> +#include "sp_define.h"
> +#include "sp_hal.h"
> +
> +#define MDIO_READ_CMD           0x02
> +#define MDIO_WRITE_CMD          0x01
> +
> +u32  mdio_read(struct sp_mac *mac, u32 phy_id, u16 regnum);
> +u32  mdio_write(struct sp_mac *mac, u32 phy_id, u32 regnum, u16 val);

Please scope your functions better, and name them sp_mdio_read, etc.
because mdio_read() is way too generic. Also, can you please follow the
same prototype as what include/linux/mdio.h has for the mdiobus->read
and ->write calls, that is phy_id is int, regnum is u32, etc.

> +u32  mdio_init(struct platform_device *pdev, struct net_device *ndev);
> +void mdio_remove(struct net_device *ndev);
> +
> +#endif
> diff --git a/drivers/net/ethernet/sunplus/sp_phy.c b/drivers/net/ethernet/sunplus/sp_phy.c
> new file mode 100644
> index 0000000..df6df3a
> --- /dev/null
> +++ b/drivers/net/ethernet/sunplus/sp_phy.c
> @@ -0,0 +1,64 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Copyright Sunplus Technology Co., Ltd.
> + *       All rights reserved.
> + */
> +
> +#include "sp_phy.h"
> +#include "sp_mdio.h"
> +
> +static void mii_linkchange(struct net_device *netdev)
> +{
> +}

Does your MAC fully auto-configure based on the PHY's link parameters,
if so, how does it do it? You most certainly need to act on duplex
changes, or speed changes no?

> +
> +int sp_phy_probe(struct net_device *ndev)
> +{
> +	struct sp_mac *mac = netdev_priv(ndev);
> +	struct phy_device *phydev;
> +	int i;
> +
> +	phydev = of_phy_connect(ndev, mac->phy_node, mii_linkchange,
> +				0, mac->phy_mode);
> +	if (!phydev) {
> +		netdev_err(ndev, "\"%s\" failed to connect to phy!\n", ndev->name);
> +		return -ENODEV;
> +	}
> +
> +	for (i = 0; i < sizeof(phydev->supported) / sizeof(long); i++)
> +		phydev->advertising[i] = phydev->supported[i];
> +
> +	phydev->irq = PHY_MAC_INTERRUPT;
> +	mac->phy_dev = phydev;
> +
> +	// Bug workaround:
> +	// Flow-control of phy should be enabled. MAC flow-control will refer
> +	// to the bit to decide to enable or disable flow-control.
> +	mdio_write(mac, mac->phy_addr, 4, mdio_read(mac, mac->phy_addr, 4) | (1 << 10));

This is a layering violation, and you should not be doing those things
here, if you need to advertise flow control, then please set
ADVERTISE_PAUSE_CAP and/or ADVERTISE_PAUSE_ASYM accordingly, see whether
phy_set_asym_pause() can do what you need it to.

> +
> +	return 0;
> +}
> +
> +void sp_phy_start(struct net_device *ndev)
> +{
> +	struct sp_mac *mac = netdev_priv(ndev);
> +
> +	if (mac->phy_dev)
> +		phy_start(mac->phy_dev);
> +}
> +
> +void sp_phy_stop(struct net_device *ndev)
> +{
> +	struct sp_mac *mac = netdev_priv(ndev);
> +
> +	if (mac->phy_dev)
> +		phy_stop(mac->phy_dev);
> +}
> +
> +void sp_phy_remove(struct net_device *ndev)
> +{
> +	struct sp_mac *mac = netdev_priv(ndev);
> +
> +	if (mac->phy_dev) {
> +		phy_disconnect(mac->phy_dev);
> +		mac->phy_dev = NULL;
> +	}

The net_device structure already contains a phy_device pointer, you
don't need to have one in your sp_mac structure, too.
-- 
Florian
