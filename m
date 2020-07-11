Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1C6321C674
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgGKVgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 17:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726948AbgGKVgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 17:36:24 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BECBCC08C5DD;
        Sat, 11 Jul 2020 14:36:24 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id m22so4168952pgv.9;
        Sat, 11 Jul 2020 14:36:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hXr0UmCW3IxsSUYajVlkF8cBg9e3wS7ndcvUWmdqDG8=;
        b=AzH0nFZmhCWX0rrjsWgLMfvQA/IfSEhNRl6ovOACAQuHrcUMDpQjV+pCTzt1RKwcCr
         9VRn+3qoaUrtA8hlQcm5mvdfv5NoIT3DNp9KjgAjdkeStzkw2h6+OkBbOIVfGx8V6c44
         UAeEu2SLL+DqYsF+G9Tb3af3u+vFJnerW6cPJ4h1N8kP0DmlkdYni8bqKY3rieI5+K7T
         9xTJXNF0RgJsMX6DG2kKPO8F1tBOLliNIsYjtsCKiW0ZtLQRwWLkTo0+/fpY0Y8oDUpE
         D9sP3YgFGahWMcF+ZbNdwvw1GYF1Vf5xFupcD0BWixY4quSMh0rvACplf7DJgtKdYaaJ
         8ieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hXr0UmCW3IxsSUYajVlkF8cBg9e3wS7ndcvUWmdqDG8=;
        b=l1ijl5xZDgk0pN3SJwwCvgw2rgZxf73cwfXIhYwwUBN89/JdwJs3dDZsg/ujCzB0m0
         D2EJvt7WMEouX09XpcOAlRP+6bUz4Llqx9BuI5CoUdunbB3WeM8o5zH6ToycjRukY3p2
         IGcgrT8Ah7BD/fo1eF2Jjb0fvT3zidxvN8u16GIft3yGQRVIQPct/CTTCCQR3SwQQl/S
         LaFT9mWEiMB6SpVJAJhtZEs4jVq6Uo1JKtTdIcCG9Sl2ckuiX5zj9pso7f/e5Rk5l4Si
         d9Fh55w4E5y0j/kicXCf1b5YZryLXHUDRosF11NbVczPS6IysXj2ElGfAUdI3/vqvF3p
         BKLQ==
X-Gm-Message-State: AOAM531SzNq6hHNFeuAp2tbdjL+8HYBjN+XXG5iS/B1fVHwJen7lx9Fg
        UygLAaFl0aC3d9k9H/hawd8q+tdw
X-Google-Smtp-Source: ABdhPJxfaT580Ux8aP//K91Pf6fsIqPwk158JNjJG6hWaP1UiQmg9whpBkVHlLG4SIKCPyb/ar3Vdg==
X-Received: by 2002:a62:1ad3:: with SMTP id a202mr6406791pfa.263.1594503383615;
        Sat, 11 Jul 2020 14:36:23 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:108c:a2dd:75d1:a903? ([2001:470:67:5b9:108c:a2dd:75d1:a903])
        by smtp.gmail.com with ESMTPSA id y7sm9748517pjy.54.2020.07.11.14.36.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 14:36:22 -0700 (PDT)
Subject: Re: [net-next PATCH v6 2/6] net: phy: introduce
 device_mdiobus_register()
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
 <20200711065600.9448-3-calvin.johnson@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a35e0437-0340-a676-619a-f3671b1c1f91@gmail.com>
Date:   Sat, 11 Jul 2020 14:36:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200711065600.9448-3-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 11:55 PM, Calvin Johnson wrote:
> Introduce device_mdiobus_register() to register mdiobus
> in cases of either DT or ACPI.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> 
> ---
> 
> Changes in v6:
> - change device_mdiobus_register() parameter position
> - improve documentation
> 
> Changes in v5:
> - add description
> - clean up if else
> 
> Changes in v4: None
> Changes in v3: None
> Changes in v2: None
> 
>  drivers/net/phy/mdio_bus.c | 26 ++++++++++++++++++++++++++
>  include/linux/mdio.h       |  1 +
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 46b33701ad4b..8610f938f81f 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -501,6 +501,32 @@ static int mdiobus_create_device(struct mii_bus *bus,
>  	return ret;
>  }
>  
> +/**
> + * device_mdiobus_register - register mdiobus for either DT or ACPI
> + * @bus: target mii_bus
> + * @dev: given MDIO device
> + *
> + * Description: Given an MDIO device and target mii bus, this function
> + * calls of_mdiobus_register() for DT node and mdiobus_register() in
> + * case of ACPI.
> + *
> + * Returns 0 on success or negative error code on failure.
> + */
> +int device_mdiobus_register(struct device *dev,
> +			    struct mii_bus *bus)
> +{
> +	struct fwnode_handle *fwnode = dev_fwnode(dev);
> +
> +	if (is_of_node(fwnode))
> +		return of_mdiobus_register(bus, to_of_node(fwnode));
> +	if (fwnode) {
> +		bus->dev.fwnode = fwnode;
> +		return mdiobus_register(bus);
> +	}
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL(device_mdiobus_register);
> +
>  /**
>   * __mdiobus_register - bring up all the PHYs on a given bus and attach them to bus
>   * @bus: target mii_bus
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index 898cbf00332a..f454c5435101 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -358,6 +358,7 @@ static inline int mdiobus_c45_read(struct mii_bus *bus, int prtad, int devad,
>  	return mdiobus_read(bus, prtad, mdiobus_c45_addr(devad, regnum));
>  }
>  
> +int device_mdiobus_register(struct device *dev, struct mii_bus *bus);

Humm, this header file does not have any of the mii_bus registration
functions declared, and it typically pertains to mdio_device instances
which are devices *on* the mii_bus. phy.h may be more appropriate here
until we break it up into phy_device proper, mii_bus, etc.

>  int mdiobus_register_device(struct mdio_device *mdiodev);
>  int mdiobus_unregister_device(struct mdio_device *mdiodev);
>  bool mdiobus_is_registered_device(struct mii_bus *bus, int addr);
> 

-- 
Florian
