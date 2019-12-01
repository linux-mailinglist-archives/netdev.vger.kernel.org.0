Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6164F10E154
	for <lists+netdev@lfdr.de>; Sun,  1 Dec 2019 10:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfLAJxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Dec 2019 04:53:02 -0500
Received: from mail.itouring.de ([188.40.134.68]:42544 "EHLO mail.itouring.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726498AbfLAJxC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 1 Dec 2019 04:53:02 -0500
Received: from tux.applied-asynchrony.com (p5B07E981.dip0.t-ipconnect.de [91.7.233.129])
        by mail.itouring.de (Postfix) with ESMTPSA id 486104160628;
        Sun,  1 Dec 2019 10:52:59 +0100 (CET)
Received: from [192.168.100.223] (ragnarok.applied-asynchrony.com [192.168.100.223])
        by tux.applied-asynchrony.com (Postfix) with ESMTP id A47C4F015C3;
        Sun,  1 Dec 2019 10:52:58 +0100 (CET)
Subject: Re: 5.4.1 WARNINGs with r8169
To:     Udo van den Heuvel <udovdh@xs4all.nl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <46e7dcf9-3c89-25c1-ccb8-336450047bec@xs4all.nl>
From:   =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <aa3b11a5-eb7e-dc2c-e5b4-96e53942246d@applied-asynchrony.com>
Date:   Sun, 1 Dec 2019 10:52:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <46e7dcf9-3c89-25c1-ccb8-336450047bec@xs4all.nl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(cc:'ing netdev & Heiner)

Are you using Jumbo packets? If so please check the thread at
https://lore.kernel.org/lkml/24034.56114.248207.524177@wylie.me.uk/

Btw you should use a more descriptive Subject line, otherwise people might
miss your message..

-h

-------- Forwarded Message --------
Subject: 5.4.1 WARNINGs
Date: Sun, 1 Dec 2019 08:06:37 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
Organization: hierzo
To: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>
Newsgroups: gmane.linux.kernel

Hello,

While booting into 5.4.1 I noticed these.
Any advice please?


Dec  1 07:59:28 vuurmuur named[1318]: resolver priming query complete
Dec  1 07:59:34 vuurmuur kernel: ------------[ cut here ]------------
Dec  1 07:59:34 vuurmuur kernel: NETDEV WATCHDOG: eth0 (r8169): transmit
queue 0 timed out
Dec  1 07:59:34 vuurmuur kernel: WARNING: CPU: 0 PID: 9 at
net/sched/sch_generic.c:447 dev_watchdog+0x208/0x210
Dec  1 07:59:34 vuurmuur kernel: Modules linked in: act_police
sch_ingress cls_u32 sch_sfq sch_cbq pppoe pppox ip6table_raw nf_log_ipv6
ip6table_mangle xt_u32 xt_CT xt_nat nf_log_ipv4 nf_log_common
xt_statistic nf_nat_sip nf_conntrack_sip xt_recent xt_string xt_lscan(O)
xt_TARPIT(O) iptable_raw nf_nat_h323 nf_conntrack_h323 xt_TCPMSS
xt_length xt_hl xt_tcpmss xt_owner xt_mac xt_mark xt_multiport xt_limit
nf_nat_irc nf_conntrack_irc xt_LOG xt_DSCP xt_REDIRECT xt_MASQUERADE
xt_dscp nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat
mq_deadline 8021q ipt_REJECT nf_reject_ipv4 iptable_filter ip6t_REJECT
nf_reject_ipv6 xt_state xt_conntrack ip6table_filter nct6775 ip6_tables
sunrpc amdgpu mfd_core gpu_sched drm_kms_helper syscopyarea sysfillrect
sysimgblt fb_sys_fops ttm snd_hda_codec_realtek snd_hda_codec_generic
drm snd_hda_codec_hdmi snd_hda_intel drm_panel_orientation_quirks
cfbfillrect snd_intel_nhlt amd_freq_sensitivity cfbimgblt snd_hda_codec
aesni_intel cfbcopyarea i2c_algo_bit fb glue_helper
Dec  1 07:59:34 vuurmuur kernel: snd_hda_core crypto_simd fbdev snd_pcm
cryptd pl2303 backlight snd_timer snd i2c_piix4 acpi_cpufreq sr_mod
cdrom sd_mod autofs4
Dec  1 07:59:34 vuurmuur kernel: CPU: 0 PID: 9 Comm: ksoftirqd/0
Tainted: G           O      5.4.1 #2
Dec  1 07:59:34 vuurmuur kernel: Hardware name: To Be Filled By O.E.M.
To Be Filled By O.E.M./QC5000M-ITX/PH, BIOS P1.10 05/06/2015
Dec  1 07:59:34 vuurmuur kernel: RIP: 0010:dev_watchdog+0x208/0x210
Dec  1 07:59:34 vuurmuur kernel: Code: 63 54 24 e0 eb 8d 4c 89 f7 c6 05
fc a0 b9 00 01 e8 6d fa fc ff 44 89 e9 48 89 c2 4c 89 f6 48 c7 c7 48 79
dd 81 e8 98 5a b5 ff <0f> 0b eb bd 0f 1f 40 00 48 c7 47 08 00 00 00 00
48 c7 07 00 00 00
Dec  1 07:59:34 vuurmuur kernel: RSP: 0018:ffffc9000006fd68 EFLAGS: 00010286
Dec  1 07:59:34 vuurmuur kernel: RAX: 0000000000000000 RBX:
ffff88813a1d6400 RCX: 0000000000000006
Dec  1 07:59:34 vuurmuur kernel: RDX: 0000000000000007 RSI:
ffffffff8203aa58 RDI: ffff88813b216250
Dec  1 07:59:34 vuurmuur kernel: RBP: ffff8881394ee460 R08:
0000000000080001 R09: 0000000000000002
Dec  1 07:59:34 vuurmuur kernel: R10: 0000000000000001 R11:
0000000000000001 R12: ffff8881394ee4b8
Dec  1 07:59:34 vuurmuur kernel: R13: 0000000000000000 R14:
ffff8881394ee000 R15: ffff88813a1d6480
Dec  1 07:59:34 vuurmuur kernel: FS:  0000000000000000(0000)
GS:ffff88813b200000(0000) knlGS:0000000000000000
Dec  1 07:59:34 vuurmuur kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Dec  1 07:59:34 vuurmuur kernel: CR2: 00007f09b9c20a78 CR3:
00000001385d4000 CR4: 00000000000406b0
Dec  1 07:59:34 vuurmuur kernel: Call Trace:
Dec  1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
Dec  1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
Dec  1 07:59:34 vuurmuur kernel: call_timer_fn.isra.0+0x78/0x110
Dec  1 07:59:34 vuurmuur kernel: ? add_timer_on+0xd0/0xd0
Dec  1 07:59:34 vuurmuur kernel: run_timer_softirq+0x19d/0x1c0
Dec  1 07:59:34 vuurmuur kernel: ? _raw_spin_unlock_irq+0x1f/0x40
Dec  1 07:59:34 vuurmuur kernel: ? finish_task_switch+0xb2/0x250
Dec  1 07:59:34 vuurmuur kernel: ? finish_task_switch+0x81/0x250
Dec  1 07:59:34 vuurmuur kernel: __do_softirq+0xcf/0x210
Dec  1 07:59:34 vuurmuur kernel: run_ksoftirqd+0x15/0x20
Dec  1 07:59:34 vuurmuur kernel: smpboot_thread_fn+0xe9/0x1f0
Dec  1 07:59:34 vuurmuur kernel: kthread+0xf1/0x130
Dec  1 07:59:34 vuurmuur kernel: ? sort_range+0x20/0x20
Dec  1 07:59:34 vuurmuur kernel: ? kthread_park+0x80/0x80
Dec  1 07:59:34 vuurmuur kernel: ret_from_fork+0x22/0x40
Dec  1 07:59:34 vuurmuur kernel: ---[ end trace e771bca3c459d7f9 ]---
Dec  1 07:59:34 vuurmuur kernel: ------------[ cut here ]------------
Dec  1 07:59:34 vuurmuur kernel: WARNING: CPU: 0 PID: 9 at
net/sched/sch_generic.c:447 dev_watchdog+0x208/0x210
Dec  1 07:59:34 vuurmuur kernel: Modules linked in: act_police
sch_ingress cls_u32 sch_sfq sch_cbq pppoe pppox ip6table_raw nf_log_ipv6
ip6table_mangle xt_u32 xt_CT xt_nat nf_log_ipv4 nf_log_common
xt_statistic nf_nat_sip nf_conntrack_sip xt_recent xt_string xt_lscan(O)
xt_TARPIT(O) iptable_raw nf_nat_h323 nf_conntrack_h323 xt_TCPMSS
xt_length xt_hl xt_tcpmss xt_owner xt_mac xt_mark xt_multiport xt_limit
nf_nat_irc nf_conntrack_irc xt_LOG xt_DSCP xt_REDIRECT xt_MASQUERADE
xt_dscp nf_nat_ftp nf_conntrack_ftp iptable_mangle iptable_nat
mq_deadline 8021q ipt_REJECT nf_reject_ipv4 iptable_filter ip6t_REJECT
nf_reject_ipv6 xt_state xt_conntrack ip6table_filter nct6775 ip6_tables
sunrpc amdgpu mfd_core gpu_sched drm_kms_helper syscopyarea sysfillrect
sysimgblt fb_sys_fops ttm snd_hda_codec_realtek snd_hda_codec_generic
drm snd_hda_codec_hdmi snd_hda_intel drm_panel_orientation_quirks
cfbfillrect snd_intel_nhlt amd_freq_sensitivity cfbimgblt snd_hda_codec
aesni_intel cfbcopyarea i2c_algo_bit fb glue_helper
Dec  1 07:59:34 vuurmuur kernel: snd_hda_core crypto_simd fbdev snd_pcm
cryptd pl2303 backlight snd_timer snd i2c_piix4 acpi_cpufreq sr_mod
cdrom sd_mod autofs4
Dec  1 07:59:34 vuurmuur kernel: CPU: 0 PID: 9 Comm: ksoftirqd/0
Tainted: G           O      5.4.1 #2
Dec  1 07:59:34 vuurmuur kernel: Hardware name: To Be Filled By O.E.M.
To Be Filled By O.E.M./QC5000M-ITX/PH, BIOS P1.10 05/06/2015
Dec  1 07:59:34 vuurmuur kernel: RIP: 0010:dev_watchdog+0x208/0x210
Dec  1 07:59:34 vuurmuur kernel: Code: 63 54 24 e0 eb 8d 4c 89 f7 c6 05
fc a0 b9 00 01 e8 6d fa fc ff 44 89 e9 48 89 c2 4c 89 f6 48 c7 c7 48 79
dd 81 e8 98 5a b5 ff <0f> 0b eb bd 0f 1f 40 00 48 c7 47 08 00 00 00 00
48 c7 07 00 00 00
Dec  1 07:59:34 vuurmuur kernel: RSP: 0018:ffffc9000006fd68 EFLAGS: 00010286
Dec  1 07:59:34 vuurmuur kernel: RAX: 0000000000000000 RBX:
ffff88813a1d6400 RCX: 0000000000000006
Dec  1 07:59:34 vuurmuur kernel: RDX: 0000000000000007 RSI:
ffffffff8203aa58 RDI: ffff88813b216250
Dec  1 07:59:34 vuurmuur kernel: RBP: ffff8881394ee460 R08:
0000000000080001 R09: 0000000000000002
Dec  1 07:59:34 vuurmuur kernel: R10: 0000000000000001 R11:
0000000000000001 R12: ffff8881394ee4b8
Dec  1 07:59:34 vuurmuur kernel: R13: 0000000000000000 R14:
ffff8881394ee000 R15: ffff88813a1d6480
Dec  1 07:59:34 vuurmuur kernel: FS:  0000000000000000(0000)
GS:ffff88813b200000(0000) knlGS:0000000000000000
Dec  1 07:59:34 vuurmuur kernel: CS:  0010 DS: 0000 ES: 0000 CR0:
0000000080050033
Dec  1 07:59:34 vuurmuur kernel: CR2: 00007f09b9c20a78 CR3:
00000001385d4000 CR4: 00000000000406b0
Dec  1 07:59:34 vuurmuur kernel: Call Trace:
Dec  1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
Dec  1 07:59:34 vuurmuur kernel: ? qdisc_put_unlocked+0x30/0x30
Dec  1 07:59:34 vuurmuur kernel: call_timer_fn.isra.0+0x78/0x110
Dec  1 07:59:34 vuurmuur kernel: ? add_timer_on+0xd0/0xd0
Dec  1 07:59:34 vuurmuur kernel: run_timer_softirq+0x19d/0x1c0
Dec  1 07:59:34 vuurmuur kernel: ? _raw_spin_unlock_irq+0x1f/0x40
Dec  1 07:59:34 vuurmuur kernel: ? finish_task_switch+0xb2/0x250
Dec  1 07:59:34 vuurmuur kernel: ? finish_task_switch+0x81/0x250
Dec  1 07:59:34 vuurmuur kernel: __do_softirq+0xcf/0x210
Dec  1 07:59:34 vuurmuur kernel: run_ksoftirqd+0x15/0x20
Dec  1 07:59:34 vuurmuur kernel: smpboot_thread_fn+0xe9/0x1f0
Dec  1 07:59:34 vuurmuur kernel: kthread+0xf1/0x130
Dec  1 07:59:34 vuurmuur kernel: ? sort_range+0x20/0x20
Dec  1 07:59:34 vuurmuur kernel: ? kthread_park+0x80/0x80
Dec  1 07:59:34 vuurmuur kernel: ret_from_fork+0x22/0x40
Dec  1 07:59:34 vuurmuur kernel: ---[ end trace e771bca3c459d7f9 ]---


Kind regards,
Udo
