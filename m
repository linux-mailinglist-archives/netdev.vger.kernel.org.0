Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB6A5ED4B
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 22:15:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbfGCUOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 16:14:48 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:38241 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726581AbfGCUOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 16:14:47 -0400
Received: by mail-wm1-f65.google.com with SMTP id s15so3711417wmj.3;
        Wed, 03 Jul 2019 13:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KGRGCWyzALDC/wgl3gDRBe1xns6oSqRLv+D34iEHye0=;
        b=pjpkaCb85EinJW0a5vQs5C55nMP34arf7Ry/cbJ4A1kpNzLP3w8c984F//IjnMupU2
         mJC5sWeuPUcfZOa/0biCUTBEv9ZYtzIgpH+pKDCA7CuSr6qjm70ZZQTgMXDbFqqvTtyE
         tE7Gp7a0yt2Wtfhqtzyuw1O8q8FWsdwKsi85JHWioENvRgxup/Q4TMuogpjPD2uEitbK
         6H6+iSSpBB+mFP2wrHabAs7mhlCh4qb7kiJAq//1wzOqDz4aH/Q2PMi9PA4eOharURdi
         DU6O+TgkH1ICpdw7Q5T02bo4oTFXN9poJuhnaRj0Rrmw1t+PPjbzO4Z/ntZ2QeLDjldS
         QiPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KGRGCWyzALDC/wgl3gDRBe1xns6oSqRLv+D34iEHye0=;
        b=B3h+QCATovrlNsOFBmL8jhC4taWEoMjilufPz69hrUaskgGJteSrM0GLjOtMTkd8+Z
         gqWUZs0eWe826JmD0v82cMmyehZrlzOfM3p9E4ZBlOEAGt58hno9b5EGw+nbQcBCLIv6
         mQn83yRwDJ5USBkLawP8vQzi2hBARDTigXM/Yn2tngQk6KVwqDR2RNqTJKyNf8ADWhWK
         /gHHz18HseHU20kLZJtzWmnSgJrn9VjL1YylZXWNNf9FLozEGuq92BMSFJYLk5jRwEtw
         FtgGmBGGHO22EyQY6GNEL9f4WvMkQ1Qd2LTCWxarCNsq3Ey3wR6V9acN+xSXAHu3huqn
         jHSQ==
X-Gm-Message-State: APjAAAURNuA03kFe0eKtIldyqXOG1k1wUA/PAjhdCDt+veJ/bNpbaG6C
        S8BlJJPN4Hgveda/NCCgM8B9AFvq
X-Google-Smtp-Source: APXvYqxKIv2erFklghRAxLVhTS8uHe6icyW/Gq6R7uuo19PCXRq5akB6xCsRa2oNl+VWfhZiY8YwnQ==
X-Received: by 2002:a7b:ce88:: with SMTP id q8mr9346411wmj.89.1562184884981;
        Wed, 03 Jul 2019 13:14:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:4503:872e:8227:c4e0? (p200300EA8BD60C004503872E8227C4E0.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:4503:872e:8227:c4e0])
        by smtp.googlemail.com with ESMTPSA id a67sm3840405wmh.40.2019.07.03.13.14.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 13:14:44 -0700 (PDT)
Subject: Re: [PATCH v2 2/7] net: phy: realtek: Allow disabling RTL8211E EEE
 LED mode
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-2-mka@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <743dda1b-532d-175f-1f87-5d80ba4a2e94@gmail.com>
Date:   Wed, 3 Jul 2019 22:09:39 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190703193724.246854-2-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.07.2019 21:37, Matthias Kaehlcke wrote:
> EEE LED mode is enabled by default on the RTL8211E. Disable it when
> the device tree property 'realtek,eee-led-mode-disable' exists.
> 
> The magic values to disable EEE LED mode were taken from the RTL8211E
> datasheet, unfortunately they are not further documented.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
> Changes in v2:
> - patch added to the series
> ---
>  drivers/net/phy/realtek.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index a669945eb829..eb815cbe1e72 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -9,8 +9,9 @@
>   * Copyright (c) 2004 Freescale Semiconductor, Inc.
>   */
>  #include <linux/bitops.h>
> -#include <linux/phy.h>
>  #include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/phy.h>
>  
>  #define RTL821x_PHYSR				0x11
>  #define RTL821x_PHYSR_DUPLEX			BIT(13)
> @@ -26,6 +27,10 @@
>  #define RTL821x_EXT_PAGE_SELECT			0x1e
>  #define RTL821x_PAGE_SELECT			0x1f
>  
> +/* RTL8211E page 5 */
> +#define RTL8211E_EEE_LED_MODE1			0x05
> +#define RTL8211E_EEE_LED_MODE2			0x06
> +
>  #define RTL8211F_INSR				0x1d
>  
>  #define RTL8211F_TX_DELAY			BIT(8)
> @@ -53,6 +58,35 @@ static int rtl821x_write_page(struct phy_device *phydev, int page)
>  	return __phy_write(phydev, RTL821x_PAGE_SELECT, page);
>  }
>  
> +static int rtl8211e_disable_eee_led_mode(struct phy_device *phydev)
> +{

You define return type int but AFAICS the return value is never used,
also in subsequent patches.

> +	int ret = 0;
> +	int oldpage;
> +
> +	oldpage = phy_select_page(phydev, 5);
> +	if (oldpage < 0)
> +		goto out;
> +
> +	/* write magic values to disable EEE LED mode */
> +	ret = __phy_write(phydev, RTL8211E_EEE_LED_MODE1, 0x8b82);
> +	if (ret)
> +		goto out;
> +
> +	ret = __phy_write(phydev, RTL8211E_EEE_LED_MODE2, 0x052b);
> +
> +out:
> +	return phy_restore_page(phydev, oldpage, ret);
> +}
> +
> +static int rtl8211e_config_init(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +
> +	if (of_property_read_bool(dev->of_node, "realtek,eee-led-mode-disable"))
> +		rtl8211e_disable_eee_led_mode(phydev);
> +
> +	return 0;
> +}

I suppose checkpatch complains about the missing empty line.
You add it in a later patch, in case of a v3 you could fix that.

>  static int rtl8201_ack_interrupt(struct phy_device *phydev)
>  {
>  	int err;
> @@ -310,6 +344,7 @@ static struct phy_driver realtek_drvs[] = {
>  		.name		= "RTL8211E Gigabit Ethernet",
>  		.config_init	= &rtl8211e_config_init,
>  		.ack_interrupt	= &rtl821x_ack_interrupt,
> +		.config_init	= &rtl8211e_config_init,
>  		.config_intr	= &rtl8211e_config_intr,
>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
> 

