Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C11B63A570
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:53:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbiK1Jxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiK1Jxj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:53:39 -0500
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5B2A184
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:53:38 -0800 (PST)
Received: by mail-il1-f198.google.com with SMTP id q6-20020a056e020c2600b00302664fc72cso8395944ilg.14
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:53:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4YMW++R1On3P6dJ2gu4QPEe9Sm2nMnUkQkuzAEPBPQE=;
        b=pcpp+t4yEhvVaP6GsGQWAe2ILESOVJtpinDr/iF9PSyECEFNv/u7lRtncGBLiSyQFx
         76Tj13k8LyT2e7R1/XAacidLFE0LIkxu2hUHnvPftYp0PRVKZCit2y5TnI5LMs9n84J+
         Bo7aSt7TBEsCEoN5CoZb0K4Iv44i+I3WdGJYo0wk10Bt49SssBjxP97m2g3qi/DuYJ2F
         s9RD0PWM0ezIivze4rrFKaMOjs8dW0rkwU+TG7nYqoe27LYGbIPzMpytCp+QU0mS9VKE
         tKJ4DfFu/IOEfaQQBPovdAv3bPTch6gAZ9fxFT6+4KIMIOgXDt4jgkqqRiu8uuU1B/X4
         3vNA==
X-Gm-Message-State: ANoB5pmRL10IVeKqIkQRcsmfKElrUlAGhY62VsrxWa+Fe3qxVon86yJV
        9BtJa0k4djj0q8LRIqErGiN6fsS3aByWbcl0iPeicQ3whVRy
X-Google-Smtp-Source: AA0mqf5BgmVfE/wPnZYHko/K0RlBaIXALiRSGXFfnLumQbDr25gLsY0SpsphOU49L5OvNqVCkg0ZQigJUv3eDzDidUKZsXjrBbge
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1b08:b0:358:1594:9eb6 with SMTP id
 cb8-20020a0566381b0800b0035815949eb6mr9269386jab.236.1669629217828; Mon, 28
 Nov 2022 01:53:37 -0800 (PST)
Date:   Mon, 28 Nov 2022 01:53:37 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000006f759505ee84d8d7@google.com>
Subject: [syzbot] BUG: corrupted list in nfc_llcp_unregister_device
From:   syzbot <syzbot+81232c4a81a886e2b580@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        krzysztof.kozlowski@linaro.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com
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

HEAD commit:    9e46a7996732 Add linux-next specific files for 20221125
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=149b558d880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=11e19c740a0b2926
dashboard link: https://syzkaller.appspot.com/bug?extid=81232c4a81a886e2b580
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/758d818cf966/disk-9e46a799.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/f7c8696b40a5/vmlinux-9e46a799.xz
kernel image: https://storage.googleapis.com/syzbot-assets/810f9750b87f/bzImage-9e46a799.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+81232c4a81a886e2b580@syzkaller.appspotmail.com

list_del corruption. prev->next should be ffff888060ce7000, but was ffff88802a0ad000. (prev=ffffffff8e536240)
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:59!
invalid opcode: 0000 [#1] PREEMPT SMP KASAN
CPU: 0 PID: 16622 Comm: syz-executor.5 Not tainted 6.1.0-rc6-next-20221125-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
RIP: 0010:__list_del_entry_valid.cold+0x12/0x72 lib/list_debug.c:59
Code: f0 ff 0f 0b 48 89 f1 48 c7 c7 60 96 a6 8a 4c 89 e6 e8 4b 29 f0 ff 0f 0b 4c 89 e1 48 89 ee 48 c7 c7 c0 98 a6 8a e8 37 29 f0 ff <0f> 0b 48 89 ee 48 c7 c7 a0 97 a6 8a e8 26 29 f0 ff 0f 0b 4c 89 e2
RSP: 0018:ffffc900151afd58 EFLAGS: 00010282
RAX: 000000000000006d RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801e7eba80 RSI: ffffffff8166001c RDI: fffff52002a35f9d
RBP: ffff888060ce7000 R08: 000000000000006d R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8e536240
R13: ffff88801f3f3000 R14: ffff888060ce1000 R15: ffff888079d855f0
FS:  0000555556f57400(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f095d5ad988 CR3: 000000002155a000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __list_del_entry include/linux/list.h:134 [inline]
 list_del include/linux/list.h:148 [inline]
 local_release net/nfc/llcp_core.c:171 [inline]
 kref_put include/linux/kref.h:65 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:181 [inline]
 nfc_llcp_local_put net/nfc/llcp_core.c:176 [inline]
 nfc_llcp_unregister_device+0xb8/0x260 net/nfc/llcp_core.c:1619
 nfc_unregister_device+0x196/0x330 net/nfc/core.c:1179
 virtual_ncidev_close+0x52/0xb0 drivers/nfc/virtual_ncidev.c:163
 __fput+0x27c/0xa90 fs/file_table.c:320
 task_work_run+0x16f/0x270 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
 exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
 do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f8e7103df8b
Code: 0f 05 48 3d 00 f0 ff ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8 63 fc ff ff 8b 7c 24 0c 41 89 c0 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 35 44 89 c7 89 44 24 0c e8 a1 fc ff ff 8b 44
RSP: 002b:00007fffb68ce4c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000003
RAX: 0000000000000000 RBX: 0000000000000004 RCX: 00007f8e7103df8b
RDX: 00007f8e70c00e38 RSI: ffffffffffffffff RDI: 0000000000000003
RBP: 00007f8e711ad980 R08: 0000000000000000 R09: 00007f8e70c00000
R10: 00007f8e70c00e40 R11: 0000000000000293 R12: 000000000002bca8
R13: 00007fffb68ce5c0 R14: 00007f8e711abf80 R15: 0000000000000032
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__list_del_entry_valid.cold+0x12/0x72 lib/list_debug.c:59
Code: f0 ff 0f 0b 48 89 f1 48 c7 c7 60 96 a6 8a 4c 89 e6 e8 4b 29 f0 ff 0f 0b 4c 89 e1 48 89 ee 48 c7 c7 c0 98 a6 8a e8 37 29 f0 ff <0f> 0b 48 89 ee 48 c7 c7 a0 97 a6 8a e8 26 29 f0 ff 0f 0b 4c 89 e2
RSP: 0018:ffffc900151afd58 EFLAGS: 00010282
RAX: 000000000000006d RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801e7eba80 RSI: ffffffff8166001c RDI: fffff52002a35f9d
RBP: ffff888060ce7000 R08: 000000000000006d R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8e536240
R13: ffff88801f3f3000 R14: ffff888060ce1000 R15: ffff888079d855f0
FS:  0000555556f57400(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa7f4ab1718 CR3: 000000002155a000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
