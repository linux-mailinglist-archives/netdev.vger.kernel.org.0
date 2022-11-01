Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B7B96142FA
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 02:58:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiKAB6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 21:58:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiKAB6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 21:58:45 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3CAFD1
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:58:39 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id u7-20020a056e021a4700b00300b1379a2fso3306775ilv.13
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 18:58:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k5aumleoC+6dOgtsmeyQ80AN/JAO4J+h0lsbF+cmcaA=;
        b=Cm/WdyL/HNdfR1z2Jw++h3GFYS+yXSrIprvUOyXi79l4qbBKIXDKkZNeuB/CDyL/2q
         Y9jzPdFQ++xETmKituK2gTCXbPnubZKPbLioVr8WVsWuXo+tJ3nEGbAWjw+OpRD7fk3w
         yDoXdVKUDE3oqv1AdivMKSkGp5RMtXnlGu/fupwlXqA9esdHyuo0vQekrxUCRrkQFMo0
         ba8xbDl4tHoD373anC67T+G2sAwBrYWPeH+7KsLQe4AFzKgHl50SXFiJd5IdvPU7tnbG
         dm02/Cpn3UG3bYcUxGiu8FaG9AHFclLMo3sMUedGUpuuQ8JsPtx5/ve4ZONRC7ZvyLbH
         av+Q==
X-Gm-Message-State: ACrzQf1GN9NQORhHmWY2wrigkMMvZmeTT/h9SMV0hKwyOxhPNwKs1tf0
        +bYTB8Avs40ibsOcQuOTPjU4aImoSt4X3JT5phLbacZne7wT
X-Google-Smtp-Source: AMsMyM55cnr9xu3djM1WAb9zBUV5XeIA5h/VRdj7FJ+TwNqlvQrhVHxDSqdaCTTjWgYMembu6mdFh7k5eC5/V3PVhK7EkkQwdjJN
MIME-Version: 1.0
X-Received: by 2002:a02:a518:0:b0:375:59f0:a0f3 with SMTP id
 e24-20020a02a518000000b0037559f0a0f3mr5418197jam.24.1667267918925; Mon, 31
 Oct 2022 18:58:38 -0700 (PDT)
Date:   Mon, 31 Oct 2022 18:58:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000d98ad05ec5f106a@google.com>
Subject: [syzbot] net-next boot error: WARNING in genl_register_family
From:   syzbot <syzbot+1bd9726d2031ebadac74@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jiri@nvidia.com,
        johannes@sipsolutions.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nicolas.dichtel@6wind.com, pabeni@redhat.com, razor@blackwall.org,
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

HEAD commit:    0cf9deb3005f net: mvneta: Remove unused variable i
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=1515e00a880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53cedb500b7b74c6
dashboard link: https://syzkaller.appspot.com/bug?extid=1bd9726d2031ebadac74
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f1565497b0ab/disk-0cf9deb3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0b1b7b29a5f5/vmlinux-0cf9deb3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/a9200f03d86a/bzImage-0cf9deb3.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1bd9726d2031ebadac74@syzkaller.appspotmail.com

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
WARNING: CPU: 0 PID: 1 at net/netlink/genetlink.c:383 genl_validate_ops net/netlink/genetlink.c:383 [inline]
WARNING: CPU: 0 PID: 1 at net/netlink/genetlink.c:383 genl_register_family+0x298/0x1450 net/netlink/genetlink.c:414
Modules linked in:
CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc2-syzkaller-00625-g0cf9deb3005f #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:genl_validate_ops net/netlink/genetlink.c:383 [inline]
RIP: 0010:genl_register_family+0x298/0x1450 net/netlink/genetlink.c:414
Code: dd 0f 82 b1 06 00 00 e8 06 11 e5 f9 0f b6 9c 24 b7 00 00 00 31 ff 89 de e8 85 0d e5 f9 84 db 0f 84 93 06 00 00 e8 e8 10 e5 f9 <0f> 0b e8 e1 10 e5 f9 41 bc ea ff ff ff e8 d6 10 e5 f9 48 b8 00 00
RSP: 0000:ffffc90000067c50 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff8881401c8000 RSI: ffffffff87978b98 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff8b9a6a26 R14: ffffffff8b9a6a00 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000bc8e000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 dp_register_genl net/openvswitch/datapath.c:2578 [inline]
 dp_init+0x148/0x25d net/openvswitch/datapath.c:2707
 do_one_initcall+0x13d/0x780 init/main.c:1303
 do_initcall_level init/main.c:1376 [inline]
 do_initcalls init/main.c:1392 [inline]
 do_basic_setup init/main.c:1411 [inline]
 kernel_init_freeable+0x6ff/0x788 init/main.c:1631
 kernel_init+0x1a/0x1d0 init/main.c:1519
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
