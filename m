Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69649307BC1
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 18:08:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhA1RGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 12:06:25 -0500
Received: from mail-il1-f199.google.com ([209.85.166.199]:43802 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232797AbhA1RAH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 12:00:07 -0500
Received: by mail-il1-f199.google.com with SMTP id b4so5213688ilj.10
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 08:59:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=KCxuXpW8R77Zz40AefQtdqEAsY8KYOrUeobt3QS3Auk=;
        b=nAeflsmZOrkNFa/XPvJzSZgZaDoKe7vwrXzhoZjdFREjLQKX5XJ+FHJKF0kcOUhE1Q
         Q32LRvfyVASdALFsDkV8Ve/tUnrSMKLaDTJVDCZqz3GdU0Tm9SaI+0JTSY2gQFbV/a2u
         ju31o5UD1fq941IQZpY7bNCC+Dt/RtWR5Wt/Df8YvkSXSSVaB9TpWstiXBmFd289MzZ0
         /gLT3lBg1dW7LJU/hgSjLRxkn5EGfV6nnYca9YiUANo+v3mWHDOypUqHp2bvk9Ui42BU
         4YwOWXCUX2yoo3iwNpRmgYHokIrdyLN0hMdZfU4HFiFP7OJj/shfFxGlXEUSoi0s++0x
         s80Q==
X-Gm-Message-State: AOAM532L51n1+tClRMqwTfmpvTCx0bJu1JCPEFv2HxmNMnmrhso4cSZC
        Zz52Zg229SZebKp8RdMfB0Jjxd5OUYoDhgFKm3D2owE98+Nz
X-Google-Smtp-Source: ABdhPJwPuJGFwW9q1TkEHg3vEnYlx77j4KXqhorm7ZVBjw4xHGo7ShMw65AELWp+9Op3iTJCGE29h444p6NSycZCgnWbQiUCBL2A
MIME-Version: 1.0
X-Received: by 2002:a05:6638:164c:: with SMTP id a12mr180854jat.128.1611853166198;
 Thu, 28 Jan 2021 08:59:26 -0800 (PST)
Date:   Thu, 28 Jan 2021 08:59:26 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000066c54105b9f8cf2b@google.com>
Subject: WARNING in cfg80211_change_iface
From:   syzbot <syzbot+d2d412349f88521938aa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    d1f3bdd4 net: dsa: rtl8366rb: standardize init jam tables
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=14977d10d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5f48fca2e44a9a2
dashboard link: https://syzkaller.appspot.com/bug?extid=d2d412349f88521938aa
compiler:       gcc (GCC) 10.1.0-syz 20200507

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2d412349f88521938aa@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 28772 at net/wireless/util.c:1013 cfg80211_change_iface+0xa10/0xf30 net/wireless/util.c:1013
Modules linked in:
CPU: 1 PID: 28772 Comm: syz-executor.2 Not tainted 5.11.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cfg80211_change_iface+0xa10/0xf30 net/wireless/util.c:1013
Code: 8d bd e8 05 00 00 be ff ff ff ff e8 2a b4 c5 00 31 ff 41 89 c6 89 c6 e8 2e 72 3d f9 45 85 f6 0f 85 b4 f6 ff ff e8 a0 6a 3d f9 <0f> 0b e9 a8 f6 ff ff e8 94 6a 3d f9 65 ff 05 7d 8e cc 77 48 c7 c0
RSP: 0018:ffffc9000116fbb8 EFLAGS: 00010216
RAX: 0000000000008319 RBX: ffff888017128000 RCX: ffffc9000d850000
RDX: 0000000000040000 RSI: ffffffff88356130 RDI: 0000000000000003
RBP: ffff888054c40000 R08: 0000000000000000 R09: ffffc9000116fc30
R10: ffffffff88356122 R11: 0000000000000001 R12: 0000000000000001
R13: 0000000000000003 R14: 0000000000000000 R15: 0000000000000000
FS:  00007fa7b69e0700(0000) GS:ffff8880b9f00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000050d1b0 CR3: 0000000063569000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cfg80211_wext_siwmode net/wireless/wext-compat.c:64 [inline]
 __cfg80211_wext_siwmode+0x1bb/0x200 net/wireless/wext-compat.c:1559
 ioctl_standard_call+0xcd/0x1f0 net/wireless/wext-core.c:1016
 wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:954
 wext_ioctl_dispatch net/wireless/wext-core.c:987 [inline]
 wext_ioctl_dispatch net/wireless/wext-core.c:975 [inline]
 wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1048
 sock_ioctl+0x410/0x6a0 net/socket.c:1109
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x45e219
Code: 0d b4 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 db b3 fb ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007fa7b69dfc68 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 000000000045e219
RDX: 0000000020000040 RSI: 0000000000008b06 RDI: 0000000000000003
RBP: 000000000119bfc0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119bf8c
R13: 00007fff91257a9f R14: 00007fa7b69e09c0 R15: 000000000119bf8c


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
