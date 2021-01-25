Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C966B304ADD
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 22:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729343AbhAZEzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jan 2021 23:55:12 -0500
Received: from mail-pf1-f199.google.com ([209.85.210.199]:47136 "EHLO
        mail-pf1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727057AbhAYKBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 05:01:40 -0500
Received: by mail-pf1-f199.google.com with SMTP id q200so5952670pfc.14
        for <netdev@vger.kernel.org>; Mon, 25 Jan 2021 02:01:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=m8wT6/GYAr4kqq+Vd6zCqDzhuX6QAA8Z8W9ZsMMjKCE=;
        b=ZzbSQbQ4JBygL6i2uI9ZJP730Njd5SGgHsxFNrNXEqLBltPXubf1CNynAR9R3dWALO
         ifnR1ZuUuCq2orQx7o2Ltr8l1Cv06/Wo8/oURNBKPAObLV+PoVc44VDcNfWDfxd6PTzR
         cTMkItJdNVkFSCwXKUEji7w73TfEqcbf+3CCa6OynT5e4LNhGg3E12R/mX76Kc+bOBMZ
         ZmoQNxg+xvh5b+oCsSeSshxXfa5Hxvz6D7KONpYu0SqfO+i/nrZUCH9aMrz2QzGRem8l
         PySCpETsNwhuRQ6mvthXWUiQmIaci8Mb6QPvUTOYPia4I+ybfOHJqzZlBy3GoVcfm1c1
         POsw==
X-Gm-Message-State: AOAM533lEPcImzIIrMiUaevZOrqBfAuNbUKlHxZOhQ9/cMbLBRsRubCS
        U/vvPr1xAxeltZ/5bWgUlD+IYbCyg4pDcebC+Xlyet7a2sQQ
X-Google-Smtp-Source: ABdhPJweWOBaRR6+1DFNitHtqFYy1jDn+gBsR8Ey2l3LhOiuPFc+x9BnI+mWxs83IYguPYqtKj3hDzaPgfF61aAIqfwScP21KZff
MIME-Version: 1.0
X-Received: by 2002:a6b:e204:: with SMTP id z4mr3719ioc.28.1611568334421; Mon,
 25 Jan 2021 01:52:14 -0800 (PST)
Date:   Mon, 25 Jan 2021 01:52:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000001ac5af05b9b67e2d@google.com>
Subject: linux-next boot error: WARNING in cfg80211_register_netdevice
From:   syzbot <syzbot+2c4a63c6480a7457eca5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        sfr@canb.auug.org.au, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    59fa6a16 Add linux-next specific files for 20210125
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1647f4bf500000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae5f53cc82a45e0d
dashboard link: https://syzkaller.appspot.com/bug?extid=2c4a63c6480a7457eca5
compiler:       gcc (GCC) 10.1.0-syz 20200507

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2c4a63c6480a7457eca5@syzkaller.appspotmail.com

Rounding down aligned max_sectors from 4294967295 to 4294967288
db_root: cannot open: /etc/target
slram: not enough parameters.
ftl_cs: FTL header not found.
wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
eql: Equalizer2002: Simon Janes (simon@ncm.com) and David S. Miller (davem@redhat.com)
MACsec IEEE 802.1AE
libphy: Fixed MDIO Bus: probed
tun: Universal TUN/TAP device driver, 1.6
vcan: Virtual CAN interface driver
vxcan: Virtual CAN Tunnel driver
slcan: serial line CAN interface driver
slcan: 10 dynamic interface channels.
CAN device driver interface
usbcore: registered new interface driver usb_8dev
usbcore: registered new interface driver ems_usb
usbcore: registered new interface driver esd_usb2
usbcore: registered new interface driver gs_usb
usbcore: registered new interface driver kvaser_usb
usbcore: registered new interface driver mcba_usb
usbcore: registered new interface driver peak_usb
e100: Intel(R) PRO/100 Network Driver
e100: Copyright(c) 1999-2006 Intel Corporation
e1000: Intel(R) PRO/1000 Network Driver
e1000: Copyright (c) 1999-2006 Intel Corporation.
e1000e: Intel(R) PRO/1000 Network Driver
e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
mkiss: AX.25 Multikiss, Hans Albas PE1AYX
AX.25: 6pack driver, Revision: 0.3.0
AX.25: bpqether driver version 004
PPP generic driver version 2.4.2
PPP BSD Compression module registered
PPP Deflate Compression module registered
PPP MPPE Compression module registered
NET: Registered protocol family 24
PPTP driver version 0.8.5
SLIP: version 0.8.4-NET3.019-NEWTTY (dynamic channels, max=256) (6 bit encapsulation enabled).
CSLIP: code copyright 1989 Regents of the University of California.
SLIP linefill/keepalive option.
hdlc: HDLC support module revision 1.22
LAPB Ethernet driver version 0.02
usbcore: registered new interface driver ath9k_htc
usbcore: registered new interface driver carl9170
usbcore: registered new interface driver ath6kl_usb
usbcore: registered new interface driver ar5523
usbcore: registered new interface driver ath10k_usb
usbcore: registered new interface driver rndis_wlan
mac80211_hwsim: initializing netlink
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at net/wireless/core.c:1336 cfg80211_register_netdevice+0x235/0x330 net/wireless/core.c:1336
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.11.0-rc4-next-20210125-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:cfg80211_register_netdevice+0x235/0x330 net/wireless/core.c:1336
Code: f9 be ff ff ff ff bf e8 05 00 00 e8 95 e8 c6 00 31 ff 41 89 c4 89 c6 e8 89 99 3b f9 45 85 e4 0f 85 73 fe ff ff e8 fb 91 3b f9 <0f> 0b e8 f4 91 3b f9 48 85 ed 0f 85 6c fe ff ff e8 e6 91 3b f9 0f
RSP: 0000:ffffc90000c679a8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffffffff8d2511bc RCX: 0000000000000000
RDX: ffff888140758000 RSI: ffffffff88378355 RDI: 0000000000000003
RBP: ffff88801b408bd0 R08: 0000000000000000 R09: ffffffff8cc6c227
R10: ffffffff88378347 R11: 00000000ffff8000 R12: 0000000000000000
R13: ffff88801b408000 R14: ffff88801b40972c R15: ffff88801b408000
FS:  0000000000000000(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000b28e000 CR4: 00000000001506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ieee80211_if_add+0xfb8/0x18f0 net/mac80211/iface.c:1984
 ieee80211_register_hw+0x31dc/0x3c40 net/mac80211/main.c:1285
 mac80211_hwsim_new_radio+0x20d9/0x48d0 drivers/net/wireless/mac80211_hwsim.c:3333
 init_mac80211_hwsim+0x5d0/0x761 drivers/net/wireless/mac80211_hwsim.c:4550
 do_one_initcall+0x103/0x650 init/main.c:1226
 do_initcall_level init/main.c:1299 [inline]
 do_initcalls init/main.c:1315 [inline]
 do_basic_setup init/main.c:1335 [inline]
 kernel_init_freeable+0x605/0x689 init/main.c:1536
 kernel_init+0xd/0x1b8 init/main.c:1424
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:296


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
