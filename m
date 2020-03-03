Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0070417717D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 09:46:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727659AbgCCIqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 03:46:49 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36165 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725818AbgCCIqt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 03:46:49 -0500
Received: by mail-wr1-f67.google.com with SMTP id j16so3260603wrt.3;
        Tue, 03 Mar 2020 00:46:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bP8XvFl8R4YFVa1gOdjRlY+8HK04lqQH7mcmvwAZAJY=;
        b=GjObYFTAzE8rFA8uaHRt9vBguf3GQ4s+wj1lB1DVJG1aStFtYQxUhD2yAmPn+GKk2U
         4weAX/X9EpNGmlEipOB94qnHFe5+WiSev8J3AAxH2S9GD9CG/q+i1E0VCy1Qo/kTNP3M
         sPG5WhWfOHr0PgWxBSaBaG7fDFub5t/7OZkYlM0jtn6hR8h0KPPC25+eEAjCvRNbRjJS
         pq28zFhe4ijt0uULSZeClaE6I0gNY7qe8nkYSTp2E73MeKOUKHsxOhXgXSHW9UucPGZs
         YjlhYf31HRI+l1dCJPbWvEqA6jvhjFBcR0OdnBBmFA1vffWViNvdmAwCi7G2OPRYuvwk
         fsmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bP8XvFl8R4YFVa1gOdjRlY+8HK04lqQH7mcmvwAZAJY=;
        b=NX8fWqylWIz/0oIE/WHWC2UZ2E6tukRX7Kt3KcgjdXZOK5m9LAsqEix4sRvhhm+GJh
         qo7PXMtSedJM/m3hbksu3BVv/5pnip/8MnF73dIpjpKATKham+XnjwDUAC3E74lmOPPr
         U6HSihDCzb0SLFREXeQpmuiUIv4NhUM94rUBwxwNmnVAyFTBODHxxpRqvmQqinFhJqYo
         1X1eusimSSxg6homdVyGQ68h+OorG9Is07bswMAtLoOJo7x4k5tDEWFwHmrN4D+RUH4q
         TqxR3uqQpihosXKwYyXn1TtiLJqlhE4SnwS0pTv7xjq6r3qK9wcdV6zhxI8sohC+j/kx
         kRYw==
X-Gm-Message-State: ANhLgQ06i+MlxTtSsA/mqyVsrHmqYqonjD4+DhoSw5aV9FcRYy3Hw/2M
        1RYxkzpXvdbe1DWRwOCc+dM=
X-Google-Smtp-Source: ADFU+vu+A3P/TC8dTmyi5tKf23KZ5V9N9wV9ldGhrc91Dm2ea+Ql9x3yFTm5HbwAAZ8qK0tvd2DhVQ==
X-Received: by 2002:adf:e98f:: with SMTP id h15mr4456890wrm.263.1583225204458;
        Tue, 03 Mar 2020 00:46:44 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:6062:15dd:9144:874b? (p200300EA8F296000606215DD9144874B.dip0.t-ipconnect.de. [2003:ea:8f29:6000:6062:15dd:9144:874b])
        by smtp.googlemail.com with ESMTPSA id k126sm2508176wme.4.2020.03.03.00.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2020 00:46:43 -0800 (PST)
Subject: Re: [PATCH v1] net: phy: tja11xx: add TJA1102 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     Pengutronix Kernel Team <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Marek Vasut <marex@denx.de>, David Jander <david@protonic.nl>
References: <20200303073715.32301-1-o.rempel@pengutronix.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <eada8b95-bbfe-5dba-7e39-6202e67c26f0@gmail.com>
Date:   Tue, 3 Mar 2020 09:46:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200303073715.32301-1-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.03.2020 08:37, Oleksij Rempel wrote:
> TJA1102 is an dual T1 PHY chip. Both PHYs are separately addressable.
> PHY 0 can be identified by PHY ID. PHY 1 has no PHY ID and can be
> configured in device tree by setting compatible =
> "ethernet-phy-id0180.dc81".
> 
> PHY 1 has less suported registers and functionality. For current driver
> it will affect only the HWMON support.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  drivers/net/phy/nxp-tja11xx.c | 43 +++++++++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
> 
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index b705d0bd798b..52090cfaa54e 100644
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
> @@ -190,6 +191,7 @@ static int tja11xx_config_init(struct phy_device *phydev)
>  			return ret;
>  		break;
>  	case PHY_ID_TJA1101:
> +	case PHY_ID_TJA1102:
>  		ret = phy_set_bits(phydev, MII_COMMCFG, MII_COMMCFG_AUTO_OP);
>  		if (ret)
>  			return ret;
> @@ -337,6 +339,31 @@ static int tja11xx_probe(struct phy_device *phydev)
>  	if (!priv)
>  		return -ENOMEM;
>  
> +	/* Use the phyid to distinguish between port 0 and port 1 of the
> +	 * TJA1102. Port 0 has a proper phyid, while port 1 reads 0.
> +	 */
> +	if ((phydev->phy_id & PHY_ID_MASK) == PHY_ID_TJA1102) {
> +		int ret;
> +		u32 id;
> +
> +		ret = phy_read(phydev, MII_PHYSID1);
> +		if (ret < 0)
> +			return ret;
> +
> +		id = ret;
> +		ret = phy_read(phydev, MII_PHYSID2);
> +		if (ret < 0)
> +			return ret;
> +
> +		id |= ret << 16;
> +
> +		/* TJA1102 Port 1 has phyid 0 and doesn't support temperature
> +		 * and undervoltage alarms.
> +		 */
> +		if (id == 0)
> +			return 0;

I'm not sure I understand what you're doing here. The two ports of the chip
are separate PHY's on individual MDIO bus addresses?
Reading the PHY ID registers here seems to repeat what phylib did already
to populate phydev->phy_id. If port 1 has PHD ID 0 then the driver wouldn't
bind and tja11xx_probe() would never be called (see phy_bus_match)

> +	}
> +
>  	priv->hwmon_name = devm_kstrdup(dev, dev_name(dev), GFP_KERNEL);
>  	if (!priv->hwmon_name)
>  		return -ENOMEM;
> @@ -385,6 +412,21 @@ static struct phy_driver tja11xx_driver[] = {
>  		.get_sset_count = tja11xx_get_sset_count,
>  		.get_strings	= tja11xx_get_strings,
>  		.get_stats	= tja11xx_get_stats,
> +	}, {
> +		PHY_ID_MATCH_MODEL(PHY_ID_TJA1102),
> +		.name		= "NXP TJA1102",
> +		.features       = PHY_BASIC_T1_FEATURES,
> +		.probe		= tja11xx_probe,
> +		.soft_reset	= tja11xx_soft_reset,
> +		.config_init	= tja11xx_config_init,
> +		.read_status	= tja11xx_read_status,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.set_loopback   = genphy_loopback,
> +		/* Statistics */
> +		.get_sset_count = tja11xx_get_sset_count,
> +		.get_strings	= tja11xx_get_strings,
> +		.get_stats	= tja11xx_get_stats,
>  	}
>  };
>  
> @@ -393,6 +435,7 @@ module_phy_driver(tja11xx_driver);
>  static struct mdio_device_id __maybe_unused tja11xx_tbl[] = {
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1100) },
>  	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1101) },
> +	{ PHY_ID_MATCH_MODEL(PHY_ID_TJA1102) },
>  	{ }
>  };
>  
> 

