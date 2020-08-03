Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A7EE23AC31
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728369AbgHCSOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCSOQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:14:16 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8A3C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:14:16 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id t14so476171wmi.3
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 11:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8c5Ikd0qB9ECVzzHb38FC9+NAoMRJCBAWo95l6Hmxac=;
        b=PmN4m1BSEBW9XqQW0SdYzQdE+qa4uvLWeOT41eBVFQg2avlPZ6T2IDQvOl7fNty/Gf
         RFC0m5eipM5YK999uAGTjvPdra9NHiJKaVFk6KqCACAUwVeDFfd2KUwkUY3syykXKxpv
         P/g4nB9zat09OVuRINhcWi5ZUDf7ZRxRnaSLcq17aeciFibhRROWAd4rBPZqcmsyR+co
         c7X0tMnrvaKaJBLH/gH35ZeTliHqaiRKfBeDJ9OZgVNy0opowIut5ySa0anZG4FieMZT
         DEIK0wCr8VcIDbizWPRdE+EkNwjPAtDZlWD0kUiqm+Eo+2867EjaqrYBtru68VAq/YNr
         O/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8c5Ikd0qB9ECVzzHb38FC9+NAoMRJCBAWo95l6Hmxac=;
        b=RYFyWgo5yaFhk5Fj77IQLpktiH7JZOHcjiW4nY0eRDsyk81IvwKJIQNa/maQadGP2c
         QiibususcU2gvibPi8ChJWIcXuEF3Q+mhSafV4Os+M5mE2M+8Sp4h+eukk6H5MjdG49h
         O8Xl56MHZmjzYlF61PMywRRfohXWXXBW4wkEBCG5rqTXY/daEOgo6sV/JHBbJOOw1E4M
         /u4ugL1HNwxeDHl7cxPc9gTFPCtiZuDMIjrWyXckznYR7CshURPzffQgtzZXkT+ZPShW
         3ILS8nfGSFSoq3x7HHfv60sfcDBkKxJI/MGcaxDa0u8JD2FKsTmbENKQrni2aYPrFS7h
         7VCA==
X-Gm-Message-State: AOAM531T+BzbJHWBgPi562P66bJR8QTqhhV46QNlWZLqXv/w7nes4OBp
        qkc3k/1tbSf3QHW4Eb9fIM4=
X-Google-Smtp-Source: ABdhPJxmd9sqMTpdrP/afCyxFaN9ifJUsHFhbnUL/BHbH8txfml/Oh0ANbW4zyDlFY9KxoISZY+E4g==
X-Received: by 2002:a1c:7315:: with SMTP id d21mr406513wmb.108.1596478455131;
        Mon, 03 Aug 2020 11:14:15 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g145sm1038589wmg.23.2020.08.03.11.14.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 11:14:14 -0700 (PDT)
Subject: Re: [PATCH v4 10/11] net: dsa: microchip: Add Microchip KSZ8863 SPI
 based driver support
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>, andrew@lunn.ch
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kernel@pengutronix.de
References: <20200803054442.20089-1-m.grzeschik@pengutronix.de>
 <20200803054442.20089-11-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9de1dad0-64b3-1e66-fb13-9800fd6b71e7@gmail.com>
Date:   Mon, 3 Aug 2020 11:14:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200803054442.20089-11-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/2/2020 10:44 PM, Michael Grzeschik wrote:
> Add KSZ88X3 driver support. We add support for the KXZ88X3 three port
> switches using the SPI Interface.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> ---
> v1 -> v2: - this glue was not implemented
> v2 -> v3: - this glue was part of previous bigger patch
> v3 -> v4: - this glue was moved to this separate patch
> 
>  drivers/net/dsa/microchip/ksz8795_spi.c | 62 ++++++++++++++++++-------
>  1 file changed, 45 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz8795_spi.c b/drivers/net/dsa/microchip/ksz8795_spi.c
> index 3bab09c46f6a7bd..d13a83c27428cdc 100644
> --- a/drivers/net/dsa/microchip/ksz8795_spi.c
> +++ b/drivers/net/dsa/microchip/ksz8795_spi.c
> @@ -14,34 +14,70 @@
>  #include <linux/regmap.h>
>  #include <linux/spi/spi.h>
>  
> +#include "ksz8.h"
>  #include "ksz_common.h"
>  
> -#define SPI_ADDR_SHIFT			12
> -#define SPI_ADDR_ALIGN			3
> -#define SPI_TURNAROUND_SHIFT		1
> +#define KSZ8795_SPI_ADDR_SHIFT			12
> +#define KSZ8795_SPI_ADDR_ALIGN			3
> +#define KSZ8795_SPI_TURNAROUND_SHIFT		1
>  
> -KSZ_REGMAP_TABLE(ksz8795, 16, SPI_ADDR_SHIFT,
> -		 SPI_TURNAROUND_SHIFT, SPI_ADDR_ALIGN);
> +#define KSZ8863_SPI_ADDR_SHIFT			8
> +#define KSZ8863_SPI_ADDR_ALIGN			8
> +#define KSZ8863_SPI_TURNAROUND_SHIFT		0
> +
> +KSZ_REGMAP_TABLE(ksz8795, 16, KSZ8795_SPI_ADDR_SHIFT,
> +		 KSZ8795_SPI_TURNAROUND_SHIFT, KSZ8795_SPI_ADDR_ALIGN);
> +
> +KSZ_REGMAP_TABLE(ksz8863, 16, KSZ8863_SPI_ADDR_SHIFT,
> +		 KSZ8863_SPI_TURNAROUND_SHIFT, KSZ8863_SPI_ADDR_ALIGN);

You could fancy a macro that does all of the above, and takes a name and
a model as argument, up to you.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
