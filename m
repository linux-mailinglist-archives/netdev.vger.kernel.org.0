Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 231562D57DD
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 11:07:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgLJKGl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 05:06:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728353AbgLJKGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 05:06:30 -0500
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3ACAC06179C
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:05:49 -0800 (PST)
Received: by mail-ed1-x543.google.com with SMTP id cw27so4855763edb.5
        for <netdev@vger.kernel.org>; Thu, 10 Dec 2020 02:05:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=essensium.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dYyIFuo77eWpup6s+qRK/CtxPzV7SU+lryIdSY50mGQ=;
        b=fMoW9WpJONRgpIZYXCjDHfmKvhovPVeZATproWZn8soyVYcHQZqUuUFJgQBW7BOaDk
         EO9jBzeCo/ZnMhYbTHpGp1xCgx4aneOAQYBk9Y+91nwFg21FcagHbDDiQdZojfST2cB8
         mOBTMStJ5m8cwiKByMJsQfwTUXOHh7fJd1vAgZ1rExdAl/RyID9j0fPQRpPx4Xcz0fPv
         tpXXjx6H+hZjPCKQc9pEf4fwzMK8Oh2OooicNfr23ZwSKelG6MaGwV50cRDlzV5H8g+U
         aeQxIid8MWyx6+ereqGZIF8rUDx9Iwon2+7rkL4c7dzht3Nwxf5gqQ+qz7erPowmyEhM
         PiDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dYyIFuo77eWpup6s+qRK/CtxPzV7SU+lryIdSY50mGQ=;
        b=WY7yskNYhD2kvlJfUN1QBWaGj/awJp/3l8O1UZoUK3HDntY8IBG4rbhoYkm2j+vRJR
         4CbJCUdF9BaSGRe3P2PWRPJjSOHnbWO85Ne/XFOfiw1djQm/iTX1lFGYWFJuqQStsWue
         C6wUP9edsbUW3Tmi4PyiansZVBjJNk15gCwBChn8o0eNeeiycz3mNMWALh/9oBx/r9LN
         P/lxRmoAlBcQL59x5Txh9GMSHjVsyoVulpnkdTYtQNhERr7vEX6/xpK26PQy9R/gn7YD
         LOl1M2g777eujQhe9CPf7p2ax1k/sBVAasVQVgJpv5wtjV7WlK1Gtgi/ejPN33Zw8jJx
         rVRg==
X-Gm-Message-State: AOAM530GkEiarOgcqeViPZgWQuLhE58+U9AmRMbeYY7PlErb7VSf/FcX
        WJrfObQnBVfYiT6pC8g10ZUrOQ==
X-Google-Smtp-Source: ABdhPJyPymra7MZRmC4i4cHn92ZFc67Km3dGUG5yHta/c/JjAat55la1+odkg57XtyuouY4VhN7igA==
X-Received: by 2002:a05:6402:610:: with SMTP id n16mr5860805edv.172.1607594748563;
        Thu, 10 Dec 2020 02:05:48 -0800 (PST)
Received: from [192.168.1.16] (77.109.117.213.adsl.dyn.edpnet.net. [77.109.117.213])
        by smtp.gmail.com with ESMTPSA id oq7sm4103032ejb.63.2020.12.10.02.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Dec 2020 02:05:47 -0800 (PST)
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
 <9a118a8d-ce39-c71b-9efe-3a4fc86041ee@essensium.com>
 <AM6PR04MB3976C893BE91E755D439EDFFECCB0@AM6PR04MB3976.eurprd04.prod.outlook.com>
From:   Patrick Havelange <patrick.havelange@essensium.com>
Message-ID: <51b57945-c238-0c58-ef12-562911a56f8a@essensium.com>
Date:   Thu, 10 Dec 2020 11:05:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <AM6PR04MB3976C893BE91E755D439EDFFECCB0@AM6PR04MB3976.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-10 10:05, Madalin Bucur wrote:
>> -----Original Message-----
>> From: Patrick Havelange <patrick.havelange@essensium.com>

[snipped]

>>
>> But then that change would not be compatible with the existing device
>> trees in already existing hardware. I'm not sure how to handle that case
>> properly.
> 
> One needs to be backwards compatible with the old device trees, so we do not
> really have a simple answer, I know.
> 
>>> If we want to hack it,
>>> instead of splitting ioremaps, we can reserve 4 kB in the FMan driver,
>>> and keep the ioremap as it is now, with the benefit of less code churn.
>>
>> but then the ioremap and the memory reservation do not match. Why bother
>> at all then with the mem reservation, just ioremap only and be done with
>> it. What I'm saying is, I don't see the point of having a "fake"
>> reservation call if it does not correspond that what is being used.
> 
> The reservation is not fake, it just covering the first portion of the ioremap.
> Another hypothetical FMan driver would presumably reserve and ioremap starting
> from the same point, thus the desired error would be met.
> 
> Regarding removing reservation altogether, yes, we can do that, in the child
> device drivers. That will fix that use after free issue you've found and align
> with the custom, hierarchical structure of the FMan devices/drivers. But would
> leave them without the double use guard we have when using the reservation.
> 
>>> In the end, what the reservation is trying to achieve is to make sure
>> there
>>> is a single driver controlling a certain peripeheral, and this basic
>>> requirement would be addressed by that change plus devm_of_iomap() for
>> child
>>> devices (ports, MACs).
>>
>> Again, correct me if I'm wrong, but with the fake mem reservation, it
>> would *not* make sure that a single driver is controlling a certain
>> peripheral.
> 
> Actually, it would. If the current FMan driver reserves the first part of the FMan
> memory, then another FMan driver (I do not expect a random driver trying to map the
> FMan register area)

Ha!, now I understand your point. I still think it is not a clean 
solution, as the reservation do not match the ioremap usage.

> would likely try to use that same part (with the same or
> a different size, it does not matter, there will be an error anyway) and the
> reservation attempt will fail. If we fix the child device drivers, then they
> will have normal mappings and reservations.
> 
>> My point is, either have a *correct* mem reservation, or don't have one
>> at all. There is no point in trying to cheat the system.
> 
> Now we do not have correct reservations for the child devices because the
> parent takes it all for himself. Reduce the parent reservation and make room
> for correct reservations for the child. The two-sections change you've made may
> try to be correct but it's overkill for the purpose of detecting double use.

But it is not overkill if we want to detect potential subdrivers mapping 
sections that would not start at the main fman region (but still part of 
the main fman region).

> And I also find the patch to obfuscate the already not so readable code so I'd
> opt for a simpler fix.

As said already, I'm not in favor of having a reservation that do not 
match the real usage.

And in my opinion, having a mismatch with the mem reservation and the 
mem usage is also the kind of obfuscation that we want to avoid.

Yes now the code is slightly more complex, but it is also slightly more 
correct.

I'm not seeing currently another way on how to make it simpler *and* 
correct at the same time.

Patrick H.

> 
> Madalin
> 
