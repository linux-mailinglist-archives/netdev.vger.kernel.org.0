Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 504A56A7FC8
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 11:16:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229991AbjCBKQz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 05:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjCBKQy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 05:16:54 -0500
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 814333A879
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 02:16:53 -0800 (PST)
Received: by mail-io1-f70.google.com with SMTP id c13-20020a0566022d0d00b0074cc4ed52d9so10136924iow.18
        for <netdev@vger.kernel.org>; Thu, 02 Mar 2023 02:16:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gfU34tRPzjFsfIGICwAUSyYWO7y40eQRHesXaw40d8s=;
        b=IvLkzmKlleqPeQuaZwR4fcbTLuM4kQUtkqKRB7D7+lwhHZfrUaAEad7fY4RPhieaEZ
         aXROvfirSQpTgFbY8JgTIhroefg6LVJloxADzKCjL7uTbRkB5hSmKN/eL/NFwkQ4W14i
         5m4VwrqRoo5+MlqtQ0rlsmL6HTV+TmYcn4xae003bI37YaI3chX0lebd/pUgNE8MT7/S
         Ge0XwoQdMUVnaMdKzfbLpwAXsEqKvMt+qGY9jejeQzM/h5uZeEOYlYdrN3cpzhTkU0az
         EkVy5ZkeDex05Nuc2BnSzIzXfxIFcnuoybPbLkuwOnAZ4y9v/ZaXX8LFV7+0Ml+svhlu
         oaYA==
X-Gm-Message-State: AO0yUKU2byumx9rbAml412mSBLmdCMwtnjqm+bXwe2JdgK9lZgqGmKSE
        5ll6ehMAug55fBHgOpsf2GQInsFT7kI7tNtcKPLPy0EWpqic
X-Google-Smtp-Source: AK7set+/K3PFd/KL6aqokazUrBlm0Z0tvxLV672j3djpKYOCKyBsMKiRM1UiJba0CXhjSPWzLaKdu1YfYoeIRHv5TkCoXGLj2GRQ
MIME-Version: 1.0
X-Received: by 2002:a92:180b:0:b0:310:a298:1c95 with SMTP id
 11-20020a92180b000000b00310a2981c95mr4344576ily.6.1677752212861; Thu, 02 Mar
 2023 02:16:52 -0800 (PST)
Date:   Thu, 02 Mar 2023 02:16:52 -0800
In-Reply-To: <000000000000057d3e05edbd51b9@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ab3bcc05f5e82073@google.com>
Subject: Re: [syzbot] [net?] WARNING in default_device_exit_batch (4)
From:   syzbot <syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, roman.gushchin@linux.dev, shakeelb@google.com,
        shaozhengchao@huawei.com, syzkaller-bugs@googlegroups.com,
        vasily.averin@linux.dev
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

syzbot has found a reproducer for the following issue on:

HEAD commit:    5b7c4cabbb65 Merge tag 'net-next-6.3' of git://git.kernel...
git tree:       net-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=12e7db64c80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c74c134cc415a89b
dashboard link: https://syzkaller.appspot.com/bug?extid=9dfc3f3348729cc82277
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13158898c80000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c52674c80000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/65932a118570/disk-5b7c4cab.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8de67fb8c522/vmlinux-5b7c4cab.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2b90e329d792/bzImage-5b7c4cab.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+9dfc3f3348729cc82277@syzkaller.appspotmail.com

bond7 (unregistering): Released all slaves
------------[ cut here ]------------
WARNING: CPU: 1 PID: 56 at net/core/dev.c:10867 unregister_netdevice_many_notify+0x14cf/0x19f0 net/core/dev.c:10867
Modules linked in:
CPU: 1 PID: 56 Comm: kworker/u4:4 Not tainted 6.2.0-syzkaller-05251-g5b7c4cabbb65 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/16/2023
Workqueue: netns cleanup_net
RIP: 0010:unregister_netdevice_many_notify+0x14cf/0x19f0 net/core/dev.c:10867
Code: af 1a 00 00 48 c7 c6 00 1c 5c 8b 48 c7 c7 40 1c 5c 8b c6 05 28 d4 4c 06 01 e8 5d 45 37 f9 0f 0b e9 01 f9 ff ff e8 f1 c8 6f f9 <0f> 0b e9 d8 f8 ff ff e8 85 66 c1 f9 e9 11 ed ff ff 4c 89 ef e8 d8
RSP: 0018:ffffc90001577a38 EFLAGS: 00010293
RAX: 0000000000000000 RBX: 000000007db3f601 RCX: 0000000000000000
RDX: ffff888017d61d40 RSI: ffffffff8814e53f RDI: 0000000000000001
RBP: ffff88807bc46100 R08: 0000000000000001 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000000
R13: ffff88807bc46100 R14: ffff88802ab70000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b9900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcb678e960 CR3: 00000000768f2000 CR4: 00000000003506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 unregister_netdevice_many net/core/dev.c:10897 [inline]
 default_device_exit_batch+0x451/0x5b0 net/core/dev.c:11350
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:174
 cleanup_net+0x4ee/0xb10 net/core/net_namespace.c:613
 process_one_work+0x9bf/0x1820 kernel/workqueue.c:2390
 worker_thread+0x669/0x1090 kernel/workqueue.c:2537
 kthread+0x2e8/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:308
 </TASK>

