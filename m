Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29C0349D820
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 03:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235238AbiA0Cgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 21:36:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiA0Cgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 21:36:52 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C36AC06173B
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 18:36:52 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id c188so1919654iof.6
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 18:36:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=TrIeda6M4M9lk0at+GG7zdWgmSnIp1weAu9IMqU+s08=;
        b=l4A+UQhrk06bBi+wF2aJYmA4y8nQ+pNm+Rvr+7sGsyZLFxfYTsh08Il8FE+m/CPMwo
         36dllpe44+bpOGwj0aWi58dBAEgfbjzOk7QbfK/BW5GigWJasMw1IJ/pisrjn7AGxv8w
         gJWjk65XesHHi/ytL1i69oys+dl0tNeXV0arKUPpa31FaCpcVHx/LrgyrTyiYVtZ/kkd
         S+hhwvhnV2jiAfbmjVUvHqq1mJiyP+K4c4MUjcFodiIrt99bj3PvyrD30WtxqGocrlMj
         jJ5OCPa0ekoS2e76ncdTyDSToh+mo3y+B9L6qdE8nLEpdmFV+ucfQ17wtNC/5BgSErPN
         2CbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=TrIeda6M4M9lk0at+GG7zdWgmSnIp1weAu9IMqU+s08=;
        b=e0q1+AibONFA1tc+ZqqnN23N7NDgCbA7IuSTPEYi/LvwpM6Az2b30F1WCX6yqMyGPI
         WtDr/suvXV0VCUGtwsfPg6GXWxa3JxjEdzci4jqyyERyjYINRqYGNgFwfnXCNf+UcU09
         xhXRiHHnhvtvO6Qu1Ziqhm6SjAE1QP8Ebh12m3SX8DJF9+XGJYppjQuOjux0reJzjQdh
         CVfb5C3q7ydBY4EME1EECcPZLA77bZ7a7e42ksPQO2CM7vZHFPt+KzYY7SWy1bLNNMkr
         aTFisr5sYatS7q+v0kXEp/PPSrSegWPHWMpG64S+a0psGLXws+qNj50+bRomxciLJcGm
         gG8g==
X-Gm-Message-State: AOAM532p2nfkUKmUGtVv1Jw2WLB7DxJm5U/IAqTpSp0maApuYkQx3jGd
        D3C+RH28wIvXLwcQRDJRucA=
X-Google-Smtp-Source: ABdhPJwcRTne4f7tFbMy5KoYb/GXM+y1AokfDAmXnys5EsOVZqIPbnIEQ5X6A0cgtqH+blZjEKnzuA==
X-Received: by 2002:a02:9997:: with SMTP id a23mr847566jal.256.1643251011491;
        Wed, 26 Jan 2022 18:36:51 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:a443:a1f0:524f:ffce? ([2601:282:800:dc80:a443:a1f0:524f:ffce])
        by smtp.googlemail.com with ESMTPSA id k11sm10464529iob.23.2022.01.26.18.36.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jan 2022 18:36:51 -0800 (PST)
Message-ID: <640acb21-e5ed-49cb-ecce-34200f5af543@gmail.com>
Date:   Wed, 26 Jan 2022 19:36:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net] ipv4: remove sparse error in ip_neigh_gw4()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220127013404.1279313-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220127013404.1279313-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/26/22 6:34 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> ./include/net/route.h:373:48: warning: incorrect type in argument 2 (different base types)
> ./include/net/route.h:373:48:    expected unsigned int [usertype] key
> ./include/net/route.h:373:48:    got restricted __be32 [usertype] daddr
> 
> Fixes: 5c9f7c1dfc2e ("ipv4: Add helpers for neigh lookup for nexthop")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@gmail.com>
> ---
>  include/net/route.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/net/route.h b/include/net/route.h
> index 4c858dcf1aa8cd1988746e55eb698ad4425fd77b..25404fc2b48374c69081b8c72c2ea1dbbc09ed7f 100644
> --- a/include/net/route.h
> +++ b/include/net/route.h
> @@ -370,7 +370,7 @@ static inline struct neighbour *ip_neigh_gw4(struct net_device *dev,
>  {
>  	struct neighbour *neigh;
>  
> -	neigh = __ipv4_neigh_lookup_noref(dev, daddr);
> +	neigh = __ipv4_neigh_lookup_noref(dev, (__force u32)daddr);
>  	if (unlikely(!neigh))
>  		neigh = __neigh_create(&arp_tbl, &daddr, dev, false);
>  

I think __ipv4_neigh_lookup_noref can be changed to __be32 and remove
the (__force u32) from a couple of callers, but more like net-next material.

Reviewed-by: David Ahern <dsahern@kernel.org>
