Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 016B735FAD5
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:43:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352534AbhDNSeA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352892AbhDNSdv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 14:33:51 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8B2C061574;
        Wed, 14 Apr 2021 11:33:29 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id m18so8414723plc.13;
        Wed, 14 Apr 2021 11:33:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=rz3cawkbrnCyPjsVdycA1nMpVevT+1OVAac+Hkq3DbM=;
        b=BTvU3yuprehAQKBP9fbgte7/JLHnmHDZ1CHglPu+k0/ldlYoLkopBcL36bhuXgizyZ
         A473VN9pRA1tBT3tJaWiUr4F98igUIUvkKljUdW5CkMDShwkJWwoUH5xzhtlycXgHDnf
         J+rilmLRQiM84r/KWoBI0EMFZgDT1br9LellCMqrMuzt9Sh/Y5fa/aHGcmQu2ah28du1
         aEA2fMVnzE+HhjNzdvh7cJJmOa6doPjJC333dNHfr5jOxVC1C0Vloxgn6V8iMFPE4qiw
         77y2Tc5jslsrPc4mOko4vk34pPyg7ejIO4dOesEaiWtSgZZEgsyAH8zWQ46ChVJh0Pb0
         2Cfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rz3cawkbrnCyPjsVdycA1nMpVevT+1OVAac+Hkq3DbM=;
        b=LP7nRepEK8Bf75ty9I8W6vaHjZZZzb7kqTzZxIQTIoV08gz6h0SnXyq/1WklfSrLs8
         EqL6K6dGltYN2VuwHdk9LB9ZZkQFKapcjP4LY/6V8UskOcZubP/WKYjNjitVzKC/ygJy
         E30IQBZ08Roz9L6Vi7FhaJyDo7e7Asy6JAxUrKqEb1EoQso3sY1Dze7hbUEpVikXdmhR
         G6T6TY8flCo3UuscHM9IoksvBGFQ7S/jC9nXCMsS6b3NVy9HMv24YVXKWOT5OLmS2isf
         dlgY7XgSyV9Ih1vKlUtEV/JZvq0GFld8Lg9bzB0T1CBaoqYF4uJCwV/BJ1Xw3pyar8VB
         mK4A==
X-Gm-Message-State: AOAM532KLtqoEFzIs21DGXRsxUeIC3L1x/HNG0yTCqwWCoyxdsfY0cj+
        aJwb4FlqAejpwQ4Kab79o3eIL+7OcPA=
X-Google-Smtp-Source: ABdhPJwZJzRbIwwmyjht4i/mEAfHaQTwDGI/zYN0sofehGlMWCXnlZfnno2uK43jpAbuI0kMmv7xNw==
X-Received: by 2002:a17:902:e549:b029:e6:6b3a:49f7 with SMTP id n9-20020a170902e549b02900e66b3a49f7mr41042336plf.52.1618425208319;
        Wed, 14 Apr 2021 11:33:28 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p22sm115359pjg.39.2021.04.14.11.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Apr 2021 11:33:27 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 7/9] net: korina: Add support for device tree
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210414152946.12517-1-tsbogend@alpha.franken.de>
 <20210414152946.12517-8-tsbogend@alpha.franken.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ac7b7eb9-5208-f895-943d-3191111442e0@gmail.com>
Date:   Wed, 14 Apr 2021 11:33:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210414152946.12517-8-tsbogend@alpha.franken.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/14/2021 8:29 AM, Thomas Bogendoerfer wrote:
> If there is no mac address passed via platform data try to get it via
> device tree and fall back to a random mac address, if all fail.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  drivers/net/ethernet/korina.c | 29 ++++++++++++++++++++++++++---
>  1 file changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> index 69c8baa87a6e..c4590b2c65aa 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -42,6 +42,8 @@
>  #include <linux/interrupt.h>
>  #include <linux/ioport.h>
>  #include <linux/in.h>
> +#include <linux/of_device.h>
> +#include <linux/of_net.h>
>  #include <linux/slab.h>
>  #include <linux/string.h>
>  #include <linux/delay.h>
> @@ -1056,7 +1058,7 @@ static const struct net_device_ops korina_netdev_ops = {
>  
>  static int korina_probe(struct platform_device *pdev)
>  {
> -	u8 *mac_addr = dev_get_platdata(&pdev->dev);
> +	const u8 *mac_addr = dev_get_platdata(&pdev->dev);
>  	struct korina_private *lp;
>  	struct net_device *dev;
>  	void __iomem *p;
> @@ -1069,7 +1071,15 @@ static int korina_probe(struct platform_device *pdev)
>  	SET_NETDEV_DEV(dev, &pdev->dev);
>  	lp = netdev_priv(dev);
>  
> -	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
> +	if (mac_addr) {
> +		ether_addr_copy(dev->dev_addr, mac_addr);
> +	} else {
> +		mac_addr = of_get_mac_address(pdev->dev.of_node);
> +		if (!IS_ERR(mac_addr))
> +			ether_addr_copy(dev->dev_addr, mac_addr);
> +		else
> +			eth_hw_addr_random(dev);
> +	}
>  
>  	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
>  	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
> @@ -1149,8 +1159,21 @@ static int korina_remove(struct platform_device *pdev)
>  	return 0;
>  }
>  
> +#ifdef CONFIG_OF
> +static const struct of_device_id korina_match[] = {
> +	{
> +		.compatible = "korina",
> +	},

If you add Device Tree, you might as well provide a binding document for
this controller and possibly pick up a better name than what this driver
had to begin with (in hindsight rb532 is also a bad name since it was
just one board instance), how about using idt,rc32434-emac or something
along these lines?
-- 
Florian
