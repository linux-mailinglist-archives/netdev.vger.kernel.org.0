Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB333DDEA9
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 19:37:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhHBRh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 13:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbhHBRh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 13:37:58 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395FBC06175F
        for <netdev@vger.kernel.org>; Mon,  2 Aug 2021 10:37:48 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 68-20020a9d0f4a0000b02904b1f1d7c5f4so18210243ott.9
        for <netdev@vger.kernel.org>; Mon, 02 Aug 2021 10:37:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DlUpILSj3quRHEJRual/lQapS/HveYcdPqc2O4/2CpM=;
        b=CE8PSutauxrHZJSCIi2Zbsv723jQS0kw8WdpbwRuQkYg7Yyb374Z4TNY13WWHULr+j
         12Ilcdg0IA/6c2VXZmlzfzaJWOBhmHeOHr0DXXvW9qP6utPAV0l/O45mNcY26uwaAX1P
         x01YCa1g9CKCqw3mbZUOzgoSlu3ABZt5/e3t1fKwpQwt+C7eCvWot+lGbmvTdfwiTkgY
         vqaKyL6tPfTIJlxt17BEVNOPcqcednWbGowk5SPcNkHjCUIRnLoxWnLf/aKMAC5zzFIW
         8mKcUZ4o6RCLnM9qh3+kqlSIPERrQVVH6aR9Up+vGoMWWBCe4wWaLZx1GW9FG+DzEs6A
         GKQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DlUpILSj3quRHEJRual/lQapS/HveYcdPqc2O4/2CpM=;
        b=qxA1h7K92Dj59wcKRjP71YWRrs30aw+qCCfuYjS0l/l7q7OtrMKSsyZlBM4WSQmUxV
         mMK6Fs54Phn+9hXDvA1Vb/dWWyAOi5pdZEO/PhoYK2HgHv9u+iOUUiUMMDO75wNvnSyO
         0+JPu3INRnEbI7tUvpITsLugYg0ksZ8WPi6uP9VJg92QG2XamOSWZRiY3z3GRJrgqGf0
         IrNmyL2Y9isEyKYDE6l4S8arbeqS/qdfmN/XsX8s/bexyDi2l4i7ElfjfADl90HFCS2q
         God/38vuV+IP6RrZ3+cuG0NgR7YYjPJ2xU+sAfsfsA4ijQpTLvvTmI7hD0Vz3Km1M1MX
         SsDw==
X-Gm-Message-State: AOAM5319R2IRXL2gXzvJ7xPP442P0dcPArgqf3Jm5AssbhBiL24NauOL
        lK1jXFe3BhDHduSAcK+icmn9UYgMPK8=
X-Google-Smtp-Source: ABdhPJyt3BtNqTYKl4vupbq4j6kQ/C53U4qLZp9Vxvm6WysRtZOSeoXqr5xbY1W//8YBe+5qQzutQw==
X-Received: by 2002:a05:6830:447:: with SMTP id d7mr12543634otc.253.1627925866685;
        Mon, 02 Aug 2021 10:37:46 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id z18sm1996489oto.71.2021.08.02.10.37.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Aug 2021 10:37:46 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 0/3] Provide support for IOAM
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20210801124552.15728-1-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d63c65f1-0009-8cf4-2815-8e7a0ef63463@gmail.com>
Date:   Mon, 2 Aug 2021 11:37:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210801124552.15728-1-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/1/21 6:45 AM, Justin Iurman wrote:
> v3:
>  - Use strcmp instead of matches
>  - Use genl_init_handle instead of rtnl_open_byproto/genl_resolve_family
>  - Refine the output of schemas data
>  - distinguish trace options by adding another keyword, in this case "prealloc":
>    "encap ioam6 trace **prealloc** type ...." (anticipate future implems)
> 
> v2:
>  - Use print_{hex,0xhex} instead of print_string when possible (patch #1)
> 
> 
> The IOAM patchset was merged recently (see net-next commits [1,2,3,4,5,6]).
> Therefore, this patchset provides support for IOAM inside iproute2, as well as
> manpage documentation. Here is a summary of added features inside iproute2.
> 
> (1) configure IOAM namespaces and schemas:
> 
> $ ip ioam
> Usage:	ip ioam { COMMAND | help }
> 	ip ioam namespace show
> 	ip ioam namespace add ID [ data DATA32 ] [ wide DATA64 ]
> 	ip ioam namespace del ID
> 	ip ioam schema show
> 	ip ioam schema add ID DATA
> 	ip ioam schema del ID
> 	ip ioam namespace set ID schema { ID | none }
> 	
> (2) provide a new encap type to insert the IOAM pre-allocated trace:
> 
> $ ip -6 ro ad fc00::1/128 encap ioam6 trace prealloc type 0x800000 ns 1 size 12 dev eth0
> 
>   [1] db67f219fc9365a0c456666ed7c134d43ab0be8a
>   [2] 9ee11f0fff205b4b3df9750bff5e94f97c71b6a0
>   [3] 8c6f6fa6772696be0c047a711858084b38763728
>   [4] 3edede08ff37c6a9370510508d5eeb54890baf47
>   [5] de8e80a54c96d2b75377e0e5319a64d32c88c690
>   [6] 968691c777af78d2daa2ee87cfaeeae825255a58
> 
> Justin Iurman (3):
>   Add, show, link, remove IOAM namespaces and schemas
>   New IOAM6 encap type for routes
>   IOAM man8
> 
>  include/uapi/linux/ioam6.h          | 133 +++++++++++
>  include/uapi/linux/ioam6_genl.h     |  52 +++++
>  include/uapi/linux/ioam6_iptunnel.h |  20 ++
>  include/uapi/linux/lwtunnel.h       |   1 +
>  ip/Makefile                         |   2 +-
>  ip/ip.c                             |   3 +-
>  ip/ip_common.h                      |   1 +
>  ip/ipioam6.c                        | 340 ++++++++++++++++++++++++++++
>  ip/iproute.c                        |   5 +-
>  ip/iproute_lwtunnel.c               | 127 +++++++++++
>  man/man8/ip-ioam.8                  |  72 ++++++
>  man/man8/ip-route.8.in              |  36 ++-
>  man/man8/ip.8                       |   7 +-
>  13 files changed, 793 insertions(+), 6 deletions(-)
>  create mode 100644 include/uapi/linux/ioam6.h
>  create mode 100644 include/uapi/linux/ioam6_genl.h
>  create mode 100644 include/uapi/linux/ioam6_iptunnel.h
>  create mode 100644 ip/ipioam6.c
>  create mode 100644 man/man8/ip-ioam.8
> 

applied to iproute2-next.
