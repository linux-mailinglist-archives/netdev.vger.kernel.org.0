Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C0138FF38
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:32:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232299AbhEYKd2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:33:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbhEYKc3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:32:29 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58182C061362
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:23 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d89-20020a25a3620000b02904dc8d0450c6so41533995ybi.2
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=gkcIenNyeJgRZGHGvMfH0eC4mHHDBZbDC+PSmyjBqv0=;
        b=AElPzMVIyXDCNF7bcS/Qn16kjkRXJlrRNtoX+4JcNdzAJAR5eoUJOE1G2cvpeZEvCx
         4PTSzLxomOrP9MiKTz5tjqmUVYEUnSsm6tVDS/0iXXR4/BBe+e1+EH7Zq2n/4DuA1kON
         0EY4W5awHjjf/m3I9RyHcP3eN4th9FX+tROiXA+UA2r4SUmeid8IWe0GpnSzf/nBlvsf
         m83wAFIm5nDZIZ83RnhGlL7S0m9dOUTd5w9jNgBYcH99ZtSkXrJaNaBkGDz778lhl54U
         ECvyj+ElPkMPHB0A5gZiYpFcXK3GYkG4Tk/UhBU+eSG1p+2I0mjXKd64mcl2jFNeNgpB
         /lnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=gkcIenNyeJgRZGHGvMfH0eC4mHHDBZbDC+PSmyjBqv0=;
        b=L9ExBx8/5BdB3rdY4nfuBar40wE/BWNr1GtuG7slSuYb4TgwKtTmMcO1eb9KiSqqez
         wzOZctb5shfITFr3GnKtVV+HHDgBCOePGfeQZZ8g8uXb6ugIrZ5U2kHOn94nJ9BY9C4e
         pa7j840AIhERmzgYa2a72SSj2ioi7f4/gNdx6YaWwDlz0DoGigv6WzySDJ+pcljQ1Psb
         VAhju+qs+gAng/ao+B5sw6O4r8TkVoKevsirP+5UIzTvhhgXSB6ZVyo9sOgLScBkulA5
         qGyQLGJ5ziRIhkngadb42rjfsFhUgKnJoXceYSX/hFnzN7duMOxnsPt1FIymBTwaCH8b
         gTKw==
X-Gm-Message-State: AOAM532etV8QqpW0WA+zY5oq5B4At54arwRbOLQviNTUiEbcgEVm/D1G
        lK1kRthzMVSqnnMx08oiac8dW2muiEpA
X-Google-Smtp-Source: ABdhPJxpJ5sRvDD6Xb0++Zy4LqEBQlZp/IfFKZdGtC/Gj1oND+tUMwTnMA2pCPL/qudUaoLHx2PIFscMjuX8
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:8806:6b98:8ae6:8824])
 (user=apusaka job=sendgmr) by 2002:a5b:612:: with SMTP id d18mr20833578ybq.314.1621938622576;
 Tue, 25 May 2021 03:30:22 -0700 (PDT)
Date:   Tue, 25 May 2021 18:29:37 +0800
In-Reply-To: <20210525102941.3958649-1-apusaka@google.com>
Message-Id: <20210525182900.8.Iaeee77b8a1ff6ce9972ba57a9e51d0bfc7d20250@changeid>
Mime-Version: 1.0
References: <20210525102941.3958649-1-apusaka@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 08/12] Bluetooth: use inclusive language in SMP
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
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

Use "central" and "peripheral".

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

 include/net/bluetooth/mgmt.h |  2 +-
 net/bluetooth/mgmt.c         | 10 +++---
 net/bluetooth/smp.c          | 66 +++++++++++++++++++-----------------
 net/bluetooth/smp.h          |  6 ++--
 4 files changed, 43 insertions(+), 41 deletions(-)

diff --git a/include/net/bluetooth/mgmt.h b/include/net/bluetooth/mgmt.h
index a03c62b1dc2f..b9cc4a727b78 100644
--- a/include/net/bluetooth/mgmt.h
+++ b/include/net/bluetooth/mgmt.h
@@ -202,7 +202,7 @@ struct mgmt_cp_load_link_keys {
 struct mgmt_ltk_info {
 	struct mgmt_addr_info addr;
 	__u8	type;
-	__u8	master;
+	__u8	central;
 	__u8	enc_size;
 	__le16	ediv;
 	__le64	rand;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b44e19c69c44..0f550740e1f4 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -6167,7 +6167,7 @@ static int load_irks(struct sock *sk, struct hci_dev *hdev, void *cp_data,
 
 static bool ltk_is_valid(struct mgmt_ltk_info *key)
 {
-	if (key->master != 0x00 && key->master != 0x01)
+	if (key->central != 0x00 && key->central != 0x01)
 		return false;
 
 	switch (key->addr.type) {
@@ -6245,11 +6245,11 @@ static int load_long_term_keys(struct sock *sk, struct hci_dev *hdev,
 		switch (key->type) {
 		case MGMT_LTK_UNAUTHENTICATED:
 			authenticated = 0x00;
-			type = key->master ? SMP_LTK : SMP_LTK_SLAVE;
+			type = key->central ? SMP_LTK : SMP_LTK_PERIPHERAL;
 			break;
 		case MGMT_LTK_AUTHENTICATED:
 			authenticated = 0x01;
-			type = key->master ? SMP_LTK : SMP_LTK_SLAVE;
+			type = key->central ? SMP_LTK : SMP_LTK_PERIPHERAL;
 			break;
 		case MGMT_LTK_P256_UNAUTH:
 			authenticated = 0x00;
@@ -8644,7 +8644,7 @@ static u8 mgmt_ltk_type(struct smp_ltk *ltk)
 {
 	switch (ltk->type) {
 	case SMP_LTK:
-	case SMP_LTK_SLAVE:
+	case SMP_LTK_PERIPHERAL:
 		if (ltk->authenticated)
 			return MGMT_LTK_AUTHENTICATED;
 		return MGMT_LTK_UNAUTHENTICATED;
@@ -8690,7 +8690,7 @@ void mgmt_new_ltk(struct hci_dev *hdev, struct smp_ltk *key, bool persistent)
 	ev.key.rand = key->rand;
 
 	if (key->type == SMP_LTK)
-		ev.key.master = 1;
+		ev.key.central = 1;
 
 	/* Make sure we copy only the significant bytes based on the
 	 * encryption key size, and set the rest of the value to zeroes.
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 54242711aa67..18b1caf47586 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -111,9 +111,9 @@ struct smp_chan {
 	u8		id_addr_type;
 	u8		irk[16];
 	struct smp_csrk	*csrk;
-	struct smp_csrk	*slave_csrk;
+	struct smp_csrk	*peripheral_csrk;
 	struct smp_ltk	*ltk;
-	struct smp_ltk	*slave_ltk;
+	struct smp_ltk	*peripheral_ltk;
 	struct smp_irk	*remote_irk;
 	u8		*link_key;
 	unsigned long	flags;
@@ -753,7 +753,7 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
 	mgmt_smp_complete(hcon, complete);
 
 	kfree_sensitive(smp->csrk);
-	kfree_sensitive(smp->slave_csrk);
+	kfree_sensitive(smp->peripheral_csrk);
 	kfree_sensitive(smp->link_key);
 
 	crypto_free_shash(smp->tfm_cmac);
@@ -776,9 +776,9 @@ static void smp_chan_destroy(struct l2cap_conn *conn)
 			kfree_rcu(smp->ltk, rcu);
 		}
 
-		if (smp->slave_ltk) {
-			list_del_rcu(&smp->slave_ltk->list);
-			kfree_rcu(smp->slave_ltk, rcu);
+		if (smp->peripheral_ltk) {
+			list_del_rcu(&smp->peripheral_ltk->list);
+			kfree_rcu(smp->peripheral_ltk, rcu);
 		}
 
 		if (smp->remote_irk) {
@@ -979,7 +979,7 @@ static u8 smp_random(struct smp_chan *smp)
 	int ret;
 
 	bt_dev_dbg(conn->hcon->hdev, "conn %p %s", conn,
-		   conn->hcon->out ? "master" : "slave");
+		   conn->hcon->out ? "central" : "peripheral");
 
 	ret = smp_c1(smp->tk, smp->rrnd, smp->preq, smp->prsp,
 		     hcon->init_addr_type, &hcon->init_addr,
@@ -1021,8 +1021,8 @@ static u8 smp_random(struct smp_chan *smp)
 		else
 			auth = 0;
 
-		/* Even though there's no _SLAVE suffix this is the
-		 * slave STK we're adding for later lookup (the master
+		/* Even though there's no _PERIPHERAL suffix this is the
+		 * peripheral STK we're adding for later lookup (the central
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
+	if (smp->peripheral_csrk) {
+		smp->peripheral_csrk->bdaddr_type = hcon->dst_type;
+		bacpy(&smp->peripheral_csrk->bdaddr, &hcon->dst);
+		mgmt_new_csrk(hdev, smp->peripheral_csrk, persistent);
 	}
 
 	if (smp->ltk) {
@@ -1089,10 +1089,10 @@ static void smp_notify_keys(struct l2cap_conn *conn)
 		mgmt_new_ltk(hdev, smp->ltk, persistent);
 	}
 
-	if (smp->slave_ltk) {
-		smp->slave_ltk->bdaddr_type = hcon->dst_type;
-		bacpy(&smp->slave_ltk->bdaddr, &hcon->dst);
-		mgmt_new_ltk(hdev, smp->slave_ltk, persistent);
+	if (smp->peripheral_ltk) {
+		smp->peripheral_ltk->bdaddr_type = hcon->dst_type;
+		bacpy(&smp->peripheral_ltk->bdaddr, &hcon->dst);
+		mgmt_new_ltk(hdev, smp->peripheral_ltk, persistent);
 	}
 
 	if (smp->link_key) {
@@ -1272,7 +1272,7 @@ static void smp_distribute_keys(struct smp_chan *smp)
 
 	if (*keydist & SMP_DIST_ENC_KEY) {
 		struct smp_cmd_encrypt_info enc;
-		struct smp_cmd_master_ident ident;
+		struct smp_cmd_central_ident ident;
 		struct smp_ltk *ltk;
 		u8 authenticated;
 		__le16 ediv;
@@ -1293,14 +1293,15 @@ static void smp_distribute_keys(struct smp_chan *smp)
 
 		authenticated = hcon->sec_level == BT_SECURITY_HIGH;
 		ltk = hci_add_ltk(hdev, &hcon->dst, hcon->dst_type,
-				  SMP_LTK_SLAVE, authenticated, enc.ltk,
+				  SMP_LTK_PERIPHERAL, authenticated, enc.ltk,
 				  smp->enc_key_size, ediv, rand);
-		smp->slave_ltk = ltk;
+		smp->peripheral_ltk = ltk;
 
 		ident.ediv = ediv;
 		ident.rand = rand;
 
-		smp_send_cmd(conn, SMP_CMD_MASTER_IDENT, sizeof(ident), &ident);
+		smp_send_cmd(conn, SMP_CMD_CENTRAL_IDENT, sizeof(ident),
+			     &ident);
 
 		*keydist &= ~SMP_DIST_ENC_KEY;
 	}
@@ -1343,7 +1344,7 @@ static void smp_distribute_keys(struct smp_chan *smp)
 				csrk->type = MGMT_CSRK_LOCAL_UNAUTHENTICATED;
 			memcpy(csrk->val, sign.csrk, sizeof(csrk->val));
 		}
-		smp->slave_csrk = csrk;
+		smp->peripheral_csrk = csrk;
 
 		smp_send_cmd(conn, SMP_CMD_SIGN_INFO, sizeof(sign), &sign);
 
@@ -2048,7 +2049,7 @@ static int fixup_sc_false_positive(struct smp_chan *smp)
 	struct smp_cmd_pairing *req, *rsp;
 	u8 auth;
 
-	/* The issue is only observed when we're in slave role */
+	/* The issue is only observed when we're in peripheral role */
 	if (hcon->out)
 		return SMP_UNSPECIFIED;
 
@@ -2084,7 +2085,8 @@ static u8 smp_cmd_pairing_confirm(struct l2cap_conn *conn, struct sk_buff *skb)
 	struct hci_conn *hcon = conn->hcon;
 	struct hci_dev *hdev = hcon->hdev;
 
-	bt_dev_dbg(hdev, "conn %p %s", conn, hcon->out ? "master" : "slave");
+	bt_dev_dbg(hdev, "conn %p %s", conn,
+		   hcon->out ? "central" : "peripheral");
 
 	if (skb->len < sizeof(smp->pcnf))
 		return SMP_INVALID_PARAMS;
@@ -2251,7 +2253,7 @@ static bool smp_ltk_encrypt(struct l2cap_conn *conn, u8 sec_level)
 	hci_le_start_enc(hcon, key->ediv, key->rand, key->val, key->enc_size);
 	hcon->enc_key_size = key->enc_size;
 
-	/* We never store STKs for master role, so clear this flag */
+	/* We never store STKs for central role, so clear this flag */
 	clear_bit(HCI_CONN_STK_ENCRYPT, &hcon->flags);
 
 	return true;
@@ -2467,7 +2469,7 @@ int smp_cancel_and_remove_pairing(struct hci_dev *hdev, bdaddr_t *bdaddr,
 		/* Set keys to NULL to make sure smp_failure() does not try to
 		 * remove and free already invalidated rcu list entries. */
 		smp->ltk = NULL;
-		smp->slave_ltk = NULL;
+		smp->peripheral_ltk = NULL;
 		smp->remote_irk = NULL;
 
 		if (test_bit(SMP_FLAG_COMPLETE, &smp->flags))
@@ -2503,7 +2505,7 @@ static int smp_cmd_encrypt_info(struct l2cap_conn *conn, struct sk_buff *skb)
 		return SMP_INVALID_PARAMS;
 	}
 
-	SMP_ALLOW_CMD(smp, SMP_CMD_MASTER_IDENT);
+	SMP_ALLOW_CMD(smp, SMP_CMD_CENTRAL_IDENT);
 
 	skb_pull(skb, sizeof(*rp));
 
@@ -2512,9 +2514,9 @@ static int smp_cmd_encrypt_info(struct l2cap_conn *conn, struct sk_buff *skb)
 	return 0;
 }
 
-static int smp_cmd_master_ident(struct l2cap_conn *conn, struct sk_buff *skb)
+static int smp_cmd_central_ident(struct l2cap_conn *conn, struct sk_buff *skb)
 {
-	struct smp_cmd_master_ident *rp = (void *) skb->data;
+	struct smp_cmd_central_ident *rp = (void *)skb->data;
 	struct l2cap_chan *chan = conn->smp;
 	struct smp_chan *smp = chan->data;
 	struct hci_dev *hdev = conn->hcon->hdev;
@@ -2913,7 +2915,7 @@ static int smp_cmd_dhkey_check(struct l2cap_conn *conn, struct sk_buff *skb)
 			return 0;
 		}
 
-		/* Slave sends DHKey check as response to master */
+		/* Peripheral sends DHKey check as response to central */
 		sc_dhkey_check(smp);
 	}
 
@@ -3000,8 +3002,8 @@ static int smp_sig_channel(struct l2cap_chan *chan, struct sk_buff *skb)
 		reason = smp_cmd_encrypt_info(conn, skb);
 		break;
 
-	case SMP_CMD_MASTER_IDENT:
-		reason = smp_cmd_master_ident(conn, skb);
+	case SMP_CMD_CENTRAL_IDENT:
+		reason = smp_cmd_central_ident(conn, skb);
 		break;
 
 	case SMP_CMD_IDENT_INFO:
diff --git a/net/bluetooth/smp.h b/net/bluetooth/smp.h
index fc35a8bf358e..57ac417e9712 100644
--- a/net/bluetooth/smp.h
+++ b/net/bluetooth/smp.h
@@ -79,8 +79,8 @@ struct smp_cmd_encrypt_info {
 	__u8	ltk[16];
 } __packed;
 
-#define SMP_CMD_MASTER_IDENT	0x07
-struct smp_cmd_master_ident {
+#define SMP_CMD_CENTRAL_IDENT	0x07
+struct smp_cmd_central_ident {
 	__le16	ediv;
 	__le64	rand;
 } __packed;
@@ -146,7 +146,7 @@ struct smp_cmd_keypress_notify {
 enum {
 	SMP_STK,
 	SMP_LTK,
-	SMP_LTK_SLAVE,
+	SMP_LTK_PERIPHERAL,
 	SMP_LTK_P256,
 	SMP_LTK_P256_DEBUG,
 };
-- 
2.31.1.818.g46aad6cb9e-goog

