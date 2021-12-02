Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92A1466B70
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 22:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356170AbhLBVQ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 16:16:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243377AbhLBVQ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 16:16:26 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10F64C06174A;
        Thu,  2 Dec 2021 13:13:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id z5so3306536edd.3;
        Thu, 02 Dec 2021 13:13:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CosSd+cgUcNUiaY0hs7VW9skwmiaGD8L6mDXn30jLrE=;
        b=JdXG6rsH5kxSnasrKVMg86W+ysQD/1JwF4sgOtgQREvDvaiw5rfW6E/IchkwkJeOFH
         svKXqSr3i91JLZZzugdUqIPapjn13w7Ov/bo36TeHD8r1wYC6mwz3/np/TdjS1LFLp7L
         AXBYuO34jZsl6JpNILpjmr7zQX3v0gyAVG5MdTGdZORF7Y049BAgyD/6mmtBdnc6fXsD
         QaqA8YEJAdi89KP3Ib1u3Ss5umfkF9rY9w3mDk3yv/bLXbkFO2V92E0nPKoH/AGcM7WB
         BKo/Dd4FAe0inxeZSVNtaMvKSdc6ly8E6VqabSp7ZtRyQ1EWQf/Z3vSO/T8JunoHZ5vR
         QZuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CosSd+cgUcNUiaY0hs7VW9skwmiaGD8L6mDXn30jLrE=;
        b=HCTTBqvRpUnoB98fz/WG/tLBggZeHgKtT1GQJBl9gHvVXtrtOHzQK5iJettVrDNXk8
         Q2n/J8Z2Lw104AeRvy+nVGqpybjHWbnWkTcTUPi+O6Fykq44UrSJsmBgNkAwCJORlg8v
         Z1LABZzWzwE6SVfmNFKSHVgzCm8bdpOOlq4u7LTOtAqGR+hTB1o2CQeH6pnXIRuCU8/C
         t9z3erTnfDoF+/yHQcCFgkE7wdQMMAM8rcg63R6geSlVlxJ7r9xAtyI9FwLGGew0hCac
         4h//mhm5Rda+g//+8D/W7PqPdfhJ6Torq6mHzT7u7eXFy9fn04vZC9xlBydmQBXWt/Tb
         0VvA==
X-Gm-Message-State: AOAM532weJV8cI2I1LNpcdw68WY7laLhQRZSnX9rqaHvVc/Y6AZd9sM0
        mV8RTCuY0OaYhDRWGarwa9Q=
X-Google-Smtp-Source: ABdhPJwx6u0YDT9Q5iFGmV1UgIGHGbcKO1BBHb/CW6Gku0y4F30OzcH6F/wEO+rS4b4N4yi9ocfkdA==
X-Received: by 2002:a17:907:3f83:: with SMTP id hr3mr18410051ejc.555.1638479581662;
        Thu, 02 Dec 2021 13:13:01 -0800 (PST)
Received: from skbuf ([188.25.173.50])
        by smtp.gmail.com with ESMTPSA id gs15sm625863ejc.42.2021.12.02.13.13.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 13:13:01 -0800 (PST)
Date:   Thu, 2 Dec 2021 23:12:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v1 1/1] net: dsa: vsc73xxx: Get rid of duplicate of_node
 assignment
Message-ID: <20211202211259.qzdg3zs7lkjbykhn@skbuf>
References: <20211202210029.77466-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202210029.77466-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 02, 2021 at 11:00:29PM +0200, Andy Shevchenko wrote:
> GPIO library does copy the of_node from the parent device of
> the GPIO chip, there is no need to repeat this in the individual
> drivers. Remove assignment here.
> 
> For the details one may look into the of_gpio_dev_init() implementation.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/net/dsa/vitesse-vsc73xx-core.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/vitesse-vsc73xx-core.c b/drivers/net/dsa/vitesse-vsc73xx-core.c
> index 4c18f619ec02..ae55167ce0a6 100644
> --- a/drivers/net/dsa/vitesse-vsc73xx-core.c
> +++ b/drivers/net/dsa/vitesse-vsc73xx-core.c
> @@ -1122,9 +1122,6 @@ static int vsc73xx_gpio_probe(struct vsc73xx *vsc)
>  	vsc->gc.ngpio = 4;
>  	vsc->gc.owner = THIS_MODULE;
>  	vsc->gc.parent = vsc->dev;
> -#if IS_ENABLED(CONFIG_OF_GPIO)
> -	vsc->gc.of_node = vsc->dev->of_node;
> -#endif
>  	vsc->gc.base = -1;
>  	vsc->gc.get = vsc73xx_gpio_get;
>  	vsc->gc.set = vsc73xx_gpio_set;
> -- 
> 2.33.0
> 

I'm in To: and everyone else is in Cc? I don't even have the hardware.
Adding Linus just in case, although the change seems correct.

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
