Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBC6B2D440B
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 15:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732873AbgLIORh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 09:17:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729725AbgLIORh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 09:17:37 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D5CC0613D6
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 06:16:56 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id g20so2367020ejb.1
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 06:16:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0BawNQzW+1YSRYczgI/IFlRkYH5dyypysXXzW34PR7E=;
        b=dkyx9kMe5DMSqgUmXwOtMhFctIqTIUtmaN+ySfS8QZ1drhelQDc8Wi4MDwAhkK2ITC
         SQT+Isol2VuZPjLqfFSvL/jRAc24jhxwIEgQiSRKea0lmw2Mo8awtzjKWRM1Btg0r+q6
         8vaBBsXnXKK5iHIy3DiX/M63QbVUIryHytQppdPJedtYA++yZrfkBOtIvdUQDFRQUH6T
         fozdx5fy0En6iwLV1WqtayPKGpr+cv4iuVgYNwvwcnXmaYe0GILNPFrw71SAk/OQV1Wh
         8+r4OtsOGO4STSTT2fa+JRRBKfMfiqesI9VF2uxtVkuKMOgeviKvVC3aviOsjL4UctF7
         VSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0BawNQzW+1YSRYczgI/IFlRkYH5dyypysXXzW34PR7E=;
        b=k63ISHc+LKJvqpXGqxnwGAgvSUZAE8JmIQTYT/U7BcM6UCPr94+RuZNyqabnOfN/zO
         uZcKepVZwTZ1QkZQB+Rk3WNVHBFQdm0BMd53OHqeJEXQ6iJW2baMIPE0CNuI8FgMnXU4
         KtXlwEynxIuJyfZIuFU6RuY0C5PQBsCmyvTrA8BxqUpJigiSoTS+5kADI5zalk9m+SeF
         putQwosbqoxPWFxJdTmXwOMwK+1u5EJayZ3dJCo0SFHBHaxRTNsb9mU8A368B8GOtec3
         fuhGdmA8naBbRQ8hAoQsEHTIKIsvdUKKE6ArxpSoJBbkgR+jb4aBfX5fEx0Crpmo/nq6
         nvdQ==
X-Gm-Message-State: AOAM533GCX3wBZ7BQMUR+AZeb3oqDXdY01SWGSDG+kuJ9kX2DpCfOaSL
        7w1vrzeS4Gt4uX4IfQJ4QEJqVpsv5o/5Mw==
X-Google-Smtp-Source: ABdhPJyUoz168raWJN7okvkHdEQFynLKIfbDBJSmvFlwAFMJcfpQxLxUBFZiUnoF5+QHV3lBIgl43w==
X-Received: by 2002:a17:906:60d2:: with SMTP id f18mr2174495ejk.528.1607523415333;
        Wed, 09 Dec 2020 06:16:55 -0800 (PST)
Received: from [10.8.0.46] (ip-188-118-3-185.reverse.destiny.be. [188.118.3.185])
        by smtp.gmail.com with ESMTPSA id x9sm1622565ejd.99.2020.12.09.06.16.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 06:16:54 -0800 (PST)
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
From:   Patrick Havelange <patrick.havelange@essensium.com>
Message-ID: <8c28d03a-8831-650c-cf17-9a744d084479@essensium.com>
Date:   Wed, 9 Dec 2020 15:16:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM6PR04MB3976F905489C0CB2ECD1A6FAECCC0@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>> area. I'm assuming this is the problem you are trying to address here,
>>> besides the stack corruption issue.
>>
>> Yes exactly.
>> I did not add this behaviour (having a main region and subdrivers using
>> subregions), I'm just trying to correct what is already there.
>> For example: this is some content of /proc/iomem for one board I'm
>> working with, with the current existing code:
>> ffe400000-ffe4fdfff : fman
>>     ffe4e0000-ffe4e0fff : mac
>>     ffe4e2000-ffe4e2fff : mac
>>     ffe4e4000-ffe4e4fff : mac
>>     ffe4e6000-ffe4e6fff : mac
>>     ffe4e8000-ffe4e8fff : mac
>>
>> and now with my patches:
>> ffe400000-ffe4fdfff : /soc@ffe000000/fman@400000
>>     ffe400000-ffe480fff : fman
>>     ffe488000-ffe488fff : fman-port
>>     ffe489000-ffe489fff : fman-port
>>     ffe48a000-ffe48afff : fman-port
>>     ffe48b000-ffe48bfff : fman-port
>>     ffe48c000-ffe48cfff : fman-port
>>     ffe4a8000-ffe4a8fff : fman-port
>>     ffe4a9000-ffe4a9fff : fman-port
>>     ffe4aa000-ffe4aafff : fman-port
>>     ffe4ab000-ffe4abfff : fman-port
>>     ffe4ac000-ffe4acfff : fman-port
>>     ffe4c0000-ffe4dffff : fman
>>     ffe4e0000-ffe4e0fff : mac
>>     ffe4e2000-ffe4e2fff : mac
>>     ffe4e4000-ffe4e4fff : mac
>>     ffe4e6000-ffe4e6fff : mac
>>     ffe4e8000-ffe4e8fff : mac
>>
>>> While for the latter I think we can
>>> put together a quick fix, for the former I'd like to take a bit of time
>>> to select the best fix, if one is really needed. So, please, let's split
>>> the two problems and first address the incorrect stack memory use.
>>
>> I have no idea how you can fix it without a (more correct this time)
>> dummy region passed as parameter (and you don't want to use the first
>> patch). But then it will be useless to do the call anyway, as it won't
>> do any proper verification at all, so it could also be removed entirely,
>> which begs the question, why do it at all in the first place (the
>> devm_request_mem_region).
>>
>> I'm not an expert in that part of the code so feel free to correct me if
>> I missed something.
>>
>> BR,
>>
>> Patrick H.
> 
> Hi, Patrick,
> 
> the DPAA entities are described in the device tree. Adding some hardcoding in
> the driver is not really the solution for this problem. And I'm not sure we have

I'm not seeing any problem here, the offsets used by the fman driver 
were already there, I just reorganized them in 2 blocks.

> a clear problem statement to start with. Can you help me on that part?

- The current call to __devm_request_region in fman_port.c is not correct.

One way to fix this is to use devm_request_mem_region, however this 
requires that the main fman would not be reserving the whole region. 
This leads to the second problem:
- Make sure the main fman driver is not reserving the whole region.

Is that clearer like this ?

Patrick H.

> 
> Madalin
> 
