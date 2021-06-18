Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2278A3AC122
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 04:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhFRDAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 23:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbhFRDAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Jun 2021 23:00:07 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E46C061574
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 19:57:57 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id h24-20020a9d64180000b029036edcf8f9a6so8289686otl.3
        for <netdev@vger.kernel.org>; Thu, 17 Jun 2021 19:57:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lhhFjsWIYaIMox8vCVXSzIqwV5FMCi7H82CMeH6zabQ=;
        b=HQlMALhbo1l8UvELixNeomQ95eAfOD3+Zhi8I8CwokiJ1F2Xwmkm52aTelvaf8BmqZ
         NiXYeTZMQfZYdNqZLvei8fASyAkmpGFVML/Y8kqxtFHjGh9KmFzB/zVUtmxrG8IaOZKz
         /gWUSdJc/KRkAY6tMPMxAT8/w0CREiHlcNeO2CKN8y398bM2hmCIneTDkcaMiCuGhXUQ
         rVAUJXEdtwNa9b0CTumwHL6xPx/LYFDcb+TyQCBKJh622sqXkOaFmLfrulBLfiC8Fe9w
         5yBsz7n6jsb+Q8+1nshiQI4peEuwJ02uyhb88qpHFRXq/yUPB2BoAmEgSIdYp2q0ysFH
         moWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lhhFjsWIYaIMox8vCVXSzIqwV5FMCi7H82CMeH6zabQ=;
        b=JDg+KjyoEWbEHZkdH6d4DGT1CwIEnfOnuzxSf2kU4UxgTWeQdX2YWNDu5Ab2teyOl3
         THnjX5ZuNUUi7glrI4sT00k51s3qzULEYkG1o1qB697xF6BMT5TqaLcimUcjPtHq8aY4
         xjtDbofebqPNiNIKk4o5vE563FdwzEVmammctDowWl/BzTYMewdWorjuyj6wVpMnBhB+
         HgZ7az+IdMfW4WL8rsV+L/AbRmfaTiX6TksA2+vjgriUvG7Y7BUIkEJQXQStXbK+1c+x
         GAIP9U3ftu6/6Kq94/exznfbjZ8cqCe7d0Uk78wpnQlc1JGIRyVHC08YFkbbt22wfdMh
         O2fQ==
X-Gm-Message-State: AOAM532nUhu1j7Y1N8Q+jH0i3ApzJYDy2kQ33oI3BCrHPg8ztgm047AL
        m0A6JSDBY35f7+Qi+MDE/1gHisj4YwA=
X-Google-Smtp-Source: ABdhPJxcLWDk2LBWwGqNT1pNMsarWRGVeKpcPngiiQ0E/+xAWj7aTxwJc+dS7pcQiA4plnpQ2CpKdw==
X-Received: by 2002:a9d:5e8b:: with SMTP id f11mr7367631otl.274.1623985076821;
        Thu, 17 Jun 2021 19:57:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.44])
        by smtp.googlemail.com with ESMTPSA id o20sm649067ook.40.2021.06.17.19.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Jun 2021 19:57:56 -0700 (PDT)
Subject: Re: [PATCH v2 iproute2] utils: bump max args number to 512 for batch
 files
To:     Guillaume Nault <gnault@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <e2bf7f7890e2da1a3bda08ef69f2685aba560561.1623404496.git.gnault@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b9a44aba-74c1-50f6-5eb7-d5eb6f18a464@gmail.com>
Date:   Thu, 17 Jun 2021 20:57:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <e2bf7f7890e2da1a3bda08ef69f2685aba560561.1623404496.git.gnault@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/21 3:46 AM, Guillaume Nault wrote:
> Large tc filters can have many arguments. For example the following
> filter matches the first 7 MPLS LSEs, pops all of them, then updates
> the Ethernet header and redirects the resulting packet to eth1.
> 
> filter add dev eth0 ingress handle 44 priority 100 \
>   protocol mpls_uc flower mpls                     \
>     lse depth 1 label 1040076 tc 4 bos 0 ttl 175   \
>     lse depth 2 label 89648 tc 2 bos 0 ttl 9       \
>     lse depth 3 label 63417 tc 5 bos 0 ttl 185     \
>     lse depth 4 label 593135 tc 5 bos 0 ttl 67     \
>     lse depth 5 label 857021 tc 0 bos 0 ttl 181    \
>     lse depth 6 label 239239 tc 1 bos 0 ttl 254    \
>     lse depth 7 label 30 tc 7 bos 1 ttl 237        \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol mpls_uc pipe            \
>   action mpls pop protocol ipv6 pipe               \
>   action vlan pop_eth pipe                         \
>   action vlan push_eth                             \
>     dst_mac 00:00:5e:00:53:7e                      \
>     src_mac 00:00:5e:00:53:03 pipe                 \
>   action mirred egress redirect dev eth1
> 
> This filter has 149 arguments, so it can't be used with tc -batch
> which is limited to a 100.
> 
> Let's bump the limit to 512. That should leave a lot of room for big
> batch commands.
> 
> v2:
>    -Define the limit in utils.h (Stephen Hemminger)
>    -Bump the limit even higher (256 -> 512) (Stephen Hemminger)
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  include/utils.h | 3 +++
>  lib/utils.c     | 4 ++--
>  2 files changed, 5 insertions(+), 2 deletions(-)
> 

applied to iproute2-next. Thanks,

