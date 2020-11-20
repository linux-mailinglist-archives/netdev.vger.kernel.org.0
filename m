Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 947072BB70B
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 21:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731104AbgKTUdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 15:33:06 -0500
Received: from sonic317-38.consmr.mail.ne1.yahoo.com ([66.163.184.49]:43571
        "EHLO sonic317-38.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730937AbgKTUdF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 15:33:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605904384; bh=p1YuVBPZn7hPysARDQWvRpJ3a5rIGoVi+47szzIkwO0=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject; b=F+I6Sh7d2h6vGrIanUav0m4hVWb2xdGgaspur+nEjVmtS3aqZTnCVM2w9bUJixXRzArClYVxWZq1JJ8286hq/DPuFNQ7ImAttkj5QW+LSOF/r3s0BoKT+YnPNvDnMnjM+Uf7DPVdG+1XjGlqM0AHnxB41mVWPizv3M9bFvWQtvwhBg4RxXNe+kF9EsIihfswPDzng8PZe/9KlR1r19jHYa3Yckp0tg3jNRbGhwSSECjYkXrTY9II1grWURIWBreE7dMthR7mnecZcbgeYroegg/NeckuDh95iI+f0bhp+tPBAB98dKqz3DwuSqMqsxGhPrwMn4JetLBGiN99iStitQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1605904384; bh=i/sIO63Ulfk83/Oc09fol4Q0rsuVBvLzpPZfWEzITJ/=; h=From:To:Subject:Date:From:Subject; b=niHWB/iEgXKj1vczruLuEq8rfA/VBWCB9ULj1eXRLxAEns54jS2MT/i0W7wWn9R58CJ8Ks93/YpWu5mNFnJSbV0eYJPaLl66YD3qCnvdwWsMAogXVq2kUGBYW9D4iR3SZbHkFbOiiAqmxJhd6koXok2ZJrQoQRaIlrrAigejyv7dPicskD+duG+aqaZyJsghngrxAIewm+bKZFJEuMQIAtqKV//XYp7ujk+YiQK65hCVjveNczbvsq/Jgja9sA8nbzqtLLzDAx2MWZDLlQxToVhF63Nk+TxpoOk5Hyqs7a5jMg28xlWNrrFrufqkYD879ImGRxRhHVUza8edgKazZw==
X-YMail-OSG: 8eLaW1EVM1mKsLIVlBJZdxQ7KyzuMKjKxFH4OsKeG7wxCRhDLhgWAPxmjoJPIu6
 OKchM9GBNxRGMvABQXm8WzduzB1EpjpLzBRWXasn5eM0fPvnkKY2RDBHZR7maMqQ7DmAn.8YSLsj
 ighoK842dgwRTcwLTPdleM3B_T29dXeZea1Nn2rQtZgi2XEXOB5cAnrY54erQo0266IcNr101lck
 dA09BONqVAZBBhx7sKV.yI_94rd9aM5Au_YxXUvzeKljsXROMddA4OvyXZCbDHC502PO4Q1v3htu
 7lp.VXzqPmk0csggA2rJrsrgVuRpPfxqtWiukRryaVtGLyRzYqcwFGbHu7yQqBxJ.k8j4AQnFumU
 1myCog_sck.Y9QYz_fSMk5HCT3.hYhVJDGDZ8iEaJl2WlHY4lV.JXAXuegWsO_U3fVtknEjnp7xB
 rwQPW57OiCiWYqOPwYolVLKaynkjFlSNaZrjbBTa1x4Gb4hsII9mZ.FB9DGIKr96q5x10r.sj7it
 NK_YKUbO8cNR2hAeXhp6OV.V7lqHWqUYaDAQbVE2Q3b6zIJ.8YXbSs5_Y1S1fmpzynEb0XfgBJwe
 2Twxd4CVc4N9wIK20.PZ193mkzVY_ZtCabeUvtSHfRJbIVydVPurXvRf.CUOdsDKRhSE4iV.5ffd
 nSpBzjnFUbXLXTcZueVMWqzUuGR0C_zc8X6.VYf2OTB5Fknm9Z5zw2ixwnNC1uOY1bwkyhcWRHL6
 jraHzVis_vbOhPwqzdPuu0k.ptbuW_LI7.ef3okIhW9XkeMJaNQpMEaeaXlUhELfje.lkkKsYulk
 09a290G_GiGNw8Oam7SphaRwfDGsAGV68UsnwgX6hn9GC5ykT93IWKjgHw4iprNS3WRoEzFWmfQv
 ys36DdMdBCX8Ofh3uTsyjc8QRES_6_UP_OkF9NzbAKH.TE61RPepvlZUmXIRWKbY5aYgDvGx8Tcr
 yVpnVTuCQe_Atvau.ExCLiEDyyyVMb9IljgEYzMOzBF.MlTM.LwIOJeiQLTMHJOTBHpg88NzkPC6
 ucjnY5wDSOtnjNAB562L.0KnkSw80gb8xunv04F1vruKGzC8eWaOM3j_mj1NI01T8rKctjsgE867
 1JrYgbkNdI2OOYMBlzqIPTKXZLfTXU_GzVSx7havFEwht9e5XvCHfHpW4hNil8qzR5GAlBTuRuj7
 MF_Cw4HveaAauOfGcXtNkzZnjSYMkPrXINWNMWn3ZVlYgg6u_6djtJg9KAgNqMo2wSEke2MGQSvs
 PYSU7DLlb_hn5NW7XmfO2uwUFcNbKD073c3JYSdh8U7N46yB6_dxcGSXqVGN4bEh5N9z.Twa3gs4
 13dzihOGfOPmqLDYI4BHco2AkhAbCoWFFEDremQzim9hUigAYV0FA0fWwpSAcRJe7jaijUjS07tB
 BsvcbiH04T_t3_0AVWHozuWwYbKvuEav6e5EoJ33392WkGOta2fhkdDrX2I4Ozhx.dAqtwkrGDDa
 NV1myVpDK31zXufgHGyYGrzkqkmqZEJfNVTc7QQrZL5FyO_MXZ937IMqmkXMvKOcz8jYDueorQsA
 Kg0XQMb2QpeOtXktrx8tYoi4dpWrrjBhxexFQ9rxEKbvq_YPbWM5OPB8qljTi6e1Hrg_2QAEC.vS
 yuLeB7A9qTm.c1ljh96A00p5hpTlsVPApRBKipep.FVhlNDT1N.1QyGHqvhv33yDLN6tD6HUOqGs
 1q.xU8U5FkHR.NbvNVySBlE44_ozTGXos0ptcSR5Lvl3lRP_38bglhbLKd7vFOVRXjbjcouFZqrK
 Tb3QJKeNsRLSaTnoR4hSF1qMbqFVzrzhnQVuthqZw48lXsoU9nNhwYnO9o2elf7pf1BiaqEvePd1
 3anNXYbsLIx5.svMYmAlHelqsbG5iFAe7WMKNk6xZSYLAusHDj8pIQziCl_ulXTbdqN7DU27di5_
 jrzESMozi_.ySvvUaBitgITsqdrHyAhODB0r7AGwG29tLEmKzI3pRU_zjFF_5mjLFSX8L.mBX1ku
 iYAWO9PFZMO8Vu9G4_suHa.a9mh4ljtAmV7ZBpm27c.7tshVubVNrwYPlFJjp1iikEUSPFTFUrdE
 gQWIb9isCvZhtAmzL.ajzuxUXDRmUkppTBpEUnOmfECBsYv9ugsIUhOTvenjjPu4RaNd_bQIX8UQ
 Q1fkdvK5CLk4LV9u5a1XeDOUjHjK5cKfvjWiDruCAfZVh0FSehuWndvesIycBgScqpYqG8P_BxuH
 E5w_lhyGtw0bPGcBz9dPgmUXwEGgCykEYOsiIorfvXfgLGJh.eT84Si9ZI1UgUwh8W8UXmkF2Lu0
 jWHOsZw9go3kQjfc4wiyY.vu8_DUAKsBvb_HTAFHxfPV_8obOt854H48g3Je_vFYxppBjl7RkeWr
 TEiEFJHO.cJeMxcTdPf2wy3obiqsWw7JxX6Xp_PlJYRlTdnxvaADMmq7eFi2.RrihZBNEXC7Z0ml
 FtUk9hOF7MUDH2aYrY.S8QzB0bGWHUzCM2bJzgJhBlYHi2qXCLif1Rr8hKwWikE6b2kJYk7Zq92b
 54xBDvir3xzjCkCT4iEEysMrnvVS68y_0ZipLH8UgEXqCJQ_5RJGR0FNmNr.2A_zdMNo3PT0qYwr
 SYw5b.aAZkcZp2rbsCYm0keXOvitsek.GVyJUY3IXXOOZ9YYR_tIBN95s43RMSVkGbwnRf.qPH08
 OmG95nWLHcAQOZO.zY5t3BSdYEd_EL8zVKD6GMVFPdLATphReucIBkZAfY8g0mZ5D14VE89bVkcb
 0ee73gSzTN_8Hkc8MsD2C1loJePnbbtLuBYMQQRgf4E3k36dYS.pfLrVv0DqTCjur6pGD5LO3yL6
 20wyaKZMjyyTPJjXIn_Rx9BJd5vnJLPT7eGOS2zYJIDgL6EwJgmHuG7cTTyHicFfaQF_OVn.FFEA
 GdkZ1f8VfHG6oAe96ENLaFDib6hLM4BBQDoTJPfc23uQqlmn4lGCNpldC8SbAjcoJnElo8REX1Ej
 VhKLIosu7lEcJeupNKYqRF1YCk9.66FsW_CTr2_46uvEalqUwOCQIy4JCO27aPix_lL.tfwhOLbx
 Dwzc_lBjNDozNavWLs7fvWECnELMBGllFem2nQrkP2lBx.1o3yhVz2RIASFnqQuTrBcQ8bQi7bnR
 LAUlsvyrMEBbQalqo.M6WlxVnqVsD._oN0IITQMAXxF5c6G20CXv7S6e06Ja6P6h.0DCc95uJHdt
 r3prgh7mV4vdn7s8BtKFVKKEqbGOF38nyS4ZrTiAy2z5BfaASuQXwwFMF1z2qx3JtDTKU4UKTQiE
 -
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Fri, 20 Nov 2020 20:33:04 +0000
Received: by smtp401.mail.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 359628cbfcbaed5b6afc835050250cb1;
          Fri, 20 Nov 2020 20:33:00 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v23 16/23] LSM: security_secid_to_secctx in netlink netfilter
Date:   Fri, 20 Nov 2020 12:15:00 -0800
Message-Id: <20201120201507.11993-17-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20201120201507.11993-1-casey@schaufler-ca.com>
References: <20201120201507.11993-1-casey@schaufler-ca.com>
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

