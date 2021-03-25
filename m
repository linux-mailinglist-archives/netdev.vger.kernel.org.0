Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B3F3485BE
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbhCYALy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:11:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231675AbhCYAL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 20:11:29 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E23C06174A;
        Wed, 24 Mar 2021 17:11:29 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id l123so165554pfl.8;
        Wed, 24 Mar 2021 17:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=At9VfTXYGbpEkv+bskSHgsrNIlMHMh6pA+O0p4XadnY=;
        b=JzHSHvAX/LmZfhKzSPTiyFsFoa9SM/Kpb55eEqknyhg7p+1zVBFJIwifRXpQKvIKm7
         29WO2+sDSiLmPobMyej3B+6FTj7xVQcee/04lgRq32n77iD96JVMaSZYwDJdTKz150Fc
         ur1Nx+rvyU76xwx/rpEieTou8Co9g5rvcDLQiRjXi2C7zEdZ6PSSOqtHEnxQQp3HQQ2i
         m8r3K1+H5iq2/rdNqF9eVaRgE9BEOPTxT6mis4zlDREzwEnBQl2JIW0Ob/3+yaG9utr4
         ahHWCMETJc3mrqqQoQQ8FeqFI1W8YIVUvyxvvGl3zAVvXCuxNvZkf9u7B1TLLJygq1oi
         D7Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=At9VfTXYGbpEkv+bskSHgsrNIlMHMh6pA+O0p4XadnY=;
        b=e9eCkVMFqqDQTfipZEEHdN0s4F0JgDz2xNGdc4Tyeki7Q361SWFiDjVWqlVbdXgRso
         GcO08PrRQJDUQ7D/hLwLwZrdPHsjYg6xC6qubEP7dybI2+WmjNURXrvIRe08x7Aac9Zl
         66/4MwAzD+MRSrt7DlioMkzjlOoqfBKOTOZZkmCHz4qYXYj3RANu+OsaI+PUerlxeLxR
         gb8PFD0YFrlElGLIOdGmTgyUe56qFt0o7hKHVBHzXaAA4Kn8QDeboQYd54tb+Rdv5O3O
         f/TNY3L68UUwpbhCQWVsXuI7I+KI5z72XIml/k/wqXvOi/VGjodxiKIgR99ytFYw2j8o
         novw==
X-Gm-Message-State: AOAM530bLVqwt3x6ZUZqIf9yflzGaXmRyuyxzkKGUseUUn27I6XMdT7m
        1jwpbqCg0AqL/hn5Yu+IcDU=
X-Google-Smtp-Source: ABdhPJxuN0W54NrcBNuvTfuzBaLxCKaqo+Y8auW6dMf5X8dyxepuoPY7idwk2DQMeNOBjQdUlF/y4g==
X-Received: by 2002:a63:1a0d:: with SMTP id a13mr5009262pga.167.1616631088452;
        Wed, 24 Mar 2021 17:11:28 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ds3sm3496417pjb.23.2021.03.24.17.11.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 17:11:27 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] dt-bindings: define property describing
 supported ethernet PHY modes
To:     =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        pali@kernel.org
References: <20210324103556.11338-1-kabel@kernel.org>
 <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
 <20210325000007.19a38bce@thinkpad>
 <755130b4-2fab-2b53-456f-e2304b1922f2@gmail.com>
 <20210325004525.734f3040@thinkpad>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5fc6fea9-d4c1-bb7e-8f0d-da38c7147825@gmail.com>
Date:   Wed, 24 Mar 2021 17:11:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325004525.734f3040@thinkpad>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 4:45 PM, Marek Behún wrote:
> On Wed, 24 Mar 2021 16:16:41 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
>> On 3/24/2021 4:00 PM, Marek Behún wrote:
>>> On Wed, 24 Mar 2021 14:19:28 -0700
>>> Florian Fainelli <f.fainelli@gmail.com> wrote:
>>>   
>>>>> Another problem is that if lower modes are supported, we should
>>>>> maybe use them in order to save power.    
>>>>
>>>> That is an interesting proposal but if you want it to be truly valuable,
>>>> does not that mean that an user ought to be able to switch between any
>>>> of the supported PHY <=> MAC interfaces at runtime, and then within
>>>> those interfaces to the speeds that yield the best power savings?  
>>>
>>> If the code determines that there are multiple working configurations,
>>> it theoretically could allow the user to switch between them.
>>>
>>> My idea was that this should be done by kernel, though.
>>>
>>> But power saving is not the main problem I am trying to solve.
>>> What I am trying to solve is that if a board does not support all modes
>>> supported by the MAC and PHY, because they are not wired or something,
>>> we need to know about that so that we can select the correct mode for
>>> PHYs that change this mode at runtime.  
>>
>> OK so the runtime part comes from plugging in various SFP modules into a
>> cage but other than that, for a "fixed" link such as a SFF or a soldered
>> down PHY, do we agree that there would be no runtime changing of the
>> 'phy-mode'?
> 
> No, we do not. The PHY can be configured (by strapping pins or by
> sw) to change phy-mode depending on the autonegotiated copper speed.
> 
> So if you plug in an ethernet cable where on the otherside is only 1g
> capable device, the PHY will change mode to sgmii. But if you then plug
> a 5g capable device, the PHY will change mode to 5gbase-r.
> 
> This happens if the PHY is configured into one of these changing
> configurations. It can also be configured to USXGMII, or 10GBASER with
> rate matching.
> 
> Not many MACs in kernel support USXGMII currently.
> 
> And if you use rate matching mode, and the copper side is
> linked in lower speed (2.5g for example), and the MAC will start
> sending too many packets, the internal buffer in the PHY is only 16 KB,
> so it will fill up quickly. So you need pause frames support. But this
> is broken for speeds <= 1g, according to erratum.
> 
> So you really want to change modes. The rate matching mode is
> basically useless.

OK, so whenever there is a link change you are presumably reading the
mode in which the PHY has been reconfigured to, asking the MAC to
configured itself appropriately based on that, and if there is no
intersection, error out?

> 
>>
>> What I am trying to understand is why this needs to be added to the
>> Device Tree as opposed to a bitmask within the PHY driver that indicates
>> the various interface mode capabilities which, looking at the code you
>> shared below, is how you make decisions ultimately.
> 
> Because someone can create a board with a SOC where MAC is capable of
> all of the following modes: 10gbase-r, xaui, rxaui, 5gbase-r,
> 2.5gbase-x, sgmii.
> 
> And use Marvell 88X3310 PHY to translate to copper.
> 
> But only wire the PHY to the MAC with one SerDes lane. So for 10g,
> 10gbase-r mode must be used, xaui and rxaui cannot.
> Or wire the PHY to the MAC with 2 SerDes lanes, but both lanes capable
> only of 6 GHz freq. So for 10g, rxaui must be used.
> 
> And then make the mistake of wiring the strapping pins to the
> rate-matching mode, which is useless.
> 
> So we need to know which modes are supported if we want to change the
> configuration to a working one.

OK, so you need to know the PCB limitations which would be coming via
Device Tree and what mode the PHY has been configured into at the time
you attach/connect to the PHY which you could read from the device itself.

> 
>>>   
>>>>>
>>>>> But for this we need to know which phy-modes are supported on the
>>>>> board.
>>>>>
>>>>> This series adds documentation for a new ethernet PHY property,
>>>>> called `supported-mac-connection-types`.    
>>>>
>>>> That naming does not quite make sense to me, if we want to describe the
>>>> MAC supported connection types, then those would naturally be within the
>>>> Ethernet MAC Device Tree node, no? If we are describing what the PHY is
>>>> capable, then we should be dropping "mac" from the property name not to
>>>> create confusion.  
>>>
>>> I put "mac" there to indicate that this is the SerDes to the MAC (i.e.
>>> host side in Marvell PHY). 88X3310 has another SerDes side (Fiber Side).
>>> I guess I put "mac" there so that if in the future we wanted to specify
>>> supported modes for the fiber side, we could add
>>> `supported-fiber-connection-types`.  
>>
>> You would traditionally find the words "line side" (copper, optical,
>> etc.) and "MAC side" being used in datasheets, maybe you can use a
>> similar naming here?
> 
> So
>   supported-connection-types-mac-side
>   supported-connection-types-line-side
> or maybe media-side?

Yes, that sounds a bit better and more descriptive.

> 
> I am still exploring whether this could be simply defined in the
> ethernet controllers `phy-mode` property, as Rob Herring says. It would
> be simpler...

OK.
-- 
Florian
