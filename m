Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F06616C8763
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 22:19:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbjCXVTt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 17:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231433AbjCXVTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 17:19:47 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEBC17175
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:19:43 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id ja10so3028737plb.5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 14:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679692783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=btR/6Iz6hb9WhPx+MigfFUrqWrdnSdT4ogmT1sr/+uE=;
        b=AMpTgUZhCQx8RQTeaKD9cr6F9xyn+TJ6dnpETtgS5SwexyXAgdwlhXOB6uBk85uH3B
         8uugtLR5cDIxVS7Xy7mhJlTetKxp8JULRFbQsDa6j3sWQqeQR4TJoKNo6L89QZHqK9E9
         sZJAhGU1uLx9HtNWiqlE8tFdxxy3hNI+lityARsp3wwzfWkmfVQfqhaKJU1I7qAq07bQ
         2gJY8r5B9POObTyInMIS6Q+r47Bv8CMILG4jDBinjOGoxa/2ZdrEBdCE3G0GFVFwEk1J
         dsJFI84ZQRb52qCD9nCZXqdzdH8ZEeLwTS79ZHuAq9kfZQet39PgNqs7H/pVFYQFGYv0
         wbdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679692783;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=btR/6Iz6hb9WhPx+MigfFUrqWrdnSdT4ogmT1sr/+uE=;
        b=tWDxPrWO+ivYJhahOVcSyerT6+atSBV6Ahmf3hlF/fXzqQCNkDxZbcwEnckgohQj/H
         +IGizS+CFyCJL7F/uIY9UrBC+RQKrz2SempB/25I+mPRaPrZwC1Kb1Rvev8w0Fpkja/1
         58IOb3xBRAIIJqkSxolmbehojCtyz1O9If8nSeJwKTMiPj0otjIB/M2VU60Vr4ne/cIX
         f13FJXQhvh5p16ukVvHZFc3tXRm8mxDkEiQM2vE7T7/1HY6LdCehKmrOKeChuTT4V1L/
         EzZ2hVKQ9/rph1JzghmVgyuJWsPHnZdKyc23Zgcalenbgn14UR3UXyn3zjetuJbmS9Np
         pKxg==
X-Gm-Message-State: AO0yUKVcP5ggIR4n0KOSk8isYUgjSy9cBjTLcoXh2RVj546+zXBUhFyJ
        Ex3YOqU78orNq1+xJI9+CaA=
X-Google-Smtp-Source: AK7set/c/bwBi4MdBdAfoqaeNwgbQlFOCN0ODiIj+kur+7jXNoBOgWzenGhkRXwBnSYolAjge2kp5A==
X-Received: by 2002:a05:6a20:c41f:b0:db:6237:e76 with SMTP id en31-20020a056a20c41f00b000db62370e76mr3458019pzb.15.1679692783051;
        Fri, 24 Mar 2023 14:19:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j6-20020a62e906000000b0062a56e51fd7sm2997188pfh.188.2023.03.24.14.19.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 14:19:41 -0700 (PDT)
Message-ID: <88a39d9c-1c89-3c05-c4d3-063e73c14cfc@gmail.com>
Date:   Fri, 24 Mar 2023 14:19:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 4/4] net: phy: bcm7xxx: remove getting reference
 clock
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
 <8d1e588f-72a4-ffff-f0f3-dbb071838a08@gmail.com>
 <c3bc1a7e-b80b-cf04-c925-6893d5ac53ae@gmail.com>
 <45afac86-cff6-f695-f02b-a8d711166db0@gmail.com>
 <2e377557-3177-7117-bf00-ad308aabab69@gmail.com>
 <0c9f262b-0f06-d1d5-636e-8ad6baa3380f@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <0c9f262b-0f06-d1d5-636e-8ad6baa3380f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 14:16, Heiner Kallweit wrote:
> On 24.03.2023 21:11, Florian Fainelli wrote:
>> On 3/24/23 12:50, Heiner Kallweit wrote:
>>> On 24.03.2023 20:03, Florian Fainelli wrote:
>>>> On 3/24/23 11:05, Heiner Kallweit wrote:
>>>>> Now that getting the reference clock has been moved to phylib,
>>>>> we can remove it here.
>>>>>
>>>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>
>>>> This is not the reference clock for bcm7xxx this is the SoC internal clock that feeds the Soc internal PHY.
>>>
>>> Ah, good to know. Then indeed we may have to allow drivers to disable this feature.
>>>
>>> Another aspect: When looking at ba4ee3c05365 "net: phy: bcm7xxx: request and manage GPHY clock"
>>> I stumbled across statement "PHY driver can be probed with the clocks turned off".
>>> I interpret this in a way that dynamic PHY detection doesn't work because the PHY ID
>>> registers aren't accessible before the PHY driver has been loaded and probed. Is this right?
>>
>> Yes this is correct we actually probe with the clock turned off as we try to run as low power as possible upon boot.
>>
>>> Should the MDIO bus driver enable the clock for the PHY?
>>>
>>
>> This is what I had done in our downstream MDIO bus driver initially and this was fine because we were guaranteed to use a specific MDIO bus driver since the PHY is integrated.
>>
>> Eventually when this landed upstream I went with specifying the Ethernet PHY compatible with the "ethernet-phy-idAAAA.BBBB" notation which forces the PHY library to match the compatible with the driver directly without requiring to read from MII_PHYSID1/2.
>>
>> The problems I saw with the MDIO bus approach was that:
>>
>> - you would have to enable the clock prior to scanning the bus which could be done in mii_bus::reset for a driver specific way of doing it, or directly in mdiobus_scan() and then you would have to balance the clock enable count within the PHY driver's probe function which required using __clk_is_enabled() to ensure the clock could be disabled later on when you unbind the PHY device from its driver or during remove, or suspend/resume
>>
>> - if the PHY device tree node specified multiple clocks, you would not necessarily know which one(s) to enable and which one(s) not to. Enabling all of them would be a waste of power and could also possibly create sequencing issues if we have a situation similar to the reference clock you are trying to address. Not enabling any would obviously not work at all.
>>
>> Using the "ethernet-phy-idAAAA.BBBB" ensured that the PHY driver could enable the clock(s) it needs and ensure that probe() and remove() would have balanced clock enable/disable calls.
> 
> I see, thanks for the comprehensive explanation. If we need an additional
> PHY driver flag or other measures, then I wonder whether it's worth it
> to add refclock handling to phylib for two drivers. Maybe not.

Agreed that two drivers may not be that many. Situations like stmmac or 
other drivers where there may be a need for the PHY clock to run for the 
MAC's RX path to complete initializing might be solved using existing 
PHY library routines.
-- 
Florian

