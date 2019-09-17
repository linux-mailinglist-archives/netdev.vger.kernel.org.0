Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E16B4735
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 08:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404008AbfIQGJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 02:09:47 -0400
Received: from mail-wm1-f43.google.com ([209.85.128.43]:37464 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726511AbfIQGJr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 02:09:47 -0400
Received: by mail-wm1-f43.google.com with SMTP id r195so1583537wme.2
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 23:09:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ILMAFXza4BsChYRK7gpSq3+XazVb5RDFtNh/LX0hwiI=;
        b=Yrl1EfqXqyLJCn+83x1PFEUoFhKwFNhQjvYjuHuUEPT5tg8o8tQ1Sj76YAdfXb2fgL
         DXqnUHwrWFr0AoX1c50tdy1lRnfOJQIkZUGWPFxDP2LT7yWUAP0o1W7Jt8yJ7gJkKRO5
         mjITeqd9E3+D42DJQzuXUHhD4QsTHWXdGLockvy6ITF0220aglvkRN4eom4eHBjxSGfX
         DeXW6jSZ09Q9cNo14gKldVm15pvdvpElhU9N6DugdEYkKd7S8MnEjW6z8xldGYCwBZJk
         9Czfc43Ac2n2TFVN1v5/juVLvcKFKt93tRNfWn6BfdVr6V1eyRFA3faFiUXh4GFgmWym
         EpQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=ILMAFXza4BsChYRK7gpSq3+XazVb5RDFtNh/LX0hwiI=;
        b=h6m7k11nYpVxrKg6WvOnPoZCv+PdixD+9Bb/ppXRofSKciY3KU99WX9uW6ooaMvwjO
         J1NA1/AngPd6qDbp0sEde9gSEOHsnqIfKCb3wXLE61GBU1BkSMgbFDG/lH/C/ziINx2v
         AT4fHG9PEQhVO98qoe2FRpIi+KLPb0ORJCT4lgTiCN+ye9VM0llhsSngyAWTG4VaW3y+
         VaSE981xCpHELwbcuOA1Zl63CcbkFUgvaF7p7m1L7SXkoxyN6N4MjFIpO+IwAK7+YxUW
         qlyYip8YFfkRXTpmeSsA/pmokMA186t6TZCARPJKYZ5q7AJdFFaUFeYhBm6Jg03unQjd
         rLLg==
X-Gm-Message-State: APjAAAXlHt2wYam5qLFG0oH8MRdWWNYID4GQJ2KwaH2xxUDkKzYJRSkB
        s+caDFCal8EFFzrh2g1NEAuVp4omYS9PQQ==
X-Google-Smtp-Source: APXvYqwnc0xhQrots0T7/JliedPm0DBl//hwIU8LEGrIGEGAbxmZt4lcda9YWarShMwAachHZv4c2w==
X-Received: by 2002:a1c:7513:: with SMTP id o19mr1882200wmc.126.1568700583599;
        Mon, 16 Sep 2019 23:09:43 -0700 (PDT)
Received: from xps13.home (2a01cb088723c800c05c811fc99ddf73.ipv6.abo.wanadoo.fr. [2a01:cb08:8723:c800:c05c:811f:c99d:df73])
        by smtp.gmail.com with ESMTPSA id y186sm2251653wmb.41.2019.09.16.23.09.42
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 16 Sep 2019 23:09:43 -0700 (PDT)
Date:   Tue, 17 Sep 2019 08:09:39 +0200
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 204879] New: "invalid inflight", WARNING: CPU: 1 PID: 5103
 at net/ipv4/tcp_output.c:2509 tcp_send_loss_probe.cold.42+0x20/0x2d
Message-ID: <20190917080939.0ba7e89b@xps13.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Mon, 16 Sep 2019 20:28:15 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 204879] New: "invalid inflight", WARNING: CPU: 1 PID: 5103 at net/ipv4/tcp_output.c:2509 tcp_send_loss_probe.cold.42+0x20/0x2d


https://bugzilla.kernel.org/show_bug.cgi?id=204879

            Bug ID: 204879
           Summary: "invalid inflight", WARNING: CPU: 1 PID: 5103 at
                    net/ipv4/tcp_output.c:2509
                    tcp_send_loss_probe.cold.42+0x20/0x2d
           Product: Networking
           Version: 2.5
    Kernel Version: 4.14.143
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: rm+bko@romanrm.net
        Regression: No

After upgrading my kernel version from 4.14.121 to 4.14.143, on every boot I
now get the following warning.

Moreover, eventually (in a few hours) the server appears to lock-up. However I
can't say for sure if the lock-up is related, or what messages appear during
that time, as this is a remote system with no IPMI or the like. There's nothing
in disk-based logs. I'll try netconsole later if this continues to repeat.

For now, any ideas about this particular backtrace? Thanks

[   35.587989] invalid inflight: 1 state 1 cwnd 14 mss 1428
[   35.588004] ------------[ cut here ]------------
[   35.588009] WARNING: CPU: 1 PID: 5103 at net/ipv4/tcp_output.c:2509
tcp_send_loss_probe.cold.42+0x20/0x2d
[   35.588011] Modules linked in: wireguard ip6_udp_tunnel udp_tunnel
xt_comment xt_u32 xt_connlimit ip6t_MASQUERADE nf_nat_masquerade_ipv6 xt_TCPMSS
xt_nat xt_mark ipt_MASQUERADE nf_nat_masquerade_ipv4 xt_tcpudp xt_set
ip_set_hash_net ip_set nfnetlink xt_multiport xt_limit xt_length xt_conntrack
ip6t_rpfilter ipt_rpfilter ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
nf_nat_ipv6 ip6table_raw ip6table_mangle iptable_nat nf_conntrack_ipv4
nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_raw iptable_mangle
ip6table_filter ip6_tables iptable_filter ip_tables x_tables
cpufreq_conservative cpufreq_powersave cpufreq_userspace tcp_bbr sch_fq
tcp_illinois intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp
kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc
aesni_intel
[   35.588042]  aes_x86_64 crypto_simd glue_helper cryptd snd_hda_codec_hdmi
intel_cstate snd_hda_codec_realtek snd_hda_codec_generic intel_uncore
snd_hda_intel i915 video iTCO_wdt intel_rapl_perf iTCO_vendor_support
snd_hda_codec drm_kms_helper evdev snd_hda_core pcspkr snd_hwdep snd_pcm
snd_timer pcc_cpufreq mei_me mei drm sg snd shpchp lpc_ich button i2c_algo_bit
serio_raw mfd_core soundcore ext4 crc16 mbcache jbd2 fscrypto btrfs
zstd_decompress zstd_compress xxhash sata_nv dm_crypt raid456 async_raid6_recov
async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic
raid0 raid1 md_mod dm_mirror dm_region_hash dm_log dm_mod ata_piix sd_mod
xhci_pci xhci_hcd crc32c_intel ahci libahci i2c_i801 ehci_pci libata psmouse
ehci_hcd scsi_mod e1000e ptp usbcore pps_core
[   35.588086] CPU: 1 PID: 5103 Comm: xmrig Not tainted 4.14.144-rm1+ #64
[   35.588088] Hardware name:  /DH67BL, BIOS BLH6710H.86A.0160.2012.1204.1156
12/04/2012
[   35.588090] task: ffff8e0c0578bb80 task.stack: ffffa6a349524000
[   35.588093] RIP: 0010:tcp_send_loss_probe.cold.42+0x20/0x2d
[   35.588095] RSP: 0000:ffff8e0c1f283e70 EFLAGS: 00010246
[   35.588097] RAX: 000000000000002c RBX: ffff8e0c0b932a80 RCX:
0000000000000000
[   35.588099] RDX: 0000000000000000 RSI: ffff8e0c1f296738 RDI:
ffff8e0c1f296738
[   35.588101] RBP: ffff8e0c0b932bd8 R08: 0000000000000000 R09:
0000000000000275
[   35.588103] R10: ffff8e0c0e911280 R11: 0000000000000000 R12:
ffff8e0c0b932bd8
[   35.588105] R13: ffffffff827d46b0 R14: ffff8e0c0b932a80 R15:
ffff8e0c1f283ef0
[   35.588107] FS:  00007f71de376700(0000) GS:ffff8e0c1f280000(0000)
knlGS:0000000000000000
[   35.588110] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.588112] CR2: 000055f0f061c000 CR3: 0000000409d0e001 CR4:
00000000000606e0
[   35.588114] Call Trace:
[   35.588116]  <IRQ>
[   35.588120]  tcp_write_timer_handler+0xce/0x210
[   35.588123]  tcp_write_timer+0x77/0x90
[   35.588126]  call_timer_fn+0x30/0x130
[   35.588129]  run_timer_softirq+0x3d3/0x410
[   35.588133]  ? timerqueue_add+0x52/0x80
[   35.588136]  ? enqueue_hrtimer+0x36/0x80
[   35.588140]  __do_softirq+0xdb/0x2d5
[   35.588142]  ? hrtimer_interrupt+0x113/0x1d0
[   35.588147]  irq_exit+0xbc/0xd0
[   35.588150]  smp_apic_timer_interrupt+0x78/0x140
[   35.588152]  apic_timer_interrupt+0x85/0x90
[   35.588154]  </IRQ>
[   35.588156] RIP: 0033:0x7f71ddb3b16f
[   35.588158] RSP: 002b:81244f1f4aebe662 EFLAGS: 00000206 ORIG_RAX:
ffffffffffffff10
[   35.588161] RAX: 000000005590220e RBX: 000000004520e100 RCX:
00007f71dd513600
[   35.588163] RDX: 000000005476b198 RSI: 8219664b28bc2fe0 RDI:
00000000555b6ee0
[   35.588165] RBP: 0000000092e54880 R08: 000000000007be43 R09:
00000000ce690f4f
[   35.588166] R10: 00000000001f6970 R11: 00007f71dd400000 R12:
80ee3d8c155f6970
[   35.588168] R13: 4b3017ab1f4489c9 R14: 3854bb60406a6bea R15:
eb98349c9e84f39a
[   35.588171] Code: 00 c6 83 7b 04 00 00 00 5b 5d c3 0f b6 53 12 8b 8b 2c 06
00 00 41 89 c0 48 c7 c7 90 e3 06 83 c6 05 39 64 b1 00 01 e8 cd a3 b0 ff <0f> 0b
e9 1f ee ff ff 90 90 90 90 90 90 66 66 66 66 90 48 8b 47 
[   35.588193] ---[ end trace 7c7f3665018c9e60 ]---

-- 
You are receiving this mail because:
You are the assignee for the bug.
