Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75A1332998
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 16:03:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbhCIPDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 10:03:22 -0500
Received: from sonic309-26.consmr.mail.ne1.yahoo.com ([66.163.184.152]:44561
        "EHLO sonic309-26.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231864AbhCIPCy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 10:02:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615302173; bh=q3I4/eiRbkYu2f0b01JDmqntb1ptAUIyC93pJ+71rvk=; h=From:To:Cc:Subject:Date:In-Reply-To:References:From:Subject:Reply-To; b=fgUAcYfSFGqEAR/K4chnb0vzS7/Fib0OKjDBEvRPPLcyBGV+d3ZMpCtEHi7jiPeOt/kY+SSBAuLMX3Tn9DTx4jLwmSH+nTLKJDLKhglz0e7fBOm8mRgU7CX2YuHWMvAEjGJQrKZKYAvr+JiVGKAH56+suJnGlY2OFVR016AwtEfP+6qToLTbB9V4YEVLOb5bGGO7DEpoti54frCu9Z6vE0WpT9Yz8Chvlr0SA0QyhIKO6PWGBj9K8xWqGN8L7+XslCkkoO2aOQVUN3JF9T3ctOHXB4GNIMibH9mOAo0MQ3gWRBYh7/Pfeb1FxDnk7oWO1pOFWZCRYZnfCqHiJP+rNg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1615302173; bh=n4B2aMXEhl/rANrFIR28Yve3FPmx9aqcjy28vhfBYk3=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=m8r0fnjlXdejOMYfsf7nCKuLY3SNRiuLKEZK/fIKVeOLKAUzQ0hhnSr1MnQw7Akulhrr+hqBH5nm4OKtsarLLQFsZjJvLQNYc3q+TGcGsc0uJa+QFlMxtNSMNRFSvaN9/8B0eILkUlN0MSOPvyX0L6xNdtc2mLXlIJLBSQHAy3gfiKj3zmUGDalY16pQ7TkvnMlt/b51SDdP9QLLF6fm4Y/dF7tYNdVdZKx6f6ubLmqfNSd4GAp5ydddekYUTR9OkyhG5YfPVC5eLpPnBqVgxnxgUN1SnNeuwP8svWvXBwQvW/KT/gvTJFqA4uqCsbxKZNv6WMibe4jPWCuGThhdJA==
X-YMail-OSG: MN8umH4VM1lX59sSB1DZsLSTWprG5qUFk4SCRa3raXs8gmFff5UkkQFG7uJYcvV
 U1mNgbGVXcFOnGrssTfUNtonVuMsfdagHsMN3EVHHBkqniJo0mtXqozqr4Rx1i.BJQSUc27uNpwr
 8qfmTJtFmvlJvqwDGYWcXK18kR20kgwUP1TNnSWPUAcpbyooVh_VtD7YLmAxzHj.pd.uPZz9laRI
 fy_x1KndKJwVasKfYn3uXVCKZr59xTj1wRkN1onwzp3v3.D9Nso9t11ARg.TTNOyaB1T5kWQO6Vm
 pL0duI_qSyyqsEyEvYMBlwomjV188m90aj.X5AAa.KpTTJ3lATQTx3PGQC.zPg908AP_6xJbcwS2
 Sy8hnWctbobxo8hbm1dl0YHsVOZCa3gFqvPxV0S01Jp6W6n.mZkHYaXYfBZtsSoFMHybO_uRTH7I
 7hg0WGgnrU9NHlDYupoXkhijnutgDLwo6aT_0xg2jBQs.8Xjta9LjaBqNzDc3901NViJ7d4wsX1K
 yg8TOlxHjYdPYSI4zw8qTBokD46tlPVqhCxIiu64WIkeU5dUgbURcbfcaEjCpVRbUmYcY5XgFuNj
 OCYxGoo5b1xMRfqE434EoDUrb1JqIFoK3AAnTDD.eE8dcqv9._x.XGusXJHujC8Mxip6zqUfrsCu
 D8RbJtDEGjdQnOOXLwk_lfj2yMWJjWkKO5P7MjdujM3b7KsCo2tPTZS6geGUABm_4lhl_xmv7s3O
 dHjirccc7d0HQ82LgnBQTAJU57ABS6CmkwiopG7UwMNa5CRB6PZLN29K4LNbfAF.Ckqzj3yKiF18
 Pu4.AdgKICUk_wedq52MHvAcnhzJgFy0s9KX3Kx68NLeJ4wnpQvj2oxHzlPVDB8m0wUymcZ3Dpad
 9nKqWXF7MEukI.bc_zbXcQIrKKBqjrbUjdj.845aoVwHbuS7Qu761LEo1j0bt13._Af4xEL7RedW
 G9KnI2kDxFI0SmKtotXzBG9qay1eliZDlVfeROZnhJvY3AGbXDUYXcBeKwiUlui03hR11XjuLlgz
 g_G0UYnCCYBFiMO7J9fKYWZB28FrUtReKCwUezFtk6KgKFEM6Rf02jiO0DsBUHThF7Vc9VRQScpO
 oGqaCEsYEd14Xdb74lKarSJsh5m1v1j9jd5LDKo2nkl.6EHdOqQZnq8i3smG.3HcC1alIKWmEodh
 103bpYGpo.Y2sr1zFenTQjJ60IKX6wig2D0BR1cMlH3U0dIvHbawVnj.IchKcn7pUBXkTdyQNW8E
 qcFH1TvZ7o_IME67.ooR3UtI91QMEvLyrCcEWRhBjsmGyhmpY2Juv3eDjeCnJG2zzXPzz4lBUaDp
 BqLgRJTSWIO8K3cu1gGHFI4bWD3ONg4pZCQoCn8YuJO.Gl4a3bfmwWheJv53m97wuWQ8FlIUIkx2
 9ptudzTQPXo0RSeK1NkVfpRU3r.nDzgyW6x6H7ULqcI_8XuJ8zP.IeLBg72A..drUh_GuroXGbyS
 _RKHiZ5_ooG9x9EuGbsMOJMXhu5WM4HwTaXg35bYb5opdKVtZX.jNIe2OmWiNEQeP64BlMy5MciN
 SBsGIQ3.NZjoQbAnyddSo8GfQXKUbY7Gyt9VCWgM7.jDBuhIuSCNi_WeQercIcmmUMqMT3BRDg7I
 tXouJH8PXIOq4eDVI3L934JiU0Y7QX0axmzYi7RvQX3o1zVenquVv5zK3SD3OgUA.JpVwJvpFPBc
 E1zH1om9Dxy399cwLrxZQXENgt.AUHKXtOHcpjs_6wu6rZtFa70dUg7UQsmsCKNlVlQ4bVh4FxbD
 3OHFFwt9wJHbcBSWVNiND5QQPwGxF6B5STkthxqkm9X8P72o6AinSwKebfmUscvE_MGwlaEJ0bhs
 C6A0hqSVKDpXW17f0edNSz7LcepUxZoy7nwo6pw6z0ykS9hM49CIO8jdnmia5nOhooswu1BLTx57
 fBIauhdukx5ZgkLURlRNiB09Vc8r8Lnyljkj5prYjAb.bcT.6ZoUYf7mTI2c3Wdf7TDufEhKghw7
 tezx5XecIuZVI4esWK_bvBwG3aJ9DDR1IeObDD91ZFeuf4pCbZMdGtt0bEGwCJK5Zaq96aYMM5k7
 kWxYXRL260IRDEQ8a8ItisCnjqt6mo8I1MOizQXUeVt0sODniG9AgGvy67BZMwaU6l2g2Nk.tQW3
 pu1QfTT8lxAS7r1CgNjiTBtGnRaj.a2N1Ao5Yahmrb_ILWgNANEIAW4_CMqQBw34QYnVDl3wMjN9
 k_WuzY_VWYzZvpU_BOA8UtLUWG2_0IYwGMC2nUFegx3tt3rdywLqr3dOtjQt_kKlTigCPUOf8NGK
 7uPGMw1GapsL5apyU1rzzr3RWXhI0iWtua12mllm8Tu1CQy9xPBi6G2Krw5.rbIjcMGZNPvINWDB
 Ruc8OczugfpD7Jqoqq2tWLs_a0id3_AS1fIyECzH5Ca3jX5MKQwzAVxHVM3s4BGP60pXW1d3F92i
 y8gEsvFZnMr8lv_sijfJhRFMfhMlQXKLH_vR3GfOyqKOMhn5A0Rm9DyhXzc50eV4RBy.5dTh1H2V
 lc0BuB4Au8ZTnU17JioYGLeZIPD.2aUB5Lg3Px.sAPC.RQxQzrYvOKk4YQyHIImUM43Q5z1xr2GK
 5aLPYTtut5uIFeduGSXUzXWpiz1YSQGmR5q6FSJCV_BgdyUr1JgTdzQS0ilb_b0qNGzJb2j9cnPM
 l2V8KjKXd95C0ZwZYBS9VfNHQWU9mHk8ly4oUDLMtM2ueBFWpa_AYWSponI_2vU_JfdPOHe48h1x
 V_PTZAkwc53yrEUizgbZXG69ZKfq_KX2hVho_6.uoPzQfvAD2qsqGOa0L4RMjsz1KCkklCPniPXu
 aagXoAquTmzwIhc0GX8tHmgCb5qzp.TALy6lsZ0qqGWUv3eYycUdR23rD9ghSI.knmkM1YhFWRwq
 awnuNgoBJoNxeR84ZtT1dYlVfyMVC_KcJohY9lNulo60aB6hWwG6zTkBfI.uaw4IPPSJxKl9MRt0
 R3DKVRCXbKyf8Cij8LSEpxZKj6ZaOPqI4dk.k_gunXOojNDKejSwDY42hZZmqN3kXjcO5dSmljRG
 tyoKc6yfuBByr7y1F42ju.OtrTT6JTXr4M8haz6lFyluY62zrr_Lx.CRrbmsb8EDqjYe2XNMft1g
 m3QntwndazmROZUxX1TRJQ4iA_k3rYVg6isLPx.Mcw3A8ZWggCiCo9JUtCQOLrfTt01kuv.uPuUP
 uLkeQMGmLdE28jso7.wuRdq5CRQAd8dCE8qDLeSHJlswpsYHxGg9RkXvdjRCh8VC4Tzijsuus2gu
 w4fKpXwS6yp2pHOZSlAY7BtaWSZz86.7WfZifH3C_GgcrSSKh6aoRkXN2dX76QmxwG.zhZQ--
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Tue, 9 Mar 2021 15:02:53 +0000
Received: by smtp412.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 0b0b60e1a865012f293c98f03ce575b1;
          Tue, 09 Mar 2021 15:02:48 +0000 (UTC)
From:   Casey Schaufler <casey@schaufler-ca.com>
To:     casey.schaufler@intel.com, jmorris@namei.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org
Cc:     casey@schaufler-ca.com, linux-audit@redhat.com,
        keescook@chromium.org, john.johansen@canonical.com,
        penguin-kernel@i-love.sakura.ne.jp, paul@paul-moore.com,
        sds@tycho.nsa.gov, linux-kernel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: [PATCH v25 18/25] LSM: security_secid_to_secctx in netlink netfilter
Date:   Tue,  9 Mar 2021 06:42:36 -0800
Message-Id: <20210309144243.12519-19-casey@schaufler-ca.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210309144243.12519-1-casey@schaufler-ca.com>
References: <20210309144243.12519-1-casey@schaufler-ca.com>
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
index 449c2c7c7b27..56784592c820 100644
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
@@ -471,9 +465,9 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -606,7 +600,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	    nfqnl_put_sk_uidgid(skb, entskb->sk) < 0)
 		goto nla_put_failure;
 
-	if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
+	if (context.len &&
+	    nla_put(skb, NFQA_SECCTX, context.len, context.context))
 		goto nla_put_failure;
 
 	if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) < 0)
@@ -634,10 +629,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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
@@ -645,10 +638,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
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

