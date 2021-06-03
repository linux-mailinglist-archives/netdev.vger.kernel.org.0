Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 812DB39A246
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 15:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFCNg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 09:36:26 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:46007 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbhFCNgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 09:36:25 -0400
Received: by mail-wr1-f51.google.com with SMTP id z8so5840416wrp.12
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 06:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y114KDoLC1d7O+Zn9RCBinCUsUIhN/la9oGG1fZ/Rc0=;
        b=itVxeMX7JUDfpHrmQ/XP/lT0FbYDYzkZxtWUmNU8GZmyTix96VqdK4OVh2LoH11kWh
         XhIOamhPBhVnpBCqFQXuxOHaQQowYGAsSPod2vGjSzfY0d8xPvqsfcIK9fwqADzVpX55
         goni2ncWrv+4a0BNDTARCyqSzRU9vHFLM15xTVJg+VbhMv0OhJdR7iqQyNn0AtA6XVC3
         OlljGZgNA5XAMRRjtaU3hVN2S6rZN4YqnVGkNzKkEh/YUkSFu808Rt/rY8otD8m+kRIq
         rIj81WGC/6WVn0A/90hGRlK5OCQx6zBVcaoJxm5PV+GmlU0LE3bMnT+wLG8K8hRTnvCY
         q+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Y114KDoLC1d7O+Zn9RCBinCUsUIhN/la9oGG1fZ/Rc0=;
        b=b9yfbPR1OEs3Zc0tusfNwCnsrgkZEhi9bHn1kvHy/jfEJyrrrxyCorfwjgUnkug+MR
         b2Qu70GVwUbhdy+ww3NS7YQxXjnLV9BQuszvgCevWFdwp/p8xoRyXiaaU+YFEd4YNN9M
         RFnEETA6tykHJij9wDZ+yru6xpR1cinmWqVomHpvhqNNi0Ta7J5zRGp/DtrhaxwmnnGn
         vDOQIOlrNIomMb+9pyZw3eDZ9zqrvDeWmky0vCjMRg2A1hEZrgob+K0BRtVLolCdi/S7
         ZghSHptT+Z4duzmjdVulgtopHWlsqE6PRq93YdXJjn1uKcEscE8VV+79i8V8NCV40ZXS
         3//A==
X-Gm-Message-State: AOAM5315vh0q79JKOhNAl4nozOtU1f8H+4JNDftTmh2PnzdgNPts2mBQ
        f0QxNdRqEBaCEx2DevfrQ6mzcw==
X-Google-Smtp-Source: ABdhPJyrVHytZfD8Ie1d6zCBkpXcLxE/o6GfK/L3RDlmZ5FJjNAIAlNe9bNl3s97K1xirDaw7fi3pg==
X-Received: by 2002:a5d:68ca:: with SMTP id p10mr13316wrw.65.1622727206952;
        Thu, 03 Jun 2021 06:33:26 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:104d:bd76:408:a323? ([2a01:e0a:410:bb00:104d:bd76:408:a323])
        by smtp.gmail.com with ESMTPSA id a4sm2855847wme.45.2021.06.03.06.33.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jun 2021 06:33:26 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH] ipv6: parameter p.name is empty
To:     zhang kai <zhangkaiheb@126.com>, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210603095030.2920-1-zhangkaiheb@126.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <d1085905-215f-fb78-4d68-324bd6e48fdd@6wind.com>
Date:   Thu, 3 Jun 2021 15:33:25 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210603095030.2920-1-zhangkaiheb@126.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 03/06/2021 à 11:50, zhang kai a écrit :
> so do not check it.
> 
> Signed-off-by: zhang kai <zhangkaiheb@126.com>
> ---
>  net/ipv6/addrconf.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index b0ef65eb9..4c6b3fc7e 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -2833,9 +2833,6 @@ static int addrconf_set_sit_dstaddr(struct net *net, struct net_device *dev,
>  	if (err)
>  		return err;
>  
> -	dev = __dev_get_by_name(net, p.name);
> -	if (!dev)
> -		return -ENOBUFS;
>  	return dev_open(dev, NULL);
>  }
>  
> 
This bug seems to exist since the beginning of the SIT driver (24 years!):
https://git.kernel.org/pub/scm/linux/kernel/git/davem/netdev-vger-cvs.git/commit/?id=e5afd356a411a
Search addrconf_set_dstaddr()

Acked-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
