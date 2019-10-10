Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82F09D315C
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 21:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbfJJT0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 15:26:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40363 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbfJJT0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 15:26:49 -0400
Received: by mail-wr1-f67.google.com with SMTP id h4so9269655wrv.7
        for <netdev@vger.kernel.org>; Thu, 10 Oct 2019 12:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KMwgywPEjJ1NIlMVAnSLPurXU12bZr+yMAtH5s910wE=;
        b=PFu3FcC3SqKLnAFkKaKBYKJewkWL+41itPi7W/RDaokHcdRE6ojy1F5XpHJ8rP93I4
         U2TfzE2sBb6CVIiyDRqxnCpvzKR1g5oDRozaN5TelXjzw0nMxYxDkgM3H324FyXhLH0X
         Hj7FVlztcWExO2BCPHIs2s4lp2PNUYz1ChTg9KWDiGBK5SiXryOMEeMPr6LlalVDTKCA
         bQO/WQUb0wuSMLrte5L7QnvCHt5DOVt5iHrEOxMK9d5zaHG6c1DCJCHq6EnOPUv6dBUC
         kuO1EsRwRNmuDaBxFq7Y4lMqjkVPMqDy0UA/sRUugTiCQIoumN/sxTfodmHbD/98HIPT
         M9Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KMwgywPEjJ1NIlMVAnSLPurXU12bZr+yMAtH5s910wE=;
        b=inQYDskKH42B+5YKeNuD/MbuzlrgjVBeu1/JasTOG5opun5B4ftsE3pTFUFOTRVliR
         nUaU/LbZAo7pDukxAJiSkto9czJNR1GJ9YQ+L99K6XPaN+OSxVwsnJnltIlE7bmq89IC
         J2DEirjHGj2xgdD8E4iD3zGsdrew21pJGY1of+LeIe8ig470kLX2b3/34FU3JLJvdstA
         vZM0Au4VxRWoncGwIDCkF6eaWeX7JIJLh9JrJH+kSnnAVTCoWvkfEXz0ILGzto9SFSJR
         A/AhsgqmK75g8eZla0BfbnXYWW8qQfrX2O/tyuUlv8PGPlqC9Io+HcQubhDUo6Bd/KAA
         iffQ==
X-Gm-Message-State: APjAAAVC+doF+JTxQMHn1ZUuDLnf8KX2NvYcCoISc3lSvz3ViPQpRivJ
        VYMUBfplf/oInBed8QL4M00=
X-Google-Smtp-Source: APXvYqwJBezgNA6j3IIVtilUNECMv+bNgIhg12CpXLmD2410FkCLLmzQ638F+LiNt5tlcNZIyS17Fw==
X-Received: by 2002:a5d:6506:: with SMTP id x6mr9481544wru.366.1570735604500;
        Thu, 10 Oct 2019 12:26:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1d9e:f0ba:1c44:fdf8? (p200300EA8F2664001D9EF0BA1C44FDF8.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1d9e:f0ba:1c44:fdf8])
        by smtp.googlemail.com with ESMTPSA id x5sm10834091wrg.69.2019.10.10.12.26.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 12:26:44 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: phy: micrel: Discern KSZ8051 and KSZ8795 PHYs
To:     Marek Vasut <marex@denx.de>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        George McCollister <george.mccollister@gmail.com>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        Woojung Huh <woojung.huh@microchip.com>
References: <20191010191249.2112-1-marex@denx.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <f384c6cb-d0ad-1e63-75ad-b816478bacac@gmail.com>
Date:   Thu, 10 Oct 2019 21:26:38 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191010191249.2112-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.10.2019 21:12, Marek Vasut wrote:
> The KSZ8051 PHY and the KSZ8794/KSZ8795/KSZ8765 switch share exactly the
> same PHY ID. Since KSZ8051 is higher in the ksphy_driver[] list of PHYs
> in the micrel PHY driver, it is used even with the KSZ87xx switch. This
> is wrong, since the KSZ8051 configures registers of the PHY which are
> not present on the simplified KSZ87xx switch PHYs and misconfigures
> other registers of the KSZ87xx switch PHYs.
> 
> Fortunatelly, it is possible to tell apart the KSZ8051 PHY from the
> KSZ87xx switch by checking the Basic Status register Bit 0, which is
> read-only and indicates presence of the Extended Capability Registers.
> The KSZ8051 PHY has those registers while the KSZ87xx switch does not.
> 
> This patch implements simple check for the presence of this bit for
> both the KSZ8051 PHY and KSZ87xx switch, to let both use the correct
> PHY driver instance.
> 
> Signed-off-by: Marek Vasut <marex@denx.de>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Florian Fainelli <f.fainelli@gmail.com>
> Cc: George McCollister <george.mccollister@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Tristram Ha <Tristram.Ha@microchip.com>
> Cc: Woojung Huh <woojung.huh@microchip.com>
> ---
> NOTE: It was also suggested to populate phydev->dev_flags to discern
>       the PHY from the switch, this does not work for setups where
>       the switch is used as a PHY without a DSA driver. Checking the
>       BMSR Bit 0 for Extended Capability Register works for both DSA
>       and non-DSA usecase.
> ---
>  drivers/net/phy/micrel.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 2fea5541c35a..54d483de024f 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -341,6 +341,22 @@ static int ksz8041_config_aneg(struct phy_device *phydev)
>  	return genphy_config_aneg(phydev);
>  }
>  
> +static int ksz8051_match_phy_device(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, MII_BMSR);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* KSZ8051 PHY and KSZ8794/KSZ8795/KSZ8765 switch share the same
> +	 * exact PHY ID. However, they can be told apart by the extended
> +	 * capability registers presence. The KSZ8051 PHY has them while
> +	 * the switch does not.
> +	 */
> +	return ret & BMSR_ERCAP;

Idea and approach are right, but as-is could result in this driver
matching any (even non-Micrel) PHY devices with this bit set. You have
to check the PHY ID too. See Realtek PHY driver for an example.

> +}
> +
>  static int ksz8081_config_init(struct phy_device *phydev)
>  {
>  	/* KSZPHY_OMSO_FACTORY_TEST is set at de-assertion of the reset line
> @@ -364,6 +380,18 @@ static int ksz8061_config_init(struct phy_device *phydev)
>  	return kszphy_config_init(phydev);
>  }
>  
> +static int ksz8795_match_phy_device(struct phy_device *phydev)
> +{
> +	int ret;
> +
> +	ret = phy_read(phydev, MII_BMSR);
> +	if (ret < 0)
> +		return ret;
> +
> +	/* See comment in ksz8051_match_phy_device() for details. */
> +	return !(ret & BMSR_ERCAP);
> +}
> +
>  static int ksz9021_load_values_from_of(struct phy_device *phydev,
>  				       const struct device_node *of_node,
>  				       u16 reg,
> @@ -1029,6 +1057,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.get_sset_count = kszphy_get_sset_count,
>  	.get_strings	= kszphy_get_strings,
>  	.get_stats	= kszphy_get_stats,
> +	.match_phy_device = ksz8051_match_phy_device,

If callback match_phy_device is implemented, then you can remove
phy_id and phy_id_mask. Check phy_bus_match().

>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> @@ -1148,6 +1177,7 @@ static struct phy_driver ksphy_driver[] = {
>  	.config_init	= kszphy_config_init,
>  	.config_aneg	= ksz8873mll_config_aneg,
>  	.read_status	= ksz8873mll_read_status,
> +	.match_phy_device = ksz8795_match_phy_device,
>  	.suspend	= genphy_suspend,
>  	.resume		= genphy_resume,
>  }, {
> 

