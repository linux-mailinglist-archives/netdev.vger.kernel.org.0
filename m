Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 129D83A38A2
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 02:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhFKA0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 20:26:40 -0400
Received: from sonic314-27.consmr.mail.ne1.yahoo.com ([66.163.189.153]:39692
        "EHLO sonic314-27.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231199AbhFKA0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 20:26:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623371082; bh=KfyRLiXkN7GzdhRBaMWAjvKTGVbL2Tujl8ObV20Uuzk=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=fKy6jt9HDGPsNlooy58K9MfYcJagUCpQiVa46jD1pMJJNJELUtFcalitbOKLcdTlp6kR/45SCaiY2o9Fnjk+ye2vLFpV7Gce+2ANXv1qqOnU9Pqnq7ONnPnxoh/5xoXVJvPeLYPN0rNIM/9mrBIFQ61QLrDeBE2W2H2kBqz6cArQUI/X77G/RhZHSqotaXsTw14nmaDFAU3uo8bKi5LzXHXmKFnHxgZ0smxDWGZgqO9RpwIDHuP9J9jLsp0KT+6PGN8DJoGfwzQBckR53r/Qes3a2rkgz79S9pUft6xZdbkeLucQla+jXa5ZrkYmL6JkTjJaAjSG8HV77lEy4n+aSQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1623371082; bh=49nknRRuJKzlcvG7Rjq+VNddA7VGuHNfGnBUjw9dtZg=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=pQwOzHBlXp/Jcp7lIvYfkcZeR58sCOBkMZ35mj7EdYY6PHe2RxEJ4ZUPTBJHW7+y9M09Ag+IkQCk41M6wMRVIygq9EzxuEoFjdDchOj9Tb3yJJJD/fJiNuDUAHFAEBUMb/j/KU9ciF8981v2nQzGDip3lgq7RUnXVsaPoLq6UAe3JwlsdRzAM2peQ7IXycx9SROq9lE4R2zxTfaSAMkLZbN+vyCnnlRWmzUPX0KvD3yTAhDKxKEgQuH4zSt8x6CkK8qycsEYOoF1seP9CLNgBM4SAbNuKzwATLwchUMnX1LxaIc2h61xm84+koabYRLcdhv34cuv2NfWGPV3AKgA5g==
X-YMail-OSG: oj8uZV4VM1nQ9NCxX0Li1ZD7GrwnXyecF5vSusm7hIoloyZDmqLFowAdRi7bxY5
 v9CTa6hkV4pLi1z4ztu9LbR36aaWZvbdO1jwvLgMLqEPO7gPTo9fNv4S..280qt9BwBg2n81TAiG
 H8xLR_qEWSbibyR6svrhKFyx9YalKHVCYsF03If566T3ENAy_lvrZm0jnr4IkuUivtQSNpnN3LS9
 ojbwzK9aR49XGRU0SXSu12Era7KNvoMrRx3Weyl2cYJzErO5ieex1RzUv1OXRH8Le1RuzwBknMXI
 yucLxWwVCK2JkINx4BmIc.a14yeEm.MmGNJD_n6Uf0y8e4l5CS9i7G5OUaqM9yhBbSVKqLooF7uM
 4JLH_orQrBIqsCj_sc1743OqF4to3b9qgsekeAMRPttw23SIfN4N3c0Qi6s9WyBUYaMadBonG4r5
 GBq6J2Lv1XWXkr1wXOsf92fKCDpP72mDtkoG9DBt3QVeYceXl3v67W_MpdWBTLsV2IQXep9Dn8Lp
 UP2SDd0k9ckxX23UYeJetOVj7NKUfkQFPr9hze31Z1YmkVOohVCImhF.26x2t1_5Gmn3tq_Qypn9
 RIYbm6mt0WzoSdCwqLxkIFSpareNA8rI9Hbred4FaewbF8T.rYVbA5Q9YByubMHRaRTRUU_ZDcJ9
 L03i4PmKcBnXq50CM9v6O8l1RnJntfpABNKJ.aWtG.fnRtZTDVR04H2APGZZWrpBsOqxrVWz8pQo
 uuikZ3mzVDHZRlX7524rsGac0AyMMH9LrPecENcRJl03X5XwXd0XtSyT.g5ZetZMZykPDb8b2OfG
 LHu0gJR5VjLNPjAikWALmvE_kW9H4DPbOw8L291XwQgL94JVRNBU1vzJMXaYqdkdKzECCcb.RP7S
 5g57Gttwvyneh.QSkspTzG2rP.KJF.1LmmosZsbimjBpW5vSGRRrvEHKC9kCApO8WPzM9RstzbT_
 yJvUjB7Nq7mY2aI2gr9LYr7F_nEueEaG1Gmt8XixgB1AdyjMpnqjV2vhmpVAdXEV14fpqVgy1LGW
 Xolx5eyctW8lAxQ1uYA0sfvYRQReK0nN.j3D._EMN.mBnMNkotcC.Ks8T7Al36AymhGPQtyR9sSy
 FE0V9Elb4FqDoIcc3BPSmeXA1vnufV2LDlMOzwAl9m8DCGfvRgkDfWp4zLTRrPgaAHugsAwOGLNj
 6.7.Zu_dwLsx4kWElX4xWME4xKnNfNWcZ7VEKaoohp56liv.qO5wLfJxur33SEB0eOR.Rg6IIBdX
 hMA7okGCDDmnRWOdK9EhpnDZwZNBKLTU7O_ImtN9YZ2LfIScwXDK2jDLbmKSISAN7YCW46Qgs8El
 uxIC0a4_H4nDbG4VgBHSY22Hbp2pIsEz0jLaBDyO7frbau3myFZJiuZJuXPOKJkqk1FR4_mytlXH
 bmGX5dKePECw6lBIdMsRmwF1cM7E5BXiaIQLEGCUY4zMWVbGoy3NhjRqtVX_eoDGx4A0ecDF71n7
 hKZT2LTIixlEd23JMEqjy2zj.i2W6_9Ee5R9n9uf_ezrXUFlT8.wW8v_Twvodz5x97ic1dumZjvk
 AgIuRvdtVfJgTVHcGYWgTz0ZjCTMndMgXdLGla94HXevqf667Rs_cmrS7Ls5y.v_Zx6war4X1s1K
 zMkt6IfaRVolcgTKhqfWeawucgHitcxNr0kQgkkxMJw_TU4HA71eb_TRRLiBf8Qc7_al1PrQ5b1C
 DseXHY3jDMhBEwOfQMs1xmLjKkgibhVggEjlADuyf5g9ixh0cQ7Co6sy.YM9e2cFBRPF2laVazmQ
 tNsjVA.1YRVmor7YSg_8qWnOP.Zyh08ug1Wh0QgXTZvwxDCQWzgbrpTwECEclWwidLK9zl7t3g1N
 EZmF7fhhI48qSLdBWnw_na3CN4it4NBdT4F7e_SWmDq3nCr_KHLCbwfaSscMbOfmDw9fJvj.PHe6
 IQbcLy2q4lQZ_u3UlEjLRTvzL_FSlLcReaEKtdk2_v9V4OIapd95o_yD3jTJoCgP0YsZy1J8_lq_
 wuSlPHboyniN10_3DdaT5As3a4tNZNSZz4v7gfVw0OOTruJrSttPp1RflqRrtaIYMkKs59xFj1Nw
 7NIo4MBGBevoTuSTJcyI_J_rfKmLTaCc_P5Rlb7liOFI5b7I2aykG4XiZA87xaXmsr_BKOxi9x.H
 NxbemA2xn10ttvf8uPGx1zDtdWmR1vSEO5ZwzNuXPzgDUb.Lof_gSubnGHbMxmCWbeskDBHOVa.H
 BiEJzMCSs5EDDjzoGgm8xk6t4FhsbNlnhgbtjcIJFLr3RyNgtnYaQE3K6JChpZZV0Rksgy0LOzXZ
 HCwUpiRV7W8ipbpf15KWutIWfezgDHUg1stZr.VysNyNCUyriDC_lTV2cARZ86SVMcknA16RR7pG
 r3_32E0DLTvEmiBdCuoW1MN8RR2kyXCXVeiORa_ANbSvm.hKAXJMd55GQTdyXwDyTQ7HJUa.RRrx
 84VwFLGc__3mrxIB8PbiXVAo9l.GVP7X6IIjEcPxSRDw8SR35GKO5O81RtDszKlv_t_Agay6Fo5K
 95YaKHFvVAOKtoq0dBndufMBiqT8iLof2v3U8gTQzpNl83MYHHD5wBO0XB3KlqbgHstpE5D_tA_n
 HHPaEWZvCpFQ0kjIJCW9LLq0OSXYMmqWO7Jhb.QrfAIXPFQAoVuNrOUQfo1lZ4GXvh1zEWzoYqkC
 PbDuwZNOmUZHpe3ce90mKdv88scVpLWMkXhB5pUICnZRb5iALwQQ3QjmLVHvnRY2OZX2MDyDmaju
 7XWcoENoSO2kxi3gfBtbDybqIbznSk5iioxcDX..OtAjuxN4J68SoyR4TZCn3DDea.AwINUiktHO
 IASu6BeBMLfnOpYWWXAQzz4Vom.2UL8j00ctT8TJfmbXmPs1udjkeEdjeexUGtG0gFPrzhyayo9B
 539VfZhL7w02qWdXBwMxktwTB4rXGJ2Ivyfn2nzPR6DQ.TW1ZrTy.__DfXksExqfnYV2I3AwHcZB
 eHPd2YGHNY1MBsGz6q8wY80bdMvAVCNqdE1nHx56gNzzK9N8ujfnr0YQyXr7uuLcQ7ueangUUT0o
 FDsTPShPtd7k1upxMqJK3g7KbCQZcA1Cq6iN4xBegLsKbMRZcTIJgi3cEq7qxks7oRuB0drcEP_a
 RhJdoYU32nGnG59ai0j2pTAg5tnSYVTf3wFaYJrO3pvmt5iIl7UIbRYFs.8688WbiNbh.rqrukbA
 xU_PzqCNrQrgzd2p5ovoQLQRjdetuE0Dse4tEru5M_db7FDy48ast0QFzMJVj1xaj4uQ.kT8dIex
 hyE.WzmLqUrPJU7D.Be34Y5LUkb1Ls4JlzWC8Wg.pUgSoB8yIh6uOY2Z9Neml.5pfwYzjGp0gjJ8
 vBMDYsTpmbk3va1hCLBwDU5KHARmLwWnY5fX._y6JlX2fr2HbhmgZJCzxyRWMTYd5ecWL
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.ne1.yahoo.com with HTTP; Fri, 11 Jun 2021 00:24:42 +0000
Received: by kubenode565.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 2ced77f2ea984a5dfbb2f085c3f4d044;
          Fri, 11 Jun 2021 00:24:38 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v27 18/25] LSM: security_secid_to_secctx in netlink netfilter
Date:   Thu, 10 Jun 2021 17:04:28 -0700
Message-Id: <20210611000435.36398-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210611000435.36398-1-casey@schaufler-ca.com>
References: <20210611000435.36398-1-casey@schaufler-ca.com>
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

