Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E27A91AD0BA
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 22:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729624AbgDPUCQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 16:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727827AbgDPUCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 16:02:15 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02E5FC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 13:02:15 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id a25so6637wrd.0
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 13:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=j6TSvwUdKm2o9O1+tyOeqBl6IvFZpB9Ny23EBGlGoZg=;
        b=M4yGZ1qYXqOaqKSnn3dhLjUzB2Gise2Hcc4WOReNBlk7fiDG5Rl/gNDjfESBpOrkzJ
         Oq3LLOFq8EkmbGYHjmqb4tmxOFcbQZcXqdB9/BHF5Kh0dFOdJUIsRNrZ3p/riB7BbPZC
         0rDnM3zgSzLhaldQPWKY8QENMexioKAUzNLG1e1afCKi3ZriN+SvI2hV2V3q+aYRtmp1
         XrcAuPLZLMykLUqG+4AUIlQm77Ksq0FbrsP772kRVW7wsouCIIwLrRREaSegUk3+yjFl
         0sIuEw1RRlSV8alFe6w4QtDi0wCObGP8waziwLKQj7WH7qtFuNS5ZBSGlKqcJeOnSqq3
         dCVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=j6TSvwUdKm2o9O1+tyOeqBl6IvFZpB9Ny23EBGlGoZg=;
        b=m8VHa1pOFW7/fHNwK+jbz2foe4I4iB4iIkDidBn7hf7m+eeth4+y5cudsQuigNlPcq
         83ajJGDAWaFNc0h1JwdMTaYT02xKhV6fuaSR0HkGe/6dWdaXt5ESUU7Hoh634HdoDI4t
         f2ggLMSp+JQTazjXQ+JTHlB5EM1QscKHT6vgpkb2ldOdcYd9maUntGLTyp+4/latgU/E
         Er31HFzVvSzHvUM0YiS8wAJuncxtySZJY5tgjbYyj9pI7nwPnzq3tqQadd5jELaC4ITD
         CO+EXWUTthnkDwUsvF5gZeULDHmFlKUw8WYrf661Wfq6e9jsm+iSYje+4pTbnCw16Pk8
         IVow==
X-Gm-Message-State: AGi0Puamx9Hss/OqLL4w6AbkfEgI0TwuH4Jvy/topSvrGIqzdM7IrnxQ
        G7IUcHBsnpWQwmEAM09m0UA=
X-Google-Smtp-Source: APiQypI1R8sk+YlfhBLZYvvjmztFvTcZdrFSLxsfaNUhjuIMvAaqGakXfBDqJxt5baXODHEcoQyfRA==
X-Received: by 2002:adf:c3ca:: with SMTP id d10mr4134193wrg.64.1587067333669;
        Thu, 16 Apr 2020 13:02:13 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b900:f290:558a:f094? (p200300EA8F296000B900F290558AF094.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b900:f290:558a:f094])
        by smtp.googlemail.com with ESMTPSA id s24sm5044918wmj.28.2020.04.16.13.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 13:02:12 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
To:     Lauri Jakku <lauri.jakku@pp.inet.fi>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
 <4860e57e-93e4-24f5-6103-fa80acbdfa0d@pp.inet.fi>
 <70cfcfb3-ce2a-9d47-b034-b94682e46e35@gmail.com>
 <d4e622f1-7bd1-d884-20b2-c16e60b42bf2@pp.inet.fi>
 <8db3cdc1-b63d-9028-e4bd-659e6d213f8f@pp.inet.fi>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <2f7aeeb2-2a19-da7c-7436-71203a29f9e8@gmail.com>
Date:   Thu, 16 Apr 2020 22:02:09 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <8db3cdc1-b63d-9028-e4bd-659e6d213f8f@pp.inet.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2020 21:58, Lauri Jakku wrote:
> Hi,
> 
> On 16.4.2020 21.37, Lauri Jakku wrote:
>> Hi,
>>
>> On 16.4.2020 21.26, Heiner Kallweit wrote:
>>> On 16.04.2020 13:30, Lauri Jakku wrote:
>>>> Hi,
>>>>
>>>>
>>>> 5.6.3-2-MANJARO: stock manjaro kernel, without modifications --> network does not work
>>>>
>>>> 5.6.3-2-MANJARO-lja: No attach check, modified kernel (r8169 mods only) --> network does not work
>>>>
>>>> 5.6.3-2-MANJARO-with-the-r8169-patch: phy patched + r8169 mods -> devices show up ok, network works
>>>>
>>>> All different initcpio's have realtek.ko in them.
>>>>
>>> Thanks for the logs. Based on the logs you're presumable affected by a known BIOS bug.
>>> Check bug tickets 202275 and 207203 at bugzilla.kernel.org.
>>> In the first referenced tickets it's about the same mainboard (with earlier BIOS version).
>>> BIOS on this mainboard seems to not initialize the network chip / PHY correctly, it reports
>>> a random number as PHY ID, resulting in no PHY driver being found.
>>> Enable "Onboard LAN Boot ROM" in the BIOS, and your problem should be gone.
>>>
>> OK, I try that, thank you :)
>>
> 
> It seems that i DO have the ROM's enabled, i'm now testing some mutex guard for phy state and try to use it as indicator
> 
> that attach has been done. One thing i've noticed is that driver needs to be reloaded to allow traffic (ie. ping works etc.)
> 
All that shouldn't be needed. Just check with which PHY ID the PHY comes up.
And what do you mean with "it seems"? Is the option enabled or not?

> 
>>>> The problem with old method seems to be, that device does not have had time to attach before the
>>>> PHY driver check.
>>>>
>>>> The patch:
>>>>
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>> index bf5bf05970a2..acd122a88d4a 100644
>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>> @@ -5172,11 +5172,11 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>          if (!tp->phydev) {
>>>>                  mdiobus_unregister(new_bus);
>>>>                  return -ENODEV;
>>>> -       } else if (!tp->phydev->drv) {
>>>> +       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>>>                  /* Most chip versions fail with the genphy driver.
>>>>                   * Therefore ensure that the dedicated PHY driver is loaded.
>>>>                   */
>>>> -               dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>> +               dev_err(&pdev->dev, "Not known MAC version.\n");
>>>>                  mdiobus_unregister(new_bus);
>>>>                  return -EUNATCH;
>>>>          }
>>>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>>>> index 66b8c61ca74c..aba2b304b821 100644
>>>> --- a/drivers/net/phy/phy-core.c
>>>> +++ b/drivers/net/phy/phy-core.c
>>>> @@ -704,6 +704,10 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
>>>>     static int __phy_read_page(struct phy_device *phydev)
>>>>   {
>>>> +       /* If not attached, do nothing (no warning) */
>>>> +       if (!phydev->attached_dev)
>>>> +               return -EOPNOTSUPP;
>>>> +
>>>>          if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
>>>>                  return -EOPNOTSUPP;
>>>>   @@ -712,12 +716,17 @@ static int __phy_read_page(struct phy_device *phydev)
>>>>     static int __phy_write_page(struct phy_device *phydev, int page)
>>>>   {
>>>> +       /* If not attached, do nothing (no warning) */
>>>> +       if (!phydev->attached_dev)
>>>> +               return -EOPNOTSUPP;
>>>> +
>>>>          if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
>>>>                  return -EOPNOTSUPP;
>>>>            return phydev->drv->write_page(phydev, page);
>>>>   }
>>>>   +
>>>>   /**
>>>>    * phy_save_page() - take the bus lock and save the current page
>>>>    * @phydev: a pointer to a &struct phy_device
>>>>
>>>>
>>>>
>>>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>>>
>>>>      On 15.04.2020 16:39, Lauri Jakku wrote:
>>>>
>>>>          Hi, There seems to he Something odd problem, maybe timing related. Stripped version not workingas expected. I get back to you, when  i have it working.
>>>>
>>>>
>>>>      There's no point in working on your patch. W/o proper justification it
>>>>      isn't acceptable anyway. And so far we still don't know which problem
>>>>      you actually have.
>>>>      FIRST please provide the requested logs and explain the actual problem
>>>>      (incl. the commit that caused the regression).
>>>>
>>>>
>>>>
>>>>
>>>>          13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote:
>>>>
>>>>          On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi, Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020 13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix The driver installation determination made properly by checking PHY vs DRIVER id's. --- drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2 files changed, 72 insertions(+), 9 deletions(-) I would say that most of the code is debug prints. I tought that they are helpful to keep, they are using the debug calls, so they are not visible if user does not like those. You are missing the point of who are your users. Users want to have working device and the code. They don't need or like to debug their kernel. Thanks
>>>>
>>>>

