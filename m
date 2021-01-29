Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7993084C6
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 05:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231979AbhA2E45 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jan 2021 23:56:57 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:45853 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbhA2E4x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jan 2021 23:56:53 -0500
Received: by mail-il1-f198.google.com with SMTP id h17so6649172ila.12
        for <netdev@vger.kernel.org>; Thu, 28 Jan 2021 20:56:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=5HJJHwoEpOZhCJ2Q8NMzhO+pVec1fTvP+K0SZl/lhmU=;
        b=og12GgErqyIPKCucCduLPbay6G2NdXGytuwcNcFI2iPkCkd1uo5QeYX5TtvWBfvw+E
         2+mQ46QHExUH4aA7PAQWfbigGd6V03HUSN8U1VsW+KGeaK2OqfsKg6z+Cs0SQ/ZYSUem
         Y/Z264txLxFeSqJtm35uv1VzKVl+/YtzJ3eTqe1/0PBquhviyu4v3Ck8MLAvVo6M2pwF
         CbBDkZuhrZzTKLio6Ir6zN75b/Tq+qBjUzmaxeHm3SBIT2TNUAJyGcEAhNXj/MdCgwZy
         qnYuLauoFNeDk+uYcFRLwQzzHPJdEMy/ub1EZbmLBGL93FMM/aPbqVBAEPo5CclLmkVJ
         7U5g==
X-Gm-Message-State: AOAM533mNdo5jvQiR8Aw7i14oaDD3NO046CEFHE2nGLPx8iZNr6MBpnK
        wSY5YM5R6irxH1qgZVRpNN4h2dCCGwbviEwuSboGJqn7WJB2
X-Google-Smtp-Source: ABdhPJz/Vq3nzt9CY51VeWeyBilYqIeTSmbpT3y6W5fowFqDd+Dd4x4kc6wrI7oS+2nOQhTUEAncGm2YBOpSE8sqqMB9ssXSLsY0
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:d42:: with SMTP id h2mr2276531ilj.204.1611896172699;
 Thu, 28 Jan 2021 20:56:12 -0800 (PST)
Date:   Thu, 28 Jan 2021 20:56:12 -0800
In-Reply-To: <00000000000066c54105b9f8cf2b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c9e8e505ba02d2a7@google.com>
Subject: Re: WARNING in cfg80211_change_iface
From:   syzbot <syzbot+d2d412349f88521938aa@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes.berg@intel.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    d03154e8 Add linux-next specific files for 20210128
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1243cbc8d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6953ffb584722a1
dashboard link: https://syzkaller.appspot.com/bug?extid=d2d412349f88521938aa
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10df256f500000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=166b17a4d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d2d412349f88521938aa@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 1 PID: 8420 at net/wireless/util.c:1013 cfg80211_change_iface+0xa10/0xf30 net/wireless/util.c:1013
Modules linked in:
CPU: 1 PID: 8420 Comm: syz-executor656 Not tainted 5.11.0-rc5-next-20210128-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cfg80211_change_iface+0xa10/0xf30 net/wireless/util.c:1013
Code: 8d bd e8 05 00 00 be ff ff ff ff e8 fa 22 c6 00 31 ff 41 89 c6 89 c6 e8 be bd 37 f9 45 85 f6 0f 85 b4 f6 ff ff e8 30 b6 37 f9 <0f> 0b e9 a8 f6 ff ff e8 24 b6 37 f9 65 ff 05 8d 90 c6 77 48 c7 c0
RSP: 0018:ffffc900017bfbb8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff8880178ac000 RCX: 0000000000000000
RDX: ffff88801fa53800 RSI: ffffffff883b5f20 RDI: 0000000000000003
RBP: ffff888021c50000 R08: 0000000000000000 R09: ffffc900017bfc30
R10: ffffffff883b5f12 R11: 0000000000000002 R12: 0000000000000002
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000002295880(0000) GS:ffff8880b9e00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcbcf59000 CR3: 0000000011147000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 cfg80211_wext_siwmode net/wireless/wext-compat.c:64 [inline]
 __cfg80211_wext_siwmode+0x1bb/0x200 net/wireless/wext-compat.c:1559
 ioctl_standard_call+0xcd/0x1f0 net/wireless/wext-core.c:1017
 wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
 wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
 wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
 wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
 sock_ioctl+0x410/0x6a0 net/socket.c:1111
 vfs_ioctl fs/ioctl.c:48 [inline]
 __do_sys_ioctl fs/ioctl.c:753 [inline]
 __se_sys_ioctl fs/ioctl.c:739 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
 do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
 entry_SYSCALL_64_after_hwframe+0x44/0xa9
RIP: 0033:0x441529
Code: e8 ec 05 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 8b 0d fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffd97527908 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007ffd97527930 RCX: 0000000000441529
RDX: 0000000020000000 RSI: 0000000000008b06 RDI: 0000000000000003
RBP: 0000000000000003 R08: 0000002200000000 R09: 0000002200000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000032
R13: 0000000000000000 R14: 000000000000000c R15: 0000000000000004

