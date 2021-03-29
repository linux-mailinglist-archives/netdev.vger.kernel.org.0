Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B593134D8AD
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhC2T51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231844AbhC2T5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:57:05 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFD64C061756
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 12:57:04 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id z2so14034943wrl.5
        for <netdev@vger.kernel.org>; Mon, 29 Mar 2021 12:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=0zAoRl//clq6WPeJfxTMvaVQ753eJj4mZ95Xl7JXi2w=;
        b=jHis9KCRju1Pzkv1XjWjAwuy1/foOLRBNCKfFr3oS31vyVXubhfTY9tP6LVwBROR4n
         MmIIdIZhlD+7GOVdN02rjHj9Dm3/6H9cQvZxBMxJlg3fhdgk5HePcFl/joat1D2hC574
         63614o/popaNQbARYQ+Ycql6hmD49yDdC4P/80sX1MjsGH9dc0H/WAfGnWasvi+Gb/Nf
         v/LFyfeEBaviEJ8XsauHbyPnFKy05gvEHOanefooRBskkxHz3lhNBpU6oKrGr973Staw
         LcDzXCvkDPCd63qpkDj3eVIvJ/PreuCwfpqZgqOEW3Pp35hfi3PqIpbVGFR+DWHVzVO/
         3/LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0zAoRl//clq6WPeJfxTMvaVQ753eJj4mZ95Xl7JXi2w=;
        b=MyJ0lPYjsgc2jIdblhKHh3Isnzz/sS5qkHCLuHHUwhHP+02NDZxA8poOkzlekBj93I
         oDv8Z4llNoLdyXOG0s6R1Lo+A3UjGbYZu7rM5tJTyibjKDq7Yry/UN+7TyLq0Ya5+cfF
         B1vJnl7jlCszhwNWWaPk/+PgjuOsTehGU/hzKRW+AhLIsZR+JZKPsgPTNM9CEhOOwZqr
         PpuBBrSpH3I3aPBtFHj3GztyRiDQdzlcRRBiD2uY9avzpX34U5+kx2hIb9++9fFMu1M6
         L8zAyDbEThxFxykL6lvfHFvvDuzC6/CPbqfBrf8dsosC41x6bLL9MwEj5Eo3G25GpVxp
         IpZQ==
X-Gm-Message-State: AOAM533qSHv7/MVUtNXzQL1XTFI3rHpTgwfkKtmsHc1o2AGmDceesGov
        DqmlkVnFxvhkKPi7mxgqTCDPEA==
X-Google-Smtp-Source: ABdhPJxL2g1tP98O5KuQnu8BSjgfVcUj0Kh+h35ux47ZTWsKEX9pBHptrVDNF7gcBuJ162MG+t6Sdw==
X-Received: by 2002:adf:84e6:: with SMTP id 93mr28774576wrg.376.1617047823666;
        Mon, 29 Mar 2021 12:57:03 -0700 (PDT)
Received: from ?IPv6:2a02:8084:e84:2480:228:f8ff:fe6f:83a8? ([2a02:8084:e84:2480:228:f8ff:fe6f:83a8])
        by smtp.gmail.com with ESMTPSA id 81sm449891wmc.11.2021.03.29.12.57.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Mar 2021 12:57:03 -0700 (PDT)
Subject: Re: [syzbot] WARNING in xfrm_alloc_compat (2)
To:     syzbot <syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com>,
        davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
References: <000000000000ceb65005beb18c8f@google.com>
From:   Dmitry Safonov <dima@arista.com>
Message-ID: <06c56a34-b7c6-f397-568d-3cdf6b044858@arista.com>
Date:   Mon, 29 Mar 2021 20:57:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <000000000000ceb65005beb18c8f@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 3/29/21 8:04 PM, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    6c996e19 net: change netdev_unregister_timeout_secs min va..
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=102e5926d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c0ac79756537274e
> dashboard link: https://syzkaller.appspot.com/bug?extid=834ffd1afc7212eb8147
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10a7b1aad00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17ae6b7cd00000
> 
> The issue was bisected to:
> 
> commit 5f3eea6b7e8f58cf5c8a9d4b9679dc19e9e67ba3
> Author: Dmitry Safonov <dima@arista.com>
> Date:   Mon Sep 21 14:36:53 2020 +0000
> 
>     xfrm/compat: Attach xfrm dumps to 64=>32 bit translator
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10694b3ad00000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12694b3ad00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14694b3ad00000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+834ffd1afc7212eb8147@syzkaller.appspotmail.com
> Fixes: 5f3eea6b7e8f ("xfrm/compat: Attach xfrm dumps to 64=>32 bit translator")
> 
> netlink: 208 bytes leftover after parsing attributes in process `syz-executor193'.
> ------------[ cut here ]------------
> unsupported nla_type 356

This doesn't seem to be an issue.
Userspace sent message with nla_type 356, which is > __XFRM_MSG_MAX, so
this warning is expected. I've added it so when a new XFRM_MSG_* will be
added, to make sure that there will be translations to such messages in
xfrm_compat.ko (if the translation needed).
This is WARN_ON_ONCE(), so it can't be used as DOS.

Ping me if you'd expect something else than once-a-boot warning for
this. Not sure how-to close syzkaller bug, docs have only `invalid' tag,
which isn't `not-a-bug'/`expected' tag:
https://github.com/google/syzkaller/blob/master/docs/syzbot.md


> WARNING: CPU: 1 PID: 8423 at net/xfrm/xfrm_compat.c:280 xfrm_xlate64_attr net/xfrm/xfrm_compat.c:280 [inline]
> WARNING: CPU: 1 PID: 8423 at net/xfrm/xfrm_compat.c:280 xfrm_xlate64 net/xfrm/xfrm_compat.c:301 [inline]
> WARNING: CPU: 1 PID: 8423 at net/xfrm/xfrm_compat.c:280 xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:328
> Modules linked in:
> CPU: 1 PID: 8423 Comm: syz-executor193 Not tainted 5.12.0-rc4-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:xfrm_xlate64_attr net/xfrm/xfrm_compat.c:280 [inline]
> RIP: 0010:xfrm_xlate64 net/xfrm/xfrm_compat.c:301 [inline]
> RIP: 0010:xfrm_alloc_compat+0xf39/0x10d0 net/xfrm/xfrm_compat.c:328
> Code: de e8 5b d7 c3 f9 84 db 0f 85 b0 f8 ff ff e8 9e d0 c3 f9 8b 74 24 08 48 c7 c7 80 42 76 8a c6 05 39 2e 02 06 01 e8 74 b7 16 01 <0f> 0b e9 8d f8 ff ff e8 7b d0 c3 f9 8b 14 24 48 c7 c7 40 42 76 8a
> RSP: 0018:ffffc90000fff4b8 EFLAGS: 00010282
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88801b1554c0 RSI: ffffffff815c4d75 RDI: fffff520001ffe89
> RBP: 00000000000000d8 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815bdb0e R11: 0000000000000000 R12: 00000000ffffffa1
> R13: ffff8880248eb8f8 R14: ffff888013256dc0 R15: ffff8880132568c0
> FS:  000000000092f300(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00000000200001e0 CR3: 0000000023271000 CR4: 00000000001506e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  xfrm_alloc_userspi+0x66a/0xa30 net/xfrm/xfrm_user.c:1448
>  xfrm_user_rcv_msg+0x42c/0x8b0 net/xfrm/xfrm_user.c:2812
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>  xfrm_netlink_rcv+0x6b/0x90 net/xfrm/xfrm_user.c:2824
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:674
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2433
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x43f009
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe0986bcb8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043f009
> RDX: 0000000000000000 RSI: 0000000020000580 RDI: 0000000000000003
> RBP: 0000000000402ff0 R08: 0000000000000000 R09: 0000000000400488
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403080
> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
> 

Thanks,
          Dmitry
