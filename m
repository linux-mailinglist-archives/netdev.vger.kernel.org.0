Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 396D2442533
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 02:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhKBBjw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 21:39:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229571AbhKBBjv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 21:39:51 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92CE2C061714
        for <netdev@vger.kernel.org>; Mon,  1 Nov 2021 18:37:17 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w193so27721514oie.1
        for <netdev@vger.kernel.org>; Mon, 01 Nov 2021 18:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3goaEmgNW5oGh1mebBEkK8dSMeNT0WmNICLzvMb+mek=;
        b=LpfT9ch7n5FNFjJkgz7BlVF7Fh4SpeX7w7rHTCoNyfs63Ba3CCAdQF7X2nkvxVM2h0
         EvWVAxt3VpxxD04LXldS9uZqcdoov2f/duarwxluEgDmka0u7O5YYf9/7qVFQZ43eewz
         bz/dvfI0yrnU550XdCbyzqdwNXAl3wpT2wtagMHzu64YxFnQSFUVK1IaVfEdpQtuCFHy
         jPuxv3dwSG59fkWBH2DGvwlfQsrxSaGX+7E35IQXK8a2EaKA7bcZxNiCZPlzRqKR5eNE
         86NNIuRJVkyI0iYfQox8nBr/bYyHwQaKBs5d3bwENZ1xaIY4X5NoTLmazWne8gAJuVaN
         VtVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3goaEmgNW5oGh1mebBEkK8dSMeNT0WmNICLzvMb+mek=;
        b=VF0X/5uKl8pP089dBWy4HLClwqQpGTH3AFt5gtiSvDRHR90NTIrWms8GXKhnMSFGd5
         Jepvoxjo63ec/88hU3NDf7B7ZvlAXZodiK5Gw7EhHhm0DXsce3iv3Pd8aXPFE+KcpIDX
         M7q2Du/g0Hk64KoR3q88QgQTLAwjQwWkvxWz01V3iXJEWNqkQlVhLmvLInsKUmKbWIpa
         0yrOLjlccFYoWIC/DWrHoJZRyMmNpWZNHjU+A+YM26Uy02iQosirvtDrC/goR4RiStuC
         GE8+9p0X7KwCYwvQUykm9MiGbVrwyC+fFDPYeJqH42pP8Db0I2PyhL+Qw8M1ylVvh4Rj
         Insw==
X-Gm-Message-State: AOAM531eccbPtdBcVueM4YpiYYMOZXrNgyZQoZaPaQABGG2HWAp2oTkx
        CJH0RyVtsqWAuFB1Zr1qEIc=
X-Google-Smtp-Source: ABdhPJw3QFBM38UQNmt9fTnvcwDpQk+5BB2NxpOwEWzM7zAvQ96LottV/vw7jf0UdQ5nDyIJGlIMdQ==
X-Received: by 2002:a05:6808:1a15:: with SMTP id bk21mr2356155oib.31.1635817037008;
        Mon, 01 Nov 2021 18:37:17 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id g94sm1567909otg.10.2021.11.01.18.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 18:37:16 -0700 (PDT)
Message-ID: <05fd4fe6-da80-6e1f-2122-d38c6b58675c@gmail.com>
Date:   Mon, 1 Nov 2021 19:37:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.2.1
Subject: Re: [PATCH 1/3] net: arp: introduce arp_evict_nocarrier sysctl
 parameter
Content-Language: en-US
To:     James Prestwood <prestwoj@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, roopa@nvidia.com,
        daniel@iogearbox.net, vladimir.oltean@nxp.com, idosch@nvidia.com,
        nikolay@nvidia.com, yajun.deng@linux.dev, zhutong@amazon.com,
        johannes@sipsolutions.net, jouni@codeaurora.org
References: <20211101173630.300969-1-prestwoj@gmail.com>
 <20211101173630.300969-2-prestwoj@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211101173630.300969-2-prestwoj@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/1/21 11:36 AM, James Prestwood wrote:
> This change introduces a new sysctl parameter, arp_evict_nocarrier.
> When set (default) the ARP cache will be cleared on a NOCARRIER event.
> This new option has been defaulted to '1' which maintains existing
> behavior.
> 
> Clearing the ARP cache on NOCARRIER is relatively new, introduced by:
> 
> commit 859bd2ef1fc1110a8031b967ee656c53a6260a76
> Author: David Ahern <dsahern@gmail.com>
> Date:   Thu Oct 11 20:33:49 2018 -0700
> 
>     net: Evict neighbor entries on carrier down
> 
> The reason for this changes is to prevent the ARP cache from being
> cleared when a wireless device roams. Specifically for wireless roams
> the ARP cache should not be cleared because the underlying network has not
> changed. Clearing the ARP cache in this case can introduce significant
> delays sending out packets after a roam.
> 
> A user reported such a situation here:
> 
> https://lore.kernel.org/linux-wireless/CACsRnHWa47zpx3D1oDq9JYnZWniS8yBwW1h0WAVZ6vrbwL_S0w@mail.gmail.com/
> 
> After some investigation it was found that the kernel was holding onto
> packets until ARP finished which resulted in this 1 second delay. It
> was also found that the first ARP who-has was never responded to,
> which is actually what caues the delay. This change is more or less
> working around this behavior, but again, there is no reason to clear
> the cache on a roam anyways.
> 
> As for the unanswered who-has, we know the packet made it OTA since
> it was seen while monitoring. Why it never received a response is
> unknown. In any case, since this is a problem on the AP side of things
> all that can be done is to work around it until it is solved.
> 
> Some background on testing/reproducing the packet delay:
> 
> Hardware:
>  - 2 access points configured for Fast BSS Transition (Though I don't
>    see why regular reassociation wouldn't have the same behavior)
>  - Wireless station running IWD as supplicant
>  - A device on network able to respond to pings (I used one of the APs)
> 
> Procedure:
>  - Connect to first AP
>  - Ping once to establish an ARP entry
>  - Start a tcpdump
>  - Roam to second AP
>  - Wait for operstate UP event, and note the timestamp
>  - Start pinging
> 
> Results:
> 
> Below is the tcpdump after UP. It was recorded the interface went UP at
> 10:42:01.432875.
> 
> 10:42:01.461871 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
> 10:42:02.497976 ARP, Request who-has 192.168.254.1 tell 192.168.254.71, length 28
> 10:42:02.507162 ARP, Reply 192.168.254.1 is-at ac:86:74:55:b0:20, length 46
> 10:42:02.507185 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 1, length 64
> 10:42:02.507205 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 2, length 64
> 10:42:02.507212 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 3, length 64
> 10:42:02.507219 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 4, length 64
> 10:42:02.507225 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 5, length 64
> 10:42:02.507232 IP 192.168.254.71 > 192.168.254.1: ICMP echo request, id 52792, seq 6, length 64
> 10:42:02.515373 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 1, length 64
> 10:42:02.521399 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 2, length 64
> 10:42:02.521612 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 3, length 64
> 10:42:02.521941 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 4, length 64
> 10:42:02.522419 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 5, length 64
> 10:42:02.523085 IP 192.168.254.1 > 192.168.254.71: ICMP echo reply, id 52792, seq 6, length 64
> 
> You can see the first ARP who-has went out very quickly after UP, but
> was never responded to. Nearly a second later the kernel retries and
> gets a response. Only then do the ping packets go out. If an ARP entry
> is manually added prior to UP (after the cache is cleared) it is seen
> that the first ping is never responded to, so its not only an issue with
> ARP but with data packets in general.
> 
> As mentioned prior, the wireless interface was also monitored to verify
> the ping/ARP packet made it OTA which was observed to be true.
> 
> Signed-off-by: James Prestwood <prestwoj@gmail.com>
> ---
>  Documentation/networking/ip-sysctl.rst |  9 +++++++++
>  include/linux/inetdevice.h             |  2 ++
>  include/uapi/linux/ip.h                |  1 +
>  include/uapi/linux/sysctl.h            |  1 +
>  net/ipv4/arp.c                         | 11 ++++++++++-
>  net/ipv4/devinet.c                     |  4 ++++
>  6 files changed, 27 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
