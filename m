Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E2C1F4971
	for <lists+netdev@lfdr.de>; Wed, 10 Jun 2020 00:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728513AbgFIWiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jun 2020 18:38:10 -0400
Received: from correo.us.es ([193.147.175.20]:35532 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbgFIWiI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Jun 2020 18:38:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C70931BFA89
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:38:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B7A11DA840
        for <netdev@vger.kernel.org>; Wed, 10 Jun 2020 00:38:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id ACAC7DA852; Wed, 10 Jun 2020 00:38:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-105.7 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,SORTED_RECIPS,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled
        version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D1B11DA844;
        Wed, 10 Jun 2020 00:38:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 10 Jun 2020 00:38:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id AA9514251482;
        Wed, 10 Jun 2020 00:38:02 +0200 (CEST)
Date:   Wed, 10 Jun 2020 00:38:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     syzbot <syzbot+b005af2cfb0411e617de@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net, fw@strlen.de,
        kadlec@netfilter.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Subject: Re: memory leak in ctnetlink_start
Message-ID: <20200609223802.GB29165@salvia>
References: <000000000000df74f605a7add28b@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3lcZGd9BuhuYXNfi"
Content-Disposition: inline
In-Reply-To: <000000000000df74f605a7add28b@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--3lcZGd9BuhuYXNfi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 09, 2020 at 02:58:12PM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    7ae77150 Merge tag 'powerpc-5.8-1' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=128a9df2100000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9a1aa05456dfd557
> dashboard link: https://syzkaller.appspot.com/bug?extid=b005af2cfb0411e617de
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17304a96100000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=168a9df2100000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+b005af2cfb0411e617de@syzkaller.appspotmail.com
> 
> executing program
> executing program
> executing program
> BUG: memory leak
> unreferenced object 0xffff88811c797900 (size 128):
>   comm "syz-executor256", pid 6458, jiffies 4294947022 (age 13.050s)
>   hex dump (first 32 bytes):
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<000000004276332a>] kmalloc include/linux/slab.h:555 [inline]
>     [<000000004276332a>] kzalloc include/linux/slab.h:669 [inline]
>     [<000000004276332a>] ctnetlink_alloc_filter+0x3a/0x2a0 net/netfilter/nf_conntrack_netlink.c:924
>     [<000000000047e6fb>] ctnetlink_start+0x3a/0x80 net/netfilter/nf_conntrack_netlink.c:998
>     [<00000000a431a924>] __netlink_dump_start+0x1a3/0x2e0 net/netlink/af_netlink.c:2343
>     [<0000000016b073fa>] netlink_dump_start include/linux/netlink.h:246 [inline]
>     [<0000000016b073fa>] ctnetlink_get_conntrack+0x26d/0x2f0 net/netfilter/nf_conntrack_netlink.c:1611
>     [<00000000d311138b>] nfnetlink_rcv_msg+0x32f/0x370 net/netfilter/nfnetlink.c:229
>     [<0000000008feca87>] netlink_rcv_skb+0x5a/0x180 net/netlink/af_netlink.c:2469
>     [<0000000088caad78>] nfnetlink_rcv+0x83/0x1b0 net/netfilter/nfnetlink.c:563
>     [<0000000052160488>] netlink_unicast_kernel net/netlink/af_netlink.c:1303 [inline]
>     [<0000000052160488>] netlink_unicast+0x20a/0x2f0 net/netlink/af_netlink.c:1329
>     [<00000000ee36d991>] netlink_sendmsg+0x2b5/0x560 net/netlink/af_netlink.c:1918
>     [<00000000dee2cafe>] sock_sendmsg_nosec net/socket.c:652 [inline]
>     [<00000000dee2cafe>] sock_sendmsg+0x4c/0x60 net/socket.c:672
>     [<00000000b0b655cb>] ____sys_sendmsg+0x2c4/0x2f0 net/socket.c:2352
>     [<000000005bba2f8d>] ___sys_sendmsg+0x8a/0xd0 net/socket.c:2406
>     [<0000000060ac6563>] __sys_sendmsg+0x77/0xe0 net/socket.c:2439
>     [<000000002f7b34b0>] do_syscall_64+0x6e/0x220 arch/x86/entry/common.c:295
>     [<00000000941009bb>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

Hm, filter is not released in the error path.

--3lcZGd9BuhuYXNfi
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="z.patch"

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index d7bd8b1f27d5..832eabecfbdd 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -939,7 +939,8 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 			filter->mark.mask = 0xffffffff;
 		}
 	} else if (cda[CTA_MARK_MASK]) {
-		return ERR_PTR(-EINVAL);
+		err = -EINVAL;
+		goto err_filter;
 	}
 #endif
 	if (!cda[CTA_FILTER])
@@ -947,15 +948,17 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 
 	err = ctnetlink_parse_zone(cda[CTA_ZONE], &filter->zone);
 	if (err < 0)
-		return ERR_PTR(err);
+		goto err_filter;
 
 	err = ctnetlink_parse_filter(cda[CTA_FILTER], filter);
 	if (err < 0)
-		return ERR_PTR(err);
+		goto err_filter;
 
 	if (filter->orig_flags) {
-		if (!cda[CTA_TUPLE_ORIG])
-			return ERR_PTR(-EINVAL);
+		if (!cda[CTA_TUPLE_ORIG]) {
+			err = -EINVAL;
+			goto err_filter;
+		}
 
 		err = ctnetlink_parse_tuple_filter(cda, &filter->orig,
 						   CTA_TUPLE_ORIG,
@@ -963,23 +966,32 @@ ctnetlink_alloc_filter(const struct nlattr * const cda[], u8 family)
 						   &filter->zone,
 						   filter->orig_flags);
 		if (err < 0)
-			return ERR_PTR(err);
+			goto err_filter;
 	}
 
 	if (filter->reply_flags) {
-		if (!cda[CTA_TUPLE_REPLY])
-			return ERR_PTR(-EINVAL);
+		if (!cda[CTA_TUPLE_REPLY]) {
+			err = -EINVAL;
+			goto err_filter;
+		}
 
 		err = ctnetlink_parse_tuple_filter(cda, &filter->reply,
 						   CTA_TUPLE_REPLY,
 						   filter->family,
 						   &filter->zone,
 						   filter->orig_flags);
-		if (err < 0)
-			return ERR_PTR(err);
+		if (err < 0) {
+			err = -EINVAL;
+			goto err_filter;
+		}
 	}
 
 	return filter;
+
+err_filter:
+	kfree(filter);
+
+	return ERR_PTR(err);
 }
 
 static bool ctnetlink_needs_filter(u8 family, const struct nlattr * const *cda)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 073aa1051d43..5792e9dcd9bc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -6550,12 +6550,22 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	return err;
 }
 
+static void nft_flowtable_hook_release(struct nft_flowtable_hook *flowtable_hook)
+{
+	struct nft_hook *this, *next;
+
+	list_for_each_entry_safe(this, next, &flowtable_hook->list, list) {
+		list_del(&this->list);
+		kfree(this);
+	}
+}
+
 static int nft_delflowtable_hook(struct nft_ctx *ctx,
 				 struct nft_flowtable *flowtable)
 {
 	const struct nlattr * const *nla = ctx->nla;
 	struct nft_flowtable_hook flowtable_hook;
-	struct nft_hook *this, *next, *hook;
+	struct nft_hook *this, *hook;
 	struct nft_trans *trans;
 	int err;
 
@@ -6564,33 +6574,40 @@ static int nft_delflowtable_hook(struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	list_for_each_entry_safe(this, next, &flowtable_hook.list, list) {
+	list_for_each_entry(this, &flowtable_hook.list, list) {
 		hook = nft_hook_list_find(&flowtable->hook_list, this);
 		if (!hook) {
 			err = -ENOENT;
 			goto err_flowtable_del_hook;
 		}
 		hook->inactive = true;
-		list_del(&this->list);
-		kfree(this);
 	}
 
 	trans = nft_trans_alloc(ctx, NFT_MSG_DELFLOWTABLE,
 				sizeof(struct nft_trans_flowtable));
-	if (!trans)
-		return -ENOMEM;
+	if (!trans) {
+		err = -ENOMEM;
+		goto err_flowtable_del_hook;
+	}
 
 	nft_trans_flowtable(trans) = flowtable;
 	nft_trans_flowtable_update(trans) = true;
 	INIT_LIST_HEAD(&nft_trans_flowtable_hooks(trans));
+	nft_flowtable_hook_release(&flowtable_hook);
 
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 
 	return 0;
 
 err_flowtable_del_hook:
-	list_for_each_entry(hook, &flowtable_hook.list, list)
+	list_for_each_entry(this, &flowtable->hook_list, list) {
+		hook = nft_hook_list_find(&flowtable->hook_list, this);
+		if (!hook)
+			break;
+
 		hook->inactive = false;
+	}
+	nft_flowtable_hook_release(&flowtable_hook);
 
 	return err;
 }

--3lcZGd9BuhuYXNfi--
