Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAEDB4A6D96
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 10:14:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245369AbiBBJOV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 04:14:21 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:35608 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245361AbiBBJOV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 04:14:21 -0500
Received: by mail-io1-f71.google.com with SMTP id y124-20020a6bc882000000b0060fbfe14d03so14834038iof.2
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 01:14:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=Y4zMAKmF3fJtUB5SQPyW2jumUn+FB4DDBgKyoPqrmVs=;
        b=18kbeT98ICyoNoQ4YyDPikza2K1UaXVM5ew2BJwKFoU6oSc97vrab0hM/6PwguVBw/
         k/l7f+FjV2mk+WxzUFSZfkZD/Oc3TFNyqpDfADA0PBhXER8PmpMMnJ8ZgkRiDXSWDG/Z
         552Z5JFXvdG8g0MeLm6Ci4M5i2TCyQhwFCnDLI+NKoKzSWjpafHnd9Q+IG9eosfs34ph
         WS3u9NUeXikE5sBNEomiXFR+KJXssAYLJqx8y5f3KnNnZavSTue+FTYwcBQqz6t8WZGI
         2HLmVdBo2JDwiC+//ymR5xsVty7ZzQQGgksVwUDRaoKmeTkXyG7Izwe4CbPOGD7vdfrD
         N1lw==
X-Gm-Message-State: AOAM532LCG6j4eAOTpML6PrxhmWuY1sFnIgT79HAz+/1GOrrrlagxiVT
        hc836NWtz7arU2+ZCNU/eA9B9fxCtBBZ859SvA9OsIpSWSef
X-Google-Smtp-Source: ABdhPJw0U4DGDJ2fpSgP7caUnjZiGgAXuNFu3X7dx25PooA913HBlmaQjKArM091EKapdvbsNSw948hgZ85Y8dFXjR3+xRtUOizi
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c44:: with SMTP id x4mr16114027iov.111.1643793260598;
 Wed, 02 Feb 2022 01:14:20 -0800 (PST)
Date:   Wed, 02 Feb 2022 01:14:20 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000061d7eb05d7057144@google.com>
Subject: [syzbot] WARNING in bpf_prog_test_run_xdp
From:   syzbot <syzbot+79fd1ab62b382be6f337@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    ff58831fa02d Merge branch 'Cadence-ZyncMP-SGMII'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=16fe8fe4700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae0d71385f83fe54
dashboard link: https://syzkaller.appspot.com/bug?extid=79fd1ab62b382be6f337
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+79fd1ab62b382be6f337@syzkaller.appspotmail.com

WARNING: CPU: 0 PID: 13059 at include/linux/thread_info.h:230 check_copy_size include/linux/thread_info.h:230 [inline]
WARNING: CPU: 0 PID: 13059 at include/linux/thread_info.h:230 copy_from_user include/linux/uaccess.h:191 [inline]
WARNING: CPU: 0 PID: 13059 at include/linux/thread_info.h:230 bpf_prog_test_run_xdp+0xec7/0x1150 net/bpf/test_run.c:978
Modules linked in:
CPU: 0 PID: 13059 Comm: syz-executor.3 Not tainted 5.17.0-rc1-syzkaller-00495-gff58831fa02d #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:check_copy_size include/linux/thread_info.h:230 [inline]
RIP: 0010:copy_from_user include/linux/uaccess.h:191 [inline]
RIP: 0010:bpf_prog_test_run_xdp+0xec7/0x1150 net/bpf/test_run.c:978
Code: fd 06 48 c1 e5 0c 48 01 c5 e8 55 76 09 fa 49 81 fe ff ff ff 7f 0f 86 08 fe ff ff 4c 8b 74 24 60 4c 8b 7c 24 68 e8 a9 73 09 fa <0f> 0b 41 bc f2 ff ff ff e9 02 fb ff ff 4c 8b 74 24 60 4c 8b 7c 24
RSP: 0018:ffffc9000552fb40 EFLAGS: 00010212
RAX: 000000000000011d RBX: 00000000fffff0a4 RCX: ffffc9000ba49000
RDX: 0000000000040000 RSI: ffffffff876ee9a7 RDI: 0000000000000003
RBP: ffff88806d779000 R08: 000000007fffffff R09: ffffffff8d94d717
R10: ffffffff876ee98b R11: 000000000000001f R12: 0000000000000dc0
R13: ffff88804f43a000 R14: 0000000000000000 R15: ffffc90002056000
FS:  00007faff28c2700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f4ff63b9058 CR3: 0000000074132000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 bpf_prog_test_run kernel/bpf/syscall.c:3356 [inline]
 __sys_bpf+0x1858/0x59a0 kernel/bpf/syscall.c:4658
 __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7faff3f8f059
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007faff28c2168 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007faff40a2100 RCX: 00007faff3f8f059
RDX: 0000000000000048 RSI: 0000000020000180 RDI: 000000000000000a
RBP: 00007faff3fe908d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc3e8ffe3f R14: 00007faff28c2300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
