Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE4E147311
	for <lists+netdev@lfdr.de>; Thu, 23 Jan 2020 22:22:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729463AbgAWVWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 16:22:39 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:37366 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728765AbgAWVWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 16:22:39 -0500
Received: by mail-pl1-f193.google.com with SMTP id c23so1899297plz.4;
        Thu, 23 Jan 2020 13:22:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=S7JFTnabwwazOqTJaWZ3aS67txjPp9J00PbDM7VBM9I=;
        b=bELrEzDpY4ahuBDRCUrgd1GKEv33wrZU837ABQnMm/klG8pshh7sMzTRmeLDPg8LwL
         EzW6cc5KQJtvV8tx7N0G+os5FmAMsty1Obyob1Tffz3irOBjV1CCReHgEt4WeQsXJMiI
         NEErmrVu9WU9DJznV13B+ztsv7q8RU2zZMhMGIpiJefKU/cMqEzbilsknbRsCtmKWepF
         HUzLjS7yyD+Bu87lifNxFptGErkKJPrJtoLWRF242YqoDlAwwhxt+R/2MwKHYu7LCFjs
         JxBqExvnCmEYx3xCL5RlYX18Ow58yvVDO+wt9TF6aNSnxbz53QG9fn4o0gIQetxIZctz
         3E+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=S7JFTnabwwazOqTJaWZ3aS67txjPp9J00PbDM7VBM9I=;
        b=UY9fPTxN1KKAXpVjMq7DsBvhURjQTyXE5I/q6ArpgaGCB2Kg2zw5BxHfGqCCzA/zPZ
         WkCtS+Vkwi0Tk3OHfUQI5GDO1PF/u8KM4Nm9k42WhSsmoeW6R9nOl56As5+FY8CQnqsp
         fSBy/OVMJiJtHb6G80IwTjRygZRlI+KE287MCDSlmkAS8SQcIMu/tRmCv/yRzqEZdnbp
         rATZH1RWWbF73vxolC0hDTlUfsDfag7gg3v+P6x7rMQHOLY3VL41ER9FhIxd0q5RE8IL
         WqW5b7c2L7Ks1eonC/qzxKVKWehk/tjY6dlQzrVXdjLPQnB9vL8II7ExT6ntvNkCsyKk
         yfrw==
X-Gm-Message-State: APjAAAXWpx7YW1zzPXAGXszAQQhkA10G/ID31aEw0WyPYITatqqPkOiG
        MXFYYEjKf1iOnuVFqS53MGI=
X-Google-Smtp-Source: APXvYqw5K73NRcAiJ/3vB4kxubT0FsPyRKrBUqfoBl3mFNMibweK4Ybl1mTdGUmnUbHOcDs4Bwoe7g==
X-Received: by 2002:a17:90b:8ce:: with SMTP id ds14mr6761942pjb.57.1579814558266;
        Thu, 23 Jan 2020 13:22:38 -0800 (PST)
Received: from [10.67.50.115] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u18sm4171559pgn.9.2020.01.23.13.22.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jan 2020 13:22:37 -0800 (PST)
Subject: Re: [RFC 1/2] net: bcmgenet: Initial bcmgenet ACPI support
To:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net
References: <20200123060823.1902366-1-jeremy.linton@arm.com>
 <20200123060823.1902366-2-jeremy.linton@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <27337e71-1349-4819-7fe4-c6ecfed522cc@gmail.com>
Date:   Thu, 23 Jan 2020 13:22:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200123060823.1902366-2-jeremy.linton@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/22/20 10:08 PM, Jeremy Linton wrote:
> The rpi4 is capable of booting in ACPI mode with the latest
> edk2-platform commits. As such, it would be helpful if the genet
> platform device were usable.
> 
> To achive this we convert some of the of_ calls to device_ and
> add the ACPI id module table, and tweak the phy connection code
> to use phy_connect() in the ACPI path.

This seems reasonable to me at first glance, although I would be
splitting the bcmgenet.c changes from the bcmmii.c for clarity.

There are some more specific comments below.

> 
> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> ---
>  .../net/ethernet/broadcom/genet/bcmgenet.c    | 19 +++--
>  drivers/net/ethernet/broadcom/genet/bcmmii.c  | 76 ++++++++++++-------
>  2 files changed, 63 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> index 120fa05a39ff..c736700f829e 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
> @@ -7,6 +7,7 @@
>  
>  #define pr_fmt(fmt)				"bcmgenet: " fmt
>  
> +#include <linux/acpi.h>
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/sched.h>
> @@ -3476,7 +3477,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	const struct bcmgenet_plat_data *pdata;
>  	struct bcmgenet_priv *priv;
>  	struct net_device *dev;
> -	const void *macaddr;
> +	const void *macaddr = NULL;
>  	unsigned int i;
>  	int err = -EIO;
>  	const char *phy_mode_str;
> @@ -3510,7 +3511,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  
>  	if (dn)
>  		macaddr = of_get_mac_address(dn);
> -	else
> +	else if (pd)
>  		macaddr = pd->mac_address;
>  
>  	priv->base = devm_platform_ioremap_resource(pdev, 0);
> @@ -3555,8 +3556,9 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  
>  	priv->dev = dev;
>  	priv->pdev = pdev;
> -	if (of_id) {
> -		pdata = of_id->data;
> +
> +	pdata = device_get_match_data(&pdev->dev);
> +	if (pdata) {
>  		priv->version = pdata->version;
>  		priv->dma_max_burst_length = pdata->dma_max_burst_length;
>  	} else {
> @@ -3595,7 +3597,7 @@ static int bcmgenet_probe(struct platform_device *pdev)
>  	/* If this is an internal GPHY, power it on now, before UniMAC is
>  	 * brought out of reset as absolutely no UniMAC activity is allowed
>  	 */
> -	if (dn && !of_property_read_string(dn, "phy-mode", &phy_mode_str) &&
> +	if (!device_property_read_string(&pdev->dev, "phy-mode", &phy_mode_str) &&
>  	    !strcasecmp(phy_mode_str, "internal"))
>  		bcmgenet_power_up(priv, GENET_POWER_PASSIVE);
>  
> @@ -3768,6 +3770,12 @@ static int bcmgenet_suspend(struct device *d)
>  
>  static SIMPLE_DEV_PM_OPS(bcmgenet_pm_ops, bcmgenet_suspend, bcmgenet_resume);
>  
> +static const struct acpi_device_id genet_acpi_match[] = {
> +	{ "BCM6E4E", (kernel_ulong_t)&bcm2711_plat_data },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(acpi, genet_acpi_match);
> +
>  static struct platform_driver bcmgenet_driver = {
>  	.probe	= bcmgenet_probe,
>  	.remove	= bcmgenet_remove,
> @@ -3776,6 +3784,7 @@ static struct platform_driver bcmgenet_driver = {
>  		.name	= "bcmgenet",
>  		.of_match_table = bcmgenet_match,
>  		.pm	= &bcmgenet_pm_ops,
> +		.acpi_match_table = ACPI_PTR(genet_acpi_match),
>  	},
>  };
>  module_platform_driver(bcmgenet_driver);
> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> index 6392a2530183..054be1eaa1ae 100644
> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
> @@ -5,7 +5,7 @@
>   * Copyright (c) 2014-2017 Broadcom
>   */
>  
> -
> +#include <linux/acpi.h>
>  #include <linux/types.h>
>  #include <linux/delay.h>
>  #include <linux/wait.h>
> @@ -308,10 +308,21 @@ int bcmgenet_mii_config(struct net_device *dev, bool init)
>  	return 0;
>  }
>  
> +static void bcmgenet_phy_name(char *phy_name, int mdid, int phid)
> +{
> +	char mdio_bus_id[MII_BUS_ID_SIZE];
> +
> +	snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
> +		 UNIMAC_MDIO_DRV_NAME, mdid);
> +	snprintf(phy_name, MII_BUS_ID_SIZE, PHY_ID_FMT, mdio_bus_id, phid);
> +}
> +
>  int bcmgenet_mii_probe(struct net_device *dev)
>  {
>  	struct bcmgenet_priv *priv = netdev_priv(dev);
> -	struct device_node *dn = priv->pdev->dev.of_node;
> +	struct device *kdev = &priv->pdev->dev;
> +	struct device_node *dn = kdev->of_node;
> +
>  	struct phy_device *phydev;
>  	u32 phy_flags = 0;
>  	int ret;
> @@ -333,6 +344,16 @@ int bcmgenet_mii_probe(struct net_device *dev)
>  			pr_err("could not attach to PHY\n");
>  			return -ENODEV;
>  		}
> +	} else if (has_acpi_companion(kdev)) {
> +		char phy_name[MII_BUS_ID_SIZE + 3];
> +
> +		bcmgenet_phy_name(phy_name,  priv->pdev->id, 1);

There is no guarantee that 1 is valid other than for the current
Raspberry Pi 4 design that we have in the wild, would ACPI be used in
the future with other designs, this would likely be different. Can you
find a way to communicate that address via appropriate firmware properties?

> +		phydev = phy_connect(dev, phy_name, bcmgenet_mii_setup,
> +				     priv->phy_interface);
> +		if (!IS_ERR(phydev))
> +			phydev->dev_flags = phy_flags;
> +		else
> +			return -ENODEV;
>  	} else {
>  		phydev = dev->phydev;
>  		phydev->dev_flags = phy_flags;
> @@ -435,6 +456,7 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
>  	ppd.wait_func = bcmgenet_mii_wait;
>  	ppd.wait_func_data = priv;
>  	ppd.bus_name = "bcmgenet MII bus";
> +	ppd.phy_mask = ~0;

This is going to be breaking PHY scanning for the platform_data case, so
maybe something like:

	if (acpi_has_companion())
		ppd.phy_mask = ~BIT(acpi_phy_id);

or something like that?

>  
>  	/* Unimac MDIO bus controller starts at UniMAC offset + MDIO_CMD
>  	 * and is 2 * 32-bits word long, 8 bytes total.
> @@ -477,12 +499,28 @@ static int bcmgenet_mii_register(struct bcmgenet_priv *priv)
>  	return ret;
>  }
>  
> +static int bcmgenet_mii_phy_init(struct bcmgenet_priv *priv)
> +{

Maybe name that phy_interface_init(), there is not strictly much PHY
initialization going on here, just property fetching and internal book
keeping.
-- 
Florian
