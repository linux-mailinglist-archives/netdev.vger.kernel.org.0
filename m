Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE792395720
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:38:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbhEaIkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230423AbhEaIkI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:40:08 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E8A6C061760
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:28 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id n129-20020a2527870000b02904ed02e1aab5so12937882ybn.21
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UB+ve60Kn8xuHdfLtaEQ5HuB9aL0NsBJurrC58tfpX0=;
        b=vnTJYy6qv4JxioF4A4dPI/GMy/0nA3As/WxSu8zNl5Lkv9oRpNaZqfxLhFfFa7RfhC
         xNxGCViV9Q5R9IjGtJvePCMLC1cuFAgm6Y7N5Z1m/NjTsawz4ogzV6TuDbPSDMAxWeN2
         Zym22Nc/AooodehlEMlAxnTTCpI6URRIJTwMcWFbi7E5fB5ZE5Fd2lvE5ZxHm5lIBLE7
         u7C7zkNe5gO25o/n5m5YkaZ2pGlTjSakRTpzK/eI6J0JMhOsFgrve3K/4wH5xUqNTsvq
         VWmFBgft5I9vmIFyBAgEJtTkkGb3ej4e2RZzDWRVwEAjkPil8uRl27d5uImL03DYEjxv
         YFSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UB+ve60Kn8xuHdfLtaEQ5HuB9aL0NsBJurrC58tfpX0=;
        b=VCqU8FT37au7fdVfohPK+lCigEZZUdq2hc53uIvAlCBV/v9BfZXwM2oWh9BqEAnNAR
         CBuJE3SMtL4MQDHciUOYnY+qwnh9e1gkNUf8tBiXmb6DaN4dY0vF2Oyp4rrrlQ9nRHaE
         IaprISsYTky0YZJcRkRHxVtNSiBa9P0MFblC3l+X/aDWZEddaOD3yaAi0FxKGwx0+b4K
         fhH/oH4wLfMtRABfSTUA6HKMvgVEt4B2dBWQYcoR2t6aapJZRg+kVE4bxYcGNREEquS4
         kijVN5NVBl0SReM7/3NO1kirKFog6/uy6Zw118IHEAl4JCUsuqeVdOJ+Z4wut63tGgLl
         12UQ==
X-Gm-Message-State: AOAM530hcUjJVaTXFV9DTh+rZR1AJGYK+qm0/J5b+RUG2ulbbLvxa4lw
        4UTJ0HRCH4LYKKmIpk1qd5PfJra3/Z0u
X-Google-Smtp-Source: ABdhPJzdgvPlEiK7zUX8pyaLQcf6q0qrrJpXzc6HB761RRH+QcWh5MCY8wxNRy/PcWiPe6rPm+rHXRhENWxM
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:a6d1:a727:b17d:154e])
 (user=apusaka job=sendgmr) by 2002:a25:bb41:: with SMTP id
 b1mr30273825ybk.249.1622450307423; Mon, 31 May 2021 01:38:27 -0700 (PDT)
Date:   Mon, 31 May 2021 16:37:20 +0800
In-Reply-To: <20210531083726.1949001-1-apusaka@google.com>
Message-Id: <20210531163500.v2.1.I55a28f07420d96b60332def9a579d27f4a4cf4cb@changeid>
Mime-Version: 1.0
References: <20210531083726.1949001-1-apusaka@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 1/8] Bluetooth: use inclusive language in HCI role
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

This patch replaces some non-inclusive terms based on the appropriate
language mapping table compiled by the Bluetooth SIG:
https://specificationrefs.bluetooth.com/language-mapping/Appropriate_Language_Mapping_Table.pdf

Specifically, these terms are replaced:
master -> central
slave  -> peripheral

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

Changes in v2:
* Add details in commit message

 include/net/bluetooth/hci.h      |  6 +++---
 include/net/bluetooth/hci_core.h |  4 ++--
 net/bluetooth/amp.c              |  2 +-
 net/bluetooth/hci_conn.c         | 30 +++++++++++++++---------------
 net/bluetooth/hci_core.c         |  6 +++---
 net/bluetooth/hci_event.c        | 20 ++++++++++----------
 net/bluetooth/l2cap_core.c       | 12 ++++++------
 net/bluetooth/smp.c              | 20 ++++++++++----------
 8 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c4b0650fb9ae..18742f4471ff 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -515,7 +515,7 @@ enum {
 
 /* Link modes */
 #define HCI_LM_ACCEPT	0x8000
-#define HCI_LM_MASTER	0x0001
+#define HCI_LM_CENTRAL	0x0001
 #define HCI_LM_AUTH	0x0002
 #define HCI_LM_ENCRYPT	0x0004
 #define HCI_LM_TRUSTED	0x0008
@@ -573,8 +573,8 @@ enum {
 #define HCI_TX_POWER_INVALID	127
 #define HCI_RSSI_INVALID	127
 
-#define HCI_ROLE_MASTER		0x00
-#define HCI_ROLE_SLAVE		0x01
+#define HCI_ROLE_CENTRAL	0x00
+#define HCI_ROLE_PERIPHERAL	0x01
 
 /* Extended Inquiry Response field types */
 #define EIR_FLAGS		0x01 /* flags */
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 43b08bebae74..368e16fdf441 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -893,7 +893,7 @@ static inline void hci_conn_hash_add(struct hci_dev *hdev, struct hci_conn *c)
 		break;
 	case LE_LINK:
 		h->le_num++;
-		if (c->role == HCI_ROLE_SLAVE)
+		if (c->role == HCI_ROLE_PERIPHERAL)
 			h->le_num_slave++;
 		break;
 	case SCO_LINK:
@@ -919,7 +919,7 @@ static inline void hci_conn_hash_del(struct hci_dev *hdev, struct hci_conn *c)
 		break;
 	case LE_LINK:
 		h->le_num--;
-		if (c->role == HCI_ROLE_SLAVE)
+		if (c->role == HCI_ROLE_PERIPHERAL)
 			h->le_num_slave--;
 		break;
 	case SCO_LINK:
diff --git a/net/bluetooth/amp.c b/net/bluetooth/amp.c
index be2d469d6369..fe0083c94019 100644
--- a/net/bluetooth/amp.c
+++ b/net/bluetooth/amp.c
@@ -107,7 +107,7 @@ struct hci_conn *phylink_add(struct hci_dev *hdev, struct amp_mgr *mgr,
 {
 	bdaddr_t *dst = &mgr->l2cap_conn->hcon->dst;
 	struct hci_conn *hcon;
-	u8 role = out ? HCI_ROLE_MASTER : HCI_ROLE_SLAVE;
+	u8 role = out ? HCI_ROLE_CENTRAL : HCI_ROLE_PERIPHERAL;
 
 	hcon = hci_conn_add(hdev, AMP_LINK, dst, role);
 	if (!hcon)
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 88ec08978ff4..703470b6b924 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -222,7 +222,7 @@ static void hci_acl_create_connection(struct hci_conn *conn)
 
 	conn->state = BT_CONNECT;
 	conn->out = true;
-	conn->role = HCI_ROLE_MASTER;
+	conn->role = HCI_ROLE_CENTRAL;
 
 	conn->attempt++;
 
@@ -245,7 +245,7 @@ static void hci_acl_create_connection(struct hci_conn *conn)
 	}
 
 	cp.pkt_type = cpu_to_le16(conn->pkt_type);
-	if (lmp_rswitch_capable(hdev) && !(hdev->link_mode & HCI_LM_MASTER))
+	if (lmp_rswitch_capable(hdev) && !(hdev->link_mode & HCI_LM_CENTRAL))
 		cp.role_switch = 0x01;
 	else
 		cp.role_switch = 0x00;
@@ -257,12 +257,12 @@ int hci_disconnect(struct hci_conn *conn, __u8 reason)
 {
 	BT_DBG("hcon %p", conn);
 
-	/* When we are master of an established connection and it enters
+	/* When we are central of an established connection and it enters
 	 * the disconnect timeout, then go ahead and try to read the
 	 * current clock offset.  Processing of the result is done
 	 * within the event handling and hci_clock_offset_evt function.
 	 */
-	if (conn->type == ACL_LINK && conn->role == HCI_ROLE_MASTER &&
+	if (conn->type == ACL_LINK && conn->role == HCI_ROLE_CENTRAL &&
 	    (conn->state == BT_CONNECTED || conn->state == BT_CONFIG)) {
 		struct hci_dev *hdev = conn->hdev;
 		struct hci_cp_read_clock_offset clkoff_cp;
@@ -538,7 +538,7 @@ static void le_conn_timeout(struct work_struct *work)
 	 * happen with broken hardware or if low duty cycle was used
 	 * (which doesn't have a timeout of its own).
 	 */
-	if (conn->role == HCI_ROLE_SLAVE) {
+	if (conn->role == HCI_ROLE_PERIPHERAL) {
 		/* Disable LE Advertising */
 		le_disable_advertising(hdev);
 		hci_le_conn_failed(conn, HCI_ERROR_ADVERTISING_TIMEOUT);
@@ -580,7 +580,7 @@ struct hci_conn *hci_conn_add(struct hci_dev *hdev, int type, bdaddr_t *dst,
 	/* Set Default Authenticated payload timeout to 30s */
 	conn->auth_payload_timeout = DEFAULT_AUTH_PAYLOAD_TIMEOUT;
 
-	if (conn->role == HCI_ROLE_MASTER)
+	if (conn->role == HCI_ROLE_CENTRAL)
 		conn->out = true;
 
 	switch (type) {
@@ -1109,9 +1109,9 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 
 	hci_req_init(&req, hdev);
 
-	/* Disable advertising if we're active. For master role
+	/* Disable advertising if we're active. For central role
 	 * connections most controllers will refuse to connect if
-	 * advertising is enabled, and for slave role connections we
+	 * advertising is enabled, and for peripheral role connections we
 	 * anyway have to disable it in order to start directed
 	 * advertising. Any registered advertisements will be
 	 * re-enabled after the connection attempt is finished.
@@ -1119,8 +1119,8 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
 		__hci_req_pause_adv_instances(&req);
 
-	/* If requested to connect as slave use directed advertising */
-	if (conn->role == HCI_ROLE_SLAVE) {
+	/* If requested to connect as peripheral use directed advertising */
+	if (conn->role == HCI_ROLE_PERIPHERAL) {
 		/* If we're active scanning most controllers are unable
 		 * to initiate advertising. Simply reject the attempt.
 		 */
@@ -1261,7 +1261,7 @@ struct hci_conn *hci_connect_le_scan(struct hci_dev *hdev, bdaddr_t *dst,
 
 	BT_DBG("requesting refresh of dst_addr");
 
-	conn = hci_conn_add(hdev, LE_LINK, dst, HCI_ROLE_MASTER);
+	conn = hci_conn_add(hdev, LE_LINK, dst, HCI_ROLE_CENTRAL);
 	if (!conn)
 		return ERR_PTR(-ENOMEM);
 
@@ -1300,7 +1300,7 @@ struct hci_conn *hci_connect_acl(struct hci_dev *hdev, bdaddr_t *dst,
 
 	acl = hci_conn_hash_lookup_ba(hdev, ACL_LINK, dst);
 	if (!acl) {
-		acl = hci_conn_add(hdev, ACL_LINK, dst, HCI_ROLE_MASTER);
+		acl = hci_conn_add(hdev, ACL_LINK, dst, HCI_ROLE_CENTRAL);
 		if (!acl)
 			return ERR_PTR(-ENOMEM);
 	}
@@ -1331,7 +1331,7 @@ struct hci_conn *hci_connect_sco(struct hci_dev *hdev, int type, bdaddr_t *dst,
 
 	sco = hci_conn_hash_lookup_ba(hdev, type, dst);
 	if (!sco) {
-		sco = hci_conn_add(hdev, type, dst, HCI_ROLE_MASTER);
+		sco = hci_conn_add(hdev, type, dst, HCI_ROLE_CENTRAL);
 		if (!sco) {
 			hci_conn_drop(acl);
 			return ERR_PTR(-ENOMEM);
@@ -1630,8 +1630,8 @@ static u32 get_link_mode(struct hci_conn *conn)
 {
 	u32 link_mode = 0;
 
-	if (conn->role == HCI_ROLE_MASTER)
-		link_mode |= HCI_LM_MASTER;
+	if (conn->role == HCI_ROLE_CENTRAL)
+		link_mode |= HCI_LM_CENTRAL;
 
 	if (test_bit(HCI_CONN_ENCRYPT, &conn->flags))
 		link_mode |= HCI_LM_ENCRYPT;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 6eedf334f943..4ac6022f7085 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -2069,7 +2069,7 @@ int hci_dev_cmd(unsigned int cmd, void __user *arg)
 
 	case HCISETLINKMODE:
 		hdev->link_mode = ((__u16) dr.dev_opt) &
-					(HCI_LM_MASTER | HCI_LM_ACCEPT);
+					(HCI_LM_CENTRAL | HCI_LM_ACCEPT);
 		break;
 
 	case HCISETPTYPE:
@@ -2465,9 +2465,9 @@ static bool hci_persistent_key(struct hci_dev *hdev, struct hci_conn *conn,
 static u8 ltk_role(u8 type)
 {
 	if (type == SMP_LTK)
-		return HCI_ROLE_MASTER;
+		return HCI_ROLE_CENTRAL;
 
-	return HCI_ROLE_SLAVE;
+	return HCI_ROLE_PERIPHERAL;
 }
 
 struct smp_ltk *hci_find_ltk(struct hci_dev *hdev, bdaddr_t *bdaddr,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index cde6a43cc61d..e5f3840abd1a 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -1900,7 +1900,7 @@ static void hci_cs_create_conn(struct hci_dev *hdev, __u8 status)
 	} else {
 		if (!conn) {
 			conn = hci_conn_add(hdev, ACL_LINK, &cp->bdaddr,
-					    HCI_ROLE_MASTER);
+					    HCI_ROLE_CENTRAL);
 			if (!conn)
 				bt_dev_err(hdev, "no memory for new connection");
 		}
@@ -2627,7 +2627,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 						      &ev->bdaddr,
 						      BDADDR_BREDR)) {
 			conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
-					    HCI_ROLE_SLAVE);
+					    HCI_ROLE_PERIPHERAL);
 			if (!conn) {
 				bt_dev_err(hdev, "no memory for new conn");
 				goto unlock;
@@ -2775,7 +2775,7 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 			&ev->bdaddr);
 	if (!conn) {
 		conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
-				    HCI_ROLE_SLAVE);
+				    HCI_ROLE_PERIPHERAL);
 		if (!conn) {
 			bt_dev_err(hdev, "no memory for new connection");
 			hci_dev_unlock(hdev);
@@ -2794,10 +2794,10 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 
 		bacpy(&cp.bdaddr, &ev->bdaddr);
 
-		if (lmp_rswitch_capable(hdev) && (mask & HCI_LM_MASTER))
-			cp.role = 0x00; /* Become master */
+		if (lmp_rswitch_capable(hdev) && (mask & HCI_LM_CENTRAL))
+			cp.role = 0x00; /* Become central */
 		else
-			cp.role = 0x01; /* Remain slave */
+			cp.role = 0x01; /* Remain peripheral */
 
 		hci_send_cmd(hdev, HCI_OP_ACCEPT_CONN_REQ, sizeof(cp), &cp);
 	} else if (!(flags & HCI_PROTO_DEFER)) {
@@ -5131,7 +5131,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 		conn->dst_type = bdaddr_type;
 
 		/* If we didn't have a hci_conn object previously
-		 * but we're in master role this must be something
+		 * but we're in central role this must be something
 		 * initiated using a white list. Since white list based
 		 * connections are not "first class citizens" we don't
 		 * have full tracking of them. Therefore, we go ahead
@@ -5423,8 +5423,8 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 	}
 
 	conn = hci_connect_le(hdev, addr, addr_type, BT_SECURITY_LOW,
-			      hdev->def_le_autoconnect_timeout, HCI_ROLE_MASTER,
-			      direct_rpa);
+			      hdev->def_le_autoconnect_timeout,
+			      HCI_ROLE_CENTRAL, direct_rpa);
 	if (!IS_ERR(conn)) {
 		/* If HCI_AUTO_CONN_EXPLICIT is set, conn is already owned
 		 * by higher layer that tried to connect, if no then
@@ -5897,7 +5897,7 @@ static void hci_le_remote_conn_param_req_evt(struct hci_dev *hdev,
 		return send_conn_param_neg_reply(hdev, handle,
 						 HCI_ERROR_INVALID_LL_PARAMS);
 
-	if (hcon->role == HCI_ROLE_MASTER) {
+	if (hcon->role == HCI_ROLE_CENTRAL) {
 		struct hci_conn_params *params;
 		u8 store_hint;
 
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9ebb85df4db4..c10a45368ec2 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1691,12 +1691,12 @@ static void l2cap_le_conn_ready(struct l2cap_conn *conn)
 	if (hcon->out)
 		smp_conn_security(hcon, hcon->pending_sec_level);
 
-	/* For LE slave connections, make sure the connection interval
+	/* For LE peripheral connections, make sure the connection interval
 	 * is in the range of the minimum and maximum interval that has
 	 * been configured for this connection. If not, then trigger
 	 * the connection update procedure.
 	 */
-	if (hcon->role == HCI_ROLE_SLAVE &&
+	if (hcon->role == HCI_ROLE_PERIPHERAL &&
 	    (hcon->le_conn_interval < hcon->le_conn_min_interval ||
 	     hcon->le_conn_interval > hcon->le_conn_max_interval)) {
 		struct l2cap_conn_param_update_req req;
@@ -5537,7 +5537,7 @@ static inline int l2cap_conn_param_update_req(struct l2cap_conn *conn,
 	u16 min, max, latency, to_multiplier;
 	int err;
 
-	if (hcon->role != HCI_ROLE_MASTER)
+	if (hcon->role != HCI_ROLE_CENTRAL)
 		return -EINVAL;
 
 	if (cmd_len != sizeof(struct l2cap_conn_param_update_req))
@@ -7905,7 +7905,7 @@ int l2cap_chan_connect(struct l2cap_chan *chan, __le16 psm, u16 cid,
 			hcon = hci_connect_le(hdev, dst, dst_type,
 					      chan->sec_level,
 					      HCI_LE_CONN_TIMEOUT,
-					      HCI_ROLE_SLAVE, NULL);
+					      HCI_ROLE_PERIPHERAL, NULL);
 		else
 			hcon = hci_connect_le_scan(hdev, dst, dst_type,
 						   chan->sec_level,
@@ -8046,12 +8046,12 @@ int l2cap_connect_ind(struct hci_dev *hdev, bdaddr_t *bdaddr)
 		if (!bacmp(&c->src, &hdev->bdaddr)) {
 			lm1 |= HCI_LM_ACCEPT;
 			if (test_bit(FLAG_ROLE_SWITCH, &c->flags))
-				lm1 |= HCI_LM_MASTER;
+				lm1 |= HCI_LM_CENTRAL;
 			exact++;
 		} else if (!bacmp(&c->src, BDADDR_ANY)) {
 			lm2 |= HCI_LM_ACCEPT;
 			if (test_bit(FLAG_ROLE_SWITCH, &c->flags))
-				lm2 |= HCI_LM_MASTER;
+				lm2 |= HCI_LM_CENTRAL;
 		}
 	}
 	read_unlock(&chan_list_lock);
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 372e3b25aaa4..54242711aa67 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -909,11 +909,11 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 			hcon->pending_sec_level = BT_SECURITY_HIGH;
 	}
 
-	/* If both devices have Keyoard-Display I/O, the master
-	 * Confirms and the slave Enters the passkey.
+	/* If both devices have Keyboard-Display I/O, the central
+	 * Confirms and the peripheral Enters the passkey.
 	 */
 	if (smp->method == OVERLAP) {
-		if (hcon->role == HCI_ROLE_MASTER)
+		if (hcon->role == HCI_ROLE_CENTRAL)
 			smp->method = CFM_PASSKEY;
 		else
 			smp->method = REQ_PASSKEY;
@@ -1741,7 +1741,7 @@ static u8 smp_cmd_pairing_req(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (skb->len < sizeof(*req))
 		return SMP_INVALID_PARAMS;
 
-	if (conn->hcon->role != HCI_ROLE_SLAVE)
+	if (conn->hcon->role != HCI_ROLE_PERIPHERAL)
 		return SMP_CMD_NOTSUPP;
 
 	if (!chan->data)
@@ -1932,7 +1932,7 @@ static u8 smp_cmd_pairing_rsp(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (skb->len < sizeof(*rsp))
 		return SMP_INVALID_PARAMS;
 
-	if (conn->hcon->role != HCI_ROLE_MASTER)
+	if (conn->hcon->role != HCI_ROLE_CENTRAL)
 		return SMP_CMD_NOTSUPP;
 
 	skb_pull(skb, sizeof(*rsp));
@@ -2294,7 +2294,7 @@ static u8 smp_cmd_security_req(struct l2cap_conn *conn, struct sk_buff *skb)
 	if (skb->len < sizeof(*rp))
 		return SMP_INVALID_PARAMS;
 
-	if (hcon->role != HCI_ROLE_MASTER)
+	if (hcon->role != HCI_ROLE_CENTRAL)
 		return SMP_CMD_NOTSUPP;
 
 	auth = rp->auth_req & AUTH_REQ_MASK(hdev);
@@ -2368,7 +2368,7 @@ int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
 	if (sec_level > hcon->pending_sec_level)
 		hcon->pending_sec_level = sec_level;
 
-	if (hcon->role == HCI_ROLE_MASTER)
+	if (hcon->role == HCI_ROLE_CENTRAL)
 		if (smp_ltk_encrypt(conn, hcon->pending_sec_level))
 			return 0;
 
@@ -2412,7 +2412,7 @@ int smp_conn_security(struct hci_conn *hcon, __u8 sec_level)
 			authreq |= SMP_AUTH_MITM;
 	}
 
-	if (hcon->role == HCI_ROLE_MASTER) {
+	if (hcon->role == HCI_ROLE_CENTRAL) {
 		struct smp_cmd_pairing cp;
 
 		build_pairing_cmd(conn, &cp, NULL, authreq);
@@ -3081,8 +3081,8 @@ static void bredr_pairing(struct l2cap_chan *chan)
 	if (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags))
 		return;
 
-	/* Only master may initiate SMP over BR/EDR */
-	if (hcon->role != HCI_ROLE_MASTER)
+	/* Only central may initiate SMP over BR/EDR */
+	if (hcon->role != HCI_ROLE_CENTRAL)
 		return;
 
 	/* Secure Connections support must be enabled */
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

