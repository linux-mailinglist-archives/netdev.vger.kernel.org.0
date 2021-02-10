Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7496315FC1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 07:58:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhBJG6j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 01:58:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232169AbhBJG6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 01:58:36 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA3F8C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 22:57:55 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id 190so885092wmz.0
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 22:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hvWJNQ0WW+ohrMDi0UBn0D4SD2EbL8HNBT8NgTjqEXI=;
        b=YOzCYOrm6pbVHdEJfLMWwnPRVFDYRJt2u91cNT2NRTKLuU9q+SOV5hSjaIf6PvrW/J
         NUz/AGdBB4c6iQPFSxmZZ3gi8OnJc4MhqJuisct3rAfMay4VsQoGrOdT4jgXdg7J6l4H
         9ursBy/1QDmOFrmUUDrarbnXb39BkKSHKWLicemY8p9cb7cwkXG6arrwBIRjBDgKCkQZ
         lf/WdBrDv1ta1PGXAqp5xL+0PxKsT4bec3fBYocxjbodeOqhzSr1unvxiFwNo6Xthc6q
         68LWnYmdce3tmQhmhaCVSyCVJlx9lL0vYJoVY/K8GJrlZQuepwJoMCvX5jV4wnrfk9kj
         p5KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hvWJNQ0WW+ohrMDi0UBn0D4SD2EbL8HNBT8NgTjqEXI=;
        b=lGFNOiY5zlk3Cobv4X11x5jW1F6XyD1sJiHWis8Dc0O5oTDkLjWmYr7E/n+10IPAxC
         MOKVLU/9/Phyf8XqvTPjphSy1IzlFatkRQeeNmTs4gbAjWGuG1CL6dgikKS7ruKpvoHW
         N3EkqlPglrcjEWv8F6k8k5HN28ghCVRgYfw0lxOQnwjLVkn+YSQ7mKFFvXP7fZDlqWds
         UC7D185tD6RDY4ziUILzdZ7h7Fv7q7NmknBxvWoW5T2XKbOLDEEYuT9mBPtZGDYLZTzs
         nCxumkNV709ZLqM6KLpxcCKEMtgPIvaZPSKy1YQMWXr+T8D5YtpjlxnCKH05QGZgmWgL
         i8jw==
X-Gm-Message-State: AOAM533DC61R1kfnoS9s52c9OC8tircHkv9QZS3PmMYPzhuO7f0RaOTZ
        OmqBoAh5eQB1nuc1OnRFUMnEyMvTTaZNFw==
X-Google-Smtp-Source: ABdhPJw7LaCiET7+cpmucXhAblsagD/4iSaCrk5+WOCF9PwSS1bze1M1U+9TpWo9R+CJ2kcACPIhhw==
X-Received: by 2002:a1c:7d53:: with SMTP id y80mr1506185wmc.187.1612940274537;
        Tue, 09 Feb 2021 22:57:54 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:b0ff:e539:9460:c978? (p200300ea8f1fad00b0ffe5399460c978.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:b0ff:e539:9460:c978])
        by smtp.googlemail.com with ESMTPSA id t126sm1330755wmf.3.2021.02.09.22.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 22:57:54 -0800 (PST)
Subject: Re: Request for feature: force carrier up/on flag
To:     Anton Hvornum <anton@hvornum.se>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <CAG2iS6oP+8JG=wCueFuE3HwPsnpnkqxhUx8Br84AnL+AoLi1KQ@mail.gmail.com>
 <20210209163242.7ce62140@hermes.local>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <4fb584a3-5d4d-b6da-0e6a-766273e2a3e7@gmail.com>
Date:   Wed, 10 Feb 2021 07:57:46 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210209163242.7ce62140@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.02.2021 01:32, Stephen Hemminger wrote:
> On Tue, 9 Feb 2021 18:35:54 +0100
> Anton Hvornum <anton@hvornum.se> wrote:
> 
>> Hi.
>>
>> I am a bit new to ethtool, kernel drivers and all the surrounding aspects.
>> I also recognize that my use case is of low priority and a bit niche,
>> but any response would be greatly appreciated.
>>
>> I'm modifying an existing Intel driver, and I'm looking for a way to
>> integrate/add another ethtool hook to force call `netif_carrier_on`.
>> There's plenty of hooks/listeners (not clear as to what you call
>> these) between the Intel driver and ethtool via C API's today that
>> allows for ethtool to control the driver. Many of which are for speed,
>> autonegotiation etc. But I don't see any flags/functions to force a
>> carrier state to up.
>>
>> This would be very useful for many reasons, primarily on fiber optic
>> setups where you are developing hardware such as switches, routers and
>> even developing network cards. Or if you've got a passive device such
>> as IDS or something similar that passively monitors network traffic
>> and can't/shouldn't send out link requests.
>> There are commercial products with modified drivers that support this,
>> but since the Intel hardware in this case seems to support it - just
>> that there's no way controlling it with the tools that exist today. I
>> would therefore request a feature for consideration to ethtool that
>> can force carrier states up/down.
>>
>> A intuitive option I think would be:
>> ethtool --change carrier on
>>
>> Assuming that drivers follow suit and allow this. But a first step
>> would be for the tools to support it in the API so drivers have
>> something to call/listen for. In the meantime, I can probably
>> integrate a private flag and go that route, but that feels hacky and
>> won't foster driver developers to follow suit. My goal is to empower
>> more open source alternatives to otherwise expensive commercials
>> solutions.
>>
>> Best wishes,
>> Anton Hvornum
> 
> Normally, carrier just reflects the state of what the hardware is
> reporting. Why not set admin down which tells the NIC to take
> the device offline, and that drops the fiber link.
> 
> Or maybe what you want is already there.
> Try writing to /sys/class/net/ethX/carrier which forces a carrier change?
> 

This attribute uses callback ndo_change_carrier in struct net_device_ops.
The kerneldoc provides further details.
