Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B26AF1AFBD7
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 18:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgDSQAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725939AbgDSQAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 12:00:34 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483C0C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 09:00:34 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a25so8988898wrd.0
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 09:00:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v6Kf1o4GuuDHCh5Wbx0fWCAPecd3XFb3dgfj4UXK7m8=;
        b=eUHqJynruuv87AS450Too/JgKL6xJZuK1iLxCxmuZxHXuNCoSlwkK2BGdJEu2d/fTN
         aWKHm0fHoh5DbRcSFVh1FFMXo9nUcz5aqxVoD6IOHvTYhOVExoPrPLFZy7HdatBsKjVx
         mM6hE0pakRjvXJd1HGIhdk3ze3zltAOUqUd97HCy1lDDH6OL5tJPSI5W3NcMjn+SGBin
         ifsrx9NAj6H1dP9NPVlwHv3v9jlWD6G/Q89es4OXg82mmMvB2f3nMNioXVAla5W5eysL
         q7+VuJN3x8L9oPEUT1lUJcKrG0YsUMjQHbXXtC9u2mxbzh+sxBY+p5uallEiS6DiD+V2
         qcwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v6Kf1o4GuuDHCh5Wbx0fWCAPecd3XFb3dgfj4UXK7m8=;
        b=P/CS/Aa89v92ub+8aNhTBGbjU6f2OzDwPF+E4hdR80lGTEFRsKR7KvsI5YRHTMU8SC
         FoLBLy312kUDB18Z3dXXxdvjQzTM+dMXofWDHxFvqPlUdxtVGpxdGongkdH5ixF0+1i9
         sCdWFwyblSS+PzbVu0yn3t5VmDXDev8xarm2ecWn/F74PG58hqblCMmtUO8B6pJ8tRI6
         QX1frBzlCYi3ONm/IthGSIGyV4/3LIQRXGQNjGhkPo+vQQZZcyI61qbAdubaBEmOS4RW
         +fHns9Iw8ek6UzpLe+qgsk8VgnxXp8NjB+wlAxljJeXcb/9IEgIcFEYjVVtmabwJHzuY
         gHJA==
X-Gm-Message-State: AGi0Pub4KIiLNcw1cYgrezHTutaloi20FpvjjFLM+ko/KgXCEf2W+lZ1
        fZXIUByvsVTGT4Iw21BPazQ=
X-Google-Smtp-Source: APiQypKiuY0N3bCnDVej+ff733TAMN8TD0QW50SSAMUjMm+d4wGeVNC5+c1FQ0/i+n4Ei/L+Bvm1rg==
X-Received: by 2002:adf:e704:: with SMTP id c4mr13688243wrm.181.1587312032691;
        Sun, 19 Apr 2020 09:00:32 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? ([2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id h5sm22642257wrp.97.2020.04.19.09.00.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 09:00:32 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
To:     Lauri Jakku <lauri.jakku@pp.inet.fi>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
 <4860e57e-93e4-24f5-6103-fa80acbdfa0d@pp.inet.fi>
 <70cfcfb3-ce2a-9d47-b034-b94682e46e35@gmail.com>
 <d4e622f1-7bd1-d884-20b2-c16e60b42bf2@pp.inet.fi>
 <8db3cdc1-b63d-9028-e4bd-659e6d213f8f@pp.inet.fi>
 <2f7aeeb2-2a19-da7c-7436-71203a29f9e8@gmail.com>
 <d9781ac2-c7b7-0399-578e-cc43c4629147@pp.inet.fi>
 <04107d6d-d07b-7589-0cef-0d39d86484f3@pp.inet.fi>
 <b9a31f5a-e140-5cd4-d7aa-21a2fa2c27a0@gmail.com>
 <de1bf1a4-8ce3-3352-3ff6-339206fa871e@pp.inet.fi>
 <a940416a-2cc9-c27b-1660-df19273b7478@pp.inet.fi>
 <ae6fe5f1-d7d5-c0ca-a206-48940ee80681@pp.inet.fi>
 <303643ef-91b1-462a-5ecd-6217ca7b325f@pp.inet.fi>
 <db508b70-e5fb-2abf-8012-c168fe7535a7@pp.inet.fi>
 <f3faeea9-13b7-d6ca-7cce-6ec0278d7437@pp.inet.fi>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2c9b8110-3be9-28d8-a5e1-729686fe6f12@gmail.com>
Date:   Sun, 19 Apr 2020 18:00:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <f3faeea9-13b7-d6ca-7cce-6ec0278d7437@pp.inet.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 18:49, Lauri Jakku wrote:
> Hi,
> 
> On 19.4.2020 18.09, Lauri Jakku wrote:
>> Hi,
>>
>> On 18.4.2020 21.46, Lauri Jakku wrote:
>>
>>> Hi,
>>>
>>> On 18.4.2020 14.06, Lauri Jakku wrote:
>>>> Hi,
>>>>
>>>> On 17.4.2020 10.30, Lauri Jakku wrote:
>>>>> Hi,
>>>>>
>>>>> On 17.4.2020 9.23, Lauri Jakku wrote:
>>>>>>
>>>>>> On 16.4.2020 23.50, Heiner Kallweit wrote:
>>>>>>> On 16.04.2020 22:38, Lauri Jakku wrote:
>>>>>>>> Hi
>>>>>>>>
>>>>>>>> On 16.4.2020 23.10, Lauri Jakku wrote:
>>>>>>>>> On 16.4.2020 23.02, Heiner Kallweit wrote:
>>>>>>>>>> On 16.04.2020 21:58, Lauri Jakku wrote:
>>>>>>>>>>> Hi,
>>>>>>>>>>>
>>>>>>>>>>> On 16.4.2020 21.37, Lauri Jakku wrote:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> On 16.4.2020 21.26, Heiner Kallweit wrote:
>>>>>>>>>>>>> On 16.04.2020 13:30, Lauri Jakku wrote:
>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 5.6.3-2-MANJARO: stock manjaro kernel, without modifications --> network does not work
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 5.6.3-2-MANJARO-lja: No attach check, modified kernel (r8169 mods only) --> network does not work
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 5.6.3-2-MANJARO-with-the-r8169-patch: phy patched + r8169 mods -> devices show up ok, network works
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> All different initcpio's have realtek.ko in them.
>>>>>>>>>>>>>>
>>>>>>>>>>>>> Thanks for the logs. Based on the logs you're presumable affected by a known BIOS bug.
>>>>>>>>>>>>> Check bug tickets 202275 and 207203 at bugzilla.kernel.org.
>>>>>>>>>>>>> In the first referenced tickets it's about the same mainboard (with earlier BIOS version).
>>>>>>>>>>>>> BIOS on this mainboard seems to not initialize the network chip / PHY correctly, it reports
>>>>>>>>>>>>> a random number as PHY ID, resulting in no PHY driver being found.
>>>>>>>>>>>>> Enable "Onboard LAN Boot ROM" in the BIOS, and your problem should be gone.
>>>>>>>>>>>>>
>>>>>>>>>>>> OK, I try that, thank you :)
>>>>>>>>>>>>
>>>>>>>>>>> It seems that i DO have the ROM's enabled, i'm now testing some mutex guard for phy state and try to use it as indicator
>>>>>>>>>>>
>>>>>>>>>>> that attach has been done. One thing i've noticed is that driver needs to be reloaded to allow traffic (ie. ping works etc.)
>>>>>>>>>>>
>>>>>>>>>> All that shouldn't be needed. Just check with which PHY ID the PHY comes up.
>>>>>>>>>> And what do you mean with "it seems"? Is the option enabled or not?
>>>>>>>>>>
>>>>>>>>> I do have ROM's enabled, and it does not help with my issue.
>>>>>>> Your BIOS is a beta version, downgrading to F7 may help. Then you have the same
>>>>>>> mainboard + BIOS as the user who opened bug ticket 202275.
>>>>>>>
>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc2077002
>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: MAC version: 23
>>>>>>
>>>>>> ....
>>>>>>
>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>>
>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: MAC version: 23
>>>>>>
>>>>>> .. after module unload & load cycle:
>>>>>>
>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: MAC version: 23
>>>>>>
>>>>>>
>>>>>> it seem to be the case that the phy_id chances onetime, then stays the same. I'll do few shutdowns and see
>>>>>>
>>>>>> is there a pattern at all .. next i'm going to try how it behaves, if i read mac/phy versions twice on MAC version 23.
>>>>>>
>>>>>>
>>>>>> The BIOS downgrade: I'd like to solve this without downgrading BIOS. If I can't, then I'll do systemd-service that
>>>>>>
>>>>>> reloads r8169 driver at boot, cause then network is just fine.
>>>>>>
>>>>>>
>>>>> What i've gathered samples now, there is three values for PHY ID:
>>>>>
>>>>> [sillyme@MinistryOfSillyWalk KernelStuff]$ sudo journalctl |grep "PHY ver"
>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc2077002
>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc2077002
>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>> huhti 17 09:24:53 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc1071002
>>>>> huhti 17 09:24:53 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc1071002
>>>>> huhti 17 09:27:59 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>> huhti 17 09:27:59 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>> huhti 17 10:08:42 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc1071002
>>>>> huhti 17 10:08:42 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc1071002
>>>>> huhti 17 10:12:07 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>> huhti 17 10:12:07 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>> huhti 17 10:20:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc1071002
>>>>> huhti 17 10:20:35 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc1071002
>>>>> huhti 17 10:23:46 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>> huhti 17 10:23:46 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>>
>>>>> I dont know are those hard coded or what, and are they device specific how much.
>>>>>
>>>>> i haven't coldbooted things up, that may be that something to check do they vary how per coldboot.
>>>>>
>>>>>>>> I check the ID, and revert all other changes, and check how it is working after adding the PHY id to list.
>>>>>>>>
>>>> What i've now learned: the patch + script + journald services -> Results working network, but it is still a workaround.
>>>>
>>> Following patch trusts the MAC version, another thing witch could help is to derive method to do 2dn pass of the probeing:
>>>
>>> if specific MAC version is found.
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index acd122a88d4a..62b37a1abc24 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -5172,13 +5172,18 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>         if (!tp->phydev) {
>>>                 mdiobus_unregister(new_bus);
>>>                 return -ENODEV;
>>> -       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>> -               /* Most chip versions fail with the genphy driver.
>>> -                * Therefore ensure that the dedicated PHY driver is loaded.
>>> -                */
>>> -               dev_err(&pdev->dev, "Not known MAC version.\n");
>>> -               mdiobus_unregister(new_bus);
>>> -               return -EUNATCH;
>>> +       } else {
>>> +               dev_info(&pdev->dev, "PHY version: 0x%x\n", tp->phydev->phy_id);
>>> +               dev_info(&pdev->dev, "MAC version: %d\n", tp->mac_version);
>>> +
>>> +               if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>> +                       /* Most chip versions fail with the genphy driver.
>>> +                        * Therefore ensure that the dedicated PHY driver is loaded.
>>> +                        */
>>> +                       dev_err(&pdev->dev, "Not known MAC/PHY version.\n", tp->phydev->phy_id);
>>> +                       mdiobus_unregister(new_bus);
>>> +                       return -EUNATCH;
>>> +               }
>>>         }
>>>
>>>         /* PHY will be woken up in rtl_open() */
>>>
>>
>> I just got bleeding edge 5.7.0-1 kernel compiled + firmware's updated.. and  now up'n'running. There is one (WARN_ONCE) stack trace coming from driver, i think i tinker with it next, with above patch the network devices shows up and they can be configured.
>>
> 
> I tought to ask first, before going to make new probe_type for errorneus hw (propetype + retry counter) to do re-probe if requested, N times. Or should the r8169_main.c return deferred probe on error on some MAC enums ? Which approach is design-wise sound ?
> 
> I just tought that the DEFERRED probe may just do the trick i'm looking ways to implement the re-probeing... hmm. I try the deferred thing and check would that help.
> 
Playing with options to work around the issue is of course a great way to
learn about the kernel. However it's questionable whether a workaround in
the driver is acceptable for dealing with the broken BIOS of exactly one
> 10 yrs old board (for which even a userspace workaround exists).

>>>>
>>>>>>>>>>>>>> The problem with old method seems to be, that device does not have had time to attach before the
>>>>>>>>>>>>>> PHY driver check.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> The patch:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>>>>>> index bf5bf05970a2..acd122a88d4a 100644
>>>>>>>>>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>>>>>> @@ -5172,11 +5172,11 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>>>>>>>>>>            if (!tp->phydev) {
>>>>>>>>>>>>>> mdiobus_unregister(new_bus);
>>>>>>>>>>>>>>                    return -ENODEV;
>>>>>>>>>>>>>> -       } else if (!tp->phydev->drv) {
>>>>>>>>>>>>>> +       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>>>>>>>>>>>>>                    /* Most chip versions fail with the genphy driver.
>>>>>>>>>>>>>>                     * Therefore ensure that the dedicated PHY driver is loaded.
>>>>>>>>>>>>>>                     */
>>>>>>>>>>>>>> -               dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>>>>>>>>>>> +               dev_err(&pdev->dev, "Not known MAC version.\n");
>>>>>>>>>>>>>> mdiobus_unregister(new_bus);
>>>>>>>>>>>>>>                    return -EUNATCH;
>>>>>>>>>>>>>>            }
>>>>>>>>>>>>>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>>>>>>>>>>>>>> index 66b8c61ca74c..aba2b304b821 100644
>>>>>>>>>>>>>> --- a/drivers/net/phy/phy-core.c
>>>>>>>>>>>>>> +++ b/drivers/net/phy/phy-core.c
>>>>>>>>>>>>>> @@ -704,6 +704,10 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
>>>>>>>>>>>>>>       static int __phy_read_page(struct phy_device *phydev)
>>>>>>>>>>>>>>     {
>>>>>>>>>>>>>> +       /* If not attached, do nothing (no warning) */
>>>>>>>>>>>>>> +       if (!phydev->attached_dev)
>>>>>>>>>>>>>> +               return -EOPNOTSUPP;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>            if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
>>>>>>>>>>>>>>                    return -EOPNOTSUPP;
>>>>>>>>>>>>>>     @@ -712,12 +716,17 @@ static int __phy_read_page(struct phy_device *phydev)
>>>>>>>>>>>>>>       static int __phy_write_page(struct phy_device *phydev, int page)
>>>>>>>>>>>>>>     {
>>>>>>>>>>>>>> +       /* If not attached, do nothing (no warning) */
>>>>>>>>>>>>>> +       if (!phydev->attached_dev)
>>>>>>>>>>>>>> +               return -EOPNOTSUPP;
>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>            if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
>>>>>>>>>>>>>>                    return -EOPNOTSUPP;
>>>>>>>>>>>>>>              return phydev->drv->write_page(phydev, page);
>>>>>>>>>>>>>>     }
>>>>>>>>>>>>>>     +
>>>>>>>>>>>>>>     /**
>>>>>>>>>>>>>>      * phy_save_page() - take the bus lock and save the current page
>>>>>>>>>>>>>>      * @phydev: a pointer to a &struct phy_device
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>        On 15.04.2020 16:39, Lauri Jakku wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>            Hi, There seems to he Something odd problem, maybe timing related. Stripped version not workingas expected. I get back to you, when i have it working.
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>        There's no point in working on your patch. W/o proper justification it
>>>>>>>>>>>>>>        isn't acceptable anyway. And so far we still don't know which problem
>>>>>>>>>>>>>>        you actually have.
>>>>>>>>>>>>>>        FIRST please provide the requested logs and explain the actual problem
>>>>>>>>>>>>>>        (incl. the commit that caused the regression).
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>            13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote:
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>            On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi, Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020 13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix The driver installation determination made properly by checking PHY vs DRIVER id's. --- drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2 files changed, 72 insertions(+), 9 deletions(-) I would say that most of the code is debug prints. I tought that they are helpful to keep, they are using the debug calls, so they are not visible if user does not like those. You are missing the point of who are your users. Users want to have working device and the code. They don't need or like to debug their kernel. Thanks
>>>>>>>>>>>>>>
>>>>>>>>>>>>>>

