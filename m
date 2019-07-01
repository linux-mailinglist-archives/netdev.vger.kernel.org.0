Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2EA5C48F
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 22:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727069AbfGAUuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 16:50:00 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41504 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726668AbfGAUt4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 16:49:56 -0400
Received: by mail-wr1-f66.google.com with SMTP id c2so15277776wrm.8;
        Mon, 01 Jul 2019 13:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VCmoEt1Ue1y9VkurCH5AlBvlPQd2obDODoXHcT2LGG0=;
        b=CHsJ7O6YLTSUGTp2J3n+RvMgjHGbg5/obunCB+5VwvEmMTNfEoU6Q2wlo5JiuHaYs7
         TbIHOxmdSqjYRn55hMHjghl99GOhyvHAENwkmfKPV3LtWNTYMLr7fhC1Ts/T3R1dHnnc
         c7XttDkysklUMw0ZJxGhfSavkE7ewMFaJ2sTE9rvb6RD+FyABkH8T0DBFxWkum+yY6JZ
         UOm+K7PKxRzNMLj70njilPA4O1FnPcNnL1p9DpuEkSZRl/aygYfhaPxyR/iHnAxEyu00
         YUsHqPYX2CM2PtK1KuTwb8GmLT6/f8ZBgIRMHc5LQAF9LryuQ5mpdAg5Xsjh+YlH2CVi
         zW7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VCmoEt1Ue1y9VkurCH5AlBvlPQd2obDODoXHcT2LGG0=;
        b=o9VNRckj058ir4gEsxmpkVvyWt9PfdZ4QSlFOy3ia30E1nnByNSFdja3NKi6cg9DYt
         7g3qzylYj/Vq91EjAAsDMFn27rAypDkEkONm/XyYbPOJw1J5OEH9WNutLsKSOakp0XbG
         UvV/oWH+4+BS2y8LBF9MQwD+o2V+5/bE2CnZyjkCe7AhLlNJ9p39ZQuwgeUWFt8u3gW+
         UbhL+Fi0MhsdJ67GghYYOPdIKLow3sxecVBCRA8FPxnRJmRy1RAu0nUUTPgQECke7FQn
         DXgpBJbDbPtYjMS/frx3te8sX5RSA7/1ERaXqUWHO0k/esgXX7BQ0ofj3xnXiuybXV7a
         WnUA==
X-Gm-Message-State: APjAAAUCOMyG2NI8xuzYqM+UlwdYpszmymQF0ToO8LG6gt/rz9+g69rV
        q8aMSPSu8SfxteMqQgBFtMI=
X-Google-Smtp-Source: APXvYqxkqei9VSIPX35xxH8p1rMZtfavI1wFWFMsnUfB/NPJ9thE/Pbhcwi2N+SAWWi4UxxMf+ZUxw==
X-Received: by 2002:a5d:5752:: with SMTP id q18mr14958894wrw.337.1562014194231;
        Mon, 01 Jul 2019 13:49:54 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc? (p200300EA8BD60C008DAC9AD2A34C33BC.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:8dac:9ad2:a34c:33bc])
        by smtp.googlemail.com with ESMTPSA id i188sm892976wma.27.2019.07.01.13.49.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 13:49:53 -0700 (PDT)
Subject: Re: [PATCH 3/3] net: phy: realtek: Support SSC for the RTL8211E
To:     Matthias Kaehlcke <mka@chromium.org>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-3-mka@chromium.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8adbb2b8-6747-b876-f85d-75e54f1978cb@gmail.com>
Date:   Mon, 1 Jul 2019 22:49:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190701195225.120808-3-mka@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.2019 21:52, Matthias Kaehlcke wrote:
> By default Spread-Spectrum Clocking (SSC) is disabled on the RTL8211E.
> Enable it if the device tree property 'realtek,enable-ssc' exists.
> 
> Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> ---
>  drivers/net/phy/realtek.c | 27 ++++++++++++++++++++++++---
>  1 file changed, 24 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> index dfc2e20ef335..b617169ccc8c 100644
> --- a/drivers/net/phy/realtek.c
> +++ b/drivers/net/phy/realtek.c
> @@ -9,8 +9,10 @@
>   * Copyright (c) 2004 Freescale Semiconductor, Inc.
>   */
>  #include <linux/bitops.h>
> -#include <linux/phy.h>
> +#include <linux/device.h>
> +#include <linux/of.h>
>  #include <linux/module.h>
> +#include <linux/phy.h>
>  
>  #define RTL821x_PHYSR				0x11
>  #define RTL821x_PHYSR_DUPLEX			BIT(13)
> @@ -28,6 +30,8 @@
>  
>  #define RTL8211E_EXT_PAGE			7
>  #define RTL8211E_EPAGSR				0x1e
> +#define RTL8211E_SCR				0x1a
> +#define RTL8211E_SCR_DISABLE_RXC_SSC		BIT(2)
>  
>  #define RTL8211F_INSR				0x1d
>  
> @@ -87,8 +91,8 @@ static int rtl821e_restore_page(struct phy_device *phydev, int oldpage, int ret)
>  	return ret;
>  }
>  
> -static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
> -				    int page, u32 regnum, u16 mask, u16 set)
> +static int rtl8211e_modify_ext_paged(struct phy_device *phydev, int page,
> +				     u32 regnum, u16 mask, u16 set)
>  {
>  	int ret = 0;
>  	int oldpage;
> @@ -114,6 +118,22 @@ static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
>  	return rtl821e_restore_page(phydev, oldpage, ret);
>  }
>  
> +static int rtl8211e_probe(struct phy_device *phydev)
> +{
> +	struct device *dev = &phydev->mdio.dev;
> +	int err;
> +
> +	if (of_property_read_bool(dev->of_node, "realtek,enable-ssc")) {
> +		err = rtl8211e_modify_ext_paged(phydev, 0xa0, RTL8211E_SCR,
> +						RTL8211E_SCR_DISABLE_RXC_SSC,
> +						0);
> +		if (err)
> +			dev_err(dev, "failed to enable SSC on RXC: %d\n", err);
> +	}
> +
> +	return 0;
> +}
> +
>  static int rtl8201_ack_interrupt(struct phy_device *phydev)
>  {
>  	int err;
> @@ -372,6 +392,7 @@ static struct phy_driver realtek_drvs[] = {
>  		.config_init	= &rtl8211e_config_init,
>  		.ack_interrupt	= &rtl821x_ack_interrupt,
>  		.config_intr	= &rtl8211e_config_intr,
> +		.probe          = rtl8211e_probe,

I'm not sure whether this setting survives soft reset and power-down.
Maybe it should be better applied in the config_init callback.

>  		.suspend	= genphy_suspend,
>  		.resume		= genphy_resume,
>  		.read_page	= rtl821x_read_page,
> 
