Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 760F33D78B2
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 16:43:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236871AbhG0OnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 10:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232432AbhG0OnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 10:43:24 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4C2C0613C1;
        Tue, 27 Jul 2021 07:43:22 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id d17so22178728lfv.0;
        Tue, 27 Jul 2021 07:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=LvguakZhljJ6qsltWl9Xtfz0TMtM4W2dtQG1XypA974=;
        b=rv3QNcVnds0tQICQRm4SgSmF7d0MGCrWGBrwaGu87Ux6eYDsDJwUOXCgfSlDKBQjfU
         ikZmEaexAEySC0iUndVEtCAK83Du4dhLWaVDsfwfE38fbPb7O1zzbzy7CUGBIl0rsZXi
         Benjv+25SvBGssKvr7/rYgRURVhUWxbGpp8AA5QY3iZxmLJlY0YBq3GCTW2kaFY6EcTk
         Ja84eavN2Vqj5X7GnoS8s1946e9tLH2TGC3GniC+vH+X4J+CxUS8/VoDgM6oahxjd63W
         /8SuEXa/TVi7BxJImIQJZO9fUD0no38oVH7/r9ykhCyskTvR7eBBt+Bortl7bqmhI62e
         QjUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=LvguakZhljJ6qsltWl9Xtfz0TMtM4W2dtQG1XypA974=;
        b=sLmZDZ3oYGzsdauLSgVbl72MuYhs1SElW+MI4yBr0TarXvceLW9oMqK1ownQsy8edz
         1Q0RI72jlbei4/1HA96vMhlnkhh8t1R9UZ69k8L+9BXn1Y5V4Ihve2qID0TYVKyyMhHt
         V5hIuhJ482ss0ijB/oPm1Yiq6ANrUKxgdJbVzdjm8inoJO7YEB7ATBHPYxijuHVGUx43
         GxJ/TBUvZo1C5J2ERxd/k63b5FXJmqfPPQU34/jV9DgL+Dfftv6Zi1QCif6z5OtA84c3
         WXtQWMeBBPOjuMwLapX5epumWyjDtGWEtlDOgS4+UPxbTa3P1Xhb5wIr7A0ZM6kvTZHh
         tppw==
X-Gm-Message-State: AOAM533Vrm9Vj2JPN/6nAJT3LfjDBFCZyCOHv8z/I4YZTmTa0ukHg1vJ
        S/K1r0pToPq1kwX7irFHd7I=
X-Google-Smtp-Source: ABdhPJwcFkF5a0cuZJ1xWDxQkTqYNVhza1PTfDih4HBjGFkT2XaZmevO74FY0lyjY5u8x4x2LNAUEw==
X-Received: by 2002:a19:7512:: with SMTP id y18mr16764455lfe.533.1627397001190;
        Tue, 27 Jul 2021 07:43:21 -0700 (PDT)
Received: from localhost.localdomain ([94.103.227.213])
        by smtp.gmail.com with ESMTPSA id i16sm311661lfg.139.2021.07.27.07.43.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 07:43:20 -0700 (PDT)
Date:   Tue, 27 Jul 2021 17:43:18 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     syzbot <syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        steffen.klassert@secunet.com, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] UBSAN: shift-out-of-bounds in xfrm_set_default
Message-ID: <20210727174318.53806d27@gmail.com>
In-Reply-To: <0000000000004f5de905c81a45e7@google.com>
References: <0000000000004f5de905c81a45e7@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/UMAwpennY/SnMSMQPwA2e3u"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--MP_/UMAwpennY/SnMSMQPwA2e3u
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, 27 Jul 2021 05:47:21 -0700
syzbot <syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    90d856e71443 Add linux-next specific files for
> 20210723 git tree:       linux-next
> console output:
> https://syzkaller.appspot.com/x/log.txt?x=133fd00a300000 kernel
> config:  https://syzkaller.appspot.com/x/.config?x=298516715f6ad5cd
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=9cd5837a045bbee5b810
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU
> Binutils for Debian) 2.35.1 syz repro:
> https://syzkaller.appspot.com/x/repro.syz?x=1263bba6300000 C
> reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1066b4d4300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the
> commit: Reported-by:
> syzbot+9cd5837a045bbee5b810@syzkaller.appspotmail.com
> 
> netlink: 228 bytes leftover after parsing attributes in process
> `syz-executor669'.
> ================================================================================


The first thing that comes in mind is to check up->dirmask value


#syz test
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master 


With regards,
Pavel Skripkin



--MP_/UMAwpennY/SnMSMQPwA2e3u
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename=0001-net-xfrm-fix-shift-out-of-bounce.patch

From 30db223b1f724ca241c7fa15769d0c65eada3b66 Mon Sep 17 00:00:00 2001
From: Pavel Skripkin <paskripkin@gmail.com>
Date: Tue, 27 Jul 2021 17:38:24 +0300
Subject: [PATCH] net: xfrm: fix shift-out-of-bounce

We need to check up->dirmask to avoid shift-out-of-bounce bug,
since up->dirmask comes from userspace.

Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
---
 net/xfrm/xfrm_user.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index acc3a0dab331..5f3fe2295519 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -1966,9 +1966,14 @@ static int xfrm_set_default(struct sk_buff *skb, struct nlmsghdr *nlh,
 {
 	struct net *net = sock_net(skb->sk);
 	struct xfrm_userpolicy_default *up = nlmsg_data(nlh);
-	u8 dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK;
+	u8 dirmask;
 	u8 old_default = net->xfrm.policy_default;
 
+	if (up->dirmask >= sizeof(up->action) * 8)
+		return -EINVAL;
+
+	dirmask = (1 << up->dirmask) & XFRM_POL_DEFAULT_MASK
+
 	net->xfrm.policy_default = (old_default & (0xff ^ dirmask))
 				    | (up->action << up->dirmask);
 
-- 
2.32.0


--MP_/UMAwpennY/SnMSMQPwA2e3u--
