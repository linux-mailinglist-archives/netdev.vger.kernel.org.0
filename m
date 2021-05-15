Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6812F381A11
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 19:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbhEOREW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 13:04:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbhEOREV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 13:04:21 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77DA9C061573;
        Sat, 15 May 2021 10:03:06 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id pi6-20020a17090b1e46b029015cec51d7cdso1373161pjb.5;
        Sat, 15 May 2021 10:03:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MB1APffVjgoMzeVzbuCucMk9nO1HoRAk+17E/1Zqv+k=;
        b=o7nRQ8KOar6oGITS6dJ/MD8bcTZ+P6OZ4abGyTl19YqXRrTW3KOE9ajUsMSHkJ1F1+
         lUPhdE66SimOPivAYZs3TSUnRyJERSUNEZYiuGGRDiC2g8R3YJLae5QBhfLW7aReFt+/
         E878XSOkqGsSk4Z5oVabndwWzPXI7kSMUbtY2G3werVAVH8rjdGO3VJQLASe9keUz9T1
         aNrEMYaSQjmD/7sz2H6xoClC22/xz3HD8dxJlyFsqiRatZRFj1PcuILTjp4QqE2U0BjV
         CthS5A4bMnIMj+gCMmI7eDXFNRhJkI4QLkV9lqmStW1ppWGd+NFzApbA68JEHwdHh+of
         FW2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MB1APffVjgoMzeVzbuCucMk9nO1HoRAk+17E/1Zqv+k=;
        b=IWCusiBKy2S8duwS1mcr3HLRFDudzEpyUi5UDN/7bqDslxfCq3hPLfAc0YxswUG7Je
         kHUDFz4rzrnJH1gssT5H8bdHMc1CT1QXBracafD/600rVmCbRSoFN3K/xupJ9DD08moP
         VM41JGlZtiEdasH+zE9I4UcKOEV5H2vAMAE/pg/wDVyD2tywjb3O9+3rAEXTLGPleOBS
         9x6bZziwtkxaSQ7CAuigZAwaQJldvwLSd5TummorKqO6lMuPlbckD9E8HxvfU9+czVrI
         jmprXgegrpxm6oir+T1v8npImVd+rYTPh0trRSQEBtUXT5Bl5nHkmUvsmwLWpm+v5Z/P
         /aPQ==
X-Gm-Message-State: AOAM5316kyg8+jpalAnK9qxoFL4kLOkBT5I3msfjAJRfwpK2tA8k+Fv/
        a9gM8JsdqCLDgi9u/sm+nz/814og6C2eRw==
X-Google-Smtp-Source: ABdhPJypE3HzfNrUfI1RDGq1wyGJL2OKfWPJwbw/atcrW3+Uq1lVNuFPMWkmsPHKKYR8s+cJoSHeRw==
X-Received: by 2002:a17:90a:542:: with SMTP id h2mr6132492pjf.82.1621098185624;
        Sat, 15 May 2021 10:03:05 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n9sm6896023pgt.35.2021.05.15.10.03.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 May 2021 10:03:04 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 01/28] net: mdio: ipq8064: clean
 whitespaces in define
To:     Jonathan McDowell <noodles@earth.li>,
        Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <YJbSOYBxskVdqGm5@lunn.ch> <YJbTBuKobu1fBGoM@Ansuel-xps.localdomain>
 <20210515170046.GA18069@earth.li>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <747555da-cc9b-299f-39dd-9b3368bd467d@gmail.com>
Date:   Sat, 15 May 2021 10:03:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210515170046.GA18069@earth.li>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2021 10:00 AM, Jonathan McDowell wrote:
> On Sat, May 08, 2021 at 08:05:58PM +0200, Ansuel Smith wrote:
>> On Sat, May 08, 2021 at 08:02:33PM +0200, Andrew Lunn wrote:
>>> On Sat, May 08, 2021 at 02:28:51AM +0200, Ansuel Smith wrote:
>>>> Fix mixed whitespace and tab for define spacing.
>>>
>>> Please add a patch [0/28] which describes the big picture of what
>>> these changes are doing.
>>>
>>> Also, this series is getting big. You might want to split it into two,
>>> One containing the cleanup, and the second adding support for the new
>>> switch.
>>>
>>> 	Andrew
>>
>> There is a 0/28. With all the changes. Could be that I messed the cc?
>> I agree think it's better to split this for the mdio part, the cleanup
>> and the changes needed for the internal phy.
> 
> FWIW I didn't see the 0/28 mail either.I tried these out on my RB3011
> today. I currently use the GPIO MDIO driver because I saw issues with
> the IPQ8064 driver in the past, and sticking with the GPIO driver I see
> both QCA8337 devices and traffic flows as expected, so no obvious
> regressions from your changes.

The cover letter somehow appeared as the final patch in the submission
instead of having all patches in-reply-to it as one would expect.

Russell had some additional feedback that came in during or after the
patches being applied so it would be nice to address that.

> 
> I also tried switching to the IPQ8064 MDIO driver for my first device
> (which is on the MDIO0 bus), but it's still not happy:
> 
> qca8k 37000000.mdio-mii:10: Switch id detected 0 but expected 13

If you do repeated reads of the revision register to you eventually get
13 as intended?
-- 
Florian
