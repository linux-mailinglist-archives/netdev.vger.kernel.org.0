Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CE64568C8
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 04:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbhKSDvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 22:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbhKSDvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 22:51:20 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 759C2C061574
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 19:48:19 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id g91-20020a9d12e4000000b0055ae68cfc3dso14727038otg.9
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 19:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=JTIaBNra4n2MVDVc6MKqFMZXd+UFtw3ja9qNrU4Ky+U=;
        b=EELw0JXjHVTtuFI6B9g52GlKB8X2/vgYQ39/XiGVZY0pDXgbQc2gFyR4g4kA6qbrrZ
         XPZPNN0Jrt4dNYTq/Qnypb4NUQ4thqZ37KZBQMaOyjL++NlGq+FKmOXbelvIgJJSE5mK
         yv/KWSbLVSxHKtNrrQO5B1Fw3F9M+kzKlUXibWsdUpHzwhLcQX5Nzr2eJ9mWswjS8ONN
         d2NkjqP3ADnUNWL0e4lUK9oB6de3JFuZ20Eo+QNjQiO1PqLQPclOny7fBNY7sI+T3Ug+
         lJVUsD93xPJJ91CSaOBUDxZLgAPR7rz+eUrbE/AknPBDLamgj/zi8yX6ECIeB9j/bvlk
         b0tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=JTIaBNra4n2MVDVc6MKqFMZXd+UFtw3ja9qNrU4Ky+U=;
        b=PMjq4POQtNk8uwmnJaFa62GOgBICiCQLx576fD6DD/m/krbW4cEb3m670Wn6kKijQF
         RP5Gep9pu97Y43FFq/D8Kd7xD9G4h+mpVzDgLrQm5ii6kT9FGAlVHsth9wAdga5g8kUQ
         U13+o86kDp+5qGVP3BN7zTvwpS4Kak8YVq6diUfCP/OfFFaC5z8CDtn/wJPM95CebmmQ
         mXimZIkgN5kBF4MUBINNFOWrB4LbSk3KJcN7Cl709xrZOrkphTvdyE37zz296csXhx01
         lZsXXMPcLpp8AhX+Czjr+MY3bP4Hz+EP3OtwOQABLx9X4ZTHR3YI3bqtafGhCOAl2Rzr
         lsTA==
X-Gm-Message-State: AOAM530A/gcflGJMlOox16zU+WSkPAEatNUSn91xRwZNuAX3gUnY7S+Q
        nKkcYDbdj50Hk7TPuzGMD7c=
X-Google-Smtp-Source: ABdhPJx699FD3hv26TclNqonmmu8ArOrfZ1PVeTLUhD3dECi3I4BkjVDSqXrsx/f9EvpitS71cA7MQ==
X-Received: by 2002:a05:6830:22d8:: with SMTP id q24mr1960678otc.170.1637293698905;
        Thu, 18 Nov 2021 19:48:18 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r10sm385217ool.1.2021.11.18.19.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Nov 2021 19:48:18 -0800 (PST)
Message-ID: <e48ceee7-b101-44f3-1bbc-6fbcdf9194db@gmail.com>
Date:   Thu, 18 Nov 2021 20:48:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net] ipv6: fix typos in __ip6_finish_output()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Tobias Brunner <tobias@strongswan.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        David Ahern <dsahern@kernel.org>
References: <20211119013758.2740195-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211119013758.2740195-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 6:37 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We deal with IPv6 packets, so we need to use IP6CB(skb)->flags and
> IP6SKB_REROUTED, instead of IPCB(skb)->flags and IPSKB_REROUTED
> 
> Found by code inspection, please double check that fixing this bug
> does not surface other bugs.
> 
> Fixes: 09ee9dba9611 ("ipv6: Reinject IPv6 packets if IPsec policy matches after SNAT")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Tobias Brunner <tobias@strongswan.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv6/ip6_output.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
> index 2f044a49afa8cf3586c36607c34073edecafc69c..ff4e83e2a5068322bb93391c7c5e2a8cb932730b 100644
> --- a/net/ipv6/ip6_output.c
> +++ b/net/ipv6/ip6_output.c
> @@ -174,7 +174,7 @@ static int __ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff
>  #if defined(CONFIG_NETFILTER) && defined(CONFIG_XFRM)
>  	/* Policy lookup after SNAT yielded a new policy */
>  	if (skb_dst(skb)->xfrm) {
> -		IPCB(skb)->flags |= IPSKB_REROUTED;
> +		IP6CB(skb)->flags |= IP6SKB_REROUTED;
>  		return dst_output(net, sk, skb);
>  	}
>  #endif
> 

How did that even work - the flags are at different offsets.

VRF driver has the same mistake in vrf_output6_direct (I followed ipv6
code back when and did not pick up on the mistake). prepare_ipv6_hdr in
rxe_net.c has a similar style mistake.

Reviewed-by: David Ahern <dsahern@kernel.org>

