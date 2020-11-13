Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 262DD2B23E2
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 19:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgKMSgw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 13:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726081AbgKMSgw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 13:36:52 -0500
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C29C0613D1;
        Fri, 13 Nov 2020 10:36:51 -0800 (PST)
Received: by mail-qt1-x841.google.com with SMTP id j31so7352194qtb.8;
        Fri, 13 Nov 2020 10:36:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uLLsU6PNK7gn2ZF6sgEbNvfAguFm+Twkz8HSYgMSdHA=;
        b=P1KvIekJ77d1TC7nitWKAlL3pVw7ss+zZBh//e/EsaQTKTD1eTBf/bNMZilOhD09KE
         c94opGCTQBZuuYQCTknaMU0siEiPFIJt8oO05DdL3g7VRP297jy2Xl36RZGE3ELtcy9z
         +hq5cbu+4HY4DaxM7NF+wHbToWVOmCOwArSpbr69cRvHmgycLc2SNx23eV7Y5jYBOVXQ
         QXX9MsQA1z4zHVTm/Rxq8kiiGqsXVZE1CRdAmgwSiNbcEyi1yUiy94al76ldaZcijdcZ
         kJ0kDyg21X0AgmsekCsCH1afCsnVT3pM7f4XCEkHPrUn5QLdN5Rw8WlqkJij98IjXYjT
         INrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uLLsU6PNK7gn2ZF6sgEbNvfAguFm+Twkz8HSYgMSdHA=;
        b=amCOnonJi33wBE2zhbMuq37f9BPc/APMGTqje43pIAyuQkxmnVX/nGjOnK0CmZFuCb
         8qS0KenDZb3RbOyZS/GSb7xHg5nak3Vxty1l3DzIqbYAnggKE2ZX7psaR+2nNL5svNOv
         Pv+KAYXnFRfUZfL+2OUhTSMp4Cxgig/IheD/8llWAirM1JdH2dSlcMXjZwgy/HLwqa7S
         xDPy9gKlwFb+ces1fgJtmxer3BbiaCuq0gYJko7q+KYjEErYNa7eCNOjZqULW8hsbK8b
         pndsil9naiDFM9ONfTInDNw/xguUEgXLnW5y7v/h4I+SQXCux2UYRkDhdaDlGXj4pkpX
         UkvQ==
X-Gm-Message-State: AOAM530uGN4PRVJ3dnk6cdBaTUl9PcJ99XaRVmbTlslUOEnFzNfIhnZ4
        GtZGbPLcIDow3vk3sjez3TM=
X-Google-Smtp-Source: ABdhPJzrJwUQP7TRzyMS8vsdEmfnLmQuPHfTT7JGfv+V/qtg7cxxikUGbbygCkFIgOnjPJiFhQDYnQ==
X-Received: by 2002:a05:622a:86:: with SMTP id o6mr3179517qtw.147.1605292611012;
        Fri, 13 Nov 2020 10:36:51 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 207sm2500356qki.91.2020.11.13.10.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 10:36:50 -0800 (PST)
Date:   Fri, 13 Nov 2020 11:36:49 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Tom Rix <trix@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: remove unused function ipv6_skb_idev()
Message-ID: <20201113183649.GA1436199@ubuntu-m3-large-x86>
References: <20201113135012.32499-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113135012.32499-1-lukas.bulwahn@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 02:50:12PM +0100, Lukas Bulwahn wrote:
> Commit bdb7cc643fc9 ("ipv6: Count interface receive statistics on the
> ingress netdev") removed all callees for ipv6_skb_idev(). Hence, since
> then, ipv6_skb_idev() is unused and make CC=clang W=1 warns:
> 
>   net/ipv6/exthdrs.c:909:33:
>     warning: unused function 'ipv6_skb_idev' [-Wunused-function]
> 
> So, remove this unused function and a -Wunused-function warning.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>

> ---
> Alexey, Hideaki-san, please ack.
> 
> David, Jakub, please pick this minor non-urgent clean-up patch.
> 
>  net/ipv6/exthdrs.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
> index 374105e4394f..584d1b06eb90 100644
> --- a/net/ipv6/exthdrs.c
> +++ b/net/ipv6/exthdrs.c
> @@ -906,10 +906,6 @@ void ipv6_exthdrs_exit(void)
>  /*
>   * Note: we cannot rely on skb_dst(skb) before we assign it in ip6_route_input().
>   */
> -static inline struct inet6_dev *ipv6_skb_idev(struct sk_buff *skb)
> -{
> -	return skb_dst(skb) ? ip6_dst_idev(skb_dst(skb)) : __in6_dev_get(skb->dev);
> -}
>  
>  static inline struct net *ipv6_skb_net(struct sk_buff *skb)
>  {
> -- 
> 2.17.1
> 
