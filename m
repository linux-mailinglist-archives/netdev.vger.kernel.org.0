Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617AB33F492
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 16:51:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232006AbhCQPvb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 11:51:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbhCQPu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 11:50:58 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12309C061763;
        Wed, 17 Mar 2021 08:50:58 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id g8-20020a9d6c480000b02901b65ca2432cso2232723otq.3;
        Wed, 17 Mar 2021 08:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=19vFCxyc/d/BylNt+OTc+iBLZijRIvHRbJoemdahdg4=;
        b=S8DN3uJ6pmkH0i5ozpjnJ+QTjbdOrmWUwvE7aKg2LQPqyO53I6+LGAlPpc/kHC1IAH
         TVinDGGj3kQGAkL51yk6MWLyFbZIijocroZSAHrAe8vrxU3Urf7OngHT6XnbDsVKI5rb
         rfDsJLrYpu9+tBROF7WvELu4BC4xejZ3aQNq44RMUJ2uZTCBQbYnwJecd7fZqJu0hsbX
         H+pUu7bbv5jgI3NmD3yAyfncZhd0VcS2zrfXEru2+d9ppNXKs4mqy54xlnjPKgyekIZ0
         O1nsACck0qBLrZALFrfpHAFUAKaHjv4Xal+bdWGlaCRhZVbpsySygnFnn4HVqtrPvQxC
         Z+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=19vFCxyc/d/BylNt+OTc+iBLZijRIvHRbJoemdahdg4=;
        b=uUlBtZIMBl64Fu2a9ZUn6a92vmWNz3iHr892blzitlmEqlgjt1GrPelKtqpEv8gVGD
         wKA/c9ev68kSjld0znpvBPYiVlMTq4g9i5ceTzfoG5IHRZGpfq+ZMAH/HfqMKDHsLFuw
         hdO9WzlFXDrxPg5BScXxHZoapI2CTFz0pye+82kl6rLQIF0uYRgL+M8JMRq3aoOGpUXn
         15YlGXnvwE+uzF2DZwnLHvXt2EEUJ27OqPpSnTIB2W8tumNPm07RGNeZPmgZPNErOUnj
         v9fU59tz/IMsEvMriPkFKzXgEu6V7NxEvFRpCuLel6iPpV+CffDVa08DfqYziF7P/aBo
         v7Tw==
X-Gm-Message-State: AOAM531Jc8FzmnaDngxQBFm1iBGuo6mTxETcdZV81yehoCPrH4ZFzy+Q
        0SkgVZD2BN9Hm0e2EbW5+7tWS8s/X80=
X-Google-Smtp-Source: ABdhPJwqC3u1xdxDQE1twSj2SMvvQWTkxjpoX9eOQGEefgoyewW5Z3C2iU/DmmwgCAghIeehrP9NUQ==
X-Received: by 2002:a9d:19e8:: with SMTP id k95mr3962633otk.37.1615996257286;
        Wed, 17 Mar 2021 08:50:57 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id y143sm7881623oie.50.2021.03.17.08.50.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 08:50:56 -0700 (PDT)
Subject: Re: [PATCH] net: ipv4: Fixed some styling issues.
To:     Anish Udupa <udupa.anish@gmail.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAPDGunOVtW5mZWXwEjtT3qWXNG4WgkdEa3jV79QKVHOmjHU-9Q@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <824c82b7-ea4d-9b64-9f5a-61577c1d7584@gmail.com>
Date:   Wed, 17 Mar 2021 09:50:55 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAPDGunOVtW5mZWXwEjtT3qWXNG4WgkdEa3jV79QKVHOmjHU-9Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/21 9:07 AM, Anish Udupa wrote:
> Ran checkpatch and found these warnings. Fixed some of them in this patch.
> a) Added a space before '='.
> b) Removed the space before the tab.
> 
> Signed-off-by: Anish Udupa H <udupa.anish@gmail.com>
> ---
>  net/ipv4/route.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/net/ipv4/route.c b/net/ipv4/route.c
> index 02d81d79deeb..0b9024584fde 100644
> --- a/net/ipv4/route.c
> +++ b/net/ipv4/route.c
> @@ -2236,7 +2236,7 @@ out: return err;
>   if (!rth)
>   goto e_nobufs;
> 
> - rth->dst.output= ip_rt_bug;
> + rth->dst.output = ip_rt_bug;
>  #ifdef CONFIG_IP_ROUTE_CLASSID
>   rth->dst.tclassid = itag;
>  #endif
> @@ -2244,9 +2244,9 @@ out: return err;
> 
>   RT_CACHE_STAT_INC(in_slow_tot);
>   if (res->type == RTN_UNREACHABLE) {
> - rth->dst.input= ip_error;
> - rth->dst.error= -err;
> - rth->rt_flags &= ~RTCF_LOCAL;
> + rth->dst.input = ip_error;
> + rth->dst.error = -err;
> + rth->rt_flags &= ~RTCF_LOCAL;
>   }
> 
>   if (do_cache) {
> 

your patch seems to have lost one or more tabs at the beginning of each
line.
