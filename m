Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9192E3B1841
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 12:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbhFWKyQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 06:54:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhFWKyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Jun 2021 06:54:13 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E639C06175F;
        Wed, 23 Jun 2021 03:51:55 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id n23so1310537wms.2;
        Wed, 23 Jun 2021 03:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YJ73V5hYmJu2Li20f6H0oXcp8rTwNQepTRvs9pg0Ayc=;
        b=HZnD6Mj9y0wPAxfFNO40Rb1hDKKLYfm6I3na+Q20BjgRD58FwReS9GD2VWdYVMRc+1
         FQR75MY5dsj//IuErAWXf/U6ZYCLAP/lR1KJqRH0RUMp8xTNs0UyDyF8DDKWTlsASs8L
         O1zYz64o4u8K86KqzbBp4s4NZmYAawkae9BPheLVAeL6gqdbcvDKMRcgmfqtSeqDPaN4
         nM315GCJDwrFYlR8Mstpkypj/5xlHhDb9Uu3Ox+WnFSzVLDxUEX8De3RJtc1WYPDtoGU
         Pw23ApaIhKLew7uSeSHAewpiC8RnWZ91XrWSGy1Wu0ywanr9nYg0UFwvf07o2ag/Bzmr
         1EtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YJ73V5hYmJu2Li20f6H0oXcp8rTwNQepTRvs9pg0Ayc=;
        b=kK8BaNGqjTy90gBoI9fS6ZMj1QUJCwmhFm+lOP3aQewlF8pMAPZ/fZsrhGV2GZQRGj
         tp+0MaP4gm+8/Ekj9ceXNfdObPsHLiarpjckcuMQd1aWPptIzHdCUh0QIXmwla0HbCGt
         pis5OY0QwJsLfGESQ0vhXn3uzH8xKVzCgldBy1umMcwRTjyPIpUTvW4qyty4NXuIu5RB
         dHAJG9WF1KT2xZvKCT0BG1LY4kZqUk+646tL6G6qy7rTK8q4eCsL5uraC644YB9JdX77
         C4H5eDbx5H2C6kiBc7Xa0BdOjF+mf8Hkezdfx4/0Jl9+yF8FFvLqJ4jC049FXMJfrhJi
         I8JA==
X-Gm-Message-State: AOAM533KDPBPmE1dKCxqe2fHT3PObpvY1skH+Tjj6Cmu0gpNetJCzvlC
        /qS8OPNVaddfh684f2B9UWM=
X-Google-Smtp-Source: ABdhPJy0pdv8S5A+OZI7wjE988c0i8ppfp51KJK1z0gcAs4eD/JcFObMzLSWmeQFFFzuVphYwZzXhA==
X-Received: by 2002:a1c:6408:: with SMTP id y8mr10151978wmb.30.1624445514286;
        Wed, 23 Jun 2021 03:51:54 -0700 (PDT)
Received: from [192.168.98.98] (8.249.23.93.rev.sfr.net. [93.23.249.8])
        by smtp.gmail.com with ESMTPSA id i16sm5403832wmm.9.2021.06.23.03.51.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 03:51:53 -0700 (PDT)
Subject: Re: [PATCH] net: bridge: remove redundant return
To:     13145886936@163.com, roopa@nvidia.com, nikolay@nvidia.com,
        davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
References: <20210623005307.6215-1-13145886936@163.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <e8df63b4-b16b-c3ed-3991-508c5840cf8d@gmail.com>
Date:   Wed, 23 Jun 2021 12:51:52 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210623005307.6215-1-13145886936@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/23/21 2:53 AM, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Return statements are not needed in Void function.

Maybe, but this just works.

I see your patch as a matter of taste.


> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>
> ---
>  net/bridge/br_netlink.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 8642e56059fb..b70075939721 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -619,7 +619,7 @@ void br_ifinfo_notify(int event, const struct net_bridge *br,
>  {
>  	u32 filter = RTEXT_FILTER_BRVLAN_COMPRESSED;
>  
> -	return br_info_notify(event, br, port, filter);
> +	br_info_notify(event, br, port, filter);
>  }
>  
>  /*
> @@ -814,7 +814,7 @@ static const struct nla_policy br_port_policy[IFLA_BRPORT_MAX + 1] = {
>  	[IFLA_BRPORT_MODE]	= { .type = NLA_U8 },
>  	[IFLA_BRPORT_GUARD]	= { .type = NLA_U8 },
>  	[IFLA_BRPORT_PROTECT]	= { .type = NLA_U8 },
> -	[IFLA_BRPORT_FAST_LEAVE]= { .type = NLA_U8 },
> +	[IFLA_BRPORT_FAST_LEAVE] = { .type = NLA_U8 },

Useless noise.

>  	[IFLA_BRPORT_LEARNING]	= { .type = NLA_U8 },
>  	[IFLA_BRPORT_UNICAST_FLOOD] = { .type = NLA_U8 },
>  	[IFLA_BRPORT_PROXYARP]	= { .type = NLA_U8 },
> 
