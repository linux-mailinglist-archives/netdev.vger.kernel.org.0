Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBC571A6B07
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 19:11:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729018AbgDMLeo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 07:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728945AbgDMLen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 07:34:43 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78F65C00860A
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 04:28:17 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id c195so9925627wme.1
        for <netdev@vger.kernel.org>; Mon, 13 Apr 2020 04:28:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UpNux2IPautNg0ZcqA9LRAVi1pFPgjaon5m9UeRJ87w=;
        b=bi1WFinOoQ4Kh55MAtjMOzKGnX/95RzO/cGbNZneHt05sLArZWNahHwIRd4VXINZ7e
         IvEYI4fbBQvNjX4gwHX+y2BZrNfFSAbopCVOz5XHrF1fpMHDLVFAwbvBrmB/sXs0L0h/
         Yu1KR+SmbyaAgM7hwn9bhuOiHiNLFP0V32CtLCEbfGqQYRlS2nXaSXe5vpN+lJH5rv3z
         sspMaixllA2j671Fx2QjHlo6x2f8FjToUmgcWKamiYp8/4VXSJAMdMlminKZITNTw0BE
         negidQkGU2cuog7Jz/mvrrnJredIfYqdaHhawEp9DE5Ba7he1Dv9K0Q70eluEyRS78p4
         5U2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UpNux2IPautNg0ZcqA9LRAVi1pFPgjaon5m9UeRJ87w=;
        b=uH//7859qbV/iCW1RP2VI4yyPnCXdLdBBNOJ3inxJ4m5giNb8I0ja1PNeJkOBiiD2h
         N4cRV7Oilygk6tcWg0CUvQo5SVFRKos0+3JRETgDaEDSgHiCinvzaLKwIM+mmSy9GhTK
         Cs+QVoHhbi3hnkJwvdBdsVQfqlENRO8kOEwQOO7ryT7huZhpl7jgVhIr8YJmLyMr7Y83
         NctKtqb+40vr6kSYsD1urEuxTO4JFT83LKrJAVM9sdHtUOtK4NB8TmxRuKUMjiiawiiR
         HZ0/IHHhDGARO4j/9iBwHU/RCThm1J6v+v8Shjo+6l3VsS9dmHa3Qy4750aaYYjQD9kE
         afNA==
X-Gm-Message-State: AGi0PuaCjfhckI578vyPwl2f9wm4XIU64OXKAX21sgGGNTeP1JvNSU5y
        9jtIG9DdNYoDtyz6ZMKOBB4=
X-Google-Smtp-Source: APiQypLnuXabwbMCoyB7l60T78Fn32uxcUP3oG8zYPaDuiX72reUWZWHS6hoqKp2el2R2s2XJZmP1Q==
X-Received: by 2002:a7b:c20f:: with SMTP id x15mr17558022wmi.2.1586777295954;
        Mon, 13 Apr 2020 04:28:15 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:ecd0:ef61:dfee:4535? (p200300EA8F296000ECD0EF61DFEE4535.dip0.t-ipconnect.de. [2003:ea:8f29:6000:ecd0:ef61:dfee:4535])
        by smtp.googlemail.com with ESMTPSA id c83sm11400684wmd.23.2020.04.13.04.28.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2020 04:28:15 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
To:     Lauri Jakku <lauri.jakku@pp.inet.fi>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <31016d2a-e96a-fa80-efd3-2f5edd65e1c9@pp.inet.fi>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <269404a4-0c17-d11a-4300-57478b7c7c12@gmail.com>
Date:   Mon, 13 Apr 2020 13:28:10 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <31016d2a-e96a-fa80-efd3-2f5edd65e1c9@pp.inet.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2020 13:06, Lauri Jakku wrote:
> Hi,
> 
> Modified as suggested:
> 
>>From f4fba16025260bf08f0df867c3de51803ddb78ef Mon Sep 17 00:00:00 2001
> From: Lauri Jakku <lja@iki.fi>
> Date: Mon, 13 Apr 2020 13:18:35 +0300
> Subject: [PATCH] NET: r8168/r8169 identifying fix
> 
> The driver installation determination made properly by
> checking PHY vs DRIVER id's.
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++---
>  drivers/net/phy/mdio_bus.c                | 11 +++-
>  2 files changed, 72 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index bf5bf05970a2..2384da7d2988 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5149,6 +5149,9 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  {
>  	struct pci_dev *pdev = tp->pci_dev;
>  	struct mii_bus *new_bus;
> +	u32 phydev_id = 0;
> +	u32 phydrv_id = 0;
> +	u32 phydrv_id_mask = 0;
>  	int ret;
>  
>  	new_bus = devm_mdiobus_alloc(&pdev->dev);
> @@ -5165,20 +5168,62 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>  	new_bus->write = r8169_mdio_write_reg;
>  
>  	ret = mdiobus_register(new_bus);
> +	dev_info(&pdev->dev,
> +		 "mdiobus_register: %s, %d\n",
> +		 new_bus->id, ret);
>  	if (ret)
>  		return ret;
>  
>  	tp->phydev = mdiobus_get_phy(new_bus, 0);
> +
>  	if (!tp->phydev) {
>  		mdiobus_unregister(new_bus);
>  		return -ENODEV;
> -	} else if (!tp->phydev->drv) {
> -		/* Most chip versions fail with the genphy driver.
> -		 * Therefore ensure that the dedicated PHY driver is loaded.
> -		 */
> -		dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
> -		mdiobus_unregister(new_bus);
> -		return -EUNATCH;
> +	} else {
> +		/* tp -> phydev ok */
> +		int everything_OK = 0;
> +
> +		/* Check driver id versus phy */
> +
> +		if (tp->phydev->drv) {
> +			u32 phydev_masked = 0xBEEFDEAD;
> +			u32 drv_masked = ~0;
> +			u32 phydev_match = ~0;
> +			u32 drv_match = 0xDEADBEEF;
> +
> +			phydev_id = tp->phydev->phy_id;
> +			phydrv_id = tp->phydev->drv->phy_id;
> +			phydrv_id_mask = tp->phydev->drv->phy_id_mask;
> +
> +			drv_masked = phydrv_id & phydrv_id_mask;
> +			phydev_masked = phydev_id & phydrv_id_mask;
> +
> +			dev_debug(&pdev->dev,
> +				  "%s: ID Check: (%x -> %x), drv (%x -> %x)\n",
> +				new_bus->id, phydev_id, phydev_masked,
> +				phydrv_id, drv_masked);
> +
> +			phydev_match = phydev_masked & drv_masked;
> +			phydev_match = phydev_match == phydev_masked;
> +
> +			drv_match = phydev_masked & drv_masked;
> +			drv_match = drv_match == drv_masked;
> +
> +			dev_debug(&pdev->dev, "%s: ID Check: %x == %x\n",
> +				  new_bus->id, phydev_match, drv_match);
> +
> +			everything_OK = (phydev_match == drv_match);

You're doing again what phy_bus_match() did. It's unclear what this should
be good for. Also it would be helpful if you could explain what the actual
issue is you're trying to fix, incl. the commit that caused the regression.
There is one known issue in 5.4.31 with chip versions with RTL8208 PHY.
This is fixed in 5.4.32.
Apart from that having r8169 in initramfs can cause issues if realtek.ko
isn't included too. Most distro's take care by checking softdeps in their
initramfs mgmt tools. One known exception is Gentoo, as their genkernel
tool doesn't check softdeps.


> +		}
> +
> +		if (!everything_OK) {
> +			/* Most chip versions fail with the genphy driver.
> +			 * Therefore ensure that the dedicated PHY driver
> +			 * is loaded.
> +			 */
> +			dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
> +			mdiobus_unregister(new_bus);
> +			return -EUNATCH;
> +		}
>  	}
>  
>  	/* PHY will be woken up in rtl_open() */
> @@ -5435,6 +5480,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	u64_stats_init(&tp->rx_stats.syncp);
>  	u64_stats_init(&tp->tx_stats.syncp);
>  
> +	dev_dbg(&pdev->dev, "init: MAC\n");
>  	rtl_init_mac_address(tp);
>  
>  	dev->ethtool_ops = &rtl8169_ethtool_ops;
> @@ -5483,12 +5529,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	dev->hw_features |= NETIF_F_RXFCS;
>  
>  	jumbo_max = rtl_jumbo_max(tp);
> +	dev_dbg(&pdev->dev, "init: jumbo max: %d\n", jumbo_max);
>  	if (jumbo_max)
>  		dev->max_mtu = jumbo_max;
>  
> +	dev_dbg(&pdev->dev, "init: irq mask\n");
>  	rtl_set_irq_mask(tp);
>  
>  	tp->fw_name = rtl_chip_infos[chipset].fw_name;
> +	dev_dbg(&pdev->dev, "init: FW name: %s\n", tp->fw_name);
>  
>  	tp->counters = dmam_alloc_coherent (&pdev->dev, sizeof(*tp->counters),
>  					    &tp->counters_phys_addr,
> @@ -5496,16 +5545,21 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (!tp->counters)
>  		return -ENOMEM;
>  
> +	dev_dbg(&pdev->dev, "init: set driver data\n");
>  	pci_set_drvdata(pdev, dev);
>  
> +	dev_dbg(&pdev->dev, "init: register mdio\n");
>  	rc = r8169_mdio_register(tp);
> +	dev_dbg(&pdev->dev, "init: mdio register: %d\n", rc);
>  	if (rc)
>  		return rc;
>  
>  	/* chip gets powered up in rtl_open() */
> +	dev_dbg(&pdev->dev, "init: pll pwr down\n");
>  	rtl_pll_power_down(tp);
>  
>  	rc = register_netdev(dev);
> +	dev_dbg(&pdev->dev, "init: netdev register: %d\n", rc);
>  	if (rc)
>  		goto err_mdio_unregister;
>  
> @@ -5525,6 +5579,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>  	if (pci_dev_run_wake(pdev))
>  		pm_runtime_put_sync(&pdev->dev);
>  
> +	dev_dbg(&pdev->dev, "init: ALL DONE!\n");
> +
>  	return 0;
>  
>  err_mdio_unregister:
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index 522760c8bca6..719ea48164f6 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -112,6 +112,9 @@ EXPORT_SYMBOL(mdiobus_unregister_device);
>  struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  {
>  	struct mdio_device *mdiodev = bus->mdio_map[addr];
> +	struct phy_device *rv = NULL;
> +
> +	pr_debug("mii_bus %s addr %d, %p\n", bus->id, addr, mdiodev);
>  
>  	if (!mdiodev)
>  		return NULL;
> @@ -119,7 +122,10 @@ struct phy_device *mdiobus_get_phy(struct mii_bus *bus, int addr)
>  	if (!(mdiodev->flags & MDIO_DEVICE_FLAG_PHY))
>  		return NULL;
>  
> -	return container_of(mdiodev, struct phy_device, mdio);
> +	rv = container_of(mdiodev, struct phy_device, mdio);
> +	pr_debug("mii_bus OK? %s addr %d, %p -> %p\n",
> +		 bus->id, addr, mdiodev, rv);
> +	return rv;
>  }
>  EXPORT_SYMBOL(mdiobus_get_phy);
>  
> @@ -645,10 +651,11 @@ int __mdiobus_register(struct mii_bus *bus, struct module *owner)
>  	mdiobus_setup_mdiodev_from_board_info(bus, mdiobus_create_device);
>  
>  	bus->state = MDIOBUS_REGISTERED;
> -	pr_info("%s: probed\n", bus->name);
> +	pr_info("%s: probed (mdiobus_register)\n", bus->name);
>  	return 0;
>  
>  error:
> +	pr_err("%s: Error while in mdiobus_register: %d\n", bus->name, err);
>  	while (--i >= 0) {
>  		mdiodev = bus->mdio_map[i];
>  		if (!mdiodev)
> 

