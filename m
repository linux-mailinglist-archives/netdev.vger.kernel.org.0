Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E57B3E85AB
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbhHJVus (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 17:50:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234156AbhHJVur (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 17:50:47 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37675C061765
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 14:50:24 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id z2so969710lft.1
        for <netdev@vger.kernel.org>; Tue, 10 Aug 2021 14:50:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:reply-to:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=OSBLiWB0eZECp5yLhnastkW6Wh/FbMLJR7Mw+URSblU=;
        b=jH2E1oy0XxD+qG/bZWitKgp1JNC1Og6lZbYR1HmeJyvxGuoJzlF8akqddKpoJoY8Rq
         wAsfVpFdrlEbtvg92lQSVnkoyt1XRQwYJMZF3O/v6mDuWzBxxT6S0Kwl40yx36cpKrDj
         mOjVYhkR48r7T0wWodtnlvulvcPnSvV/SYvUVUROuj5YVInzaInNnFnb8QO7jfGWKss1
         Gxm42b8r+207oLe7KL0bSW8nhh4BAQ2kUwq8BqUwEJUEnTRZvIbATtdZqLy5zwZvjSFo
         U7hEt7oUDA91/pYcxTEgUv3IDrMVwruFF9Lvh++L1dtM/fr7HFS08FrSbqTJSyUZSqeB
         sj2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:reply-to:references
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-transfer-encoding:content-language;
        bh=OSBLiWB0eZECp5yLhnastkW6Wh/FbMLJR7Mw+URSblU=;
        b=AMoQ5RTaN6TlSXslVGaUOrR1d+ldiuDUvSnaiABIemgFN2LQl4399Ryks+L5glEKP1
         10/ED7HG5f4aq/LiAes6UXk5dn4LwtHxNNH2bGKec35zOieaWc11iP22hXqUuOM7HT4F
         wU+ThHix4R8MSA5PjofMv0q9eyKVrq3PuXvBKw2l5IKyMhLy6Py3heydUSM4/CjbdcKZ
         q2pYuGld94BjsjrJ9Bkze0o+pw4ix6dJuobEtEs8XcccJyBUVqHhGl/I1bRYbAh0bxt/
         YdjFHrU+k7cDQUKAUcGL4+GvFOz+PX+JvJQJ1BIt0e1uNGJNn9FCUIqIKjCPNwohA2FY
         pFZg==
X-Gm-Message-State: AOAM532F8dz63Pus3S8KKbnPOHj41bziG9g6ikPagb4rdcDFDJtORyDo
        PuoqWQAcBKMqTRuLsrX3ewzevwWCAOo89A==
X-Google-Smtp-Source: ABdhPJwvLBDhkn2nIDQGxV8fek/6PDtqMemuxXKc6vG2N4zxwIOQQbCZ7FJu5yzrugNAkd9POEQe5g==
X-Received: by 2002:a05:6512:3b98:: with SMTP id g24mr8709815lfv.202.1628632222431;
        Tue, 10 Aug 2021 14:50:22 -0700 (PDT)
Received: from ?IPv6:2001:14ba:3601:3500:c224:dedb:bf01:b0e0? (dh4yxmyhcfxsq3s4b2dty-3.rev.dnainternet.fi. [2001:14ba:3601:3500:c224:dedb:bf01:b0e0])
        by smtp.gmail.com with ESMTPSA id h17sm513132lfr.287.2021.08.10.14.50.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Aug 2021 14:50:22 -0700 (PDT)
Subject: Re: NET: r8168/r8169 identifying fix
From:   "Late @ Gmail" <ljakku77@gmail.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        nic_swsd@realtek.com
Reply-To: ljakku77@gmail.com
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
Message-ID: <efe87588-e480-ebc9-32d7-a1489b25f45a@gmail.com>
Date:   Wed, 11 Aug 2021 00:50:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <eb4b6c25-539a-9a94-27a4-398031725709@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Now I solved the reloading issue, and r8169 driver works line charm.

Patch:

From: Lauri Jakku <lja@lja.fi>
Date: Mon, 9 Aug 2021 21:44:53 +0300
Subject: [PATCH] net:realtek:r8169 driver load fix

   net:realtek:r8169 driver load fix

     Problem:

       The problem is that (1st load) fails, but there is valid
       HW found (the ID is known) and this patch is applied, the second
       time of loading module works ok, and network is connected ok
       etc.

     Solution:

       The driver will trust the HW that reports valid ID and then make
       re-loading of the module as it would being reloaded manually.

       I do check that if the HW id is read ok from the HW, then pass
       -EAGAIN ja try to load 5 times, sleeping 250ms in between.

Signed-off-by: Lauri Jakku <lja@lja.fi>
diff --git a/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c b/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
index c7af5bc3b..d8e602527 100644
--- a/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
+++ b/linux-5.14-rc4/drivers/net/ethernet/realtek/r8169_main.c
@@ -634,6 +634,8 @@ struct rtl8169_private {
     struct rtl_fw *rtl_fw;
 
     u32 ocp_base;
+
+    int retry_probeing;
 };
 
 typedef void (*rtl_generic_fct)(struct rtl8169_private *tp);
@@ -5097,13 +5099,16 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
     tp->phydev = mdiobus_get_phy(new_bus, 0);
     if (!tp->phydev) {
         return -ENODEV;
-    } else if (!tp->phydev->drv) {
-        /* Most chip versions fail with the genphy driver.
-         * Therefore ensure that the dedicated PHY driver is loaded.
+    } else if (tp->phydev->phy_id != RTL_GIGA_MAC_NONE) {
+        /* Most chip versions fail with the genphy driver, BUT do rerport valid IW
+         * ID. Re-starting the module seem to fix the issue of non-functional driver.
          */
-        dev_err(&pdev->dev, "no dedicated PHY driver found for PHY ID 0x%08x, maybe realtek.ko needs to be added to initramfs?\n",
+        dev_err(&pdev->dev,
+            "no dedicated driver, but HW found: PHY PHY ID 0x%08x\n",
             tp->phydev->phy_id);
-        return -EUNATCH;
+
+        dev_err(&pdev->dev, "trying re-probe few times..\n");
+
     }
 
     tp->phydev->mac_managed_pm = 1;
@@ -5250,6 +5255,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
     enum mac_version chipset;
     struct net_device *dev;
     u16 xid;
+    int savederr = 0;
 
     dev = devm_alloc_etherdev(&pdev->dev, sizeof (*tp));
     if (!dev)
@@ -5261,6 +5267,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
     tp->dev = dev;
     tp->pci_dev = pdev;
     tp->supports_gmii = ent->driver_data == RTL_CFG_NO_GBIT ? 0 : 1;
+    tp->retry_probeing = 0;
     tp->eee_adv = -1;
     tp->ocp_base = OCP_STD_PHY_BASE;
 
@@ -5410,7 +5417,15 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 
     pci_set_drvdata(pdev, tp);
 
-    rc = r8169_mdio_register(tp);
+    savederr = r8169_mdio_register(tp);
+
+    if (
+        (tp->retry_probeing > 0) &&
+        (savederr == -EAGAIN)
+       ) {
+        netdev_info(dev, " retry of probe requested..............");
+    }
+
     if (rc)
         return rc;
 
@@ -5435,6 +5450,14 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
     if (pci_dev_run_wake(pdev))
         pm_runtime_put_sync(&pdev->dev);
 
+    if (
+        (tp->retry_probeing > 0) &&
+        (savederr == -EAGAIN)
+       ) {
+        netdev_info(dev, " retry of probe requested..............");
+        return savederr;
+    }
+
     return 0;
 }
 
diff --git a/linux-5.14-rc4/drivers/net/phy/phy_device.c b/linux-5.14-rc4/drivers/net/phy/phy_device.c
index 5d5f9a9ee..59c6ac031 100644
--- a/linux-5.14-rc4/drivers/net/phy/phy_device.c
+++ b/linux-5.14-rc4/drivers/net/phy/phy_device.c
@@ -2980,6 +2980,9 @@ struct fwnode_handle *fwnode_get_phy_node(struct fwnode_handle *fwnode)
 }
 EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
 
+
+static int phy_remove(struct device *dev);
+
 /**
  * phy_probe - probe and init a PHY device
  * @dev: device to probe and init
@@ -2988,13 +2991,22 @@ EXPORT_SYMBOL_GPL(fwnode_get_phy_node);
  *   set the state to READY (the driver's init function should
  *   set it to STARTING if needed).
  */
+#define REDO_PROBE_TIMES    5
 static int phy_probe(struct device *dev)
 {
     struct phy_device *phydev = to_phy_device(dev);
     struct device_driver *drv = phydev->mdio.dev.driver;
     struct phy_driver *phydrv = to_phy_driver(drv);
+    int again = 0;
+    int savederr = 0;
+again_retry:
     int err = 0;
 
+    if (again > 0) {
+        pr_err("%s: Re-probe %d of driver.....\n",
+               phydrv->name, again);
+    }
+
     phydev->drv = phydrv;
 
     /* Disable the interrupt if the PHY doesn't support it
@@ -3013,6 +3025,17 @@ static int phy_probe(struct device *dev)
 
     if (phydev->drv->probe) {
         err = phydev->drv->probe(phydev);
+
+        /* If again requested. */
+        if (err == -EAGAIN) {
+            again++;
+            savederr = err;
+            err = 0;
+
+            pr_info("%s: EAGAIN: %d ...\n",
+                phydrv->name, again);
+        }
+
         if (err)
             goto out;
     }
@@ -3081,6 +3104,20 @@ static int phy_probe(struct device *dev)
 
     mutex_unlock(&phydev->lock);
 
+    if ((savederr == -EAGAIN) &&
+        ((again > 0) && (again < REDO_PROBE_TIMES))
+       ) {
+        pr_err("%s: Retry removal driver..\n",
+            phydrv->name);
+
+        phy_remove(dev);
+
+        pr_err("%s: Re-probe driver..\n",
+            phydrv->name);
+        savederr = 0;
+        goto again_retry;
+    }
+
     return err;
 }
 
@@ -3108,6 +3145,7 @@ static int phy_remove(struct device *dev)
     return 0;
 }
 
+
 static void phy_shutdown(struct device *dev)
 {
     struct phy_device *phydev = to_phy_device(dev);



On 11.3.2021 18.43, gmail wrote:
>
> Heiner Kallweit kirjoitti 11.3.2021 klo 18.23:
>> On 11.03.2021 17:00, gmail wrote:
>>> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
>>>
>>>     On 15.04.2020 16:39, Lauri Jakku wrote:
>>>
>>>         Hi, There seems to he Something odd problem, maybe timing
>>>         related. Stripped version not workingas expected. I get back to
>>>         you, when  i have it working.
>>>
>>>     There's no point in working on your patch. W/o proper justification it
>>>     isn't acceptable anyway. And so far we still don't know which problem
>>>     you actually have.
>>>     FIRST please provide the requested logs and explain the actual problem
>>>     (incl. the commit that caused the regression).
>>>
>>>
>>>              13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com
>>>         <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll
>>>         strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote: On
>>>         Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi,
>>>         Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On
>>>         Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From
>>>         2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00
>>>         2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020
>>>         13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix
>>>         The driver installation determination made properly by checking
>>>         PHY vs DRIVER id's. ---
>>>         drivers/net/ethernet/realtek/r8169_main.c | 70
>>>         ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2
>>>         files changed, 72 insertions(+), 9 deletions(-) I would say that
>>>         most of the code is debug prints. I tought that they are helpful
>>>         to keep, they are using the debug calls, so they are not visible
>>>         if user does not like those. You are missing the point of who
>>>         are your users. Users want to have working device and the code.
>>>         They don't need or like to debug their kernel. Thanks
>>>
>>>     Hi, now i got time to tackle with this again :) .. I know the proposed fix is quite hack, BUT it does give a clue what is wrong.
>>>
>>>     Something in subsystem is not working at the first time, but it needs to be reloaded to work ok (second time). So what I will do
>>>     is that I try out re-do the module load within the module, if there is known HW id available but driver is not available, that
>>>     would be much nicer and user friendly way.
>>>
>>>
>>>     When the module setup it self nicely on first load, then can be the hunt for late-init of subsystem be checked out. Is the HW
>>>     not brought up correct way during first time, or does the HW need time to brough up, or what is the cause.
>>>
>>>     The justification is the same as all HW driver bugs, the improvement is always better to take in. Or do this patch have some-
>>>     thing what other patches do not?
>>>
>>>     Is there legit reason why NOT to improve something, that is clearly issue for others also than just me ? I will take on the
>>>     task to fiddle with the module to get it more-less hacky and fully working version. Without the need for user to do something
>>>     for the module to work.
>>>
>>>         --Lauri J.
>>>
>>>
>> I have no clue what you're trying to say. The last patch wasn't acceptable at all.
>> If you want to submit a patch:
>>
>> - Follow kernel code style
>> - Explain what the exact problem is, what the root cause is, and how your patch fixes it
>> - Explain why you're sure that it doesn't break processing on other chip versions
>>    and systems.
>>
> Ok, i'll make nice patch that has in comment what is the problem and how does the patch help the case at hand.
>
> I don't know the rootcause, but something in subsystem that possibly is initializing bit slowly, cause the reloading
>
> of the module provides working network connection, when done via insmod cycle. I'm not sure is it just a timing
>
> issue or what. I'd like to check where is the driver pointer populated, and put some debugs to see if the issue is just
>
> timing, let's see.
>
>
> The problem is that (1st load) fails, but there is valid HW found (the ID is known), when the hacky patch of mine
>
> is applied, the second time of loading module works ok, and network is connected ok etc.
>
>
> I make the change so that when the current HEAD code is going to return failure, i do check that if the HW id is read ok
>
> from the HW, then pass -EAGAIN ja try to load 5 times, sleeping 250ms in between.
>
>
> --Lauri J.
>
>
>
>
