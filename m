Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09C08455B2A
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 13:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344484AbhKRMGo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 07:06:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344467AbhKRMGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 07:06:38 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014EAC0613B9;
        Thu, 18 Nov 2021 04:03:38 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id w1so25850464edd.10;
        Thu, 18 Nov 2021 04:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=mewAveTCqRi9du2w88kTP85jrwc8TZs6Ft0E9xKmPFE=;
        b=PLbIZvvlcujP4/jkzP+A+nTyEKCzovhCa7auRnoFzlIPkxyMTmGB+aXDgB/Yk8f00i
         z/w89oag+btW0Sz7g/9LknGaZ7hGHEfF1KeZO60t6XSc4qNyHml2rFUE2rDBwHiooB03
         rtAMtRoKkmElwSpW2Sg7OBhgQkbksqVDl4YykTmuDlv16WscSqxZkeiocplN/yN3o98o
         D7FjpeWcw4jWcHcK4QFH+PWaSBSHwlOv+EBdH3jUrErREGVPDswT1FNP54Qp0VWhQ2Jr
         ZAZanhbogVQkaOx+4cIXDRr3iioqGoMrcykjzyQXygs7DvPG8gNTXqauoLw9hBi4FcLz
         rTZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=mewAveTCqRi9du2w88kTP85jrwc8TZs6Ft0E9xKmPFE=;
        b=yN8KRxw8ZPGxbU2nwwjRb8JVA797dbrdVX9czidbUZj8XnLzaW9VJtUZrbpb54tEhn
         qu4d0u6yGXTs/Sn9OVDlFG018deJ2CodgUJdD93+C52KOqchYg7puYJ/ntbfOaCfKIrf
         CDqAEO4bHAPNeLg99D0dDKz1xwha2kRXtuEg6zG410dF6C1mx7SB7VaH8xlzTzXi2SJR
         xMOc3/l+gcoOXxh0HlQlr/mSYG5z9wNT87w33ccJlcshU2qSYUOn5gkQIOox8nNBKkex
         FhcrOsoRO4sqqAWswEPPo4G71asdMLclKuCLVkhbIO1UxhSUMkxDuOFuoaDsiER3zLwQ
         3T/A==
X-Gm-Message-State: AOAM532NaAVofrko0YV8pypoyZE/hJUaiVcK+i26bXmfG8u9nE9pFjT2
        Bm3+GB4ebw/7xRfzd7yy7iE=
X-Google-Smtp-Source: ABdhPJw+B7nSRvctiZ9enWFR61p6TaUmdogURkWt5tv0B77xZuIIyT0wpW5GukVDj/LbFOwE4Bn3dw==
X-Received: by 2002:a17:906:2c47:: with SMTP id f7mr33330825ejh.94.1637237016466;
        Thu, 18 Nov 2021 04:03:36 -0800 (PST)
Received: from skbuf ([188.25.163.189])
        by smtp.gmail.com with ESMTPSA id p13sm1515236eds.38.2021.11.18.04.03.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 04:03:36 -0800 (PST)
Date:   Thu, 18 Nov 2021 14:03:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net: phy: marvell10g: select host interface
 configuration
Message-ID: <20211118120334.jjujutp5cnjgwjq2@skbuf>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-9-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211117225050.18395-9-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Wed, Nov 17, 2021 at 11:50:50PM +0100, Marek Behún wrote:
> From: Russell King <rmk+kernel@armlinux.org.uk>
> 
> Select the host interface configuration according to the capabilities of
> the host.
> 
> This allows the kernel to:
> - support SFP modules with 88X33X0 or 88E21X0 inside them
> - switch interface modes when the PHY is used with the mvpp2 MAC
>   (e.g. on MacchiatoBIN)
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> [ rebase, updated, also added support for 88E21X0 ]
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/phy/marvell10g.c | 120 +++++++++++++++++++++++++++++++++--
>  1 file changed, 115 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> index 0cb9b4ef09c7..94bea1bade6f 100644
> --- a/drivers/net/phy/marvell10g.c
> +++ b/drivers/net/phy/marvell10g.c
> @@ -96,6 +96,11 @@ enum {
>  	MV_PCS_PORT_INFO_NPORTS_MASK	= 0x0380,
>  	MV_PCS_PORT_INFO_NPORTS_SHIFT	= 7,
>  
> +	/* SerDes reinitialization 88E21X0 */
> +	MV_AN_21X0_SERDES_CTRL2	= 0x800f,
> +	MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS	= BIT(13),
> +	MV_AN_21X0_SERDES_CTRL2_RUN_INIT	= BIT(15),
> +
>  	/* These registers appear at 0x800X and 0xa00X - the 0xa00X control
>  	 * registers appear to set themselves to the 0x800X when AN is
>  	 * restarted, but status registers appear readable from either.
> @@ -140,6 +145,8 @@ struct mv3310_chip {
>  	bool (*has_downshift)(struct phy_device *phydev);
>  	void (*init_supported_interfaces)(unsigned long *mask);
>  	int (*get_mactype)(struct phy_device *phydev);
> +	int (*set_mactype)(struct phy_device *phydev, int mactype);
> +	int (*select_mactype)(unsigned long *interfaces);
>  	int (*init_interface)(struct phy_device *phydev, int mactype);
>  
>  #ifdef CONFIG_HWMON
> @@ -593,6 +600,49 @@ static int mv2110_get_mactype(struct phy_device *phydev)
>  	return mactype & MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
>  }
>  
> +static int mv2110_set_mactype(struct phy_device *phydev, int mactype)
> +{
> +	int err, val;
> +
> +	mactype &= MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK;
> +	err = phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_21X0_PORT_CTRL,
> +			     MV_PMA_21X0_PORT_CTRL_SWRST |
> +			     MV_PMA_21X0_PORT_CTRL_MACTYPE_MASK,
> +			     MV_PMA_21X0_PORT_CTRL_SWRST | mactype);
> +	if (err)
> +		return err;
> +
> +	err = phy_set_bits_mmd(phydev, MDIO_MMD_AN, MV_AN_21X0_SERDES_CTRL2,
> +			       MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS |
> +			       MV_AN_21X0_SERDES_CTRL2_RUN_INIT);
> +	if (err)
> +		return err;
> +
> +	err = phy_read_mmd_poll_timeout(phydev, MDIO_MMD_AN,
> +					MV_AN_21X0_SERDES_CTRL2, val,
> +					!(val &
> +					  MV_AN_21X0_SERDES_CTRL2_RUN_INIT),
> +					5000, 100000, true);
> +	if (err)
> +		return err;
> +
> +	return phy_clear_bits_mmd(phydev, MDIO_MMD_AN, MV_AN_21X0_SERDES_CTRL2,
> +				  MV_AN_21X0_SERDES_CTRL2_AUTO_INIT_DIS);
> +}
> +
> +static int mv2110_select_mactype(unsigned long *interfaces)
> +{
> +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> +		return MV_PMA_21X0_PORT_CTRL_MACTYPE_USXGMII;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> +		 !test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> +		return MV_PMA_21X0_PORT_CTRL_MACTYPE_5GBASER;
> +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> +		return MV_PMA_21X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> +	else
> +		return -1;
> +}
> +
>  static int mv3310_get_mactype(struct phy_device *phydev)
>  {
>  	int mactype;
> @@ -604,6 +654,46 @@ static int mv3310_get_mactype(struct phy_device *phydev)
>  	return mactype & MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
>  }
>  
> +static int mv3310_set_mactype(struct phy_device *phydev, int mactype)
> +{
> +	int ret;
> +
> +	mactype &= MV_V2_33X0_PORT_CTRL_MACTYPE_MASK;
> +	ret = phy_modify_mmd_changed(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
> +				     MV_V2_33X0_PORT_CTRL_MACTYPE_MASK,
> +				     mactype);
> +	if (ret <= 0)
> +		return ret;
> +
> +	return phy_set_bits_mmd(phydev, MDIO_MMD_VEND2, MV_V2_PORT_CTRL,
> +				MV_V2_33X0_PORT_CTRL_SWRST);
> +}
> +
> +static int mv3310_select_mactype(unsigned long *interfaces)
> +{
> +	if (test_bit(PHY_INTERFACE_MODE_USXGMII, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_USXGMII;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> +		 test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> +		 test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces) &&
> +		 test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI;
> +	else if (test_bit(PHY_INTERFACE_MODE_10GBASER, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER_RATE_MATCH;
> +	else if (test_bit(PHY_INTERFACE_MODE_RXAUI, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_RXAUI_RATE_MATCH;
> +	else if (test_bit(PHY_INTERFACE_MODE_XAUI, interfaces))
> +		return MV_V2_3310_PORT_CTRL_MACTYPE_XAUI_RATE_MATCH;
> +	else if (test_bit(PHY_INTERFACE_MODE_SGMII, interfaces))
> +		return MV_V2_33X0_PORT_CTRL_MACTYPE_10GBASER;
> +	else
> +		return -1;
> +}
> +

I would like to understand this heuristic better. Both its purpose and
its implementation.

It says:
(a) If the intersection between interface modes supported by the MAC and
    the PHY contains USXGMII, then use USXGMII as a MACTYPE
(b) Otherwise, if the intersection contains both 10GBaseR and SGMII, then
    use 10GBaseR as MACTYPE
(...)
(c) Otherwise, if the intersection contains just 10GBaseR (no SGMII), then
    use 10GBaseR with rate matching as MACTYPE
(...)
(d) Otherwise, if the intersection contains just SGMII (no 10GBaseR), then
    use 10GBaseR as MACTYPE (no rate matching).

First of all, what is MACTYPE exactly? And what is the purpose of
changing it? What would happen if this configuration remained fixed, as
it were?

I see there is no MACTYPE definition for SGMII. Why is that? How does
the PHY choose to use SGMII?

Why is item (d) correct - use 10GBaseR as MACTYPE if the intersection
only supports SGMII?

A breakdown per link speed might be helpful in understanding the
configurations being performed here.

>  static int mv2110_init_interface(struct phy_device *phydev, int mactype)
>  {
>  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
> @@ -674,10 +764,16 @@ static int mv3310_config_init(struct phy_device *phydev)
>  {
>  	struct mv3310_priv *priv = dev_get_drvdata(&phydev->mdio.dev);
>  	const struct mv3310_chip *chip = to_mv3310_chip(phydev);
> +	DECLARE_PHY_INTERFACE_MASK(interfaces);
>  	int err, mactype;
>  
> -	/* Check that the PHY interface type is compatible */
> -	if (!test_bit(phydev->interface, priv->supported_interfaces))
> +	/* In case host didn't provide supported interfaces */
> +	__set_bit(phydev->interface, phydev->host_interfaces);

Shouldn't phylib populate phydev->host_interfaces with
phydev->interface, rather than requiring PHY drivers to do it?

> +
> +	/* Check that there is at least one compatible PHY interface type */
> +	phy_interface_and(interfaces, phydev->host_interfaces,
> +			  priv->supported_interfaces);
> +	if (phy_interface_empty(interfaces))
>  		return -ENODEV;
>  
>  	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
> @@ -687,9 +783,15 @@ static int mv3310_config_init(struct phy_device *phydev)
>  	if (err)
>  		return err;
>  
> -	mactype = chip->get_mactype(phydev);
> -	if (mactype < 0)
> -		return mactype;
> +	mactype = chip->select_mactype(interfaces);
> +	if (mactype < 0) {
> +		mactype = chip->get_mactype(phydev);
> +	} else {
> +		phydev_info(phydev, "Changing MACTYPE to %i\n", mactype);
> +		err = chip->set_mactype(phydev, mactype);
> +		if (err)
> +			return err;
> +	}
>  
>  	err = chip->init_interface(phydev, mactype);
>  	if (err) {
> @@ -1049,6 +1151,8 @@ static const struct mv3310_chip mv3310_type = {
>  	.has_downshift = mv3310_has_downshift,
>  	.init_supported_interfaces = mv3310_init_supported_interfaces,
>  	.get_mactype = mv3310_get_mactype,
> +	.set_mactype = mv3310_set_mactype,
> +	.select_mactype = mv3310_select_mactype,
>  	.init_interface = mv3310_init_interface,
>  
>  #ifdef CONFIG_HWMON
> @@ -1060,6 +1164,8 @@ static const struct mv3310_chip mv3340_type = {
>  	.has_downshift = mv3310_has_downshift,
>  	.init_supported_interfaces = mv3340_init_supported_interfaces,
>  	.get_mactype = mv3310_get_mactype,
> +	.set_mactype = mv3310_set_mactype,
> +	.select_mactype = mv3310_select_mactype,
>  	.init_interface = mv3340_init_interface,
>  
>  #ifdef CONFIG_HWMON
> @@ -1070,6 +1176,8 @@ static const struct mv3310_chip mv3340_type = {
>  static const struct mv3310_chip mv2110_type = {
>  	.init_supported_interfaces = mv2110_init_supported_interfaces,
>  	.get_mactype = mv2110_get_mactype,
> +	.set_mactype = mv2110_set_mactype,
> +	.select_mactype = mv2110_select_mactype,
>  	.init_interface = mv2110_init_interface,
>  
>  #ifdef CONFIG_HWMON
> @@ -1080,6 +1188,8 @@ static const struct mv3310_chip mv2110_type = {
>  static const struct mv3310_chip mv2111_type = {
>  	.init_supported_interfaces = mv2111_init_supported_interfaces,
>  	.get_mactype = mv2110_get_mactype,
> +	.set_mactype = mv2110_set_mactype,
> +	.select_mactype = mv2110_select_mactype,
>  	.init_interface = mv2110_init_interface,
>  
>  #ifdef CONFIG_HWMON
> -- 
> 2.32.0
> 

