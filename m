Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C38912A477
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 00:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbfLXXQs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 18:16:48 -0500
Received: from sonic313-15.consmr.mail.ne1.yahoo.com ([66.163.185.38]:35180
        "EHLO sonic313-15.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726317AbfLXXQq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 18:16:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1577229404; bh=jx6SBqD3iFh7Ov9qmHnd1D9nd07iILpEnAa1txjocoA=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=D7S70wD3e99jrtuJFzobue53ubDiK01e6t4yDbKJ6VNCeF1U/ADeeBxvNeqsaKiLFSm7HNy7JuYwSP7iNmpc3MEhW5a4isVK46Xv5fGpI46B1H8NMTEu7PsydB00DkOWAf1EJqH/MXgX/9/kJqFEwb+Uk0rTurPuPcGh33MvyrD/fNGPX+Tb3bqdFShiehpffQEnoEY4LAohCCl8y34oyEtUIfMMmW7RHsWq8Bi406ZKoTSaCbCmhau1OxAMu9BL7Kn2rFSYuVeq1dSem3QSVmmLLQdY5+CEj9aHVo2JCEcI4F7MTkqHsKz7Qw6DYPa12WLk0J9//WuwOgI5tNpbww==
X-YMail-OSG: mNg_EhcVM1mq8UwOS5sPX8dtczDQ2afhCb5YGlwzAJs1MdDXPa1f28YXSDPdd4R
 ctkVSxDzWbbyyeatZf4jIgFGVelSo7GtK.hQoauvReYLEWW08_9wrSHMokP7bZ0ew0pjuvpilGs3
 x8iCUchAh4GV4ltK1yYClQygw3rbpniR7n2t0T2vJOwfwkZCvuM51KMQTa.tH_gGITcLh2t__B9_
 FBGdGxRopl6m1uasJPt7GJ3sqf41flBUur6mA7YJM2g9_AKGlHsR5COeL8B4hnnQ_5looksPC53V
 HwdCHB5Rq9Ekf6JcSjn7QhGXusGdU_dLqDHTJrbGxQ0JMT7GwBFLpDV083VyA0NQ9nrhaxcEIT9m
 NyM1MNhdYYjBCXK4fHb0pejQtx5SPS1iatixCnqWRG..OG8sUhlCDjngIV9aWTc5o_yOw5ePbTot
 SQNJ5biE4ouKOqYVUvxdihkh_fWFjyPc7HmHwcyZFcECq_bznnjFqUCzHE3NXICDMPMMTQtbjkJR
 TuZKI4ffdgUNQEtyfhXi3hw_xZnTlrHeF0uAszeHL7HQhvVTeQX_0HKhp4cREChfFG16qT1VrueH
 HevNDGLPg1UTk.Oa9BIFVlgUADyj.x8W2wcPHROrnSzjJyiPmMwDOV9ZTTyd.mAShnyeYdA65CXl
 VI3HeF757mmbiKqF0E4bNgB_f_hf0fLuPYVROLignLtIIuQXIOC3rzz6SCc7At32t1irloT3KhKe
 w6y.ROkkh4AXDGXSsNIZCiNgYt_JpawK8vrI2VLPpKBesjgTY9n7TeuQcibi5xVnE2PiBujTnx8a
 M3fVA5ozLalCXz2IRPv4mAUxIRAZ6WCcF6bibeHI17oLu6xwVO_h9VK6lVvnHSGieoIIwj8UGE4C
 ER8FdMSZv9mqWiREmuPCMXP_8seOtHSogM4Ql66fxLZp9ohFooxb.A1TM5d.Jhb.mbCdK9UgHu76
 CA8Wb3GOva2U2ECo.g.zw.Pdz5UJ.tRgl1ZDgMEyvUqCRPsv1jGCLMiIJIUzTQ.7HY24TKwfK_a7
 qiREWs9Q6LSGwZwKd4RnQsplahaBNApuCJe2iQqYd.o7h1bghbntcyrH65uT3eBEZ34_Kj4QUohr
 zv88i3ZohVWCZnIC5ZhhyOVhyI2E_OE6t3Z.oiqE1_T9BNdKM0NwRWB.3UgsIb32qMvL3NgcIvYJ
 FUioWSGzmYxLfzanG8_bGtZhSI82oqic4TsB3euBj5Yjf2GgSkSbELqM62jPFlrl4yxe3OnpDYRa
 KoTOeSEbXtfLH3JZ7Q48p9f6yITOKLCm_TWhaKFQLdkhNcoKeRegx1Pol0U9PfWvg74KgVxoNb8F
 RZeM2g7nqyAgz.wFoVdKPrgs1RY1Eav1tg2Ww.VRMsHpU0T3a8JOGyfgGW7SZ0oq1XSkJShFMY2j
 YWdI2lbMmpGO4WG103_QRAZGtK5nXwQ.oThtvMkaZ39k6Oos5RZ7sk9skcg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Tue, 24 Dec 2019 23:16:44 +0000
Received: by smtp432.mail.bf1.yahoo.com (Oath Hermes SMTP Server) with ESMTPA ID 45b342742caafa7237a95bb97222a748;
          Tue, 24 Dec 2019 23:16:39 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com
Cc:     casey@schaufler-ca.com, Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        netdev@vger.kernel.org
Subject: [PATCH v12 18/25] LSM: security_secid_to_secctx in netlink netfilter
Date:   Tue, 24 Dec 2019 15:13:32 -0800
Message-Id: <20191224231339.7130-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191224231339.7130-1-casey@schaufler-ca.com>
References: <20191224231339.7130-1-casey@schaufler-ca.com>
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
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
cc: netdev@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 2d6668fd026c..a1296453d8f2 100644
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
@@ -314,15 +312,16 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
 	if (skb->secmark) {
+		/* Any LSM might be looking for the secmark */
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
@@ -398,8 +397,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	enum ip_conntrack_info uninitialized_var(ctinfo);
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsmcontext scaff; /* scaffolding */
-	char *secdata = NULL;
+	struct lsmcontext context = { };
 	u32 seclen = 0;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
@@ -466,7 +464,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
+		seclen = nfqnl_get_sk_secctx(entskb, &context);
 		if (seclen)
 			size += nla_total_size(seclen);
 	}
@@ -601,7 +599,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (seclen && nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -629,10 +627,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -640,10 +636,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
2.20.1

