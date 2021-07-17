Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99BC33CC4AC
	for <lists+netdev@lfdr.de>; Sat, 17 Jul 2021 19:02:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232663AbhGQRFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Jul 2021 13:05:18 -0400
Received: from mail-io1-f72.google.com ([209.85.166.72]:35746 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbhGQRFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Jul 2021 13:05:17 -0400
Received: by mail-io1-f72.google.com with SMTP id n13-20020a5ed90d0000b02904f43c8bffc4so8702810iop.2
        for <netdev@vger.kernel.org>; Sat, 17 Jul 2021 10:02:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=g90AgkTYuQUUbs5TFCFt3vuNOobqVkVvVWHJWrYPCBU=;
        b=LwGyU/TsQlNq/LAwrLnUSG1L2F12bAy9RztfN2wYNBl0Tqqqm/m2Uvh+Aq/BUhVt4M
         SGtJNyNBAm/5MNacxwzQmiiPE8KH02Qp2STAoCS5kgv5cenkM4IW5kaFzL7zK2ATkrkY
         uh72mEOKWs3sHltFHjzJtyvHO0GKYdjSyWWTzVUm0HLfec6vjy9vluOvRMkaPMPvUTaK
         sIji0FaJZzTaXCHZq6xbHZuQ+iHix52Jd66fw3c7EcAzY0jc2NRGILu/wZUY1BIi+9Yf
         QudAgkvacynCPQMM65woGKU75C+xtc1OsOV/fJtzlR8ZoHV2Ia+jdBHPDK6wMyVsV5cn
         SOOQ==
X-Gm-Message-State: AOAM530PtJqMHSV934pVfv2MXA6oW6cJQb0AifP0GLnKngKTw9mxDx/4
        era/Qzr/LMxsOW3F5UpXBqTWGrygJNnMygwBFwcjj2DygBy5
X-Google-Smtp-Source: ABdhPJx7+9PqoKXImXjFm6KstvJAgsBDS+pT1JNGVDWIoj1aPZ1KW1fCXc2biQRghmrh5ol8jUzizpeGfqdzPuTVOgpsRuIMF0JJ
MIME-Version: 1.0
X-Received: by 2002:a5e:8816:: with SMTP id l22mr6664377ioj.100.1626541340805;
 Sat, 17 Jul 2021 10:02:20 -0700 (PDT)
Date:   Sat, 17 Jul 2021 10:02:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000d4ce1205c754aa4c@google.com>
Subject: [syzbot] WARNING in remove_proc_entry (3)
From:   syzbot <syzbot+3405f46cf7078134383e@syzkaller.appspotmail.com>
To:     anna.schumaker@netapp.com, bfields@fieldses.org,
        chuck.lever@oracle.com, colin.king@canonical.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org,
        martijn.de.gouw@prodrive-technologies.com, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, trond.myklebust@hammerspace.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    7fef2edf7cc7 sd: don't mess with SD_MINORS for CONFIG_DEBU..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=147c3b3c300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=957eaf08bd3bb8d6
dashboard link: https://syzkaller.appspot.com/bug?extid=3405f46cf7078134383e

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+3405f46cf7078134383e@syzkaller.appspotmail.com

bond0 (unregistering): (slave bond_slave_0): Releasing backup interface
bond0 (unregistering): Released all slaves
------------[ cut here ]------------
name 'use-gss-proxy'
WARNING: CPU: 0 PID: 7951 at fs/proc/generic.c:709 remove_proc_entry+0x389/0x460 fs/proc/generic.c:709
Modules linked in:
CPU: 0 PID: 7951 Comm: kworker/u4:2 Tainted: G        W         5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: netns cleanup_net
RIP: 0010:remove_proc_entry+0x389/0x460 fs/proc/generic.c:709
Code: e9 6d fe ff ff e8 f7 d9 85 ff 48 c7 c7 20 d4 b3 8b e8 fb 96 3d 07 e8 e6 d9 85 ff 4c 89 e6 48 c7 c7 00 2a 9c 89 e8 92 86 f8 06 <0f> 0b e9 a4 fe ff ff e8 cb d9 85 ff 48 8d bd d8 00 00 00 48 b8 00
RSP: 0018:ffffc9000c8efb48 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 1ffff9200191df6b RCX: 0000000000000000
RDX: ffff8880341121c0 RSI: ffffffff815c9ca5 RDI: fffff5200191df5b
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815c3aae R11: 0000000000000000 R12: ffffffff8aa28e40
R13: dffffc0000000000 R14: ffff888000102000 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f38761a8740 CR3: 000000002c23a000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
Call Trace:
 destroy_use_gss_proxy_proc_entry net/sunrpc/auth_gss/svcauth_gss.c:1504 [inline]
 gss_svc_shutdown_net+0x196/0x8c0 net/sunrpc/auth_gss/svcauth_gss.c:1992
 ops_exit_list+0xb0/0x160 net/core/net_namespace.c:175
 cleanup_net+0x4ea/0xb10 net/core/net_namespace.c:595
 process_one_work+0x98d/0x1630 kernel/workqueue.c:2276
 worker_thread+0x658/0x11f0 kernel/workqueue.c:2422
 kthread+0x3e5/0x4d0 kernel/kthread.c:319
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
