Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F65E2FA727
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406922AbhARRLr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405883AbhARRED (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 12:04:03 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98F06C061574;
        Mon, 18 Jan 2021 09:02:55 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id u11so4662332plg.13;
        Mon, 18 Jan 2021 09:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=RMi0PjfOyHorHYMdRo7t9epW/vdviuy6uEzyVvq9u+4=;
        b=LRjd62hcVyMhTL9rY6PIFPY4XKt8UKM/sdY5+MW6NhAdl4/kQSW06srovGCVMFIdq3
         xxfM4CNwOdrUXwdrdc87iY7ncfafwkXVEYeTRGKjmQcDnLP95EFZHfIwoSGOSDknYJfM
         seCuCSc7vOQwGCG+dIugxwZfOPvqn4Q8NwhKvN4vnOLQhz3Y7YVvX9OPyE+s8sORACM3
         pF7KwItKXsMMIrRIeRcjIqibZwg4kEAThvZXShBo4zB3VqTxmMjOqAVgIs6xD7mFfpFZ
         eLN45rGiPbz2wZONJbISDl+rjB58yyz9woWkHA9I2TJWS0z5JfKCTgjeP2e7wycJdmUI
         HIAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RMi0PjfOyHorHYMdRo7t9epW/vdviuy6uEzyVvq9u+4=;
        b=K+X2zMUlEP/N9a4P8Lzzgroh8A6WdMxKnFRmyBcDdQhgfVTOjZC76LJbLXwnoGmiLL
         KD0OQFSuFBWP0kQEDbtiy9ETnGI3PEE4kWl1raaAY/2kmWKz4dqbtQC1hSby/ztZnuVR
         Y4rFPIZHZKhwGcenfEeiYBAg0DMdJfbStkNXnOpuTwZip7VGeVlfJGE/z686caJNnHqz
         CuF5VjdJA29g/jRusVGq4red6rNAywJw9KgrVHFEkcaubmpqjkkulVd2k90V7DGWPPhv
         +dGBfNRzq8EN+YNK66lGbYknapofqeBaczcgdN+ThcBN6vZ5YXsHK+dVXtTyKsQbsIZH
         mR0w==
X-Gm-Message-State: AOAM5323LlxH0j3KQmf7g2FLbDd4klvMnwGQFOJEUGRYky1CnpvjhhbM
        Rpo5DKEWFPcfJdfDwaXEELM=
X-Google-Smtp-Source: ABdhPJwJKYDGhTTp/QXkCxFql59ZBaAjjPBqmv3KRmxIum3WjC+b+JQgkOWsZ+Cl76DADBtW8s0XkA==
X-Received: by 2002:a17:90a:430b:: with SMTP id q11mr214679pjg.51.1610989375133;
        Mon, 18 Jan 2021 09:02:55 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y67sm512560pfb.211.2021.01.18.09.02.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 09:02:54 -0800 (PST)
Subject: Re: [PATCH v4 net-next 1/5] net: phy: Add PHY_RST_AFTER_PROBE flag
To:     "Badel, Laurent" <LaurentBadel@eaton.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "marex@denx.de" <marex@denx.de>
References: <MW4PR17MB4243C51A3D1616487F201B2EDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35b89925-1fe9-0161-f007-8085942bc35b@gmail.com>
Date:   Mon, 18 Jan 2021 09:02:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <MW4PR17MB4243C51A3D1616487F201B2EDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/18/2021 8:58 AM, Badel, Laurent wrote:
> ﻿Add new flag PHY_RST_AFTER_PROBE for LAN8710/20/40. This flag is intended
> for phy_probe() to assert hardware reset after probing the PHY.
> 
> Signed-off-by: Laurent Badel <laurentbadel@eaton.com>
> ---
>  drivers/net/phy/smsc.c | 4 ++--
>  include/linux/phy.h    | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index ddb78fb4d6dc..5ee45c48efbb 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -433,7 +433,7 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.name		= "SMSC LAN8710/LAN8720",
>  
>  	/* PHY_BASIC_FEATURES */
> -
> +	.flags		= PHY_RST_AFTER_PROBE,
>  	.probe		= smsc_phy_probe,
>  	.remove		= smsc_phy_remove,
>  
> @@ -460,7 +460,7 @@ static struct phy_driver smsc_phy_driver[] = {
>  	.name		= "SMSC LAN8740",
>  
>  	/* PHY_BASIC_FEATURES */
> -	.flags		= PHY_RST_AFTER_CLK_EN,
> +	.flags		= PHY_RST_AFTER_CLK_EN & PHY_RST_AFTER_PROBE,


Not PHY_RST_AFTER_CLK_EN | PHY_RST_AFTER_PROBE?
-- 
Florian
