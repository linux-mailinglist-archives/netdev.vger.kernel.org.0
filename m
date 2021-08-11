Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8983E9263
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 15:17:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbhHKNSI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 09:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbhHKNSH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 09:18:07 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA1C1C061765
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:17:43 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id x7so4508336ljn.10
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 06:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=uWu8nZ/GyC3LxHvwFyMss9+gem8I9tUvBvkCbq3iuqk=;
        b=Vpu19gsUEUbG4OeRvLVGNBO/QmDTJq/oFkjGSCbYdXTApZgPBAhsEXm/AKevudb4GV
         I8qjrLGUb9GQ2rbGSnfnglVKE4HulOKkXaCcRdDzsgny1tnHo8m4E/4efatPB1Q7vCgu
         p2VgII1xbCKW8RW+MpauzZiGjsmRtdf3x0x5br/qIesZQ3z5E50x2kz9E6YSQ3T2vZ88
         QdffSk0s1DJAsjwPQ8boVj1ZYr60Y0SBU3TmsMYPyIfK7LW2nH1a3hqi0iBlcO7s618Z
         TE27joAwQ9T2iMvhgBCAJ6I/pq6DExn3+9VmnZMp87pbK9WGntPgT65Hy8d6t/wYKDre
         lmrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=uWu8nZ/GyC3LxHvwFyMss9+gem8I9tUvBvkCbq3iuqk=;
        b=UemXN11xL95eJ521VfpNiBVgmiEuA+lGlCvVpQ5MJNY5pkwhbRbJiQPvMuDe7qXhEN
         xPqoA0tSgthOr9Q3o4tjT7MDVBMs8MAoAxf+bq70wuapQJ6sWnxZTXhNHTkBMq1sst8Q
         V3iDRs34+4paFtmrftTrWAGXXZJ6i0eue7VY+0i1oOC5vpRU76W95NJhDGU2VHT3nX9O
         Y9d5MiEOOiv1aJ57AkalvWR/zQiw2M6vYDS8GcwhQCLna6poAN1El1+48O3Kn0ck6YdP
         4LyCKvFAxBgHe4/Lty6FiZQQfDHonpVYKIQsZhl4egupl63OT///eBA2Nj4Z0kJjSDFD
         5y0A==
X-Gm-Message-State: AOAM5320KEVz4hMTTTOFOUu4x+hiy9e7jKfiqgKemDfagu4rRVK/LPDj
        kEWJnnsBP2WOF4lW66FH4qY=
X-Google-Smtp-Source: ABdhPJxD1Ce7NZVT1mPvk/fN9sJP4YJJ0vddoicDZ9nG5h1rrPfJxC/5ZH4X9bcYuw+8AXYqh+Hs6Q==
X-Received: by 2002:a05:651c:201b:: with SMTP id s27mr3490303ljo.500.1628687862096;
        Wed, 11 Aug 2021 06:17:42 -0700 (PDT)
Received: from ?IPv6:2001:14ba:3601:3500:f5e:3c10:ee53:ed79? (dh4yxmyysn40bb7wx918t-3.rev.dnainternet.fi. [2001:14ba:3601:3500:f5e:3c10:ee53:ed79])
        by smtp.gmail.com with ESMTPSA id 28sm301032lft.154.2021.08.11.06.17.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Aug 2021 06:17:41 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
References: <4bc0fc0c-1437-fc41-1c50-38298214ec75@gmail.com>
 <20200413105838.GK334007@unreal>
 <dc2de414-0e6e-2531-0131-0f3db397680f@gmail.com>
 <20200413113430.GM334007@unreal>
 <03d9f8d9-620c-1f8b-9c58-60b824fa626c@gmail.com>
 <d3adc7f2-06bb-45bc-ab02-3d443999cefd@gmail.com>
 <f143b58d-4caa-7c9b-b98b-806ba8d2be99@gmail.com>
 <0415fc0d-1514-0d79-c1d8-52984973cca5@gmail.com>
 <3e3b4402-3b6f-7d26-10f3-8e2b18eb65c4@gmail.com>
 <eb4b6c25-539a-9a94-27a4-398031725709@gmail.com>
 <efe87588-e480-ebc9-32d7-a1489b25f45a@gmail.com>
 <60619b13-fdd4-e9f9-2b80-0807c381a247@gmail.com>
From:   "Late @ Gmail" <ljakku77@gmail.com>
Message-ID: <56ab5e00-a26e-de3e-3002-3e5b2dfb2009@gmail.com>
Date:   Wed, 11 Aug 2021 16:17:39 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <60619b13-fdd4-e9f9-2b80-0807c381a247@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Ok, I will not send patch with the hacky-stuff anymore. I do realize the hacky stuff is not acceptable, but it is a starting point

.. you gotta start from somewhere, and get some comments about the patch.


That means that I need some help, what i'm trying to grasp is what the patch does, so that the driver

works with my HW (witch needs the patch (hacky yeah) to work out of the boot ok).


The modprobe reload does something to driver/hw/??? that it is ok, when the module's probe return zero at all times.

.. that is hacky partly reason: I'm not familiar with kernel's code base yet -> It may seem hacky for many, but i'm

trying to get picture in my head what and why works like it works.


The hacky-bit works for me -> in principle the way to fix in concept is ok, now just to make it non-hacky and align

with current architechture and design of overall kernel codebase.


hmm, i'm thinking of debugging the module's reloading steps with stacktraces to figure out more and

possibly make quirk bit(s) for re-probe within initial module load & handle unloading properly in

between.


So basicly what i'm trying to reproduce in boot-time is:


    modprobe -r r8169

    modprobe r8169


Sequence.


--Lauri

On 11.8.2021 9.09, Heiner Kallweit wrote:
> On 10.08.2021 23:50, Late @ Gmail wrote:
>> Hi,
>>
>> Now I solved the reloading issue, and r8169 driver works line charm.
>>
> This patch is a complete hack and and in parts simply wrong.
> In addition it misses the basics of how to submit a patch.
> Quality hasn't improved since your first attempt, so better stop
> trying to submit this to mainline.
>
>> Patch:
>>
>> From: Lauri Jakku <lja@lja.fi>
>> Date: Mon, 9 Aug 2021 21:44:53 +0300
>> Subject: [PATCH] net:realtek:r8169 driver load fix
>>
>>    net:realtek:r8169 driver load fix
>>
>>      Problem:
>>
>>        The problem is that (1st load) fails, but there is valid
>>        HW found (the ID is known) and this patch is applied, the second
>>        time of loading module works ok, and network is connected ok
>>        etc.
>>
>>      Solution:
>>
>>        The driver will trust the HW that reports valid ID and then make
>>        re-loading of the module as it would being reloaded manually.
>>
>>        I do check that if the HW id is read ok from the HW, then pass
>>        -EAGAIN ja try to load 5 times, sleeping 250ms in between.
>>
>> Signed-off-by: Lauri Jakku <lja@lja.fi>
>> diff --git a/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c b/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
>> index c7af5bc3b..d8e602527 100644
>> --- a/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
>> +++ b/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
>> @@ -634,6 +634,8 @@ struct rtl8169_private {
>>      struct rtl_fw *rtl_fw;
>>  
>>      u32 ocp_base;
>> +
>> +    int retry_probeing;
>>  };
>>  
>>  typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
>> @@ -5097,13 +5099,16 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>>      tp->phydev = mdiobus_get_phy(new_bus, 0);
>>      if (!tp->phydev) {
>>          return -ENODEV;
>> -    } else if (!tp->phydev->drv) {
>> -        /* Most chip versions fail with the genphy driver.
>> -         * Therefore ensure that the dedicated PHY driver is loaded.
>> +    } else if (tp->phydev->phy_id != RTL_GIGA_MAC_NONE) {
> You compare two completely different things here. The phy_id has nothing
> to do with the chip version enum.
>
>> +        /* Most chip versions fail with the genphy driver, BUT do rerport valid IW
>> +         * ID. Re-starting the module seem to fix the issue of non-functional driver.
>>           */
>> -        dev_err(&pdev->dev, "no dedicated PHY driver found for PHY ID 0x%08x, maybe realtek.ko needs to be added to initramfs?\n",
>> +        dev_err(&pdev->dev,
>> +            "no dedicated driver, but HW found: PHY PHY ID 0x%08x\n",
>>              tp->phydev->phy_id);
>> -        return -EUNATCH;
>> +
>> +        dev_err(&pdev->dev, "trying re-probe few times..\n");
>> +
>>      }
>>  
>>      tp->phydev->mac_managed_pm = 1;
>> @@ -5250,6 +5255,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>      enum mac_version chipset;
>>      struct net_device *dev;
>>      u16 xid;
>> +    int savederr = 0;
>>  
>>      dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
>>      if (!dev)
>> @@ -5261,6 +5267,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>      tp->dev = dev;
>>      tp->pci_dev = pdev;
>>      tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
>> +    tp->retry_probeing = 0;
>>      tp->eee_adv = -1;
>>      tp->ocp_base = OCP_STD_PHY_BASE;
>>  
>> @@ -5410,7 +5417,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>  
>>      pci_set_drvdata(pdev, tp);
>>  
>> -    rc = r8169_mdio_register(tp);
>> +    savederr = r8169_mdio_register(tp);
>> +
>> +    if (
>> +        (tp->retry_probeing > 0) &&
>> +        (savederr == -EAGAIN)
>> +       ) {
>> +        netdev_info(dev, " retry of probe requested..............");
>> +    }
>> +
>>      if (rc)
>>          return rc;
>>  
>> @@ -5435,6 +5450,14 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>      if (pci_dev_run_wake(pdev))
>>          pm_runtime_put_sync(&pdev->dev);
>>  
>> +    if (
>> +        (tp->retry_probeing > 0) &&
>> +        (savederr == -EAGAIN)
>> +       ) {
>> +        netdev_info(dev, " retry of probe requested..............");
>> +        return savederr;
> You can not simply return here. You have to clean up.
>
>> +    }
>> +
>>      return 0;
>>  }
>>  
>> diff --git a/linux-5.14-rc4/drivers/net/phy/phy_device.c b/linux-5.14-rc4/drivers/net/phy/phy_device.c
>> index 5d5f9a9ee..59c6ac031 100644
> No mixing of changes in phylib and drivers.
>
>> --- a/linux-5.14-rc4/drivers/net/phy/phy_device.c
>> +++ b/linux-5.14-rc4/drivers/net/phy/phy_device.c
>> @@ -2980,6 +2980,9 @@ struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
>>  }
>>  EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
>>  
>> +
>> +static int phy_remove(struct device *dev);
>> +
> No forward declarations.
>
>>  /**
>>   * phy_probe - probe and init a PHY device
>>   * @dev: device to probe and init
>> @@ -2988,13 +2991,22 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
>>   *   set the state to READY (the driver's init function should
>>   *   set it to STARTING if needed).
>>   */
>> +#define REDO_PROBE_TIMES    5
>>  static int phy_probe(struct device *dev)
>>  {
>>      struct phy_device *phydev = to_phy_device(dev);
>>      struct device_driver *drv = phydev->mdio.dev.driver;
>>      struct phy_driver *phydrv = to_phy_driver(drv);
>> +    int again = 0;
>> +    int savederr = 0;
>> +again_retry:
>>      int err = 0;
>>  
>> +    if (again > 0) {
>> +        pr_err("%s: Re-probe %d of driver.....\n",
>> +               phydrv->name, again);
>> +    }
>> +
>>      phydev->drv = phydrv;
>>  
>>      /* Disable the interrupt if the PHY doesn't support it
>> @@ -3013,6 +3025,17 @@ static int phy_probe(struct device *dev)
>>  
>>      if (phydev->drv->probe) {
>>          err = phydev->drv->probe(phydev);
>> +
>> +        /* If again requested. */
>> +        if (err == -EAGAIN) {
> This doesn't make sense. You check the PHY driver probe return code,
> mixing it up with the MAC driver return code.
>
>> +            again++;
>> +            savederr = err;
>> +            err = 0;
>> +
>> +            pr_info("%s: EAGAIN: %d ...\n",
>> +                phydrv->name, again);
>> +        }
>> +
>>          if (err)
>>              goto out;
>>      }
>> @@ -3081,6 +3104,20 @@ static int phy_probe(struct device *dev)
>>  
>>      mutex_unlock(&phydev->lock);
>>  
>> +    if ((savederr == -EAGAIN) &&
>> +        ((again > 0) && (again < REDO_PROBE_TIMES))
>> +       ) {
>> +        pr_err("%s: Retry removal driver..\n",
>> +            phydrv->name);
>> +
>> +        phy_remove(dev);
>> +
>> +        pr_err("%s: Re-probe driver..\n",
>> +            phydrv->name);
>> +        savederr = 0;
>> +        goto again_retry;
>> +    }
>> +
>>      return err;
>>  }
>>  
>> @@ -3108,6 +3145,7 @@ static int phy_remove(struct device *dev)
>>      return 0;
>>  }
>>  
>> +
>>  static void phy_shutdown(struct device *dev)
>>  {
>>      struct phy_device *phydev = to_phy_device(dev);
>>
>>
>>
>> On 11.3.2021 18.43, gmail wrote:
>>> Heiner Kallweit kirjoitti 11.3.2021 klo 18.23:
>>>> On 11.03.2021 17:00, gmail wrote:
>>>>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>>>>
>>>>>     On 15.04.2020 16:39, Lauri Jakku wrote:
>>>>>
>>>>>         Hi, There seems to he Something odd problem, maybe timing
>>>>>         related. Stripped version not workingas expected. I get back to
>>>>>         you, when  i have it working.
>>>>>
>>>>>     There's no point in working on your patch. W/o proper justification it
>>>>>     isn't acceptable anyway. And so far we still don't know which problem
>>>>>     you actually have.
>>>>>     FIRST please provide the requested logs and explain the actual problem
>>>>>     (incl. the commit that caused the regression).
>>>>>
>>>>>
>>>>>              13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com
>>>>>         <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll
>>>>>         strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote: On
>>>>>         Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi,
>>>>>         Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On
>>>>>         Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From
>>>>>         2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00
>>>>>         2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020
>>>>>         13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>>>         The driver installation determination made properly by checking
>>>>>         PHY vs DRIVER id's. ---
>>>>>         drivers/net/ethernet/realtek/r8169_main.c | 70
>>>>>         ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2
>>>>>         files changed, 72 insertions(+), 9 deletions(-) I would say that
>>>>>         most of the code is debug prints. I tought that they are helpful
>>>>>         to keep, they are using the debug calls, so they are not visible
>>>>>         if user does not like those. You are missing the point of who
>>>>>         are your users. Users want to have working device and the code.
>>>>>         They don't need or like to debug their kernel. Thanks
>>>>>
>>>>>     Hi, now i got time to tackle with this again :) .. I know the proposed fix is quite hack, BUT it does give a clue what is wrong.
>>>>>
>>>>>     Something in subsystem is not working at the first time, but it needs to be reloaded to work ok (second time). So what I will do
>>>>>     is that I try out re-do the module load within the module, if there is known HW id available but driver is not available, that
>>>>>     would be much nicer and user friendly way.
>>>>>
>>>>>
>>>>>     When the module setup it self nicely on first load, then can be the hunt for late-init of subsystem be checked out. Is the HW
>>>>>     not brought up correct way during first time, or does the HW need time to brough up, or what is the cause.
>>>>>
>>>>>     The justification is the same as all HW driver bugs, the improvement is always better to take in. Or do this patch have some-
>>>>>     thing what other patches do not?
>>>>>
>>>>>     Is there legit reason why NOT to improve something, that is clearly issue for others also than just me ? I will take on the
>>>>>     task to fiddle with the module to get it more-less hacky and fully working version. Without the need for user to do something
>>>>>     for the module to work.
>>>>>
>>>>>         --Lauri J.
>>>>>
>>>>>
>>>> I have no clue what you're trying to say. The last patch wasn't acceptable at all.
>>>> If you want to submit a patch:
>>>>
>>>> - Follow kernel code style
>>>> - Explain what the exact problem is, what the root cause is, and how your patch fixes it
>>>> - Explain why you're sure that it doesn't break processing on other chip versions
>>>>    and systems.
>>>>
>>> Ok, i'll make nice patch that has in comment what is the problem and how does the patch help the case at hand.
>>>
>>> I don't know the rootcause, but something in subsystem that possibly is initializing bit slowly, cause the reloading
>>>
>>> of the module provides working network connection, when done via insmod cycle. I'm not sure is it just a timing
>>>
>>> issue or what. I'd like to check where is the driver pointer populated, and put some debugs to see if the issue is just
>>>
>>> timing, let's see.
>>>
>>>
>>> The problem is that (1st load) fails, but there is valid HW found (the ID is known), when the hacky patch of mine
>>>
>>> is applied, the second time of loading module works ok, and network is connected ok etc.
>>>
>>>
>>> I make the change so that when the current HEAD code is going to return failure, i do check that if the HW id is read ok
>>>
>>> from the HW, then pass -EAGAIN ja try to load 5 times, sleeping 250ms in between.
>>>
>>>
>>> --Lauri J.
>>>
>>>
>>>
>>>
