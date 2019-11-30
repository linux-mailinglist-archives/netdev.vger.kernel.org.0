Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD3410DF6C
	for <lists+netdev@lfdr.de>; Sat, 30 Nov 2019 22:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfK3Vhg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Nov 2019 16:37:36 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36322 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726981AbfK3Vhg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Nov 2019 16:37:36 -0500
Received: by mail-wr1-f68.google.com with SMTP id z3so39219370wru.3;
        Sat, 30 Nov 2019 13:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ll2mBh78Igd8pFMlZIjIxNiwEVMBNAzRdv5H4t6A7x8=;
        b=jbRPh4ag2/806G33wqnDqlRTH4rNdr4j0EFQp4gL6Zi88d7bAoWcpfopqHrk4T+1I+
         6bA4waA0K/dSpfkn7+ApI4dJajGph21B9kXAdu2U4XlRz10Jy+gdJb4LKnILW6FS+VIt
         lTHAs/NDKuR2l66EqGkBWnkArAg5H9U2/gR64lMovrclwImIBMM00z5Vr6571QW/VA5z
         tTtwHedAtQSW4ek+HXt+HUpD4Gs8pqJ+x8I0K5DXGuzKmSkNTqoBNZSRslGxBEu7tZjs
         wNxhPZySN02HN3iHgGMCkdHB8HU9vocStigwexIWe19eNTPoWEvTAhCofGz0FAOnHYVn
         v3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ll2mBh78Igd8pFMlZIjIxNiwEVMBNAzRdv5H4t6A7x8=;
        b=AYNN9Zf6mg071sLwTdlCX6XhJgWCn72UoZUB+y6lfk5kr3r4UbPqKCw/Wn63ZAcqhS
         LEa2ibux8z9UoFPh6unLzqwD0oO3KEQrdiaiOA+31j3vNaYmCzj7er1D6OPWEOHluIxs
         fW99vdG+npi4oonLjk3N3w7Zefq2cQ5DYPu1tbNumkjz0DCHxi6yKHBNbcZVjxwK5Ihx
         Ma7eFMMbelLUe2aemiKoDQIusQr51kCuYpI6WhGiiFYxHQ6a0t8jT1CP/RK8rwnuCeut
         dSiZkiJO7l7BJDkN7y7MUc8/HAfa6TTaxIDf95ppCndbX4d1YDyH8em4BzDNDotSK1ce
         z2fA==
X-Gm-Message-State: APjAAAVQGue8na3gCwPVUaIorY3NR9EFaRA4qJmtsGvfXLzmtuDglTY/
        mAM4bXADQQyYBp1QWhujtv2P2qLx
X-Google-Smtp-Source: APXvYqy+/AlnLifmFvMF807skvRhNfoMG9EpJwV7HeMD+zkv1M4ZTlEiinmPl26j1ktLLrSI64hVvw==
X-Received: by 2002:adf:b746:: with SMTP id n6mr61113550wre.65.1575149852751;
        Sat, 30 Nov 2019 13:37:32 -0800 (PST)
Received: from ?IPv6:2003:ea:8f4a:6300:7441:dba6:2c4a:1e97? (p200300EA8F4A63007441DBA62C4A1E97.dip0.t-ipconnect.de. [2003:ea:8f4a:6300:7441:dba6:2c4a:1e97])
        by smtp.googlemail.com with ESMTPSA id c184sm7335311wma.20.2019.11.30.13.37.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 30 Nov 2019 13:37:32 -0800 (PST)
Subject: Re: 5.4 Regression in r8169 with jumbo frames - packet loss/delays
To:     "Alan J. Wylie" <alan@wylie.me.uk>
References: <24034.56114.248207.524177@wylie.me.uk>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <75146b50-9518-8588-81fa-f2811faf6cca@gmail.com>
Date:   Sat, 30 Nov 2019 22:37:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <24034.56114.248207.524177@wylie.me.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.2019 22:12, Alan J. Wylie wrote:
> 
> I have a Realtek ethernet interface (rtl8168e ?) using the r8169 driver
> 
> It uses Jumbo frames (6000 bytes) and has a bridge on it.
> 
> With 5.4 I saw repeated packet loss / very long delays. Also with 5.4.1.
> 
> There were also some kernel messages at about the same time as the
> pings stopped: "r8169 transmit queue timed out".
> 
> I was unable to reproduce the issue on another system with a different
> network card.
> 
> I've run a fairly targeted bisect - see below.
> 
> If there is any more information I can provide, or testing to be done
> I'll be glad to help.
> 

Thanks for the report. A jumbo fix for one chip version may have
revealed an issue with another chip version. Could you please try
the following?
I checked the vendor driver r8168 and there's no special sequence
to configure jumbo mode.

What would be interesting:
Do you set the (jumbo) MTU before bringing the device up?

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 0b47db2ff..38d212686 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -3873,7 +3873,7 @@ static void rtl_hw_jumbo_enable(struct rtl8169_private *tp)
 	case RTL_GIGA_MAC_VER_27 ... RTL_GIGA_MAC_VER_28:
 		r8168dp_hw_jumbo_enable(tp);
 		break;
-	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_34:
+	case RTL_GIGA_MAC_VER_31 ... RTL_GIGA_MAC_VER_33:
 		r8168e_hw_jumbo_enable(tp);
 		break;
 	default:
-- 
2.24.0


> Regards
> Alan
> 
Rgds, Heiner
> 
> git bisect start '--' 'drivers/net/ethernet/realtek'
> # good: [b8e167066e85c9e1e9c5d27b82a858d96e6ba22c] Linux 5.3.14
> git bisect good b8e167066e85c9e1e9c5d27b82a858d96e6ba22c
> # bad: [219d54332a09e8d8741c1e1982f5eae56099de85] Linux 5.4
> git bisect bad 219d54332a09e8d8741c1e1982f5eae56099de85
> # good: [4d856f72c10ecb060868ed10ff1b1453943fc6c8] Linux 5.3
> git bisect good 4d856f72c10ecb060868ed10ff1b1453943fc6c8
> # good: [2e779ddb5617928ee09842758c4734682264279d] r8169: use the generic EEE management functions
> git bisect good 2e779ddb5617928ee09842758c4734682264279d
> # good: [ae84bc18733752e9bf47227bd80b3c0f3649b8d0] r8169: don't use bit LastFrag in tx descriptor after send
> git bisect good ae84bc18733752e9bf47227bd80b3c0f3649b8d0
> # good: [dc161162e42ca51daff50e86a4a4bb8395d60501] r8169: don't set bit RxVlan on RTL8125
> git bisect good dc161162e42ca51daff50e86a4a4bb8395d60501
> # bad: [4ebcb113edcc498888394821bca2e60ef89c6ff3] r8169: fix jumbo packet handling on resume from suspend
> git bisect bad 4ebcb113edcc498888394821bca2e60ef89c6ff3
> # good: [299d14d4c31aff3b37a03894e012edf8421676ee] Merge tag 'pci-v5.4-changes' of git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci
> git bisect good 299d14d4c31aff3b37a03894e012edf8421676ee
> # first bad commit: [4ebcb113edcc498888394821bca2e60ef89c6ff3] r8169: fix jumbo packet handling on resume from suspend
> 
> 
> 2: enp3s0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 6000 qdisc pfifo_fast master br0 state UP mode DEFAULT group default qlen 1000
>     link/ether 90:2b:34:9d:ed:6f brd ff:ff:ff:ff:ff:ff
> 
> 3: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 6000 qdisc noqueue state UP mode DEFAULT group default qlen 1000
>     link/ether 90:2b:34:9d:ed:6f brd ff:ff:ff:ff:ff:ff
> 
> 
> 03:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 06)
> 	Subsystem: Gigabyte Technology Co., Ltd Onboard Ethernet
> 	Flags: bus master, fast devsel, latency 0, IRQ 17, NUMA node 0
> 	I/O ports at de00 [size=256]
> 	Memory at fdeff000 (64-bit, prefetchable) [size=4K]
> 	Memory at fdef8000 (64-bit, prefetchable) [size=16K]
> 	Capabilities: <access denied>
> 	Kernel driver in use: r8169
> 
> # ethtool -i enp3s0
> driver: r8169
> version:
> firmware-version: rtl8168e-3_0.0.4 03/27/12
> expansion-rom-version:
> bus-info: 0000:03:00.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: yes
> supports-priv-flags: no
> 
> # mii-tool -v enp3s0
> enp3s0: negotiated 1000baseT-FD flow-control, link ok
>   product info: vendor 00:07:32, model 17 rev 5
>   basic mode:   autonegotiation enabled
>   basic status: autonegotiation complete, link ok
>   capabilities: 1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD
>   advertising:  1000baseT-HD 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
>   link partner: 1000baseT-FD 100baseTx-FD 100baseTx-HD 10baseT-FD 10baseT-HD flow-control
> 
> 
> [  203.908724] NETDEV WATCHDOG: enp3s0 (r8169): transmit queue 0 timed out
> [  203.908831] WARNING: CPU: 7 PID: 0 at net/sched/sch_generic.c:447 dev_watchdog+0x256/0x260
> [  203.908883] Modules linked in: cpuid i2c_dev asus_atk0110 acpi_power_meter it87 hwmon_vid af_packet bridge stp llc usbhid xhci_pci ohci_pci xhci_hcd ohci_hcd ehci_pci ehci_hcd sr_mod usbcore 8250 cdrom i2c_piix4 k10temp fam15h_power usb_common 8250_base serial_core acpi_cpufreq ghash_clmulni_intel cryptd evdev softdog
> [  203.908995] CPU: 7 PID: 0 Comm: swapper/7 Not tainted 5.4.0-rc1-00312-g4ebcb113edcc #4
> [  203.909046] Hardware name: Gigabyte Technology Co., Ltd. GA-990XA-UD3/GA-990XA-UD3, BIOS F12 05/30/2012
> [  203.909103] RIP: 0010:dev_watchdog+0x256/0x260
> [  203.909150] Code: ff 0f 1f 00 eb 85 4c 89 f7 c6 05 0a 3e b3 00 01 e8 df 40 fc ff 44 89 e9 48 89 c2 4c 89 f6 48 c7 c7 60 b3 db aa e8 ea e0 aa ff <0f> 0b e9 63 ff ff ff 0f 1f 00 0f 1f 44 00 00 48 c7 47 08 00 00 00
> [  203.909218] RSP: 0018:ffff9198801f8e70 EFLAGS: 00010282
> [  203.909266] RAX: 0000000000000000 RBX: ffff88b7b5100600 RCX: 0000000000000000
> [  203.909315] RDX: ffff88b7b6be1900 RSI: ffff88b7b6bd1aa8 RDI: 0000000000000300
> [  203.909365] RBP: ffff88b7b59a439c R08: ffff88b7b6bd1aa8 R09: 0000000000000004
> [  203.909414] R10: 0000000000000774 R11: 0000000000000000 R12: ffff88b7b59a43b8
> [  203.909463] R13: 0000000000000000 R14: ffff88b7b59a4000 R15: ffff88b7b5100680
> [  203.909513] FS:  0000000000000000(0000) GS:ffff88b7b6bc0000(0000) knlGS:0000000000000000
> [  203.909565] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  203.909612] CR2: 00007f7f2310d020 CR3: 0000000232fc4000 CR4: 00000000000406e0
> [  203.909673] Call Trace:
> [  203.909730]  <IRQ>
> [  203.909789]  ? qdisc_put_unlocked+0x30/0x30
> [  203.909850]  ? qdisc_put_unlocked+0x30/0x30
> [  203.909910]  call_timer_fn+0x32/0x170
> [  203.909969]  run_timer_softirq+0x195/0x4f0
> [  203.910029]  ? tick_sched_do_timer+0x60/0x60
> [  203.910088]  ? tick_sched_timer+0x45/0x90
> [  203.910147]  ? __hrtimer_run_queues+0x11c/0x2f0
> [  203.910209]  __do_softirq+0xe4/0x319
> [  203.910269]  irq_exit+0xa5/0xb0
> [  203.910327]  smp_apic_timer_interrupt+0x78/0x170
> [  203.910388]  apic_timer_interrupt+0xf/0x20
> [  203.911558]  </IRQ>
> [  203.911616] RIP: 0010:cpuidle_enter_state+0xbf/0x480
> [  203.911676] Code: 85 c0 0f 8f fe 02 00 00 31 ff e8 0c 4c b6 ff 45 84 f6 74 12 9c 58 f6 c4 02 0f 85 95 03 00 00 31 ff e8 95 96 bb ff fb 45 85 e4 <0f> 88 82 01 00 00 49 63 cc 4d 29 fd 48 8d 04 49 48 c1 e0 05 8b 74
> [  203.911781] RSP: 0018:ffff9198800bbe70 EFLAGS: 00000202 ORIG_RAX: ffffffffffffff13
> [  203.911845] RAX: ffff88b7b6be4080 RBX: ffffffffab09b460 RCX: 000000000000001f
> [  203.911907] RDX: 0000000000000000 RSI: 000000001fc92d00 RDI: 0000000000000000
> [  203.911969] RBP: ffff88b7b0103800 R08: 0000002f79e6984e R09: 00000000000f930c
> [  203.912031] R10: ffff88b7b6be31a0 R11: ffff88b7b6be3180 R12: 0000000000000002
> [  203.912093] R13: 0000002f79e6984e R14: 0000000000000000 R15: 0000002f740057dd
> [  203.912161]  cpuidle_enter+0x37/0x60
> [  203.912220]  do_idle+0x1ce/0x270
> [  203.912278]  cpu_startup_entry+0x19/0x20
> [  203.912337]  start_secondary+0x14d/0x180
> [  203.912397]  secondary_startup_64+0xa4/0xb0
> [  203.912457] ---[ end trace 1c807a8b2eb1f6b6 ]---
> 
> 

