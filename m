Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F18A8352EBB
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 19:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235984AbhDBRtv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 13:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhDBRtu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 13:49:50 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4D18C0613E6;
        Fri,  2 Apr 2021 10:49:48 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id i18so1871849wrm.5;
        Fri, 02 Apr 2021 10:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6/S7y9C8nRxZmjQeY8wpCEGGx7d5w2nUI9mEHAzOyr4=;
        b=EKJRA9qiti7P9cUGyyz4nzgoW4eR1olaGPIr8PtEys12m9EmxxXJqBe73YBwGzSwbN
         TqnMm1GU6uCV7ISWh57RMLiE9Ns0bhZFqdMfvBlyWc2uJSssoMYy5dJQqQG/O5jTTUSL
         EmppftdLqPklLWp/IQTtjH3du7sMMkpmxFUp8OsPqP4GqU6/7pxl4nxo5uMb5Hv56YKx
         jj+6/MIjAaAxQwSSp9q/8cKbR+b4rgDqA0vkE1lKlv/KSaowHakhJuS7DfxTXycaPSFf
         lspjUzd5LR5ojUcP+ZYseL07LH/jtqnI6Z6Q7PHO5BPuxJH9Z29JMCWZTwzk3dXE6kKd
         2Hqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6/S7y9C8nRxZmjQeY8wpCEGGx7d5w2nUI9mEHAzOyr4=;
        b=aKyEqFWKDtzxl/TJgcQ+UrJrRphR33Mvnen7cU0b67l43RO/q3qeOhTryaZjA9MJiw
         yiuBFLEOGfpWzH+f3cOiQBj0ZujtwTggY+G4jF3EbX0yuGW+i4AqduLAgmMGcw0MXhvT
         9n+zE29pGTbXNqJgA7KtIQdPnkfNRROnU3u6x4TXhmKh+ILNBkI9baZ+FKjLyGm/YYnH
         jLPThcoWFBkcsc8PtC4/7nCnQn8SSv5fjlNi1GBP1dxo9CKfvDk0LxMGbMFT/P6HkBkH
         l2L0KcOWbuLnan91dpVXUjPxETWqu7LoD+Wp4J2uMTdpcjXidgmV41Ium7c46CX4VyQv
         NP3g==
X-Gm-Message-State: AOAM5304M45/IxK0SrqvcymoLQAx+MJxtmcgYyv16uQQlWYcim86bid/
        cQigAtcFR381v8anpdxzZWAaLIkI24g=
X-Google-Smtp-Source: ABdhPJw8bkMpDdw4laVwoNHLaRMSJeXL7Ze2yJGqxwMYXo9ucLuObt0MlgbVEIMpRMBhG9soE6lzvw==
X-Received: by 2002:a5d:6106:: with SMTP id v6mr16696092wrt.268.1617385786821;
        Fri, 02 Apr 2021 10:49:46 -0700 (PDT)
Received: from [192.168.1.101] ([37.166.24.151])
        by smtp.gmail.com with ESMTPSA id h8sm15305784wrt.94.2021.04.02.10.49.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 10:49:45 -0700 (PDT)
Subject: Re: [PATCH] net: initialize local variables in net/ipv6/mcast.c and
 net/ipv4/igmp.c
To:     Phillip Potter <phil@philpotter.co.uk>, davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210402173617.895-1-phil@philpotter.co.uk>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <d2334631-4b3a-48e5-5305-7320adc50909@gmail.com>
Date:   Fri, 2 Apr 2021 19:49:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210402173617.895-1-phil@philpotter.co.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/21 7:36 PM, Phillip Potter wrote:
> Use memset to initialize two local buffers in net/ipv6/mcast.c,
> and another in net/ipv4/igmp.c. Fixes a KMSAN found uninit-value
> bug reported by syzbot at:
> https://syzkaller.appspot.com/bug?id=0766d38c656abeace60621896d705743aeefed51


According to this link, the bug no longer triggers.

Please explain why you think it is still there.

> 
> Reported-by: syzbot+001516d86dbe88862cec@syzkaller.appspotmail.com
> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
> ---
>  net/ipv4/igmp.c  | 2 ++
>  net/ipv6/mcast.c | 4 ++++
>  2 files changed, 6 insertions(+)
> 
> diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
> index 7b272bbed2b4..bc8e358a9a2a 100644
> --- a/net/ipv4/igmp.c
> +++ b/net/ipv4/igmp.c
> @@ -1131,6 +1131,8 @@ static void ip_mc_filter_add(struct in_device *in_dev, __be32 addr)
>  	char buf[MAX_ADDR_LEN];
>  	struct net_device *dev = in_dev->dev;
>  
> +	memset(buf, 0, sizeof(buf));
> +
>  	/* Checking for IFF_MULTICAST here is WRONG-WRONG-WRONG.
>  	   We will get multicast token leakage, when IFF_MULTICAST
>  	   is changed. This check should be done in ndo_set_rx_mode
> diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
> index 6c8604390266..ad90dc28f318 100644
> --- a/net/ipv6/mcast.c
> +++ b/net/ipv6/mcast.c
> @@ -658,6 +658,8 @@ static void igmp6_group_added(struct ifmcaddr6 *mc)
>  	struct net_device *dev = mc->idev->dev;
>  	char buf[MAX_ADDR_LEN];
>  
> +	memset(buf, 0, sizeof(buf));
> +
>  	if (IPV6_ADDR_MC_SCOPE(&mc->mca_addr) <
>  	    IPV6_ADDR_SCOPE_LINKLOCAL)
>  		return;
> @@ -694,6 +696,8 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
>  	struct net_device *dev = mc->idev->dev;
>  	char buf[MAX_ADDR_LEN];
>  
> +	memset(buf, 0, sizeof(buf));
> +
>  	if (IPV6_ADDR_MC_SCOPE(&mc->mca_addr) <
>  	    IPV6_ADDR_SCOPE_LINKLOCAL)
>  		return;
> 
