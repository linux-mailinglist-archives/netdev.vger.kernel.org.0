Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0894FE819
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 20:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352445AbiDLSi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 14:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233371AbiDLSiz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 14:38:55 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D8151335
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 11:36:37 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id b15so23441880edn.4
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 11:36:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Qzn148We9XavLCPnkjKAVkx4J24baZYNxkMK7Z/8yLA=;
        b=6zcvRk4t6zjIi9VUqhYdQe5+Y/t3BN+bwbv90esoK9EZDsSs6uD08xfUsY5UgyewXR
         c2roVuOjy6N2Mi1WzTgSTN80CWaQKrdCwAuGud5odlmrPqbDKs4wTuuorWJSNJJ75h5l
         kplFvdJdLES5TaVpqwOJKtG0YD1lbIgtg9j7dGBplZZdnesop0BhKVkBC0URr9GqoqvI
         ZAJSKtRXAFAINt/zKBta4T2sBoc4MAi1BaYEdTrXrzuc90f8HdFwRxKNCE/Y4jAYtyc7
         YGuzMfU+Q6Q+ML8z8vzSstV3dyqe76Wl1ABDb5DHolRI9g3lU+S25RmzBYMbE7G/mr51
         gGug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Qzn148We9XavLCPnkjKAVkx4J24baZYNxkMK7Z/8yLA=;
        b=N/Ts3kBe8zun344xjRKVhjctPR9yil0vLCUo0deoB03pBI4JdczYgF9Gmjyfc7sj5Z
         6xKxYmfV4rNFuWJ/eHWFtYv8GKEU/vT0hBWu42jqjI7JEQ8H0H2pQTh8R4Awdtr4n2I7
         GqHys7qUWU5cR3Sa5cl/Np/XeD1vSbv9d8BDs4yGH04E1FmvhYjMFn8DLz+byvj1Wb3j
         gUpe0LzmfeKZsS3qTTB5FiuNF0wApfg6tr10yjdxXzaqfeXkHrW8bRgNHwQ5kve66mpg
         t+dJlWC40IiMUTkkIe+9M55eo/X+WeDhNbUOjiEH00m32WwPHf4aCf7eHcnkVQv4/t+0
         s3LQ==
X-Gm-Message-State: AOAM531mBlhPcb/CX8bxCI37ZaquCUV42UHsP2oyo7PDqqf11tdgYTQn
        HMBr3OnfJeTV0WwYZenT4hvg5lueUbKrYhOk
X-Google-Smtp-Source: ABdhPJzLImArn19hcTzskeUAA6UBsS/8tRIgHLMti+GKp8gVts2J0FivZnrdVJ/Nvf1D+H85sMvGlw==
X-Received: by 2002:a05:6402:5cf:b0:41d:7aa7:152a with SMTP id n15-20020a05640205cf00b0041d7aa7152amr12703378edx.68.1649788595591;
        Tue, 12 Apr 2022 11:36:35 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id m3-20020a17090679c300b006cf9ce53354sm13411208ejo.190.2022.04.12.11.36.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Apr 2022 11:36:35 -0700 (PDT)
Message-ID: <76490693-ea6d-7174-0546-b9361ab5088c@blackwall.org>
Date:   Tue, 12 Apr 2022 21:36:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next 03/13] net: bridge: minor refactor of
 br_setlink() for readability
Content-Language: en-US
To:     Joachim Wiberg <troglobit@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220411133837.318876-1-troglobit@gmail.com>
 <20220411133837.318876-4-troglobit@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220411133837.318876-4-troglobit@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/04/2022 16:38, Joachim Wiberg wrote:
> The br_setlink() function extracts the struct net_bridge pointer a bit
> sloppy.  It's easy to interpret the code wrong.  This patch attempts to
> clear things up a bit.
> 
> Signed-off-by: Joachim Wiberg <troglobit@gmail.com>
> ---
>  net/bridge/br_netlink.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 

I think you can make it more straight-forward, remove the first br = netdev_priv
and do something like (completely untested):
...
struct net_bridge_port *p = NULL;
...
if (netif_is_bridge_master(dev)) {
 br = netdev_priv(dev);
} else {
 p = br_port_get_rtnl(dev);
 if (WARN_ON(!p))
	return -EINVAL;
 br = p->br;
}

So br is always and only set in this block.

> diff --git a/net/bridge/br_netlink.c b/net/bridge/br_netlink.c
> index 7fca8ff13ec7..8f4297287b32 100644
> --- a/net/bridge/br_netlink.c
> +++ b/net/bridge/br_netlink.c
> @@ -1040,6 +1040,8 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
>  		return 0;
>  
>  	p = br_port_get_rtnl(dev);
> +	if (p)
> +		br = p->br;
>  	/* We want to accept dev as bridge itself if the AF_SPEC
>  	 * is set to see if someone is setting vlan info on the bridge
>  	 */
> @@ -1055,17 +1057,17 @@ int br_setlink(struct net_device *dev, struct nlmsghdr *nlh, u16 flags,
>  			if (err)
>  				return err;
>  
> -			spin_lock_bh(&p->br->lock);
> +			spin_lock_bh(&br->lock);
>  			err = br_setport(p, tb, extack);
> -			spin_unlock_bh(&p->br->lock);
> +			spin_unlock_bh(&br->lock);
>  		} else {
>  			/* Binary compatibility with old RSTP */
>  			if (nla_len(protinfo) < sizeof(u8))
>  				return -EINVAL;
>  
> -			spin_lock_bh(&p->br->lock);
> +			spin_lock_bh(&br->lock);
>  			err = br_set_port_state(p, nla_get_u8(protinfo));
> -			spin_unlock_bh(&p->br->lock);
> +			spin_unlock_bh(&br->lock);
>  		}
>  		if (err)
>  			goto out;

