Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8B3E522BC1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 07:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241238AbiEKFe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 01:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiEKFeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 01:34:25 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1E441DEC7A
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 22:34:24 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id v11-20020a056e0213cb00b002cbcd972206so737084ilj.11
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 22:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=aFQgjH47dbDj5aNlTIcru9pTtYzNioptBNbSqlWWCQs=;
        b=pJCcSQw8cBZiUaLMsHmYJ0N/ynf2Er05IphbOQkAI5FQI/1g0Lr733u8l+hX0leKfe
         80NZ2GCmHmdEDjfpWJdlZoHrfuxQR63v/xacGMWHzoV02YOwK4u0ApdkXVzbpBFVt3R4
         UlzZoJQcnVyLqahNih4WgfQ+oKkgLiFVE2DozwaF6LC1jvAwGl66iFPG7yadL14890J8
         8YaALph5miw3U9Jh0rTpSqUFd5Z/XiuRLQReOk2ju30qrWE6/O4ZVkvOQ7kRj/2YWc8h
         x1okX8zoEkTSupbW96YxySJo7ZsaUJvBTf9/5qrtQAZRWk1/WZzrAIHIaJuKI8pqGOEe
         5KtQ==
X-Gm-Message-State: AOAM530/27dloa2vsepAzu7eis692qfyf8qfeT8IXc/JVB1n/dzv+EBj
        IPIYpcDXSnuVRAVALjAzE27yBJfGPXVMAjxNC6HHjr3Fjxrt
X-Google-Smtp-Source: ABdhPJwTVsHq2aqZS5Ayf8vNemcKQ6F5l3+d4V/7OJEc4u2Ch8TFVZHMiN+gW/Gj8eoElw5dJksmF5Iid3mzzRCOAFXaifOKJzuC
MIME-Version: 1.0
X-Received: by 2002:a05:6602:1608:b0:65a:d365:c220 with SMTP id
 x8-20020a056602160800b0065ad365c220mr7974969iow.69.1652247264100; Tue, 10 May
 2022 22:34:24 -0700 (PDT)
Date:   Tue, 10 May 2022 22:34:24 -0700
In-Reply-To: <00000000000042b02105d0db5037@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004206f505deb5cb12@google.com>
Subject: Re: [syzbot] WARNING in mntput_no_expire (3)
From:   syzbot <syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    feb9c5e19e91 Merge tag 'for_linus' of git://git.kernel.org..
git tree:       upstream
console+strace: https://syzkaller.appspot.com/x/log.txt?x=10ea9d8ef00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=79caa0035f59d385
dashboard link: https://syzkaller.appspot.com/bug?extid=5b1e53987f858500ec00
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=125039fef00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17a27b71f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5b1e53987f858500ec00@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 3608 at fs/namespace.c:1236 mntput_no_expire+0xada/0xcd0 fs/namespace.c:1236
Modules linked in:

CPU: 0 PID: 3608 Comm: syz-executor314 Not tainted 5.18.0-rc6-syzkaller-00009-gfeb9c5e19e91 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mntput_no_expire+0xada/0xcd0 fs/namespace.c:1236
Code: 30 84 c0 0f 84 b9 fe ff ff 3c 03 0f 8f b1 fe ff ff 4c 89 44 24 10 e8 45 50 e9 ff 4c 8b 44 24 10 e9 9d fe ff ff e8 56 bf 9d ff <0f> 0b e9 19 fd ff ff e8 4a bf 9d ff e8 b5 cf 91 07 31 ff 89 c5 89
RSP: 0018:ffffc900030ffcf0 EFLAGS: 00010293

RAX: 0000000000000000 RBX: 1ffff9200061ffa4 RCX: 0000000000000000
RDX: ffff88807c859d80 RSI: ffffffff81db815a RDI: 0000000000000003
RBP: ffff88801bcbca80 R08: 0000000000000000 R09: ffffffff9006d90f
R10: ffffffff81db7e71 R11: 0000000000000001 R12: 0000000000000008
R13: ffffc900030ffd40 R14: 00000000ffffffff R15: 0000000000000002
FS:  0000555556a0e300(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555556a17628 CR3: 0000000071c9d000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 path_umount+0x7d4/0x1260 fs/namespace.c:1806
 ksys_umount fs/namespace.c:1825 [inline]
 __do_sys_umount fs/namespace.c:1830 [inline]
 __se_sys_umount fs/namespace.c:1828 [inline]
 __x64_sys_umount+0x159/0x180 fs/namespace.c:1828
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fcc5b9cc2c7
Code: 00 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffcb4fdf1a8 EFLAGS: 00000202 ORIG_RAX: 00000000000000a6
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcc5b9cc2c7
RDX: 00007ffcb4fdf269 RSI: 000000000000000a RDI: 00007ffcb4fdf260
RBP: 00007ffcb4fdf260 R08: 00000000ffffffff R09: 00007ffcb4fdf040
R10: 0000555556a0f693 R11: 0000000000000202 R12: 00007ffcb4fe02e0
R13: 0000555556a0f5f0 R14: 00007ffcb4fdf1d0 R15: 0000000000000002
 </TASK>

