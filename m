Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA5A27F34C
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 22:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728793AbgI3UXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 16:23:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 16:23:40 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EEEC061755;
        Wed, 30 Sep 2020 13:23:39 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id d6so2009009pfn.9;
        Wed, 30 Sep 2020 13:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=18EEffurEnwfrK/Fyg657CI9jL/GVvC955LQwmGXhk0=;
        b=dUX5292IWmUEGCSzNOcWkiUuDfrTKoBPFoO59ZfRoMBGyd/8gLgl7LNnc1Y+hizn3w
         U7ITM+wAr9k+2g4+s+4LfVecpe//7iVmA7tvbke1U0fypwDkUOozRQTlzFqtZi8rTDxN
         m2zZLbValL2Kn6tMl8hjE+TTNv+pijWh5qUdkL81KEwQgJdp6UtLUh8ts/IREYQiu0dT
         FAeTl9GqDUxe+h7DyXrkk+DjdAq+2UJqX1Q8qDaO+MzustoHnlTlVHBQbBNqiGPCpOJZ
         ugXWPWklL77MtH+eYPLrvWxYYDo+jXW/TWaMPogcegnQZavvgro+CWNCnABnCZxkJlmE
         H9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=18EEffurEnwfrK/Fyg657CI9jL/GVvC955LQwmGXhk0=;
        b=di7MxBnfdOiVjcwkeC0BHeaqPCTdv4dnZMMtuY7u1ipOGS8o/0KxUoGEpOjrx5E2Br
         49Nf5cJV7Xy2IETDptn91IfPD7yPyURdsi+o1mAXScVv0SsZerQyDBSq0XAP5Q3yaau1
         G3HvICRy7WceM+SfGQ6rIbDxuUNuDgquqa6k/zN8psSJrAcPqVL0+Ir+eRGq+mIl1pqV
         FzpkEghhNuucmOfHh0+tkJTLs/jVAkisPXn2fdzpiup9RbWHoQbVbeuf+u5VmT7AfPDv
         AvoUsHBKtZTVM/NxhD4BqIUixXddmJbmRH0NbvsQhYo9pdP/F5o5wsE4+Hx8+auQLlkV
         JM/g==
X-Gm-Message-State: AOAM531326c1hg6SrZRexgYH0n+HOvxoE5VDO/GNFAr1L8t/Yq8+8jKL
        5NYly6eaqJoY5PPoS1Iv/j+2ZMum5adq7g==
X-Google-Smtp-Source: ABdhPJyfZt0dqT/rG90nl4v+OP8Wt/33nJv4MkiiPsGWP+uVLjxzZa5U6tOWjvbn7AmgPlmhSNKqRA==
X-Received: by 2002:a62:3706:0:b029:142:2501:39e5 with SMTP id e6-20020a6237060000b0290142250139e5mr4161135pfa.52.1601497418046;
        Wed, 30 Sep 2020 13:23:38 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f19sm3642836pfd.45.2020.09.30.13.23.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 13:23:37 -0700 (PDT)
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jisheng Zhang <Jisheng.Zhang@synaptics.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200930174419.345cc9b4@xhacker.debian>
 <20200930190911.GU3996795@lunn.ch>
 <bab6c68f-8ed7-26b7-65ed-a65c7210e691@gmail.com>
 <20200930201135.GX3996795@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [RFC] net: phy: add shutdown hook to struct phy_driver
Message-ID: <379683c5-3ce5-15a6-20c4-53a698f0a3d0@gmail.com>
Date:   Wed, 30 Sep 2020 13:23:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20200930201135.GX3996795@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/30/2020 1:11 PM, Andrew Lunn wrote:
> On Wed, Sep 30, 2020 at 01:07:19PM -0700, Florian Fainelli wrote:
>>
>>
>> On 9/30/2020 12:09 PM, Andrew Lunn wrote:
>>> On Wed, Sep 30, 2020 at 05:47:43PM +0800, Jisheng Zhang wrote:
>>>> Hi,
>>>>
>>>> A GE phy supports pad isolation which can save power in WOL mode. But once the
>>>> isolation is enabled, the MAC can't send/receive pkts to/from the phy because
>>>> the phy is "isolated". To make the PHY work normally, I need to move the
>>>> enabling isolation to suspend hook, so far so good. But the isolation isn't
>>>> enabled in system shutdown case, to support this, I want to add shutdown hook
>>>> to net phy_driver, then also enable the isolation in the shutdown hook. Is
>>>> there any elegant solution?
>>>
>>>> Or we can break the assumption: ethernet can still send/receive pkts after
>>>> enabling WoL, no?
>>>
>>> That is not an easy assumption to break. The MAC might be doing WOL,
>>> so it needs to be able to receive packets.
>>>
>>> What you might be able to assume is, if this PHY device has had WOL
>>> enabled, it can assume the MAC does not need to send/receive after
>>> suspend. The problem is, phy_suspend() will not call into the driver
>>> is WOL is enabled, so you have no idea when you can isolate the MAC
>>> from the PHY.
>>>
>>> So adding a shutdown in mdio_driver_register() seems reasonable.  But
>>> you need to watch out for ordering. Is the MDIO bus driver still
>>> running?
>>
>> If your Ethernet MAC controller implements a shutdown callback and that
>> callback takes care of unregistering the network device which should also
>> ensure that phy_disconnect() gets called, then your PHY's suspend function
>> will be called.
> 
> Hi Florian
> 
> I could be missing something here, but:
> 
> phy_suspend does not call into the PHY driver if WOL is enabled. So
> Jisheng needs a way to tell the PHY it should isolate itself from the
> MAC, and suspend is not that.

I missed that part, that's right if WoL is enabled at the PHY level then 
the suspend callback is not called, how about we change that and we 
always call the PHY's suspend callback? This would require that we audit 
every driver that defines both .suspend and .set_wol but there are not 
that many.

Adding an additional callback to the PHY driver does not really scale 
and it would require us to be extra careful and also plumb the MDIO bus 
shutdown.
-- 
Florian
