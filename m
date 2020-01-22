Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF6B71452B3
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 11:35:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729130AbgAVKfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 05:35:31 -0500
Received: from mail.thelounge.net ([91.118.73.15]:36627 "EHLO
        mail.thelounge.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728931AbgAVKfb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 05:35:31 -0500
X-Greylist: delayed 1073 seconds by postgrey-1.27 at vger.kernel.org; Wed, 22 Jan 2020 05:35:31 EST
Received: from srv-rhsoft.rhsoft.net  (Authenticated sender: h.reindl@thelounge.net) by mail.thelounge.net (THELOUNGE MTA) with ESMTPSA id 482hDJ0lrlzXTK
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 11:17:36 +0100 (CET)
To:     network dev <netdev@vger.kernel.org>
From:   Reindl Harald <h.reindl@thelounge.net>
Subject: NETDEV WATCHDOG: lan-pci (r8169): transmit queue 0 timed out
Organization: the lounge interactive design
Message-ID: <1cc7a2e0-4697-c155-fe9c-1548ccdca504@thelounge.net>
Date:   Wed, 22 Jan 2020 11:17:35 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

this started with 5.4 and happens at least one time afetr reboot, the
machine cats as router and internal server

Jan 21 13:43:25 localhost kernel: ------------[ cut here ]------------
Jan 21 13:43:25 localhost kernel: NETDEV WATCHDOG: lan-pci (r8169):
transmit queue 0 timed out
Jan 21 13:43:25 localhost kernel: WARNING: CPU: 6 PID: 0 at
net/sched/sch_generic.c:447 dev_watchdog+0x248/0x250
Jan 21 13:43:25 localhost kernel: Modules linked in: tun cls_u32 sch_htb
bridge stp llc nfnetlink_log xt_NFLOG ipt_REJECT nf_reject_ipv4 xt_limit
xt_iprange xt_multiport iptable_filter xt_set xt_tcpmss xt_conntrack
iptable_mangle xt_MASQUERADE xt_nat iptable_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c iptable_raw ip_set_hash_net
ip_set_bitmap_port ip_set nfnetlink i915 intel_rapl_msr
intel_rapl_common video i2c_algo_bit drm_kms_helper x86_pkg_temp_thermal
drm r8169 intel_powerclamp i2c_i801 libarc4 wmi_bmof iTCO_wdt
iTCO_vendor_support gpio_ich e1000e coretemp lpc_ich intel_cstate
intel_uncore pcspkr intel_rapl_perf ip_tables raid1 crct10dif_pclmul
crc32_pclmul crc32c_intel ghash_clmulni_intel serio_raw wmi
Jan 21 13:43:25 localhost kernel: CPU: 6 PID: 0 Comm: swapper/6 Not
tainted 5.4.12-100.fc30.x86_64 #1
Jan 21 13:43:25 localhost kernel: Hardware name: Hewlett-Packard HP
Compaq 8200 Elite CMT PC/1494, BIOS J01 v02.15 11/10/2011
Jan 21 13:43:25 localhost kernel: RIP: 0010:dev_watchdog+0x248/0x250
Jan 21 13:43:25 localhost kernel: Code: 85 c0 75 e5 eb 9f 4c 89 ef c6 05
0d 7b f2 00 01 e8 4d e8 fa ff 44 89 e1 4c 89 ee 48 c7 c7 d0 70 40 9e 48
89 c2 e8 76 4b 81 ff <0f> 0b eb 80 0f 1f 40 00 66 66 66 66 90 41 57 41
56 49 89 d6 41 55
Jan 21 13:43:25 localhost kernel: RSP: 0018:ffffb20c401c0e60 EFLAGS:
00010286
Jan 21 13:43:25 localhost kernel: RAX: 0000000000000000 RBX:
ffff8f71dd775600 RCX: 0000000000000000
Jan 21 13:43:25 localhost kernel: RDX: ffff8f71e61a57c0 RSI:
ffff8f71e6197908 RDI: 0000000000000300
Jan 21 13:43:25 localhost kernel: RBP: ffff8f71e1f9245c R08:
ffff8f71e6197908 R09: 0000000000000003
Jan 21 13:43:25 localhost kernel: R10: 0000000000000000 R11:
0000000000000001 R12: 0000000000000000
Jan 21 13:43:25 localhost kernel: R13: ffff8f71e1f92000 R14:
ffff8f71e1f92480 R15: 0000000000000001
Jan 21 13:43:25 localhost kernel: FS:  0000000000000000(0000)
GS:ffff8f71e6180000(0000) knlGS:0000000000000000
Jan 21 13:43:25 localhost kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Jan 21 13:43:25 localhost kernel: CR2: 00007fe61d76a000 CR3:
00000000a860a005 CR4: 00000000000606e0
Jan 21 13:43:25 localhost kernel: Call Trace:
Jan 21 13:43:25 localhost kernel: <IRQ>
Jan 21 13:43:25 localhost kernel: ? pfifo_fast_enqueue+0x150/0x150
Jan 21 13:43:25 localhost kernel: call_timer_fn+0x2d/0x130
Jan 21 13:43:25 localhost kernel: __run_timers.part.0+0x16f/0x260
Jan 21 13:43:25 localhost kernel: ? tick_sched_handle+0x22/0x60
Jan 21 13:43:25 localhost kernel: ? tick_sched_timer+0x38/0x80
Jan 21 13:43:25 localhost kernel: ? tick_sched_do_timer+0x60/0x60
Jan 21 13:43:25 localhost kernel: run_timer_softirq+0x26/0x50
Jan 21 13:43:25 localhost kernel: __do_softirq+0xee/0x2ff
Jan 21 13:43:25 localhost kernel: irq_exit+0xe9/0xf0
Jan 21 13:43:25 localhost kernel: smp_apic_timer_interrupt+0x76/0x130
Jan 21 13:43:25 localhost kernel: apic_timer_interrupt+0xf/0x20
Jan 21 13:43:25 localhost kernel: </IRQ>
Jan 21 13:43:25 localhost kernel: RIP: 0010:cpuidle_enter_state+0xc1/0x450
Jan 21 13:43:25 localhost kernel: Code: 90 31 ff e8 51 6b 90 ff 80 7c 24
0f 00 74 17 9c 58 66 66 90 66 90 f6 c4 02 0f 85 61 03 00 00 31 ff e8 93
a3 96 ff fb 66 66 90 <66> 66 90 45 85 e4 0f 88 8c 02 00 00 49 63 cc 4c
2b 6c 24 10 48 8d
Jan 21 13:43:25 localhost kernel: RSP: 0018:ffffb20c400abe68 EFLAGS:
00000246 ORIG_RAX: ffffffffffffff13
Jan 21 13:43:25 localhost kernel: RAX: ffff8f71e61a89c0 RBX:
ffffffff9e74a480 RCX: 000000000000001f
Jan 21 13:43:25 localhost kernel: RDX: 0000000000000000 RSI:
0000000025bb8b00 RDI: 0000000000000000
Jan 21 13:43:25 localhost kernel: RBP: ffff8f71e61b2f00 R08:
000016eebbe8fa2b R09: 000000000000abc0
Jan 21 13:43:25 localhost kernel: R10: ffff8f71e61a77a0 R11:
ffff8f71e61a7780 R12: 0000000000000004
Jan 21 13:43:25 localhost kernel: R13: 000016eebbe8fa2b R14:
0000000000000004 R15: ffff8f71e5290000
Jan 21 13:43:25 localhost kernel: ? cpuidle_enter_state+0x9f/0x450
Jan 21 13:43:25 localhost kernel: cpuidle_enter+0x29/0x40
Jan 21 13:43:25 localhost kernel: do_idle+0x1dc/0x270
Jan 21 13:43:25 localhost kernel: cpu_startup_entry+0x19/0x20
Jan 21 13:43:25 localhost kernel: start_secondary+0x162/0x1b0
Jan 21 13:43:25 localhost kernel: secondary_startup_64+0xb6/0xc0
Jan 21 13:43:25 localhost kernel: ---[ end trace efed542e1b43685e ]---
