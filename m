Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 299544B0FA2
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 15:05:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242592AbiBJOFS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 09:05:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240156AbiBJOFR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 09:05:17 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F42F1BA
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:05:19 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id ay26-20020a5d9d9a000000b006396dd81e4bso2635988iob.10
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 06:05:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=9sgSbApQo++c7T70sHfxQzyj8WhWNYeWFt0ennmNEF4=;
        b=kHigvCpy/ZNRF89A1Mz9t2lofIbs7xR4xbDzT2qlbr0p7ONFkyLIvZOw2D0P0SEGEM
         N2o9UMTcNmx2AFDYSpFqgbOfLfAnXryCzKR32MUrvv1WfYgjPBj889WgDRjOABNvLO4a
         wQP4QLM8AVByz9Wpy5OtTpFWt6Q2faOzb+TO/7vV4XPZPWX57TRp1U2IXMBdhGddY1mm
         TZFvtGn7cXpb/TsvHWV7XR8i1Cfng9vV0hT1df7qcT0I+8+G/rwtwQwborOJ5FX4gXzb
         Cvh3osVsOQST71rPFw5TFWZR5bmFTyJDnpmYqCfz8mvZ/iBm9WgsV3V2UjXTbPOAga/l
         FwXg==
X-Gm-Message-State: AOAM530n5daB8lht/bFbMq/DKhaoU7Oa892ry12knYVy7+wtUrAY2sIB
        7LdyunfEfY90K9t9/KmkAz2NBdcO4dc0SHDDrsTDa38rBSJf
X-Google-Smtp-Source: ABdhPJx9Wn+4DdjWmfvunvoohS0TCSGFqtxqixRGiPT2n7ES7InJgdBlxLJp6xXEqCpCxhBmFGtGpg9ihjjFDl5JQHf92GXr/eOb
MIME-Version: 1.0
X-Received: by 2002:a05:6638:2054:: with SMTP id t20mr4051237jaj.207.1644501918370;
 Thu, 10 Feb 2022 06:05:18 -0800 (PST)
Date:   Thu, 10 Feb 2022 06:05:18 -0800
In-Reply-To: <0000000000009962dc05d7a6b27f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ad4e9c05d7aa7064@google.com>
Subject: Re: [syzbot] WARNING in mroute_clean_tables
From:   syzbot <syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    e5313968c41b Merge branch 'Split bpf_sk_lookup remote_port..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=141c859a700000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c40b67275bfe2a58
dashboard link: https://syzkaller.appspot.com/bug?extid=a7c030a05218db921de5
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=130486f8700000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16d9f758700000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a7c030a05218db921de5@syzkaller.appspotmail.com

------------[ cut here ]------------
RTNL: assertion failed at net/core/dev.c (10367)
WARNING: CPU: 1 PID: 3674 at net/core/dev.c:10367 unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Modules linked in:
CPU: 1 PID: 3674 Comm: syz-executor165 Not tainted 5.16.0-syzkaller-11655-ge5313968c41b #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:unregister_netdevice_many+0x1246/0x1850 net/core/dev.c:10367
Code: 0f 85 9b ee ff ff e8 59 f1 4a fa ba 7f 28 00 00 48 c7 c6 00 90 ae 8a 48 c7 c7 40 90 ae 8a c6 05 0e a1 51 06 01 e8 3c 8a d8 01 <0f> 0b e9 70 ee ff ff e8 2e f1 4a fa 4c 89 e7 e8 c6 22 59 fa e9 ee
RSP: 0018:ffffc90003adf6e0 EFLAGS: 00010286
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: ffff888075bf8000 RSI: ffffffff815fa058 RDI: fffff5200075bece
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: ffffffff815f3dbe R11: 0000000000000000 R12: 00000000fffffff4
R13: dffffc0000000000 R14: ffffc90003adf750 R15: ffff888070f9c000
FS:  00007f8cda422700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8cda4229d0 CR3: 0000000071e66000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 mroute_clean_tables+0x244/0xb40 net/ipv6/ip6mr.c:1509
 ip6mr_free_table net/ipv6/ip6mr.c:389 [inline]
 ip6mr_rules_init net/ipv6/ip6mr.c:246 [inline]
 ip6mr_net_init net/ipv6/ip6mr.c:1306 [inline]
 ip6mr_net_init+0x3f0/0x4e0 net/ipv6/ip6mr.c:1298
 ops_init+0xaf/0x470 net/core/net_namespace.c:140
 setup_net+0x54f/0xbb0 net/core/net_namespace.c:331
 copy_net_ns+0x318/0x760 net/core/net_namespace.c:475
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 copy_namespaces+0x391/0x450 kernel/nsproxy.c:178
 copy_process+0x2e15/0x7310 kernel/fork.c:2167
 kernel_clone+0xe7/0xab0 kernel/fork.c:2555
 __do_sys_clone+0xc8/0x110 kernel/fork.c:2672
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f8cda472169
Code: Unable to access opcode bytes at RIP 0x7f8cda47213f.
RSP: 002b:00007f8cda4222f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f8cda4fb4e0 RCX: 00007f8cda472169
RDX: 0000000020000080 RSI: 0000000020000050 RDI: 0000000046000080
RBP: 00007f8cda4c82fc R08: 0000000020000100 R09: 0000000000000000
R10: 00000000200000c0 R11: 0000000000000246 R12: 00007f8cda4c82ed
R13: 2bcc52a5f498fa8d R14: 000000344059e000 R15: 00007f8cda4fb4e8
 </TASK>

