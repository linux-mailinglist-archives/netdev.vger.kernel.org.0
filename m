Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C576440659B
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 04:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhIJCRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 22:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbhIJCRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 22:17:01 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF4C4C061574;
        Thu,  9 Sep 2021 19:15:50 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so281970otq.7;
        Thu, 09 Sep 2021 19:15:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XdFt5ACb0B6NcL1KaHkMQUctIwj4PvbhHoqu8//N+IA=;
        b=LHdCsqiGZr1a7aiYUkP7DmFRSY7gqLulr5Nn4zNvh0y0RdM3QF64LUuHQQV0fezoKI
         YsCK6WfLBg9Q2NBIggwlnPau0NPP6Y4pCj2blHxTwEP058jXdih56SE3+lu2Md/kjcre
         K4rNqVMX/9YI+LoHuUho1R5cJ0myVdOUlWPTJG71JcR6X41cR25TSptNwkxjAnpiluu5
         cri4JIizJV3LqCUBtbyO/irsiAWmRIOMrjNoTtaOu4p1WLIDmNtZuWqe3Iiki/AfcjEO
         6XyeP7kKTKfhfawpJRWevUuLrXg7nB7yYn+Z/GFMr8a/taVTZ6NbBE8VX8MjM/l/iI5I
         THfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XdFt5ACb0B6NcL1KaHkMQUctIwj4PvbhHoqu8//N+IA=;
        b=yUfPWjqDo5JeZifG9QrimcyaxASS+NsMmoPyrjU2cOg3iocu+75h/iyTLmFb1cBFaB
         J12JVj116yhrkuhHpBkir4skMpdjBpWMCEiDIGZhDX/CXvx/TEcvbJNiEcXGfqGFiGRa
         U61DQPAPIFjHS2sx458xFtV1Xw5cxRTIAtAXPKtPUY0tJJu8MrQJdFT2vllQNp1IDvSA
         SSaUj3SmRUSy6aAQpqUWcxjQk4fOZn5/YTLZ5VFwHSUgia5VcxeoDgPYDe9lStkx3Lhq
         0R9hPlb49nhFtJoNdCWW6z3lZV27OVrrDn+BdLgDepDHTTxg76kmmRlsfdxl+lGexzuY
         wJxA==
X-Gm-Message-State: AOAM532EXSBKiFwhwhr/08oWJ66l/r7SqwjN7kcT4ws9NWJR9a50XPg4
        84jDfa/aKl0kKu0jVhmNhHY=
X-Google-Smtp-Source: ABdhPJz5QMktgDBi/tpsczQ7ArxVo+6UbzYO2tKpJ/Bym6d5ziGJqK7GGOJGwLYOME5N69NldHwqgw==
X-Received: by 2002:a05:6830:3482:: with SMTP id c2mr2655519otu.16.1631240150156;
        Thu, 09 Sep 2021 19:15:50 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:d03b:9989:a53d:104f? ([2600:1700:dfe0:49f0:d03b:9989:a53d:104f])
        by smtp.gmail.com with ESMTPSA id m25sm938941otp.41.2021.09.09.19.15.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Sep 2021 19:15:49 -0700 (PDT)
Message-ID: <35466c02-16da-0305-6d53-1c3bbf326418@gmail.com>
Date:   Thu, 9 Sep 2021 19:15:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH 0/3] Fix for KSZ DSA switch shutdown
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Saravana Kannan <saravanak@google.com>
Cc:     p.rosenberger@kunbus.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210909095324.12978-1-LinoSanfilippo@gmx.de>
 <20210909101451.jhfk45gitpxzblap@skbuf>
 <81c1a19f-c5dc-ab4a-76ff-59704ea95849@gmx.de>
 <20210909114248.aijujvl7xypkh7qe@skbuf>
 <20210909125606.giiqvil56jse4bjk@skbuf>
 <trinity-85ae3f9c-38f9-4442-98d3-bdc01279c7a8-1631193592256@3c-app-gmx-bs01>
 <20210909154734.ujfnzu6omcjuch2a@skbuf>
 <8498b0ce-99bb-aef9-05e1-d359f1cad6cf@gmx.de>
 <2b316d9f-1249-9008-2901-4ab3128eed81@gmail.com>
 <5b899bb3-ed37-19ae-8856-3dabce534cc6@gmx.de>
 <20210909225457.figd5e5o3yw76mcs@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210909225457.figd5e5o3yw76mcs@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/9/2021 3:54 PM, Vladimir Oltean wrote:
[snip]
> Question 6: How about a patch on the device core that is more lightweight?
> Wouldn't it be sensible for device_shutdown() to just call ->remove if
> the device's bus has no ->shutdown, and the device's driver doesn't have
> a ->shutdown either?
> 
> Answer: This would sometimes work, the vast majority of DSA switch
> drivers, and Ethernet controllers (in this case used as DSA masters) do
> not have a .shutdown method implemented. But their bus does: PCI does,
> SPI controllers do, most of the time. So it would work for limited
> scenarios, but would be ineffective in the general sense.

Having wondered about that question as well, I don't really see a 
compelling reason as to why we do not default to calling .remove() when 
.shutdown() is not implemented. In almost all of the cases the semantics 
of .remove() are superior to those required by .shutdown().

> 
> Question 7: I said that .shutdown, as opposed to .remove, doesn't really
> care so much about the integrity of data structures. So how far should
> we really go to fix this issue? Should we even bother to unbind the
> whole DSA tree, when the sole problem is that we are the DSA master's
> upper, and that is keeping a reference on it?
> 
> Answer: Well, any solution that does unnecessary data structure teardown
> only delays the reboot for nothing. Lino's patch just bluntly calls
> dsa_tree_teardown() from the switch .shutdown method, and this leaks
> memory, namely dst->ports. But does this really matter? Nope, so let's
> extrapolate. In this case, IMO, the simplest possible solution would be
> to patch bcmgenet to not unregister the net device. Then treat every
> other DSA master driver in the same way as they come, one by one.
> Do you need to unregister_netdevice() at shutdown? No. Then don't.
> Is it nice? Probably not, but I'm not seeing alternatives.

It does not really scale but we also don't have that many DSA masters to 
support, I believe I can name them all: bcmgenet, stmmac, bcmsysport, 
enetc, mv643xx_eth, cpsw, macb. If you want me to patch bcmgenet, give 
me a few days to test and make sure there is no power management 
regression, that's the primary concern I have.

> 
> Also, unless I'm missing something, Lino probably still sees the WARN_ON
> in bcmgenet's unregister_netdevice() about eth0 getting unregistered
> while having an upper interface. If not, it's by sheer luck that the DSA
> switch's ->shutdown gets called before bcmgenet's ->shutdown. But for
> this reason, it isn't a great solution either. If the device links can't
> guarantee us some sort of shutdown ordering (what we ideally want, as
> mentioned, is for the DSA switch driver to get _unbound_ (->remove)
> before the DSA master gets unbound or shut down).
> 

All of your questions are good and I don't have answers to any of them, 
however I would like you and others to reason about .shutdown() not just 
in the context of a reboot, or kexec'd kernel but also in the context of 
putting the system into ACPI S5 (via poweroff). In that case the goal is 
not only to quiesce the device, the goal is also to put it in a low 
power mode.

For bcmgenet specifically the code path that leads to a driver remove is 
well tested and is guaranteeing the network device registration, thus 
putting the PHY into suspend, shutting down DMAs, turning off clocks. 
This is a big hammer, but it gets the job done and does not introduce 
yet another code path to test, it's the same as the module removal.
-- 
Florian
