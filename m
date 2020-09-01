Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E05EB2594AD
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 17:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgIAPmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 11:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731537AbgIAPmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 11:42:00 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06660C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 08:41:56 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id j11so712015plk.9
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 08:41:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=wuaMMv3U1dmDn7ze4U8yCVho6TKskZioiNYtaVMhgJw=;
        b=gwftFzjYsWd2TJDxERFgjglz6DezkKRMdrZgbdFMXlrwjoTGvQOQZYLgrXS0DQnZT4
         vzsCq/PTgNKP+J2oFzbyXSs/8PE0/7Ja7sWt4CS4FHLfRZl0gHVGFEWEJfsw/SRqtIpq
         MxhJ1gMog/q6g799Elk36lDNTMbUjsXEO/NPUQ8vTa9ILaBLF2y7k0RKmgDK8qRuQN4W
         oVS4HWoVepPOZwsQXrCUOmblFeVjwXKRITAlbSkREMHDKonVh3WNzawTaWV+7zFOstjE
         rytpR6EBu6l3LX6OUv4svIfjy12pnKzhZijce8Gb3m7Ccr3ID0mNQuQ9NBEaG2UXYsSo
         580g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=wuaMMv3U1dmDn7ze4U8yCVho6TKskZioiNYtaVMhgJw=;
        b=gXfYDbsUDqLAu+k1h5lQo0JAMwA9ivIggXQEh62e5kG8uNBvJjnme5Joqk6WvmKJbQ
         Tr9780gskEHGTbD/Ak66tuBvIrpHl2tmJ2na17Q9yfjpfVuFb405ZtR3B/VAb3n/80Wa
         zSGmWYz3fgEb1Kgjyin/SKnFXAlLzYXnuwGtLyWdO5inVuhtSmwA1fhyUraYDTbMYAAh
         t1wtOLuzxfBJyODXWw/VifCrTSmKDgXdXxqNEG+dNpBqrA7Zjd6AjI76O+WHDAVjiD8g
         bXylyngpOKQN6MKBK2rhQiMDWQojn2EHZ8jDB6lGmSEDP4ifZphO5/PXjSVb8WfYi/+d
         Wc5w==
X-Gm-Message-State: AOAM530s39twFm6G8y4xlzQt+o+3lIGuJtDEW83v9/2PYLrk0QDFdqTh
        DoSSmnZo5XfXAUNBlDWfejxN6Q==
X-Google-Smtp-Source: ABdhPJz90b7IPoq3LfmI4WMVpf4gguyfvXQQrlB7ki8o+JhyCkOkZ1jdp1zlgjxhiOsf7qCO/KoyfA==
X-Received: by 2002:a17:902:b7c8:: with SMTP id v8mr1922219plz.87.1598974915423;
        Tue, 01 Sep 2020 08:41:55 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q9sm2411984pfs.42.2020.09.01.08.41.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 08:41:55 -0700 (PDT)
Date:   Tue, 1 Sep 2020 08:41:47 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     swsd@realtek.com, hkallweit1@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Fw: [Bug 209103] New: Sporadic r8169 0000:03:00.0 enp3s0:
 rtl_txcfg_empty_cond == 0 (loop: 666, delay: 100)
Message-ID: <20200901084147.6464a22c@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Tue, 01 Sep 2020 11:14:24 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 209103] New: Sporadic r8169 0000:03:00.0 enp3s0: rtl_txcfg_empty_cond == 0 (loop: 666, delay: 100)


https://bugzilla.kernel.org/show_bug.cgi?id=209103

            Bug ID: 209103
           Summary: Sporadic r8169 0000:03:00.0 enp3s0:
                    rtl_txcfg_empty_cond == 0 (loop: 666, delay: 100)
           Product: Networking
           Version: 2.5
    Kernel Version: 5.4.0-42
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: malekpatryk@gmail.com
        Regression: No

Rarely (every couple of days) I get this in dmesg:

[pon sie 31 16:38:20 2020] ------------[ cut here ]------------
[pon sie 31 16:38:20 2020] NETDEV WATCHDOG: enp3s0 (r8169): transmit queue 0
timed out
[pon sie 31 16:38:20 2020] WARNING: CPU: 6 PID: 0 at
/build/linux-hwe-5.4-huXhHV/linux-hwe-5.4-5.4.0/net/sched/sch_generic.c:448
dev_watchdog+0x264/0x270
[pon sie 31 16:38:20 2020] Modules linked in: xt_nat xt_tcpudp veth
xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink xfrm_user xfrm_algo
xt_addrtype iptable_filter iptable_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 libcrc32c br_netfilter bridge stp llc aufs overlay binfmt_misc
nvidia_uvm(OE) intel_rapl_msr mei_hdcp intel_rapl_common x86_pkg_temp_thermal
intel_powerclamp kvm_intel kvm nvidia_drm(POE) nvidia_modeset(POE)
snd_hda_codec_hdmi crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel nvidia(POE) crypto_simd cryptd snd_soc_rt5640 glue_helper
snd_hda_codec_realtek snd_soc_rl6231 intel_cstate snd_hda_codec_generic
snd_soc_core intel_rapl_perf ledtrig_audio snd_compress ac97_bus
snd_pcm_dmaengine snd_seq_midi drm_kms_helper snd_seq_midi_event snd_hda_intel
snd_intel_dspcfg snd_hda_codec snd_rawmidi drm snd_hda_core snd_seq snd_hwdep
snd_pcm fb_sys_fops syscopyarea mei_me sysfillrect snd_seq_device input_leds
sysimgblt mei ie31200_edac lpc_ich snd_timer snd soundcore mac_hid
[pon sie 31 16:38:20 2020]  acpi_pad sch_fq_codel it87 hwmon_vid coretemp
parport_pc ppdev lp parport bfq ip_tables x_tables autofs4 hid_logitech_hidpp
hid_logitech_dj hid_generic ahci usbhid libahci r8169 hid realtek video
[pon sie 31 16:38:20 2020] CPU: 6 PID: 0 Comm: swapper/6 Tainted: P          
OE     5.4.0-42-generic #46~18.04.1-Ubuntu
[pon sie 31 16:38:20 2020] Hardware name: Gigabyte Technology Co., Ltd.
Z97M-DS3H/Z97M-DS3H, BIOS F5 06/03/2014
[pon sie 31 16:38:20 2020] RIP: 0010:dev_watchdog+0x264/0x270
[pon sie 31 16:38:20 2020] Code: 48 85 c0 75 e6 eb a0 4c 89 ef c6 05 52 06 e8
00 01 e8 f0 bc fa ff 89 d9 48 89 c2 4c 89 ee 48 c7 c7 08 f4 c2 b2 e8 4c 78 71
ff <0f> 0b eb 82 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41
[pon sie 31 16:38:20 2020] RSP: 0018:ffffbc3400210e48 EFLAGS: 00010282
[pon sie 31 16:38:20 2020] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000006
[pon sie 31 16:38:20 2020] RDX: 0000000000000007 RSI: 0000000000000096 RDI:
ffff93e00eb978c0
[pon sie 31 16:38:20 2020] RBP: ffffbc3400210e78 R08: 00000000000005bd R09:
0000000000000004
[pon sie 31 16:38:20 2020] R10: ffffbc3400210ee0 R11: 0000000000000001 R12:
0000000000000001
[pon sie 31 16:38:20 2020] R13: ffff93e003a44000 R14: ffff93e003a44480 R15:
ffff93e0039e1a80
[pon sie 31 16:38:20 2020] FS:  0000000000000000(0000)
GS:ffff93e00eb80000(0000) knlGS:0000000000000000
[pon sie 31 16:38:20 2020] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[pon sie 31 16:38:20 2020] CR2: 00007ffe43660000 CR3: 00000003c120a001 CR4:
00000000001606e0
[pon sie 31 16:38:20 2020] Call Trace:
[pon sie 31 16:38:20 2020]  <IRQ>
[pon sie 31 16:38:20 2020]  ? pfifo_fast_reset+0x110/0x110
[pon sie 31 16:38:20 2020]  call_timer_fn+0x32/0x130
[pon sie 31 16:38:20 2020]  run_timer_softirq+0x443/0x480
[pon sie 31 16:38:20 2020]  ? ktime_get+0x43/0xa0
[pon sie 31 16:38:20 2020]  ? lapic_next_deadline+0x26/0x30
[pon sie 31 16:38:20 2020]  __do_softirq+0xe4/0x2da
[pon sie 31 16:38:20 2020]  irq_exit+0xae/0xb0
[pon sie 31 16:38:20 2020]  smp_apic_timer_interrupt+0x79/0x130
[pon sie 31 16:38:20 2020]  apic_timer_interrupt+0xf/0x20
[pon sie 31 16:38:20 2020]  </IRQ>
[pon sie 31 16:38:20 2020] RIP: 0010:cpuidle_enter_state+0xbc/0x440
[pon sie 31 16:38:20 2020] Code: ff e8 f8 26 81 ff 80 7d d3 00 74 17 9c 58 0f
1f 44 00 00 f6 c4 02 0f 85 54 03 00 00 31 ff e8 ab a2 87 ff fb 66 0f 1f 44 00
00 <45> 85 ed 0f 88 1a 03 00 00 4c 2b 7d c8 48 ba cf f7 53 e3 a5 9b c4
[pon sie 31 16:38:20 2020] RSP: 0018:ffffbc34000c7e48 EFLAGS: 00000246
ORIG_RAX: ffffffffffffff13
[pon sie 31 16:38:20 2020] RAX: ffff93e00ebaad00 RBX: ffffffffb2f579c0 RCX:
000000000000001f
[pon sie 31 16:38:20 2020] RDX: 0000e5b2d94d8703 RSI: 0000000025a5a7d3 RDI:
0000000000000000
[pon sie 31 16:38:20 2020] RBP: ffffbc34000c7e88 R08: 0000000000000002 R09:
000000000002a580
[pon sie 31 16:38:20 2020] R10: ffffbc34000c7e18 R11: 000000000000b225 R12:
ffff93e00ebb5500
[pon sie 31 16:38:20 2020] R13: 0000000000000005 R14: ffffffffb2f57bb8 R15:
0000e5b2d94d8703
[pon sie 31 16:38:20 2020]  ? cpuidle_enter_state+0x98/0x440
[pon sie 31 16:38:20 2020]  ? menu_select+0x377/0x600
[pon sie 31 16:38:20 2020]  cpuidle_enter+0x2e/0x40
[pon sie 31 16:38:20 2020]  call_cpuidle+0x23/0x40
[pon sie 31 16:38:20 2020]  do_idle+0x1f6/0x270
[pon sie 31 16:38:20 2020]  cpu_startup_entry+0x1d/0x20
[pon sie 31 16:38:20 2020]  start_secondary+0x166/0x1c0
[pon sie 31 16:38:20 2020]  secondary_startup_64+0xa4/0xb0
[pon sie 31 16:38:20 2020] ---[ end trace 63c98c8ec420a2c1 ]---
[pon sie 31 16:38:20 2020] r8169 0000:03:00.0 enp3s0: rtl_txcfg_empty_cond == 0
(loop: 666, delay: 100).
[pon sie 31 17:40:49 2020] perf: interrupt took too long (6168 > 6166),
lowering kernel.perf_event_max_sample_rate to 32250

NIC seems to be working fine but it's a bit annoying and worrying.

modinfo r8169
modinfo r8169
filename:      
/lib/modules/5.4.0-42-generic/kernel/drivers/net/ethernet/realtek/r8169.ko
firmware:       rtl_nic/rtl8125a-3.fw
firmware:       rtl_nic/rtl8107e-2.fw
firmware:       rtl_nic/rtl8107e-1.fw
firmware:       rtl_nic/rtl8168h-2.fw
firmware:       rtl_nic/rtl8168h-1.fw
firmware:       rtl_nic/rtl8168g-3.fw
firmware:       rtl_nic/rtl8168g-2.fw
firmware:       rtl_nic/rtl8106e-2.fw
firmware:       rtl_nic/rtl8106e-1.fw
firmware:       rtl_nic/rtl8411-2.fw
firmware:       rtl_nic/rtl8411-1.fw
firmware:       rtl_nic/rtl8402-1.fw
firmware:       rtl_nic/rtl8168f-2.fw
firmware:       rtl_nic/rtl8168f-1.fw
firmware:       rtl_nic/rtl8105e-1.fw
firmware:       rtl_nic/rtl8168e-3.fw
firmware:       rtl_nic/rtl8168e-2.fw
firmware:       rtl_nic/rtl8168e-1.fw
firmware:       rtl_nic/rtl8168d-2.fw
firmware:       rtl_nic/rtl8168d-1.fw
license:        GPL
softdep:        pre: realtek
description:    RealTek RTL-8169 Gigabit Ethernet driver
author:         Realtek and the Linux r8169 crew <netdev@vger.kernel.org>
srcversion:     45049AB10197DBC356B2C41
alias:          pci:v000010ECd00003000sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008125sv*sd*bc*sc*i*
alias:          pci:v00000001d00008168sv*sd00002410bc*sc*i*
alias:          pci:v00001737d00001032sv*sd00000024bc*sc*i*
alias:          pci:v000016ECd00000116sv*sd*bc*sc*i*
alias:          pci:v00001259d0000C107sv*sd*bc*sc*i*
alias:          pci:v00001186d00004302sv*sd*bc*sc*i*
alias:          pci:v00001186d00004300sv*sd*bc*sc*i*
alias:          pci:v00001186d00004300sv00001186sd00004B10bc*sc*i*
alias:          pci:v000010ECd00008169sv*sd*bc*sc*i*
alias:          pci:v000010FFd00008168sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008168sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008167sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008161sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008136sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008129sv*sd*bc*sc*i*
alias:          pci:v000010ECd00002600sv*sd*bc*sc*i*
alias:          pci:v000010ECd00002502sv*sd*bc*sc*i*
depends:
retpoline:      Y
intree:         Y
name:           r8169
vermagic:       5.4.0-42-generic SMP mod_unload
signat:         PKCS#7
signer:
sig_key:
sig_hashalgo:   md4
parm:           debug:Debug verbosity level (0=none, ..., 16=all) (int)


ethtool -i enp3s0
driver: r8169
version:
firmware-version: rtl8168e-3_0.0.4 03/27/12
expansion-rom-version:
bus-info: 0000:03:00.0
supports-statistics: yes
supports-test: no
supports-eeprom-access: no
supports-register-dump: yes
supports-priv-flags: no

-- 
You are receiving this mail because:
You are the assignee for the bug.
