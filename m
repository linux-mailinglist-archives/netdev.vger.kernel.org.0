Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6262D55F1
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 09:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbgLJI6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 03:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388201AbgLJIuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 03:50:16 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD8D4C0613CF
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 00:49:35 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id p22so4596867edu.11
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 00:49:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=CZayN64RkmFgP9YFt0ohbXNG2Yfe239YNxPd4WUrfnQ=;
        b=FF/92pZYdsUc4EP0t0DHnNjQJw52sDA2J7zOygjMInZJJIJm3YRCEW5zClNClV2HO0
         uaUSZ+EtQEbI5EKou+n60PAHQ49tAE2Ouo+Ew404toupyldzPZ65NqZeMaIC766v4FaG
         gdP06SRX34myU8O3o5URN5weEtM90gshX1hyWWlQYMGk+Iba27zPHmF4rG6Xw/IdHrGR
         upFoJW8FvVeU7T5CbD+xnzALSDFg5EMXL0jolkWolMAGeErJ9MMuxKn0peo9OsearkQq
         J/+HiZI+qSapDz9UM4+IdyjXpyup7GNYg8giWuJurkMS6guJxZYwyi2R2T09HQtt+9Wn
         b7iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZayN64RkmFgP9YFt0ohbXNG2Yfe239YNxPd4WUrfnQ=;
        b=Kfm8gcDPOifaWm21ypEBq/yrdD8caQBVZr0zgIbYOZwQPTgkH14vGQMYKS7WkwuskA
         xkgslCncgxlncJMVetuBA7sxHsDvBD1fiOh3y/Sm5RVc1xqJdV8/uE3iKI44yEo8Xhsm
         ZSINU4nVDBKcq27jPg1lNFtbbLpCYPHa4liSTfuHk0kXiPeazoYKqNtO8o5DKDwqQF1A
         d8X5nt78PB88sVzMLPoOSeD9IC0hNS+beuohrfdrC1CMq0BjJ1T0DEqqFits4ZZvcrcw
         ZQwig68gNnLZCpcDnTK/50C1vQMaxFq4IkPPzwFCbJo1DDoPNevypeCryoTaLAt6sG/3
         YOXA==
X-Gm-Message-State: AOAM531yn57YjZj6qek/mzDW21srzsrHZAxMNhj7Il6QY8G+A1tS9eOY
        6MhBJBjpcgDYY10cGBh9lwJmBg==
X-Google-Smtp-Source: ABdhPJwbUB1pNPJ9JA6DsnfSBsUb/y2v8ErUkWB3ocdPkXUmhlTipaOkkqW4P67vhn4cVvSaWPjawA==
X-Received: by 2002:a50:d5c4:: with SMTP id g4mr5497199edj.334.1607590174408;
        Thu, 10 Dec 2020 00:49:34 -0800 (PST)
Received: from [192.168.1.16] (77.109.117.213.adsl.dyn.edpnet.net. [77.109.117.213])
        by smtp.gmail.com with ESMTPSA id e3sm3733082ejq.96.2020.12.10.00.49.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 00:49:33 -0800 (PST)
Subject: Re: [PATCH net 1/4] net: freescale/fman: Split the main resource
 region reservation
To:     Madalin Bucur <madalin.bucur@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20201203135039.31474-1-patrick.havelange@essensium.com>
 <20201203135039.31474-2-patrick.havelange@essensium.com>
 <AM6PR04MB39764190C3CC885EAA84E8B3ECF20@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <e488ed95-3672-fdcb-d678-fdd4eb9a8b4b@essensium.com>
 <AM6PR04MB3976F905489C0CB2ECD1A6FAECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <8c28d03a-8831-650c-cf17-9a744d084479@essensium.com>
 <AM6PR04MB3976721D38D6EAE91E6F3F37ECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   Patrick Havelange <patrick.havelange@essensium.com>
Message-ID: <9a118a8d-ce39-c71b-9efe-3a4fc86041ee@essensium.com>
Date:   Thu, 10 Dec 2020 09:49:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM6PR04MB3976721D38D6EAE91E6F3F37ECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 19:55, Madalin Bucur wrote:
>> -----Original Message-----
>> From: Patrick Havelange <patrick.havelange@essensium.com>
>> Sent: 09 December 2020 16:17
>> To: Madalin Bucur <madalin.bucur@nxp.com>; David S. Miller
>> <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.org>;
>> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH net 1/4] net: freescale/fman: Split the main resource
>> region reservation
>>
>>>>> area. I'm assuming this is the problem you are trying to address here,
>>>>> besides the stack corruption issue.
>>>>
>>>> Yes exactly.
>>>> I did not add this behaviour (having a main region and subdrivers using
>>>> subregions), I'm just trying to correct what is already there.
>>>> For example: this is some content of /proc/iomem for one board I'm
>>>> working with, with the current existing code:
>>>> ffe400000-ffe4fdfff : fman
>>>>      ffe4e0000-ffe4e0fff : mac
>>>>      ffe4e2000-ffe4e2fff : mac
>>>>      ffe4e4000-ffe4e4fff : mac
>>>>      ffe4e6000-ffe4e6fff : mac
>>>>      ffe4e8000-ffe4e8fff : mac
>>>>
>>>> and now with my patches:
>>>> ffe400000-ffe4fdfff : /soc@ffe000000/fman@400000
>>>>      ffe400000-ffe480fff : fman
>>>>      ffe488000-ffe488fff : fman-port
>>>>      ffe489000-ffe489fff : fman-port
>>>>      ffe48a000-ffe48afff : fman-port
>>>>      ffe48b000-ffe48bfff : fman-port
>>>>      ffe48c000-ffe48cfff : fman-port
>>>>      ffe4a8000-ffe4a8fff : fman-port
>>>>      ffe4a9000-ffe4a9fff : fman-port
>>>>      ffe4aa000-ffe4aafff : fman-port
>>>>      ffe4ab000-ffe4abfff : fman-port
>>>>      ffe4ac000-ffe4acfff : fman-port
>>>>      ffe4c0000-ffe4dffff : fman
>>>>      ffe4e0000-ffe4e0fff : mac
>>>>      ffe4e2000-ffe4e2fff : mac
>>>>      ffe4e4000-ffe4e4fff : mac
>>>>      ffe4e6000-ffe4e6fff : mac
>>>>      ffe4e8000-ffe4e8fff : mac
>>>>
>>>>> While for the latter I think we can
>>>>> put together a quick fix, for the former I'd like to take a bit of
>> time
>>>>> to select the best fix, if one is really needed. So, please, let's
>> split
>>>>> the two problems and first address the incorrect stack memory use.
>>>>
>>>> I have no idea how you can fix it without a (more correct this time)
>>>> dummy region passed as parameter (and you don't want to use the first
>>>> patch). But then it will be useless to do the call anyway, as it won't
>>>> do any proper verification at all, so it could also be removed entirely,
>>>> which begs the question, why do it at all in the first place (the
>>>> devm_request_mem_region).
>>>>
>>>> I'm not an expert in that part of the code so feel free to correct me
>> if
>>>> I missed something.
>>>>
>>>> BR,
>>>>
>>>> Patrick H.
>>>
>>> Hi, Patrick,
>>>
>>> the DPAA entities are described in the device tree. Adding some
>> hardcoding in
>>> the driver is not really the solution for this problem. And I'm not sure
>> we have
>>
>> I'm not seeing any problem here, the offsets used by the fman driver
>> were already there, I just reorganized them in 2 blocks.
>>
>>> a clear problem statement to start with. Can you help me on that part?
>>
>> - The current call to __devm_request_region in fman_port.c is not correct.
>>
>> One way to fix this is to use devm_request_mem_region, however this
>> requires that the main fman would not be reserving the whole region.
>> This leads to the second problem:
>> - Make sure the main fman driver is not reserving the whole region.
>>
>> Is that clearer like this ?
>>
>> Patrick H.

Hi,

> 
> The overlapping IO areas result from the device tree description, that in turn
> mimics the HW description in the manual. If we really want to remove the nesting,
> we should change the device trees, not the drivers.

But then that change would not be compatible with the existing device 
trees in already existing hardware. I'm not sure how to handle that case 
properly.

> If we want to hack it,
> instead of splitting ioremaps, we can reserve 4 kB in the FMan driver,
> and keep the ioremap as it is now, with the benefit of less code churn.

but then the ioremap and the memory reservation do not match. Why bother 
at all then with the mem reservation, just ioremap only and be done with 
it. What I'm saying is, I don't see the point of having a "fake" 
reservation call if it does not correspond that what is being used.

> In the end, what the reservation is trying to achieve is to make sure there
> is a single driver controlling a certain peripeheral, and this basic
> requirement would be addressed by that change plus devm_of_iomap() for child
> devices (ports, MACs).

Again, correct me if I'm wrong, but with the fake mem reservation, it 
would *not* make sure that a single driver is controlling a certain 
peripheral.

My point is, either have a *correct* mem reservation, or don't have one 
at all. There is no point in trying to cheat the system.

Patrick H.

> 
> Madalin
> 
