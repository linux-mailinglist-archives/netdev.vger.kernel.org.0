Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 914C7348525
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 00:17:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239002AbhCXXQy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 19:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhCXXQp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 19:16:45 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B24C06174A;
        Wed, 24 Mar 2021 16:16:44 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id w8so251647pjf.4;
        Wed, 24 Mar 2021 16:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OtUEvkCJ2SPvQKrg37lPkJrHw8GNfzDTe5ABJYj7Lcc=;
        b=t9qDCIz4c29vPBrjl5t9XMJ6+sixb6Eg+AWdeVfIuFNWiMdkD4Gvwx0Sk7GW7d0fOy
         Gln4PXOkJdAJm9eTybshTVeOPXZmOc4ipwCj70XFRmi7jVqOl8uBQfPC03zTNXpzPSIV
         fe85ZkzacMLAzSmTmmdMnKrpiYBVMjh/r4i1gItwyKYOSV9rdLRimQa+GCyLxMd4u9/o
         CS5/e44rFGJUcpcNQRNCkOcx2sWYbQ42DwxF1hlwmPDJlQlc0ZGBl7j9kSTc9/b2hwf3
         iYvn5XyJf6w02agjtYVsnXxQKeD95xQsvt4ohJL174r1xflUrMFgz6MZCCt1GrynE6Te
         tQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OtUEvkCJ2SPvQKrg37lPkJrHw8GNfzDTe5ABJYj7Lcc=;
        b=LRRJIDy7LTGUQTYCsTWcpGVEg9Qzfvi5SeiYBroB4ZcMeXk+sxDOg1Ht6wUV7IRgu8
         5nnBZbKjtQTIj0RepPSGa3k6dvzZ6mCkt3SBwj/hCi2USqP6V9J3Qk6Ko79492R5vhSt
         B9RpJBLn/OlnMpHAYmShqe4IglJXKXOCf4y6wEplkU71QXyAWb2KM+2TLgd1OryTU+pT
         PmjcZa1BKeFk/VwMxqKDWKe9Xzu5gdCaVp4aIAo5pHciadbfnbK4YJyXx+xvss5ustkH
         TG8hVfBKhkxqVNztb2aheV5sbsFY+HoFIDdfRFuBzCoAVyW/UsVEdeGv0vh4w8Cg0CoX
         V1LQ==
X-Gm-Message-State: AOAM531emKgfq0NGoLJxlC+k2v7mCyOzhox0yjqYwRF9ZnuBFWi7oeMP
        ZdeB9IhU8dBK9Iwi7Rh3s/k=
X-Google-Smtp-Source: ABdhPJy7ng7IOPTSu4cFwZuuTF8zgLanyHeejrkFI6R5h+8bDfJ5RFejtnBVumKIDBJz9rHR5X/Z9A==
X-Received: by 2002:a17:90a:3be4:: with SMTP id e91mr5590803pjc.113.1616627803911;
        Wed, 24 Mar 2021 16:16:43 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f20sm3573816pfa.10.2021.03.24.16.16.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 16:16:43 -0700 (PDT)
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
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <755130b4-2fab-2b53-456f-e2304b1922f2@gmail.com>
Date:   Wed, 24 Mar 2021 16:16:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210325000007.19a38bce@thinkpad>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/24/2021 4:00 PM, Marek Behún wrote:
> On Wed, 24 Mar 2021 14:19:28 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
>>> Another problem is that if lower modes are supported, we should
>>> maybe use them in order to save power.  
>>
>> That is an interesting proposal but if you want it to be truly valuable,
>> does not that mean that an user ought to be able to switch between any
>> of the supported PHY <=> MAC interfaces at runtime, and then within
>> those interfaces to the speeds that yield the best power savings?
> 
> If the code determines that there are multiple working configurations,
> it theoretically could allow the user to switch between them.
> 
> My idea was that this should be done by kernel, though.
> 
> But power saving is not the main problem I am trying to solve.
> What I am trying to solve is that if a board does not support all modes
> supported by the MAC and PHY, because they are not wired or something,
> we need to know about that so that we can select the correct mode for
> PHYs that change this mode at runtime.

OK so the runtime part comes from plugging in various SFP modules into a
cage but other than that, for a "fixed" link such as a SFF or a soldered
down PHY, do we agree that there would be no runtime changing of the
'phy-mode'?

What I am trying to understand is why this needs to be added to the
Device Tree as opposed to a bitmask within the PHY driver that indicates
the various interface mode capabilities which, looking at the code you
shared below, is how you make decisions ultimately.

> 
>>>
>>> But for this we need to know which phy-modes are supported on the
>>> board.
>>>
>>> This series adds documentation for a new ethernet PHY property,
>>> called `supported-mac-connection-types`.  
>>
>> That naming does not quite make sense to me, if we want to describe the
>> MAC supported connection types, then those would naturally be within the
>> Ethernet MAC Device Tree node, no? If we are describing what the PHY is
>> capable, then we should be dropping "mac" from the property name not to
>> create confusion.
> 
> I put "mac" there to indicate that this is the SerDes to the MAC (i.e.
> host side in Marvell PHY). 88X3310 has another SerDes side (Fiber Side).
> I guess I put "mac" there so that if in the future we wanted to specify
> supported modes for the fiber side, we could add
> `supported-fiber-connection-types`.

You would traditionally find the words "line side" (copper, optical,
etc.) and "MAC side" being used in datasheets, maybe you can use a
similar naming here?

> 
> But otherwise it does not matter where this property is. Rob Herring
> says that maybe we don't need a new property at all. We can reuse
> phy-mode property of the MAC, and enumerate all supported modes there.
> 
>>
>>>
>>> When this property is present for a PHY node, only the phy-modes
>>> listed in this property should be considered to be functional on
>>> the board.  
>>
>> Can you post the code that is going to utilize these properties so we
>> have a clearer picture of how and what you need to solve?
> 
> I am still working on this, so the repo may change, but look at
> https://git.kernel.org/pub/scm/linux/kernel/git/kabel/linux.git/log/?h=phy-supported-interfaces
> at the last three patches.
> 

-- 
Florian
