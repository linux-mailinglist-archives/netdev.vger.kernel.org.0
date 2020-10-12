Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A55F28C28B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 22:37:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728491AbgJLUhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 16:37:14 -0400
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:40118
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727077AbgJLUhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 16:37:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602535030; bh=AfU4tEGic6KQi2q/KY4oQA7M/bMh1AWYHAZwfip3Ww4=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=n0imRydNZCk72wSmqCS7kqG6xxSTNfWc54ofl5PpYO6buvD5k+cvEAoRUJOr9we9w593TUrkkORhuO73UnHDb+Kfg1JKuhO0oTO9OMbmgr1VmOLYSjHJGtZSGZ6IVYufceW9MSNZxXwXjZ/l0f/C2tIB4kvYDOVRrE/1uXUBZlSOXlS/x8kDoJucb0RAMoNHtTCOQX/cuUi1QlZca/VttFnFbkyPOs3awresAcN4DR5Lp8V/4gM1QCXLsQZwtDnbZW+gO5IJ80mgphelHjvXs0VJ1WAQEFo/xn0ajU2m070QoA4OMV9Ard/zLeZwXgcmx/9YK1Bchx8dNGYUhrWVsg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1602535030; bh=cyu7IpR3Af+V+mmg35Aq2U1YaQC/Qy5M/S9WX2BGOcu=; h=From:To:Subject:Date; b=joQTeOuOya2KUkMqAas/SfXACBBcM45RXerqSg1vxLE2tgkwcX1ZxDzVn9kcfImfbnzTJzGswU/bC63GN4cGXi0QSodxDrKngXId8jDpgUjCcZuseiyM/OHPLI0wUxwiAvfPI2ABCns92aEun/NpfgH0j2SzSly3tqmXCfqE5kEsK8sQODWY8vkVzXDo4hXgfPIFvJQI7GtfDRt7zZlmT7vPKEMGfOtouZFkXHkTztjHPxyl88KDGfdqaxVeQy4jwEj4SbbGFn7VgEE6jOQmH23RfwIJNEcxoFUSrZ46VA9P11wlBV9gx6SGb5LZp/3NiPvdKMqhDL9ZNxErrLOnRQ==
X-YMail-OSG: NXldRPQVM1klca8zFalDBF2V5rpJNj.d66mW5Tszt.iS06p95tuc.R7cxu52cMu
 v77yhROaD4LQGDxzB47GFfZzrJEPYoH.un86vkn0lWkiC9lQkDMp1dHBPLJsjAurgw8vNAw8_Pmn
 w6oPyiXE3Q_LgCa4QS3ojcIpEZR3FvMeU.UCapRovsBnY4GX1jtmuGxhTfUmdOJzK30jzYhFjL2U
 BJRcD8qwueg7vsdCUGLQZiMnmhPd_hCwj2ZdfJp2ksXLRI1yiAsLdg.7XsMBaA2R2i2nS1UuePyh
 Skbbw8bxvP_Bp6vRdC.mv4byiqdAwGB3QqmIIwY0UZEAIV_DqwjoAMIdtKNZO1cL_pLXWzZYCdn2
 eTXhndibsNMUMACl85WLNz.sK2P9Sq9nDjyLglLddLSPJYNe6ea.ry6m.4Uca2keY0RRiC1AD3tS
 4OOehrBbeAGWiAwV2ynFavPp3io4dGP1FWZlK5kP0ZCk8rwJTTq0r2ZHoJYPAw.Wy3H3sdmmTMhc
 ZgQ_UrAevpds3mNBPfG5chTMb79MUmzC1lZkPmg4K4OS97lwlECQuk5VO6XCDSLVrlFeQymby99E
 ThWgipUiPVFX_svI7vAfZgwAimCxGyWxNkSDL3KeE2bI17b8yO98LSbaGTJJi2y.o7TtI3E9jMkv
 pn4wUvYenk7qzbJEz87XQuIlLsP1FUFro8iZ5oEUTuGnP.YRuCIUJnjx8Q6zP2NbBQVhfQ_UjjW6
 szDyvts_zZzrgi4AlBcCYzDou76WRNPZmyDY4YxxFrfsL8Rhffr0774qexUUyIu6nhTDNtXOMF23
 Db7P7aZJOFPO68TdBY9QvDES7kVlP.IDxB7UTnPPHufVz_FsZdHAiC3EVe1S6m_EniIeQarCjnug
 w4cua0GyVVhCWg7xVYs7GOoxDLBPiM9yeVs8hPXRpFtL_XRX0oxRjBTPETF5qWvqq9_9yDKDjZWp
 1feTLgGLYpEk.TYDMZfSjKj2ykxv3Bc9kbQCpcIr3jusBsKqdGrxjL021PhjtAEakswY8cHpcPI8
 4scoXrGjIQ22HjFzfG.jzclCJCiG.UFlml3nja8kp9_XaBWQtu82hG0IN1pWVN5DndDbx.gzEUo4
 H5ZOpSjvbMcbC9.BTYLvjcD.vUrPrdh1PPPxgCjuMTisYlmPyK02CNi0KCnNiSyYqfkvkzl5buHF
 ccD3fSv8r75jHn9QWVRYriz8Sfby_bgtQTsJ2av9MfHk4Xynj4wg4Bs8ZIyv_rEeaQXM1sKgxt9O
 z_e.TpUI1qd.NL99y94VouYTGuJBhIyr6bY6KnGqbeqZALdF.sMgd2qQkHlGcEcKlSe4S6psn109
 uvBNSP2AZFpucx9dp_VbCMJgpH0YHb.ayixYZNGY7b09zL1qSKCSDw.IZZcp4qymMdiMtfBjgnUx
 dklzfw3uHv.x7FHZfKMhmsbkieh31FEk55wcDM2c55cVr1Nvm.sNVcUUkO98.1U3Uiu8xPg1.Lw0
 Il0o_6_ubXYfXl4v_tMG_VwqYa3knZU0d3KkboiSmlhD_.Q4G33bUialbFu_dIqjXJ6d_Rky7Lha
 s9LEsvDdyqoBgxxd10KgZ.fbA1_kWIqlJNYDnx9zk9ZuKESxr7qDjbA--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Mon, 12 Oct 2020 20:37:10 +0000
Received: by smtp416.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID e62583af68d35fda33e6a51faf5fc845;
          Mon, 12 Oct 2020 20:37:05 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: [PATCH v21 16/23] LSM: security_secid_to_secctx in netlink netfilter
Date:   Mon, 12 Oct 2020 13:19:17 -0700
Message-Id: <20201012201924.71463-17-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201012201924.71463-1-casey@schaufler-ca.com>
References: <20201012201924.71463-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change netlink netfilter interfaces to use lsmcontext
pointers, and remove scaffolding.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 84be5a49a157..0d8b83d84422 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -301,15 +301,13 @@ static int nfqnl_put_sk_uidgid(struct sk_buff *skb, struct sock *sk)
 	return -1;
 }
 
-static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
+static void nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsmcontext *context)
 {
-	u32 seclen = 0;
 #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
 	struct lsmblob blob;
-	struct lsmcontext context = { };
 
 	if (!skb || !sk_fullsock(skb->sk))
-		return 0;
+		return;
 
 	read_lock_bh(&skb->sk->sk_callback_lock);
 
@@ -318,14 +316,12 @@ static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
 		 * blob. security_secid_to_secctx() will know which security
 		 * module to use to create the secctx.  */
 		lsmblob_init(&blob, skb->secmark);
-		security_secid_to_secctx(&blob, &context);
-		*secdata = context.context;
+		security_secid_to_secctx(&blob, context);
 	}
 
 	read_unlock_bh(&skb->sk->sk_callback_lock);
-	seclen = context.len;
 #endif
-	return seclen;
+	return;
 }
 
 static u32 nfqnl_get_bridge_size(struct nf_queue_entry *entry)
@@ -398,12 +394,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct net_device *indev;
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
+	struct lsmcontext context = { };
 	enum ip_conntrack_info ctinfo;
 	struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
-	struct lsmcontext scaff; /* scaffolding */
-	char *secdata = NULL;
-	u32 seclen = 0;
 
 	size = nlmsg_total_size(sizeof(struct nfgenmsg))
 		+ nla_total_size(sizeof(struct nfqnl_msg_packet_hdr))
@@ -469,9 +463,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
-		seclen = nfqnl_get_sk_secctx(entskb, &secdata);
-		if (seclen)
-			size += nla_total_size(seclen);
+		nfqnl_get_sk_secctx(entskb, &context);
+		if (context.len)
+			size += nla_total_size(context.len);
 	}
 
 	skb = alloc_skb(size, GFP_ATOMIC);
@@ -604,7 +598,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (context.len &&
+	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -632,10 +627,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	}
 
 	nlh->nlmsg_len = skb->len;
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (context.len)
+		security_release_secctx(&context);
 	return skb;
 
 nla_put_failure:
@@ -643,10 +636,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	kfree_skb(skb);
 	net_err_ratelimited("nf_queue: error creating packet message\n");
 nlmsg_failure:
-	if (seclen) {
-		lsmcontext_init(&scaff, secdata, seclen, 0);
-		security_release_secctx(&scaff);
-	}
+	if (context.len)
+		security_release_secctx(&context);
 	return NULL;
 }
 
-- 
2.24.1

