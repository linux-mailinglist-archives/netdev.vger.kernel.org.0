Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E63A1ACFA8
	for <lists+netdev@lfdr.de>; Thu, 16 Apr 2020 20:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390439AbgDPS1E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Apr 2020 14:27:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390331AbgDPS1C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Apr 2020 14:27:02 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F340DC061A0C
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 11:27:01 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id r26so6038172wmh.0
        for <netdev@vger.kernel.org>; Thu, 16 Apr 2020 11:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8HVjJTUM0/wmXvFVD0ZBdPHYukVg0MKp5J8erIoPLrg=;
        b=Gtc0rYhj9YBRK0UiDchsjnSFPaTJ4mvzQo5AZ15UTOeNMTubCp6Gfi0GxLUz00MEPz
         vacX5/r3cEPUZTYqLEenSmN+xUEfPSaQUKqzAOG8MSiUaLBsD+dhkv7Fs6qikKLKHwmq
         McVFc9x2BhOwYOa48GqjYWLRDmbdNQ/rYuvcACtjuQTedoE/lNyp2BcjSvFUOJYRGZzh
         LzCX0wIJDG3g5RmzyUZYzIIyZCNKuo8A2v2L28iLzEVGj6IL9lV6G5xLzjzCU6Iai0fe
         UxlvB/IJ9G9Vvl+S/uSl3/mJ7fxehLzljyiRVMZIEjJIV4nr4jmJsW9fjrNyxpco4cae
         eZKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8HVjJTUM0/wmXvFVD0ZBdPHYukVg0MKp5J8erIoPLrg=;
        b=pPW1cOQ2uI31Y2NDa29ExobOMH5Qhuz26TwsPobe4l8iUe7BV9XmAvHpInQIOS/yu6
         7b5wzpmwfxkVD9Dw3btq5GZpaSwimHkytMbfLOySdm72gOVDCm6hc0Vrfdw1LP6/Ffnl
         Nvr6N08okMelyznVRYt92wSuZg87gkzWAMrllwpuXNpxzk6a5uQIC0mRG0cvBK96PsuE
         gPDEsiXWNVfzQ+vjItg1gTAV3QO9CyR3h29LhXjj2Oi/cBne/BayYEMI0WDgD5RZuPQf
         VQdMSEqcpJkRZQzsZKIsaKGM1/pW8jJYauDgC4T6f/C+T+Ti3qUn8G/9Neky1tjyc71u
         m9BQ==
X-Gm-Message-State: AGi0PuaHWPb1PWZ2z4ZIJZoI0KzCGWMPp+YI3irjb+/qtQWijl0MBZ+F
        Bm7CCLlQ9Yfw6NbCPg/kiSc=
X-Google-Smtp-Source: APiQypLuNtUjYu6NqT/sqZumCUWEAMtWc3NPcHzc/9Q/+r6yhX7DikWrvOcoDYRS6s9UL1/QpHaLOA==
X-Received: by 2002:a1c:492:: with SMTP id 140mr6496349wme.9.1587061620673;
        Thu, 16 Apr 2020 11:27:00 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:b900:f290:558a:f094? (p200300EA8F296000B900F290558AF094.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b900:f290:558a:f094])
        by smtp.googlemail.com with ESMTPSA id r20sm4374845wmh.26.2020.04.16.11.26.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Apr 2020 11:26:59 -0700 (PDT)
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <70cfcfb3-ce2a-9d47-b034-b94682e46e35@gmail.com>
Date:   Thu, 16 Apr 2020 20:26:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <4860e57e-93e4-24f5-6103-fa80acbdfa0d@pp.inet.fi>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16.04.2020 13:30, Lauri Jakku wrote:
> Hi,
> 
> 
> 5.6.3-2-MANJARO: stock manjaro kernel, without modifications --> network does not work
> 
> 5.6.3-2-MANJARO-lja: No attach check, modified kernel (r8169 mods only) --> network does not work
> 
> 5.6.3-2-MANJARO-with-the-r8169-patch: phy patched + r8169 mods -> devices show up ok, network works
> 
> All different initcpio's have realtek.ko in them.
> 
Thanks for the logs. Based on the logs you're presumable affected by a known BIOS bug.
Check bug tickets 202275 and 207203 at bugzilla.kernel.org.
In the first referenced tickets it's about the same mainboard (with earlier BIOS version).
BIOS on this mainboard seems to not initialize the network chip / PHY correctly, it reports
a random number as PHY ID, resulting in no PHY driver being found.
Enable "Onboard LAN Boot ROM" in the BIOS, and your problem should be gone.


> 
> The problem with old method seems to be, that device does not have had time to attach before the
> PHY driver check.
> 
> The patch:
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index bf5bf05970a2..acd122a88d4a 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5172,11 +5172,11 @@ static int r8169_mdio_register(struct rtl8169_private *tp)
>         if (!tp->phydev) {
>                 mdiobus_unregister(new_bus);
>                 return -ENODEV;
> -       } else if (!tp->phydev->drv) {
> +       } else if (tp->mac_version == RTL_GIGA_MAC_NONE) {
>                 /* Most chip versions fail with the genphy driver.
>                  * Therefore ensure that the dedicated PHY driver is loaded.
>                  */
> -               dev_err(&pdev->dev, "realtek.ko not loaded, maybe it needs to be added to initramfs?\n");
> +               dev_err(&pdev->dev, "Not known MAC version.\n");
>                 mdiobus_unregister(new_bus);
>                 return -EUNATCH;
>         }
> diff --git a/drivers/net/phy/phy-core.c b/drivers/net/phy/phy-core.c
> index 66b8c61ca74c..aba2b304b821 100644
> --- a/drivers/net/phy/phy-core.c
> +++ b/drivers/net/phy/phy-core.c
> @@ -704,6 +704,10 @@ EXPORT_SYMBOL_GPL(phy_modify_mmd);
>  
>  static int __phy_read_page(struct phy_device *phydev)
>  {
> +       /* If not attached, do nothing (no warning) */
> +       if (!phydev->attached_dev)
> +               return -EOPNOTSUPP;
> +
>         if (WARN_ONCE(!phydev->drv->read_page, "read_page callback not available, PHY driver not loaded?\n"))
>                 return -EOPNOTSUPP;
>  
> @@ -712,12 +716,17 @@ static int __phy_read_page(struct phy_device *phydev)
>  
>  static int __phy_write_page(struct phy_device *phydev, int page)
>  {
> +       /* If not attached, do nothing (no warning) */
> +       if (!phydev->attached_dev)
> +               return -EOPNOTSUPP;
> +
>         if (WARN_ONCE(!phydev->drv->write_page, "write_page callback not available, PHY driver not loaded?\n"))
>                 return -EOPNOTSUPP;
>  
>         return phydev->drv->write_page(phydev, page);
>  }
>  
> +
>  /**
>   * phy_save_page() - take the bus lock and save the current page
>   * @phydev: a pointer to a &struct phy_device
> 
> 
> 
> 15. huhtik. 2020, 19.18, Heiner Kallweit <hkallweit1@gmail.com <mailto:hkallweit1@gmail.com>> kirjoitti:
> 
>     On 15.04.2020 16:39, Lauri Jakku wrote:
> 
>         Hi, There seems to he Something odd problem, maybe timing related. Stripped version not workingas expected. I get back to you, when  i have it working. 
> 
> 
>     There's no point in working on your patch. W/o proper justification it
>     isn't acceptable anyway. And so far we still don't know which problem
>     you actually have.
>     FIRST please provide the requested logs and explain the actual problem
>     (incl. the commit that caused the regression).
> 
> 
> 
> 
>         13. huhtik. 2020, 14.46, Lauri Jakku <ljakku77@gmail.com <mailto:ljakku77@gmail.com>> kirjoitti: Hi, Fair enough, i'll strip them. -lja On 2020-04-13 14:34, Leon Romanovsky wrote:
> 
>         On Mon, Apr 13, 2020 at 02:02:01PM +0300, Lauri Jakku wrote: Hi, Comments inline. On 2020-04-13 13:58, Leon Romanovsky wrote: On Mon, Apr 13, 2020 at 01:30:13PM +0300, Lauri Jakku wrote: From 2d41edd4e6455187094f3a13d58c46eeee35aa31 Mon Sep 17 00:00:00 2001 From: Lauri Jakku <lja@iki.fi> Date: Mon, 13 Apr 2020 13:18:35 +0300 Subject: [PATCH] NET: r8168/r8169 identifying fix The driver installation determination made properly by checking PHY vs DRIVER id's. --- drivers/net/ethernet/realtek/r8169_main.c | 70 ++++++++++++++++++++--- drivers/net/phy/mdio_bus.c | 11 +++- 2 files changed, 72 insertions(+), 9 deletions(-) I would say that most of the code is debug prints. I tought that they are helpful to keep, they are using the debug calls, so they are not visible if user does not like those. You are missing the point of who are your users. Users want to have working device and the code. They don't need or like to debug their kernel. Thanks 
> 
> 

