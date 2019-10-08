Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A3C1D01E5
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 22:04:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730410AbfJHUE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 16:04:56 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35493 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730070AbfJHUE4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 16:04:56 -0400
Received: by mail-wm1-f68.google.com with SMTP id y21so4428656wmi.0
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 13:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kjk9++/WdxRu2QEtibjhC8Ep87j9HKpfD4cYnVqD61M=;
        b=CFznlEB0RGkTEfqz7QeVR6Hoj6316OiZm4OOp1OViLCBNgGdY8DmiM6cYeo8zQhs0l
         6SPtSbHI+K+6ue7QgtjkSLUChBC8CRm52K+Jiy+gl6EhlgUP3WGgJQ/GvBzJFZkD/5ps
         R+YYBs9JLAKnsB2g4D3QxzJEpHx+/liiPIcs4PcAFyAGQTJ2cZnNtHWpyonAKXJaYwQW
         kxe3JRVC+TD1RPy6KBeVLZlHkjUWyUpBeVfE+WIXkGXxPUXtL1eW8OSXiTEd+nX6corS
         aJiILEWlw8TU03roe043ZnsJ5oapwv2j2zpFRX1v+MGOAog2ZLO83Vfavql7vQZMXc+n
         LcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kjk9++/WdxRu2QEtibjhC8Ep87j9HKpfD4cYnVqD61M=;
        b=ciKH6oZQ1t49rsED/KNxcOI06Oi2Y7yIBkdSsdG+y8uRPQ6jVpAczhDs5zmqJQcqZJ
         IvM1hgLHRB8POtXjNGx7rF7jfV6G0w/C3q0WkVmzOfAzDGrvJ/00A/9haWdveNcDfZFd
         MenatqhIskcZsL4FRfFbwbba69AKUagseDAsi8N8aBENcZwXiFpQ8MSspSaj3GgB2Otz
         Ys7jckZqOt0fr0Jo49qvUmfrTTtOw1U/t9TKCWUUMW4MyawqNVSgjupcfX5H8T7DhxQg
         BKhLDh+WQMuqyzT8HhQogyyJqCBsltOANTzEojhjXDenEgRjvxXe4s4/0UVs4L9uKV9j
         mAJw==
X-Gm-Message-State: APjAAAUocGG31Wv3AVqB+EXvJoRwdy5qYk3yBzyRigRaJiuzg7GbYBxB
        d5d5qgsbr4xAK7reYu7aGwAG422q
X-Google-Smtp-Source: APXvYqxivnlBEGEFSPhQYJRfYWFmjktLDKcdmkEr8oSLmIg8NyLX3PvA0OHNfcGb7lFqNfeAb6XwzQ==
X-Received: by 2002:a05:600c:10ce:: with SMTP id l14mr5131769wmd.15.1570565092969;
        Tue, 08 Oct 2019 13:04:52 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f26:6400:1dc6:b02d:53c2:ab45? (p200300EA8F2664001DC6B02D53C2AB45.dip0.t-ipconnect.de. [2003:ea:8f26:6400:1dc6:b02d:53c2:ab45])
        by smtp.googlemail.com with ESMTPSA id c132sm5912405wme.27.2019.10.08.13.04.51
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 08 Oct 2019 13:04:52 -0700 (PDT)
Subject: Re: RTL8169 question
To:     Mariusz Bialonczyk <manio@skyboo.net>
References: <20190913114424.540c1d257c4083eace242bbf@skyboo.net>
 <c55484e7-9dfb-0e5e-3887-278a334ac831@gmail.com>
 <20191008102706.e3f57ffe3e779802898a99ee@skyboo.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <c6cac9fa-36fe-dded-a0a7-082326c3cc36@gmail.com>
Date:   Tue, 8 Oct 2019 22:04:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191008102706.e3f57ffe3e779802898a99ee@skyboo.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.10.2019 10:27, Mariusz Bialonczyk wrote:
> Heiner,
> Hello again.
> 
> On Wed, 25 Sep 2019 21:28:04 +0200
> Heiner Kallweit <hkallweit1@gmail.com> wrote:
> 
>>> Here is the brief description of the problem:
>>> After the NIC is going out of suspend-to-ram it is in some weird state.
>>> This state is causing problems on the cisco switch.
>>> If I understand the problem correctly my assumption is that the driver
>>> is probably waking up the NIC wrongly and this is leading to problems
>>> with cisco switch (which probably also have a bug in the firmware)... :)
>>>
>> The MTU setting doesn't affect L2 (link level), so it's not clear how this
>> should cause problems with the switch. Your RTL8168 chip version is ancient
>> and I can't rule out a HW issue with this chip version, so the best advice
>> I can give is: don't use jumbo packets (as chip also doesn't support
>> HW checksumming for jumbo packets).
> After hours spent of wireshark/tcpdump analysis I found the problem :)
> The RTL8168 chip or linux driver is malforming packets after wakeup from
> suspend-to-ram. I am able to catch a single packets which are starting with
> random src and dst MAC addresses (samples in attachment).
> The problem is when the MTU is set to 9000.
> These packets are single ones in the stream but it is affecting transmission.
> Do you think it would be easy catch and fix the problem in the linux driver?
> I have near 100% reproduce rate of the problem with 'stress' tool.

Thanks for the comprehensive analysis! Comparing the chip registers before
and after suspend your BIOS seems to change registers on resume from suspend,
and the driver doesn't configure jumbo when resuming. This may explain the
issue. The combination jumbo + suspend + BIOS bug seems to be quite rare,
else I think we should have seen such a report years ago already.
Could you please check whether the following patch fixes the issue for you?

Heiner

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 74f81fe03..350b0d949 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -4146,6 +4146,14 @@ static void rtl_hw_jumbo_disable(struct rtl8169_private *tp)
 	rtl_lock_config_regs(tp);
 }
 
+static void rtl_jumbo_config(struct rtl8169_private *tp, int mtu)
+{
+	if (mtu > ETH_DATA_LEN)
+		rtl_hw_jumbo_enable(tp);
+	else
+		rtl_hw_jumbo_disable(tp);
+}
+
 DECLARE_RTL_COND(rtl_chipcmd_cond)
 {
 	return RTL_R8(tp, ChipCmd) & CmdReset;
@@ -4442,11 +4450,6 @@ static void rtl8168g_set_pause_thresholds(struct rtl8169_private *tp,
 static void rtl_hw_start_8168bb(struct rtl8169_private *tp)
 {
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN) {
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B |
-					 PCI_EXP_DEVCTL_NOSNOOP_EN);
-	}
 }
 
 static void rtl_hw_start_8168bef(struct rtl8169_private *tp)
@@ -4462,9 +4465,6 @@ static void __rtl_hw_start_8168cp(struct rtl8169_private *tp)
 
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_disable_clock_request(tp);
 }
 
@@ -4490,9 +4490,6 @@ static void rtl_hw_start_8168cp_2(struct rtl8169_private *tp)
 	rtl_set_def_aspm_entry_latency(tp);
 
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Beacon_en);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
@@ -4503,9 +4500,6 @@ static void rtl_hw_start_8168cp_3(struct rtl8169_private *tp)
 
 	/* Magic. */
 	RTL_W8(tp, DBG_REG, 0x20);
-
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
 }
 
 static void rtl_hw_start_8168c_1(struct rtl8169_private *tp)
@@ -4611,9 +4605,6 @@ static void rtl_hw_start_8168e_1(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8168e_1);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_disable_clock_request(tp);
 
 	/* Reset tx FIFO pointer */
@@ -4636,9 +4627,6 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	rtl_ephy_init(tp, e_info_8168e_2);
 
-	if (tp->dev->mtu <= ETH_DATA_LEN)
-		rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-
 	rtl_eri_write(tp, 0xc0, ERIAR_MASK_0011, 0x0000);
 	rtl_eri_write(tp, 0xb8, ERIAR_MASK_0011, 0x0000);
 	rtl_set_fifo_size(tp, 0x10, 0x10, 0x02, 0x06);
@@ -5485,6 +5473,8 @@ static void rtl_hw_start(struct  rtl8169_private *tp)
 	rtl_set_rx_tx_desc_registers(tp);
 	rtl_lock_config_regs(tp);
 
+	rtl_jumbo_config(tp, tp->dev->mtu);
+
 	/* Initially a 10 us delay. Turned it into a PCI commit. - FR */
 	RTL_R16(tp, CPlusCmd);
 	RTL_W8(tp, ChipCmd, CmdTxEnb | CmdRxEnb);
@@ -5498,10 +5488,7 @@ static int rtl8169_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct rtl8169_private *tp = netdev_priv(dev);
 
-	if (new_mtu > ETH_DATA_LEN)
-		rtl_hw_jumbo_enable(tp);
-	else
-		rtl_hw_jumbo_disable(tp);
+	rtl_jumbo_config(tp, new_mtu);
 
 	dev->mtu = new_mtu;
 	netdev_update_features(dev);
-- 
2.23.0


