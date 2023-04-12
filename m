Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D0726DE877
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 02:22:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229498AbjDLAWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 20:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDLAWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 20:22:55 -0400
Received: from mail-il1-f205.google.com (mail-il1-f205.google.com [209.85.166.205])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E33A199D
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:22:54 -0700 (PDT)
Received: by mail-il1-f205.google.com with SMTP id u6-20020a926006000000b003232594207dso7047029ilb.8
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 17:22:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681258973; x=1683850973;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vDeAciAGUu2Os6CWnaMgil2ftdLPgpp4On5AN0OJS54=;
        b=HofPxhOETFmaG4aRnocGk8MxU5FVwy5wflOLun5iUGeEnq5gSEVH+KV2+rMDRqFpur
         uA340UxXdp6MIK7+RTgKvQbKu9FgUKAeDGlunxNaFsf6bEaNvNIjQulR+6HcKOh+lr5z
         toP8BidD41LP1qOmuASAL3zQkmVWNXGYUEzwqZoZKSWUtpjEu3mM/eX5jgTwwHRpAEcW
         HpNFDvHNuy47kAQWDit56d+R9SuKtyQw1O2KpMsfGYAjMHPmtX2tiWO3YrfZhm62PTkm
         OFH1RClLtG2C4WLYCEHJwF8gkgcj3I47qejc+Cnvj9vojLjL06pJO/yGNuGCat77mNRF
         GSfQ==
X-Gm-Message-State: AAQBX9eOmLVOKuDFOG3kx+h/ACY8Es0/dLvjMj8xtAfsEBFsk6zhmJMb
        1nH4Nh16fXwLRK/JjvUWiGTBPDd85dxHeS+W9ztlPHtFTHBq
X-Google-Smtp-Source: AKy350YgxTXf6utG/kdS74PL6xy/zu7P/KDgHxM+D3LuJXG9FwV7icfcPsCi6s29J2jEglm/WwQI4j5lFw4/y/pQloQzBLonRuOi
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1090:b0:328:49a2:216 with SMTP id
 r16-20020a056e02109000b0032849a20216mr539989ilj.4.1681258973361; Tue, 11 Apr
 2023 17:22:53 -0700 (PDT)
Date:   Tue, 11 Apr 2023 17:22:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e1fc7905f9189b86@google.com>
Subject: [syzbot] [net?] WARNING in xfrm_policy_fini (2)
From:   syzbot <syzbot+b3346cca0c23c839e787@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com,
        herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
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

HEAD commit:    e28531143b25 net: ethernet: mtk_eth_soc: mtk_ppe: prefer n..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=163c0ac5c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a3bc1f699d6e9cb0
dashboard link: https://syzkaller.appspot.com/bug?extid=b3346cca0c23c839e787
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/6ff439efecb6/disk-e2853114.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/280d508d228c/vmlinux-e2853114.xz
kernel image: https://storage.googleapis.com/syzbot-assets/af98eb5ab0e4/bzImage-e2853114.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b3346cca0c23c839e787@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 41 at net/xfrm/xfrm_policy.c:4176 xfrm_policy_fini+0x2f2/0x3c0 net/xfrm/xfrm_policy.c:4176
Modules linked in:
CPU: 0 PID: 41 Comm: kworker/u4:2 Not tainted 6.3.0-rc5-syzkaller-01242-ge28531143b25 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/30/2023
Workqueue: netns cleanup_net
RIP: 0010:xfrm_policy_fini+0x2f2/0x3c0 net/xfrm/xfrm_policy.c:4176
Code: cd f8 0f 0b 8b 74 24 04 e9 56 fe ff ff e8 a6 a1 cd f8 0f 0b e9 e1 fd ff ff e8 9a a1 cd f8 0f 0b e9 02 ff ff ff e8 8e a1 cd f8 <0f> 0b e9 76 fd ff ff e8 d2 ea 1e f9 e9 8d fe ff ff 48 89 ef e8 e5
RSP: 0018:ffffc90000b27bd8 EFLAGS: 00010293
RAX: 0000000000000000 RBX: ffff88807945b980 RCX: 0000000000000000
RDX: ffff8880177b57c0 RSI: ffffffff88b53632 RDI: 0000000000000000
RBP: ffff88807945cd00 R08: 0000000000000001 R09: ffffffff914e0b8f
R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8e28cb40
R13: ffffc90000b27ca0 R14: dffffc0000000000 R15: fffffbfff1c5196c
FS:  0000000000000000(0000) GS:ffff8880b9800000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f60f8cb7378 CR3: 000000000c571000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 xfrm_net_exit+0x1d/0x60 net/xfrm/xfrm_policy.c:4240
 ops_exit_list+0xb0/0x170 net/core/net_namespace.c:169
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
 process_one_work+0x991/0x15c0 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
