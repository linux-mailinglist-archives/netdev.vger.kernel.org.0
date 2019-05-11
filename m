Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A804D1A80C
	for <lists+netdev@lfdr.de>; Sat, 11 May 2019 16:00:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728573AbfEKOAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 May 2019 10:00:22 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37126 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726016AbfEKOAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 May 2019 10:00:22 -0400
Received: by mail-wr1-f67.google.com with SMTP id a12so10647399wrn.4
        for <netdev@vger.kernel.org>; Sat, 11 May 2019 07:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Vv+VEGa/zrxHz7+hDmy2kqli1uFlMdD+EnQxGqgm3NI=;
        b=gP7YxwDYwsZFPIgwe+AyB8L0KQy18iCODxRRT/VfnEj5K31+PwPqxljrbmSF/7hvpR
         8eXcaJkFunCozp5pJ6yfVnL1ShFUlzy5M4wuR1NTZp13tlwW4XyJ0MXrX6Bxzviz5Cb1
         JCM6cV7rhupMdda+NNP6jEN2AKZoQmFwzoUfMgsP6g6Af3wD67WhJ2o+yyzzx83Kkn89
         LkoEkQb/MTdhl84WKcoLt+pPvruSgd5nn9RPfEAT4ygDuQaMhOri8TERDGw0uJoh6rNr
         mcbPVRDL4aP0rqqAQnYkmsR1REPcnL9HesYz/ex0pZC+DH46SBUfRCn68SD+DM92Qmw0
         h6hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Vv+VEGa/zrxHz7+hDmy2kqli1uFlMdD+EnQxGqgm3NI=;
        b=M7Y2sodmyQ5Z4WTzRa3Rd4gzWIyRubiCkN2lSCrqAgO0CwsiFKILrWv+SdwvY6jfVx
         38PTwpafc3FdAO+Ko0aL5N2Ez8Kf52joGXAkiya+oH361LRHhA0p31fyKICDx1HZXXJ2
         9ThGTVNMk2aAS4d3EMLTIqG5Z3XETJVCckoGuEeMHpqcETzLrrQx0uPiTsyPiiQKYtbE
         HKjOsADEUH6h0gFMHaHn7jR+JBq9oQKYjVAyORjI1wObpdNfyrw1/lXx5ObJhCG1A9+Z
         409OnyBIt45aFPdRUvoMmIfHBjiE2px4reD6useZbnuaoBeOqKOk+6untqWVG4Oh/Vaz
         O89w==
X-Gm-Message-State: APjAAAW0VodTZYpNghZnzEVZl3/vrAM+0KrmeAAy4tDI+W71uo2O84Tj
        2aRVVRWtWBQQ3CVa4cx1oHQ=
X-Google-Smtp-Source: APXvYqz9E833/JjAaUZDo4XzqVhausIiEX2Vw+PM0y0qXh1LlLAby+2bZSe5eUDtzXs+iJFIxkp0bw==
X-Received: by 2002:adf:afcb:: with SMTP id y11mr8521802wrd.97.1557583220579;
        Sat, 11 May 2019 07:00:20 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd4:5700:152f:e071:7960:90b9? (p200300EA8BD45700152FE071796090B9.dip0.t-ipconnect.de. [2003:ea:8bd4:5700:152f:e071:7960:90b9])
        by smtp.googlemail.com with ESMTPSA id h24sm14387681wmb.40.2019.05.11.07.00.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 May 2019 07:00:19 -0700 (PDT)
Subject: Re: net: micrel: confusion about phyids used in driver
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Uwe_Kleine-K=c3=b6nig?= <u.kleine-koenig@pengutronix.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Yuiko Oshino <yuiko.oshino@microchip.com>,
        netdev@vger.kernel.org, kernel@pengutronix.de
References: <20190509202929.wg3slwnrfhu4f6no@pengutronix.de>
 <da599967-c423-80dd-945d-5b993c041e90@gmail.com>
 <20190509210745.GD11588@lunn.ch>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <966ad23c-33c2-fffb-6aad-f0e3e6a6ffb4@gmail.com>
Date:   Sat, 11 May 2019 16:00:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190509210745.GD11588@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.05.2019 23:07, Andrew Lunn wrote:
> On Thu, May 09, 2019 at 10:55:29PM +0200, Heiner Kallweit wrote:
>> On 09.05.2019 22:29, Uwe Kleine-König wrote:
>>> Hello,
>>>
>>> I have a board here that has a KSZ8051MLL (datasheet:
>>> http://ww1.microchip.com/downloads/en/DeviceDoc/ksz8051mll.pdf, phyid:
>>> 0x0022155x) assembled. The actual phyid is 0x00221556.
>>>
>> I think the datasheets are the source of the confusion. If the
>> datasheets for different chips list 0x0022155x as PHYID each, and
>> authors of support for additional chips don't check the existing code,
>> then happens what happened.
>> However it's not a rare exception and not Microchip-specific that
>> sometimes vendors use the same PHYID for different chips.
>>
>> And it seems you even missed one: KSZ8795
>> It's a switch and the internal PHY's have id 0x00221550.
>>
>> If the drivers for the respective chips are actually different then we
>> may change the driver to match the exact model number only.
>> However, if there should be a PHY with e.g. id 0x00221554 out there,
>> it wouldn't be supported any longer and the generic PHY driver would
>> be used (what may work or not).
> 
> Hi Heiner
> 
> We might also want to take a look at the code which matches a driver
> to a PHY ID. Ideally we want the most specific match when looking at
> the mask. We can then have device specific matches, and then a more
> general fallback match using a wider mask.
> 
The matching code is the generic driver/device matching code.
As Uwe pointed out before, we can influence the probe order only
by ordering the drivers accordingly and hoping that the core
keeps to the order of registration when probing.

But this still wouldn't solve the issue as there are PHY's with the
same PHYID having registers that need to be treated differently.
When searching the internet a little bit one easily finds old questions
regarding how to tell between KSZ8031 and KSZ8051.

I'm not a fan of workarounds like having one driver and hoping that
writing to a reserved bit on one chip doesn't hurt. You never know
whether this register/bit has an undocumented function.

If these PHY's are primarily used on DT-configured boards, then we
may consider to add DT properties for the features that differ.

> No idea how to actually implement that :-(
> 
>    Andrew
> 
Heiner
