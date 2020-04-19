Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E97C1AFCEE
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgDSSA7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:00:59 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:54988 "EHLO johanna3.inet.fi"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725793AbgDSSA6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 19 Apr 2020 14:00:58 -0400
X-RazorGate-Vade-Verdict: clean 0
X-RazorGate-Vade-Classification: clean
X-RazorGate-Vade: gggruggvucftvghtrhhoucdtuddrgeduhedrgedugdduvddtucetufdoteggodetrfdotffvucfrrhhofhhilhgvmecuuffpveftnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefuvfhfhffkffgfgggjtgfgsehtkeertddtfeejnecuhfhrohhmpefnrghurhhiucflrghkkhhuuceolhgruhhrihdrjhgrkhhkuhesphhprdhinhgvthdrfhhiqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgrdhinhenucfkphepkeegrddvgeekrdeftddrudelheenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhephhgvlhhopegludelvddrudeikedruddrudefhegnpdhinhgvthepkeegrddvgeekrdeftddrudelhedpmhgrihhlfhhrohhmpeeolhgruhhjrghkqdefsehmsghogidrihhnvghtrdhfihequceuqfffjgepkeeukffvoffkoffgpdhrtghpthhtohepoehhkhgrlhhlfigvihhtudesghhmrghilhdrtghomheqpdhrtghpthhtohepoehlvghonheskhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeonhgvthguvghvsehvghgvrhdrkhgvrhhnvghlrdhorhhgqedprhgtphhtthhopeeonhhitggpshifshgusehrvggrlhhtvghkrdgtohhmqe
Received: from [192.168.1.135] (84.248.30.195) by johanna3.inet.fi (9.0.019.26-1) (authenticated as laujak-3)
        id 5E1C39D549C4EA96; Sun, 19 Apr 2020 21:00:44 +0300
Subject: Re: NET: r8168/r8169 identifying fix
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
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
 <2c9b8110-3be9-28d8-a5e1-729686fe6f12@gmail.com>
From:   Lauri Jakku <lauri.jakku@pp.inet.fi>
Message-ID: <4368e540-4d90-09bb-7399-8df91d0c8040@pp.inet.fi>
Date:   Mon, 20 Apr 2020 00:00:42 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <2c9b8110-3be9-28d8-a5e1-729686fe6f12@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 19.4.2020 19.00, Heiner Kallweit wrote:
> On 19.04.2020 18:49, Lauri Jakku wrote:
>> Hi,
>>
>> On 19.4.2020 18.09, Lauri Jakku wrote:
>>> Hi,
>>>
>>> On 18.4.2020 21.46, Lauri Jakku wrote:
>>>
>>>> Hi,
>>>>
>>>> On 18.4.2020 14.06, Lauri Jakku wrote:
>>>>> Hi,
>>>>>
>>>>> On 17.4.2020 10.30, Lauri Jakku wrote:
>>>>>> Hi,
>>>>>>
>>>>>> On 17.4.2020 9.23, Lauri Jakku wrote:
>>>>>>> On 16.4.2020 23.50, Heiner Kallweit wrote:
>>>>>>>> On 16.04.2020 22:38, Lauri Jakku wrote:
>>>>>>>>> Hi
>>>>>>>>>
>>>>>>>>> On 16.4.2020 23.10, Lauri Jakku wrote:
>>>>>>>>>> On 16.4.2020 23.02, Heiner Kallweit wrote:
>>>>>>>>>>> On 16.04.2020 21:58, Lauri Jakku wrote:
>>>>>>>>>>>> Hi,
>>>>>>>>>>>>
>>>>>>>>>>>> On 16.4.2020 21.37, Lauri Jakku wrote:
>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>
>>>>>>>>>>>>> On 16.4.2020 21.26, Heiner Kallweit wrote:
>>>>>>>>>>>>>> On 16.04.2020 13:30, Lauri Jakku wrote:
>>>>>>>>>>>>>>> Hi,
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 5.6.3-2-MANJARO: stock manjaro kernel, without modifications --> network does not work
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 5.6.3-2-MANJARO-lja: No attach check, modified kernel (r8169 mods only) --> network does not work
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 5.6.3-2-MANJARO-with-the-r8169-patch: phy patched + r8169 mods -> devices show up ok, network works
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> All different initcpio's have realtek.ko in them.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>> Thanks for the logs. Based on the logs you're presumable affected by a known BIOS bug.
>>>>>>>>>>>>>> Check bug tickets 202275 and 207203 at bugzilla.kernel.org.
>>>>>>>>>>>>>> In the first referenced tickets it's about the same mainboard (with earlier BIOS version).
>>>>>>>>>>>>>> BIOS on this mainboard seems to not initialize the network chip / PHY correctly, it reports
>>>>>>>>>>>>>> a random number as PHY ID, resulting in no PHY driver being found.
>>>>>>>>>>>>>> Enable "Onboard LAN Boot ROM" in the BIOS, and your problem should be gone.
>>>>>>>>>>>>>>
>>>>>>>>>>>>> OK, I try that, thank you :)
>>>>>>>>>>>>>
>>>>>>>>>>>> It seems that i DO have the ROM's enabled, i'm now testing some mutex guard for phy state and try to use it as indicator
>>>>>>>>>>>>
>>>>>>>>>>>> that attach has been done. One thing i've noticed is that driver needs to be reloaded to allow traffic (ie. ping works etc.)
>>>>>>>>>>>>
>>>>>>>>>>> All that shouldn't be needed. Just check with which PHY ID the PHY comes up.
>>>>>>>>>>> And what do you mean with "it seems"? Is the option enabled or not?
>>>>>>>>>>>
>>>>>>>>>> I do have ROM's enabled, and it does not help with my issue.
>>>>>>>> Your BIOS is a beta version, downgrading to F7 may help. Then you have the same
>>>>>>>> mainboard + BIOS as the user who opened bug ticket 202275.
>>>>>>>>
>>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc2077002
>>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: MAC version: 23
>>>>>>>
>>>>>>> ....
>>>>>>>
>>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>>>
>>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: MAC version: 23
>>>>>>>
>>>>>>> .. after module unload & load cycle:
>>>>>>>
>>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: MAC version: 23
>>>>>>>
>>>>>>>
>>>>>>> it seem to be the case that the phy_id chances onetime, then stays the same. I'll do few shutdowns and see
>>>>>>>
>>>>>>> is there a pattern at all .. next i'm going to try how it behaves, if i read mac/phy versions twice on MAC version 23.
>>>>>>>
>>>>>>>
>>>>>>> The BIOS downgrade: I'd like to solve this without downgrading BIOS. If I can't, then I'll do systemd-service that
>>>>>>>
>>>>>>> reloads r8169 driver at boot, cause then network is just fine.
>>>>>>>
>>>>>>>
>>>>>> What i've gathered samples now, there is three values for PHY ID:
>>>>>>
>>>>>> [sillyme@MinistryOfSillyWalk KernelStuff]$ sudo journalctl |grep "PHY ver"
>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc2077002
>>>>>> huhti 17 09:01:49 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc2077002
>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 09:03:29 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 09:17:35 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 09:24:53 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc1071002
>>>>>> huhti 17 09:24:53 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc1071002
>>>>>> huhti 17 09:27:59 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 09:27:59 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 10:08:42 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc1071002
>>>>>> huhti 17 10:08:42 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc1071002
>>>>>> huhti 17 10:12:07 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 10:12:07 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 10:20:35 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0xc1071002
>>>>>> huhti 17 10:20:35 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0xc1071002
>>>>>> huhti 17 10:23:46 MinistryOfSillyWalk kernel: r8169 0000:02:00.0: PHY version: 0x1cc912
>>>>>> huhti 17 10:23:46 MinistryOfSillyWalk kernel: r8169 0000:03:00.0: PHY version: 0x1cc912
>>>>>>
>>>>>> I dont know are those hard coded or what, and are they device specific how much.
>>>>>>
>>>>>> i haven't coldbooted things up, that may be that something to check do they vary how per coldboot.
>>>>>>
>>>>>>>>> I check the ID, and revert all other changes, and check how it is working after adding the PHY id to list.
>>>>>>>>>
>>>>> What i've now learned: the patch + script + journald services -> Results working network, but it is still a workaround.
>>>>>
>>>> Following patch trusts the MAC version, another thing witch could help is to derive method to do 2dn pass of the probeing:
>>>>
>>>> if specific MAC version is found.
>>>>
>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>> index acd122a88d4a..62b37a1abc24 100644
>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>> @@ -5172,13 +5172,18 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>          if (!tp->phydev) {
>>>>                  mdiobus_unregister(new_bus);
>>>>                  return -ENODEV;
>>>> -       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>>> -               /* Most chip versions fail with the genphy driver.
>>>> -                * Therefore ensure that the dedicated PHY driver is loaded.
>>>> -                */
>>>> -               dev_err(&pdev->dev, "Not known MAC version.\n");
>>>> -               mdiobus_unregister(new_bus);
>>>> -               return -EUNATCH;
>>>> +       } else {
>>>> +               dev_info(&pdev->dev, "PHY version: 0x%x\n", tp->phydev->phy_id);
>>>> +               dev_info(&pdev->dev, "MAC version: %d\n", tp->mac_version);
>>>> +
>>>> +               if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>>> +                       /* Most chip versions fail with the genphy driver.
>>>> +                        * Therefore ensure that the dedicated PHY driver is loaded.
>>>> +                        */
>>>> +                       dev_err(&pdev->dev, "Not known MAC/PHY version.\n", tp->phydev->phy_id);
>>>> +                       mdiobus_unregister(new_bus);
>>>> +                       return -EUNATCH;
>>>> +               }
>>>>          }
>>>>
>>>>          /* PHY will be woken up in rtl_open() */
>>>>
>>> I just got bleeding edge 5.7.0-1 kernel compiled + firmware's updated.. and  now up'n'running. There is one (WARN_ONCE) stack trace coming from driver, i think i tinker with it next, with above patch the network devices shows up and they can be configured.
>>>
>> I tought to ask first, before going to make new probe_type for errorneus hw (propetype + retry counter) to do re-probe if requested, N times. Or should the r8169_main.c return deferred probe on error on some MAC enums ? Which approach is design-wise sound ?
>>
>> I just tought that the DEFERRED probe may just do the trick i'm looking ways to implement the re-probeing... hmm. I try the deferred thing and check would that help.
>>
> Playing with options to work around the issue is of course a great way to
> learn about the kernel. However it's questionable whether a workaround in
> the driver is acceptable for dealing with the broken BIOS of exactly one

Hmm, I think that it is better to have devices supported, even if the HW 
is old, and cause it has had support.

There are even older harddisk & network drivers, so the argument is not 
good, thus i see no reason why not

to take patch in.


>> 10 yrs old board (for which even a userspace workaround exists).
The age of driver has never been the thing .. there are very old 
drivers, HDD and Network etc.
>>>>>>>>>>>>>>> The problem with old method seems to be, that device does not have had time to attach before the
>>>>>>>>>>>>>>> PHY driver check.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> The patch:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>>>>>>> index bf5bf05970a2..acd122a88d4a 100644
>>>>>>>>>>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>>>>>>>>>> @@ -5172,11 +5172,11 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>>>>>>>>>>>>>>             if (!tp->phydev) {
>>>>>>>>>>>>>>> mdiobus_unregister(new_bus);
>>>>>>>>>>>>>>>                     return -ENODEV;
>>>>>>>>>>>>>>> -       } else if (!tp->phydev->drv) {
>>>>>>>>>>>>>>> +       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>>>>>>>>>>>>>>>                     /* Most chip versions fail with the genphy driver.
>>>>>>>>>>>>>>>                      * Therefore ensure that the dedicated PHY driver is loaded.
>>>>>>>>>>>>>>>                      */
>>>>>>>>>>>>>>> -               dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
>>>>>>>>>>>>>>> +               dev_err(&pdev->dev, "Not known MAC version.\n");
>>>>>>>>>>>>>>> mdiobus_unregister(new_bus);
>>>>>>>>>>>>>>>                     return -EUNATCH;
>>>>>>>>>>>>>>>             }
>>>>>>>>>>>>>>> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
>>>>>>>>>>>>>>> index 66b8c61ca74c..aba2b304b821 100644
>>>>>>>>>>>>>>> --- a/drivers/net/phy/phy-core.c
>>>>>>>>>>>>>>> +++ b/drivers/net/phy/phy-core.c
>>>>>>>>>>>>>>> @@ -704,6 +704,10 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
>>>>>>>>>>>>>>>        static int __phy_read_page(struct phy_device *phydev)
>>>>>>>>>>>>>>>      {
>>>>>>>>>>>>>>> +       /* If not attached, do nothing (no warning) */
>>>>>>>>>>>>>>> +       if (!phydev->attached_dev)
>>>>>>>>>>>>>>> +               return -EOPNOTSUPP;
>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>             if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
>>>>>>>>>>>>>>>                     return -EOPNOTSUPP;
>>>>>>>>>>>>>>>      @@ -712,12 +716,17 @@ static int __phy_read_page(struct phy_device *phydev)
>>>>>>>>>>>>>>>        static int __phy_write_page(struct phy_device *phydev, int page)
>>>>>>>>>>>>>>>      {
>>>>>>>>>>>>>>> +       /* If not attached, do nothing (no warning) */
>>>>>>>>>>>>>>> +       if (!phydev->attached_dev)
>>>>>>>>>>>>>>> +               return -EOPNOTSUPP;
>>>>>>>>>>>>>>> +
>>>>>>>>>>>>>>>             if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
>>>>>>>>>>>>>>>                     return -EOPNOTSUPP;
>>>>>>>>>>>>>>>               return phydev->drv->write_page(phydev, page);
>>>>>>>>>>>>>>>      }
>>>>>>>>>>>>>>>      +
>>>>>>>>>>>>>>>      /**
>>>>>>>>>>>>>>>       * phy_save_page() - take the bus lock and save the current page
>>>>>>>>>>>>>>>       * @phydev: a pointer to a &struct phy_device
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>         On 15.04.2020 16:39, Lauri Jakku wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>             Hi, There seems to he Something odd problem, maybe timing related. Stripped version not workingas expected. I get back to you, when i have it working.
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>         There's no point in working on your patch. W/o proper justification it
>>>>>>>>>>>>>>>         isn't acceptable anyway. And so far we still don't know which problem
>>>>>>>>>>>>>>>         you actually have.
>>>>>>>>>>>>>>>         FIRST please provide the requested logs and explain the actual problem
>>>>>>>>>>>>>>>         (incl. the commit that caused the regression).
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>             13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote:
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>             On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi, Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020 13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix The driver installation determination made properly by checking PHY vs DRIVER id's. --- drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2 files changed, 72 insertions(+), 9 deletions(-) I would say that most of the code is debug prints. I tought that they are helpful to keep, they are using the debug calls, so they are not visible if user does not like those. You are missing the point of who are your users. Users want to have working device and the code. They don't need or like to debug their kernel. Thanks
>>>>>>>>>>>>>>>
>>>>>>>>>>>>>>>
