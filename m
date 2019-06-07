Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B863B38EC1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 17:16:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729226AbfFGPQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 11:16:07 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:34609 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728486AbfFGPQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 11:16:07 -0400
Received: by mail-pl1-f195.google.com with SMTP id i2so961159plt.1
        for <netdev@vger.kernel.org>; Fri, 07 Jun 2019 08:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Ip4elrPLGCMXVJWXh5WbeGWCskfRzsDea3LFyn6A9gQ=;
        b=wPqyetjhGSbBV1zs6BG0kqLFALe53h6kVX13nYPw/CjEqZqcW8wvqPMWGr/Un4om5u
         uuP1xSTlgAYFK0vKbFfkONXkiiQnRm1ZJYTjSUjCCQCxpWk4D74ztzi6CE9q8ilSWPi2
         5NMk4xgWSc06VZatqLnVqluseYogQIh6djCyDxcKjsAQq8bgmC3Q9Rsit0kC1ctSBlfj
         KxvRcVfs2+QADlzz+l9fOCV8iZxBN4pZn2l44JKKI20e21nVyognUvBHkRJHLQGVbTdW
         a1u5Mz9A7f68Tr539GSp2g7Het7qFeaByHItzWNf7VN8QgS44PPDnYA5T8do5OZ5xPGh
         eVSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=Ip4elrPLGCMXVJWXh5WbeGWCskfRzsDea3LFyn6A9gQ=;
        b=nIHRIgUhs6nRO/0Sn33euAvYW+vdz8/KPHvGshSBM91ryiBS+RuF7L9nKqoVAnDmpD
         cS8o/On5ajecJmpWSBwAlmUFgMcH0YRUiqwLvyEbRDWqnROE/2TWefTlEK6o7OK1hxlG
         cGR9KIgFLcNhRh6yPyM0+07GLDCEsgRtrx2a4d/vntzfrn0p7FZ+KxRsgJ3an9+k4rsT
         /G3fK84jC5NitArwAAuo4Z27uxvwiD4C+Q021xJHu8H0sSofIRMbCtvCOcxxQw1dmOHm
         csfQuVAun9+P3qZhB7gIPOXhDbWiXB2MYKPmggNKyVqEZStzAVDEujIbyUdZXS6QZVjd
         Z8Ig==
X-Gm-Message-State: APjAAAXlLFrFnWhqKm3BlOdmiYCZWpmeW8EMUb8RYl2prrVxQJGLtFhl
        1O4GtHI9Q0Crb23G09HCuvIGW+wiJfc=
X-Google-Smtp-Source: APXvYqyUFTkS9efWCiZSEReMOmIFl3G1ZEbzxbuKWF4MD0pQkzSS50aqRqXvSFM2/IpxEa+7wcNo9A==
X-Received: by 2002:a17:902:165:: with SMTP id 92mr28370607plb.197.1559920565489;
        Fri, 07 Jun 2019 08:16:05 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j37sm2282630pgj.58.2019.06.07.08.16.04
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 07 Jun 2019 08:16:05 -0700 (PDT)
Date:   Fri, 7 Jun 2019 08:16:02 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Fw: [Bug 203843] New: e1000e crash when ethernet is plugged in
Message-ID: <20190607081602.3e286000@hermes.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Fri, 07 Jun 2019 10:09:19 +0000
From: bugzilla-daemon@bugzilla.kernel.org
To: stephen@networkplumber.org
Subject: [Bug 203843] New: e1000e crash when ethernet is plugged in


https://bugzilla.kernel.org/show_bug.cgi?id=203843

            Bug ID: 203843
           Summary: e1000e crash when ethernet is plugged in
           Product: Networking
           Version: 2.5
    Kernel Version: 5.1.7
          Hardware: Intel
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: Other
          Assignee: stephen@networkplumber.org
          Reporter: justinvangog@gmail.com
        Regression: No

Created attachment 283143
  --> https://bugzilla.kernel.org/attachment.cgi?id=283143&action=edit  
log of the crash

I get a crash when i plug in a network cable after the system has booted.

Im on kernel version 5.1.7

e1000e driver version 3.4.2.4






T30 ~ # [   20.027123] e1000e: enp0s31f6 NIC Link is Up 10 Mbps Full Duplex,
Flow Control: None
[   20.027151] e1000e 0000:00:1f.6 enp0s31f6: 10/100 speed: disabling TSO
[   20.027211] IPv6: ADDRCONF(NETDEV_CHANGE): enp0s31f6: link becomes ready
[   25.212764] ------------[ cut here ]------------
[   25.212824] NETDEV WATCHDOG: enp0s31f6 (e1000e): transmit queue 0 timed out
[   25.212909] WARNING: CPU: 3 PID: 0 at net/sched/sch_generic.c:461
dev_watchdog+0x1ee/0x200
[   25.212977] Modules linked in: snd_hda_codec_realtek snd_hda_codec_generic
snd_hda_intel snd_hda_codec snd_hwdep snd_hda_core e1000e(O) snd_pcm tpm_tis
tpm_tis_core efivarfs
[   25.213107] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G           O     
5.1.7-gentoo #1
[   25.213171] Hardware name: Dell Inc. PowerEdge T30/07T4MC, BIOS 1.0.15
07/12/2018
[   25.213236] RIP: 0010:dev_watchdog+0x1ee/0x200
[   25.213277] Code: 00 48 63 4d e0 eb 93 4c 89 e7 c6 05 bf 98 ad 00 01 e8 26
d4 fc ff 89 d9 4c 89 e6 48 c7 c7 b0 85 68 84 48 89 c2 e8 79 96 83 ff <0f> 0b eb
c0 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 00 48 c7 47 08
[   25.213421] RSP: 0018:ffff9eefddb83ea0 EFLAGS: 00010286
[   25.213466] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000000
[   25.213525] RDX: 0000000000040400 RSI: 00000000000000f6 RDI:
0000000000000300
[   25.213584] RBP: ffff9eefcaa9c440 R08: 000000000000039c R09:
0000000000aaaaaa
[   25.213643] R10: 0000000000000000 R11: ffffb691f01c0220 R12:
ffff9eefcaa9c000
[   25.213702] R13: 0000000000000003 R14: ffff9eefddb83ef0 R15:
0000000000000000
[   25.213762] FS:  0000000000000000(0000) GS:ffff9eefddb80000(0000)
knlGS:0000000000000000
[   25.213828] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   25.213877] CR2: 00007f6a77a0c680 CR3: 00000001b820e003 CR4:
00000000003606e0
[   25.213936] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[   25.213994] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
0000000000000400
[   25.214053] Call Trace:
[   25.214080]  <IRQ>
[   25.214107]  ? qdisc_put_unlocked+0x30/0x30
[   25.214148]  call_timer_fn+0x26/0x120
[   25.214185]  run_timer_softirq+0x390/0x3c0
[   25.214225]  ? tick_sched_timer+0x32/0x70
[   25.214266]  ? __hrtimer_run_queues+0x10b/0x280
[   25.214310]  ? recalibrate_cpu_khz+0x10/0x10
[   25.214352]  __do_softirq+0xd3/0x2ec
[   25.214390]  irq_exit+0xa0/0xb0
[   25.214422]  smp_apic_timer_interrupt+0x67/0x130
[   25.214466]  apic_timer_interrupt+0xf/0x20
[   25.214504]  </IRQ>
[   25.214530] RIP: 0010:cpuidle_enter_state+0xac/0x420
[   25.214574] Code: 89 04 24 0f 1f 44 00 00 31 ff e8 ff 66 8f ff 45 84 ff 74
12 9c 58 f6 c4 02 0f 85 3e 03 00 00 31 ff e8 58 ca 93 ff fb 45 85 e4 <0f> 88 7c
02 00 00 49 63 cc 48 8b 34 24 48 2b 74 24 08 48 8d 04 49
[   25.214717] RSP: 0018:ffffb691c00bbe98 EFLAGS: 00000206 ORIG_RAX:
ffffffffffffff13
[   25.214787] RAX: ffff9eefddba0d00 RBX: ffffffff8489b260 RCX:
000000000000001f
[   25.214846] RDX: 00000005decbd37a RSI: 0000000026a5b845 RDI:
0000000000000000
[   25.214905] RBP: ffff9eefddba8200 R08: 0000000000000002 R09:
00000000000205c0
[   25.214964] R10: 00000017dec25626 R11: ffff9eefddb9fe44 R12:
0000000000000006
[   25.215023] R13: ffffffff8489b4b8 R14: ffffffff8489b4a0 R15:
0000000000000000
[   25.215086]  ? cpuidle_enter_state+0x91/0x420
[   25.215128]  do_idle+0x1a6/0x1e0
[   25.215164]  cpu_startup_entry+0x14/0x20
[   25.215202]  start_secondary+0x159/0x180
[   25.215240]  secondary_startup_64+0xa4/0xb0
[   25.215279] ---[ end trace 7e6afe981485542a ]---
[   25.215346] e1000e 0000:00:1f.6 enp0s31f6: Reset adapter unexpectedly
[   29.186751] e1000e: enp0s31f6 NIC Link is Up 1000 Mbps Full Duplex, Flow
Control: None

-- 
You are receiving this mail because:
You are the assignee for the bug.
