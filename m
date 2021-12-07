Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C3F46AFA1
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 02:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350378AbhLGBW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 20:22:56 -0500
Received: from mail-io1-f69.google.com ([209.85.166.69]:44770 "EHLO
        mail-io1-f69.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344950AbhLGBWw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 20:22:52 -0500
Received: by mail-io1-f69.google.com with SMTP id 7-20020a6b0107000000b005ed196a2546so11053978iob.11
        for <netdev@vger.kernel.org>; Mon, 06 Dec 2021 17:19:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=RNWsgHOIVkueubYtTOcBqWUSmrjChqsKpkIh8nTQqD0=;
        b=AJk1DyUpkTjDvmG3IckoLg3jj3txWEBwr25p2evktNQuq5MWREGCC8h9wpB8l/Jqcr
         nzg9uE/L+mqlv2rcGpQUUM2Iz1COFCDjz+IgrMH1k0Mltwll7Gn/McvxZJEXF6bFeX9k
         8O9d6uI6HcvNT+x6jqKhQTHXYEaRQczLa/ynB9w3gQyrNxV8niseYCjeCIiuGwp9V8il
         Jn6L6bpYoee+8ivUFMpBBotNeM52kr6cDk3ufdg0k7rbWwhCNuUxKKvuRv39aeXv9/3c
         RA3Q+ZtrDewOrNg3d8ZVIOHIOoFidmj098qf6FC3ZKtyNcPQiU7QTjnQBRSB2Z2s36g0
         8S5w==
X-Gm-Message-State: AOAM530vhU8vxzEogeBjeRNViIXCbeRdig5Roy1laZh4yb50D1e0te/3
        LI6sEOH2k8XytRag7zOUFCnTYi3XMecbgLYWoSjgBDAk3Lut
X-Google-Smtp-Source: ABdhPJxdDyfWyaO0SpGY1WG4kiAxauk2bK+AuDHqSYOiC0mKBl/gGIE8myysqrcePWg0VnwEmSfdJHoYqOyIHPslLx7n/vY+cqLE
MIME-Version: 1.0
X-Received: by 2002:a92:bf0d:: with SMTP id z13mr2183487ilh.315.1638839962436;
 Mon, 06 Dec 2021 17:19:22 -0800 (PST)
Date:   Mon, 06 Dec 2021 17:19:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ce0a9f05d28429a4@google.com>
Subject: [syzbot] divide error in mac80211_hwsim_config
From:   syzbot <syzbot+befa3d613df263396a0c@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        kvalo@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    fc993be36f9e Merge git://git.kernel.org/pub/scm/linux/kern..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=147b18c5b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b5949d4891208a1b
dashboard link: https://syzkaller.appspot.com/bug?extid=befa3d613df263396a0c
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+befa3d613df263396a0c@syzkaller.appspotmail.com

divide error: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 5890 Comm: syz-executor.0 Not tainted 5.16.0-rc3-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:mac80211_hwsim_config+0x7fd/0xdb0 drivers/net/wireless/mac80211_hwsim.c:1957
Code: 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 11 00 0f 85 1a 03 00 00 48 8b b5 08 3d 00 00 48 8d bd a8 3d 00 00 31 d2 89 f1 <48> f7 f1 29 d6 b9 05 00 00 00 31 d2 48 69 f6 e8 03 00 00 e8 db a8
RSP: 0018:ffffc9000281fac0 EFLAGS: 00010246
RAX: 0005d233ac620269 RBX: ffff8880795fb2e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880795ff088
RBP: ffff8880795fb2e0 R08: 000000000006cc08 R09: ffffffff8ff7ca67
R10: ffffffff8167b17f R11: 0000000000000036 R12: ffff8880795fefe8
R13: ffff8880795f8da0 R14: 1ffff92000503f6a R15: 0000000000000014
FS:  00007f8fcd540700(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2c820000 CR3: 00000000249cd000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 drv_config net/mac80211/driver-ops.h:145 [inline]
 ieee80211_hw_config+0x840/0x1480 net/mac80211/main.c:181
 ieee80211_set_wiphy_params+0x4d7/0xdb0 net/mac80211/cfg.c:2688
 rdev_set_wiphy_params+0x125/0x390 net/wireless/rdev-ops.h:569
 cfg80211_wext_siwretry net/wireless/wext-compat.c:369 [inline]
 __cfg80211_wext_siwretry+0x2c6/0x5d0 net/wireless/wext-compat.c:1584
 ioctl_standard_call+0xcd/0x1f0 net/wireless/wext-core.c:1017
 wireless_process_ioctl+0xc8/0x4c0 net/wireless/wext-core.c:955
 wext_ioctl_dispatch net/wireless/wext-core.c:988 [inline]
 wext_ioctl_dispatch net/wireless/wext-core.c:976 [inline]
 wext_handle_ioctl+0x26b/0x280 net/wireless/wext-core.c:1049
 sock_ioctl+0x285/0x640 net/socket.c:1169
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8fcffcaae9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8fcd540188 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f8fd00ddf60 RCX: 00007f8fcffcaae9
RDX: 0000000020000000 RSI: 0000000000008b28 RDI: 0000000000000005
RBP: 00007f8fd0024f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd1c29a66f R14: 00007f8fcd540300 R15: 0000000000022000
 </TASK>
Modules linked in:
---[ end trace 7b3003b6289f2375 ]---
RIP: 0010:mac80211_hwsim_config+0x7fd/0xdb0 drivers/net/wireless/mac80211_hwsim.c:1957
Code: 48 ba 00 00 00 00 00 fc ff df 48 c1 e9 03 80 3c 11 00 0f 85 1a 03 00 00 48 8b b5 08 3d 00 00 48 8d bd a8 3d 00 00 31 d2 89 f1 <48> f7 f1 29 d6 b9 05 00 00 00 31 d2 48 69 f6 e8 03 00 00 e8 db a8
RSP: 0018:ffffc9000281fac0 EFLAGS: 00010246
RAX: 0005d233ac620269 RBX: ffff8880795fb2e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8880795ff088
RBP: ffff8880795fb2e0 R08: 000000000006cc08 R09: ffffffff8ff7ca67
R10: ffffffff8167b17f R11: 0000000000000036 R12: ffff8880795fefe8
R13: ffff8880795f8da0 R14: 1ffff92000503f6a R15: 0000000000000014
FS:  00007f8fcd540700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fdba49e7012 CR3: 00000000249cd000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
----------------
Code disassembly (best guess):
   0:	48 ba 00 00 00 00 00 	movabs $0xdffffc0000000000,%rdx
   7:	fc ff df
   a:	48 c1 e9 03          	shr    $0x3,%rcx
   e:	80 3c 11 00          	cmpb   $0x0,(%rcx,%rdx,1)
  12:	0f 85 1a 03 00 00    	jne    0x332
  18:	48 8b b5 08 3d 00 00 	mov    0x3d08(%rbp),%rsi
  1f:	48 8d bd a8 3d 00 00 	lea    0x3da8(%rbp),%rdi
  26:	31 d2                	xor    %edx,%edx
  28:	89 f1                	mov    %esi,%ecx
* 2a:	48 f7 f1             	div    %rcx <-- trapping instruction
  2d:	29 d6                	sub    %edx,%esi
  2f:	b9 05 00 00 00       	mov    $0x5,%ecx
  34:	31 d2                	xor    %edx,%edx
  36:	48 69 f6 e8 03 00 00 	imul   $0x3e8,%rsi,%rsi
  3d:	e8                   	.byte 0xe8
  3e:	db                   	.byte 0xdb
  3f:	a8                   	.byte 0xa8


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
