Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 096B5222804
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgGPQJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:09:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728837AbgGPQJI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:09:08 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AEFC061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:09:08 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id d18so5138861edv.6
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:09:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oeNX2xEfBpX5RwyukhM3297id2eZGK2oDR8Got5NzYk=;
        b=p2sjGgwg/FIebrj3lryoNmahF/1AXjlE778ntHEUwiSOKVDI3n0Hpbf5HtZ/HyhvAP
         dyM1/+ocwHSCrMQKf11cnLzh/WQCeyBrwZPGOBoh7F4OLk8lFzesfR4wo48kDqOZ6Gmy
         3MtLk75wkD2ELw5+hugQURp7alNxO1AQIYeGG3hyh+QNkZH5ZMBuJAUmM1rbrvDlYfGj
         jY+AMsGhLHRDReEZnQIaryOu7oxyxGI8pTRHfjNS0CC7YSWAfa6FyQk3Qzf+65AmmCH2
         qUkqJqQEa+IEXjVFOxrygWaFkVUs9OD34TQiCDOicDMokIEyD4iF5+lBqPa0FaMVQOAt
         EaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oeNX2xEfBpX5RwyukhM3297id2eZGK2oDR8Got5NzYk=;
        b=qxT8ys0fPON6rZjWPixIAy4V+GprPQIOGI09TQSOdGEKcsSfqJiDNeUxzmi/9Lm76u
         3GxvhmBr+0/TfRaLN9BJMKAkd6we6G4sW6Ev6ZiS2ELK2yKQBEYsE8fqyUE7/mniOp3D
         zS3eYbZT2aLQi8bSdZ5/V5XIt97zIJTbGBO+KdYjFTtdExKUPie53jJaPROyKZXEz2Ia
         3XkyZKtpCtqwNjV40N4jXaAo8J6/rXHAzU2HNSysuXbeCdMz+hdv6Vt6WT415KVdtPE9
         5k3axOh5xpmYGi8MDiuv9VgJgFH8+/lJRJub+y5ZeyzVuYBhgPOp/3Zi6QP6qFDY5a+4
         SP+Q==
X-Gm-Message-State: AOAM532WxouB1EWRBwKxPIWqVwrP2vGWTZ5NLE57XcS0l4eaS5KE3vUD
        O6HzHp5J44LHshYBfOUjHlf16+lBi9E=
X-Google-Smtp-Source: ABdhPJyiju/Ps9cb5Xp2Gm0OYMOLsC+k44U4Sg1EMhBqwqZR3cBWR8mwxTi/bzXoy9XXoF4cwd7ABg==
X-Received: by 2002:aa7:dd10:: with SMTP id i16mr5213207edv.227.1594915746933;
        Thu, 16 Jul 2020 09:09:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:b8e6:dbf4:ee69:fbd9? (p200300ea8f235700b8e6dbf4ee69fbd9.dip0.t-ipconnect.de. [2003:ea:8f23:5700:b8e6:dbf4:ee69:fbd9])
        by smtp.googlemail.com with ESMTPSA id be2sm5639465edb.92.2020.07.16.09.09.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 09:09:06 -0700 (PDT)
Subject: Re: wake-on-lan
To:     "Michael J. Baars" <mjbaars1977.netdev@cyberfiber.eu>,
        Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
References: <309b0348938a475f256cbc8afbbc127c285fec69.camel@cyberfiber.eu>
 <20200715133922.tu2ptsfeu25fnuwe@lion.mk-sys.cz>
 <5bc8aee0916754b166c7b1fc84fe3ec87509d00b.camel@cyberfiber.eu>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7d4c5243-8949-6617-781b-915eadd9fbf0@gmail.com>
Date:   Thu, 16 Jul 2020 18:09:02 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <5bc8aee0916754b166c7b1fc84fe3ec87509d00b.camel@cyberfiber.eu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.07.2020 09:28, Michael J. Baars wrote:
> On Wed, 2020-07-15 at 15:39 +0200, Michal Kubecek wrote:
>> On Wed, Jul 15, 2020 at 11:27:20AM +0200, Michael J. Baars wrote:
>>> Hi Michal,
>>>
>>> This is my network card:
>>>
>>> 01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
>>> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 0c)
>>> 	Subsystem: Realtek Semiconductor Co., Ltd. Device 0123
>>> 	Kernel driver in use: r8169
>>>
>>> On the Realtek website
>>> (
>>> https://www.realtek.com/en/products/communications-network-ics/item/rtl8168e
>>> )
>>> it says that both wake-on-lan and remote wake-on-lan are supported.
>>> I
>>> got the wake-on-lan from my local network working, but I have
>>> problems
>>> getting the remote wake-on-lan to work.
>>>
>>> When I set 'Wake-on' to 'g' and suspend my system, everything works
>>> fine (the router does lose the ip address assigned to the mac
>>> address
>>> of the system). I figured the SecureOn password is meant to forward
>>> magic packets to the correct machine when the router does not have
>>> an
>>> ip address assigned to a mac address, i.e. port-forwarding does not
>>> work.
>>>
>>> Ethtool 'Supports Wake-on' gives 'pumbg', and when I try to set
>>> 'Wake-on' to 's' I get:
>>>
>>> netlink error: cannot enable unsupported WoL mode (offset 36)
>>> netlink error: Invalid argument
>>>
>>> Does this mean that remote wake-on-lan is not supported (according
>>> to
>>> ethtool)?
>>
>> "MagicPacket" ('g') means that the NIC would wake on reception of
>> packet
>> containing specific pattern described e.g. here:
>>
>>   https://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet
>>
>> This is the most frequently used wake on LAN mode and, in my
>> experience,
>> what most people mean when they say "enable wake on LAN".
>>
> 
> Yes, about that. I've tried the 'system suspend' with 'ethtool -s 
> enp1s0' wol g' several times this morning. It isn't working as fine as
> I thought it was. The results are in the attachment, five columns for
> five reboots, ten rows for ten trials. As you can see, the wake-on-lan
> isn't working the first time after reboot. You can try for yourself, I
> run kernel 5.7.8.
> 
>> The "SecureOn(tm) mode" ('s') is an extension of this which seems to
>> be
>> supported only by a handful of drivers; it involves a "password" (48-
>> bit
>> value set by sopass parameter of ethtool) which is appended to the
>> MagicPacket.
>>
> 
> Funny, it looks more like a mac address to me than like a password :) 
> 
>> I'm not sure how is the remote wake-on-lan supposed to work but
>> technically you need to get _any_ packet with the "magic" pattern to
>> the
>> NIC.
> 
>>> I figured the SecureOn password is meant to forward magic packets
>>> to the correct machine when the router does not have an ip address
>>> assigned to a mac address, i.e. port-forwarding does not work.
> 
> Like this? We put it on the broadcast address?
> 
>>
>>> I also tried to set 'Wake-on' to 'b' and 'bg' but then the systems
>>> turns back on almost immediately for both settings.
>>
>> This is not surprising as enabling "b" should wake the system upon
>> reception of any broadcast which means e.g. any ARP request. Enabling
>> multiple modes wakes the system on a packet matching any of them.
>>
> 
> I think the "bg" was supposed to wake the system on a packet matching
> both of them. We want to wake up on a packet with the magic packet
> signature on the broadcast address,
> 
This needs to be supported by the hardware. And also r8168 vendor driver
doesn't support the signature mode, you can check the r8168 sources.

>> _any_ packet with the "magic" pattern
> 
>> Michal
> 
> 

