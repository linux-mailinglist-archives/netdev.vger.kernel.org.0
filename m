Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 185A739572F
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbhEaIla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:41:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhEaIkz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:40:55 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96BDC06134F
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:59 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id d15-20020a05620a136fb02902e9e93c69c8so8957189qkl.23
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Wq582RTddpXTOBA/9kUqY6cydC2I3+L2zU+wv+Xfw4M=;
        b=I68QpgSZS8SbTPjFE7/GAUhilDVYQj5AzyTeHT4I0mkGraAI8rd0MzeXuIRcKdd9fN
         JpzY3uzpbqmQ6DnQpK3yvTQK6YcarGLlfL8/qPiT1qlyEfZzIZ5Fup6rsBSZBHiCuH0s
         r9HfDgTnqJzjrhLyNr4hbzEXp0KTpUhBog18xPMefBNeRIBxQS0j6bUDWqw6btic3oFZ
         LpRHfi0BGBgy0IJSb+IbuXvFA/chxh7gKM7zzqj6nIJWHNEs+KQ49L6jLz6+i+jcwhtf
         LFgZ0htiZa+cuVQT/yQE2G/6Qw/zVgBOR9lbXrB166p/bs97ej7Incf3ZoR3BOd1Q+NJ
         xLAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wq582RTddpXTOBA/9kUqY6cydC2I3+L2zU+wv+Xfw4M=;
        b=C2PJff4xrDBGtNxGsbb1ajJNU6zZODU04bQ+06esDHNMagOaJNAeygbPAjobNNvhBV
         F4VbXY+KOzE/cQWoLYXnWUceMDdow6Ta21DuGvckFQAep6Fs+yiuou8iI32LnWIYVuH2
         0C2eUrYMZFlZ/VTgb5U6kdqMALOhmGfdUtNllqiLXiwffINm48wofOMMquuL6dlACyMz
         njo8eh4zvImh4+d3SgrG12C6i5IaZnCs3G5zEBJUrtEBM84bmQwd4S25LQxC6UnzrKL/
         cdn7ZKlm9F2D1uMneE9+BhrxF0V8u4kIMzGFI/5WfC+pCnJP/BxFySfGYpXjaXrwSC9p
         3Tqg==
X-Gm-Message-State: AOAM532l+Aayh2JZ3ckIMHbVVcZIzN7uIU3ku0bO+HzvAOThgEqGe5O8
        tjyO1W+QaNryeuHz06SogaD+uAugM5EU
X-Google-Smtp-Source: ABdhPJzVGGEeWpB27fyBqOMbIhqP1vGfpr7VsyrhIqqNjfMgSRxmOE+QXCv/2ufo4225Rx1KRzdLA7vTP6Mn
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:a6d1:a727:b17d:154e])
 (user=apusaka job=sendgmr) by 2002:a0c:fe90:: with SMTP id
 d16mr12956067qvs.62.1622450339081; Mon, 31 May 2021 01:38:59 -0700 (PDT)
Date:   Mon, 31 May 2021 16:37:25 +0800
In-Reply-To: <20210531083726.1949001-1-apusaka@google.com>
Message-Id: <20210531163500.v2.6.I8ce5429f4899791a30c0c612e007e230f2ffee1a@changeid>
Mime-Version: 1.0
References: <20210531083726.1949001-1-apusaka@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 6/8] Bluetooth: use inclusive language in SMP
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

This patch replaces some non-inclusive terms based on the appropriate
language mapping table compiled by the Bluetooth SIG:
https://specificationrefs.bluetooth.com/language-mapping/Appropriate_Language_Mapping_Table.pdf

Specifically, these terms are replaced:
master -> initiator
slave  -> responder

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
---

Changes in v2:
* Add details in commit message
* Use initiator/responder instead of central/peripheral

 include/net/bluetooth/mgmt.h |  2 +-
 net/bluetooth/mgmt.c         | 10 +++---
 net/bluetooth/smp.c          | 66 +++++++++++++++++++-----------------
 net/bluetooth/smp.h          |  6 ++--
 4 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a03c62b1dc2f..23a0524061b7 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -202,7 +202,7 @@ struct mgmt_cp_load_link_keys {
 struct mgmt_ltk_info {
 	struct mgmt_addr_info addr;
 	__u8	type;
-	__u8	master;
+	__u8	initiator;
 	__u8	enc_size;
 	__le16	ediv;
 	__le64	rand;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index 91d36c3bf23e..6adee6de1e03 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6169,7 +6169,7 @@ static int load_irks(struct sock *sk, struct hci_dev *hdev, void *cp_data,
 
 static bool ltk_is_valid(struct mgmt_ltk_info *key)
 {
-	if (key->master != 0x00 && key->master != 0x01)
+	if (key->initiator != 0x00 && key->initiator != 0x01)
 		return false;
 
 	switch (key->addr.type) {
@@ -6247,11 +6247,11 @@ static int load_long_term_keys(struct sock *sk, struct hci_dev *hdev,
 		switch (key->type) {
 		case MGMT_LTK_UNAUTHENTICATED:
 			authenticated = 0x00;
-			type = key->master ? SMP_LTK : SMP_LTK_SLAVE;
+			type = key->initiator ? SMP_LTK : SMP_LTK_RESPONDER;
 			break;
 		case MGMT_LTK_AUTHENTICATED:
 			authenticated = 0x01;
-			type = key->master ? SMP_LTK : SMP_LTK_SLAVE;
+			type = key->initiator ? SMP_LTK : SMP_LTK_RESPONDER;
 			break;
 		case MGMT_LTK_P256_UNAUTH:
 			authenticated = 0x00;
@@ -8646,7 +8646,7 @@ static u8 mgmt_ltk_type(struct smp_ltk *ltk)
 {
 	switch (ltk->type) {
 	case SMP_LTK:
-	case SMP_LTK_SLAVE:
+	case SMP_LTK_RESPONDER:
 		if (ltk->authenticated)
 			return MGMT_LTK_AUTHENTICATED;
 		return MGMT_LTK_UNAUTHENTICATED;
@@ -8692,7 +8692,7 @@ void mgmt_new_ltk(struct hci_dev *hdev, struct smp_ltk *key, bool persistent)
 	ev.key.rand = key->rand;
 
 	if (key->type == SMP_LTK)
-		ev.key.master = 1;
+		ev.key.initiator = 1;
 
 	/* Make sure we copy only the significant bytes based on the
 	 * encryption key size, and set the rest of the value to zeroes.
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 54242711aa67..f357bc6e5366 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -111,9 +111,9 @@ struct smp_chan {
 	u8		id_addr_type;
 	u8		irk[16];
 	struct smp_csrk	*csrk;
-	struct smp_csrk	*slave_csrk;
+	struct smp_csrk	*responder_csrk;
 	struct smp_ltk	*ltk;
-	struct smp_ltk	*slave_ltk;
+	struct smp_ltk	*responder_ltk;
 	struct smp_irk	*remote_irk;
 	u8		*link_key;
 	unsigned long	flags;
@@ -753,7 +753,7 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
 	mgmt_smp_complete(hcon, complete);
 
 	kfree_sensitive(smp->csrk);
-	kfree_sensitive(smp->slave_csrk);
+	kfree_sensitive(smp->responder_csrk);
 	kfree_sensitive(smp->link_key);
 
 	crypto_free_shash(smp->tfm_cmac);
@@ -776,9 +776,9 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
 			kfree_rcu(smp->ltk, rcu);
 		}
 
-		if (smp->slave_ltk) {
-			list_del_rcu(&smp->slave_ltk->list);
-			kfree_rcu(smp->slave_ltk, rcu);
+		if (smp->responder_ltk) {
+			list_del_rcu(&smp->responder_ltk->list);
+			kfree_rcu(smp->responder_ltk, rcu);
 		}
 
 		if (smp->remote_irk) {
@@ -979,7 +979,7 @@ static u8 smp_random(struct smp_chan *smp)
 	int ret;
 
 	bt_dev_dbg(conn->hcon->hdev, "conn %p %s", conn,
-		   conn->hcon->out ? "master" : "slave");
+		   conn->hcon->out ? "initiator" : "responder");
 
 	ret = smp_c1(smp->tk, smp->rrnd, smp->preq, smp->prsp,
 		     hcon->init_addr_type, &hcon->init_addr,
@@ -1021,8 +1021,8 @@ static u8 smp_random(struct smp_chan *smp)
 		else
 			auth = 0;
 
-		/* Even though there's no _SLAVE suffix this is the
-		 * slave STK we're adding for later lookup (the master
+		/* Even though there's no _RESPONDER suffix this is the
+		 * responder STK we're adding for later lookup (the initiator
 		 * STK never needs to be stored).
 		 */
 		hci_add_ltk(hcon->hdev, &hcon->dst, hcon->dst_type,
@@ -1077,10 +1077,10 @@ static void smp_notify_keys(struct l2cap_conn *conn)
 		mgmt_new_csrk(hdev, smp->csrk, persistent);
 	}
 
-	if (smp->slave_csrk) {
-		smp->slave_csrk->bdaddr_type = hcon->dst_type;
-		bacpy(&smp->slave_csrk->bdaddr, &hcon->dst);
-		mgmt_new_csrk(hdev, smp->slave_csrk, persistent);
+	if (smp->responder_csrk) {
+		smp->responder_csrk->bdaddr_type = hcon->dst_type;
+		bacpy(&smp->responder_csrk->bdaddr, &hcon->dst);
+		mgmt_new_csrk(hdev, smp->responder_csrk, persistent);
 	}
 
 	if (smp->ltk) {
@@ -1089,10 +1089,10 @@ static void smp_notify_keys(struct l2cap_conn *conn)
 		mgmt_new_ltk(hdev, smp->ltk, persistent);
 	}
 
-	if (smp->slave_ltk) {
-		smp->slave_ltk->bdaddr_type = hcon->dst_type;
-		bacpy(&smp->slave_ltk->bdaddr, &hcon->dst);
-		mgmt_new_ltk(hdev, smp->slave_ltk, persistent);
+	if (smp->responder_ltk) {
+		smp->responder_ltk->bdaddr_type = hcon->dst_type;
+		bacpy(&smp->responder_ltk->bdaddr, &hcon->dst);
+		mgmt_new_ltk(hdev, smp->responder_ltk, persistent);
 	}
 
 	if (smp->link_key) {
@@ -1272,7 +1272,7 @@ static void smp_distribute_keys(struct smp_chan *smp)
 
 	if (*keydist & SMP_DIST_ENC_KEY) {
 		struct smp_cmd_encrypt_info enc;
-		struct smp_cmd_master_ident ident;
+		struct smp_cmd_initiator_ident ident;
 		struct smp_ltk *ltk;
 		u8 authenticated;
 		__le16 ediv;
@@ -1293,14 +1293,15 @@ static void smp_distribute_keys(struct smp_chan *smp)
 
 		authenticated = hcon->sec_level == BT_SECURITY_HIGH;
 		ltk = hci_add_ltk(hdev, &hcon->dst, hcon->dst_type,
-				  SMP_LTK_SLAVE, authenticated, enc.ltk,
+				  SMP_LTK_RESPONDER, authenticated, enc.ltk,
 				  smp->enc_key_size, ediv, rand);
-		smp->slave_ltk = ltk;
+		smp->responder_ltk = ltk;
 
 		ident.ediv = ediv;
 		ident.rand = rand;
 
-		smp_send_cmd(conn, SMP_CMD_MASTER_IDENT, sizeof(ident), &ident);
+		smp_send_cmd(conn, SMP_CMD_INITIATOR_IDENT, sizeof(ident),
+			     &ident);
 
 		*keydist &= ~SMP_DIST_ENC_KEY;
 	}
@@ -1343,7 +1344,7 @@ static void smp_distribute_keys(struct smp_chan *smp)
 				csrk->type = MGMT_CSRK_LOCAL_UNAUTHENTICATED;
 			memcpy(csrk->val, sign.csrk, sizeof(csrk->val));
 		}
-		smp->slave_csrk = csrk;
+		smp->responder_csrk = csrk;
 
 		smp_send_cmd(conn, SMP_CMD_SIGN_INFO, sizeof(sign), &sign);
 
@@ -2048,7 +2049,7 @@ static int fixup_sc_false_positive(struct smp_chan *smp)
 	struct smp_cmd_pairing *req, *rsp;
 	u8 auth;
 
-	/* The issue is only observed when we're in slave role */
+	/* The issue is only observed when we're in responder role */
 	if (hcon->out)
 		return SMP_UNSPECIFIED;
 
@@ -2084,7 +2085,8 @@ static u8 smp_cmd_pairing_confirm(struct l2cap_conn *conn, struct sk_buff *skb)
 	struct hci_conn *hcon = conn->hcon;
 	struct hci_dev *hdev = hcon->hdev;
 
-	bt_dev_dbg(hdev, "conn %p %s", conn, hcon->out ? "master" : "slave");
+	bt_dev_dbg(hdev, "conn %p %s", conn,
+		   hcon->out ? "initiator" : "responder");
 
 	if (skb->len < sizeof(smp->pcnf))
 		return SMP_INVALID_PARAMS;
@@ -2251,7 +2253,7 @@ static bool smp_ltk_encrypt(struct l2cap_conn *conn, u8 sec_level)
 	hci_le_start_enc(hcon, key->ediv, key->rand, key->val, key->enc_size);
 	hcon->enc_key_size = key->enc_size;
 
-	/* We never store STKs for master role, so clear this flag */
+	/* We never store STKs for initiator role, so clear this flag */
 	clear_bit(HCI_CONN_STK_ENCRYPT, &hcon->flags);
 
 	return true;
@@ -2467,7 +2469,7 @@ int smp_cancel_and_remove_pairing(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		/* Set keys to NULL to make sure smp_failure() does not try to
 		 * remove and free already invalidated rcu list entries. */
 		smp->ltk = NULL;
-		smp->slave_ltk = NULL;
+		smp->responder_ltk = NULL;
 		smp->remote_irk = NULL;
 
 		if (test_bit(SMP_FLAG_COMPLETE, &smp->flags))
@@ -2503,7 +2505,7 @@ static int smp_cmd_encrypt_info(struct l2cap_conn *conn, struct sk_buff *skb)
 		return SMP_INVALID_PARAMS;
 	}
 
-	SMP_ALLOW_CMD(smp, SMP_CMD_MASTER_IDENT);
+	SMP_ALLOW_CMD(smp, SMP_CMD_INITIATOR_IDENT);
 
 	skb_pull(skb, sizeof(*rp));
 
@@ -2512,9 +2514,9 @@ static int smp_cmd_encrypt_info(struct l2cap_conn *conn, struct sk_buff *skb)
 	return 0;
 }
 
-static int smp_cmd_master_ident(struct l2cap_conn *conn, struct sk_buff *skb)
+static int smp_cmd_initiator_ident(struct l2cap_conn *conn, struct sk_buff *skb)
 {
-	struct smp_cmd_master_ident *rp = (void *) skb->data;
+	struct smp_cmd_initiator_ident *rp = (void *)skb->data;
 	struct l2cap_chan *chan = conn->smp;
 	struct smp_chan *smp = chan->data;
 	struct hci_dev *hdev = conn->hcon->hdev;
@@ -2913,7 +2915,7 @@ static int smp_cmd_dhkey_check(struct l2cap_conn *conn, struct sk_buff *skb)
 			return 0;
 		}
 
-		/* Slave sends DHKey check as response to master */
+		/* Responder sends DHKey check as response to initiator */
 		sc_dhkey_check(smp);
 	}
 
@@ -3000,8 +3002,8 @@ static int smp_sig_channel(struct l2cap_chan *chan, struct sk_buff *skb)
 		reason = smp_cmd_encrypt_info(conn, skb);
 		break;
 
-	case SMP_CMD_MASTER_IDENT:
-		reason = smp_cmd_master_ident(conn, skb);
+	case SMP_CMD_INITIATOR_IDENT:
+		reason = smp_cmd_initiator_ident(conn, skb);
 		break;
 
 	case SMP_CMD_IDENT_INFO:
diff --git a/net/bluetooth/smp.h b/net/bluetooth/smp.h
index fc35a8bf358e..87a59ec2c9f0 100644
--- a/net/bluetooth/smp.h
+++ b/net/bluetooth/smp.h
@@ -79,8 +79,8 @@ struct smp_cmd_encrypt_info {
 	__u8	ltk[16];
 } __packed;
 
-#define SMP_CMD_MASTER_IDENT	0x07
-struct smp_cmd_master_ident {
+#define SMP_CMD_INITIATOR_IDENT	0x07
+struct smp_cmd_initiator_ident {
 	__le16	ediv;
 	__le64	rand;
 } __packed;
@@ -146,7 +146,7 @@ struct smp_cmd_keypress_notify {
 enum {
 	SMP_STK,
 	SMP_LTK,
-	SMP_LTK_SLAVE,
+	SMP_LTK_RESPONDER,
 	SMP_LTK_P256,
 	SMP_LTK_P256_DEBUG,
 };
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

