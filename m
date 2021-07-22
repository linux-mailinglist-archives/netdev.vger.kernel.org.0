Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE83D1B40
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 03:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbhGVA1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 20:27:30 -0400
Received: from sonic313-16.consmr.mail.ne1.yahoo.com ([66.163.185.39]:37479
        "EHLO sonic313-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229928AbhGVA13 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 20:27:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626916084; bh=tJAwSelRtnA20TVgVj9Y3KhFAdN3sk+uAxfLqwCxMqI=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=Lt6CLRqe2LO1sr/osGFQZt4FMecgSdrDN0qfICvy+9OcciO/xmY3ZZ2X0b+Omu2ry4kXok49cdOIr06zXMlEG+9e3grpe9pygirV/dCzW3RM7KGkhNeXP98Jf70VGUE9o9WkEWKIxid/eBvQeEnofz75XCQGwtl0XrBLpOH0KnomaNpYxnRKCyLA6ASwGIADLpULP2usrtRji4aEkZkA4UTh6nDiCH9UoSTYuQWOnRyEWTxoPoD1GOvCtehEycP5ecvPhcHuylGNnnRu4XoSHQuQckxNgac8ZPdaeUDGYhEepHp/HYOaxfXntRMLmwoFUTxrfMr385l8vnXaVmSi4A==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1626916084; bh=/S10Cne118glpCJEOJ7LcWu8cu+6LV1b5bFXdIbxpiG=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=bsgm2xxoGBco9BOygySY9a6klOmRe445hyBVBbG4N5QQ7AoszbbO8VCCFAScO8L9GEa6IPOmaCgHISJght3BJdB1JNASsD1V/IFKCSK+9aOwbmbn8P6S5YYSJKVRPeNuL/+b3hP3FnAqxcDKhYpX/o5RR6VGKyskk+GlfCJ0AIjRhCpMopY+N7JiFAAvbkAkbHKzG//NgZNEx1jITAtpOazORtiAaDaS/uDfO53C9Takh+7uCsOfixpS2Px1/B4vBpn+FLPzmg66tyeA9QSGaQBwp6qhAP8oMcLqXgmCG5WqP/or3zWofC1LByjW8VC+8mpEIDetg+cIFzgDW3UA8w==
X-YMail-OSG: wQHRWIkVM1kB40c.I4T0wArblMzb7K8.Fd1cMvI2D5Xn2XlKnScqm.VuOS6Gt2z
 o9SJnCwWouQuwxY2t5Xvu4fJT.zBpezv1FW.j1WBYfivuIHZXQGM6QdLhvzVKiDu_QX..W4eUgeD
 vCRmoW2vHg2vOx5Fvknl5YdX6ovuEDggw7.WXx3bZh0.a4LudSIzUpTekFAcrkm3alFjKTcPytXg
 5.lksbFJC1izsELsp.CT1ZI71CdnUabAscJLiCcu57WUQa.yN_qFKln6eomAEXyAxLLOQvLoS1yj
 meJPDuplGMf9r1lP34KeFk.iC.gHCqIDK8G.xkwY91.qX7eMhwRRYmJr60St29eQbaW146tApXRp
 yyU9oG0lfi7qrjGnIcuQz.aFuFBimq.k9tPZef.YtHPtrWuWYYOXv6t5kdhbhPgGRmaVrxyxMsH.
 JB6rcpZPYEmkviizXGbtTLcWWCTD.VlqxzwjQWDfpT6EOlIsiWQRQMPYix43lJAiOgtrf0L6dMVn
 pYLcZJVSaKH8fX0FiaboRPiKu.8Jrr1UQyiGw7VSKSeBfqOBLANSYEaNLkTNScbYErRlw3PZo3Qc
 wcgHSQwHbmy6Y06duFtyC404gJPFuu68_sDM9TJEab6yPeJ72m4zu4JcTAYTDanMeUsV20bOz2a2
 R1hWh.6LA_Og_eWKwOaAt6OYHaRNU5ELvzKMPgtkvojnUlnRXacTn1fId0XzRWa8LfOUrp3ju1bz
 .RHATPo3UTntqFM4DKjgyvpeTFM6MXeIalHo5swVoTps7nhTGwpqoU3S4yF8KMEL3p0AWh3HfN1U
 bSM8D5Df.OxUG.VMDLsJwkpZ_xOcxzo3jZ2rj3Sdg4ab8XDlb80Wp0rlP9cBIJa6xGi4y_HCRh.3
 XxIFcdYN4esWm3bCuNhGVbJ1WkoawhDF81f_01GtmpmaJb4v0lTTa7w.RdLD5pAbe0YOECSWIk4g
 PypezNOr5nEgJIVu2yVYvwUkXwBg7JnN41iHIpRQA_eJESCpk3J16tnVyr58rFexQfPJXtrEK9fQ
 omsl0cziiePDqu.egePuDQbOmfxTmERyqUP.4_lfJP4YCeOpcjdXyc7MxSATkSil1ffhH6it1GbS
 z_L2X9V3Cnxpq9R_QrnLMfxBLBEN6.9HtEjhck2foHWbRhsw7ir0z2myAECbw7Z4hsp173iGm.px
 _6UpDcejSnkWk.G29fsfA21ySGN_hj073KaOOsc9FPr0DmgzBItq3npSD5MyRMR9m4zEhbbl4vWN
 VCear2f3AIDXR9noNJvrWA6C0fqetRqOR1XbOgbxu7SlxNrBDnnUEh2XeGV31ZiOC1wUl8qMObJU
 SaV70FOwmzDP_px8mQZ7qNn0qgu8eS0kgrFSKNIiolBxYWEvT8M3BMOCu5FQEws1EEYpLWFqlrbi
 d2JRrn9aa_yc66QjojuyBOkvb7gUGAf09fYF4UY5HkEqGG35LODRerlll6VhMkLK0Vdmpx4DZH04
 Mt_KQ.K0qqYYkHis49n0WfnIfg.p2EiAYHIMWdGmUMNwL6VpPmN0GRQJWiYJXxsZNVj7qIaRtWdk
 dxmJUi3V9Wig_cvaHMkyV0MXgmW9iLWNTxBGlq9FE.DdmVYJwqSvD.WOHvPfxvAnounZTB1QlDlZ
 2Rfk5G1qlJPejmCSBKG2Hw4W4XzCpUeFoT724noHOnovVzcs9vJB12GEch38SJ2epY5Hh8NGpe3h
 .2dHlfRmvhYmZUIMWGSjx1MksrvrYoateben5yQkEA2fIy9A5BW.BJrz1E_.NsKTS_Xsd0DayOPr
 ZepOl4AqhtkZgqU5ZUe9NayvunKLLauCKy9bB1.DQdd0dCVbYzkdyqK_w7yJWKydznC4nOSlhxN7
 7aPXFWUc7YZ6d5ku4RUImv0XmYHpsjmCRBk4oNHscRJ34oqzyhKGV6DYpQUHwXd6EkI5jzXUPjNV
 OpZrXvVymjDdcVZIfRco7EGvLJTwMdNJY1X5AXytG9dvQnJV6KvX.f5wBUQRvPiS9gdYM7vJQ9Hk
 r0_MClJcN4cgpDSMBkYKj23Atlxl9d_g926jN_fjdm0.8I.r.h4SN6zFnea5ZRhazKQmdI46XuSi
 c7BMq_KBPGudSBsCtcEBCz.XplTdpRD5F5eJ.EAeASL9p5z6wpM17qGJGHkWvy.ORoCXdzLNgPFB
 gl3im.qIjgPjQoMTma.oLlrUEVv_7UPq4_ekmfRibwIfTlGXxG7wglF2igrEwWAxoSOhqLg.QjF.
 pAsvQSbaM131TAvTbqWOYWW7MA077BZIjgsxveUyXC5zHNvNjCiwKuEeAmTzNTm5GBALxqaiABCm
 auOENwHqDdJbzJojV3AypJ1NJppuBmy8IWK_AyAWTCpXHIbOFs4dbpQFqYSYol8MdIklLMslYIYK
 Yy2IxtLwzxhrSpZAYDKnO1R4mSJnoIaRWgtdAuKHsw80fj65dntw8ioNenZk8v3dcmU5wxuyxR9m
 hr0zBB_FLuckXsH0t3rt.QtaKHAWg...xd.K_GvDvxDaemfLlLqn4XBZOnK8B7fgc0ZcnVGW_U8H
 C_FPv0gFinGRxXQo_LGG34DJ2QysytzdDuqWR5bEQk4dyUU_9I1qDNhrG.VX62CSA_3zFw3HZFrE
 Pqw_p9ODyrLOUw05gxIlqXTEbS4pYpsY3wnISzKjV7qToe3.qxmF.gIPWFTbwR3h9WFFFcuT3uyZ
 RIDAauvLQjN59OQfpsFRfpFrRoQDd.dn0sDmFGClFxYuT2LVDCqj_ufH1zPIwlqiAvtmsqjHSBN7
 jjG7_mNgoFyO5HROZKu7p0MM3Sajx.P0mdY9HTOgoKkNyxsq0kDu.TjFJXzjTyHpTsEoPsKjEbhQ
 vmMzBRj3TOun6HIndSiq3OllcwAKzLgCk71bx9XssRy1WxhWo5vGT47i1eMiV0BuwUyxn_m6vcQP
 Hu_Yo5M7sD5f7VOaigpJgFq1.4Fnt48mCzxvqCXpE2Wpf8ZzcQk.4MXI7X3y6bCXS0lrY6FXzEH6
 qKvS11midAQOhPHRcS2GO8oG1gJixkrHjNEip_.SrosJ.9ZtvtaKrnlpdYg1g8X5BLu4Mrn.7zSS
 KJ_qCEk12qxImtXKj11_.5Vmkug4PT04aXZu0wDLQyoEBnyPZ3lh9swAnpAH1T6sUtupS.RnjcVo
 clRpUs.l9hcwGkyR5Wts0oi6vNO6mF48CLywif8mjo_39juqHZgL4I6wZy3OLDzQb9CR2AD3Yd8.
 Ptz5jQnHUobMYDAuIm.PUPmjAhJsvPNQmTD.OReZtCyMYa_8r8F9DpjOyd0ZO4nY4GOHMY9DCPyr
 j_KoouR20ZtuwqyAZG.YjrRYCnlurQEfqjXKgEUQwoXMK9EVPKVjeh8sZHR5RGllEiVEMrmhS4Ag
 vwajZJ3wyYRfIr_6oWu4cLytqbtcG_Q4XM20qewFGguWnphj432qAC8PdlpYHAYVF
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic313.consmr.mail.ne1.yahoo.com with HTTP; Thu, 22 Jul 2021 01:08:04 +0000
Received: by kubenode523.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 73c59ba14959d5075c3acfdad7dcbf4c;
          Thu, 22 Jul 2021 01:08:00 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v28 18/25] LSM: security_secid_to_secctx in netlink netfilter
Date:   Wed, 21 Jul 2021 17:47:51 -0700
Message-Id: <20210722004758.12371-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210722004758.12371-1-casey@schaufler-ca.com>
References: <20210722004758.12371-1-casey@schaufler-ca.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change netlink netfilter interfaces to use lsmcontext
pointers, and remove scaffolding.

Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: John Johansen <john.johansen@canonical.com>
Acked-by: Paul Moore <paul@paul-moore.com>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
Cc: netdev@vger.kernel.org
Cc: netfilter-devel@vger.kernel.org
---
 net/netfilter/nfnetlink_queue.c | 37 +++++++++++++--------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index d5cff4559237..cffb04baf7b8 100644
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
2.31.1

