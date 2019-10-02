Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0295C934B
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 23:11:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729344AbfJBVLJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 17:11:09 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:34816 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbfJBVLJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 17:11:09 -0400
Received: by mail-wr1-f66.google.com with SMTP id v8so595654wrt.2
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 14:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FKy0RMqYEwvsmwrpnhqs0OkUrPsgI4e0NVxtfXa7efo=;
        b=K6mmnxs2t6wkgeGUB1t8UnZdatR5lDKF8HUl8/mXkhtFgbE0hIcjuGqVwOzHPopvkS
         YeaMxZva6z4u1P4CWT3o9Pj3iJY1kAErnjkNk4+VPRTwRZU7yF1Cn3WkuaKvy6WI8/a9
         IK0krb6DEbX5/mSbJCgT+MNFZZfbVB48q+axgVWnAIoaRtYmvliJoXeNjx/vrQi/59X4
         5PllEmAnleTZUITdmR9JhBuUR85iR5zYyPs8RrIQv0y9aaI0zHQVGFUalJIKzLZSLTqP
         fHOZHm63odsdq38960EI9ObW7r/t0ml/Y1pF9dUislocHBBzFxSPMf+W52nPLquC5x+H
         myKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FKy0RMqYEwvsmwrpnhqs0OkUrPsgI4e0NVxtfXa7efo=;
        b=DImLH/LuGs3UBR0TyKGnUmmn6IgKlnldBp+2ZZKIzLXejPrs4EuFAt7oSi+YHWYY2r
         vaaqGjlwoebYip6TN/2toCrFrhCYlZ595n9ILtzeUEpJT5aj132SSniDux2KNS1iK5ey
         UsGKcd+tzPxH2yP1/DLWqwqbH55N6pu6ATftJ+ViiboahVzBaREx6wOaGAi6TRmHEXXK
         seU3u6jIsDj6GVejmYIJ3QOWI0qh4Dk1ertwh+uGimYCvtOWfH7iQjMIdWJVIpYK1mZO
         meU7eJ5/Ml8w4tc/q2ylYUjDblxSIeAECDoItiz40gPJsMc4H3KnjYEVyYpvz8AEyNcH
         Irqg==
X-Gm-Message-State: APjAAAWwUHufhlY3ucj3KXmLvKLgdktUXPSRsToAiM/XMB/gaLEbiicf
        ftWaX7pgLFpFW8lGSK1JYICXYPBu
X-Google-Smtp-Source: APXvYqxhbXrs44YiOFiZGtLTh2VaWvZr3CEGXosCNSfmvQEb7Sing7TS+lHEdXoEmdMgTaVZVj5HTg==
X-Received: by 2002:a5d:5692:: with SMTP id f18mr4665899wrv.68.1570050666308;
        Wed, 02 Oct 2019 14:11:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:9cd0:52ca:b438:97d1? (p200300EA8F2664009CD052CAB43897D1.dip0.t-ipconnect.de. [2003:ea:8f26:6400:9cd0:52ca:b438:97d1])
        by smtp.googlemail.com with ESMTPSA id l18sm568403wrc.18.2019.10.02.14.11.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Oct 2019 14:11:05 -0700 (PDT)
Subject: Re: Driver support for Realtek RTL8125 2.5GB Ethernet
To:     Jian-Hong Pan <jian-hong@endlessm.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Linux Upstreaming Team <linux@endlessm.com>
References: <CAPpJ_ed7dSCfWPt8PiK3_LNw=MDPrFwo-5M1xcpKw-3x7dxsrA@mail.gmail.com>
 <e178221e-4f48-b9b9-2451-048e8f4a0f9f@gmail.com>
 <a3066098-9fba-c2f4-f2d3-b95b08ef5637@gmail.com>
 <71ccd182-beec-31f4-5a25-a81a7457ca55@gmail.com>
 <CAPpJ_efajCONc=7LaUdGftEpKpnpSMXn8YBE6=epJ57fF_WekA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9089b373-da45-c34c-4dbe-5c916edfb419@gmail.com>
Date:   Wed, 2 Oct 2019 23:03:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <CAPpJ_efajCONc=7LaUdGftEpKpnpSMXn8YBE6=epJ57fF_WekA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02.10.2019 12:22, Jian-Hong Pan wrote:
> Heiner Kallweit <hkallweit1@gmail.com> 於 2019年10月2日 週三 下午1:54寫道：
>>
>> On 26.07.2019 21:05, Heiner Kallweit wrote:
>>> On 24.07.2019 22:02, Heiner Kallweit wrote:
>>>> On 24.07.2019 10:19, Jian-Hong Pan wrote:
>>>>> Hi all,
>>>>>
>>>>> We have got a consumer desktop equipped with Realtek RTL8125 2.5GB
>>>>> Ethernet [1] recently.  But, there is no related driver in mainline
>>>>> kernel yet.  So, we can only use the vendor driver [2] and customize
>>>>> it [3] right now.
>>>>>
>>>>> Is anyone working on an upstream driver for this hardware?
>>>>>
>>>> At least I'm not aware of any such work. Issue with Realtek is that
>>>> they answer individual questions very quickly but company policy is
>>>> to not release any datasheets or errata documentation.
>>>> RTL8169 inherited a lot from RTL8139, so I would expect that the
>>>> r8169 driver could be a good basis for a RTL8125 mainline driver.
>>>>
>>> Meanwhile I had a look at the RTL8125 vendor driver. Most parts are
>>> quite similar to RTL8168. However the PHY handling is quite weird.
>>> 2.5Gbps isn't covered by Clause 22, but instead of switching to
>>> Clause 45 Realtek uses Clause 22 plus a proprietary chip register
>>> (for controlling the 2.5Gbps mode) that doesn't seem to be accessible
>>> via MDIO bus. This may make using phylib tricky.
>>>
>> In case you haven't seen it yet: Meanwhile I added RTL8125 support to
>> phylib and r8169, it's included in 5.4-rc1. I tested it on a
>> RTL8125-based PCIe add-on card, feedback from your system would be
>> appreciated. Note that you also need latest linux-firmware package
>> from Sep 23rd.
> 
> Thank you!!!
> 
> I tried kernel 5.4.0-rc1 on the desktop equipped with Realtek RTL8125
> 2.5GB Ethernet.
> 
> $ sudo lspci -nnvs 04:00.0
> [sudo] password for dev:
> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
> Device [10ec:8125] (rev 01)
>     Subsystem: Acer Incorporated [ALI] Device [1025:1354]
>     Flags: bus master, fast devsel, latency 0, IRQ 17
>     I/O ports at 3000 [size=256]
>     Memory at a4200000 (64-bit, non-prefetchable) [size=64K]
>     Memory at a4210000 (64-bit, non-prefetchable) [size=16K]
>     Capabilities: [40] Power Management version 3
>     Capabilities: [50] MSI: Enable- Count=1/1 Maskable+ 64bit+
>     Capabilities: [70] Express Endpoint, MSI 01
>     Capabilities: [b0] MSI-X: Enable+ Count=4 Masked-
>     Capabilities: [d0] Vital Product Data
>     Capabilities: [100] Advanced Error Reporting
>     Capabilities: [148] Virtual Channel
>     Capabilities: [168] Device Serial Number 01-00-00-00-68-4c-e0-00
>     Capabilities: [178] Alternative Routing-ID Interpretation (ARI)
>     Capabilities: [188] Single Root I/O Virtualization (SR-IOV)
>     Capabilities: [1c8] Transaction Processing Hints
>     Capabilities: [254] Latency Tolerance Reporting
>     Capabilities: [25c] L1 PM Substates
>     Capabilities: [26c] Vendor Specific Information: ID=0002 Rev=4 Len=100 <?>
>     Kernel driver in use: r8169
>     Kernel modules: r8169
> 
> Module r8169 works for it.
> 
Thanks for the prompt test and feedback!

> $ dmesg | grep r8169
> [   19.631623] libphy: r8169: probed
> [   19.631978] r8169 0000:04:00.0 eth0: RTL8125, 94:c6:91:5f:1f:45,
> XID 609, IRQ 127
> [   19.631983] r8169 0000:04:00.0 eth0: jumbo features [frames: 9200
> bytes, tx checksumming: ko]
> [   19.635492] r8169 0000:04:00.0 enp4s0: renamed from eth0
> [   21.778431] RTL8125 2.5Gbps internal r8169-400:00: attached PHY
> driver [RTL8125 2.5Gbps internal] (mii_bus:phy_addr=r8169-400:00,
> irq=IGNORE)
> [   21.871953] r8169 0000:04:00.0 enp4s0: Link is Down
> [   24.668516] r8169 0000:04:00.0 enp4s0: Link is Up - 1Gbps/Full -
> flow control off
> 
> Jian-Hong Pan
> 
>>>>> [1] https://www.realtek.com/en/press-room/news-releases/item/realtek-launches-world-s-first-single-chip-2-5g-ethernet-controller-for-multiple-applications-including-gaming-solution
>>>>> [2] https://www.realtek.com/en/component/zoo/category/network-interface-controllers-10-100-1000m-gigabit-ethernet-pci-express-software
>>>>> [3] https://github.com/endlessm/linux/commit/da1e43f58850d272eb72f571524ed71fd237d32b
>>>>>
>>>>> Jian-Hong Pan
>>>>>
>>>> Heiner
>>>>
>>> Heiner
>>>
>> Heiner
> 

