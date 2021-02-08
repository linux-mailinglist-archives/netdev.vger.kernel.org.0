Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF87A313D8A
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 19:32:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231206AbhBHScK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 13:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234021AbhBHSbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 13:31:52 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30373C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 10:31:10 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id t142so76360wmt.1
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 10:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Hs7wTewV0cufOq3PKa0WHvUyp9n739TnznjMarToqCc=;
        b=RpH2Lz7pBFJIErN3xdxHHdFPlTYVidTrYSQl2BdM18gPbVKsM17KVw8Wm8RX2E2XW2
         AycEOG7v0fX26zn8907VQhL15f534mcTbbZGCureeKPd6Hll9jI7w3377pnOlOiD9fuU
         h+AfZ0LwIsl4uhEfrDJRnCQNGB4jKMHgk+3Shirh9RNs6Qu3vgRpRbPT9Ba3koI3dQ76
         Dizy6QoxVDomW5LZ7lDk1yk+Ag6yp8JGjEULUE5RElSHF6VSTGfwLujuOV5eFqEPTn2b
         9fWIxx0wU3fIeuVYl1B5Wdf6rQstvAFfx8Xq+hPv2KcrdgYDXPwWF4tfrpJ67JMEBTRS
         TvFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Hs7wTewV0cufOq3PKa0WHvUyp9n739TnznjMarToqCc=;
        b=pHFHtAT1mmyk4tpoEpTNzZu1xBjvfHTlWTTdS7ZfIFSaBd5udOYd8Pte4oBWJlkEMY
         OYztzELJNTJdYRCXZfahxENZVQPSY55nnmV3+0zaoYuaBKzUhsx3iqfDG7nHvwYFkmZv
         XqK17OsBowbfGsFMtwk0LZWDohNKm+ZN6mXN7NpBTMaN0XCIT+PYnsbkRkGKf8FBh4NX
         rOvn/lpTjBByHKuVcOoyPpQaJjfSff83xzlMRjhjI8ZdRwafpJc61ioAfpNvW0zfTzyI
         jjPgt2QzXpYUYBNK9QhvvSfeRzhPhWbie/99YHaglgPazinI1QD0CZQ86kRqsDv3sEgm
         Q5oQ==
X-Gm-Message-State: AOAM530HfNfk3nahK/55xZg2bnF8DpnW8PjiwT8inytMcQolgmr7KZOz
        /oQM/FAegsevvi8gjT3Ckck=
X-Google-Smtp-Source: ABdhPJwDkDr4OWzpD4EadcmAHIpfdVUqSpYecmRUS0lKqY3l3JR4RSI61qCyK3oygQYLf0zOoChAPQ==
X-Received: by 2002:a05:600c:2f81:: with SMTP id t1mr100238wmn.186.1612809068975;
        Mon, 08 Feb 2021 10:31:08 -0800 (PST)
Received: from [192.168.1.101] ([37.171.108.87])
        by smtp.gmail.com with ESMTPSA id q24sm51964wmq.24.2021.02.08.10.31.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Feb 2021 10:31:08 -0800 (PST)
Subject: Re: [PATCH net-next 7/8] mld: convert ip6_sf_socklist to list macros
To:     Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, dsahern@kernel.org,
        xiyou.wangcong@gmail.com
References: <20210208175820.5690-1-ap420073@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <8633a76b-84c1-44c1-f532-ce66c1502b5c@gmail.com>
Date:   Mon, 8 Feb 2021 19:31:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210208175820.5690-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/8/21 6:58 PM, Taehee Yoo wrote:
> Currently, struct ip6_sf_socklist doesn't use list API so that code
> shape is a little bit different from others.
> So it converts ip6_sf_socklist to use list API so it would
> improve readability.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  include/net/if_inet6.h  |  19 +-
>  include/uapi/linux/in.h |   4 +-
>  net/ipv6/mcast.c        | 387 +++++++++++++++++++++++++---------------
>  3 files changed, 256 insertions(+), 154 deletions(-)
> 
> diff --git a/include/net/if_inet6.h b/include/net/if_inet6.h
> index babf19c27b29..6885ab8ec2e9 100644
> --- a/include/net/if_inet6.h
> +++ b/include/net/if_inet6.h
> @@ -13,6 +13,7 @@
>  #include <net/snmp.h>
>  #include <linux/ipv6.h>
>  #include <linux/refcount.h>
> +#include <linux/types.h>
>  
>  /* inet6_dev.if_flags */
>  
> @@ -76,23 +77,19 @@ struct inet6_ifaddr {
>  };
>  
>  struct ip6_sf_socklist {
> -	unsigned int		sl_max;
> -	unsigned int		sl_count;
> -	struct in6_addr		sl_addr[];
> +	struct list_head	list;
> +	struct in6_addr		sl_addr;
> +	struct rcu_head		rcu;
>  };
>

I dunno about readability, but :

Your patches adds/delete more than 1000 lines, who is really going to review this ?

You replace dense arrays by lists, so the performance will likely be hurt,
as cpu caches will be poorly used.


