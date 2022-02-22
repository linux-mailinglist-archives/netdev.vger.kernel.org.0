Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3B0E4BEE91
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 02:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237826AbiBVA3p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 19:29:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237806AbiBVA3o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 19:29:44 -0500
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D6BB2559C
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 16:29:19 -0800 (PST)
Received: by mail-il1-f199.google.com with SMTP id v13-20020a927a0d000000b002c1ecbb3a5dso4661537ilc.7
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 16:29:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=0BZwrNloClntFMswwx+cnpzCRFfY9U/Eu/+IXatkajU=;
        b=0Y1QIw7Ol+Fe6MX3WOy9VHKEpwnoFXFZiOweMZK37ya10vSav1i36oSoLSo23BOuLS
         2CjcQcX+DuwUje7ERy4Pg0DJwC9QGV9/1ZxTUPa4Px+/nO1HXlSWBo9mKog0vV1fhpC0
         mg2f63y0SgcUiSGuqw1pOFXRmdHSsrvMaF9oXLAGYhkzVluqIWLDPnLNKxahr0JzcqJN
         ybVcEUVVMtV8k3UjLtOYwtqtF+XvDFZlMkuILkIGM76DhARmC+1gcUW9/CljGGoVLgry
         Bu8eB1/8GebkCboEPJDuRJkseslxrEf5y7kHf4AYxFXT415WKcdEIb57TcnZJRdm91f4
         EGdQ==
X-Gm-Message-State: AOAM531+lwfnd8XUG4xc7vTLSbQRwCyTyz8AJT6QIjrVQP1Untm02LRD
        ibXyMusdcdz8KS1WYRzpQsxabuMgzUNJ6DahZhb+yJ4HXJRo
X-Google-Smtp-Source: ABdhPJxAxRYMrEcUINLoSv3fvwzOA8DoG69h5G/pu1ZS4VjLCHJw9JVGDFu4NcW3tBRJ5ppM1UJ/UNIm5sXjVOegZPq38xj0DBvy
MIME-Version: 1.0
X-Received: by 2002:a5e:c24a:0:b0:640:97be:f792 with SMTP id
 w10-20020a5ec24a000000b0064097bef792mr12138085iop.15.1645489758890; Mon, 21
 Feb 2022 16:29:18 -0800 (PST)
Date:   Mon, 21 Feb 2022 16:29:18 -0800
In-Reply-To: <000000000000264b2a05d44bca80@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000008f71e305d89070bb@google.com>
Subject: Re: [syzbot] WARNING in cpuset_write_resmask
From:   syzbot <syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com>
To:     cgroups@vger.kernel.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, lizefan.x@bytedance.com,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        tj@kernel.org
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=113aeefa700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
dashboard link: https://syzkaller.appspot.com/bug?extid=568dc81cd20b72d4a49f
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13bb97ce700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12062c8e700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+568dc81cd20b72d4a49f@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 3647 at kernel/cgroup/cpuset.c:1817 update_nodemasks_hier kernel/cgroup/cpuset.c:1817 [inline]
WARNING: CPU: 1 PID: 3647 at kernel/cgroup/cpuset.c:1817 update_nodemask kernel/cgroup/cpuset.c:1890 [inline]
WARNING: CPU: 1 PID: 3647 at kernel/cgroup/cpuset.c:1817 cpuset_write_resmask+0x167b/0x20f0 kernel/cgroup/cpuset.c:2457
Modules linked in:
CPU: 0 PID: 3647 Comm: syz-executor287 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:update_nodemasks_hier kernel/cgroup/cpuset.c:1817 [inline]
RIP: 0010:update_nodemask kernel/cgroup/cpuset.c:1890 [inline]
RIP: 0010:cpuset_write_resmask+0x167b/0x20f0 kernel/cgroup/cpuset.c:2457
Code: 3c 08 00 0f 85 ed 08 00 00 49 8b 9c 24 38 01 00 00 48 89 ef 48 89 de e8 63 4a 04 00 48 39 dd 0f 84 dd ef ff ff e8 e5 46 04 00 <0f> 0b e9 d1 ef ff ff e8 d9 46 04 00 e8 b4 a5 ef ff e8 cf 46 04 00
RSP: 0018:ffffc90003acfb18 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
RDX: ffff88801e193a00 RSI: ffffffff81740f0b RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000000000000003 R09: ffffffff8fdeca17
R10: ffffffff81740efd R11: 0000000000000001 R12: ffff888074f2e000
R13: ffff888074f2e054 R14: ffff888074f2e138 R15: 0000000000000000
FS:  00007fee62f33700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcf8240960 CR3: 0000000072ae3000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 cgroup_file_write+0x1de/0x760 kernel/cgroup/cgroup.c:3877
 kernfs_fop_write_iter+0x342/0x500 fs/kernfs/file.c:296
 call_write_iter include/linux/fs.h:2086 [inline]
 new_sync_write+0x431/0x660 fs/read_write.c:503
 vfs_write+0x7cd/0xae0 fs/read_write.c:590
 ksys_write+0x12d/0x250 fs/read_write.c:643
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7fee62f82b79
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 b1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fee62f33308 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007fee6300c4c8 RCX: 00007fee62f82b79
RDX: 0000000000000001 RSI: 0000000020000080 RDI: 0000000000000006
RBP: 00007fee6300c4c0 R08: 0000000000000012 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fee6300c4cc
R13: 00007fee62fd92b0 R14: 6d2e746573757063 R15: 0000000000022000
 </TASK>

