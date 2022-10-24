Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06602609E54
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229730AbiJXJwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiJXJwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:52:22 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 241A9BF4B;
        Mon, 24 Oct 2022 02:52:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666605142; x=1698141142;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=VKA0TLvqW6SrGdoMkbABZt9c/Z5KNe1Vij6Iqbim3mM=;
  b=adNPW/Db61VCESgQ/vYJZRYnljKZYekUj9pFDi5I2gdDKsW60bHmLEay
   pspHF8z7sIUIPFLaOrRROL4a++sk24K1JJkA5sPyu6E9wgOhsNg5EIrGf
   Obb7J6l2on9AyBEm3JZeldx585lS54a8RcPdWME7YQPqVTuZfUFdSQyDs
   g7P6ac02bBVQJJhfl0svmFj1pZPm8SttpTWrHTG+tql3LyUOrhPp5OnSA
   DCq6v2oWvzHcfeSDfOBYumsMk1Zv0kVAgxnNwoxBEq3j2eBN2/kLJ6C8Y
   rAIYpiGQT8gYcUQyxIjOAGO2q/0FB9YX9PzfJBRxGoeWHfmJQxIvNhiwa
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="180209758"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Oct 2022 02:52:21 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 24 Oct 2022 02:52:20 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Mon, 24 Oct 2022 02:52:19 -0700
Date:   Mon, 24 Oct 2022 11:56:59 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next V1 2/2] net: phy: micrel: Add PHY Auto/MDI/MDI-X
 set driver for KSZ9131
Message-ID: <20221024095659.aurdnuurytjzgav5@soft-dev3-1>
References: <20221024082516.661199-1-Raju.Lakkaraju@microchip.com>
 <20221024082516.661199-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221024082516.661199-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/24/2022 13:55, Raju Lakkaraju wrote:
> Add support for MDI-X status and configuration for KSZ9131 chips

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
> Change List:
> ============
> V0 -> V1:
>  - Drop the "_" from the end of the macros
>  - Add KSZ9131 MDI-X specific register contain 9131 in macro names 
> 
>  drivers/net/phy/micrel.c | 77 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 54a17b576eac..26ce0c5defcd 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1295,6 +1295,81 @@ static int ksz9131_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +#define MII_KSZ9131_AUTO_MDIX		0x1C
> +#define MII_KSZ9131_AUTO_MDI_SET	BIT(7)
> +#define MII_KSZ9131_AUTO_MDIX_SWAP_OFF	BIT(6)
> +
> +static int ksz9131_mdix_update(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, MII_KSZ9131_AUTO_MDIX);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & MII_KSZ9131_AUTO_MDIX_SWAP_OFF) {
> +		if (ret & MII_KSZ9131_AUTO_MDI_SET)
> +			phydev->mdix_ctrl = ETH_TP_MDI;
> +		else
> +			phydev->mdix_ctrl = ETH_TP_MDI_X;
> +	} else {
> +		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> +	}
> +
> +	if (ret & MII_KSZ9131_AUTO_MDI_SET)
> +		phydev->mdix = ETH_TP_MDI;
> +	else
> +		phydev->mdix = ETH_TP_MDI_X;
> +
> +	return 0;
> +}
> +
> +static int ksz9131_config_mdix(struct phy_device *phydev, u8 ctrl)
> +{
> +	u16 val;
> +
> +	switch (ctrl) {
> +	case ETH_TP_MDI:
> +		val = MII_KSZ9131_AUTO_MDIX_SWAP_OFF |
> +		      MII_KSZ9131_AUTO_MDI_SET;
> +		break;
> +	case ETH_TP_MDI_X:
> +		val = MII_KSZ9131_AUTO_MDIX_SWAP_OFF;
> +		break;
> +	case ETH_TP_MDI_AUTO:
> +		val = 0;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return phy_modify(phydev, MII_KSZ9131_AUTO_MDIX,
> +			  MII_KSZ9131_AUTO_MDIX_SWAP_OFF |
> +			  MII_KSZ9131_AUTO_MDI_SET, val);
> +}
> +
> +static int ksz9131_read_status(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = ksz9131_mdix_update(phydev);
> +	if (ret < 0)
> +		return ret;
> +
> +	return genphy_read_status(phydev);
> +}
> +
> +static int ksz9131_config_aneg(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = ksz9131_config_mdix(phydev, phydev->mdix_ctrl);
> +	if (ret)
> +		return ret;
> +
> +	return genphy_config_aneg(phydev);
> +}
> +
>  #define KSZ8873MLL_GLOBAL_CONTROL_4	0x06
>  #define KSZ8873MLL_GLOBAL_CONTROL_4_DUPLEX	BIT(6)
>  #define KSZ8873MLL_GLOBAL_CONTROL_4_SPEED	BIT(4)
> @@ -3304,6 +3379,8 @@ static struct phy_driver ksphy_driver[] = {
>  	.probe		= kszphy_probe,
>  	.config_init	= ksz9131_config_init,
>  	.config_intr	= kszphy_config_intr,
> +	.config_aneg	= ksz9131_config_aneg,
> +	.read_status	= ksz9131_read_status,
>  	.handle_interrupt = kszphy_handle_interrupt,
>  	.get_sset_count = kszphy_get_sset_count,
>  	.get_strings	= kszphy_get_strings,
> -- 
> 2.25.1
> 

-- 
/Horatiu
