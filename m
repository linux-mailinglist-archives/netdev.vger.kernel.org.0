Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 259044606A5
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 15:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357814AbhK1OFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 09:05:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357817AbhK1ODs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 09:03:48 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2232C0613F6;
        Sun, 28 Nov 2021 05:57:16 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id y13so60326248edd.13;
        Sun, 28 Nov 2021 05:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WxyvII6OmnQeCAY+DJ4uBaCQep/MW3p/jfUqUkGPhKg=;
        b=TwMUP/DXnY70GvOEWDlRhxHKej9qY3L1d+Ha9pMZ/Qm3pZvOwxtWDMdwio1aAAjo50
         +Mo8f1K+SA5m8lSr7wkFVg3lAsGc2nncWTYvajZ/PxAfdUb2He0jda6neOl9zaBh9xri
         e5TL5mgqrYcWEbsZ6TtmgoVz4nYfgYYvy2g9D2MGZRFn23quhyexpyRawgbi6J42dEw3
         vTt4a4Ct9e86w0JRlctf9d3dH6D4u22+7g/jeK5VyhsbaDF0d87u1pTsS+AhBXpBCj2G
         jjFGC4qkVe0wJ0oBP9iTKda3ORRTpY6cZm8oNTWbkLw22LkdHqw82lCv4GODjPSWFCzQ
         kG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WxyvII6OmnQeCAY+DJ4uBaCQep/MW3p/jfUqUkGPhKg=;
        b=RZOiHhDLSVLGuamkW8zBLQ1KieiZahNcxcAKScoewaHE4yraZg5UVXwj4l7kbfrfg1
         Md2+6eH1M6jWld29Y5jXx/r0ZjooWr+kNFtdScukHybRotAvug4t1aFkwEagdXqqw72n
         Jo1zzQK7NhhHKGANEJAMJGkPuqXQZ9e2cPDw1OLF0EZ+mtT5WeBmr9YmNqLhvJkl778X
         mGa80zkdQi1UcKShVLFs7TZmsdtv310IizrMEx5cdokJQ2G4vWYUlgP1fzhRU/aE9Fba
         EcIi7f7vWpwNDDWkQ6CatMXQoI/eE8jd4HTvIMLbtyG6P/1ksfGFCijsZ9hhDYCt4jwu
         Av1A==
X-Gm-Message-State: AOAM533aU3f1J3aC7wgJY3RMtakXrH071p7x/yu9u5LzPr8E+u0tA6PC
        nBS60vvNJ/Kg02IqsGHG6bg=
X-Google-Smtp-Source: ABdhPJz6nXfc+mVeK1gz4vdbNriFAG/nL94eSnXm4Z5qazr0myWosKzt5iyFKC2FoRAMixMfuqCDBw==
X-Received: by 2002:a05:6402:2026:: with SMTP id ay6mr65342803edb.202.1638107835368;
        Sun, 28 Nov 2021 05:57:15 -0800 (PST)
Received: from [192.168.0.108] ([77.124.1.33])
        by smtp.gmail.com with ESMTPSA id og14sm5883651ejc.107.2021.11.28.05.57.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 05:57:14 -0800 (PST)
Message-ID: <f76ad3e6-fccb-a481-8283-c8ff3100a82b@gmail.com>
Date:   Sun, 28 Nov 2021 15:57:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] net/mlx4_en: Update reported link modes for 1/10G
Content-Language: en-US
To:     Erik Ekman <erik@kryo.se>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Stapelberg <michael@stapelberg.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20211128123712.82096-1-erik@kryo.se>
From:   Tariq Toukan <ttoukan.linux@gmail.com>
In-Reply-To: <20211128123712.82096-1-erik@kryo.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/28/2021 2:37 PM, Erik Ekman wrote:
> When link modes were initially added in commit 2c762679435dc
> ("net/mlx4_en: Use PTYS register to query ethtool settings") and
> later updated for the new ethtool API in commit 3d8f7cc78d0eb
> ("net: mlx4: use new ETHTOOL_G/SSETTINGS API") the only 1/10G non-baseT
> link modes configured were 1000baseKX, 10000baseKX4 and 10000baseKR.
> It looks like these got picked to represent other modes since nothing
> better was available.
> 
> Switch to using more specific link modes added in commit 5711a98221443
> ("net: ethtool: add support for 1000BaseX and missing 10G link modes").
> 
> Tested with MCX311A-XCAT connected via DAC.
> Before:
> 
> % sudo ethtool enp3s0
> Settings for enp3s0:
> 	Supported ports: [ FIBRE ]
> 	Supported link modes:   1000baseKX/Full
> 	                        10000baseKR/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: No
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  1000baseKX/Full
> 	                        10000baseKR/Full
> 	Advertised pause frame use: Symmetric
> 	Advertised auto-negotiation: No
> 	Advertised FEC modes: Not reported
> 	Speed: 10000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: off
> 	Port: Direct Attach Copper
> 	PHYAD: 0
> 	Transceiver: internal
> 	Supports Wake-on: d
> 	Wake-on: d
>          Current message level: 0x00000014 (20)
>                                 link ifdown
> 	Link detected: yes
> 
> With this change:
> 
> % sudo ethtool enp3s0
> 	Settings for enp3s0:
> 	Supported ports: [ FIBRE ]
> 	Supported link modes:   1000baseX/Full
> 	                        10000baseCR/Full
>   	                        10000baseSR/Full
> 	Supported pause frame use: Symmetric Receive-only
> 	Supports auto-negotiation: No
> 	Supported FEC modes: Not reported
> 	Advertised link modes:  1000baseX/Full
>   	                        10000baseCR/Full
>   	                        10000baseSR/Full
> 	Advertised pause frame use: Symmetric
> 	Advertised auto-negotiation: No
> 	Advertised FEC modes: Not reported
> 	Speed: 10000Mb/s
> 	Duplex: Full
> 	Auto-negotiation: off
> 	Port: Direct Attach Copper
> 	PHYAD: 0
> 	Transceiver: internal
> 	Supports Wake-on: d
> 	Wake-on: d
>          Current message level: 0x00000014 (20)
>                                 link ifdown
> 	Link detected: yes
> 
> Tested-by: Michael Stapelberg <michael@stapelberg.ch>
> Signed-off-by: Erik Ekman <erik@kryo.se>
> ---
>   drivers/net/ethernet/mellanox/mlx4/en_ethtool.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> index 066d79e4ecfc..10238bedd694 100644
> --- a/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> +++ b/drivers/net/ethernet/mellanox/mlx4/en_ethtool.c
> @@ -670,7 +670,7 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_T, SPEED_1000,
>   				       ETHTOOL_LINK_MODE_1000baseT_Full_BIT);
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_CX_SGMII, SPEED_1000,
> -				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
> +				       ETHTOOL_LINK_MODE_1000baseX_Full_BIT);
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_1000BASE_KX, SPEED_1000,
>   				       ETHTOOL_LINK_MODE_1000baseKX_Full_BIT);
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_T, SPEED_10000,
> @@ -682,9 +682,9 @@ void __init mlx4_en_init_ptys2ethtool_map(void)
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_KR, SPEED_10000,
>   				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_CR, SPEED_10000,
> -				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
> +				       ETHTOOL_LINK_MODE_10000baseCR_Full_BIT);
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_10GBASE_SR, SPEED_10000,
> -				       ETHTOOL_LINK_MODE_10000baseKR_Full_BIT);
> +				       ETHTOOL_LINK_MODE_10000baseSR_Full_BIT);
>   	MLX4_BUILD_PTYS2ETHTOOL_CONFIG(MLX4_20GBASE_KR2, SPEED_20000,
>   				       ETHTOOL_LINK_MODE_20000baseMLD2_Full_BIT,
>   				       ETHTOOL_LINK_MODE_20000baseKR2_Full_BIT);
> 

LGTM. Thanks for your patch.
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
