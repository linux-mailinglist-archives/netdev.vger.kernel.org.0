Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3A9A610851
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 04:41:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236384AbiJ1Cll (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 22:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiJ1Clk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 22:41:40 -0400
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F899DDA1
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 19:41:39 -0700 (PDT)
Received: by mail-io1-f69.google.com with SMTP id bx19-20020a056602419300b006bcbf3b91fdso3125558iob.13
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 19:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=awXigRTWzy6BSQJsV32OYDv8G0LoVqiSVgNhrScYdpU=;
        b=tzo4EZJ0IF+n6BhxQ35rQ8qD3RHkJiFWXflRF6/mdzeQC6fx4CUzmO+8qkByFg6EKc
         RXjWLxSzpDQwZOofGCHjkOizpZo7Cu8MeHT0Dv2NJnRgKNv0quJAtCmysb59OF73gjEm
         2qsW0LCYNBIZPKOMJi/kdBYiccrZ7ucU8kq5LaAiP6yPao7XrXyIjuYhisLMa6gZ4/Dd
         MmHvl16msIpgsykbmj4SqVTySfHZnHND/g9z2CKxzvYnv0KiqufkdMGJ+ISfPsXDG4rj
         B1bcikcys6lB4YII2SCHALfBxoWn+xTWRhK4suPb6d2Oqtj8wHAMp/sz4T3sCUZ7kkid
         1UYw==
X-Gm-Message-State: ACrzQf1FPhpJVeJF+7FQmVjgs7o9z9MBgWnZzj99eF5xicahupo3YjDK
        Dn1kWye2TtOKVWMYgUDb3rmca17iyXeD4wRb+Pu4fhYyrgrY
X-Google-Smtp-Source: AMsMyM4Oi1gB3R+J6g3Kn1xN+HEPH/HMWXXOKmw0BrZTNQkMa3SuBjQQgc5daPXOIzUiU0jYZgLaX8nGFfc4qh77YGwGtwYlqNGc
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1ca5:b0:2fa:bee0:32ad with SMTP id
 x5-20020a056e021ca500b002fabee032admr33931592ill.136.1666924898506; Thu, 27
 Oct 2022 19:41:38 -0700 (PDT)
Date:   Thu, 27 Oct 2022 19:41:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000715f6f05ec0f32d3@google.com>
Subject: [syzbot] upstream boot error: WARNING in genl_register_family
From:   syzbot <syzbot+40eb8c0447c0e47a7e9b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, gnault@redhat.com,
        jiri@nvidia.com, johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, razor@blackwall.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    23758867219c Merge tag 'net-6.1-rc3-2' of git://git.kernel..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=135d15ce880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1d3548a4365ba17d
dashboard link: https://syzkaller.appspot.com/bug?extid=40eb8c0447c0e47a7e9b
compiler:       Debian clang version 13.0.1-++20220126092033+75e33f71c2da-1~exp1~20220126212112.63, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/20e53c5d9806/disk-23758867.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/7c05afb0709a/vmlinux-23758867.xz
kernel image: https://storage.googleapis.com/syzbot-assets/687dcd5504ea/bzImage-23758867.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+40eb8c0447c0e47a7e9b@syzkaller.appspotmail.com

can: controller area network core
NET: Registered PF_CAN protocol family
can: raw protocol
can: broadcast manager protocol
can: netlink gateway - max_hops=1
can: SAE J1939
can: isotp protocol
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: CMTP (CAPI Emulation) ver 1.0
Bluetooth: CMTP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
NET: Registered PF_RXRPC protocol family
Key type rxrpc registered
Key type rxrpc_s registered
NET: Registered PF_KCM protocol family
lec:lane_module_init: lec.c: initialized
mpoa:atm_mpoa_init: mpc.c: initialized
l2tp_core: L2TP core driver, V2.0
l2tp_ppp: PPPoL2TP kernel driver, V2.0
l2tp_ip: L2TP IP encapsulation support (L2TPv3)
l2tp_netlink: L2TP netlink interface
l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
NET: Registered PF_PHONET protocol family
8021q: 802.1Q VLAN Support v1.8
DCCP: Activated CCID 2 (TCP-like)
DCCP: Activated CCID 3 (TCP-Friendly Rate Control)
sctp: Hash tables configured (bind 32/56)
NET: Registered PF_RDS protocol family
Registered RDS/infiniband transport
Registered RDS/tcp transport
tipc: Activated (version 2.0.0)
NET: Registered PF_TIPC protocol family
tipc: Started in single node mode
NET: Registered PF_SMC protocol family
9pnet: Installing 9P2000 support
NET: Registered PF_CAIF protocol family
NET: Registered PF_IEEE802154 protocol family
Key type dns_resolver registered
Key type ceph registered
libceph: loaded (mon/osd proto 15/24)
batman_adv: B.A.T.M.A.N. advanced 2022.3 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
------------[ cut here ]------------
WARNING: CPU: 0 PID: 1 at net/netlink/genetlink.c:383 genl_register_family+0x13c0/0x1540 net/netlink/genetlink.c:414
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc2-syzkaller-00189-g23758867219c #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:genl_validate_ops net/netlink/genetlink.c:383 [inline]
RIP: 0010:genl_register_family+0x13c0/0x1540 net/netlink/genetlink.c:414
Code: 5d 41 5e 41 5f 5d c3 e8 5e 74 1b f9 0f 0b 41 be ea ff ff ff eb a2 e8 4f 74 1b f9 0f 0b 41 be ea ff ff ff eb 93 e8 40 74 1b f9 <0f> 0b 41 be ea ff ff ff eb 84 44 89 e1 80 e1 07 38 c1 0f 8c bd ec
RSP: 0000:ffffc90000067820 EFLAGS: 00010293
RAX: ffffffff886c5ba0 RBX: 0000000000000001 RCX: ffff888140170000
RDX: 0000000000000000 RSI: 0000000000000003 RDI: 0000000000000000
RBP: ffffc90000067950 R08: ffffffff886c4bd3 R09: fffffbfff1c1b606
R10: fffffbfff1c1b606 R11: 1ffffffff1c1b605 R12: dffffc0000000000
R13: ffffffff8c582448 R14: 0000000000000000 R15: 0000000000000003
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000c88e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 dp_register_genl+0x40/0x136 net/openvswitch/datapath.c:2578
 dp_init+0x11a/0x140 net/openvswitch/datapath.c:2707
 do_one_initcall+0x1c9/0x400 init/main.c:1303
 do_initcall_level+0x168/0x218 init/main.c:1376
 do_initcalls+0x4b/0x8c init/main.c:1392
 kernel_init_freeable+0x428/0x5d5 init/main.c:1631
 kernel_init+0x19/0x2b0 init/main.c:1519
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
