Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8532428543
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233703AbhJKCqb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:46:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233411AbhJKCq2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:46:28 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A04CC061570;
        Sun, 10 Oct 2021 19:44:29 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id u69so10283714oie.3;
        Sun, 10 Oct 2021 19:44:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=FEsKQETeRll8zdrD7pbt3rLtoNmhMueb3RF/kjwBxDg=;
        b=MOG8/CQTeiJKlF4QcodxH9h7UqnCdawe+sWybHuy0aPFF03SZs8SKwDEk0nfmQYns6
         C5tESG8ZxSAhTNKdX4py1eHjxlrsrIXNLOqS0jdnfkA/hGdT5QA8eocgieubjLtdit1L
         u6aKsLOfY868R8LzKenGTO+5+HXM7CMFHT2oANRSXCXmcohRJ4GCEzBPQY7C1JtDM/nh
         eeuPGMlqucBeU3zLyuZJa4lDY8ZDVfA6BvukxQdKlohA0QwLEGUJ3oMvok8wElNTONMr
         h+cf1QrlkJS6jrSganY/BovGYRgLLmSCzt0CxfyjTFjR2wltPKBRFDZrmR7oGyhrOb97
         eC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FEsKQETeRll8zdrD7pbt3rLtoNmhMueb3RF/kjwBxDg=;
        b=fg+1/8Lr/93PSFpJOdWBW7Vf6oH6NZD9Sq6kdGnCREpQIxRHZ97H5OzpdToHsmBHac
         VaHXLA+CFBhJaHuLDxb5eZwgHClcEMiY/XZhPMmbko93oJLCMpWmNyEz1QPn78nsWkQz
         UujyZ7+iv0iW0DwsiTwZlE5Cm2+DELMvD1mK/7Hq51hABM+x9K4T/foovGrO2o3upSGs
         T5yi+XKE62HQ60gbIUZKMqxDJNhO3iSUwLHpQvxESjLpPERfyHzHcu8PLF/KcXwHs3Rn
         L/aJVPsCpOGIjHxNNxTmP4HkLNc7Htu7yqsvbKqDmOTYnbXI7p4o3IfPb15x/tqFEQZs
         F4oQ==
X-Gm-Message-State: AOAM5324aU2//gXtwgZToy9jrnaMXLZooM5HuUuve1MGNJejaxMxch3I
        vglzi4rsnT4jB09CGR4wWFs=
X-Google-Smtp-Source: ABdhPJyPcjZS82mtyLu0RXGz/DQvMO8GdHs0STaTNsxwe+zq9PNIDfts31et3jc4DqwMDp/Reqq7lQ==
X-Received: by 2002:aca:41d5:: with SMTP id o204mr25440133oia.41.1633920268505;
        Sun, 10 Oct 2021 19:44:28 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:3cb6:937e:609b:a590? ([2600:1700:dfe0:49f0:3cb6:937e:609b:a590])
        by smtp.gmail.com with ESMTPSA id 3sm1110709oif.12.2021.10.10.19.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:44:28 -0700 (PDT)
Message-ID: <13904686-9a74-00d9-d2fa-1ebf7e820d0c@gmail.com>
Date:   Sun, 10 Oct 2021 19:44:25 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 13/14] drivers: net: dsa: qca8k: set internal
 delay also for sgmii
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-14-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-14-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> QCA original code report port instability and sa that SGMII also require
> to set internal delay. Generalize the rgmii delay function and apply the
> advised value if they are not defined in DT.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>   drivers/net/dsa/qca8k.c | 81 +++++++++++++++++++++++++++--------------
>   drivers/net/dsa/qca8k.h |  2 +
>   2 files changed, 55 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index cb66bdccc233..28635f4feaf5 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -998,6 +998,7 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
>   		case PHY_INTERFACE_MODE_RGMII_ID:
>   		case PHY_INTERFACE_MODE_RGMII_TXID:
>   		case PHY_INTERFACE_MODE_RGMII_RXID:
> +		case PHY_INTERFACE_MODE_SGMII:
>   			delay = 0;
>   
>   			if (!of_property_read_u32(port_dn, "tx-internal-delay-ps", &delay))
> @@ -1030,8 +1031,6 @@ qca8k_parse_port_config(struct qca8k_priv *priv)
>   
>   			priv->rgmii_rx_delay[cpu_port_index] = delay;
>   
> -			break;
> -		case PHY_INTERFACE_MODE_SGMII:
>   			if (of_property_read_bool(port_dn, "qca,sgmii-txclk-falling-edge"))
>   				priv->sgmii_tx_clk_falling_edge = true;

This also makes the RGMII* ports parse the couple of sgmii properties 
introduced earlier, but since these properties are only acted on for 
PHY_INTERFACE_MODE_SGMII in the .mac_config, I suppose that is fine.
--
Florian
