Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7161DD65D
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 05:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727406AbfJSDnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 23:43:22 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:38027 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfJSDnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 23:43:22 -0400
Received: by mail-pg1-f194.google.com with SMTP id w3so4392863pgt.5;
        Fri, 18 Oct 2019 20:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=4sBZf1JX41IExY7eNYd2bWZHHYfpyb6PwCN8lkqayLk=;
        b=TdYTqhCHXm2g+jvcpAGRwE0omhaEnZ2deMLCNLdm15J0iHOwXSFdqyCvr29sUnOppo
         W3IKP2i9rI1ri8567xV+4Fh1khRPQU7G+xUaGFbVbyHGxumwTWnzl41uL4Yv54Fd4Toc
         uptCBRtKsAPUACkElMLY/mZ5GYmC3t1edH+gT+FdJdXoG0YMGsHLex4a4RBjL2MddLr5
         TCLa4mqFGxqLnRuvM9OeGBNWYtbaI18bSaJO30fLTZJSpQTwjqfpBrqjDu2hJ8m66G2o
         j1rj2nUGU/DOIGMfjEOMMkMQqEw2VJnJDumTmoYFs/MIeaFJcORTIxqpkNDas5fA/3U/
         fvyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=4sBZf1JX41IExY7eNYd2bWZHHYfpyb6PwCN8lkqayLk=;
        b=JszKJV9YEY49M8F2dgKPKGe6iQRRJ3n0ITdYlS/61Q2HbUKLhTZwTexX5IGs5W2VFj
         eg0hMDHKluPWtWHRJRsiA4LSeCV1BQiCzeh++LOhY9DL27OoOUZ/MKU80YyztOkcj0vA
         rEyijJ5cpt/pAQo+H8S8+DfttW3Dx8dERG4tEq4ZwV+rrPtgVxfWL4CWYBBwWeJMIueR
         aNPCXUJ3WQvM9z7GNgCKQa/h63mNVScXPVQQfJ53g64WpRCkHjbA+y8W7E1CIlxFhCv8
         H2UME2chrFEvlXOryc1h6ixvSFZVEZD5MahX7djdfxwGqWit1b+i4CI5NPh6PGQpi7v7
         2obA==
X-Gm-Message-State: APjAAAX1gne/R4kLbGEQiUU60IvdntPdK67yIhztukRSs2k+sNtyUYfU
        FjxlJUXqivAu76yB7/VGwg==
X-Google-Smtp-Source: APXvYqyaIT31iR+UYJ9n9zS5Qe5pO9vsAmh553gdIXrN/u9WsmC31wPsOAxTNE4JV0eHF5fYeh2zPw==
X-Received: by 2002:a63:d504:: with SMTP id c4mr13155061pgg.75.1571456601665;
        Fri, 18 Oct 2019 20:43:21 -0700 (PDT)
Received: from DESKTOP (softbank126006126096.bbtec.net. [126.6.126.96])
        by smtp.gmail.com with ESMTPSA id cx22sm6385020pjb.19.2019.10.18.20.43.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 18 Oct 2019 20:43:20 -0700 (PDT)
Date:   Sat, 19 Oct 2019 12:43:14 +0900
From:   Takeshi Misawa <jeliantsurux@gmail.com>
To:     syzbot <syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com>
Cc:     a.p.zijlstra@chello.nl, acme@redhat.com, andi@firstfloor.org,
        "David S. Miller" <davem@davemloft.net>, dhowells@redhat.com,
        dsahern@gmail.com, jakub.kicinski@netronome.com,
        johannes.berg@intel.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, namhyung@kernel.org,
        netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        syzkaller-bugs@googlegroups.com, tyhicks@canonical.com,
        willy@infradead.org
Subject: Re: memory leak in copy_net_ns
Message-ID: <CAKK_rcj55g8WPCLrrLdT+8zWLXXOMVf0jhMyYQj9jndy_+i8qw@mail.gmail.com>
References: <0000000000000bf1e50593533a38@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <0000000000000bf1e50593533a38@google.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

#syz test: https://github.com/google/kasan.git 43b815c6

--SLDf9lqlvOQaIe6s
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-keys-Fix-memory-leak-in-copy_net_ns.patch"

From 366b85e1555a8ef4d0f0759c2da8d8dff4598ace Mon Sep 17 00:00:00 2001
From: Takeshi Misawa <jeliantsurux@gmail.com>
Date: Sat, 19 Oct 2019 11:44:45 +0900
Subject: [PATCH] keys: Fix memory leak in copy_net_ns

If copy_net_ns() failed after net_alloc(), net->key_domain is leaked.
Fix this, by freeing key_domain in error path.

syzbot report:
BUG: memory leak
unreferenced object 0xffff8881175007e0 (size 32):
  comm "syz-executor902", pid 7069, jiffies 4294944350 (age 28.400s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace:
    [<00000000a83ed741>] kmemleak_alloc_recursive include/linux/kmemleak.h:43 [inline]
    [<00000000a83ed741>] slab_post_alloc_hook mm/slab.h:439 [inline]
    [<00000000a83ed741>] slab_alloc mm/slab.c:3326 [inline]
    [<00000000a83ed741>] kmem_cache_alloc_trace+0x13d/0x280 mm/slab.c:3553
    [<0000000059fc92b9>] kmalloc include/linux/slab.h:547 [inline]
    [<0000000059fc92b9>] kzalloc include/linux/slab.h:742 [inline]
    [<0000000059fc92b9>] net_alloc net/core/net_namespace.c:398 [inline]
    [<0000000059fc92b9>] copy_net_ns+0xb2/0x220 net/core/net_namespace.c:445
    [<00000000a9d74bbc>] create_new_namespaces+0x141/0x2a0 kernel/nsproxy.c:103
    [<000000008047d645>] unshare_nsproxy_namespaces+0x7f/0x100 kernel/nsproxy.c:202
    [<000000005993ea6e>] ksys_unshare+0x236/0x490 kernel/fork.c:2674
    [<0000000019417e75>] __do_sys_unshare kernel/fork.c:2742 [inline]
    [<0000000019417e75>] __se_sys_unshare kernel/fork.c:2740 [inline]
    [<0000000019417e75>] __x64_sys_unshare+0x16/0x20 kernel/fork.c:2740
    [<00000000f4c5f2c8>] do_syscall_64+0x76/0x1a0 arch/x86/entry/common.c:296
    [<0000000038550184>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

syzbot reported other leak in copy_net_ns -> setup_net.
This problem is already fixed by cf47a0b882a4e5f6b34c7949d7b293e9287f1972.

sysbot link:
https://syzkaller.appspot.com/bug?id=3babacc2ed6bddb8e168d022ef77d32db0e05ea6

Fixes: 9b242610514f ("keys: Network namespace domain tag")
Reported-by: syzbot+3b3296d032353c33184b@syzkaller.appspotmail.com
Signed-off-by: Takeshi Misawa <jeliantsurux@gmail.com>
---
 net/core/net_namespace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index a0e0d298c991..b88905792795 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -478,6 +478,7 @@ struct net *copy_net_ns(unsigned long flags,
 
 	if (rv < 0) {
 put_userns:
+		key_remove_domain(net->key_domain);
 		put_user_ns(user_ns);
 		net_drop_ns(net);
 dec_ucounts:
-- 
2.17.1


--SLDf9lqlvOQaIe6s--
