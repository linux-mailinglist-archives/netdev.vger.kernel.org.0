Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 323A74606A8
	for <lists+netdev@lfdr.de>; Sun, 28 Nov 2021 15:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352641AbhK1OGs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 09:06:48 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:56499 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1357792AbhK1OEr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 09:04:47 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.nyi.internal (Postfix) with ESMTP id 5025D580233;
        Sun, 28 Nov 2021 09:01:31 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Sun, 28 Nov 2021 09:01:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9QEJ4a
        3JCf6f6EXsCeOpWCQYkSVQO3Izw6ivvg22kAE=; b=JRVJLyvr9erNruhr6GmpWw
        /hJVhQL5Hrni3Xtg9nhLSsZOkl4GzzRKRLmqGKhWFJljPbOK7sGUF3wUa85VojPp
        pOAvEwHdNzH1gB7WQ5GuffWV/40PEXvw/jrEaaMFS35nbTklfEM24XTVfOFvLWmF
        PLdGyyLpkLmciOCNPoaWNTJKrzxEKa35Idk7ijnDJmbVsUlkhvL0mhpzuQPMG+ji
        Pmrf6rHnVbMxmyqupW/AuhheKmFZXr0Q9jJFXhWB3NHbJvdh0vxJIVc2neiQkr4d
        14DFZaPANpylVdUcQteNEtqxmuwRFUvoY73C0J4mPWflXfK7vvECa3jj3iDnjUKw
        ==
X-ME-Sender: <xms:uoujYbPMjp1d4grp2Bi15pUbY_vDUwCJB9pCzj_Hq1U8T3RVAWLgiQ>
    <xme:uoujYV8WsJiDdMTS_7Eqx-IWaWRySZo2uk5tV63zWIJ9NhVL6OIccEmK8a6xiV3js
    FHTIVYvDy8d2Cg>
X-ME-Received: <xmr:uoujYaQ4BzAb8WE8aj2jRcnuggPQ8ugdlEMPrjb5ugAudQIzCvrHNpL9-iN6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrheeigdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:uoujYfvhCaTdlwuAxDryXF4tEBk5LA1if9Q5PrBdzauzNG77BcJbpA>
    <xmx:uoujYTd-5PJsjrJOZ7cAFzopq6NGvQWisXS_xJQwPxkD89oJjFv4kA>
    <xmx:uoujYb3DSUL6kfuLhsOz_QprwFtlxu8QpHYtkun86Qstxd54CVW8pw>
    <xmx:u4ujYSySRaJplu8LpJqxc75ic6qQgLcUHROqcIWQq8X5tmjYIq2Mnw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 28 Nov 2021 09:01:30 -0500 (EST)
Date:   Sun, 28 Nov 2021 16:01:27 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Alexander Mikhalitsyn <alexander@mihalicyn.com>
Subject: Re: [PATCH net-next] rtnetlink: add RTNH_REJECT_MASK
Message-ID: <YaOLt2M1hBnoVFKd@shredder>
References: <20211111160240.739294-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-1-alexander.mikhalitsyn@virtuozzo.com>
 <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126134311.920808-2-alexander.mikhalitsyn@virtuozzo.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 04:43:11PM +0300, Alexander Mikhalitsyn wrote:
> diff --git a/include/uapi/linux/rtnetlink.h b/include/uapi/linux/rtnetlink.h
> index 5888492a5257..9c065e2fdef9 100644
> --- a/include/uapi/linux/rtnetlink.h
> +++ b/include/uapi/linux/rtnetlink.h
> @@ -417,6 +417,9 @@ struct rtnexthop {
>  #define RTNH_COMPARE_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN | \
>  				 RTNH_F_OFFLOAD | RTNH_F_TRAP)
>  
> +/* these flags can't be set by the userspace */
> +#define RTNH_REJECT_MASK	(RTNH_F_DEAD | RTNH_F_LINKDOWN)
> +
>  /* Macros to handle hexthops */
>  
>  #define RTNH_ALIGNTO	4
> diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
> index 4c0c33e4710d..805f5e05b56d 100644
> --- a/net/ipv4/fib_semantics.c
> +++ b/net/ipv4/fib_semantics.c
> @@ -685,7 +685,7 @@ static int fib_get_nhs(struct fib_info *fi, struct rtnexthop *rtnh,
>  			return -EINVAL;
>  		}
>  
> -		if (rtnh->rtnh_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> +		if (rtnh->rtnh_flags & RTNH_REJECT_MASK) {
>  			NL_SET_ERR_MSG(extack,
>  				       "Invalid flags for nexthop - can not contain DEAD or LINKDOWN");
>  			return -EINVAL;
> @@ -1363,7 +1363,7 @@ struct fib_info *fib_create_info(struct fib_config *cfg,
>  		goto err_inval;
>  	}
>  
> -	if (cfg->fc_flags & (RTNH_F_DEAD | RTNH_F_LINKDOWN)) {
> +	if (cfg->fc_flags & RTNH_REJECT_MASK) {
>  		NL_SET_ERR_MSG(extack,
>  			       "Invalid rtm_flags - can not contain DEAD or LINKDOWN");

Instead of a deny list as in the legacy nexthop code, the new nexthop
code has an allow list (from rtm_to_nh_config()):

```
	if (nhm->nh_flags & ~NEXTHOP_VALID_USER_FLAGS) {
		NL_SET_ERR_MSG(extack, "Invalid nexthop flags in ancillary header");
		goto out;
	}
```

Where:

```
#define NEXTHOP_VALID_USER_FLAGS RTNH_F_ONLINK
```

So while the legacy nexthop code allows setting flags such as
RTNH_F_OFFLOAD, the new nexthop code denies them. I don't have a use
case for setting these flags from user space so I don't care if we allow
or deny them, but I believe the legacy and new nexthop code should be
consistent.

WDYT? Should we allow these flags in the new nexthop code as well or
keep denying them?

>  		goto err_inval;
> -- 
> 2.31.1
> 
