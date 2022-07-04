Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 361B1565745
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 15:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbiGDNcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 09:32:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234810AbiGDNbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 09:31:45 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0E112A8B
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 06:27:30 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id l4-20020a056e021aa400b002dab8f7402dso4220881ilv.18
        for <netdev@vger.kernel.org>; Mon, 04 Jul 2022 06:27:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=ig3N5oa/JeW9dpkx21ieU8vJNyRfJLsRn6DNkb8uyyw=;
        b=SM+okx9YjapBRnGkcz7tcLx+kxfgqJlpDncFZKF8R8H+cq0pj7qtxZLV2DXqmXbi1y
         2Li0MaPEaJBsq7C8hS0zGXA4Ik7UCp0FGATbtSIqubCrgwps0MW5LaABkZBs+mYkhRYi
         C34Wd/Q1A1bpyVTvFQN8LVGYG0iyWIKd16YNV/65HEuwRwiLGrHuOv2jGZLZ++Jg4Fyy
         xkajGL2cGSbZLJgbpWGiyMc8UhpSJYBC1Z6k6SrGvHpQCymdy+yGrS5/OcREV7f05RKh
         G312MU9C1ZsgBF4j9iyMGZgkScuNQ+J+dDqjoaJK+kJdL/RWmhUEUSXhyQIFntM45Btu
         L84g==
X-Gm-Message-State: AJIora/0CDk+nz8u3Zl96JlAC6K+GCdk8picSKC1t5aQfZves1DqGC0t
        cFOK8iHU33HmQVr2VCYX5O04ZCt+vPthC6qbgmjM63U7yLnl
X-Google-Smtp-Source: AGRyM1sdb1ILg6yFadU/DZOjhPMGOsGkQblRXKk6i9TDhISOJ67Zy1GyBtwafJ240VElGAnVIPVr0wmTaAMxSjaGceeHsSKnYBw4
MIME-Version: 1.0
X-Received: by 2002:a5d:9919:0:b0:675:48c7:d959 with SMTP id
 x25-20020a5d9919000000b0067548c7d959mr15771702iol.27.1656941250080; Mon, 04
 Jul 2022 06:27:30 -0700 (PDT)
Date:   Mon, 04 Jul 2022 06:27:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000009ff60505e2fab2e6@google.com>
Subject: [syzbot] KMSAN: uninit-value in ethnl_set_linkmodes (2)
From:   syzbot <syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, glider@google.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com
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

HEAD commit:    4b28366af7d9 x86: kmsan: enable KMSAN builds for x86
git tree:       https://github.com/google/kmsan.git master
console output: https://syzkaller.appspot.com/x/log.txt?x=169d3317f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d14e10a167d1c585
dashboard link: https://syzkaller.appspot.com/bug?extid=ef6edd9f1baaa54d6235
compiler:       clang version 15.0.0 (https://github.com/llvm/llvm-project.git 610139d2d9ce6746b3c617fb3e2f7886272d26ff), GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ef6edd9f1baaa54d6235@syzkaller.appspotmail.com

=====================================================
BUG: KMSAN: uninit-value in ethnl_update_u32 net/ethtool/netlink.h:81 [inline]
BUG: KMSAN: uninit-value in ethnl_update_linkmodes net/ethtool/linkmodes.c:295 [inline]
BUG: KMSAN: uninit-value in ethnl_set_linkmodes+0x1469/0x2270 net/ethtool/linkmodes.c:344
 ethnl_update_u32 net/ethtool/netlink.h:81 [inline]
 ethnl_update_linkmodes net/ethtool/linkmodes.c:295 [inline]
 ethnl_set_linkmodes+0x1469/0x2270 net/ethtool/linkmodes.c:344
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x103f/0x1260 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x3a5/0x6c0 net/netlink/af_netlink.c:2501
 genl_rcv+0x3c/0x50 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xabc/0xe90 net/socket.c:2492
 ___sys_sendmsg+0x2a5/0x350 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Uninit was stored to memory at:
 tun_get_link_ksettings+0x3e/0x60 drivers/net/tun.c:3515
 __ethtool_get_link_ksettings+0x181/0x270 net/ethtool/ioctl.c:461
 ethnl_set_linkmodes+0x57c/0x2270 net/ethtool/linkmodes.c:338
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x103f/0x1260 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x3a5/0x6c0 net/netlink/af_netlink.c:2501
 genl_rcv+0x3c/0x50 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xabc/0xe90 net/socket.c:2492
 ___sys_sendmsg+0x2a5/0x350 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Uninit was stored to memory at:
 tun_set_link_ksettings+0x3e/0x60 drivers/net/tun.c:3524
 ethtool_set_link_ksettings+0x607/0x6a0 net/ethtool/ioctl.c:628
 __dev_ethtool net/ethtool/ioctl.c:2997 [inline]
 dev_ethtool+0x1862/0x2600 net/ethtool/ioctl.c:3051
 dev_ioctl+0x369/0x1020 net/core/dev_ioctl.c:524
 sock_do_ioctl+0x295/0x540 net/socket.c:1183
 sock_ioctl+0x556/0xc90 net/socket.c:1286
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:870 [inline]
 __se_sys_ioctl+0x222/0x400 fs/ioctl.c:856
 __x64_sys_ioctl+0x92/0xd0 fs/ioctl.c:856
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0

Local variable link_ksettings created at:
 ethtool_set_link_ksettings+0x54/0x6a0 net/ethtool/ioctl.c:596
 __dev_ethtool net/ethtool/ioctl.c:2997 [inline]
 dev_ethtool+0x1862/0x2600 net/ethtool/ioctl.c:3051

CPU: 0 PID: 20786 Comm: syz-executor.2 Not tainted 5.19.0-rc3-syzkaller-30868-g4b28366af7d9 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
=====================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
