Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D2D3B100F
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 15:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732227AbfILNeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 09:34:09 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41009 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731283AbfILNeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 09:34:09 -0400
Received: by mail-pf1-f193.google.com with SMTP id b13so16011988pfo.8;
        Thu, 12 Sep 2019 06:34:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AOatXHCitiKL87ERXc3HpgwYrhBGRNlx7jOwScjCRWU=;
        b=Jr/O3OdJj5XEnZw9E5KhFE2e/P79Jxv45DzbCTVOnksxsCZLrCsglgTpjMhP/CUqpQ
         FxV/i9DjBWTuL0AgSOo3VZL/AswHSKtAfuKmG4suDcX+Bo9I+QEPA60qEFxwB3BmO52s
         BA0mppgozs5ioUi9yc4VLIP/po1IZ22wKz7jLXvHsDXeM1TT6SAeDUGK5eUCaPCkcguW
         z6HpeNcKUAb0mcD54P7MFHNhRj1FZ+eVpuKeWjhRJNXf1F1/7VxXdF/VtDt5Li9xk5gL
         grIdetkJXTrCF7R8ZDbrTKoFtpBzoQtB0NDBB0beq5pgYNv+ziQznxWPIbs1omNQcZ08
         EyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AOatXHCitiKL87ERXc3HpgwYrhBGRNlx7jOwScjCRWU=;
        b=J2v7+TuYy1c7WCnzWSDsMhk29wPYOchEgEkUk0qJKuBdNTeYRee662LXpWt1Z2nbLD
         iCWlxRyICcFj+P4C/yDerreXWiqXP7AHKhsIT8m7ILGscqvjRqRKt1c9VV4OiUsihMeD
         sJ//DYUJ+8i3PBMb0zQqSh9nrsIsH1h9K7ZhYqZnB892EywIgBM6VwZ39LWSOKIqCABI
         vxSqiXPB97/BUaTyVrszkHP/FlcAzeb62OpcO0cvullufJYOO+4T1Cg/LjozwoxcfoOA
         EygiOKOzHc5J/HJ5jAWtKcHWckFd19XBNKEzD27mMMPaLIqNtZyqzKKSFx0iTjD5RP2C
         +A3w==
X-Gm-Message-State: APjAAAX2hqhz7ZG/SB5iT6Ib9p9MAANx3Orb8fj9KNdNAahxCAue5LKa
        z7Fye9XYDHgH8n4UyufmYw==
X-Google-Smtp-Source: APXvYqx+o3gwfnUvsIkknmFCS2MYpF0zqj4FQzZXkli86+QlMwz3klWltYz4z1f6onv6AZ6GOeAMzg==
X-Received: by 2002:a62:7c47:: with SMTP id x68mr49463684pfc.178.1568295248717;
        Thu, 12 Sep 2019 06:34:08 -0700 (PDT)
Received: from DESKTOP (softbank126011092035.bbtec.net. [126.11.92.35])
        by smtp.gmail.com with ESMTPSA id u17sm15239pjn.7.2019.09.12.06.34.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 12 Sep 2019 06:34:07 -0700 (PDT)
Date:   Thu, 12 Sep 2019 22:34:02 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     syzbot <syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com>
Cc:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, kafai@fb.com, linux-kernel@vger.kernel.org,
        linux-ppp@vger.kernel.org, netdev@vger.kernel.org,
        paulus@samba.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Subject: Re: memory leak in ppp_write
Message-ID: <CAKK_rchVQCYmjPSxk9MszV9BtF8y04-j2dpjV0Jg3c+nrRNEWQ@mail.gmail.com>
References: <000000000000edc1d5058f5dfa5f@google.com>
 <000000000000594c700591433550@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <000000000000594c700591433550@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

#syz test: https://github.com/google/kasan.git 6525771f


--6WlEvdN9Dv0WHSBl
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ppp-Fix-memory-leak-in-ppp_write.patch"

From e4ff0d04a4b8dd6da3dfb9135235ae5360ce86e6 Mon Sep 17 00:00:00 2001
From: Takeshi Misawa <jeliantsurux@gmail.com>
Date: Wed, 11 Sep 2019 22:18:43 +0900
Subject: [PATCH] ppp: Fix memory leak in ppp_write

When ppp is closing, __ppp_xmit_process() failed to enqueue skb
and skb allocated in ppp_write() is leaked.

syzbot reported :
BUG: memory leak
unreferenced object 0xffff88812a17bc00 (size 224):
  comm "syz-executor673", pid 6952, jiffies 4294942888 (age 13.040s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000d110fff9>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000d110fff9>] slab_post_alloc_hook mm/slab.h:522 [inline]
    [<00000000d110fff9>] slab_alloc_node mm/slab.c:3262 [inline]
    [<00000000d110fff9>] kmem_cache_alloc_node+0x163/0x2f0 mm/slab.c:3574
    [<000000002d616113>] __alloc_skb+0x6e/0x210 net/core/skbuff.c:197
    [<000000000167fc45>] alloc_skb include/linux/skbuff.h:1055 [inline]
    [<000000000167fc45>] ppp_write+0x48/0x120 drivers/net/ppp/ppp_generic.c:502
    [<000000009ab42c0b>] __vfs_write+0x43/0xa0 fs/read_write.c:494
    [<00000000086b2e22>] vfs_write fs/read_write.c:558 [inline]
    [<00000000086b2e22>] vfs_write+0xee/0x210 fs/read_write.c:542
    [<00000000a2b70ef9>] ksys_write+0x7c/0x130 fs/read_write.c:611
    [<00000000ce5e0fdd>] __do_sys_write fs/read_write.c:623 [inline]
    [<00000000ce5e0fdd>] __se_sys_write fs/read_write.c:620 [inline]
    [<00000000ce5e0fdd>] __x64_sys_write+0x1e/0x30 fs/read_write.c:620
    [<00000000d9d7b370>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<0000000006e6d506>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fix this by freeing skb, if ppp is closing.

Reported-by: syzbot+d9c8bf24e56416d7ce2c@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
---
 drivers/net/ppp/ppp_generic.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ppp/ppp_generic.c b/drivers/net/ppp/ppp_generic.c
index a30e41a56085..9a1b006904a7 100644
--- a/drivers/net/ppp/ppp_generic.c
+++ b/drivers/net/ppp/ppp_generic.c
@@ -1415,6 +1415,8 @@ static void __ppp_xmit_process(struct ppp *ppp, struct sk_buff *skb)
 			netif_wake_queue(ppp->dev);
 		else
 			netif_stop_queue(ppp->dev);
+	} else {
+		kfree_skb(skb);
 	}
 	ppp_xmit_unlock(ppp);
 }
-- 
2.17.1


--6WlEvdN9Dv0WHSBl--
