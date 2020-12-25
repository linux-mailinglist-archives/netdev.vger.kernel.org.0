Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A772E2BF9
	for <lists+netdev@lfdr.de>; Fri, 25 Dec 2020 18:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgLYRJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Dec 2020 12:09:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725856AbgLYRJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Dec 2020 12:09:10 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C53C061573
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 09:08:30 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id lt17so6787634ejb.3
        for <netdev@vger.kernel.org>; Fri, 25 Dec 2020 09:08:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rYP1O8K5SsQ9FCv0gq+YuTqkohWzCkxa+DwnvyAasc8=;
        b=STeluDTRfGm2RNZuU9LFUCxitJ8N0gU6e8FZT+qEg/3yp9wfWF0kJo0OgF5bxFApGC
         oe2yl9+J6wPi+voDGIceXpE3FVQAQnocLfhGUnAM3ukgXL8mRh4MVT+kxyuRMcg6iioT
         Wg8BIXSRz2hFBkohAwUGYCP1RSmpP9492F1rexDGTvn8Z0su82eD2NuweKBp0QEIVttF
         rQZqvEDNoyJTULqjUhxg730RZzgzsFA5LrXn1NV2wWGzV9eCHyEtnWWAD3XTIWeaybDA
         dESQUW0ZY+kQCOxfM1M1GDzuDJgWRIkPN3J6P1Dbh6onDZ75IGqvYUEB547ECDagFYDX
         /SEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rYP1O8K5SsQ9FCv0gq+YuTqkohWzCkxa+DwnvyAasc8=;
        b=RfslBXEha7E3TazUg49nO6Ojgbku7T2JnjT8DDdTQUkxjEo8uNRklt5UqHcZg1SqSR
         wUUN6wEvYnH7HnrHxJmGzoJwYJ16kJZ+n0KqCNmwfpHX24uCCG2VSmHwvl3GfyVWH0Y2
         yLs1TCobt1fzmKc59P+3+NYbXDhYROrAK3B1NCmYFvyfHAuYjVcsKRwzaW1VfH8pxh9P
         Oo4rkz1U/GB3ih4Q7CL6PkL4Tzje5u+WfmfsdmvTfRXlk7ML77yac6qMfn4fSpZjhdgG
         TuhhvYltxLGSoC5uUxjNoI3Y/f6tdKEvDN4jLl/fVrz0R3xeZ4AEm0+Tnsy638m1wIOJ
         /tow==
X-Gm-Message-State: AOAM531bRWsVRxFm4MBMypQvugpV8dJslTyx6nOTJCufPBJJviLeM+ne
        4ZLQ3tG1VUug0Bu1ItDDpm0=
X-Google-Smtp-Source: ABdhPJwd904M/K2z7Op3GNxTcjs0iSTCg5c7NTTrFgYDchbXAQM+9YQUa4dg5dVolQJiTt4wgfJRPQ==
X-Received: by 2002:a17:906:591a:: with SMTP id h26mr31771152ejq.174.1608916108943;
        Fri, 25 Dec 2020 09:08:28 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:ad53:85a4:d62:cc8c? (p200300ea8f065500ad5385a40d62cc8c.dip0.t-ipconnect.de. [2003:ea:8f06:5500:ad53:85a4:d62:cc8c])
        by smtp.googlemail.com with ESMTPSA id a2sm6984687ejt.46.2020.12.25.09.08.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Dec 2020 09:08:28 -0800 (PST)
Subject: Re: [PATCH] net: phy: realtek: Add support for RTL9000AA/AN
To:     Yuusuke Ashizuka <ashiduka@fujitsu.com>, andrew@lunn.ch,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, torii.ken1@fujitsu.com
References: <20201225004751.26075-1-ashiduka@fujitsu.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d9bb2855-e9a1-239f-b1cd-2be8294f357a@gmail.com>
Date:   Fri, 25 Dec 2020 18:08:24 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201225004751.26075-1-ashiduka@fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.12.2020 01:47, Yuusuke Ashizuka wrote:
> RTL9000AA/AN as 100BASE-T1 is following:
> - 100 Mbps
> - Full duplex
> - Link Status Change Interrupt
> 
> Signed-off-by: Yuusuke Ashizuka <ashiduka@fujitsu.com>
> Signed-off-by: Torii Kenichi <torii.ken1@fujitsu.com>
> ---
>  drivers/net/phy/realtek.c | 51 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 51 insertions(+)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index 575580d3ffe0..ccd3368ba14e 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -54,6 +54,9 @@
>  #define RTL_LPADV_5000FULL			BIT(6)
>  #define RTL_LPADV_2500FULL			BIT(5)
>  
> +#define RTL9000A_GINMR				0x14
> +#define RTL9000A_GINMR_LINK_STATUS		BIT(4)
> +
>  #define RTLGEN_SPEED_MASK			0x0630
>  
>  #define RTL_GENERIC_PHYID			0x001cc800
> @@ -547,6 +550,41 @@ static int rtlgen_resume(struct phy_device *phydev)
>  	return ret;
>  }
>  
> +static int rtl9000a_config_init(struct phy_device *phydev)
> +{
> +	phydev->autoneg = AUTONEG_DISABLE;
> +	phydev->speed = SPEED_100;
> +	phydev->duplex = DUPLEX_FULL;
> +
> +	return 0;
> +}
> +
> +static int rtl9000a_config_aneg(struct phy_device *phydev)
> +{
> +	return 0;
> +}
> +
> +static int rtl9000a_ack_interrupt(struct phy_device *phydev)
> +{
> +	int err;
> +
> +	err = phy_read(phydev, RTL8211F_INSR);
> +
> +	return (err < 0) ? err : 0;
> +}
> +
> +static int rtl9000a_config_intr(struct phy_device *phydev)
> +{
> +	u16 val;
> +
> +	if (phydev->interrupts == PHY_INTERRUPT_ENABLED)
> +		val = (u16)~RTL9000A_GINMR_LINK_STATUS;
> +	else
> +		val = ~0;
> +
> +	return phy_write_paged(phydev, 0xa42, RTL9000A_GINMR, val);
> +}
> +
>  static struct phy_driver realtek_drvs[] = {
>  	{
>  		PHY_ID_MATCH_EXACT(0x00008201),
> @@ -674,6 +712,19 @@ static struct phy_driver realtek_drvs[] = {
>  		.config_intr	= genphy_no_config_intr,
>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
> +	}, {
> +		PHY_ID_MATCH_EXACT(0x001ccb00),
> +		.name		= "RTL9000AA/AN Ethernet",

Better don't use a slash in the name. This breaks usage of sysfs:
/sys/bus/mdio_bus/drivers/<driver_name>

> +		.features       = PHY_BASIC_T1_FEATURES,
> +		.config_init	= rtl9000a_config_init,
> +		.config_aneg	= rtl9000a_config_aneg,
> +		.read_status	= genphy_update_link,
> +		.ack_interrupt	= rtl9000a_ack_interrupt,
> +		.config_intr	= rtl9000a_config_intr,
> +		.suspend	= genphy_suspend,
> +		.resume		= genphy_resume,
> +		.read_page	= rtl821x_read_page,
> +		.write_page	= rtl821x_write_page,
>  	},
>  };
>  
> 

