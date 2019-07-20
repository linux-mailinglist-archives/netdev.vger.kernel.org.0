Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7F56F013
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 18:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726709AbfGTQpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 12:45:00 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:36385 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726300AbfGTQo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jul 2019 12:44:59 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so27508310wme.1;
        Sat, 20 Jul 2019 09:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=m5lKfQnBpu3Z2U9kZ6l+hcIv7hGWKUFy9VsYJw3l5hw=;
        b=m8dwWKxypk3y8sijFwk4UaGylB6VhiJdOZahjaG/fjitRwUb4g44cP3rjcvkZ659OZ
         XkvHoHN205P49GHpejjdnXA6t3ReWoR+mnJL+Ldxu6U24QVWUs4qpKxjBM0DiE8ax/PV
         lPgT2AqUrgU7Or0uQH6qUBPDu2lRuB9dJe7pFxuk/pSVspgfGppkQbtWf0vXl1WNUYz1
         dzUc+Xi38rboVvrZvr0ITAGntKp/gpOqJxRE8xxfWtGlQIR+0HYHsFiy6d/VqVkTgTTN
         r3xBEtprUWjfN3j63VJ3++WX+rDqJu6wsDS09ch1rVQJH0jX6BFxPFXNSJYF11a9RIc8
         VK1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=m5lKfQnBpu3Z2U9kZ6l+hcIv7hGWKUFy9VsYJw3l5hw=;
        b=iaCqXaovq4jw7QnkHA8IGVdGVyK1xFvWGQwGtBGZz9GBV7PHv3QKFpBQAiwS+EzqBN
         iv2g2r0LkgIzL6a+/O5OoNRB3xoT3FLfdYTiAZOQFXZIUHj84LdHxZ81CBGxAc24fTr/
         /n/Jb9bYyG5wPRVo/5p2TZkn2Y/tWRpZyFY8Vu/Zh5l59vuK5+a+fX+j7FLiXqXhY2Al
         OLbnoEnYJVDbLbkDZN0uNuURex87wDqvlZGmy3Oqe1aEhODJaA4uVfKP34zKpN4oeW1u
         S++MsVtgq+moba+5Y/l0b7WLdVByeQAQxF5RV/Bcm5YfQGMhvSECXCOHBOGVfT4idffc
         O1FQ==
X-Gm-Message-State: APjAAAWdY6VYToVXk0wpXWMPvoq9C2/4rOyWx4daqLHlUO50hzyESkcC
        nhbMXELXUHcu6t5d5XESiGdOWzal
X-Google-Smtp-Source: APXvYqypdsWBreJeKYDPhjd2RwNtZNQYTOofMYf3G0RF7NEPQ8GRlse7MrFgKGs0NeXIppWP4LV2QA==
X-Received: by 2002:a1c:4c1a:: with SMTP id z26mr52995996wmf.2.1563641096032;
        Sat, 20 Jul 2019 09:44:56 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:7490:a073:b68b:c51c? ([2003:ea:8bd6:c00:7490:a073:b68b:c51c])
        by smtp.googlemail.com with ESMTPSA id g19sm59605244wrb.52.2019.07.20.09.44.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 20 Jul 2019 09:44:55 -0700 (PDT)
Subject: Re: network problems with r8169
To:     Thomas Voegtle <tv@lio96.de>
Cc:     linux-kernel@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <alpine.LSU.2.21.1907182032370.7080@er-systems.de>
 <2eeedff5-4911-db6e-6bfd-99b591daa7ef@gmail.com>
 <alpine.LSU.2.21.1907192310140.11569@er-systems.de>
 <9cab7996-d801-0ae5-9e82-6d24eeb8d7c7@gmail.com>
 <alpine.LSU.2.21.1907201620070.2099@er-systems.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <add2c1e3-a216-5082-e847-452adb0169f7@gmail.com>
Date:   Sat, 20 Jul 2019 18:44:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.21.1907201620070.2099@er-systems.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.07.2019 16:22, Thomas Voegtle wrote:
> On Sat, 20 Jul 2019, Heiner Kallweit wrote:
> 
>> On 19.07.2019 23:12, Thomas Voegtle wrote:
>>> On Fri, 19 Jul 2019, Heiner Kallweit wrote:
>>>
>>>> On 18.07.2019 20:50, Thomas Voegtle wrote:
>>>>>
>>>>> Hello,
>>>>>
>>>>> I'm having network problems with the commits on r8169 since v5.2. There are ping packet loss, sometimes 100%, sometimes 50%. In the end network is unusable.
>>>>>
>>>>> v5.2 is fine, I bisected it down to:
>>>>>
>>>>> a2928d28643e3c064ff41397281d20c445525032 is the first bad commit
>>>>> commit a2928d28643e3c064ff41397281d20c445525032
>>>>> Author: Heiner Kallweit <hkallweit1@gmail.com>
>>>>> Date:   Sun Jun 2 10:53:49 2019 +0200
>>>>>
>>>>>     r8169: use paged versions of phylib MDIO access functions
>>>>>
>>>>>     Use paged versions of phylib MDIO access functions to simplify
>>>>>     the code.
>>>>>
>>>>>     Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>>>>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>>>>
>>>>>
>>>>> Reverting that commit on top of v5.2-11564-g22051d9c4a57 fixes the problem
>>>>> for me (had to adjust the renaming to r8169_main.c).
>>>>>
>>>>> I have a:
>>>>> 04:00.0 Ethernet controller [0200]: Realtek Semiconductor Co., Ltd.
>>>>> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168] (rev
>>>>> 0c)
>>>>>         Subsystem: Biostar Microtech Int'l Corp Device [1565:2400]
>>>>>         Kernel driver in use: r8169
>>>>>
>>>>> on a BIOSTAR H81MG motherboard.
>>>>>
>>>> Interesting. I have the same chip version (RTL8168g) and can't reproduce
>>>> the issue. Can you provide a full dmesg output and test the patch below
>>>> on top of linux-next? I'd be interested in the WARN_ON stack traces
>>>> (if any) and would like to know whether the experimental change to
>>>> __phy_modify_changed helps.
>>>>
>>>>>
>>>>> greetings,
>>>>>
>>>>>   Thomas
>>>>>
>>>>>
>>>> Heiner
>>>>
>>>>
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>> index 8d7dd4c5f..26be73000 100644
>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>> @@ -1934,6 +1934,8 @@ static int rtl_get_eee_supp(struct rtl8169_private *tp)
>>>>     struct phy_device *phydev = tp->phydev;
>>>>     int ret;
>>>>
>>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>>> +
>>>>     switch (tp->mac_version) {
>>>>     case RTL_GIGA_MAC_VER_34:
>>>>     case RTL_GIGA_MAC_VER_35:
>>>> @@ -1957,6 +1959,8 @@ static int rtl_get_eee_lpadv(struct rtl8169_private *tp)
>>>>     struct phy_device *phydev = tp->phydev;
>>>>     int ret;
>>>>
>>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>>> +
>>>>     switch (tp->mac_version) {
>>>>     case RTL_GIGA_MAC_VER_34:
>>>>     case RTL_GIGA_MAC_VER_35:
>>>> @@ -1980,6 +1984,8 @@ static int rtl_get_eee_adv(struct rtl8169_private *tp)
>>>>     struct phy_device *phydev = tp->phydev;
>>>>     int ret;
>>>>
>>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>>> +
>>>>     switch (tp->mac_version) {
>>>>     case RTL_GIGA_MAC_VER_34:
>>>>     case RTL_GIGA_MAC_VER_35:
>>>> @@ -2003,6 +2009,8 @@ static int rtl_set_eee_adv(struct rtl8169_private *tp, int val)
>>>>     struct phy_device *phydev = tp->phydev;
>>>>     int ret = 0;
>>>>
>>>> +    WARN_ON(phy_read(phydev, 0x1f));
>>>> +
>>>>     switch (tp->mac_version) {
>>>>     case RTL_GIGA_MAC_VER_34:
>>>>     case RTL_GIGA_MAC_VER_35:
>>>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>>>> index 16667fbac..1aa1142b8 100644
>>>> --- a/drivers/net/phy/phy-core.c
>>>> +++ b/drivers/net/phy/phy-core.c
>>>> @@ -463,12 +463,10 @@ int __phy_modify_changed(struct phy_device *phydev, u32 regnum, u16 mask,
>>>>         return ret;
>>>>
>>>>     new = (ret & ~mask) | set;
>>>> -    if (new == ret)
>>>> -        return 0;
>>>>
>>>> -    ret = __phy_write(phydev, regnum, new);
>>>> +    __phy_write(phydev, regnum, new);
>>>>
>>>> -    return ret < 0 ? ret : 1;
>>>> +    return new != ret;
>>>> }
>>>> EXPORT_SYMBOL_GPL(__phy_modify_changed);
>>>>
>>>>
>>>
>>> Took your patch on top of next-20190719.
>>> See attached dmesg.
>>> It didn't work. Same thing, lots of ping drops, no usable network.
>>>
>>> like that:
>>> 44 packets transmitted, 2 received, 95% packet loss, time 44005ms
>>>
>>>
>>> Maybe important:
>>> I build a kernel with no modules.
>>>
>>> I have to power off when I booted a kernel which doesn't work, a (soft) reboot into a older kernel (e.g. 4.9.y)  doesn't
>>> fix the problem. Powering off and on does.
>>>
>>
>> Then, what you could do is reversing the hunks of the patch step by step.
>> Or make them separate patches and bisect.
>> Relevant are the hunks from point 1 and 2.
>>
>> 1. first 5 hunks (I don't think you have to reverse them individually)
>>   EEE-related
>>
>> 2. rtl8168g_disable_aldps, rtl8168g_phy_adjust_10m_aldps, rtl8168g_1_hw_phy_config
>>   all of these hunks are in the path for RTL8168g
>>
>> 3. rtl8168h_1_hw_phy_config, rtl8168h_2_hw_phy_config, rtl8168ep_1_hw_phy_config,
>>   rtl8168ep_2_hw_phy_config
>>   not in the path for RTL8168g
>>
> 
> this is the minimal revert:
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index efef5453b94f..267995a614b5 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -3249,12 +3249,14 @@ static void rtl8168g_1_hw_phy_config(struct rtl8169_private *tp)
>         else
>                 phy_modify_paged(tp->phydev, 0x0bcc, 0x12, 0, BIT(15));
> 
> -       ret = phy_read_paged(tp->phydev, 0x0a46, 0x13);
> -       if (ret & BIT(8))
> -               phy_modify_paged(tp->phydev, 0x0c41, 0x12, 0, BIT(1));
> -       else
> -               phy_modify_paged(tp->phydev, 0x0c41, 0x12, BIT(1), 0);
> -
> +       rtl_writephy(tp, 0x1f, 0x0a46);
> +       if (rtl_readphy(tp, 0x13) & 0x0100) {
> +               rtl_writephy(tp, 0x1f, 0x0c41);
> +               rtl_w0w1_phy(tp, 0x15, 0x0002, 0x0000);
> +       } else {
> +               rtl_writephy(tp, 0x1f, 0x0c41);
> +               rtl_w0w1_phy(tp, 0x15, 0x0000, 0x0002);
> +       }
>         /* Enable PHY auto speed down */
>         phy_modify_paged(tp->phydev, 0x0a44, 0x11, 0, BIT(3) | BIT(2));
> 
> 
> 
> Could it be, that there is just a typo?
> 
I looked a hundred times over this piece of code ..
Yes, it's simply a typo. I'll submit a patch for it.
Thanks a lot for your testing efforts!

>         if (ret & BIT(8))
> -               phy_modify_paged(tp->phydev, 0x0c41, 0x12, 0, BIT(1));
> +               phy_modify_paged(tp->phydev, 0x0c41, 0x15, 0, BIT(1));
>         else
> -               phy_modify_paged(tp->phydev, 0x0c41, 0x12, BIT(1), 0);
> +               phy_modify_paged(tp->phydev, 0x0c41, 0x15, BIT(1), 0);
> 
> 
> 
> 
> greetings,
> 
>       Thomas
Heiner
