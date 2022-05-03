Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02F6F517E0D
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 09:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbiECHKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 03:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbiECHJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 03:09:59 -0400
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9B32A737
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 00:06:27 -0700 (PDT)
Received: by mail-io1-f72.google.com with SMTP id 204-20020a6b01d5000000b00657bb7a0f33so10285370iob.4
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 00:06:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CitJ2jAIqYvqUc9ni5kUYdgty2ChYsOADDS45Ei2Eac=;
        b=XxP5w6EkwLJvtejsI9BBRUzeSUGymJ/ka/Nse15e27wWS3CKr2rS7wjyNh1/5D1IHE
         MkXc279faUNcVPlHglteqNGLqwvrqupv48wcP8Wco7enGn8mkgH9NdmPH+e5oYgVZ/eL
         1NmLprQiyWqsuKVWFCsPZLWgKu2izVeTwoVzfK/eLLWIeBtjcRGMHdnASnQffDwIlcOZ
         Gk4Wo44xxOZG8fSmzQcG/T1eZNPZDlBAG5aJ4kuZztucyvAiwxYEYLLdX7b6Tp+qOR6V
         6IycLZj7S16rVnHPh4Uz074xm9wwJ60LALVcDeXvi0uJDjewh7FyeJIaQEWJvb/OvdGv
         Qjiw==
X-Gm-Message-State: AOAM532uegT1lzPjXZjpo0/Os+zFFXREM+JeGtZKGgy4lPLcFY5OcQP1
        nV0Ul2/fWzCeS7cotyUN/sEBHqV/MqAFhXHX1q0eHh8vJKwp
X-Google-Smtp-Source: ABdhPJyUiKVWB9F68ylOJOw81KBHZ/vUOjCHaezWuOkXL34CuGFOWMvNH9d3Tx2ovlFiOBwOHvgz6khC2TMiN5Hmn6xhPnsadMRf
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1392:b0:32b:8496:2c83 with SMTP id
 w18-20020a056638139200b0032b84962c83mr476408jad.136.1651561587282; Tue, 03
 May 2022 00:06:27 -0700 (PDT)
Date:   Tue, 03 May 2022 00:06:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bc1eab05de1625c4@google.com>
Subject: [syzbot] KASAN: global-out-of-bounds Read in mac802154_header_create
From:   syzbot <syzbot+f4751c2cc423e56e9e79@syzkaller.appspotmail.com>
To:     alex.aring@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        stefan@datenfreihafen.org, syzkaller-bugs@googlegroups.com
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

Hello,

syzbot found the following issue on:

HEAD commit:    8f4dd16603ce Merge branch 'akpm' (patches from Andrew)
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=110ecc12f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d21a72f6016e37e8
dashboard link: https://syzkaller.appspot.com/bug?extid=f4751c2cc423e56e9e79
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+f4751c2cc423e56e9e79@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: global-out-of-bounds in get_unaligned_be64 include/asm-generic/unaligned.h:67 [inline]
BUG: KASAN: global-out-of-bounds in ieee802154_be64_to_le64 include/net/mac802154.h:367 [inline]
BUG: KASAN: global-out-of-bounds in mac802154_header_create+0x4f6/0x530 net/mac802154/iface.c:455
Read of size 8 at addr ffffffff8a597460 by task dhcpcd/3342

CPU: 3 PID: 3342 Comm: dhcpcd Not tainted 5.18.0-rc4-syzkaller-00064-g8f4dd16603ce #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xf/0x467 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 get_unaligned_be64 include/asm-generic/unaligned.h:67 [inline]
 ieee802154_be64_to_le64 include/net/mac802154.h:367 [inline]
 mac802154_header_create+0x4f6/0x530 net/mac802154/iface.c:455
 dev_hard_header include/linux/netdevice.h:2983 [inline]
 vlan_dev_hard_header+0x13d/0x510 net/8021q/vlan_dev.c:82
 dev_hard_header include/linux/netdevice.h:2983 [inline]
 lapbeth_data_transmit+0x29f/0x350 drivers/net/wan/lapbether.c:257
 lapb_data_transmit+0x8f/0xc0 net/lapb/lapb_iface.c:447
 lapb_transmit_buffer+0x183/0x390 net/lapb/lapb_out.c:149
 lapb_send_control+0x1c7/0x370 net/lapb/lapb_subr.c:251
 lapb_establish_data_link+0xe7/0x110 net/lapb/lapb_out.c:163
 lapb_device_event+0x395/0x560 net/lapb/lapb_iface.c:512
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1938
 call_netdevice_notifiers_extack net/core/dev.c:1976 [inline]
 call_netdevice_notifiers net/core/dev.c:1990 [inline]
 __dev_notify_flags+0x110/0x2b0 net/core/dev.c:8471
 dev_change_flags+0x112/0x170 net/core/dev.c:8509
 devinet_ioctl+0x15d1/0x1ca0 net/ipv4/devinet.c:1148
 inet_ioctl+0x1e6/0x320 net/ipv4/af_inet.c:969
 sock_do_ioctl+0xcc/0x230 net/socket.c:1122
 sock_ioctl+0x2f1/0x640 net/socket.c:1239
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl fs/ioctl.c:856 [inline]
 __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f934e09d0e7
Code: 3c 1c e8 1c ff ff ff 85 c0 79 87 49 c7 c4 ff ff ff ff 5b 5d 4c 89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 b8 10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 61 9d 0c 00 f7 d8 64 89 01 48
RSP: 002b:00007ffc98450468 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f934dfaf6c8 RCX: 00007f934e09d0e7
RDX: 00007ffc98460658 RSI: 0000000000008914 RDI: 0000000000000008
RBP: 00007ffc98470808 R08: 00007ffc98460618 R09: 00007ffc984605c8
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc98460658 R14: 0000000000000028 R15: 0000000000008914
 </TASK>

The buggy address belongs to the variable:
 bcast_addr+0x0/0x14a0

Memory state around the buggy address:
 ffffffff8a597300: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffffffff8a597380: 00 00 00 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9 f9
>ffffffff8a597400: 00 00 00 00 00 00 f9 f9 f9 f9 f9 f9 06 f9 f9 f9
                                                       ^
 ffffffff8a597480: f9 f9 f9 f9 00 00 00 00 00 06 f9 f9 f9 f9 f9 f9
 ffffffff8a597500: 03 f9 f9 f9 f9 f9 f9 f9 00 00 00 00 00 f9 f9 f9
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
