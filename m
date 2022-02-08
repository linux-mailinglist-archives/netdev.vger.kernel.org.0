Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82EF54AD37C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 09:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349863AbiBHIcZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 03:32:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239909AbiBHIcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 03:32:23 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3600FC03FECD
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 00:32:21 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id k5-20020a926f05000000b002be190db91cso4048181ilc.11
        for <netdev@vger.kernel.org>; Tue, 08 Feb 2022 00:32:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Ak7DGjpz8u+yF2tUMgurDsjOzzk2JV1a40V2RS9Gck8=;
        b=uQJGGdJ2IqNIQAM0vrUEz+A8ofdEc7ukpetyXyGScnHP5tTM2GtJ5UTLSRRuxuZEb9
         VtzMn3q3D4uV2f6vwxrISekcUYtX0e+8NJsAuqCTo2duvJWgUeIvyHdOjuAeJHxEGcrK
         D19rov2KNe/vaAbxQegcQ3ub2X1J1NYwEqRV8Jd7cllhuMSumz9igBzTd+kXiK+spRdK
         6VZNbWD3fpfLgHcCvMI5cWPVXINvXAhzk4GaduU7azocWczmJQCg1t2n4TR/w6rVzuwF
         CQaCHT+crvD0xF0/qr/6+jVSR9qsJ/0eq6qVAqNeOAANh4rGLYOm3YHsIt5PXAc8sWBm
         xGkQ==
X-Gm-Message-State: AOAM531Iud/OmsEfXGPCD6qFGpYvIUTsJfgzP6Q/dXCH+nawEy/p4Lh/
        3KMNEq6EsYWwR9IoBwHDUeofmV72189T6yWYuRyZGmzcX8am
X-Google-Smtp-Source: ABdhPJy+foHVsEDATvpMe56nchUDiGYkbjVPttKtcXmM5hZNEADLd3cG6tcj3Vkz6WcEeVtjb5ev9mO+QTcW9ge+vdYOTdXIxh1T
MIME-Version: 1.0
X-Received: by 2002:a05:6602:168b:: with SMTP id s11mr1598578iow.208.1644309140646;
 Tue, 08 Feb 2022 00:32:20 -0800 (PST)
Date:   Tue, 08 Feb 2022 00:32:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000003aafee05d77d8e55@google.com>
Subject: [syzbot] KCSAN: data-race in wg_packet_send_staged_packets /
 wg_packet_send_staged_packets (3)
From:   syzbot <syzbot+6ba34f16b98fe40daef1@syzkaller.appspotmail.com>
To:     Jason@zx2c4.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, wireguard@lists.zx2c4.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    2ade8eef993c Merge tag 'ata-5.17-rc4' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16c03872700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1dcc3374da7c1f7c
dashboard link: https://syzkaller.appspot.com/bug?extid=6ba34f16b98fe40daef1
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6ba34f16b98fe40daef1@syzkaller.appspotmail.com

==================================================================
BUG: KCSAN: data-race in wg_packet_send_staged_packets / wg_packet_send_staged_packets

read to 0xffff888133f5eac8 of 4 bytes by interrupt on cpu 0:
 wg_cpumask_next_online drivers/net/wireguard/queueing.h:129 [inline]
 wg_queue_enqueue_per_device_and_peer drivers/net/wireguard/queueing.h:176 [inline]
 wg_packet_create_data drivers/net/wireguard/send.c:320 [inline]
 wg_packet_send_staged_packets+0x41a/0x800 drivers/net/wireguard/send.c:387
 wg_packet_send_keepalive+0xfc/0x110 drivers/net/wireguard/send.c:239
 wg_expired_send_persistent_keepalive+0x38/0x50 drivers/net/wireguard/timers.c:141
 call_timer_fn+0x2e/0x240 kernel/time/timer.c:1421
 expire_timers+0x116/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x410 kernel/time/timer.c:1734
 run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1747
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 __irq_exit_rcu kernel/softirq.c:637 [inline]
 irq_exit_rcu+0x37/0x70 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x8d/0xb0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 __x64_sys_clock_nanosleep+0x54/0x60 kernel/time/posix-timers.c:1245
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

write to 0xffff888133f5eac8 of 4 bytes by interrupt on cpu 1:
 wg_cpumask_next_online drivers/net/wireguard/queueing.h:133 [inline]
 wg_queue_enqueue_per_device_and_peer drivers/net/wireguard/queueing.h:176 [inline]
 wg_packet_create_data drivers/net/wireguard/send.c:320 [inline]
 wg_packet_send_staged_packets+0x455/0x800 drivers/net/wireguard/send.c:387
 wg_packet_send_keepalive+0xfc/0x110 drivers/net/wireguard/send.c:239
 wg_expired_send_persistent_keepalive+0x38/0x50 drivers/net/wireguard/timers.c:141
 call_timer_fn+0x2e/0x240 kernel/time/timer.c:1421
 expire_timers+0x116/0x240 kernel/time/timer.c:1466
 __run_timers+0x368/0x410 kernel/time/timer.c:1734
 run_timer_softirq+0x2e/0x60 kernel/time/timer.c:1747
 __do_softirq+0x158/0x2de kernel/softirq.c:558
 __irq_exit_rcu kernel/softirq.c:637 [inline]
 irq_exit_rcu+0x37/0x70 kernel/softirq.c:649
 sysvec_apic_timer_interrupt+0x8d/0xb0 arch/x86/kernel/apic/apic.c:1097
 asm_sysvec_apic_timer_interrupt+0x12/0x20
 is_atomic kernel/kcsan/core.c:262 [inline]
 should_watch kernel/kcsan/core.c:275 [inline]
 check_access kernel/kcsan/core.c:741 [inline]
 __tsan_read2+0x13e/0x180 kernel/kcsan/core.c:1012
 tlb_flush_pte_range include/asm-generic/tlb.h:524 [inline]
 zap_pte_range+0x559/0x10e0 mm/memory.c:1366
 zap_pmd_range mm/memory.c:1490 [inline]
 zap_pud_range mm/memory.c:1519 [inline]
 zap_p4d_range mm/memory.c:1540 [inline]
 unmap_page_range+0x2dc/0x3d0 mm/memory.c:1561
 unmap_single_vma+0x157/0x210 mm/memory.c:1606
 unmap_vmas+0xd0/0x180 mm/memory.c:1638
 exit_mmap+0x261/0x4b0 mm/mmap.c:3178
 __mmput+0x27/0x1b0 kernel/fork.c:1114
 mmput+0x3d/0x50 kernel/fork.c:1135
 exit_mm+0xdb/0x170 kernel/exit.c:507
 do_exit+0x569/0x16a0 kernel/exit.c:793
 do_group_exit+0xa5/0x160 kernel/exit.c:935
 get_signal+0x8cf/0x15d0 kernel/signal.c:2862
 arch_do_signal_or_restart+0x8c/0x2e0 arch/x86/kernel/signal.c:868
 handle_signal_work kernel/entry/common.c:148 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:172 [inline]
 exit_to_user_mode_prepare+0x113/0x190 kernel/entry/common.c:207
 __syscall_exit_to_user_mode_work kernel/entry/common.c:289 [inline]
 syscall_exit_to_user_mode+0x20/0x40 kernel/entry/common.c:300
 do_syscall_64+0x50/0xd0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x44/0xae

value changed: 0x00000001 -> 0x00000000

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 21549 Comm: syz-executor.4 Not tainted 5.17.0-rc3-syzkaller-00013-g2ade8eef993c-dirty #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
==================================================================
sd 0:0:1:0: [sda] tag#3016 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3016 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3016 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3016 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3016 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3023 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3023 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3023 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3023 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3023 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3025 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3025 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3025 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3025 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3025 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3026 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3026 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3026 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3026 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3026 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3027 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3027 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3027 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3027 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3027 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3029 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3029 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3029 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3029 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3029 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3056 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3056 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3056 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3056 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3056 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3057 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3057 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3057 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3057 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3057 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3059 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3059 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3059 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3059 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3059 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3060 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3060 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3060 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3060 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3060 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3061 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3061 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3061 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3061 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3061 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3062 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3062 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3062 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3062 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3062 CDB[20]: ba
sd 0:0:1:0: [sda] tag#3063 FAILED Result: hostbyte=DID_ABORT driverbyte=DRIVER_OK cmd_age=0s
sd 0:0:1:0: [sda] tag#3063 CDB: opcode=0xe5 (vendor)
sd 0:0:1:0: [sda] tag#3063 CDB[00]: e5 f4 32 73 2f 4e 09 6d 26 e2 c7 35 d1 35 12 1c
sd 0:0:1:0: [sda] tag#3063 CDB[10]: 92 1b da 40 b8 58 5b a8 d4 7d 34 f3 90 4c f1 2d
sd 0:0:1:0: [sda] tag#3063 CDB[20]: ba


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
