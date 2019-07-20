Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3FB16EE8D
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 11:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727253AbfGTJN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 05:13:59 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38677 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfGTJN7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 05:13:59 -0400
Received: by mail-wr1-f65.google.com with SMTP id g17so34458047wrr.5;
        Sat, 20 Jul 2019 02:13:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YApArYzRtqaFn8OCm79T6Uy4hpgsO61ANc2zyLsyS6s=;
        b=WN6t/E0mvmPLXGyRQGtqwKb/2uQ46vMdmIgiNXFVC0poxFhHvibm96Ze0AM6WRM0dq
         Fe72D+SKwgRtd7jPE9NN1TDNYyymtHGdQbj9PKEakNR+5/U4BGSA7/uUZvdwTpqkMWC2
         FQaP2SpRGqh9/Fi2BlUTQs4rvXkO2JiqT3/Kb2oEifr1El8JzSi21+SraBNvokR7j9O2
         j/VmZf2sbC38vMzrs8R5Zjkk0+9tt2IaMJsDoNc8ZcfxkEbkT9f0yhok6qEfaKgpBPP+
         P8itQTDiGxUGkTLXiJP+wsfDb4ieiZ2+DVjLSSX+B6cpC7ZkLZ+c1LaleNesubldxzNy
         F9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YApArYzRtqaFn8OCm79T6Uy4hpgsO61ANc2zyLsyS6s=;
        b=BaTynp+pxguAvKqrrZEGfoBbX+Da7C8K200yOoOO/EtoMqQa2YWNRCJEXXOggQo2WD
         KuLZoWKqJRqiYKofT7+ZG985Zhp3SKen/ufPvgO1ACTxiocNjs+Xtqpw+oVb2pW0GRCj
         g96eE7CDOiO//nE0h8pKihn46kFHm6oEdtiBcb3iSsWCBgE+3p/JFywwYugp7S4etaE6
         q/OmQP2k+Tsfn5waWzkYtvK2Xgq3To8WCIxx+OxFhMDxEy1bgDM1BLNWnZpS4fIgV9sz
         iCzGxtJ/udn/wuN/mJWZ/pPSRoqScnJTE88xT/AlPWh6wwpMw9pErhyTSp3Hd4fuibWj
         qOlw==
X-Gm-Message-State: APjAAAWtWWbZuQzV2DJjmy7dsmauLcizSyk9GbRvCCk03WIQpaK357/8
        gjBz60gJCcZQuulZtJADnRjocNXd
X-Google-Smtp-Source: APXvYqw3rNoKR7qhG14HdHTkzZhCFSYGhU8G4slXXzVdg2oXHT7W6FwX9XAHzE8M2jN3ui+bff923g==
X-Received: by 2002:a5d:69c4:: with SMTP id s4mr30923766wrw.163.1563614036120;
        Sat, 20 Jul 2019 02:13:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:2813:fc36:e36e:dd3b? ([2003:ea:8bd6:c00:2813:fc36:e36e:dd3b])
        by smtp.googlemail.com with ESMTPSA id r14sm30350841wrx.57.2019.07.20.02.13.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jul 2019 02:13:55 -0700 (PDT)
Subject: Re: network problems with r8169
To:     Thomas Voegtle <tv@lio96.de>
Cc:     linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <alpine.LSU.2.21.1907182032370.7080@er-systems.de>
 <2eeedff5-4911-db6e-6bfd-99b591daa7ef@gmail.com>
 <alpine.LSU.2.21.1907192310140.11569@er-systems.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <d64eee0e-e2d1-eb6a-787d-b0e592c983ca@gmail.com>
Date:   Sat, 20 Jul 2019 11:13:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1907192310140.11569@er-systems.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.07.2019 23:12, Thomas Voegtle wrote:
> On Fri, 19 Jul 2019, Heiner Kallweit wrote:
> 
>> On 18.07.2019 20:50, Thomas Voegtle wrote:
>>>
>>> Hello,
>>>
>>> I'm having network problems with the commits on r8169 since v5.2. There are ping packet loss, sometimes 100%, sometimes 50%. In the end network is unusable.
>>>
>>> v5.2 is fine, I bisected it down to:
>>>
>>> a2928d28643e3c064ff41397281d20c445525032 is the first bad commit
>>> commit a2928d28643e3c064ff41397281d20c445525032
>>> Author: Heiner Kallweit <hkallweit1@gmail.com>
>>> Date:   Sun Jun 2 10:53:49 2019 +0200
>>>
>>>     r8169: use paged versions of phylib MDIO access functions
>>>
>>>     Use paged versions of phylib MDIO access functions to simplify
>>>     the code.
>>>
>>>     Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>>
>>>
>>> Reverting that commit on top of v5.2-11564-g22051d9c4a57 fixes the problem
>>> for me (had to adjust the renaming to r8169_main.c).
>>>
>>> I have a:
>>> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>>> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev
>>> 0c)
>>>         Subsystem: Biostar Microtech Int'l Corp Device [1565:2400]
>>>         Kernel driver in use: r8169
>>>
>>> on a BIOSTAR H81MG motherboard.
>>>
>> Interesting. I have the same chip version (RTL8168g) and can't reproduce
>> the issue. Can you provide a full dmesg output and test the patch below
>> on top of linux-next? I'd be interested in the WARN_ON stack traces
>> (if any) and would like to know whether the experimental change to
>> __phy_modify_changed helps.
>>
>>>
>>> greetings,
>>>
>>>   Thomas
>>>
>>>
>> Heiner
>>
>>
>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>> index 8d7dd4c5f..26be73000 100644
>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -1934,6 +1934,8 @@ static int rtl_get_eee_supp(struct rtl8169_private *tp)
>>     struct phy_device *phydev = tp->phydev;
>>     int ret;
>>
>> +    WARN_ON(phy_read(phydev, 0x1f));
>> +
>>     switch (tp->mac_version) {
>>     case RTL_GIGA_MAC_VER_34:
>>     case RTL_GIGA_MAC_VER_35:
>> @@ -1957,6 +1959,8 @@ static int rtl_get_eee_lpadv(struct rtl8169_private *tp)
>>     struct phy_device *phydev = tp->phydev;
>>     int ret;
>>
>> +    WARN_ON(phy_read(phydev, 0x1f));
>> +
>>     switch (tp->mac_version) {
>>     case RTL_GIGA_MAC_VER_34:
>>     case RTL_GIGA_MAC_VER_35:
>> @@ -1980,6 +1984,8 @@ static int rtl_get_eee_adv(struct rtl8169_private *tp)
>>     struct phy_device *phydev = tp->phydev;
>>     int ret;
>>
>> +    WARN_ON(phy_read(phydev, 0x1f));
>> +
>>     switch (tp->mac_version) {
>>     case RTL_GIGA_MAC_VER_34:
>>     case RTL_GIGA_MAC_VER_35:
>> @@ -2003,6 +2009,8 @@ static int rtl_set_eee_adv(struct rtl8169_private *tp, int val)
>>     struct phy_device *phydev = tp->phydev;
>>     int ret = 0;
>>
>> +    WARN_ON(phy_read(phydev, 0x1f));
>> +
>>     switch (tp->mac_version) {
>>     case RTL_GIGA_MAC_VER_34:
>>     case RTL_GIGA_MAC_VER_35:
>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>> index 16667fbac..1aa1142b8 100644
>> --- a/drivers/net/phy/phy-core.c
>> +++ b/drivers/net/phy/phy-core.c
>> @@ -463,12 +463,10 @@ int __phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
>>         return ret;
>>
>>     new = (ret & ~mask) | set;
>> -    if (new == ret)
>> -        return 0;
>>
>> -    ret = __phy_write(phydev, regnum, new);
>> +    __phy_write(phydev, regnum, new);
>>
>> -    return ret < 0 ? ret : 1;
>> +    return new != ret;
>> }
>> EXPORT_SYMBOL_GPL(__phy_modify_changed);
>>
>>
> 
> Took your patch on top of next-20190719.
> See attached dmesg.
> It didn't work. Same thing, lots of ping drops, no usable network.
> 
> like that:
> 44 packets transmitted, 2 received, 95% packet loss, time 44005ms
> 
I remember that I once had problems with this chip version and 100Mbps.
Could you check whether you face the same issues with 1Gbps?

> 
> Maybe important:
> I build a kernel with no modules.
> 
> I have to power off when I booted a kernel which doesn't work, a (soft) reboot into a older kernel (e.g. 4.9.y)  doesn't
> fix the problem. Powering off and on does.
> 
> 
> greetings,
> 
>       Thomas

