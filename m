Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AAC727EDBE
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 17:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgI3PrX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 11:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3PrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 11:47:23 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A96EC061755;
        Wed, 30 Sep 2020 08:47:23 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id j11so3582375ejk.0;
        Wed, 30 Sep 2020 08:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=P4/4J9jSN37VHhsqj9BXNnrpWEuCNt73zF+n6yHkwNg=;
        b=bKC6Ui3ovge8Ncf0+Q//tChDG3h868kS7rRPoWP0bOvWmhxWFoklUq7D8S8U5ilEEP
         WT5TcCHQxH/PeetPbx8zzDPebCLEuU4NXdt2MXH2HB09w/89N7uPi/XhmuyBbh8IJ8fI
         mymjZIV9B+YRCxJjqAvJkzr7MGQex0A3E313HNCAoRwpzYBOWjkjD8NsgRIy1pBLduwS
         jxYHTbFLoT4pCrAHKW+cS4OB+l8msh6HS/d3QY276HvE+iy28ZcihaUCbod5uETUZHLI
         TdcFjBFPiai3eC4XmwXAN6ea15RgWlj4GNWnu4CaW7X7VBmpz2TPWFVm1M8ER0qZ2x7A
         t10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=P4/4J9jSN37VHhsqj9BXNnrpWEuCNt73zF+n6yHkwNg=;
        b=GtYiTdX2GzAfSnLsOiXHWVfDdFhhMDJd1KektXoa9siqRjNQUAOVwmtGf/cIk91UfC
         XPA8kGzMz8BERcWntvDc98Ld6C9dM3Bll8GXCWWSHS57H9DrubKbmdGHhCrYrLL9Mqr/
         392mj1XH7clCjevdFBD2qepKIYvWRSs8IYDRO8deOS7/srWgwvF8Y1Q+K7ntg99a6q9H
         ycY5mqFMDnGj2XBD14g97MruXdvKRh5B+WDi42hLGBlUnapvlMbuj/1poLmoTmuQT4Zh
         /SMUjDdE3oCsselkHy1T7Nd1phOw1UlwC9fSqBtOV1ydDXiePqX2GDflkra0xQFHzaT6
         04OA==
X-Gm-Message-State: AOAM533svfa211DQE0Lmsmt78I3J1H+PJ6QaLizQoIs/pbEpSMKXQDMm
        +pO/XoQlI2YZJezBa/gNRXPrYYqUkeo=
X-Google-Smtp-Source: ABdhPJwf5yhdT+pyXcoW1Z/cvIkSRAHqg3djLct9ZJaTIz9ERxDPIHH6PcMWUmBX3xAgPYOEcRx/4Q==
X-Received: by 2002:a17:906:b790:: with SMTP id dt16mr3309680ejb.33.1601480841385;
        Wed, 30 Sep 2020 08:47:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f00:6a00:814c:b08d:e987:8b78? (p200300ea8f006a00814cb08de9878b78.dip0.t-ipconnect.de. [2003:ea:8f00:6a00:814c:b08d:e987:8b78])
        by smtp.googlemail.com with ESMTPSA id o3sm1830777edt.79.2020.09.30.08.47.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2020 08:47:20 -0700 (PDT)
Subject: Re: RTL8402 stops working after hibernate/resume
To:     Hans de Goede <hdegoede@redhat.com>,
        Petr Tesarik <ptesarik@suse.cz>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        netdev@vger.kernel.org, linux-clk@vger.kernel.org
References: <20200715102820.7207f2f8@ezekiel.suse.cz>
 <d742082e-42a1-d904-8a8f-4583944e88e1@gmail.com>
 <20200716105835.32852035@ezekiel.suse.cz>
 <e1c7a37f-d8d0-a773-925c-987b92f12694@gmail.com>
 <20200903104122.1e90e03c@ezekiel.suse.cz>
 <7e6bbb75-d8db-280d-ac5b-86013af39071@gmail.com>
 <20200924211444.3ba3874b@ezekiel.suse.cz>
 <a10f658b-7fdf-2789-070a-83ad5549191a@gmail.com>
 <20200925093037.0fac65b7@ezekiel.suse.cz>
 <20200925105455.50d4d1cc@ezekiel.suse.cz>
 <aa997635-a5b5-75e3-8a30-a77acb2adf35@gmail.com>
 <20200925115241.3709caf6@ezekiel.suse.cz>
 <20200925145608.66a89e73@ezekiel.suse.cz>
 <30969885-9611-06d8-d50a-577897fcab29@gmail.com>
 <20200929210737.7f4a6da7@ezekiel.suse.cz>
 <217ae37d-f2b0-1805-5696-11644b058819@redhat.com>
 <5f2d3d48-9d1d-e9fe-49bc-d1feeb8a92eb@gmail.com>
 <1c2d888a-5702-cca9-195c-23c3d0d936b9@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <8a82a023-e361-79db-7127-769e4f6e0d1b@gmail.com>
Date:   Wed, 30 Sep 2020 17:47:15 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <1c2d888a-5702-cca9-195c-23c3d0d936b9@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.09.2020 11:04, Hans de Goede wrote:
> Hi,
> 
> On 9/29/20 10:35 PM, Heiner Kallweit wrote:
>> On 29.09.2020 22:08, Hans de Goede wrote:
> 
> <snip>
> 
>>> Also some remarks about this while I'm being a bit grumpy about
>>> all this anyways (sorry):
>>>
>>> 1. 9f0b54cd167219 ("r8169: move switching optional clock on/off
>>> to pll power functions") commit's message does not seem to really
>>> explain why this change was made...
>>>
>>> 2. If a git blame would have been done to find the commit adding
>>> the clk support: commit c2f6f3ee7f22 ("r8169: Get and enable optional ether_clk clock")
>>> then you could have known that the clk in question is an external
>>> clock for the entire chip, the commit message pretty clearly states
>>> this (although "the entire" part is implied only) :
>>>
>>> "On some boards a platform clock is used as clock for the r8169 chip,
>>> this commit adds support for getting and enabling this clock (assuming
>>> it has an "ether_clk" alias set on it).
>>>
>> Even if the missing clock would stop the network chip completely,
>> this shouldn't freeze the system as described by Petr.
>> In some old RTL8169S spec an external 25MHz clock is mentioned,
>> what matches the MII bus frequency. Therefore I'm not 100% convinced
>> that the clock is needed for basic chip operation, but due to
>> Realtek not releasing datasheets I can't verify this.
> 
> Well if that 25 MHz is the only clock the chip has, then it basically
> has to be on all the time since all clocked digital ASICs cannot work
> without a clock.  Now pci-e is a packet-switched point-to-point bus,
> so the ethernet chip not working should not freeze the entire system,
> but I'm not really surprised that even though it should not do that,
> that it still does.
> 
>> But yes, if reverting this change avoids the issue on Petr's system,
>> then we should do it. A simple mechanical revert wouldn't work because
>> source file structure has changed since then, so I'll prepare a patch
>> that effectively reverts the change.
> 
> Great, thank you.
> 
> Regards,
> 
> Hans
> 

Petr,
in the following I send two patches. First one is supposed to fix the freeze.
It also fixes another issue that existed before my ether_clk change:
ether_clk was disabled on suspend even if WoL is enabled. And the network
chip most likely needs the clock to check for WoL packets.
Please let me know whether it fixes the freeze, then I'll add your Tested-by.

Second patch is a re-send of the one I sent before, it should fix
the rx issues after resume from suspend for you.


diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 6c7c004c2..72351c5b0 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -2236,14 +2236,10 @@ static void rtl_pll_power_down(struct rtl8169_private *tp)
 	default:
 		break;
 	}
-
-	clk_disable_unprepare(tp->clk);
 }
 
 static void rtl_pll_power_up(struct rtl8169_private *tp)
 {
-	clk_prepare_enable(tp->clk);
-
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_25 ... RTL_GIGA_MAC_VER_33:
 	case RTL_GIGA_MAC_VER_37:
@@ -4820,29 +4816,39 @@ static void rtl8169_net_suspend(struct rtl8169_private *tp)
 
 #ifdef CONFIG_PM
 
+static int rtl8169_net_resume(struct rtl8169_private *tp)
+{
+	rtl_rar_set(tp, tp->dev->dev_addr);
+
+	if (tp->TxDescArray)
+		rtl8169_up(tp);
+
+	netif_device_attach(tp->dev);
+
+	return 0;
+}
+
 static int __maybe_unused rtl8169_suspend(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
 	rtnl_lock();
 	rtl8169_net_suspend(tp);
+	if (!device_may_wakeup(tp_to_dev(tp)))
+		clk_disable_unprepare(tp->clk);
 	rtnl_unlock();
 
 	return 0;
 }
 
-static int rtl8169_resume(struct device *device)
+static int __maybe_unused rtl8169_resume(struct device *device)
 {
 	struct rtl8169_private *tp = dev_get_drvdata(device);
 
-	rtl_rar_set(tp, tp->dev->dev_addr);
-
-	if (tp->TxDescArray)
-		rtl8169_up(tp);
+	if (!device_may_wakeup(tp_to_dev(tp)))
+		clk_prepare_enable(tp->clk);
 
-	netif_device_attach(tp->dev);
-
-	return 0;
+	return rtl8169_net_resume(tp);
 }
 
 static int rtl8169_runtime_suspend(struct device *device)
@@ -4868,7 +4874,7 @@ static int rtl8169_runtime_resume(struct device *device)
 
 	__rtl8169_set_wol(tp, tp->saved_wolopts);
 
-	return rtl8169_resume(device);
+	return rtl8169_net_resume(tp);
 }
 
 static int rtl8169_runtime_idle(struct device *device)
-- 
2.28.0









diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 9e4e6a883..4fb49fd0d 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4837,6 +4837,10 @@ static int rtl8169_resume(struct device *device)
 
 	rtl_rar_set(tp, tp->dev->dev_addr);
 
+	/* Reportedly at least Asus X453MA corrupts packets otherwise */
+	if (tp->mac_version == RTL_GIGA_MAC_VER_37)
+		rtl_init_rxcfg(tp);
+
 	if (tp->TxDescArray)
 		rtl8169_up(tp);
 
-- 
2.28.0


