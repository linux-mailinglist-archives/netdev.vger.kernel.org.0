Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37F92A0D8D
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 00:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbfH1W0m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 18:26:42 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:38927 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726844AbfH1W0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 18:26:41 -0400
Received: by mail-ed1-f66.google.com with SMTP id g8so1736599edm.6
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 15:26:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ePoJ33Wu/icAvNqWpNFENY9LYrP4c2t65btHAa+RjrE=;
        b=bF70Avyn4DwRjJdfn6Nbjw+PVDiW17xek6/F9luxsSGrjM7XrjyLbCNMz9T8/mQ5VE
         qD/00YM36KvgtJluIgSioCgBGb7oHDDYXdcaIgAbGB579NS1O/jGWnS8LVU2roupZ16X
         yXxzQ7s8c+VHG6XP7O0Dp11/uo4BDjTFzhNt3khIPx3bv5j19hlB7aPJznezcwUUDRID
         cXWdEaorJXviipYteiSz8JNSXswmk75S7EXiDuAIS4Ka/kORCVA+qoCoNwlZ6hQkVD/p
         qp+swzgy8a04x2TJwT2v1jMNXlrTHp2FU5c0q7BwpcaGm/fxZ6Am7rrUuI48li9/bisi
         j6gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ePoJ33Wu/icAvNqWpNFENY9LYrP4c2t65btHAa+RjrE=;
        b=DiwWOy/aJ7SK6PPte38cxRjmg56v8VCQmp9jW0ttAouzgtZXZU5ehy5w7x6DzraQQJ
         PtYeEiuCZ2gcdtav0XlvWmbQHT56km9+ErHiZEOskvVebQl7p/XLFJSB8+/uOfL+pl7v
         oEbhdDN+JP/xq9TSJ4wTc/ixN6/FQ4I7FfE+olVYJhMHfvrlPD6HuSBxdmWq/pryEiG2
         9XAdXVnumlTDyNRkTxelwIS6Bhwl4Oqrk2OKUAq1HnpdtVnDerjuUttC18pJyY3cnzvf
         ZS/HivNsd0hrRQZdXJ8W1H/t9Z6IOfTbCZkrfsG0GPrtdGx5JktEx5LuX0J9QA7MtnR7
         ztFg==
X-Gm-Message-State: APjAAAU3omlJQ0xU2CN5Y/I3mHBcWVMy4bFlLd11BYt1AYiAVHnRKhgW
        +vun/ndLBBdSo/GjwQBcN0gb5g==
X-Google-Smtp-Source: APXvYqzNhEn8jZKHAI0X43Hc8CLziEYTiZbEqayyGqBhGAO4VEfnYtddX1fP+F0k30CIMbj01IdrRw==
X-Received: by 2002:a17:906:5e50:: with SMTP id b16mr5377019eju.254.1567031199536;
        Wed, 28 Aug 2019 15:26:39 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id x11sm91676eju.26.2019.08.28.15.26.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 15:26:39 -0700 (PDT)
Date:   Wed, 28 Aug 2019 15:26:15 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     john.fastabend@gmail.com
Cc:     syzbot <syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com>,
        aviadye@mellanox.com, borisp@mellanox.com, daniel@iogearbox.net,
        davejwatson@fb.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: general protection fault in tls_sk_proto_close (2)
Message-ID: <20190828152615.0fec59b2@cakuba.netronome.com>
In-Reply-To: <000000000000c3c461059127a1c4@google.com>
References: <000000000000c3c461059127a1c4@google.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 27 Aug 2019 23:38:07 -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    a55aa89a Linux 5.3-rc6
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=16c26ebc600000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=2a6a2b9826fdadf9
> dashboard link: https://syzkaller.appspot.com/bug?extid=7a6ee4d0078eac6bf782
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1112a4de600000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+7a6ee4d0078eac6bf782@syzkaller.appspotmail.com

Hi John!

This is a loop where TLS calls it's own close function recursively.
It seems we must have gotten BPF installed on top of TLS, and then 
it handed TLS TLS'es own sk_proto via tcp_update_ulp().

Can BPF on top of TLS be prevented somehow?

Quick fix should probably be something like:

diff --git a/net/tls/tls_main.c b/net/tls/tls_main.c
index 43252a801c3f..3f4962756fa4 100644
--- a/net/tls/tls_main.c
+++ b/net/tls/tls_main.c
@@ -816,6 +816,9 @@ static void tls_update(struct sock *sk, struct proto *p)
 
        ctx = tls_get_ctx(sk);
        if (likely(ctx)) {
+               if (p->setsockopt == tls_setsockopt)
+                       return;
+
                ctx->sk_proto_close = p->close;
                ctx->sk_proto = p;
        } else {

> kasan: CONFIG_KASAN_INLINE enabled
> kasan: GPF could be caused by NULL-ptr deref or user memory access
> general protection fault: 0000 [#1] PREEMPT SMP KASAN
> CPU: 1 PID: 10290 Comm: syz-executor.0 Not tainted 5.3.0-rc6 #120
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
> Google 01/01/2011
> RIP: 0010:tls_sk_proto_close+0xe5/0x990 net/tls/tls_main.c:298
> Code: 0f 85 3f 08 00 00 49 8b 84 24 c0 02 00 00 4d 8d 75 14 4c 89 f2 48 c1  
> ea 03 48 89 85 50 ff ff ff 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c  
> 89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 2e 06 00 00
> RSP: 0018:ffff88809b23fb90 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: ffffffff862cb8db
> RDX: 0000000000000002 RSI: ffffffff862cb639 RDI: ffff8880a155ef00
> RBP: ffff88809b23fc48 R08: ffff888094344640 R09: ffffed10142abd9a
> R10: ffffed10142abd99 R11: ffff8880a155eccb R12: ffff8880a155ec40
> R13: 0000000000000000 R14: 0000000000000014 R15: 0000000000000001
> FS:  00005555556a8940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f353458e000 CR3: 00000000a9174000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>   tls_sk_proto_close+0x35b/0x990 net/tls/tls_main.c:321
>   tcp_bpf_close+0x17c/0x390 net/ipv4/tcp_bpf.c:582
>   inet_release+0xed/0x200 net/ipv4/af_inet.c:427
>   inet6_release+0x53/0x80 net/ipv6/af_inet6.c:470
>   __sock_release+0xce/0x280 net/socket.c:590
>   sock_close+0x1e/0x30 net/socket.c:1268
>   __fput+0x2ff/0x890 fs/file_table.c:280
>   ____fput+0x16/0x20 fs/file_table.c:313
>   task_work_run+0x145/0x1c0 kernel/task_work.c:113
>   tracehook_notify_resume include/linux/tracehook.h:188 [inline]
>   exit_to_usermode_loop+0x316/0x380 arch/x86/entry/common.c:163
>   prepare_exit_to_usermode arch/x86/entry/common.c:194 [inline]
>   syscall_return_slowpath arch/x86/entry/common.c:274 [inline]
>   do_syscall_64+0x5a9/0x6a0 arch/x86/entry/common.c:299
>   entry_SYSCALL_64_after_hwframe+0x49/0xbe
> RIP: 0033:0x413540
> Code: 01 f0 ff ff 0f 83 30 1b 00 00 c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f  
> 44 00 00 83 3d 4d 2d 66 00 00 75 14 b8 03 00 00 00 0f 05 <48> 3d 01 f0 ff  
> ff 0f 83 04 1b 00 00 c3 48 83 ec 08 e8 0a fc ff ff
> RSP: 002b:00007fff5d481778 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000413540
> RDX: 0000001b2e520000 RSI: 0000000000000000 RDI: 0000000000000005
> RBP: 0000000000000001 R08: 0000000000000000 R09: ffffffffffffffff
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000075bf20
> R13: 0000000000000003 R14: 0000000000761220 R15: ffffffffffffffff
> Modules linked in:
> ---[ end trace bdfd4385a0f1f76d ]---
> RIP: 0010:tls_sk_proto_close+0xe5/0x990 net/tls/tls_main.c:298
> Code: 0f 85 3f 08 00 00 49 8b 84 24 c0 02 00 00 4d 8d 75 14 4c 89 f2 48 c1  
> ea 03 48 89 85 50 ff ff ff 48 b8 00 00 00 00 00 fc ff df <0f> b6 04 02 4c  
> 89 f2 83 e2 07 38 d0 7f 08 84 c0 0f 85 2e 06 00 00
> RSP: 0018:ffff88809b23fb90 EFLAGS: 00010203
> RAX: dffffc0000000000 RBX: dffffc0000000000 RCX: ffffffff862cb8db
> RDX: 0000000000000002 RSI: ffffffff862cb639 RDI: ffff8880a155ef00
> RBP: ffff88809b23fc48 R08: ffff888094344640 R09: ffffed10142abd9a
> R10: ffffed10142abd99 R11: ffff8880a155eccb R12: ffff8880a155ec40
> R13: 0000000000000000 R14: 0000000000000014 R15: 0000000000000001
> FS:  00005555556a8940(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f353458e000 CR3: 00000000a9174000 CR4: 00000000001406e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> 
> 
> ---
> This bug is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this bug report. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this bug, for details see:
> https://goo.gl/tpsmEJ#testing-patches

