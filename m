Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35AC8361D2C
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 12:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241699AbhDPJWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 05:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235252AbhDPJWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 05:22:01 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7CF9C061574;
        Fri, 16 Apr 2021 02:21:35 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id r20so30284708ljk.4;
        Fri, 16 Apr 2021 02:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:organization:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NgU4ZuEkAIBv9K7zpQYRRLFhhJ9S9HowNQOSVq3Jw5k=;
        b=UbcwO38qzC5kOQHMKWkzPMoJr9GFjobMkdepw1TJYElxaDTOLAHbM2yGvMCXWU4iJ6
         rIoOnNngVjWu8FQT0xbFc+aQ+tASlwvlxO4HNgBfSF08NW2d6/PaiFnq5Oqd4CuJ1McF
         Osks7KtDLjtUjDc68aNsdVOT6MD2Av/63ufzLBxT8aTRrEAsu7rMTRM5Z6T9RshsYeef
         TWZ6iBNrgDqoQyTfmk5sqs1HZFAZNpFgIAUbOE0AwZzGbv4H+FmmmMWqGbahGdT9VIGR
         v8rgHe+GJMMSRMf1Ai03QDn/4mJfmIw9BqPhaiKXynbTTwBgnbjmN1To1pLUDjZD2wyF
         f85A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=NgU4ZuEkAIBv9K7zpQYRRLFhhJ9S9HowNQOSVq3Jw5k=;
        b=H2kyMzF2QFLjZh8KY+qTWHuK6cKjPP+Ohmd3dhrlgWMQZeljK0GolObSQLZ3w6F9hp
         5v9L/Nlhn0QD6RzGVbS9MO8mUA7jyJQbwu8gdDeKos93V2oBn1PLx/PVHNX/04Sp0Fr3
         ILAqYjljf87niutP2ikz1Evc/fdV4cPypQQfraOnk+s6WWZtgGF0PkVI6Nfmezpiwn3r
         A+FevId0FO8rICR3N7IbOOk+20uMYp7nt9y9w1CcNnfE8vrpE72UESOrJzjsDFxjv59P
         aY9V/nO3+IMdlrl949puJmyaq5HUypGsstMj3TLipIDNQdAYCSWfYLbUtmT9P+vAPEuh
         zkfg==
X-Gm-Message-State: AOAM5338xZbbPMhfy3Wel+83zh27jd6KwjiOIiT5dSAObNbYJh0qsM/M
        JwsnNIW2cfX1l5zepUnIO9wANoa+4KU=
X-Google-Smtp-Source: ABdhPJzMznfggoOJBbYFj1l91TtSbUPVN0puuSkCs01MkiFjjj47phZh12eigqaFekXyg6pXbZ9qEQ==
X-Received: by 2002:a2e:a40e:: with SMTP id p14mr2005425ljn.254.1618564894238;
        Fri, 16 Apr 2021 02:21:34 -0700 (PDT)
Received: from [192.168.1.100] ([31.173.80.250])
        by smtp.gmail.com with ESMTPSA id p12sm943355lfg.104.2021.04.16.02.21.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 02:21:33 -0700 (PDT)
Subject: Re: [PATCH v4 net-next 07/10] net: korina: Add support for device
 tree
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210416084712.62561-1-tsbogend@alpha.franken.de>
 <20210416084712.62561-8-tsbogend@alpha.franken.de>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <82ea17c0-826b-7dae-8709-da721c4d0d6c@gmail.com>
Date:   Fri, 16 Apr 2021 12:21:20 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210416084712.62561-8-tsbogend@alpha.franken.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 16.04.2021 11:47, Thomas Bogendoerfer wrote:

> If there is no mac address passed via platform data try to get it via > device tree and fall back to a random mac address, if all fail.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>   drivers/net/ethernet/korina.c | 24 ++++++++++++++++++++++--
>   1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> index d6dbbdd43d7c..cd078a5c679b 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -43,6 +43,8 @@
>   #include <linux/ioport.h>
>   #include <linux/iopoll.h>
>   #include <linux/in.h>
> +#include <linux/of_device.h>
> +#include <linux/of_net.h>
>   #include <linux/slab.h>
>   #include <linux/string.h>
>   #include <linux/delay.h>
> @@ -1068,7 +1070,12 @@ static int korina_probe(struct platform_device *pdev)
>   	SET_NETDEV_DEV(dev, &pdev->dev);
>   	lp = netdev_priv(dev);
>   
> -	memcpy(dev->dev_addr, mac_addr, ETH_ALEN);
> +	if (mac_addr) {
> +		ether_addr_copy(dev->dev_addr, mac_addr);
> +	} else {
> +		if (of_get_mac_address(pdev->dev.of_node, dev->dev_addr))

    *else* *if* here, and no need for {} then? :-)

> +			eth_hw_addr_random(dev);
> +	}
>   
>   	lp->rx_irq = platform_get_irq_byname(pdev, "korina_rx");
>   	lp->tx_irq = platform_get_irq_byname(pdev, "korina_tx");
[...]
MBR, Sergei
