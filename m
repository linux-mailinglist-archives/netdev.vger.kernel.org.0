Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB43D49E62D
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238475AbiA0PhL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237837AbiA0PhK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:37:10 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 694DFC061714;
        Thu, 27 Jan 2022 07:37:10 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id d3so2785294ilr.10;
        Thu, 27 Jan 2022 07:37:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iC1JMnbQZwViqZinYDvpwEPeJVrYJp7jnjvfsW04EXU=;
        b=mxiqSfEuLH/q9qXfWeFR7vTROqAAfKNpQHkMa3RgEKZGffVesxPXrXydYFW3pokusI
         AykkF5QwuZxZojBkZZhhdfCV3UN+DrKRTUYPlrQoHUE6f2rCSGihE8cTRmM/B3yMzK5R
         flqJ1FxaFF0WOUsalVzFii7pqDnaLa0bbWSdIh/3WgGTOmrsy8xEsseBl9QOD/VoMkLJ
         u3hBslqIjSPf4I1YoOx6qahF382H/gTqnKgPkfz4OHK1MIXyd/G48arD9LVlqL4ss3d8
         qxgG/hiBW0/PMyOTfDOHpfhBPibb34jJwelwGbpxjsSRoe7CJmq3nk5xXVjweeZ50imU
         8EJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iC1JMnbQZwViqZinYDvpwEPeJVrYJp7jnjvfsW04EXU=;
        b=GQ9mLSovc97iGI86LuJ+AiH7rZ522wkpEMD+ctmxsIOMs46LkSrgvt5a5b+Qaay+mE
         6/+nRuQK+lFXFMRVWOTplAj4jfRIO1ePTqmed//BOUJnRC+gvzQq2M23NhhwhkOT54Ta
         h/MkKqMDJByBumHrq+gDj91LEqPtjYzO7yvzuqoTEzOcoZGbCVHAeo4vy31fj4N3XPOJ
         DxA50R9zpy3oWQA1PZvFbpAwMNnoEMsVDn3zfeCJ8U4UukDU5vf2t+O12sQ8KfrQVwpU
         Y5YpYZUSmRSDTP4y/guMhHnu3YuGQm4H7NQrrabPPvNxW6KLhTv2nBohP7GQ2yGsrXgM
         eC1g==
X-Gm-Message-State: AOAM5303riwiYRURc52P7WlFnok0rrQePHvsNNsOgs14122+5CFkE7pD
        hJlZc/NJjhHZT/Ej7xPXntE=
X-Google-Smtp-Source: ABdhPJxl3qSOedk1qzaxnW6WAdrixeNfw6xblnEyZbJb8THdRL9DA4xXj59eYA+oK2psxr8Mm0lyAg==
X-Received: by 2002:a92:c7ce:: with SMTP id g14mr2782868ilk.102.1643297829809;
        Thu, 27 Jan 2022 07:37:09 -0800 (PST)
Received: from ?IPV6:2601:282:800:dc80:182c:2e54:e650:90f5? ([2601:282:800:dc80:182c:2e54:e650:90f5])
        by smtp.googlemail.com with ESMTPSA id q16sm11171564ion.27.2022.01.27.07.37.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jan 2022 07:37:09 -0800 (PST)
Message-ID: <2512e358-f4d8-f85e-2a82-fbd5a97d1c2f@gmail.com>
Date:   Thu, 27 Jan 2022 08:37:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH v2 net-next 1/8] net: socket: intrudoce
 SKB_DROP_REASON_SOCKET_FILTER
Content-Language: en-US
To:     menglong8.dong@gmail.com, dsahern@kernel.org, kuba@kernel.org
Cc:     rostedt@goodmis.org, mingo@redhat.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, imagedong@tencent.com,
        alobakin@pm.me, pabeni@redhat.com, cong.wang@bytedance.com,
        talalahmad@google.com, haokexin@gmail.com, keescook@chromium.org,
        memxor@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, mengensun@tencent.com
References: <20220127091308.91401-1-imagedong@tencent.com>
 <20220127091308.91401-2-imagedong@tencent.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220127091308.91401-2-imagedong@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 2:13 AM, menglong8.dong@gmail.com wrote:
> From: Menglong Dong <imagedong@tencent.com>
> 
> Introduce SKB_DROP_REASON_SOCKET_FILTER, which is used as the reason
> of skb drop out of socket filter. Meanwhile, replace
> SKB_DROP_REASON_TCP_FILTER with it.
> 
> Signed-off-by: Menglong Dong <imagedong@tencent.com>
> ---
>  include/linux/skbuff.h     | 2 +-
>  include/trace/events/skb.h | 2 +-
>  net/ipv4/tcp_ipv4.c        | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index bf11e1fbd69b..8a636e678902 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -318,7 +318,7 @@ enum skb_drop_reason {
>  	SKB_DROP_REASON_NO_SOCKET,
>  	SKB_DROP_REASON_PKT_TOO_SMALL,
>  	SKB_DROP_REASON_TCP_CSUM,
> -	SKB_DROP_REASON_TCP_FILTER,
> +	SKB_DROP_REASON_SOCKET_FILTER,
>  	SKB_DROP_REASON_UDP_CSUM,
>  	SKB_DROP_REASON_MAX,
>  };
> diff --git a/include/trace/events/skb.h b/include/trace/events/skb.h
> index 3e042ca2cedb..a8a64b97504d 100644
> --- a/include/trace/events/skb.h
> +++ b/include/trace/events/skb.h
> @@ -14,7 +14,7 @@
>  	EM(SKB_DROP_REASON_NO_SOCKET, NO_SOCKET)		\
>  	EM(SKB_DROP_REASON_PKT_TOO_SMALL, PKT_TOO_SMALL)	\
>  	EM(SKB_DROP_REASON_TCP_CSUM, TCP_CSUM)			\
> -	EM(SKB_DROP_REASON_TCP_FILTER, TCP_FILTER)		\
> +	EM(SKB_DROP_REASON_SOCKET_FILTER, SOCKET_FILTER)	\
>  	EM(SKB_DROP_REASON_UDP_CSUM, UDP_CSUM)			\
>  	EMe(SKB_DROP_REASON_MAX, MAX)
>  
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index b3f34e366b27..938b59636578 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -2095,7 +2095,7 @@ int tcp_v4_rcv(struct sk_buff *skb)
>  	nf_reset_ct(skb);
>  
>  	if (tcp_filter(sk, skb)) {
> -		drop_reason = SKB_DROP_REASON_TCP_FILTER;
> +		drop_reason = SKB_DROP_REASON_SOCKET_FILTER;
>  		goto discard_and_relse;
>  	}
>  	th = (const struct tcphdr *)skb->data;

This should go to net, not net-next.

Reviewed-by: David Ahern <dsahern@kernel.org>

