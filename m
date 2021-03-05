Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E06E632DE36
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 01:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231659AbhCEAEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 19:04:21 -0500
Received: from mail-io1-f72.google.com ([209.85.166.72]:47306 "EHLO
        mail-io1-f72.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231536AbhCEAET (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 19:04:19 -0500
Received: by mail-io1-f72.google.com with SMTP id o4so404981ioh.14
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 16:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=bqLq8lEZAr3udvWoJ5bAlwyE7Hbzc7Aau7j02WMMyZQ=;
        b=NqIJvNK7mGfM9djrcFJ8hAy1a07XGayyBBMy9P46hgV6KUkVhktjXHXZ0ryG2op2qM
         X6/bOkod93PUOLYCYkjCZPKktbo6ycCHAOz/sTV7iLLEgX3DPSjVSNR97uBUoVqgil9e
         iraH7Us6wHx+gZXk6qQFwmZX6yoyX9bHMkCtk9vywIiaaD5uOs3zsQTUuAKTJTWxk4m7
         fVPsz4EpCEf38bak51RaCPHGH6eNN/mY9BAS8SA5B06nlmwcp8MTeBrdWz2ydrMcloLs
         ddcEIlhMJTUJB8Tt5nmPqipJ4z51OqHDzID3i4clgI48+ev4pdl2a1LjO7rQydnHuoUN
         Hikg==
X-Gm-Message-State: AOAM533hAHOyzjMnusu5SXVXQ/Q+u0arAIPT+UhtM8DByztbC6rPDpMZ
        i9jzgP/K5BKFTHsEMERJiBXWD6n28vjGQSWOgKx5yzd2Wz4v
X-Google-Smtp-Source: ABdhPJyZ7X1PN5WYLX+tIw1Zbs+iVyIUGLXs1ez5SRC8FYFFL2+T/5vm5avVf1e1dadgDVcjILLDvy61otGySSFxz5gWtMQsnXWC
MIME-Version: 1.0
X-Received: by 2002:a5e:980e:: with SMTP id s14mr3880359ioj.63.1614902658921;
 Thu, 04 Mar 2021 16:04:18 -0800 (PST)
Date:   Thu, 04 Mar 2021 16:04:18 -0800
In-Reply-To: <0000000000009b387305bc00fda6@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000054fbc005bcbed38f@google.com>
Subject: Re: WARNING in ieee802154_get_llsec_params
From:   syzbot <syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, stefan@datenfreihafen.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    f5427c24 Add linux-next specific files for 20210304
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=12bb4ff2d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a7876f68bf0bea99
dashboard link: https://syzkaller.appspot.com/bug?extid=cde43a581a8e5f317bc2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=124c7b46d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1276f5b0d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cde43a581a8e5f317bc2@syzkaller.appspotmail.com

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic != lock)
WARNING: CPU: 1 PID: 8406 at kernel/locking/mutex.c:928 __mutex_lock_common kernel/locking/mutex.c:928 [inline]
WARNING: CPU: 1 PID: 8406 at kernel/locking/mutex.c:928 __mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1093
Modules linked in:
CPU: 1 PID: 8406 Comm: syz-executor446 Not tainted 5.12.0-rc1-next-20210304-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:928 [inline]
RIP: 0010:__mutex_lock+0xc0b/0x1120 kernel/locking/mutex.c:1093
Code: 08 84 d2 0f 85 a3 04 00 00 8b 05 98 77 c0 04 85 c0 0f 85 12 f5 ff ff 48 c7 c6 00 85 6b 89 48 c7 c7 c0 82 6b 89 e8 ed be bc ff <0f> 0b e9 f8 f4 ff ff 65 48 8b 1c 25 00 f0 01 00 be 08 00 00 00 48
RSP: 0018:ffffc9000163f258 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff88801e509c00 RSI: ffffffff815bc1b5 RDI: fffff520002c7e3d
RBP: ffff8880220e0c90 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815b528e R11: 0000000000000000 R12: 0000000000000000
R13: dffffc0000000000 R14: ffffffff8a8a8200 R15: 0000000000000000
FS:  0000000001676300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffc942cffac CR3: 0000000020f9b000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee802154_get_llsec_params+0x3f/0x70 net/mac802154/cfg.c:321
 rdev_get_llsec_params net/ieee802154/rdev-ops.h:241 [inline]
 nl802154_get_llsec_params+0xce/0x390 net/ieee802154/nl802154.c:745
 nl802154_send_iface+0x7cf/0xa70 net/ieee802154/nl802154.c:823
 nl802154_get_interface+0xeb/0x230 net/ieee802154/nl802154.c:889
 genl_family_rcv_msg_doit+0x228/0x320 net/netlink/genetlink.c:739
 genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
 genl_rcv_msg+0x328/0x580 net/netlink/genetlink.c:800
 netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
 genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
 netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
 netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
 netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
 sock_sendmsg_nosec net/socket.c:654 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:674
 ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
 ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
 __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x440899
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 14 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe18370df8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00000000000107cf RCX: 0000000000440899
RDX: 0000000000000000 RSI: 0000000020000300 RDI: 0000000000000005
RBP: 0000000000000000 R08: 00007ffe18370f98 R09: 00007ffe18370f98
R10: 00007ffe18370f98 R11: 0000000000000246 R12: 00007ffe18370e0c
R13: 431bde82d7b634db R14: 00000000004ae018 R15: 00000000004004a0

