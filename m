Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CE64688F8D
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 07:14:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbjBCGOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 01:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230003AbjBCGOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 01:14:39 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE5AF3
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 22:14:38 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id z12-20020a92d6cc000000b00310d4433c8cso2728937ilp.6
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 22:14:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q6qhhkxI0Fa2ecVa0opy5OWG8irJHSvv8/tIDhKgCEg=;
        b=VGgVZkoj8WdaoUWKWW12Rg3Hmw4+qaxX331AgeZZTM5JagGSuYSjtMcaEMBN8jJUdC
         PqvUE9c585IJz3Zh1iMt2sFAMkxdH9bXHbCZBgKPqbn6at/mLsQjXsCETDn50o45tM7c
         seDtQVtq2WqY8n15jbr45z/CslWyDq9HEgIn2XQ25SlQnLkSUEy1YwiJCY3aQw7MnZL4
         kRc5TLRXzTNlvg1q8J1zUdYOkKYU4E32A/GkCsieBlUU0sy4f+Ln3y8ag6UbrEanMAr6
         PPcZWiDOqd4rt2vpyrT31fosbPJqyHhCff4Kc96lWWxf2zvl+YaTxszCYb7Jjkiovw6p
         xAlQ==
X-Gm-Message-State: AO0yUKUwdElpjfQwttClzMSFKnUTq77YrHyvhx1V7Kal7a3Hi9EArLGa
        zha7+3d1m2yGqaFKlBNRUah6npjajxHXAAuTbCRqBhvSwACS
X-Google-Smtp-Source: AK7set/MqiiYgGSwQFGjuXKFYV7jvHbXG/cBEyam1SmM1Q9gjwcgZ1PqHiaAHtQAhzTkZDy6SVVeDSwkZAMHMf190iSHpY+gI+SE
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:c07:b0:30f:49fd:f547 with SMTP id
 d7-20020a056e020c0700b0030f49fdf547mr1774052ile.119.1675404877951; Thu, 02
 Feb 2023 22:14:37 -0800 (PST)
Date:   Thu, 02 Feb 2023 22:14:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009afa3c05f3c5988a@google.com>
Subject: [syzbot] WARNING in remove_proc_entry (5)
From:   syzbot <syzbot+04a8437497bcfb4afa95@syzkaller.appspotmail.com>
To:     anna@kernel.org, chuck.lever@oracle.com, davem@davemloft.net,
        edumazet@google.com, jlayton@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    80bd9028feca Add linux-next specific files for 20230131
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10a0f7ae480000
kernel config:  https://syzkaller.appspot.com/x/.config?x=904dc2f450eaad4a
dashboard link: https://syzkaller.appspot.com/bug?extid=04a8437497bcfb4afa95
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/924618188238/disk-80bd9028.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7a03cf86e545/vmlinux-80bd9028.xz
kernel image: https://storage.googleapis.com/syzbot-assets/568e80043a41/bzImage-80bd9028.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+04a8437497bcfb4afa95@syzkaller.appspotmail.com

------------[ cut here ]------------
name 'gss_krb5_enctypes'
WARNING: CPU: 0 PID: 6187 at fs/proc/generic.c:712 remove_proc_entry+0x38d/0x460 fs/proc/generic.c:712
Modules linked in:
CPU: 0 PID: 6187 Comm: syz-executor.4 Not tainted 6.2.0-rc6-next-20230131-syzkaller-09515-g80bd9028feca #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/12/2023
RIP: 0010:remove_proc_entry+0x38d/0x460 fs/proc/generic.c:712
Code: e9 6d fe ff ff e8 63 f1 7c ff 48 c7 c7 e0 6d 98 8c e8 47 ba 0b 08 e8 52 f1 7c ff 4c 89 e6 48 c7 c7 c0 85 5e 8a e8 53 8c 44 ff <0f> 0b e9 a4 fe ff ff e8 37 f1 7c ff 48 8d bd d8 00 00 00 48 b8 00
RSP: 0018:ffffc90015dcf8c8 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 1ffff92002bb9f1b RCX: ffffc9000c579000
RDX: 0000000000040000 RSI: ffffffff81692aec RDI: 0000000000000005
RBP: 0000000000000000 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8b75c440
R13: dffffc0000000000 R14: dffffc0000000000 R15: fffffbfff1c6d918
FS:  00007fe943910700(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2d14a16984 CR3: 0000000029c4e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 destroy_krb5_enctypes_proc_entry net/sunrpc/auth_gss/svcauth_gss.c:1543 [inline]
 gss_svc_shutdown_net+0x7d/0x2b0 net/sunrpc/auth_gss/svcauth_gss.c:2120
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 setup_net+0x9bd/0xe60 net/core/net_namespace.c:356
 copy_net_ns+0x320/0x6b0 net/core/net_namespace.c:483
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x410/0x500 kernel/nsproxy.c:179
 copy_process+0x311d/0x76b0 kernel/fork.c:2272
 kernel_clone+0xeb/0x9a0 kernel/fork.c:2684
 __do_sys_clone+0xba/0x100 kernel/fork.c:2825
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fe942c8c0c9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 f1 19 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe943910118 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007fe942dabf80 RCX: 00007fe942c8c0c9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000071801000
RBP: 00007fe942ce7ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007ffe8ccafb1f R14: 00007fe943910300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
