Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45F592CEA3
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 20:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfE1S3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 14:29:21 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:47004 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726569AbfE1S3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 14:29:21 -0400
Received: by mail-wr1-f66.google.com with SMTP id r7so21305565wrr.13;
        Tue, 28 May 2019 11:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8/KI1KE9vJDVwWIzxwQAdItZoUFzUqcama4dTdkeOyw=;
        b=bcTNpSygNEs0fNzp/eABcU7RsnTiioHBYXh/JTk+tLpqz+IKX9SNZgovBcKl0hmtn7
         uM8BLeTxAjZZW1KR8hPb2TpB3kjexalPYqosLG31WNaG91j1fvIHUjAcl/rGEzAqciF9
         azYJQcENFfYycfghAmSzgt0HUBofMyDS18U2ZHClVauS3JktwmF45Z5rJ/fNYiRy/6b3
         F56r/rC3Jnk9xEILHTjQZCNFDSQciQlfWR6GdMPH+nRIsn8n7wKmIOHlPcNOGBw6kBOY
         tE7QZ4Fx55nipkv1qrkKxH8UUeLiltzuOlFGU2SZUGpjc8YpSGV244/bCmKd4vZl6APy
         BWUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8/KI1KE9vJDVwWIzxwQAdItZoUFzUqcama4dTdkeOyw=;
        b=JpB5pu4SjaIeGm4zt7dkf3cEQHwNFwewSTJRcXi5Taax36XrD1O23nfxB9leS3B5Nd
         MrdIklCM2Pxfj7gEKq9C9/dYV5AGzzWoDnV+kg0DhpjAwoHCkETq2IHu1H+dS3bvL7ia
         JklmlJitdAbUgQ9bTC0T/a6KIX2BdwXl6oqlrDyE4q8Eat/0eMVXNm1JE0ppEWatmlC+
         k07+JYHhFEFGi59k/nTEiw+MpzdxWs1BG3mlfPNvRynfMprxKL9QLXtC0vvyVHSLO8u4
         1Bk2S8KUoWfht4rzlfK2e4mw0NFXvDSzbf3khnXaCwpamct62YBep1cvbIX9mKgeS2PY
         17Jw==
X-Gm-Message-State: APjAAAWTGBhq8/1B4m4X1F3+01ASFkf2g/0JKFeip7k/9j5NM2604RaB
        90dleDZ97E0M2iM+lWpna3f4ahnd
X-Google-Smtp-Source: APXvYqx2AIjaQbAwpPFU5w7qSZltqNiaYo3dL08nZ1i485RNpBp9vhMQ5npGdI2XP2S0XPccIFKxWw==
X-Received: by 2002:adf:ed44:: with SMTP id u4mr19340753wro.242.1559068159212;
        Tue, 28 May 2019 11:29:19 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137? (p200300EA8BF3BD00FCC33D8B511A9137.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:fcc3:3d8b:511a:9137])
        by smtp.googlemail.com with ESMTPSA id t4sm2215938wmi.41.2019.05.28.11.29.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 11:29:18 -0700 (PDT)
Subject: Re: [PATCH] net: phy: tja11xx: Add IRQ support to the driver
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Jean Delvare <jdelvare@suse.com>, linux-hwmon@vger.kernel.org
References: <20190528181616.2019-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1768acfc-ed20-68d3-12a0-1e5bfb7b31a3@gmail.com>
Date:   Tue, 28 May 2019 20:29:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190528181616.2019-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28.05.2019 20:16, Marek Vasut wrote:
> Add support for handling the TJA11xx PHY IRQ signal.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Jean Delvare <jdelvare@suse.com>
> Cc: linux-hwmon@vger.kernel.org
> ---
>  drivers/net/phy/nxp-tja11xx.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/net/phy/nxp-tja11xx.c b/drivers/net/phy/nxp-tja11xx.c
> index b705d0bd798b..0be9fe9a9604 100644
> --- a/drivers/net/phy/nxp-tja11xx.c
> +++ b/drivers/net/phy/nxp-tja11xx.c
> @@ -40,6 +40,8 @@
>  #define MII_INTSRC_TEMP_ERR		BIT(1)
>  #define MII_INTSRC_UV_ERR		BIT(3)
>  
> +#define MII_INTEN			22
> +
>  #define MII_COMMSTAT			23
>  #define MII_COMMSTAT_LINK_UP		BIT(15)
>  
> @@ -239,6 +241,30 @@ static int tja11xx_read_status(struct phy_device *phydev)
>  	return 0;
>  }
>  
> +static int tja11xx_config_intr(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		ret = phy_write(phydev, MII_INTEN, 0xcfef);

As Florian commented already, such magic numbers are not nice.
Better add a constant for each bit representing an interrupt
source. Please note that phylib is interested in the link
change event only. Therefore typically only one bit is set.

> +	else
> +		ret = phy_write(phydev, MII_INTEN, 0);
> +
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = phy_read(phydev, MII_INTSRC);
> +

This IRQ ACK can be removed. It's done by phylib, see
phy_enable_interrupts().

> +	return ret < 0 ? ret : 0;
> +}
> +
> +static int tja11xx_ack_interrupt(struct phy_device *phydev)
> +{
> +	int ret = phy_read(phydev, MII_INTSRC);
> +
> +	return ret < 0 ? ret : 0;
> +}
> +
>  static int tja11xx_get_sset_count(struct phy_device *phydev)
>  {
>  	return ARRAY_SIZE(tja11xx_hw_stats);
> @@ -366,6 +392,9 @@ static struct phy_driver tja11xx_driver[] = {
>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
>  		.set_loopback   = genphy_loopback,
> +		/* IRQ related */
> +		.config_intr	= tja11xx_config_intr,
> +		.ack_interrupt	= tja11xx_ack_interrupt,
>  		/* Statistics */
>  		.get_sset_count = tja11xx_get_sset_count,
>  		.get_strings	= tja11xx_get_strings,
> @@ -381,6 +410,9 @@ static struct phy_driver tja11xx_driver[] = {
>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
>  		.set_loopback   = genphy_loopback,
> +		/* IRQ related */
> +		.config_intr	= tja11xx_config_intr,
> +		.ack_interrupt	= tja11xx_ack_interrupt,
>  		/* Statistics */
>  		.get_sset_count = tja11xx_get_sset_count,
>  		.get_strings	= tja11xx_get_strings,
> 

