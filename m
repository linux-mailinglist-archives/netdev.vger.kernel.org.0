Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D20649D6E9
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 01:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231354AbiA0Amv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 19:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbiA0Amu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 19:42:50 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 700FEC06161C;
        Wed, 26 Jan 2022 16:42:48 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id a8so1180911pfa.6;
        Wed, 26 Jan 2022 16:42:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=fO8wuUJYfup5zE7DoRObXy99oD7Qo2U8WB8g72CEBTY=;
        b=lNYUwFrXdMK9t/Oz1ZcL7K8SaHzUgvUXtLM8Ji9oBgXMQc7hUZf6PnEXSWA57RcEyW
         kQBK/4HmpgiJuKBGmKBwvu/3tbAL1qCPCCJWHE4ExNOekbrgUd/M5hZ3WjHvNcS+ZfJN
         5eMJcShtdGAfE9VZPL1z/3y6jYiySiJQxtq3rC3izl5w2nGO674rlrCpGYzFKK+m8uzx
         fSf1t0kpIW6UZTGw9WGrVqkuJt01rbN+9kZBOneWC+NhhzkKz2j1wJHIyOchX/0wMu0M
         HVJ7t/3Z1bqxnDb5hLPYky6CSTByn8+fjnbeCoikzpJD039y4Xm/EQoEGAq6qxelljdZ
         Dqjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=fO8wuUJYfup5zE7DoRObXy99oD7Qo2U8WB8g72CEBTY=;
        b=0/krA9CFmbGkXw7XynS1woQ1av+0qE4RVmny6ivwxVOfHL1/8DjDsh08cQ8vVkJrBl
         5KRnd7RL0kARupZsfO48gzxLtNTBFpBZQBgIqdYaYl8ybGZ7nkj0SkdgxRKmYWY3LVDu
         CPTffZWbPyATkhpGKRyWAUUtZtBu6F4Tf+akdcQaOiGBHxrE1QtWQ4n0S1uUzM2j4w/4
         2vurZKF86r7FZqkzRQ3gaOmvMgFO5wD1vpiO4NfckYuSgKsTVgWGLuwYXcVrl7+I1fFV
         aYxoC+9QCj9sS9K1Ts5eW1ko+ejfrcXREu8lm67N+IAE020lx+MEp4G557Rk0qTxsty2
         vpaQ==
X-Gm-Message-State: AOAM531bTI/Be6nyNcF/g0/tQQK+lFyjyc+RKXPrED1Lugy0waA2dLDH
        8t5AZhgkCSwaecEDdQCHm6U=
X-Google-Smtp-Source: ABdhPJxtMGT9sKX5QWLQ851xWqkapNJiQz45x8NGD7ok7ujYvR3aaJPPziPh57uM3A7jduTgWivJYQ==
X-Received: by 2002:a65:5cc1:: with SMTP id b1mr984105pgt.341.1643244167769;
        Wed, 26 Jan 2022 16:42:47 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w10sm2994039pfn.153.2022.01.26.16.42.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 16:42:47 -0800 (PST)
Message-ID: <c9f68d34-285e-63ff-8140-691c77f8d212@gmail.com>
Date:   Wed, 26 Jan 2022 16:42:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v3 2/2] net: dsa: microchip: Add property to
 disable reference clock
Content-Language: en-US
To:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org
Cc:     woojung.huh@microchip.com, UNGLinuxDriver@microchip.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        marex@denx.de, devicetree@vger.kernel.org
References: <20220127003318.3633212-1-robert.hancock@calian.com>
 <20220127003318.3633212-3-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220127003318.3633212-3-robert.hancock@calian.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/26/2022 4:33 PM, Robert Hancock wrote:
> Add a new microchip,synclko-disable property which can be specified
> to disable the reference clock output from the device if not required
> by the board design.
> 
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

This looks good, I would just have done the hunk below a bit differently:

> ---
>   drivers/net/dsa/microchip/ksz9477.c    | 7 ++++++-
>   drivers/net/dsa/microchip/ksz_common.c | 6 ++++++
>   drivers/net/dsa/microchip/ksz_common.h | 1 +
>   3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/dsa/microchip/ksz9477.c b/drivers/net/dsa/microchip/ksz9477.c
> index 353b5f981740..33d52050cd68 100644
> --- a/drivers/net/dsa/microchip/ksz9477.c
> +++ b/drivers/net/dsa/microchip/ksz9477.c
> @@ -222,9 +222,14 @@ static int ksz9477_reset_switch(struct ksz_device *dev)
>   			   (BROADCAST_STORM_VALUE *
>   			   BROADCAST_STORM_PROT_RATE) / 100);
>   
> -	if (dev->synclko_125)
> +	if (dev->synclko_disable)
> +		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1, 0);
> +	else if (dev->synclko_125)
>   		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
>   			   SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ);
> +	else
> +		ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1,
> +			   SW_ENABLE_REFCLKO);

Since you write to the same register in all of these branches, why not 
do this:

	u32 tmp = SW_ENABLE_REFCLKO;

	if (dev->synclko_disable)
		tmp = 0
	else if (dev->synclko_125)
		tmp = SW_ENABLE_REFCLKO | SW_REFCLKO_IS_125MHZ;

	ksz_write8(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1, tmp);

even though the compiler may just do that for you under the hood.
-- 
Florian
