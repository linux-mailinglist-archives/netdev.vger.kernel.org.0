Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3B737FF11
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 22:28:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232535AbhEMU3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 16:29:22 -0400
Received: from sonic309-27.consmr.mail.ne1.yahoo.com ([66.163.184.153]:40850
        "EHLO sonic309-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232753AbhEMU3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 16:29:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937690; bh=KfyRLiXkN7GzdhRBaMWAjvKTGVbL2Tujl8ObV20Uuzk=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=WNZXM8Q2CiDQ6B8YDf75bZhLP2Il24zLLO+EfN8SxBKdyPcZwS5wCGdOSI16od+4fcdhCUvO38BaGQLvqq062bO8bYBMFTcjatAyeGlMvxPGjO1oe/na5lw9P2EJVntMPHoqt4IAd4V/LfnNyBl72YwyY53XL6mzQpbXKd8YQCYcnj9bKkwcxUO+nJ4DsR/RE+yH3XVfuUaSBcWMSD6oWHxV576Z+UoyLmuy8nHWAa6HkcwAel7UYjoxT2Em6GrwPuhaiLRWqCJNWjxJ7ZdYyUgYtN+cAtpB+SZvSw6G5y1TgCfmshjgjn9Gg523N87TDwr4HXicKLlLvlT7t/XQXw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1620937690; bh=AFG07ztm7H//CNQNPdbBKGSh8Pj3cSvWwCBlx4qakhj=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=qWoiw38bJRMeHH8IgEWnwUwVxu3gUtHh2gG/L112o0XdGstStErXcA2Vj3yXtiiKKB/pCgSyGxnn5AxijV0wCQZu70uS+PKJONjtrAMpoHwNFNPCuabtABgGa2Lrbezd9kyoNd8bOHr36+Dcc5WK1l3ckDurDImFjjx6lOyuW1+mtx0L4PZKNx0+Gm0eHP/oxvPNAhel5AP5g/xWBZsYY+k0zJ2qBKYCQaoD+scW2lXB7HFI02ulpO/P4DnrXb+iIZtEdzvLaVGpEUCLGDbH3KdHmkLxq3nQoA4VRfS8i6KcQtWD2iN2TJnzftyT3+hHyDro0QnJu58VWfBdIuAn5Q==
X-YMail-OSG: IXfK2b4VM1mB7g_Rz9YS8HJ2BslidVrIJl0SWj3yp3HeY5LYDwvnRi1c7bJ8lbD
 rIh4y8omufct6U0xEB7VomjZDRH0md9ESU9oECKZA7MNXj5zZP2kzQGkgzRqJvyk_PAoC7EAWSkX
 MGHjnXUWst3avA0SdaVRrS3PINCFc7evaGlsUAXh7v5ItqE22sjKPjO8kjZVK8UM7m1nT4N4rrw7
 0ogL2rAcarxE54LQw8WmfceuYIZfB2XzABcYFHiILNLiZLffhszATR18Y1jWz82FAk2VNdsUB6OR
 axr4dBfAXlLSWyJ7iK3SyzV3KLBFpWsC52dOq9cL3vALczcWnbmpoWpxR9U2vMM76at5fJ5nmNUM
 .8TzaOFuaypJ_43i61v_I8sWVEwCKXeMYgOUu4GgSoSj3RqIK14C5_WrmhvQCe2U03U6rSa9sFER
 8IdeYrh_JGWto8na44lP4ZMoa2NWIWGeW3ujpFKSQagrEGyAdlQmeGsc148Jyu208ARjsbYXMgBM
 saQSMdJzkFxMvw46hs9UARuZ6921eAWS1qJ.M_qVh2phFgRWBD9tEsC1kEa0SCOaAD7a.8Wp5I2M
 oxe9J7HT2LvHfSXLAPuYH6zi4ma6tWy3cCnp0L4FlcYdsOUXSgjDUrn3.owgXLNSIizyWUPXdPbh
 _fGS.Uw59oRj7EAbVDVVeD021Q8SzHcY19e7XvbYNjbYiiLhVmQY7ik1ZoXu4U0q1RBxZ6OJFRz9
 A3evX2NyZs15ARaiQ43LeZ7T1lotglFXWFyyapyna9chytRsu3VHww5WS8_RSfIzYeqsEVOkfqG5
 8pfX4dE8Sn8jiHQWlp6WhnVC1LRNmj7dR30QTe1AqfvFUa6xLyeTRUemu5W_HnXxuEs0WmuWbWMP
 57jbjF4Bs6PRslzF0UxiBtuuAuq89dQ51E3UVK.pK0L.DIT281WBgVnGOTajjH9LXdJAYMHDDlCT
 DDYrRPl.un1tWBlzcZKOoIuKmuz2S8MOYgZRGM1X3PB.daRC969Or0i44pchsit1l.gfCYn4zwgw
 .lYpleb4.7oHbq8m7D6Divdg52CXt48ubrCzgIWop_TqKQWwCtcrJHDn62HcxG_ACDFnd7Icsvp2
 h_Q4Ai7LY_219G0QbknKB8kDWJeD2jhKDxrlkC15F8Twpgq.aE5gXyuX.lVuIf5U.jrnRTLNMCGS
 oAkJUeGdhVq4gTNxVDDwo_8j87J.U2TEWx209kjvmX3tneYeCEe1K_.tNoGMl1LjqlwV9FLggWL6
 qFCFhDWwyoje9wjehh0F_6J1siL2sx1UvWYrP9Kqefq..SNKxZsZe6UHsEv5TQFSk3ukNWd4q07G
 FlhpjgPAYJ1PLbkV7we1aC1ymscpP8C1nBzKopfSb1tdRSTwpSKTtItmsYxk0tb0VJ0y9ZesvFSv
 jYnfuSYDPYCGpWUnXltA07a5B.7lr4HBVBkrTuphKvjxL7qP9vixbsCwN7lRlIT7xZCDfiJyRRKk
 9K8P6i7vYW63G1KNswvjsp.aiUiq5bwU3ZEeJg6GlyeiKhPvILJRshhECmvRHZNcb84UfvrJ9H6f
 j44Gvt_NHhNvqEShzLhSD3TA1ZaJhWgEKZNTO3AcSFh978QxKbvPlTCz4hv4bOATo_rbQBSIX1a9
 2O0efmNxVy..M_7Vx91WHli1f_WgQaEy_9ewYTtA1Tr8V1BYolA7nq5uKXRPXiDquUeEUu_C_qzO
 75nav3racAQmwo2WNtXIWhaE.pu8EVM5vUuJMI7PzwWiRxoiNZI_gvrUnPaXys_mDDwk3E8gQV6p
 bV2Peo7IVymZLrJJ45s_jluYX4cwJ.52xQlzsRnvQc6rtAi8zCNzfgFixskQDYe7NEZ31B0SoxbW
 Mpxd3XmqoN3CygocvNAr42QidyHqAzupHi9pxN66wOLDgZIyufULM2FBgKtJnqHdjI6kGXCHPK7F
 kxhwY0bAd60GJz.vaFw93G5jYMsOPtObJfluCPGiMuWIST8j0vbBKAg_dRo3B1VxrcwG7ErSeV0Q
 EoHEzLXcLCspfy26soVmFpboEJ6H300iwwpcgs8zMXnj2wswASOKDWnWqaETQYqosxdZvvMza9HR
 D7nb2WYUHKTfW0nhL.lfkg8Bl2HsWqyWuWZ3l66jzHSz.MLcgyuyfOhfatNt7k8lgjKvBLURM0uQ
 aWpo72FdtyH7gxP0CubCBhzB7J_0THAY9g8SIGmGjXqqoEp5UR.0vPrMvnWiJSKqUuBMjyR3zIip
 RFHqiEoTgDah0DmaMzVbpYpgfKy3Dh.pJBHW3PDdtKN_SbWMJRJkVDQKzT2Xi76umvR0oqANjYRR
 kEX3Oo2hTXSKNgN8R5B6Y2ms3WMrkDHYI_OxteRHxumukOPHYM0mMqLFkcSexFyxWo8acX1j_BxD
 7zwRrgGyVAYz0vvobEWA1GZjzsEeJUpJiR6Km7sxu81rWXeKv2QpLgrQUFm7fQ57qDKy45wQ5L9R
 yvsB8EEvAlEqXMjuhp7HUpYo8jhQ9Qq28po8DDN7XWNYuV_EvtWRPe5p1eMIlMwGOjCKE53Finp1
 Ug5lyfCVVfOp.ZvkI4FPTIeoPuuxTBlB.eJCIe_l07lInkT1heGsZMHyAn9z2gBUG6PKtvH9HwNt
 4yYsY0FAl.PV7MG8r8LprnZHLkxE3vYEPfQVE9jeg6g.AS7SE5YiRtGz8KgQjs7tzKoiEoIScFgA
 V5OHf_Vd5U6A3J11YilVIKw4SdFOYo7QXiop3lwqWM6mXeLbHMdtdcOKo6T8C5hlOHyX4exDXL58
 mY5nUcxNw7ccNFtE0JZFtx4h9Pwt1V0LrGXNfk2m5Cr794m8dwx3Sbj2Cg9jHoIndo7OHd.UKSHM
 3aD5wzklA_gtVF8m3Y3_.GVAPnp_hq8N0dKVT1FwhUvbxQYciiSP61xL4JdwEk149U2Y5bYi.F4O
 gsyanQmAikdxO.ZpVkt5OuKrskXUnBU8mRFMXxDe6le85MZkt2rns2a9YrDqPpKJlPpik_e2nyC0
 fY_I9b9y5MaMZhuryAsPBspskfzgTRnc5XwjLoqN6LEJOvsyihdKjMzIYI4y2huGOUQbILmjpYke
 3zMS9UcoVDYre9ekn.jE1PMM_WTGMYOpwn2z2nbNZKcak6PZqDmMCxiBM7Vk2QSwHxcbKCR7NrBc
 3LUhfIpG0CZh5KO4FcSl53h4idIJFPJavWnh9Kk8kwLqAMaB9vr1hNv3nSTqERME1n2QuroUxHdj
 KaWrTJcIxWe_eW6a3htM99oWEdTygqCvTqBHCxDbc.wguVd3TZ6_kjFHZNjys9fM8dWeZbNMJcyW
 75fD0ZLCfJqpM1kaP4KOPtJmaCKR0fxRes0o_qQnF2LVy9B3GQPf24geywP3wRlHHFyvDYwIw99w
 3wEloZHhifo0YX5X..kI45QsgO03cgQe.jAXG3zM15RAarpgMBVL_HqFkx4M0_yviHtUc
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Thu, 13 May 2021 20:28:10 +0000
Received: by kubenode562.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 6937fff4db5c11c6fac9189ee4f4cbb7;
          Thu, 13 May 2021 20:28:09 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v26 18/25] LSM: security_secid_to_secctx in netlink netfilter
Date:   Thu, 13 May 2021 13:08:00 -0700
Message-Id: <20210513200807.15910-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210513200807.15910-1-casey@schaufler-ca.com>
References: <20210513200807.15910-1-casey@schaufler-ca.com>
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
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 719ec0f0f2ab..bf8db099090b 100644
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
@@ -397,12 +393,10 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -470,9 +464,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -602,7 +596,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (context.len &&
+	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -630,10 +625,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -641,10 +634,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
2.29.2

