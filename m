Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA2025645C
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 05:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbgH2D3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 23:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726873AbgH2D32 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 23:29:28 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64280C061264
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 20:29:28 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g1so1332887pgm.9
        for <netdev@vger.kernel.org>; Fri, 28 Aug 2020 20:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Py8IMjCBItA6sajyrMCY7as2dK1TPvDX/bq5PjdeoS0=;
        b=teu1kkhWtu1SIbzyhXpTCIC1yxA202NtS9Z0TxAFVSMx4KjtNBP/VgcIESpJgJQfA+
         kkFB1qKvHRVqs1iFLLmYzuKPjNW/1Mck80gJHmeDnNPqEow69VJHs/pupQkNzdQQKLmh
         qz7PDANKOEP2kiGjgcezMtXmUGJYJ8hP9LIvwT4RdYEIzR5WZS8s8alY+f9+ioD0mdUD
         rjYA3AhUjDnFmNPOV1+G5iU0LqKALVSidroLYDt+BL8rE1+7fi+7LU9fR1zFm7/7x7yC
         SlfnAxInehV8iQeTX3To6YqlGLErkkhAXkGvr3Ww+DzNBFim7JPi+GFwSOTANLPO8gNb
         9/4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Py8IMjCBItA6sajyrMCY7as2dK1TPvDX/bq5PjdeoS0=;
        b=h/YmC+B6f+xUHEEBK7JxyVzTXAm7GxCkFim92SXRkjAiqaEpJdSTPIpY0MxDtyImSq
         1O72GOL0J0E1t20Vo0f7K5VsslBZGQCTfhYNy26Mt88IJk9NiemLxpKuhhLEXWjYDMeT
         P8yRqxTboUVr6i/zaRxLGFOGyWhhBGFES0JPVCNqY3VtSKRIW6qPb8YJoYNu2L1WxvlZ
         xMxACu3Y4PEgwnE9tTpvwozJWn6gh+qYcT+0eQ/Dfh0aKaHD/9fM8QiROMqAkVIX5HDz
         0YiUhN72cZ32pNqBvnQ3fWETcG6Sp9SmFXTGbr3BunKyafeyFKwsqnCmyb0zsuZXsoWs
         WgOA==
X-Gm-Message-State: AOAM533DPBGqsxDAP+2Cuxf2eHHfIRhkjt/5mS/++2mhsZbs/JIxbQB/
        9IBGw4CS66Av9bvSfb0F0ukHwXmlcts=
X-Google-Smtp-Source: ABdhPJzzFekPK+2srws1li1d0nYbtociAfRqgbGGzCUHQQRY4D/X5DDE+dm2wgg8pCeejERtIJPDYg==
X-Received: by 2002:a63:d504:: with SMTP id c4mr1273285pgg.138.1598671765883;
        Fri, 28 Aug 2020 20:29:25 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm880708pfq.179.2020.08.28.20.29.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Aug 2020 20:29:25 -0700 (PDT)
Subject: Re: drivers/of/of_mdio.c needs a small modification
To:     =?UTF-8?Q?Adam_Rudzi=c5=84ski?= <adam.rudzinski@arf.net.pl>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     robh+dt@kernel.org, frowand.list@gmail.com,
        netdev <netdev@vger.kernel.org>
References: <c8b74845-b9e1-6d85-3947-56333b73d756@arf.net.pl>
 <20200828222846.GA2403519@lunn.ch>
 <dcfea76d-5340-76cf-7ad0-313af334a2fd@arf.net.pl>
 <20200828225353.GB2403519@lunn.ch>
 <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <891d7e82-f22a-d24b-df5b-44b34dc419b5@gmail.com>
Date:   Fri, 28 Aug 2020 20:29:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <6eb8c287-2d9f-2497-3581-e05a5553b88f@arf.net.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/28/2020 4:14 PM, Adam Rudziński wrote:
> W dniu 2020-08-29 o 00:53, Andrew Lunn pisze:
>> On Sat, Aug 29, 2020 at 12:34:05AM +0200, Adam Rudziński wrote:
>>> Hi Andrew.
>>>
>>> W dniu 2020-08-29 o 00:28, Andrew Lunn pisze:
>>>> Hi Adam
>>>>
>>>>> If kernel has to bring up two Ethernet interfaces, the processor 
>>>>> has two
>>>>> peripherals with functionality of MACs (in i.MX6ULL these are Fast 
>>>>> Ethernet
>>>>> Controllers, FECs), but uses a shared MDIO bus, then the kernel 
>>>>> first probes
>>>>> one MAC, enables clock for its PHY, probes MDIO bus tryng to 
>>>>> discover _all_
>>>>> PHYs, and then probes the second MAC, and enables clock for its 
>>>>> PHY. The
>>>>> result is that the second PHY is still inactive during PHY 
>>>>> discovery. Thus,
>>>>> one Ethernet interface is not functional.
>>>> What clock are you talking about? Do you have the FEC feeding a 50MHz
>>>> clock to the PHY? Each FEC providing its own clock to its own PHY? And
>>>> are you saying a PHY without its reference clock does not respond to
>>>> MDIO reads and hence the second PHY does not probe because it has no
>>>> reference clock?
>>>>
>>>>       Andrew
>>> Yes, exactly. In my case the PHYs are LAN8720A, and it works this way.
>> O.K. Boards i've seen like this have both PHYs driver from the first
>> MAC. Or the clock goes the other way, the PHY has a crystal and it
>> feeds the FEC.
>>
>> I would say the correct way to solve this is to make the FEC a clock
>> provider. It should register its clocks with the common clock
>> framework. The MDIO bus can then request the clock from the second FEC
>> before it scans the bus. Or we add the clock to the PHY node so it
>> enables the clock before probing it. There are people who want this
>> sort of framework code, to be able to support a GPIO reset, which
>> needs releasing before probing the bus for the PHY.
>>
>> Anyway, post your patch, so we get a better idea what you are
>> proposing.
>>
>>     Andrew
> 
> Hm, this sounds reasonable, but complicated at the same time. I have 
> spent some time searching for possible solution and never found anything 
> teaching something similar, so I'd also speculate that it's kind of not 
> very well documented. That doesn't mean I'm against these solutions, 
> just that seems to be beyond capabilities of many mortals who even try 
> to read.
> 
> OK, so a patch it is. Please, let me know how to make the patch so that 
> it was useful and as convenient as possible for you. Would you like me 
> to use some specific code/repo/branch/... as its base?

This is targeting the net-next tree, see the netdev-FAQ here for details:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/networking/netdev-FAQ.rst

I will be posting some patches for our ARCH_BRCMSTB platforms which 
require that we turn on the internal PHY's digital clock otherwise it 
does not respond on the MDIO bus and we cannot discover its ID and we 
cannot bind to a PHY driver. I will make sure to copy you so you can see 
if this would work for you.
-- 
Florian
