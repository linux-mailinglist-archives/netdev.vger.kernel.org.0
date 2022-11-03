Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB0F66183DD
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 17:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbiKCQLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 12:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbiKCQLq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 12:11:46 -0400
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1841094
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 09:11:44 -0700 (PDT)
Received: by mail-il1-f197.google.com with SMTP id o13-20020a056e0214cd00b00300a27f9424so1898129ilk.10
        for <netdev@vger.kernel.org>; Thu, 03 Nov 2022 09:11:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Auj3vQKcwoQNezul/j4Pp/aHoO2hjUoalXp0Uezz5k=;
        b=cZXuei8d4eRt8Z/OdcxRgkhPh/4znUhZjHI1IaRhT7UFLHLqWdv0VtyJ008twOzsoF
         4FjhLH1lxO1XtxmU29uJ4Kgka1gn/9cEgljf3PtYBDFiLLiFTQw6oqCB+3rccTU2qNA6
         hJ1XzBEbEUZ601rCNg2Brf+i9dluRLEaJv2NhzPnH0cHN7x3KSmwzejfgjcAEJm4V5+A
         kmQBRnJCdbmco2yBYI4ycZ7hVetMThpx/2TI+oqgQYoAUvXI7RfcbWqi4pp9KMFQhUXo
         vskINyUlr70vIXccCus3cdXRGnfxH/7Kgx1GiW9juU7/et/wBAOUs8U8xJeVJEOm0XhB
         U07g==
X-Gm-Message-State: ACrzQf2FBfl9Ihvbt6xo+8GzisZVcNxZGX/ZrnKzUz8xThiktwbpBw8c
        hkvymdsqSqTkwrisTgG9mWrdka9i4+THifvsAkyif/tOx3CB
X-Google-Smtp-Source: AMsMyM6Cq+gQg8eyNqw4rYJ8YQP4nUd68IJMs2MKZpTHB9Z1Kmh1+J6eGzjJHMtAA/ETZBx0uNAOVioZc89X9VBHwL/pLJhr3PIA
MIME-Version: 1.0
X-Received: by 2002:a92:c26e:0:b0:2fc:1a4f:bfb with SMTP id
 h14-20020a92c26e000000b002fc1a4f0bfbmr17311052ild.58.1667491903453; Thu, 03
 Nov 2022 09:11:43 -0700 (PDT)
Date:   Thu, 03 Nov 2022 09:11:43 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000092429f05ec933622@google.com>
Subject: [syzbot] bpf-next boot error: WARNING in genl_register_family
From:   syzbot <syzbot+7cc0a430776e7900c5e7@syzkaller.appspotmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, jacob.e.keller@intel.com, jiri@nvidia.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, paul@paul-moore.com,
        razor@blackwall.org, syzkaller-bugs@googlegroups.com
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

HEAD commit:    b54a0d4094f5 Merge tag 'for-netdev' of https://git.kernel...
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=144ee346880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=53cedb500b7b74c6
dashboard link: https://syzkaller.appspot.com/bug?extid=7cc0a430776e7900c5e7
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e00a07d34b58/disk-b54a0d40.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/677c38c41b63/vmlinux-b54a0d40.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2433cd47d109/bzImage-b54a0d40.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+7cc0a430776e7900c5e7@syzkaller.appspotmail.com

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
WARNING: CPU: 1 PID: 1 at net/netlink/genetlink.c:383 genl_validate_ops net/netlink/genetlink.c:383 [inline]
WARNING: CPU: 1 PID: 1 at net/netlink/genetlink.c:383 genl_register_family+0x298/0x1450 net/netlink/genetlink.c:414
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Not tainted 6.1.0-rc2-syzkaller-10728-gb54a0d4094f5 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/11/2022
RIP: 0010:genl_validate_ops net/netlink/genetlink.c:383 [inline]
RIP: 0010:genl_register_family+0x298/0x1450 net/netlink/genetlink.c:414
Code: dd 0f 82 b1 06 00 00 e8 e6 d0 e4 f9 0f b6 9c 24 b7 00 00 00 31 ff 89 de e8 65 cd e4 f9 84 db 0f 84 93 06 00 00 e8 c8 d0 e4 f9 <0f> 0b e8 c1 d0 e4 f9 41 bc ea ff ff ff e8 b6 d0 e4 f9 48 b8 00 00
RSP: 0000:ffffc90000067c50 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff88813fe50000 RSI: ffffffff8797d148 RDI: 0000000000000001
RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
R13: ffffffff8b9a7a26 R14: ffffffff8b9a7a00 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8880b9b00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000bc8e000 CR4: 00000000003506e0
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
