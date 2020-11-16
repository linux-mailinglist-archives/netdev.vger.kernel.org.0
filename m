Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2BD32B5503
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 00:32:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730088AbgKPXao (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 18:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbgKPXan (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 18:30:43 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C58C0613CF;
        Mon, 16 Nov 2020 15:30:43 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x15so9211472pll.2;
        Mon, 16 Nov 2020 15:30:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7FYCGHJlYmaRXLMksd+6qbnneZmBkhJZIw7WgOI0UOE=;
        b=gLe5sdpbW/kH4E5quY1fIXqc69VvXGio3pk76cPJQz+Yr1lgoyk2rC0r6B2mDh8yJi
         L5+/1WxUvrov2xS8B93swbtjf1ZAe1ppKCs4UIxQ0UGGSinVgwwd1CE1L/B3DVosx1Zg
         suDbpRbMx766xUeCM6OIzCDWO7Y5voZc1D9I+QnnAxm8b0tjjBRaZNsEi5fHvS4jdqmL
         HBfFJ3VipsHlK3S2JxDOOBDVTXJxftuKSwBLxEAIJpgblNd6hhiGSRtKu3tD7TsAf+Uc
         IkPmXe76I9jHs1pw48swY1IAEcGPNPqcY0Gzva/alyHqymb4my4lM1LM9GPdUrQ4JtQW
         g2iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7FYCGHJlYmaRXLMksd+6qbnneZmBkhJZIw7WgOI0UOE=;
        b=ARtYkkUy7hVVuAz9GpT3rZzgt9HwLaWDZiHEfsiYcYYDd4MvM2ofqaKBeB+uIwUZhp
         JkC4lFGG2f7vfFtcBfk2yAXUw24t7zdls+N28cKhe2FoqEOyd9jn7DheRNdQvJtJyAhX
         bgejNbsTryt5H+7unBM1XuRTbsCZCaBE4WeWcFpq+ANJ29TWRXqXLmuEjM6cd8pSVJYD
         WXHKTiDAJzn9wk0gl+kuzoSNtRTXIQyrU5uO+v6v9yHZmSimwYr6QI/dTBtMtLr7Zu7J
         85R5pyB9nxyTInsH6HN6UWz7at9sL770wMgPDCAiJVsiQkVIR31ADvByd2j79Mzo/yg/
         rweA==
X-Gm-Message-State: AOAM530fx4QV1z2DA/f5cknHGSg4g5hmPRBb+HDrm0gAx+vQYfQutn03
        XZh47Bwmo11pfzRtEdxqodX01oaor3Q=
X-Google-Smtp-Source: ABdhPJyTfEJWgc3iLOwXgR9mEU2BzDxOSpNx263Tui2bCHs5WAfmVAvAOLj5yTa5C+Vt+PwdkFPPQg==
X-Received: by 2002:a17:902:ee85:b029:d6:c43e:2321 with SMTP id a5-20020a170902ee85b02900d6c43e2321mr14307430pld.29.1605569442171;
        Mon, 16 Nov 2020 15:30:42 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y16sm19858944pfl.144.2020.11.16.15.30.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 15:30:41 -0800 (PST)
Subject: Re: [PATCH v1 net-next] net: dsa: qca: ar9331: add ethtool stats
 support
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20201115073533.1366-1-o.rempel@pengutronix.de>
 <20201116133453.270b8db5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116222146.znetv5u2q2q2vk2j@skbuf>
 <20201116143544.036baf58@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116230053.ddub7p6lvvszz7ic@skbuf>
 <20201116151347.591925ca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201116232731.4utpige7fguzghsi@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <7cb26c4f-0c5d-0e08-5bbe-676f5d66a858@gmail.com>
Date:   Mon, 16 Nov 2020 15:30:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20201116232731.4utpige7fguzghsi@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/16/20 3:27 PM, Vladimir Oltean wrote:
> On Mon, Nov 16, 2020 at 03:13:47PM -0800, Jakub Kicinski wrote:
>> On Tue, 17 Nov 2020 01:00:53 +0200 Vladimir Oltean wrote:
>>> On Mon, Nov 16, 2020 at 02:35:44PM -0800, Jakub Kicinski wrote:
>>>> On Tue, 17 Nov 2020 00:21:46 +0200 Vladimir Oltean wrote:
>>>>> On Mon, Nov 16, 2020 at 01:34:53PM -0800, Jakub Kicinski wrote:
>>>>>> You must expose relevant statistics via the normal get_stats64 NDO
>>>>>> before you start dumping free form stuff in ethtool -S.
>>>>>
>>>>> Completely agree on the point, Jakub, but to be honest we don't give him
>>>>> that possibility within the DSA framework today, see .ndo_get_stats64 in
>>>>> net/dsa/slave.c which returns the generic dev_get_tstats64 implementation,
>>>>> and not something that hooks into the hardware counters, or into the
>>>>> driver at all, for that matter.
>>>>
>>>> Simple matter of coding, right? I don't see a problem.
>>>>
>>>> Also I only mentioned .ndo_get_stats64, but now we also have stats in
>>>> ethtool->get_pause_stats.
>>>
>>> Yes, sure we can do that. The pause stats and packet counter ops would
>>> need to be exposed to the drivers by DSA first, though. Not sure if this
>>> is something you expect Oleksij to do or if we could pick that up separately
>>> afterwards.
>>
>> Well, I feel like unless we draw the line nobody will have
>> the incentive to do the work.
>>
>> I don't mind if it's Oleksij or anyone else doing the plumbing work,
>> but the task itself seems rather trivial.
> 
> So then I'll let Oleksij show his availability.
> 
>>>>> But it's good that you raise the point, I was thinking too that we
>>>>> should do better in terms of keeping the software counters in sync with
>>>>> the hardware. But what would be a good reference for keeping statistics
>>>>> on an offloaded interface? Is it ok to just populate the netdev counters
>>>>> based on the hardware statistics?
>>>>
>>>> IIRC the stats on the interface should be a sum of forwarded in software
>>>> and in hardware. Which in practice means interface HW stats are okay,
>>>> given eventually both forwarding types end up in the HW interface
>>>> (/MAC block).
>>>
>>> A sum? Wouldn't that count the packets sent/received by the stack twice?
>>
>> Note that I said _forwarded_. Frames are either forwarded by the HW or
>> SW (former never hit the CPU, while the latter do hit the CPU or
>> originate from it).
> 
> Ah, you were just thinking out loud, I really did not understand what
> you meant by the separation between "forwarded in software" and
> "forwarded in hardware".
> Yes, the hardware typically only gives us MAC-level counters anyway.
> Another way to look at it is that the number of packets forwarded in
> hardware from a given port are equal to the total number of RX packets
> on that MAC minus the packets seen by the CPU coming from that port.
> So all in all, it's the MAC-level counters we should expose in
> .ndo_get_stats64, I'm glad you agree. As for the error packets, I
> suppose that would be a driver-specific aggregate.
> 
> What about RMON/RFC2819 style etherStatsPkts65to127Octets? We have a
> number of switches supporting that style of counters, including the one
> that Oleksij is adding support for, apparently (but not all switches
> though). I suppose your M.O. is that anything standardizable is welcome
> to be standardized via rtnetlink?
> 
> Andrew, Florian, any opinions here?
> 

Settling on RMON/RFC2819 statistics would work for me, and hopefully is
not too hard to get the various drivers converted to. With respect to
Oleksij's patch, I would tend to accept it so we actually have more
visibility into what standardized counters are available across switch
drivers.
-- 
Florian
