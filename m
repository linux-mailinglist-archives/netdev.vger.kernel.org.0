Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11E8E313BED
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 18:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235022AbhBHR6v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 12:58:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231872AbhBHRz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 12:55:59 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D516C061793
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 09:55:18 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id o21so9309671pgn.12
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 09:55:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=5LwNILtJ+GSUJjj0ZmPbjj70IBpIbFtM9sxTftOlGq4=;
        b=YqR+j9U/rLMaKFsiwzrnA8ThwsN5t4kvOMRM2XFX9JeohqHsSxFAKfWtHBBPXb3XWu
         dnVXuy1zGWU+XDQlDjQzJH7VYcsC9SbDH8yGksSIXni63DtPpCeyMVVKLOH57maNVolS
         vjz91bkyQ72iubcDOQr30hnOLLv23b0CCX4/YT8pI/wbcTKqeLyz9aFfPv5D1w3QmyBa
         Ng4iHuS8G54Pse2WbZ8jab4j4cOUEAU/g44cLHs6akqgXh1L04qwvXPC3CA4XXur/MSE
         PXKX2gYtSYUNpBbKXBNJCvJv2J1lxuA0bw6IF6NnPWI3K7YZgaXNYhVfva6lu8I1+Xfb
         S+KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=5LwNILtJ+GSUJjj0ZmPbjj70IBpIbFtM9sxTftOlGq4=;
        b=ENJOwNfb7MHtBCWqxRhSejn5LFj81yxHqn8bGDFLdNVlk/iIBHKPngbD4ojpq6ILt8
         /r2Spyo0uM9FgXgSOHpL8JrIo4rcDMXASHx667O/ipySGNez2ym1X9GBa9xo6+bX3Qp/
         PeUchrMjGsfiKFV8Cc7YNWK0omc0dh22SDnWhH96E0zDQW+XSawnV5Y91JO0OwJlq04Z
         xv0DJBSjlhzbmPv5L6uafX9k16BPuixZjnaVFrwwV8GyiCEifVP6HJc/PNHOw2VXV/ah
         5xjScHgmtHuRzCqaDFT+GVrnDUFXvNFgjz6BnrUg7E/kgTYCjwRVOUFpj2+f1lCfjsKI
         L2qg==
X-Gm-Message-State: AOAM5300JZN+3DwWu2QehHivtN6daZRq/oap8d2Pcyd8JbSYVGa0cq3D
        BmIc7mcsRy6mpy0mzNGr2lw=
X-Google-Smtp-Source: ABdhPJx4XKKWoAWz8BKxp7RYz7gzWb6rDAItTOKBHPPm7IHplsilO39ULszWsxoaIQLBIXHYuyWXUw==
X-Received: by 2002:a63:d143:: with SMTP id c3mr18944158pgj.86.1612806917841;
        Mon, 08 Feb 2021 09:55:17 -0800 (PST)
Received: from localhost.localdomain ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id e21sm18654361pgv.74.2021.02.08.09.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 09:55:17 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        dsahern@kernel.org, xiyou.wangcong@gmail.com
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 5/8] mld: rename igmp6 to mld
Date:   Mon,  8 Feb 2021 17:55:06 +0000
Message-Id: <20210208175506.5284-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

ipv6 multicast protocol is MLD, not IGMP6.
So it should be renamed.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 include/net/ndisc.h |  14 ++--
 net/ipv6/af_inet6.c |  12 +--
 net/ipv6/icmp.c     |   4 +-
 net/ipv6/mcast.c    | 198 ++++++++++++++++++++++----------------------
 4 files changed, 115 insertions(+), 113 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 38e4094960ce..09b1e5948b73 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -479,17 +479,17 @@ void ndisc_update(const struct net_device *dev, struct neighbour *neigh,
 		  struct ndisc_options *ndopts);
 
 /*
- *	IGMP
+ *	MLD
  */
-int igmp6_init(void);
-int igmp6_late_init(void);
+int mld_init(void);
+int mld_late_init(void);
 
-void igmp6_cleanup(void);
-void igmp6_late_cleanup(void);
+void mld_cleanup(void);
+void mld_late_cleanup(void);
 
-int igmp6_event_query(struct sk_buff *skb);
+int mld_event_query(struct sk_buff *skb);
 
-int igmp6_event_report(struct sk_buff *skb);
+int mld_event_report(struct sk_buff *skb);
 
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 0e9994e0ecd7..ace6527171bd 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1105,7 +1105,7 @@ static int __init inet6_init(void)
 	err = ndisc_init();
 	if (err)
 		goto ndisc_fail;
-	err = igmp6_init();
+	err = mld_init();
 	if (err)
 		goto igmp_fail;
 
@@ -1186,9 +1186,9 @@ static int __init inet6_init(void)
 	if (err)
 		goto rpl_fail;
 
-	err = igmp6_late_init();
+	err = mld_late_init();
 	if (err)
-		goto igmp6_late_err;
+		goto mld_late_err;
 
 #ifdef CONFIG_SYSCTL
 	err = ipv6_sysctl_register();
@@ -1205,9 +1205,9 @@ static int __init inet6_init(void)
 
 #ifdef CONFIG_SYSCTL
 sysctl_fail:
-	igmp6_late_cleanup();
+	mld_late_cleanup();
 #endif
-igmp6_late_err:
+mld_late_err:
 	rpl_exit();
 rpl_fail:
 	seg6_exit();
@@ -1252,7 +1252,7 @@ static int __init inet6_init(void)
 #endif
 	ipv6_netfilter_fini();
 netfilter_fail:
-	igmp6_cleanup();
+	mld_cleanup();
 igmp_fail:
 	ndisc_cleanup();
 ndisc_fail:
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index f3d05866692e..af0382a0de3c 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -943,11 +943,11 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		break;
 
 	case ICMPV6_MGM_QUERY:
-		igmp6_event_query(skb);
+		mld_event_query(skb);
 		break;
 
 	case ICMPV6_MGM_REPORT:
-		igmp6_event_report(skb);
+		mld_event_report(skb);
 		break;
 
 	case ICMPV6_MGM_REDUCTION:
diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index ed31b3212b9e..21f3bbec5568 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -70,8 +70,8 @@ static int __mld2_query_bugs[] __attribute__((__unused__)) = {
 static struct workqueue_struct *mld_wq;
 static struct in6_addr mld2_all_mcr = MLD2_ALL_MCR_INIT;
 
-static void igmp6_join_group(struct ifmcaddr6 *mc);
-static void igmp6_leave_group(struct ifmcaddr6 *mc);
+static void mld_join_group(struct ifmcaddr6 *mc);
+static void mld_leave_group(struct ifmcaddr6 *mc);
 static void mld_mca_work(struct work_struct *work);
 
 static void mld_ifc_event(struct inet6_dev *idev);
@@ -663,7 +663,7 @@ bool inet6_mc_check(struct sock *sk, const struct in6_addr *mc_addr,
 	return rv;
 }
 
-static void igmp6_group_added(struct ifmcaddr6 *mc)
+static void mld_group_added(struct ifmcaddr6 *mc)
 {
 	struct net_device *dev = mc->idev->dev;
 	char buf[MAX_ADDR_LEN];
@@ -684,7 +684,7 @@ static void igmp6_group_added(struct ifmcaddr6 *mc)
 		return;
 
 	if (mld_in_v1_mode(mc->idev)) {
-		igmp6_join_group(mc);
+		mld_join_group(mc);
 		return;
 	}
 	/* else v2 */
@@ -699,7 +699,7 @@ static void igmp6_group_added(struct ifmcaddr6 *mc)
 	mld_ifc_event(mc->idev);
 }
 
-static void igmp6_group_dropped(struct ifmcaddr6 *mc)
+static void mld_group_dropped(struct ifmcaddr6 *mc)
 {
 	struct net_device *dev = mc->idev->dev;
 	char buf[MAX_ADDR_LEN];
@@ -720,7 +720,7 @@ static void igmp6_group_dropped(struct ifmcaddr6 *mc)
 		return;
 
 	if (!mc->idev->dead)
-		igmp6_leave_group(mc);
+		mld_leave_group(mc);
 
 	spin_lock_bh(&mc->mca_lock);
 	if (cancel_delayed_work(&mc->mca_work))
@@ -923,7 +923,7 @@ static int __ipv6_dev_mc_inc(struct net_device *dev,
 	write_unlock_bh(&idev->lock);
 
 	mld_del_delrec(idev, mc);
-	igmp6_group_added(mc);
+	mld_group_added(mc);
 	mca_put(mc);
 	return 0;
 }
@@ -949,7 +949,7 @@ int __ipv6_dev_mc_dec(struct inet6_dev *idev, const struct in6_addr *addr)
 			if (--mc->mca_users == 0) {
 				list_del(&mc->list);
 				write_unlock_bh(&idev->lock);
-				igmp6_group_dropped(mc);
+				mld_group_dropped(mc);
 				ip6_mc_clear_src(mc);
 				mca_put(mc);
 				return 0;
@@ -1080,10 +1080,10 @@ static void mld_dad_stop_work(struct inet6_dev *idev)
 }
 
 /*
- *	IGMP handling (alias multicast ICMPv6 messages)
+ *	MLD handling (alias multicast ICMPv6 messages)
  */
 
-static void igmp6_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
+static void mld_group_queried(struct ifmcaddr6 *mc, unsigned long resptime)
 {
 	unsigned long delay = resptime;
 
@@ -1337,7 +1337,7 @@ static int mld_process_v2(struct inet6_dev *idev, struct mld2_query *mld,
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_query(struct sk_buff *skb)
+int mld_event_query(struct sk_buff *skb)
 {
 	struct mld2_query *mlh2 = NULL;
 	const struct in6_addr *group;
@@ -1425,7 +1425,7 @@ int igmp6_event_query(struct sk_buff *skb)
 	if (group_type == IPV6_ADDR_ANY) {
 		list_for_each_entry(mc, &idev->mc_list, list) {
 			spin_lock_bh(&mc->mca_lock);
-			igmp6_group_queried(mc, max_delay);
+			mld_group_queried(mc, max_delay);
 			spin_unlock_bh(&mc->mca_lock);
 		}
 	} else {
@@ -1446,7 +1446,7 @@ int igmp6_event_query(struct sk_buff *skb)
 			}
 			if (!(mc->mca_flags & MAF_GSQUERY) ||
 			    mld_marksources(mc, ntohs(mlh2->mld2q_nsrcs), mlh2->mld2q_srcs))
-				igmp6_group_queried(mc, max_delay);
+				mld_group_queried(mc, max_delay);
 			spin_unlock_bh(&mc->mca_lock);
 			break;
 		}
@@ -1457,7 +1457,7 @@ int igmp6_event_query(struct sk_buff *skb)
 }
 
 /* called with rcu_read_lock() */
-int igmp6_event_report(struct sk_buff *skb)
+int mld_event_report(struct sk_buff *skb)
 {
 	struct inet6_dev *idev;
 	struct ifmcaddr6 *mc;
@@ -1983,7 +1983,7 @@ static void mld_send_cr(struct inet6_dev *idev)
 	mld_sendpack(skb);
 }
 
-static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
+static void mld_send(struct in6_addr *addr, struct net_device *dev, int type)
 {
 	u8 ra[8] = { IPPROTO_ICMPV6, 0,
 		     IPV6_TLV_ROUTERALERT,
@@ -2439,14 +2439,14 @@ static void ip6_mc_clear_src(struct ifmcaddr6 *mc)
 }
 
 
-static void igmp6_join_group(struct ifmcaddr6 *mc)
+static void mld_join_group(struct ifmcaddr6 *mc)
 {
 	unsigned long delay;
 
 	if (mc->mca_flags & MAF_NOREPORT)
 		return;
 
-	igmp6_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
+	mld_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
 
 	delay = prandom_u32() % unsolicited_report_interval(mc->idev);
 
@@ -2482,12 +2482,12 @@ static int ip6_mc_leave_src(struct sock *sk, struct ipv6_mc_socklist *iml,
 	return err;
 }
 
-static void igmp6_leave_group(struct ifmcaddr6 *mc)
+static void mld_leave_group(struct ifmcaddr6 *mc)
 {
 	if (mld_in_v1_mode(mc->idev)) {
 		if (mc->mca_flags & MAF_LAST_REPORTER)
-			igmp6_send(&mc->mca_addr, mc->idev->dev,
-				   ICMPV6_MGM_REDUCTION);
+			mld_send(&mc->mca_addr, mc->idev->dev,
+				 ICMPV6_MGM_REDUCTION);
 	} else {
 		mld_add_delrec(mc->idev, mc);
 		mld_ifc_event(mc->idev);
@@ -2533,7 +2533,7 @@ static void mld_mca_work(struct work_struct *work)
 					    struct ifmcaddr6, mca_work);
 
 	if (mld_in_v1_mode(mc->idev))
-		igmp6_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
+		mld_send(&mc->mca_addr, mc->idev->dev, ICMPV6_MGM_REPORT);
 	else
 		mld_send_report(mc->idev, mc);
 
@@ -2554,7 +2554,7 @@ void ipv6_mc_unmap(struct inet6_dev *idev)
 
 	read_lock_bh(&idev->lock);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
-		igmp6_group_dropped(mc);
+		mld_group_dropped(mc);
 	read_unlock_bh(&idev->lock);
 }
 
@@ -2574,7 +2574,7 @@ void ipv6_mc_down(struct inet6_dev *idev)
 	read_lock_bh(&idev->lock);
 
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list)
-		igmp6_group_dropped(mc);
+		mld_group_dropped(mc);
 
 	/* Should stop work after group drop. or we will
 	 * start work again in mld_ifc_event()
@@ -2606,7 +2606,7 @@ void ipv6_mc_up(struct inet6_dev *idev)
 	ipv6_mc_reset(idev);
 	list_for_each_entry_safe(mc, tmp, &idev->mc_list, list) {
 		mld_del_delrec(idev, mc);
-		igmp6_group_added(mc);
+		mld_group_added(mc);
 	}
 	read_unlock_bh(&idev->lock);
 }
@@ -2670,7 +2670,7 @@ static void ipv6_mc_rejoin_groups(struct inet6_dev *idev)
 	if (mld_in_v1_mode(idev)) {
 		read_lock_bh(&idev->lock);
 		list_for_each_entry(mc, &idev->mc_list, list)
-			igmp6_join_group(mc);
+			mld_join_group(mc);
 		read_unlock_bh(&idev->lock);
 	} else
 		mld_send_report(idev, NULL);
@@ -2695,22 +2695,22 @@ static int ipv6_mc_netdev_event(struct notifier_block *this,
 	return NOTIFY_DONE;
 }
 
-static struct notifier_block igmp6_netdev_notifier = {
+static struct notifier_block mld_netdev_notifier = {
 	.notifier_call = ipv6_mc_netdev_event,
 };
 
 #ifdef CONFIG_PROC_FS
-struct igmp6_mc_iter_state {
+struct mld_mc_iter_state {
 	struct seq_net_private p;
 	struct net_device *dev;
 	struct inet6_dev *idev;
 };
 
-#define igmp6_mc_seq_private(seq)	((struct igmp6_mc_iter_state *)(seq)->private)
+#define mld_mc_seq_private(seq)	((struct mld_mc_iter_state *)(seq)->private)
 
-static inline struct ifmcaddr6 *igmp6_mc_get_first(struct seq_file *seq)
+static inline struct ifmcaddr6 *mld_mc_get_first(struct seq_file *seq)
 {
-	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
+	struct mld_mc_iter_state *state = mld_mc_seq_private(seq);
 	struct net *net = seq_file_net(seq);
 	struct ifmcaddr6 *mc;
 
@@ -2732,9 +2732,9 @@ static inline struct ifmcaddr6 *igmp6_mc_get_first(struct seq_file *seq)
 	return NULL;
 }
 
-static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr6 *mc)
+static struct ifmcaddr6 *mld_mc_get_next(struct seq_file *seq, struct ifmcaddr6 *mc)
 {
-	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
+	struct mld_mc_iter_state *state = mld_mc_seq_private(seq);
 
 	list_for_each_entry_continue(mc, &state->idev->mc_list, list)
 		return mc;
@@ -2760,35 +2760,35 @@ static struct ifmcaddr6 *igmp6_mc_get_next(struct seq_file *seq, struct ifmcaddr
 	return mc;
 }
 
-static struct ifmcaddr6 *igmp6_mc_get_idx(struct seq_file *seq, loff_t pos)
+static struct ifmcaddr6 *mld_mc_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct ifmcaddr6 *mc = igmp6_mc_get_first(seq);
+	struct ifmcaddr6 *mc = mld_mc_get_first(seq);
 
 	if (mc)
-		while (pos && (mc = igmp6_mc_get_next(seq, mc)) != NULL)
+		while (pos && (mc = mld_mc_get_next(seq, mc)) != NULL)
 			--pos;
 	return pos ? NULL : mc;
 }
 
-static void *igmp6_mc_seq_start(struct seq_file *seq, loff_t *pos)
+static void *mld_mc_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
 	rcu_read_lock();
-	return igmp6_mc_get_idx(seq, *pos);
+	return mld_mc_get_idx(seq, *pos);
 }
 
-static void *igmp6_mc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+static void *mld_mc_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
-	struct ifmcaddr6 *mc = igmp6_mc_get_next(seq, v);
+	struct ifmcaddr6 *mc = mld_mc_get_next(seq, v);
 
 	++*pos;
 	return mc;
 }
 
-static void igmp6_mc_seq_stop(struct seq_file *seq, void *v)
+static void mld_mc_seq_stop(struct seq_file *seq, void *v)
 	__releases(RCU)
 {
-	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
+	struct mld_mc_iter_state *state = mld_mc_seq_private(seq);
 
 	if (likely(state->idev)) {
 		read_unlock_bh(&state->idev->lock);
@@ -2798,10 +2798,10 @@ static void igmp6_mc_seq_stop(struct seq_file *seq, void *v)
 	rcu_read_unlock();
 }
 
-static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
+static int mld_mc_seq_show(struct seq_file *seq, void *v)
 {
 	struct ifmcaddr6 *mc = (struct ifmcaddr6 *)v;
-	struct igmp6_mc_iter_state *state = igmp6_mc_seq_private(seq);
+	struct mld_mc_iter_state *state = mld_mc_seq_private(seq);
 
 	seq_printf(seq,
 		   "%-4d %-15s %pi6 %5d %08X %ld\n",
@@ -2813,25 +2813,25 @@ static int igmp6_mc_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations igmp6_mc_seq_ops = {
-	.start	=	igmp6_mc_seq_start,
-	.next	=	igmp6_mc_seq_next,
-	.stop	=	igmp6_mc_seq_stop,
-	.show	=	igmp6_mc_seq_show,
+static const struct seq_operations mld_mc_seq_ops = {
+	.start	=	mld_mc_seq_start,
+	.next	=	mld_mc_seq_next,
+	.stop	=	mld_mc_seq_stop,
+	.show	=	mld_mc_seq_show,
 };
 
-struct igmp6_mcf_iter_state {
+struct mld_mcf_iter_state {
 	struct seq_net_private p;
 	struct net_device *dev;
 	struct inet6_dev *idev;
 	struct ifmcaddr6 *mc;
 };
 
-#define igmp6_mcf_seq_private(seq)	((struct igmp6_mcf_iter_state *)(seq)->private)
+#define mld_mcf_seq_private(seq)	((struct mld_mcf_iter_state *)(seq)->private)
 
-static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
+static inline struct ip6_sf_list *mld_mcf_get_first(struct seq_file *seq)
 {
-	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
+	struct mld_mcf_iter_state *state = mld_mcf_seq_private(seq);
 	struct net *net = seq_file_net(seq);
 	struct ip6_sf_list *psf = NULL;
 	struct ifmcaddr6 *mc = NULL;
@@ -2863,10 +2863,10 @@ static inline struct ip6_sf_list *igmp6_mcf_get_first(struct seq_file *seq)
 	return psf;
 }
 
-static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq,
-					      struct ip6_sf_list *psf)
+static struct ip6_sf_list *mld_mcf_get_next(struct seq_file *seq,
+					    struct ip6_sf_list *psf)
 {
-	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
+	struct mld_mcf_iter_state *state = mld_mcf_seq_private(seq);
 
 	list_for_each_entry_continue(psf, &state->mc->mca_source_list, list)
 		return psf;
@@ -2913,39 +2913,39 @@ static struct ip6_sf_list *igmp6_mcf_get_next(struct seq_file *seq,
 	return psf;
 }
 
-static struct ip6_sf_list *igmp6_mcf_get_idx(struct seq_file *seq, loff_t pos)
+static struct ip6_sf_list *mld_mcf_get_idx(struct seq_file *seq, loff_t pos)
 {
-	struct ip6_sf_list *psf = igmp6_mcf_get_first(seq);
+	struct ip6_sf_list *psf = mld_mcf_get_first(seq);
 
 	if (psf)
-		while (pos && (psf = igmp6_mcf_get_next(seq, psf)) != NULL)
+		while (pos && (psf = mld_mcf_get_next(seq, psf)) != NULL)
 			--pos;
 	return pos ? NULL : psf;
 }
 
-static void *igmp6_mcf_seq_start(struct seq_file *seq, loff_t *pos)
+static void *mld_mcf_seq_start(struct seq_file *seq, loff_t *pos)
 	__acquires(RCU)
 {
 	rcu_read_lock();
-	return *pos ? igmp6_mcf_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
+	return *pos ? mld_mcf_get_idx(seq, *pos - 1) : SEQ_START_TOKEN;
 }
 
-static void *igmp6_mcf_seq_next(struct seq_file *seq, void *v, loff_t *pos)
+static void *mld_mcf_seq_next(struct seq_file *seq, void *v, loff_t *pos)
 {
 	struct ip6_sf_list *psf;
 
 	if (v == SEQ_START_TOKEN)
-		psf = igmp6_mcf_get_first(seq);
+		psf = mld_mcf_get_first(seq);
 	else
-		psf = igmp6_mcf_get_next(seq, v);
+		psf = mld_mcf_get_next(seq, v);
 	++*pos;
 	return psf;
 }
 
-static void igmp6_mcf_seq_stop(struct seq_file *seq, void *v)
+static void mld_mcf_seq_stop(struct seq_file *seq, void *v)
 	__releases(RCU)
 {
-	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
+	struct mld_mcf_iter_state *state = mld_mcf_seq_private(seq);
 
 	if (likely(state->mc)) {
 		spin_unlock_bh(&state->mc->mca_lock);
@@ -2959,10 +2959,10 @@ static void igmp6_mcf_seq_stop(struct seq_file *seq, void *v)
 	rcu_read_unlock();
 }
 
-static int igmp6_mcf_seq_show(struct seq_file *seq, void *v)
+static int mld_mcf_seq_show(struct seq_file *seq, void *v)
 {
 	struct ip6_sf_list *psf = (struct ip6_sf_list *)v;
-	struct igmp6_mcf_iter_state *state = igmp6_mcf_seq_private(seq);
+	struct mld_mcf_iter_state *state = mld_mcf_seq_private(seq);
 
 	if (v == SEQ_START_TOKEN) {
 		seq_puts(seq, "Idx Device                Multicast Address                   Source Address    INC    EXC\n");
@@ -2978,51 +2978,53 @@ static int igmp6_mcf_seq_show(struct seq_file *seq, void *v)
 	return 0;
 }
 
-static const struct seq_operations igmp6_mcf_seq_ops = {
-	.start	=	igmp6_mcf_seq_start,
-	.next	=	igmp6_mcf_seq_next,
-	.stop	=	igmp6_mcf_seq_stop,
-	.show	=	igmp6_mcf_seq_show,
+static const struct seq_operations mld_mcf_seq_ops = {
+	.start	=	mld_mcf_seq_start,
+	.next	=	mld_mcf_seq_next,
+	.stop	=	mld_mcf_seq_stop,
+	.show	=	mld_mcf_seq_show,
 };
 
-static int __net_init igmp6_proc_init(struct net *net)
+static int __net_init mld_proc_init(struct net *net)
 {
 	int err;
 
 	err = -ENOMEM;
-	if (!proc_create_net("igmp6", 0444, net->proc_net, &igmp6_mc_seq_ops,
-			sizeof(struct igmp6_mc_iter_state)))
+	if (!proc_create_net("igmp6", 0444, net->proc_net, &mld_mc_seq_ops,
+			     sizeof(struct mld_mc_iter_state)))
 		goto out;
+
 	if (!proc_create_net("mcfilter6", 0444, net->proc_net,
-			&igmp6_mcf_seq_ops,
-			sizeof(struct igmp6_mcf_iter_state)))
-		goto out_proc_net_igmp6;
+			&mld_mcf_seq_ops,
+			sizeof(struct mld_mcf_iter_state)))
+		goto out_proc_net_mld;
 
 	err = 0;
 out:
 	return err;
 
-out_proc_net_igmp6:
+out_proc_net_mld:
 	remove_proc_entry("igmp6", net->proc_net);
 	goto out;
 }
 
-static void __net_exit igmp6_proc_exit(struct net *net)
+static void __net_exit mld_proc_exit(struct net *net)
 {
 	remove_proc_entry("mcfilter6", net->proc_net);
 	remove_proc_entry("igmp6", net->proc_net);
 }
 #else
-static inline int igmp6_proc_init(struct net *net)
+static inline int mld_proc_init(struct net *net)
 {
 	return 0;
 }
-static inline void igmp6_proc_exit(struct net *net)
+
+static inline void mld_proc_exit(struct net *net)
 {
 }
 #endif
 
-static int __net_init igmp6_net_init(struct net *net)
+static int __net_init mld_net_init(struct net *net)
 {
 	int err;
 
@@ -3044,7 +3046,7 @@ static int __net_init igmp6_net_init(struct net *net)
 		goto out_sock_create;
 	}
 
-	err = igmp6_proc_init(net);
+	err = mld_proc_init(net);
 	if (err)
 		goto out_sock_create_autojoin;
 
@@ -3058,47 +3060,47 @@ static int __net_init igmp6_net_init(struct net *net)
 	return err;
 }
 
-static void __net_exit igmp6_net_exit(struct net *net)
+static void __net_exit mld_net_exit(struct net *net)
 {
 	inet_ctl_sock_destroy(net->ipv6.igmp_sk);
 	inet_ctl_sock_destroy(net->ipv6.mc_autojoin_sk);
-	igmp6_proc_exit(net);
+	mld_proc_exit(net);
 }
 
-static struct pernet_operations igmp6_net_ops = {
-	.init = igmp6_net_init,
-	.exit = igmp6_net_exit,
+static struct pernet_operations mld_net_ops = {
+	.init = mld_net_init,
+	.exit = mld_net_exit,
 };
 
-int __init igmp6_init(void)
+int __init mld_init(void)
 {
 	int err;
 
-	err = register_pernet_subsys(&igmp6_net_ops);
+	err = register_pernet_subsys(&mld_net_ops);
 	if (err)
 		return err;
 
 	mld_wq = create_workqueue("mld");
 	if (!mld_wq) {
-		unregister_pernet_subsys(&igmp6_net_ops);
+		unregister_pernet_subsys(&mld_net_ops);
 		return -ENOMEM;
 	}
 
 	return err;
 }
 
-int __init igmp6_late_init(void)
+int __init mld_late_init(void)
 {
-	return register_netdevice_notifier(&igmp6_netdev_notifier);
+	return register_netdevice_notifier(&mld_netdev_notifier);
 }
 
-void igmp6_cleanup(void)
+void mld_cleanup(void)
 {
-	unregister_pernet_subsys(&igmp6_net_ops);
+	unregister_pernet_subsys(&mld_net_ops);
 	destroy_workqueue(mld_wq);
 }
 
-void igmp6_late_cleanup(void)
+void mld_late_cleanup(void)
 {
-	unregister_netdevice_notifier(&igmp6_netdev_notifier);
+	unregister_netdevice_notifier(&mld_netdev_notifier);
 }
-- 
2.17.1

