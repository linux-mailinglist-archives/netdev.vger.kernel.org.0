Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BB184DC340
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232192AbiCQJsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231384AbiCQJsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:48:41 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FD91D7DA7
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:47:24 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id yy13so9507761ejb.2
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=e84ZZv/cdn/PMhG1/yQsYvnit8l/0EVXSAREO0ZZSFw=;
        b=wS1ug3GKPNIBD0qi+q252IwUZQ9Re4D5IqAy3aDQmJHQ+V2FSnkdHh46HXAdqSGPny
         h5X1mQj7MeHXsodlSbCiQbDhgPQO7mm1G0d74CsXA9AIabWZpRYCQ5BJFn+o5RGZ06Ot
         JWK2Uman6xkmgT4dgO1TMgWUPhZ7fn3Y2vFnj0IYDmYxCrcJORZrkvv+JBKlOtPRUnUz
         yfF4G0WH6X6jiH12t3ooNuUFlPW4YDTdsRq9wwVfl/6UU+INqOgcHzicpXA3xUnlcbeS
         8NW0kLu4JCTl3bcB1p2yVHyed54IXTbrZTI/n6h1ROZY2ty++hYv0nsZ48ga9eBBL9B7
         LHkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=e84ZZv/cdn/PMhG1/yQsYvnit8l/0EVXSAREO0ZZSFw=;
        b=OD3oJ8/YUkLEoj+3C+wZ8DyHzhaJacIc0DPR1n409YjbNgM8ZYt7iqcUxDpel3fJY4
         4i5AHspOqoSj9kcGAzu0SnwsYcBPslhU0HYHDm3a1EYNfc4VySVngbnw2I6MG3Sos9c9
         BF25kXR8caEvo45tWvtOEw96u6T7537INAsM0IlvJ6/3NETQ31wH40bOjSeFQmTMw7pH
         K2m/lQkCyOhkgWf2I3KLSpS2MFmH2RQ2YWn9PV57PpsT4Uypb0qIiFom4HixJUo5cnsj
         T5mm5ca7R1ZPmIhAksllLSx3q6IrMTOkSHZAJENzLaZS3bzEJlLS47YsaRfD9nhcXS23
         obgA==
X-Gm-Message-State: AOAM533WA2/zc+waNd74vSipcIpRjgZAl5Ud29ZqaR1rZ4G1Wp1gZoTX
        Aun6f4GUCEl0//Q/sBYgsjLwuw==
X-Google-Smtp-Source: ABdhPJx47T69HYahCAv/YA7QnnQX0aJ1SuRarvVLwh8Xadc3wrQtUFcGIrMg16H7v25xwZozwh8Tlw==
X-Received: by 2002:a17:906:7d83:b0:6ce:fee:9256 with SMTP id v3-20020a1709067d8300b006ce0fee9256mr3490087ejo.647.1647510443399;
        Thu, 17 Mar 2022 02:47:23 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id hb11-20020a170907160b00b006df8951ed1bsm1151060ejc.32.2022.03.17.02.47.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 02:47:23 -0700 (PDT)
Message-ID: <5ac3cd99-5947-b80c-f815-8ab65e18b377@blackwall.org>
Date:   Thu, 17 Mar 2022 11:47:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next 1/4] net: bridge: add fdb flag to extent
 locked port feature
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
References: <20220317093902.1305816-1-schultz.hans+netdev@gmail.com>
 <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220317093902.1305816-2-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17/03/2022 11:38, Hans Schultz wrote:
> Add an intermediate state for clients behind a locked port to allow for
> possible opening of the port for said clients. This feature corresponds
> to the Mac-Auth and MAC Authentication Bypass (MAB) named features. The
> latter defined by Cisco.
> Only the kernel can set this FDB entry flag, while userspace can read
> the flag and remove it by deleting the FDB entry.
> 
> Signed-off-by: Hans Schultz <schultz.hans+netdev@gmail.com>
> ---
>  include/uapi/linux/neighbour.h |  1 +
>  net/bridge/br_fdb.c            |  6 ++++++
>  net/bridge/br_input.c          | 10 +++++++++-
>  net/bridge/br_private.h        |  3 ++-
>  4 files changed, 18 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/linux/neighbour.h b/include/uapi/linux/neighbour.h
> index db05fb55055e..a2df3b9b2f68 100644
> --- a/include/uapi/linux/neighbour.h
> +++ b/include/uapi/linux/neighbour.h
> @@ -51,6 +51,7 @@ enum {
>  #define NTF_ROUTER	(1 << 7)
>  /* Extended flags under NDA_FLAGS_EXT: */
>  #define NTF_EXT_MANAGED	(1 << 0)
> +#define NTF_EXT_LOCKED	(1 << 1)
>  
>  /*
>   *	Neighbor Cache Entry States.
> diff --git a/net/bridge/br_fdb.c b/net/bridge/br_fdb.c
> index 6ccda68bd473..57ec559a85a7 100644
> --- a/net/bridge/br_fdb.c
> +++ b/net/bridge/br_fdb.c
> @@ -105,6 +105,7 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>  	struct nda_cacheinfo ci;
>  	struct nlmsghdr *nlh;
>  	struct ndmsg *ndm;
> +	u8 ext_flags = 0;

Let's not limit ourselves to 8 bits only for new flags, we'll need to extend them
very soon. The neigh code defines the attribute as u32 which seems more appropriate.

>  
>  	nlh = nlmsg_put(skb, portid, seq, type, sizeof(*ndm), flags);
>  	if (nlh == NULL)
> @@ -125,11 +126,16 @@ static int fdb_fill_info(struct sk_buff *skb, const struct net_bridge *br,
>  		ndm->ndm_flags |= NTF_EXT_LEARNED;
>  	if (test_bit(BR_FDB_STICKY, &fdb->flags))
>  		ndm->ndm_flags |= NTF_STICKY;
> +	if (test_bit(BR_FDB_ENTRY_LOCKED, &fdb->flags))
> +		ext_flags |= NTF_EXT_LOCKED;
>  
>  	if (nla_put(skb, NDA_LLADDR, ETH_ALEN, &fdb->key.addr))
>  		goto nla_put_failure;
>  	if (nla_put_u32(skb, NDA_MASTER, br->dev->ifindex))
>  		goto nla_put_failure;
> +	if (nla_put_u8(skb, NDA_FLAGS_EXT, ext_flags))
> +		goto nla_put_failure;
> +

You have to account for the new attribute size in fdb_nlmsg_size().

>  	ci.ndm_used	 = jiffies_to_clock_t(now - fdb->used);
>  	ci.ndm_confirmed = 0;
>  	ci.ndm_updated	 = jiffies_to_clock_t(now - fdb->updated);
> diff --git a/net/bridge/br_input.c b/net/bridge/br_input.c
> index e0c13fcc50ed..5ef25a496806 100644
> --- a/net/bridge/br_input.c
> +++ b/net/bridge/br_input.c
> @@ -94,8 +94,16 @@ int br_handle_frame_finish(struct net *net, struct sock *sk, struct sk_buff *skb
>  			br_fdb_find_rcu(br, eth_hdr(skb)->h_source, vid);
>  
>  		if (!fdb_src || READ_ONCE(fdb_src->dst) != p ||
> -		    test_bit(BR_FDB_LOCAL, &fdb_src->flags))
> +		    test_bit(BR_FDB_LOCAL, &fdb_src->flags) ||
> +		    test_bit(BR_FDB_ENTRY_LOCKED, &fdb_src->flags)) {
> +			if (!fdb_src) {
> +				unsigned long flags = 0;
> +
> +				set_bit(BR_FDB_ENTRY_LOCKED, &flags);

__set_bit()

> +				br_fdb_update(br, p, eth_hdr(skb)->h_source, vid, flags);
> +			}
>  			goto drop;
> +		}
>  	}
>  
>  	nbp_switchdev_frame_mark(p, skb);
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index 48bc61ebc211..f5a0b68c4857 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -248,7 +248,8 @@ enum {
>  	BR_FDB_ADDED_BY_EXT_LEARN,
>  	BR_FDB_OFFLOADED,
>  	BR_FDB_NOTIFY,
> -	BR_FDB_NOTIFY_INACTIVE
> +	BR_FDB_NOTIFY_INACTIVE,
> +	BR_FDB_ENTRY_LOCKED,
>  };
>  
>  struct net_bridge_fdb_key {

