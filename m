Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 64CFD17D79A
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 01:54:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgCIAyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 20:54:35 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:38822 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgCIAyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 20:54:35 -0400
Received: by mail-pj1-f66.google.com with SMTP id a16so3637577pju.3
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 17:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=w0fE2a/vw1aDIO+pDwVksZGqPKExtjbmYx3VCYkHt0Q=;
        b=AgNydnEN9+vXGav5asqTHG5iQ8VfNhn76AMU1+OGEUuL21bO2XJmmHIbRuRQK8f4xU
         fQl98ba6YHeT2Zx1BkVU4p9PBU7DFYG+/0lfupF2vOXyCaXOuaQ2x22Nntcv2K+3hNJX
         d27X6IsJD21780veFCDLmHmHwcDioF55jTrFcNmCYBGp/flNEXpn1ZzR6ZMHMAHdIHPe
         bg37+f70ZB0+V2Pi33/xnD4Xf996rPJAt6psOQ88swWC6ktqkHUoe5iKYtbucHZvDadX
         1z0NDXeHkUsWqq+WrBB03JNm4jRzkuiBaXqRawb14DOtd9239pez6/JIErsRm5Oqkjsx
         yNig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=w0fE2a/vw1aDIO+pDwVksZGqPKExtjbmYx3VCYkHt0Q=;
        b=tPd92SVSWE4d7FJQzYtc3sewSwnqjBvGECT4zHKNBJrzuIEpi6dNQsTaE9yT3l4tek
         UWsn2h1V/w326FeU+/afFS0M5N5eFE7uC04nQ2zZdJL55tTbJdUfA0DmzM7rjA2p1NtY
         3BjrlUmLVN6KuQ8K+fKZqCaG3KvFDgDpT1ColFoIrzXvgc5umSWFigohX62lujH87/o0
         9s5IXmNVWu4TzmHB6ZilzJTOZXyg7sHw8QMmBvN3vSVkdyqry0JBLQdcIhoxlJXXNe52
         0RCc1vD6wWNqbYk9fS9uR3pFEssVTpTGbq7GlO9XBHSavimhQ2WMmJb8Djhxgz0ekUlv
         o0cQ==
X-Gm-Message-State: ANhLgQ1qMy9W+muFiwKlZfMeVdXS2lZXoVsifrg7I44oPYCqiJF5IXy/
        Lnf5qNbw11l7cPjnIIwRpcmQUNwM
X-Google-Smtp-Source: ADFU+vvs/tt9FvT1T2RvQMGkc6PCIBiPYkjY3JY3XZHYLrEdcdBlvKMmYy6C6LD6c+W6C3hxO0WUgw==
X-Received: by 2002:a17:90b:3692:: with SMTP id mj18mr542161pjb.170.1583715274339;
        Sun, 08 Mar 2020 17:54:34 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f19sm34576648pgf.33.2020.03.08.17.54.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 17:54:33 -0700 (PDT)
Subject: Re: [PATCH net-next] net: rmnet: set NETIF_F_LLTX flag
To:     subashab@codeaurora.org, Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
References: <20200308134706.18727-1-ap420073@gmail.com>
 <c3ae604f1bd130b3c753578aa89087cb@codeaurora.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <5c28fd8f-c814-7af6-56f9-8c5f70658e22@gmail.com>
Date:   Sun, 8 Mar 2020 17:54:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <c3ae604f1bd130b3c753578aa89087cb@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/8/20 5:28 PM, subashab@codeaurora.org wrote:
> On 2020-03-08 07:47, Taehee Yoo wrote:
>> The rmnet_vnd_setup(), which is the callback of ->ndo_start_xmit() is
>> allowed to call concurrently because it uses RCU protected data.
>> So, it doesn't need tx lock.
>>
>> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
>> ---
>>  drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
>> b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
>> index d7c52e398e4a..d58b51d277f1 100644
>> --- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
>> +++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c
>> @@ -212,6 +212,8 @@ void rmnet_vnd_setup(struct net_device *rmnet_dev)
>>      rmnet_dev->needs_free_netdev = true;
>>      rmnet_dev->ethtool_ops = &rmnet_ethtool_ops;
>>
>> +    rmnet_dev->features |= NETIF_F_LLTX;
>> +
>>      /* This perm addr will be used as interface identifier by IPv6 */
>>      rmnet_dev->addr_assign_type = NET_ADDR_RANDOM;
>>      eth_random_addr(rmnet_dev->perm_addr);
> 
> Hi Taehee
> 
> It seems the flag is deprecated per documentation.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/Documentation/networking/netdevices.txt#n73


This does not count for virtual drivers, like macvlan, bonding, tunnels...

If your ndo_start_xmit() calls dev_queue_xmit() after switching skb->dev to another device,
you do not need a lock.


