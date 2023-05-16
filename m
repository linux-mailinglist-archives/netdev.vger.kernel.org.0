Return-Path: <netdev+bounces-3007-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5FAA704FF5
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 15:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B42BB1C20E3E
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:53:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC0AD28C01;
	Tue, 16 May 2023 13:53:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B01C92773C
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 13:53:37 +0000 (UTC)
Received: from mail-io1-f80.google.com (mail-io1-f80.google.com [209.85.166.80])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C058B59D3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:53:10 -0700 (PDT)
Received: by mail-io1-f80.google.com with SMTP id ca18e2360f4ac-76c5c78bc24so1202418539f.2
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 06:53:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684245187; x=1686837187;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kyT4n4bMyXmFcXsOkobti8IGyVkJRps098amtpTfmYM=;
        b=eIFwn5Qx21AXS9Ltq34Xe6xisgop85M7n8pYL83d2raa+NL1o0IaVYFeF8SVzlbAGv
         TgYD6iOnMXJB0xf9hzeChx+IEi+ykv7qyXMqFXFYr8SadtmQrj4ljAnSaS9eHxS/0+B/
         HEom7CVtMTynRaDRoqWaP/ZRHC197zIDTkb+JREO32sIyl/1VC9oT+yE0Ek7MSbfdBxw
         Cn8jh3Yb4N8VZMb7jC1jbV5uuSaqP+BGg8gGRI4yMGiO2CEgHZ9m7J1dZZxmTdCiupNd
         YsQlw/+dsoTNRKp/RqOWfy84u5BEFNBTPMkwbE0c5U2Fi6zRl++lbMq4qVTk7SIZM6dZ
         Ufcg==
X-Gm-Message-State: AC+VfDwEayX5KmaFz0QOHj2JY68bJLM2vSrnzvom4vAf34vP0qNDdgwI
	3asfqRZ/Ht0KGs1bp4eER8aAC5Cs4xySNidbV5tKJJKgMoOO
X-Google-Smtp-Source: ACHHUZ5SyNZXvdhQg0gIKEun3Po/54nscj+EhAA0rP0BO5JNX+odk+CvUoj43x8IvwGeUEpubZU4n9S1JJ8+SphLhCHjoTEV95q4
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a02:b106:0:b0:406:5e9b:87bd with SMTP id
 r6-20020a02b106000000b004065e9b87bdmr11596972jah.2.1684245187209; Tue, 16 May
 2023 06:53:07 -0700 (PDT)
Date: Tue, 16 May 2023 06:53:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001933d305fbcfe488@google.com>
Subject: [syzbot] [net?] linux-next test error: WARNING in register_net_sysctl
From: syzbot <syzbot+a03fd670838d927d9cd8@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, linux-next@vger.kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, sfr@canb.auug.org.au, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    885df05bf634 Add linux-next specific files for 20230516
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12231ff6280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=86a3ef42a1d1a23
dashboard link: https://syzkaller.appspot.com/bug?extid=a03fd670838d927d9cd8
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/72eb24cce47e/disk-885df05b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/31443616abfe/vmlinux-885df05b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/ec388de48d44/bzImage-885df05b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a03fd670838d927d9cd8@syzkaller.appspotmail.com

------------[ cut here ]------------
sysctl net/ipv4/ipfrag_low_thresh: data points to kernel global data: ipfrag_low_thresh_unused
WARNING: CPU: 0 PID: 5002 at net/sysctl_net.c:155 ensure_safe_net_sysctl net/sysctl_net.c:155 [inline]
WARNING: CPU: 0 PID: 5002 at net/sysctl_net.c:155 register_net_sysctl+0x207/0x3c0 net/sysctl_net.c:167
Modules linked in:
CPU: 0 PID: 5002 Comm: syz-executor.0 Not tainted 6.4.0-rc2-next-20230516-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 04/28/2023
RIP: 0010:ensure_safe_net_sysctl net/sysctl_net.c:155 [inline]
RIP: 0010:register_net_sysctl+0x207/0x3c0 net/sysctl_net.c:167
Code: 8b 43 f4 48 89 f8 48 c1 e8 03 80 3c 28 00 0f 85 a9 01 00 00 48 8b 53 ec 4c 89 e9 4c 89 fe 48 c7 c7 c0 98 85 8b e8 69 13 7f f7 <0f> 0b 48 89 d8 48 c1 e8 03 0f b6 14 28 48 89 d8 83 e0 07 83 c0 01
RSP: 0018:ffffc90003f3fbf8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff888027a56854 RCX: 0000000000000000
RDX: ffff88807db13b80 RSI: ffffffff814bd247 RDI: 0000000000000001
RBP: dffffc0000000000 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000001 R12: ffff888027a56848
R13: ffffffff8b859740 R14: 0000000000000000 R15: ffffffff8b69e220
FS:  000055555618a400(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f57f7ad4620 CR3: 00000000224ca000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 ip4_frags_ns_ctl_register net/ipv4/ip_fragment.c:618 [inline]
 ipv4_frags_init_net net/ipv4/ip_fragment.c:689 [inline]
 ipv4_frags_init_net+0x269/0x430 net/ipv4/ip_fragment.c:660
 ops_init+0xb9/0x6b0 net/core/net_namespace.c:136
 setup_net+0x5d1/0xc50 net/core/net_namespace.c:339
 copy_net_ns+0x4ee/0x8e0 net/core/net_namespace.c:491
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:228
 ksys_unshare+0x449/0x920 kernel/fork.c:3440
 __do_sys_unshare kernel/fork.c:3511 [inline]
 __se_sys_unshare kernel/fork.c:3509 [inline]
 __x64_sys_unshare+0x31/0x40 kernel/fork.c:3509
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f57f6e8d727
Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff9777e5b8 EFLAGS: 00000206 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007fff9777ebf8 RCX: 00007f57f6e8d727
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000040000000
RBP: 00000000ffffffff R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000003
R13: 00007fff9777e690 R14: 00007f57f6fac9d8 R15: 000000000000000c
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

