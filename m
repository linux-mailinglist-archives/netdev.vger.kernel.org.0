Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D313233F4
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 23:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233007AbhBWWv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 17:51:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232557AbhBWWpn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 17:45:43 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D46C061574;
        Tue, 23 Feb 2021 14:45:02 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x129so5055011pfx.7;
        Tue, 23 Feb 2021 14:45:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MyScsstJI7ORQOgqP6jBg1h7EBbGtNB6RuazO9OfwkU=;
        b=OEXb/WGjobugc309Or9PdWZVhp5uGvGlbm2ED5T+DjGR6re/DwMbaWD4DDfQh7OouY
         33KIbGfPZVUvEubuc+DGSmhEhYjaEQW4uvWjcZ8dISEOlFGQiP3GtlnQPfhBJK6U6A14
         HR55xrJeV/6FN4SDetad5Knpf1fp6XGUihWBu3gbKyL5HIYziLbsvlk1DKhgTe6c1WAr
         1BDTRjId02eDRj6qeeqes+nUQRPQE2w4nDqPy6YIiJJMqKRgIzBxig/1Bi3fCpQ6Pua5
         gfWFWvqa74PCl2iBvkHf/xW8o9XonekEakttMtWnvTOzrbJANVvdu/lzZAyemC1LRnKy
         wHcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MyScsstJI7ORQOgqP6jBg1h7EBbGtNB6RuazO9OfwkU=;
        b=GhePjPhl7IWtB0drcT0hJb7SssGySjEAmVsgbR6femSJske6QhoVruxompmocRlCam
         cWT6aWZBC7e9LzFN/L0Gx1JG0KVjAZjsAvtkfNUpm8+J/cnHI/5EOwfGNLHuT4vzMClK
         IW25w2b0A2P9ZTCyKdL1MDBMeBDW/5mtekPHq9E3YWsW1mXSFbhGVdt+sOQPjSaRp/Re
         e0gwxZNT/WgKuiGr5GgfWfHPYfELC3ygZ/R4MCL/lEAl/CiZBLN4NLTWvWIIhACP3cRI
         r7MHOF0/+6GJtU6N3vGa4q/Jbcxz4bWfQkh8DHi1yden6uOsaAY4KrqW0konBFZtTJaE
         ylwA==
X-Gm-Message-State: AOAM532G/pQdNPPZn1BjgDwxj4Dtez5EZcvlEEJggH8dnGZUQZ5Q/5PK
        5iU39GTWNHljbEffRfotlzWwoiIxutvPXhuezGY=
X-Google-Smtp-Source: ABdhPJwkiV0/WkoW/7VZvUXBrMpMorE095G2RrRzoqHNL1SBzSSoYk+J7z6PYenGvCrfvCuWkTTLKTNaBoWIyTsdQjE=
X-Received: by 2002:a63:c74b:: with SMTP id v11mr10090081pgg.336.1614120301268;
 Tue, 23 Feb 2021 14:45:01 -0800 (PST)
MIME-Version: 1.0
References: <00000000000056c3e005b82689d1@google.com> <000000000000d8369805bc01fe68@google.com>
In-Reply-To: <000000000000d8369805bc01fe68@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 23 Feb 2021 14:44:50 -0800
Message-ID: <CAM_iQpVOyYGoWdEkZ62yYRoK0G+xEPqYBod2=8QOu9d8X3-c1w@mail.gmail.com>
Subject: Re: general protection fault in xfrm_user_rcv_msg_compat
To:     syzbot <syzbot+5078fc2d7cf37d71de1c@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 23, 2021 at 6:55 AM syzbot
<syzbot+5078fc2d7cf37d71de1c@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    a99163e9 Merge tag 'devicetree-for-5.12' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11a6fccad00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7a875029a795d230
> dashboard link: https://syzkaller.appspot.com/bug?extid=5078fc2d7cf37d71de1c
> userspace arch: i386
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=167c1832d00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10214f12d00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5078fc2d7cf37d71de1c@syzkaller.appspotmail.com
>
> general protection fault, probably for non-canonical address 0xe51af2c1f2c7bd20: 0000 [#1] PREEMPT SMP KASAN
> KASAN: maybe wild-memory-access in range [0x28d7b60f963de900-0x28d7b60f963de907]
> CPU: 1 PID: 8357 Comm: syz-executor113 Not tainted 5.11.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:nla_type include/net/netlink.h:1130 [inline]
> RIP: 0010:xfrm_xlate32_attr net/xfrm/xfrm_compat.c:404 [inline]
> RIP: 0010:xfrm_xlate32 net/xfrm/xfrm_compat.c:526 [inline]
> RIP: 0010:xfrm_user_rcv_msg_compat+0x5e5/0x1070 net/xfrm/xfrm_compat.c:571

Looks like we have to initialize the pointer array to NULL's.

diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
index d8e8a11ca845..56fb32f90799 100644
--- a/net/xfrm/xfrm_compat.c
+++ b/net/xfrm/xfrm_compat.c
@@ -537,7 +537,7 @@ static struct nlmsghdr
*xfrm_user_rcv_msg_compat(const struct nlmsghdr *h32,
 {
        /* netlink_rcv_skb() checks if a message has full (struct nlmsghdr) */
        u16 type = h32->nlmsg_type - XFRM_MSG_BASE;
-       struct nlattr *attrs[XFRMA_MAX+1];
+       struct nlattr *attrs[XFRMA_MAX+1] = {0};
        struct nlmsghdr *h64;
        size_t len;
        int err;
