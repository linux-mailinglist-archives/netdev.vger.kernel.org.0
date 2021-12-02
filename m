Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D2E1466DFF
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 00:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377605AbhLBXup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 18:50:45 -0500
Received: from mail-io1-f71.google.com ([209.85.166.71]:38591 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349609AbhLBXup (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 18:50:45 -0500
Received: by mail-io1-f71.google.com with SMTP id l124-20020a6b3e82000000b005ed165a1506so926013ioa.5
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 15:47:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ARLQXRQ3vGLI5tqgE5JCO+5Ssy6hqYcNjGBxU79YdC0=;
        b=J2m2rD5nwUCDOFaMX7RozXong9WClq1eMU+uei791bhrqpe+OOhJfv7k+5G3qWdT5t
         3eParhe9/+kPCOuAB07IvoGyQidLJGZ3Vj6lHCxjmzleCiRo01n7EOannrI6TFUYKAXw
         MSI8pfL6k33OxwBeuHvrm5QsiTj1E0NMPaZVKeqiDNoeuI1F5UrZ1u8NmXFqBwlnZBuc
         q5AgggYQpapeNyaDazQamRxEe+PW3fllBi+a00MC8dClfFjw5ZTSWTNA7tu/SvF9vPxQ
         h/u51hkcBlx5Wf67Hy33MhH69eHUXwYKaeEUJwH8pGIJuF3c2dgHLV+r9lbI49hlJE/k
         ZIqQ==
X-Gm-Message-State: AOAM530besO+mfdUf8bc8/WipT7zszKgwr8FLFDGn6MA/IMpBstUxdn4
        iHlgtDIQ+8URlj32IA2txhtYNr92AuaT21wj2lKNDxNxcHXJ
X-Google-Smtp-Source: ABdhPJyfueGHO8wx+XsXa2i6YsfNSgD5OYIf+nn4DzEx4Vj1Ba2fFuSDCGZniCHXxs3xeE68mbs2NZqiQaPAdTj2y3+9XdQ+Eog7
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c83:: with SMTP id i3mr18453619iow.54.1638488841849;
 Thu, 02 Dec 2021 15:47:21 -0800 (PST)
Date:   Thu, 02 Dec 2021 15:47:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000630d8505d2326961@google.com>
Subject: [syzbot] WARNING in rtl92cu_hw_init
From:   syzbot <syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com>
To:     davem@davemloft.net, kuba@kernel.org, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        pkshih@realtek.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    c4bc515d73b5 usb: dwc2: gadget: use existing helper
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=12c7d311b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1fa54650ce78e6dc
dashboard link: https://syzkaller.appspot.com/bug?extid=cce1ee31614c171f5595
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+cce1ee31614c171f5595@syzkaller.appspotmail.com

------------[ cut here ]------------
raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 1 PID: 1206 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Modules linked in:
CPU: 1 PID: 1206 Comm: dhcpcd Not tainted 5.16.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:warn_bogus_irq_restore+0x1d/0x20 kernel/locking/irqflag-debug.c:10
Code: d3 ff cc cc cc cc cc cc cc cc cc cc cc 80 3d e7 4e dc 02 00 74 01 c3 48 c7 c7 a0 85 27 86 c6 05 d6 4e dc 02 01 e8 fd 13 d3 ff <0f> 0b c3 44 8b 05 75 05 e7 02 55 53 65 48 8b 1c 25 80 6f 02 00 45
RSP: 0018:ffffc90000f0f6a8 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000000
RDX: ffff8881100f1c00 RSI: ffffffff812bae78 RDI: fffff520001e1ec7
RBP: 0000000000000200 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff812b4c4e R11: 0000000000000000 R12: ffff88814b2047c0
R13: 0000000000000000 R14: 0000000000000000 R15: 00000000ffffffff
FS:  00007f0d4252e740(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fd8c7ba7718 CR3: 0000000117bd2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 rtl92cu_hw_init.cold+0x119f/0x34c5 drivers/net/wireless/realtek/rtlwifi/rtl8192cu/hw.c:1003
 rtl_usb_start+0xaf/0x740 drivers/net/wireless/realtek/rtlwifi/usb.c:743
 rtl_op_start+0x139/0x1b0 drivers/net/wireless/realtek/rtlwifi/core.c:140
 drv_start+0x168/0x440 net/mac80211/driver-ops.c:23
 ieee80211_do_open+0xae4/0x2430 net/mac80211/iface.c:1125
 ieee80211_open net/mac80211/iface.c:362 [inline]
 ieee80211_open+0x1a0/0x240 net/mac80211/iface.c:348
 __dev_open+0x2bc/0x4d0 net/core/dev.c:1490
 __dev_change_flags+0x583/0x750 net/core/dev.c:8793
 dev_change_flags+0x93/0x170 net/core/dev.c:8864
 devinet_ioctl+0x15d1/0x1ca0 net/ipv4/devinet.c:1144
 inet_ioctl+0x1e6/0x320 net/ipv4/af_inet.c:969
 sock_do_ioctl+0xcc/0x230 net/socket.c:1118
 sock_ioctl+0x2f1/0x640 net/socket.c:1235
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:874 [inline]
 __se_sys_ioctl fs/ioctl.c:860 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:860
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f0d4261c0e7
Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 61 9d 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffcb59c0a08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f0d4252e6c8 RCX: 00007f0d4261c0e7
RDX: 00007ffcb59d0bf8 RSI: 0000000000008914 RDI: 0000000000000005
RBP: 00007ffcb59e0da8 R08: 00007ffcb59d0bb8 R09: 00007ffcb59d0b68
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffcb59d0bf8 R14: 0000000000000028 R15: 0000000000008914
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
