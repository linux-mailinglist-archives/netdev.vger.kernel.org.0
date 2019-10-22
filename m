Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 384E8E0B92
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 20:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732606AbfJVSkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 14:40:42 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45346 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729666AbfJVSkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 14:40:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id q13so14243269wrs.12
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 11:40:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oiP8C16dj2g2g1nadF1VG7cAOAON9XvvbnkFL9pQGps=;
        b=lvyonnLVBIsIMAZSYPsmBK9nA+YkmHfPpi31lkQGVnIhzgGIsT8FryaZfOY5FBVwUl
         5CoNGtEhDhrg/OxOpVwx1urWcNeapFh3Vw+d5lQdFrbtK2iYw8NPPZ/PM5Gub/GMhpnW
         uiQfJCIXjb1C+Ag1PA1vGRajZ7nVNsU3gZmuSBXFf5Jn80G09eJg0IBIHNN06Byy1fK8
         /q6tH6VqgXDH/Swh88Dk7cSO3nb8kqZaVJTL2+qxxGhdU4CX93ljlFegjutMBMVryfvC
         5T2hq8aEyX0D0BLhxp3I7G8KoRp/Djmggef7oc48DJtFhCdEdcrCgBhAfFzI8oxvVf5/
         H3ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oiP8C16dj2g2g1nadF1VG7cAOAON9XvvbnkFL9pQGps=;
        b=ZA/wMIaLdcLtcpTWDRkc8clB2AxzIy6oIRIKohDY7eDw3RqwSy7YAllwQ8hUuf14w1
         ufE13Bay6/KpUw7IhgVjL6cd3t2W6XbCeFHHDpj5xSoXmK/Z8TaZ3HvJzu9u49h335cL
         4/yayg0YieMapHinXWwM4Kdt10Wjg0EI2Mawo+303+HxDNaSYRVZ+I36PZQHsYro+viA
         GJaCA6A/1ncuPPSpA0jadmNUpSDBk7p2YHbX6s6E833rnVCN/ln6aMeV9ki18fBH17Pr
         Wnn3kVvfYbf+7qskgAh0LQaANTFuGAzz+2yVJLqSTPW/f5NsbotVzVA8MGp5vPRX92Jc
         enSw==
X-Gm-Message-State: APjAAAXO+hPrCN/yk1ztupHN0jE7h7+JW116g9kp76Gh00kwgMy+aB0L
        FVebLc8WbtuByZNbWIyn+Cg=
X-Google-Smtp-Source: APXvYqywEpqjNtSI97hZOv5PLjJ42eddtwBR11tlCTQ5jQR5rVOPOReO5xkV0IDmrlx0dqL2FDhqwA==
X-Received: by 2002:a05:6000:10d:: with SMTP id o13mr4594572wrx.321.1571769638628;
        Tue, 22 Oct 2019 11:40:38 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:d16f:4cec:8adc:ea59? (p200300EA8F266400D16F4CEC8ADCEA59.dip0.t-ipconnect.de. [2003:ea:8f26:6400:d16f:4cec:8adc:ea59])
        by smtp.googlemail.com with ESMTPSA id u1sm19411111wrp.56.2019.10.22.11.40.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 22 Oct 2019 11:40:38 -0700 (PDT)
Subject: Re: [PATCH v2] net: phy: dp83867: support Wake on LAN
To:     =?UTF-8?Q?Thomas_H=c3=a4mmerle?= <Thomas.Haemmerle@wolfvision.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.tretter@pengutronix.de" <m.tretter@pengutronix.de>
References: <1571742645-13800-1-git-send-email-thomas.haemmerle@wolfvision.net>
 <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7916e170-116d-421b-e95b-b3c3cca7f97a@gmail.com>
Date:   Tue, 22 Oct 2019 20:40:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571749572-9736-1-git-send-email-thomas.haemmerle@wolfvision.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.10.2019 15:06, Thomas Hämmerle wrote:
> From: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
> 
> This adds WoL support on TI DP83867 for magic, magic secure, unicast and
> broadcast.
> 
> Signed-off-by: Thomas Haemmerle <thomas.haemmerle@wolfvision.net>
> ---
>  drivers/net/phy/dp83867.c | 131 +++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 130 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/dp83867.c b/drivers/net/phy/dp83867.c
> index 37fceaf..1a3f8f1 100644
> --- a/drivers/net/phy/dp83867.c
> +++ b/drivers/net/phy/dp83867.c
> @@ -12,6 +12,8 @@
>  #include <linux/of.h>
>  #include <linux/phy.h>
>  #include <linux/delay.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
>  
>  #include <dt-bindings/net/ti-dp83867.h>
>  
> @@ -21,8 +23,9 @@
>  #define MII_DP83867_PHYCTRL	0x10
>  #define MII_DP83867_MICR	0x12
>  #define MII_DP83867_ISR		0x13
> -#define DP83867_CTRL		0x1f
> +#define DP83867_CFG2		0x14
>  #define DP83867_CFG3		0x1e
> +#define DP83867_CTRL		0x1f
>  
>  /* Extended Registers */
>  #define DP83867_CFG4            0x0031
> @@ -36,6 +39,13 @@
>  #define DP83867_STRAP_STS1	0x006E
>  #define DP83867_STRAP_STS2	0x006f
>  #define DP83867_RGMIIDCTL	0x0086
> +#define DP83867_RXFCFG		0x0134
> +#define DP83867_RXFPMD1	0x0136
> +#define DP83867_RXFPMD2	0x0137
> +#define DP83867_RXFPMD3	0x0138
> +#define DP83867_RXFSOP1	0x0139
> +#define DP83867_RXFSOP2	0x013A
> +#define DP83867_RXFSOP3	0x013B
>  #define DP83867_IO_MUX_CFG	0x0170
>  #define DP83867_SGMIICTL	0x00D3
>  #define DP83867_10M_SGMII_CFG   0x016F
> @@ -65,6 +75,13 @@
>  /* SGMIICTL bits */
>  #define DP83867_SGMII_TYPE		BIT(14)
>  
> +/* RXFCFG bits*/
> +#define DP83867_WOL_MAGIC_EN		BIT(0)
> +#define DP83867_WOL_BCAST_EN		BIT(2)
> +#define DP83867_WOL_UCAST_EN		BIT(4)
> +#define DP83867_WOL_SEC_EN		BIT(5)
> +#define DP83867_WOL_ENH_MAC		BIT(7)
> +
>  /* STRAP_STS1 bits */
>  #define DP83867_STRAP_STS1_RESERVED		BIT(11)
>  
> @@ -126,6 +143,115 @@ static int dp83867_ack_interrupt(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int dp83867_set_wol(struct phy_device *phydev,
> +			   struct ethtool_wolinfo *wol)
> +{
> +	struct net_device *ndev = phydev->attached_dev;
> +	u16 val_rxcfg, val_micr;
> +	const u8 *mac;
> +
> +	val_rxcfg = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
> +	val_micr = phy_read(phydev, MII_DP83867_MICR);
> +
> +	if (wol->wolopts & (WAKE_MAGIC | WAKE_MAGICSECURE | WAKE_UCAST |
> +			    WAKE_BCAST)) {
> +		val_rxcfg |= DP83867_WOL_ENH_MAC;
> +		val_micr |= MII_DP83867_MICR_WOL_INT_EN;
> +
> +		if (wol->wolopts & WAKE_MAGIC) {
> +			mac = (const u8 *)ndev->dev_addr;

Using a cast to add/remove a const qualifier usually isn't too nice.
Why not simply declare mac w/o const?

Also PHY might not be attached. I think ndev should be checked for NULL.

> +
> +			if (!is_valid_ether_addr(mac))
> +				return -EINVAL;
> +
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD1,
> +				      (mac[1] << 8 | mac[0]));
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD2,
> +				      (mac[3] << 8 | mac[2]));
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFPMD3,
> +				      (mac[5] << 8 | mac[4]));
> +
> +			val_rxcfg |= DP83867_WOL_MAGIC_EN;
> +		} else {
> +			val_rxcfg &= ~DP83867_WOL_MAGIC_EN;
> +		}
> +
> +		if (wol->wolopts & WAKE_MAGICSECURE) {
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[1] << 8) | wol->sopass[0]);
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[3] << 8) | wol->sopass[2]);
> +			phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFSOP1,
> +				      (wol->sopass[5] << 8) | wol->sopass[4]);
> +
> +			val_rxcfg |= DP83867_WOL_SEC_EN;
> +		} else {
> +			val_rxcfg &= ~DP83867_WOL_SEC_EN;
> +		}
> +
> +		if (wol->wolopts & WAKE_UCAST)
> +			val_rxcfg |= DP83867_WOL_UCAST_EN;
> +		else
> +			val_rxcfg &= ~DP83867_WOL_UCAST_EN;
> +
> +		if (wol->wolopts & WAKE_BCAST)
> +			val_rxcfg |= DP83867_WOL_BCAST_EN;
> +		else
> +			val_rxcfg &= ~DP83867_WOL_BCAST_EN;
> +	} else {
> +		val_rxcfg &= ~DP83867_WOL_ENH_MAC;
> +		val_micr &= ~MII_DP83867_MICR_WOL_INT_EN;
> +	}
> +
> +	phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG, val_rxcfg);
> +	phy_write(phydev, MII_DP83867_MICR, val_micr);
> +
> +	return 0;
> +}
> +
> +static void dp83867_get_wol(struct phy_device *phydev,
> +			    struct ethtool_wolinfo *wol)
> +{
> +	u16 value, sopass_val;
> +
> +	wol->supported = (WAKE_UCAST | WAKE_BCAST | WAKE_MAGIC |
> +			WAKE_MAGICSECURE);
> +	wol->wolopts = 0;
> +
> +	value = phy_read_mmd(phydev, DP83867_DEVADDR, DP83867_RXFCFG);
> +
> +	if (value & DP83867_WOL_UCAST_EN)
> +		wol->wolopts |= WAKE_UCAST;
> +
> +	if (value & DP83867_WOL_BCAST_EN)
> +		wol->wolopts |= WAKE_BCAST;
> +
> +	if (value & DP83867_WOL_MAGIC_EN)
> +		wol->wolopts |= WAKE_MAGIC;
> +
> +	if (value & DP83867_WOL_SEC_EN) {
> +		sopass_val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +					  DP83867_RXFSOP1);
> +		wol->sopass[0] = (sopass_val & 0xff);
> +		wol->sopass[1] = (sopass_val >> 8);
> +
> +		sopass_val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +					  DP83867_RXFSOP2);
> +		wol->sopass[2] = (sopass_val & 0xff);
> +		wol->sopass[3] = (sopass_val >> 8);
> +
> +		sopass_val = phy_read_mmd(phydev, DP83867_DEVADDR,
> +					  DP83867_RXFSOP3);
> +		wol->sopass[4] = (sopass_val & 0xff);
> +		wol->sopass[5] = (sopass_val >> 8);
> +
> +		wol->wolopts |= WAKE_MAGICSECURE;
> +	}
> +
> +	if (!(value & DP83867_WOL_ENH_MAC))
> +		wol->wolopts = 0;
> +}
> +
>  static int dp83867_config_intr(struct phy_device *phydev)
>  {
>  	int micr_status;
> @@ -463,6 +589,9 @@ static struct phy_driver dp83867_driver[] = {
>  		.config_init	= dp83867_config_init,
>  		.soft_reset	= dp83867_phy_reset,
>  
> +		.get_wol	= dp83867_get_wol,
> +		.set_wol	= dp83867_set_wol,
> +
>  		/* IRQ related */
>  		.ack_interrupt	= dp83867_ack_interrupt,
>  		.config_intr	= dp83867_config_intr,
> 

