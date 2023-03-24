Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38906C8690
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 21:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbjCXULT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 16:11:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbjCXULS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 16:11:18 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5F9E18A83
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 13:11:16 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id m16so2330369qvi.12
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 13:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679688676;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HYbTa9CmgRxAh24eNDgt7wT5bnhYMevN9tUc+h47EMg=;
        b=HyWRwKjnG9VFzWz3v7/xkIeaJ0LZMX1PPeoYqy3PicjlN84sxpnbyrcuWuP11QaCec
         RVMFzCp3Xq04KVM6nes3o+/gEnHjyknTDEx1+UDal5ZZruXtihCC4mBp88D/XhDkibbz
         Uyug4E0YIHb17QpXbfFNewCmdl02mQRuSYO0C/ieae+e7Z+YK/BUActBg+Vi7EqcAfob
         lB+tfvOsp1W6dvCC0VH0LnmC3ZHVq8nE4PsPVvBhxlvoargie33OjUK16NbPEFIXPn5D
         aPPp6fKeMLNMNZrFKESv4meb54tOsnz+rzo/gYRPggKY/afrQfOTUxqOEE+9Rz99HW/d
         64Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679688676;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HYbTa9CmgRxAh24eNDgt7wT5bnhYMevN9tUc+h47EMg=;
        b=ltoQxrbG+udSbXpOqLDFUV+JXMF+IwnmdpVgSL2rhz1Xjyj3Z8k+Qk0vO16Zn6bHdn
         rmzzNRaj4X8TYQLF5c5oWCn5ov5Ne8n1y/Q33PQfMentQlsZQm3C8A8ihe9kaFCB4NBC
         oeFS3LtrON+wpI9833OFlJaXBkyt7oO4mDCG9BPfWxr52xCzVwwyO17fNFj563IPL9U2
         grGsV9k6tqfaXsRZnz/YrevZu1uTFuzKJzvWF3vILGaRDePRq25qu7jDXyXWfg2itn8X
         OX527aW3QAaDuePKoqdRPJIS8fskC2IM3kVs9mJ3sajUcnrkgrZqlRfYMoQIdHUq6l4v
         4zFA==
X-Gm-Message-State: AAQBX9cc9X/v/WBlIP1bI+D2gNb0hnf+xmhB5YD2PzwfM+g1886SC3BM
        Dzs/IzQykN6mi3C3lRANfwI=
X-Google-Smtp-Source: AKy350ZYkHXf/NWV8CjfuQWZthKUWf/pxwG55XjPO0HcSLBnOKhw2a2iExgo9nNHaYgST23y1s0AiA==
X-Received: by 2002:ad4:5745:0:b0:56e:a2cb:5732 with SMTP id q5-20020ad45745000000b0056ea2cb5732mr7271159qvx.9.1679688675946;
        Fri, 24 Mar 2023 13:11:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id qh5-20020a0562144c0500b005dd8b93459bsm936008qvb.51.2023.03.24.13.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 13:11:15 -0700 (PDT)
Message-ID: <2e377557-3177-7117-bf00-ad308aabab69@gmail.com>
Date:   Fri, 24 Mar 2023 13:11:07 -0700
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
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <45afac86-cff6-f695-f02b-a8d711166db0@gmail.com>
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

On 3/24/23 12:50, Heiner Kallweit wrote:
> On 24.03.2023 20:03, Florian Fainelli wrote:
>> On 3/24/23 11:05, Heiner Kallweit wrote:
>>> Now that getting the reference clock has been moved to phylib,
>>> we can remove it here.
>>>
>>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>
>> This is not the reference clock for bcm7xxx this is the SoC internal clock that feeds the Soc internal PHY.
> 
> Ah, good to know. Then indeed we may have to allow drivers to disable this feature.
> 
> Another aspect: When looking at ba4ee3c05365 "net: phy: bcm7xxx: request and manage GPHY clock"
> I stumbled across statement "PHY driver can be probed with the clocks turned off".
> I interpret this in a way that dynamic PHY detection doesn't work because the PHY ID
> registers aren't accessible before the PHY driver has been loaded and probed. Is this right?

Yes this is correct we actually probe with the clock turned off as we 
try to run as low power as possible upon boot.

> Should the MDIO bus driver enable the clock for the PHY?
> 

This is what I had done in our downstream MDIO bus driver initially and 
this was fine because we were guaranteed to use a specific MDIO bus 
driver since the PHY is integrated.

Eventually when this landed upstream I went with specifying the Ethernet 
PHY compatible with the "ethernet-phy-idAAAA.BBBB" notation which forces 
the PHY library to match the compatible with the driver directly without 
requiring to read from MII_PHYSID1/2.

The problems I saw with the MDIO bus approach was that:

- you would have to enable the clock prior to scanning the bus which 
could be done in mii_bus::reset for a driver specific way of doing it, 
or directly in mdiobus_scan() and then you would have to balance the 
clock enable count within the PHY driver's probe function which required 
using __clk_is_enabled() to ensure the clock could be disabled later on 
when you unbind the PHY device from its driver or during remove, or 
suspend/resume

- if the PHY device tree node specified multiple clocks, you would not 
necessarily know which one(s) to enable and which one(s) not to. 
Enabling all of them would be a waste of power and could also possibly 
create sequencing issues if we have a situation similar to the reference 
clock you are trying to address. Not enabling any would obviously not 
work at all.

Using the "ethernet-phy-idAAAA.BBBB" ensured that the PHY driver could 
enable the clock(s) it needs and ensure that probe() and remove() would 
have balanced clock enable/disable calls.
-- 
Florian

