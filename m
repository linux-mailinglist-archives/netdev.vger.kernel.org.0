Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49112A75FD
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 04:13:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388556AbgKEDNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 22:13:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730888AbgKEDNr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 22:13:47 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20A07C0613CF;
        Wed,  4 Nov 2020 19:13:46 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id z24so284318pgk.3;
        Wed, 04 Nov 2020 19:13:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7ZW/P8m/wP7Uq6FxGtIgAnrwS9HoTp1U2UA8xNrpeMU=;
        b=qSCIofcCq5WwkXfT/ybpYb8vJOnPqU8q1XIe2O5ujGVskta3/MYQVo8M77n4MNGe27
         uK6XeyQYaGOg1BMZJ2Fk1/XpfsFJMJ02mI9Vq1LkPYbLJDs0BhEcM/lB54+xR8+SOhJS
         BcgFHLU8fzExvfks6LJGwJt86nn/SxEsg1WswqkNnSXVyOM9rznppYMNw0f1W3W+lsem
         nPc+nwgO36MRwroD7aPQ74qqP8KqkleaPvgFlUji/yd0CTL1TrtCyTuQulIfCXawguKF
         MqqF9T/VhbcqwWAc+1aMvYAtQRMwkBL9MtXdXlf3YwHjcTWscxXS2eNnpQ+1uHUc6ffX
         UyXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7ZW/P8m/wP7Uq6FxGtIgAnrwS9HoTp1U2UA8xNrpeMU=;
        b=pMDDd6eqvy5h7DSEkQUgv3ZQtI7NQ1pWFUArbLngigEXkykhAumPyW4e9AnC9vCUZc
         e4K7CYpq3nHKJFFbVBgppQ5OaJmYQowia5inb1x2NzDVLAY7viXPTx5zbbzb11d6PTel
         A+mH9uUYTUXG1N5f51ML2XwClnRS1zeM3Nm+kfCiO9mE32F9ItdOIpD8X8zGXMWQKz4H
         l4Vhr4XQXU0eXr5fNW71RTVWZ6xHiXgpWAO4yFtoBuvOwIbcFh+56N0q4ea1DWRcnlxb
         FMjNzfPtvpdwq3fjXQqj5zIGPz+ibHS6NdvvkzBqjlLRh7RFNZlTpFeF2ryN/s+rDm6L
         /4fA==
X-Gm-Message-State: AOAM530SkiA8Kus53wqV5wWZ/5oNY1CaB347mVt2jFR9lMlyfpJwFMc7
        WvARlKG31of+gkmBBsuGrDr6YRjQZkNn3tbPrJk=
X-Google-Smtp-Source: ABdhPJyazpFcx7YIHd6w7bQyqP4NCdpcBn45WCXeadNspdIsXCewqr56fOv4ynTvXTuCdJIVo4n5Xg==
X-Received: by 2002:a17:90b:ec9:: with SMTP id gz9mr284993pjb.105.1604546025413;
        Wed, 04 Nov 2020 19:13:45 -0800 (PST)
Received: from [192.168.0.104] ([49.207.201.182])
        by smtp.gmail.com with ESMTPSA id s6sm315164pfh.9.2020.11.04.19.13.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 19:13:44 -0800 (PST)
Subject: Re: [PATCH v3 net-next 07/21] net: usb: aqc111: Add support for
 getting and setting of MAC address
To:     Igor Russkikh <Igor.Russkikh@aquantia.com>
Cc:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>
References: <cover.1542794577.git.igor.russkikh@aquantia.com>
 <8f92711d8479a3df65849e60fd92c727e1e1f78a.1542794577.git.igor.russkikh@aquantia.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <7a866553-1333-4952-5fe6-45336235ebb2@gmail.com>
Date:   Thu, 5 Nov 2020 08:43:40 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8f92711d8479a3df65849e60fd92c727e1e1f78a.1542794577.git.igor.russkikh@aquantia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I only recently browsed through the code, and had some queries regarding
the changes introduced by this commit.

On 21/11/18 3:43 pm, Igor Russkikh wrote:
> From: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
>
> Signed-off-by: Dmitry Bezrukov <dmitry.bezrukov@aquantia.com>
> Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
> ---
>  drivers/net/usb/aqc111.c | 47 ++++++++++++++++++++++++++++++++++++++++
>  drivers/net/usb/aqc111.h |  1 +
>  2 files changed, 48 insertions(+)
>
> diff --git a/drivers/net/usb/aqc111.c b/drivers/net/usb/aqc111.c
> index e33be16b506c..390ed6cbc3fd 100644
> --- a/drivers/net/usb/aqc111.c
> +++ b/drivers/net/usb/aqc111.c
> @@ -11,6 +11,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/mii.h>
>  #include <linux/usb.h>
> +#include <linux/if_vlan.h>
>  #include <linux/usb/cdc.h>
>  #include <linux/usb/usbnet.h>
>  
> @@ -204,11 +205,43 @@ static void aqc111_set_phy_speed(struct usbnet *dev, u8 autoneg, u16 speed)
>  	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0, &aqc111_data->phy_cfg);
>  }
>  
> +static int aqc111_set_mac_addr(struct net_device *net, void *p)
> +{
> +	struct usbnet *dev = netdev_priv(net);
> +	int ret = 0;
> +
> +	ret = eth_mac_addr(net, p);
> +	if (ret < 0)
> +		return ret;
> +

When eth_mac_addr() fails, from what I can see, it returns either -EBUSY, or
-EADDRNOTAVAIL.
Wouldn't it be a better idea to set a random MAC address instead, when
-EADDRNOTAVAIL is returned, so that the interface still comes up and is
usable?

I'm only asking because this feels similar to the discussion that can be found here.
    https://lkml.org/lkml/2020/10/2/305

> +	/* Set the MAC address */
> +	return aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_NODE_ID, ETH_ALEN,
> +				ETH_ALEN, net->dev_addr);
> +}
> +
>  static const struct net_device_ops aqc111_netdev_ops = {
>  	.ndo_open		= usbnet_open,
>  	.ndo_stop		= usbnet_stop,
> +	.ndo_set_mac_address	= aqc111_set_mac_addr,
> +	.ndo_validate_addr	= eth_validate_addr,
>  };
>  
> +static int aqc111_read_perm_mac(struct usbnet *dev)
> +{
> +	u8 buf[ETH_ALEN];
> +	int ret;
> +
> +	ret = aqc111_read_cmd(dev, AQ_FLASH_PARAMETERS, 0, 0, ETH_ALEN, buf);
> +	if (ret < 0)
> +		goto out;
> +
> +	ether_addr_copy(dev->net->perm_addr, buf);
> +
> +	return 0;
> +out:
> +	return ret;
> +}
> +
>  static void aqc111_read_fw_version(struct usbnet *dev,
>  				   struct aqc111_data *aqc111_data)
>  {
> @@ -251,6 +284,12 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
>  	/* store aqc111_data pointer in device data field */
>  	dev->driver_priv = aqc111_data;
>  
> +	/* Init the MAC address */
> +	ret = aqc111_read_perm_mac(dev);
> +	if (ret)
> +		goto out;
> +
> +	ether_addr_copy(dev->net->dev_addr, dev->net->perm_addr);
>  	dev->net->netdev_ops = &aqc111_netdev_ops;
>  
>  	aqc111_read_fw_version(dev, aqc111_data);
> @@ -259,6 +298,10 @@ static int aqc111_bind(struct usbnet *dev, struct usb_interface *intf)
>  					 SPEED_5000 : SPEED_1000;
>  
>  	return 0;
> +
> +out:
> +	kfree(aqc111_data);
> +	return ret;
>  }
>  
>  static void aqc111_unbind(struct usbnet *dev, struct usb_interface *intf)
> @@ -467,6 +510,10 @@ static int aqc111_reset(struct usbnet *dev)
>  	aqc111_write32_cmd(dev, AQ_PHY_OPS, 0, 0,
>  			   &aqc111_data->phy_cfg);
>  
> +	/* Set the MAC address */
> +	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_NODE_ID, ETH_ALEN,
> +			 ETH_ALEN, dev->net->dev_addr);
> +

There's a chance that aqc111_write_cmd() can end up writing only a
part of the required amount of data too.
Wouldn't it be a better idea to enforce a sanity check here, and set a
random mac address instead if this write fails?

>  	reg8 = 0xFF;
>  	aqc111_write_cmd(dev, AQ_ACCESS_MAC, SFR_BM_INT_MASK, 1, 1, &reg8);
>  
> diff --git a/drivers/net/usb/aqc111.h b/drivers/net/usb/aqc111.h
> index f3b45d8ca4e3..0c8e1ee29893 100644
> --- a/drivers/net/usb/aqc111.h
> +++ b/drivers/net/usb/aqc111.h
> @@ -11,6 +11,7 @@
>  #define __LINUX_USBNET_AQC111_H
>  
>  #define AQ_ACCESS_MAC			0x01
> +#define AQ_FLASH_PARAMETERS		0x20
>  #define AQ_PHY_POWER			0x31
>  #define AQ_PHY_OPS			0x61
>

If any of these changes sound like a good idea, I'd be happy to write a
patch implementing them. :)

Thanks,
Anant

