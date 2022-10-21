Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3D466070E8
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 09:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbiJUHXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 03:23:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJUHW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 03:22:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E48245EBD;
        Fri, 21 Oct 2022 00:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666336978; x=1697872978;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j/iJEREQc6b5PWNxao/a5BkD1vhPEB7D4sLoJaR31eo=;
  b=HpmJLcFxvYv8WeqhLaI05e3WfYwVvZOu8cOjFHlVuJSUfPZLXnC7/862
   yyiwByZ8Jc1wY33+Kb2hFn64rHZRKOICqyozMZMlcd/VYvBVqOzCnSjBy
   885bHf62MznmNevkoTt8pS2hvuWW8fsysCpmId41kCu8hQI7sThS/XZYD
   I3cMqdjKqj7iu97ngBlodTgPZGswphULO9EfyGTJ2WN4/xHZMiMXNlGcI
   AMUmDEciIe1EkLUUoYE5+0Iy+womqqiCsOVu03I2btIJKu+0iUAZjgp1o
   kafKdIpHXjuF6YBlS6S4sPSN6Mwb+T8yA2AT1xeMV6NPX4OF6iUkLzw5h
   g==;
X-IronPort-AV: E=Sophos;i="5.95,200,1661842800"; 
   d="scan'208";a="179895228"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Oct 2022 00:22:58 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 21 Oct 2022 00:22:56 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.12 via Frontend
 Transport; Fri, 21 Oct 2022 00:22:56 -0700
Date:   Fri, 21 Oct 2022 09:27:35 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <bryan.whitehead@microchip.com>,
        <hkallweit1@gmail.com>, <pabeni@redhat.com>, <edumazet@google.com>,
        <linux@armlinux.org.uk>, <UNGLinuxDriver@microchip.com>,
        <andrew@lunn.ch>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 2/2] net: phy: micrel: Add PHY Auto/MDI/MDI-X
 set driver for KSZ9131
Message-ID: <20221021072735.pcx6wlnujhhxgy3q@soft-dev3-1>
References: <20221021055642.255413-1-Raju.Lakkaraju@microchip.com>
 <20221021055642.255413-3-Raju.Lakkaraju@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20221021055642.255413-3-Raju.Lakkaraju@microchip.com>
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 10/21/2022 11:26, Raju Lakkaraju wrote:

Hi Raju,

> Add support for MDI-X status and configuration for KSZ9131 chips
> 
> Signed-off-by: Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
> ---
>  drivers/net/phy/micrel.c | 77 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 77 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 54a17b576eac..40aa52d442f8 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -1295,6 +1295,81 @@ static int ksz9131_config_init(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +#define MII_KSZPHY_AUTO_MDIX		0x1C
> +#define MII_KSZPHY_AUTO_MDI_SET_	BIT(7)
> +#define MII_KSZPHY_AUTO_MDIX_SWAP_OFF_	BIT(6)

Can you please drop the "_" from the end of the macros. The only
macros that have that suffix are those used by PTP.

Are these KSZPHY registers generic for all KSZ phys? Then the functions
'ksz9131_mdix_update' and 'ksz9131_config_mdix' shouldn't be rename to
something like 'kszphy_mdix_update' and 'kszphy_config_mdix'?
Otherwise shoudln't these register contain 9131 in their name?

I know that also lan8841 and lan8804 have the same layout for these
registers.

> +
> +static int ksz9131_mdix_update(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, MII_KSZPHY_AUTO_MDIX);
> +	if (ret < 0)
> +		return ret;
> +
> +	if (ret & MII_KSZPHY_AUTO_MDIX_SWAP_OFF_) {
> +		if (ret & MII_KSZPHY_AUTO_MDI_SET_)
> +			phydev->mdix_ctrl = ETH_TP_MDI;
> +		else
> +			phydev->mdix_ctrl = ETH_TP_MDI_X;
> +	} else {
> +		phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> +	}
> +
> +	if (ret & MII_KSZPHY_AUTO_MDI_SET_)
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
> +		val = MII_KSZPHY_AUTO_MDIX_SWAP_OFF_ |
> +		      MII_KSZPHY_AUTO_MDI_SET_;
> +		break;
> +	case ETH_TP_MDI_X:
> +		val = MII_KSZPHY_AUTO_MDIX_SWAP_OFF_;
> +		break;
> +	case ETH_TP_MDI_AUTO:
> +		val = 0;
> +		break;
> +	default:
> +		return 0;
> +	}
> +
> +	return phy_modify(phydev, MII_KSZPHY_AUTO_MDIX,
> +			  MII_KSZPHY_AUTO_MDIX_SWAP_OFF_ |
> +			  MII_KSZPHY_AUTO_MDI_SET_, val);
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
> +	ret = genphy_config_aneg(phydev);
> +	if (ret)
> +		return ret;
> +
> +	return ksz9131_config_mdix(phydev, phydev->mdix_ctrl);
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
