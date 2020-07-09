Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 980E2219536
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 02:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbgGIAgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 20:36:37 -0400
Received: from sonic311-23.consmr.mail.bf2.yahoo.com ([74.6.131.197]:44206
        "EHLO sonic311-23.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgGIAgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 20:36:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1594254995; bh=uWNP/f0MZF916y2Cwsdhr7gT91hrx+SqsNnUvBkdwps=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=m0TjbZCMxF+xa2y9qyvbM/Qt44HpdEm2bdvRx0UaE0f0QfG9Q8RYAhVC54Wc8KW1Lp2OVCXcGkw3G4AUokbMvpJLbKEzESCg6YWKnJm3Isl08OGKYvq12gPOkDfYiNkRuLn/7fM9YwCsr6loAoX/oR7zkaXshxTs5bYgFviVdKywfc00+3klDvWjszrTkClLfoxrAeYmyE8JyOeB5hGMhUp6jjXiL7lvc65gkWedZLK7gjDqEpbSVn55sWGdd+L17S9PFcTyNl9A2PY2wIPwr5xIYNODg7a61iypmJog8J+WK0eKfmGoZMFYBVOC7JlHfjg8uqFngvBvD+Tn5AfdsQ==
X-YMail-OSG: ktX6py4VM1lYOoo3hZ9c_aitq_eiCAypo0GXii80Duf5mNTahMJa9O49VsMe3UL
 f_OWsF_dliPo19SAqfoAP3E7GzTQOXpbLil9qVzgI4jhPqtRWwIp5PY9i_2gJ_iXzNxVOa4vZE1Y
 GcCqQgqYYLVt57Oo4oW3ttxgNFPxhCKesUwF7qJk4HnhLWLr2nRkAoYUdHeAqy633bQjYb9LNWyN
 Qjh9XDwflWrW.q7Se4v.NjLFbp8LXrfO5eWYe14PUq4GC8Z2Bpm8TZxa1H5j9HHtR6lMIZRxWE_0
 h8TAY79JU41qP5dBLZ1ZVSvuvdPA0FY93aiHOrEZe2yhh8__6k8ZpfvktYJR7OGtuE90.jr.3Y05
 tH_ltprXK2IvRY23Y1LkexnLQou_XDhlW.tOCQOpAGeFkh28abNmS.YdjJtpTcBXPb0RhJCekSLI
 5gQsLZKQHakG6JKaYiFSbrE6zXKgJM0nF8TYr50lWe7uuSXw94U6R0.tmOzcW9gM9zvHCvkGx7uX
 tlP97vdo0N.1rf6sfyFo7qrh21SORIUCAP3efnZAtPqcWvzVeHIIojImZYJwT6GWLslbyXnPPLOw
 ffq42YlHEHo2Gvc3IHAI0np3z3bVYaSodmtQfb2s..UoJuo9lfvyx5VTlj9zAqN_SwOAdpBfJkLX
 8uCD8Tq.xjpprsGSVsBSRL3_0UoD3Q.YpfQQl8JpWJs6dLpaegcQFBGcahiGKwJ1y59h5wXLrZmf
 Z299rzB.dv8TBSkzHZJqwhzq80S.Jthy4PxGjTXhv3mgnZeJZqZYAxQtR6WDBmISI6Wi5_M39hw5
 A.596w2LOBoN5Jkcr9Es8YA8IvroIzYGPvqopPh8avwCnivFMnNVLdXDx4uFeXpl_hLE636Eulll
 fdMgt.eCdbV68YAbGuN4B3Ov5MoZC_4Hq2yVq4dF2jo61HidOH9Z.bmTwzIqo7Tgx_W9Kxsl.0fZ
 l.6jHvq9iFDdN1FeHTOiaEYv_2OSlJbpOZExo0ZTMKxrYrbmbJTJX_CW7QEa_N68F8Kt4JQjD9N8
 cfv9r39z49Wz8dZzleZFJBiRbPdTW468yTrIHyw8QLx8qGp6V5YkXl9J0dNKM8sKObXRMthIq6QK
 cubNjMMarv1p6coYBIFKBT2ulHKt2FI49EMGadwf3S_aflVrq_J3WAXPcWhMZW5PshFR_VteDXQV
 ouj4m_SQZ4Gwkqle4Nk1ieIVKsJkacFUE5_vtq40NrQ_xCiBigz2qgvoTfEGgDd3p0Mx.yXgctHS
 8qRuSdUZmjQZ6muA9xEae114_t9iqxLkYidc1IASpr5WeSRbd8DoS1V6CWtpHmmbnmxHgX7F3O20
 ZoU2xDJD0qDnauQNEbky45zwsEPWnD0DJiitvBISgJ5WoA0k4et3gZN6GkGC_bpAnHvVzl44eoRj
 xzDeyG7TLBgS8gl_6WOfHYoJYb38CxTgJUDkcWqoD
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.bf2.yahoo.com with HTTP; Thu, 9 Jul 2020 00:36:35 +0000
Received: by smtp409.mail.bf1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 55d9d25178ba3d8de0d336db3f66a37f;
          Thu, 09 Jul 2020 00:36:31 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, keescook@chromium.org,
        john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp,
        paul@paul-moore.com, sds@tycho.nsa.gov, netdev@vger.kernel.org
Subject: [PATCH v18 17/23] LSM: security_secid_to_secctx in netlink netfilter
Date:   Wed,  8 Jul 2020 17:12:28 -0700
Message-Id: <20200709001234.9719-18-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200709001234.9719-1-casey@schaufler-ca.com>
References: <20200709001234.9719-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change netlink netfilter interfaces to use lsmcontext
pointers, and remove scaffolding.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
cc: netdev@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 31 ++++++++++++-------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index fe19ae7216db..a4d4602ab9b7 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -301,12 +301,10 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
-static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
 {
-	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	struct lsmblob blob;
-	struct lsmcontext context = { };
 
 	if (!skb || !sk_fullsock(skb->sk))
 		return 0;
@@ -318,14 +316,14 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, &context);
-		*secdata = context.context;
+		security_secid_to_secctx(&blob, context);
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
-	seclen = context.len;
+	return context->len;
+#else
+	return 0;
 #endif
-	return seclen;
 }
 
 static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
@@ -401,8 +399,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info uninitialized_var(ctinfo);
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsmcontext scaff; /* scaffolding */
-	char *secdata = NULL;
+	struct lsmcontext context = { };
 	u32 seclen = 0;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
@@ -469,7 +466,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
+		seclen = nfqnl_get_sk_secctx(entskb, &context);
 		if (seclen)
 			size += nla_total_size(seclen);
 	}
@@ -604,7 +601,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (seclen && nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -632,10 +629,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (seclen)
+		security_release_secctx(&context);
 	return skb;
 
 nla_put_failure:
@@ -643,10 +638,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (seclen)
+		security_release_secctx(&context);
 	return NULL;
 }
 
-- 
2.24.1

