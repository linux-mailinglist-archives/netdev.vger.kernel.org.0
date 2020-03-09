Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E273917E8FE
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 20:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726269AbgCITqE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 15:46:04 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41650 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbgCITqE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 15:46:04 -0400
Received: by mail-wr1-f67.google.com with SMTP id v4so12773613wrs.8;
        Mon, 09 Mar 2020 12:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iajNcMb4nFgTefMlkzyM3GBBDaX3XCUGHAbLXHtEp2U=;
        b=eykaXS3nftIiU9qNCirUdhPCrcNIhvFrQbpnPPAsZheXslenyhMJYcL/p7YNzItkYa
         niw8YKg6tcBNIhWpF2k5Im9/X/dusD24zMhnuTtuYtsiN4bG/1nPncxOpnllynv0HBDI
         PZ0ldb+BeHB/CwCzdP88UWNtnH/IJbO1v8fXNxK4ZEhgaarlKWjXhMjjtTr1NkbiCZVw
         hT8kIDT8i62M2dJfjJqJE7Kpp1SVLQ14WMCxfHfPZeNj1eyfC3vDcobrlv/Zv6Sq5wKW
         bepZZucQBKFazyoqtHc+o2YE48mc5GJXaBmA+ZeqyE/pDfmXcY53qiW2agvEZ9wC8lMi
         ySlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iajNcMb4nFgTefMlkzyM3GBBDaX3XCUGHAbLXHtEp2U=;
        b=eYmIzUxpqBcg6vfdS5WY9O4rs14jaA8RicdO10pG2rNLwDduHlUFdfNPFcHt8XtDaF
         XWC52ux6/kYsKxs44+p4m/+s+7kkTcHjdG+eSCEzpbsdA2OqHDT4gAqS3/irRR+3shaR
         BX2Te8a2fzsMKJvO9rbpp7bhnZGN/SL3XzkogI4I+wE0L4aPFs3/5+zaDMW210z2NEMB
         RO3zXckr0YDnqrt1BW8huCclN9e08PgtJQWZGkysAKCOjdFmznODfRJgRh0F1+eTfEE4
         faJcaeEpkarMeC4sfxGxznJYunLtuQIV/zLtNCr/JIQ4qOeEL3dlTkEbR0erU9681+Cr
         vDjA==
X-Gm-Message-State: ANhLgQ38RG1KbvYt8LQ+EhdVp0NcWfsw90YvJXSxDR9EjKIy0/k5uBy6
        gf0rQU9G0HbB+/22fGdkhcs=
X-Google-Smtp-Source: ADFU+vtnoXo6Xy24Dkg/rmQG4Yt8eKB/a3nJC6l9sq0UV/OaeUWNujMEYL2S1jU6t+e0DAVmbctySg==
X-Received: by 2002:adf:f7c1:: with SMTP id a1mr22442883wrq.299.1583783161378;
        Mon, 09 Mar 2020 12:46:01 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:fd18:ac88:8412:f02? (p200300EA8F296000FD18AC8884120F02.dip0.t-ipconnect.de. [2003:ea:8f29:6000:fd18:ac88:8412:f02])
        by smtp.googlemail.com with ESMTPSA id k133sm785404wma.11.2020.03.09.12.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2020 12:46:00 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] net: phy: tja11xx: add TJA1102 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
References: <20200309074044.21399-1-o.rempel@pengutronix.de>
 <20200309074044.21399-2-o.rempel@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <ec2361a9-1b7b-b939-a2a2-fac4d1146731@gmail.com>
Date:   Mon, 9 Mar 2020 20:45:50 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200309074044.21399-2-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.03.2020 08:40, Oleksij Rempel wrote:
> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
> configured in device tree by setting compatible = "ethernet-phy-id0180.dc81".
> 
> PHY 1 has less supported registers and functionality. For current driver
> it will affect only the HWMON support.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/nxp-tja11xx.c | 102 ++++++++++++++++++++++++++++++++++
>  1 file changed, 102 insertions(+)
> 
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index b705d0bd798b..f79c9aa051ed 100644
> --- a/drivers/net/phy/nxp-tja11xx.c
> +++ b/drivers/net/phy/nxp-tja11xx.c
> @@ -15,6 +15,7 @@
>  #define PHY_ID_MASK			0xfffffff0
>  #define PHY_ID_TJA1100			0x0180dc40
>  #define PHY_ID_TJA1101			0x0180dd00
> +#define PHY_ID_TJA1102			0x0180dc80
>  
>  #define MII_ECTRL			17
>  #define MII_ECTRL_LINK_CONTROL		BIT(15)
> @@ -40,6 +41,10 @@
>  #define MII_INTSRC_TEMP_ERR		BIT(1)
>  #define MII_INTSRC_UV_ERR		BIT(3)
>  
> +#define MII_INTEN			22
> +#define MII_INTEN_LINK_FAIL		BIT(10)
> +#define MII_INTEN_LINK_UP		BIT(9)
> +
>  #define MII_COMMSTAT			23
>  #define MII_COMMSTAT_LINK_UP		BIT(15)
>  
> @@ -190,6 +195,7 @@ static int tja11xx_config_init(struct phy_device *phydev)
>  			return ret;
>  		break;
>  	case PHY_ID_TJA1101:
> +	case PHY_ID_TJA1102:
>  		ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
>  		if (ret)
>  			return ret;
> @@ -354,6 +360,66 @@ static int tja11xx_probe(struct phy_device *phydev)
>  	return PTR_ERR_OR_ZERO(priv->hwmon_dev);
>  }
>  
> +static int tja1102_match_phy_device(struct phy_device *phydev, bool port0)
> +{
> +	int ret;
> +
> +	if ((phydev->phy_id & PHY_ID_MASK) != PHY_ID_TJA1102)

For port 1 you rely on DT forcing the appropriate phy_id
(else it would be 0 and port 1 wouldn't be matched).
This is worth a describing comment.

> +		return 0;
> +
> +	ret = phy_read(phydev, MII_PHYSID2);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* TJA1102 Port 1 has phyid 0 and doesn't support temperature
> +	 * and undervoltage alarms.
> +	 */
> +	if (port0)
> +		return ret ? 1 : 0;
> +
> +	return !ret;
> +}
> +
> +static int tja1102_p0_match_phy_device(struct phy_device *phydev)
> +{
> +	return tja1102_match_phy_device(phydev, true);
> +}
> +
> +static int tja1102_p1_match_phy_device(struct phy_device *phydev)
> +{
> +	return tja1102_match_phy_device(phydev, false);
> +}
> +
> +static int tja11xx_ack_interrupt(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, MII_INTSRC);
> +
> +	return (ret < 0) ? ret : 0;
> +}
> +
> +static int tja11xx_config_intr(struct phy_device *phydev)
> +{
> +	int value;
> +	int ret;
> +
> +	value = phy_read(phydev, MII_INTEN);
> +	if (value < 0)
> +		return value;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED) {
> +		value |= MII_INTEN_LINK_FAIL;
> +		value |= MII_INTEN_LINK_UP;
> +

This may leave unwanted interrupt sources active. Why not
simply setting a fixed value like in the else clause?

> +		ret = phy_write(phydev, MII_INTEN, value);
> +	}
> +	else

Kernel style:
Closing brace and else belong to one line. And the else clause
needs braces too. checkpatch.pl should complain here.

> +		ret = phy_write(phydev, MII_INTEN, 0);
> +
> +	return ret;
> +}
> +
>  static struct phy_driver tja11xx_driver[] = {
>  	{
>  		PHY_ID_MATCH_MODEL(PHY_ID_TJA1100),
> @@ -385,6 +451,41 @@ static struct phy_driver tja11xx_driver[] = {
>  		.get_sset_count = tja11xx_get_sset_count,
>  		.get_strings	= tja11xx_get_strings,
>  		.get_stats	= tja11xx_get_stats,
> +	}, {
> +		.name		= "NXP TJA1102 Port 0",
> +		.features       = PHY_BASIC_T1_FEATURES,
> +		.probe		= tja11xx_probe,
> +		.soft_reset	= tja11xx_soft_reset,
> +		.config_init	= tja11xx_config_init,
> +		.read_status	= tja11xx_read_status,
> +		.match_phy_device = tja1102_p0_match_phy_device,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.set_loopback   = genphy_loopback,
> +		/* Statistics */
> +		.get_sset_count = tja11xx_get_sset_count,
> +		.get_strings	= tja11xx_get_strings,
> +		.get_stats	= tja11xx_get_stats,
> +		.ack_interrupt	= tja11xx_ack_interrupt,
> +		.config_intr	= tja11xx_config_intr,
> +
> +	}, {
> +		.name		= "NXP TJA1102 Port 1",
> +		.features       = PHY_BASIC_T1_FEATURES,
> +		/* currently no probe for Port 1 is need */
> +		.soft_reset	= tja11xx_soft_reset,
> +		.config_init	= tja11xx_config_init,
> +		.read_status	= tja11xx_read_status,
> +		.match_phy_device = tja1102_p1_match_phy_device,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.set_loopback   = genphy_loopback,
> +		/* Statistics */
> +		.get_sset_count = tja11xx_get_sset_count,
> +		.get_strings	= tja11xx_get_strings,
> +		.get_stats	= tja11xx_get_stats,
> +		.ack_interrupt	= tja11xx_ack_interrupt,
> +		.config_intr	= tja11xx_config_intr,
>  	}
>  };
>  
> @@ -393,6 +494,7 @@ module_phy_driver(tja11xx_driver);
>  static struct mdio_device_id __maybe_unused tja11xx_tbl[] = {
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1100) },
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1101) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1102) },
>  	{ }
>  };
>  
> 

