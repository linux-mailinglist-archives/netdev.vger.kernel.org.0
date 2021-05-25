Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A47038FF48
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhEYKeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232184AbhEYKcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:32:48 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65954C061379
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:34 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id u3-20020a05622a0103b02902274c59d552so8216413qtw.23
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PQtQPKWyFGBrCDjBi34DtRKxVXDFjTBSMso9FyrF2MU=;
        b=lCT4Fyx+/nvGlmoSRvzNZYTHCCH9aZb1SdJVf3C3asTVaOJOho4owBY+FdU/FVKAI6
         7Xhv4SALJYz6xoQQAkBHTGvoyNOAAgeMB0hYAJmFLry86fSa3kXnIaLET9hvFreYV2s8
         jwp4Opd4xg1DlodiL5tanfJuBx/O6x2k2d0DnrG6LkMX42j4k+5E+pu2hB4GirSi68XA
         gp470r947dncTCPZ8E4LYesr6mKcdiuTyVtPSp8NVRpkYr/hLq1QtVMCYrIoAm9LAwjM
         rxqKX64JUm3zZ8hWb8hYDehuCDsB642pKFJRlDOC9+u0TbqtabQlQ8ZQzWkwn0Zg9pgv
         J9bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PQtQPKWyFGBrCDjBi34DtRKxVXDFjTBSMso9FyrF2MU=;
        b=cozmosLUdXSN5yHBed7P5kofXoLJRao5mvJf25nmYl22yOVXk2VBpNZwEsDB+p05jp
         Uy3tsMMPA54bSPlQMN6mkMS9UngQ+VL5GjyIAawrYZNKbC3vP+Ey7FoKCuJb9zSzO6vJ
         ZCF6xxqhUkPOtXJ/6kqr50/cl+JB20r/fM8ysvPmplqfPUe1+Ct+yz3WlpoQGUaWZ4xf
         L3myMXYrGSrVAeXAe8vW+4rWo60Jc+H+UhgapdURNH8CJVMPCo4xVwlqG2Y5j7MOcq+V
         +38+lUaIQW87L/Bp9CEk4oFzNqbP6xdYQDIuu7cfukOpLGgm6W1KV+gy0u1ui4Mg0m71
         40rA==
X-Gm-Message-State: AOAM532mLI9jRTfpaUxgLJU0jhmGG8oseFcLIkwcR7A/vdBXKtGJyb0c
        Adbul6LSy1xAfPSNI/XiZnGpjETHwJPz
X-Google-Smtp-Source: ABdhPJxjiy0n+Ko8FPiLoGeodFq4wercp2knVG9FnIjFrd69wwOWCDIxNuDOphKKvrSX757DnCVa+MJ0+zvZ
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:8806:6b98:8ae6:8824])
 (user=apusaka job=sendgmr) by 2002:a0c:e20f:: with SMTP id
 q15mr36365422qvl.56.1621938633537; Tue, 25 May 2021 03:30:33 -0700 (PDT)
Date:   Tue, 25 May 2021 18:29:40 +0800
In-Reply-To: <20210525102941.3958649-1-apusaka@google.com>
Message-Id: <20210525182900.11.I7b0b296a8a540cb6bd218686295bed170bcae7ee@changeid>
Mime-Version: 1.0
References: <20210525102941.3958649-1-apusaka@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 11/12] Bluetooth: use inclusive language when filtering
 devices in
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

Use "accept list".

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

 include/net/bluetooth/hci.h      | 16 +++---
 include/net/bluetooth/hci_core.h |  6 +--
 net/bluetooth/hci_core.c         | 20 +++----
 net/bluetooth/hci_debugfs.c      |  6 +--
 net/bluetooth/hci_event.c        | 64 +++++++++++------------
 net/bluetooth/hci_request.c      | 89 ++++++++++++++++----------------
 net/bluetooth/mgmt.c             | 20 +++----
 7 files changed, 112 insertions(+), 109 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 441125f6b616..e6801ed7ad6e 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1505,7 +1505,7 @@ struct hci_cp_le_set_scan_enable {
 } __packed;
 
 #define HCI_LE_USE_PEER_ADDR		0x00
-#define HCI_LE_USE_WHITELIST		0x01
+#define HCI_LE_USE_ACCEPT_LIST		0x01
 
 #define HCI_OP_LE_CREATE_CONN		0x200d
 struct hci_cp_le_create_conn {
@@ -1525,22 +1525,22 @@ struct hci_cp_le_create_conn {
 
 #define HCI_OP_LE_CREATE_CONN_CANCEL	0x200e
 
-#define HCI_OP_LE_READ_WHITE_LIST_SIZE	0x200f
-struct hci_rp_le_read_white_list_size {
+#define HCI_OP_LE_READ_ACCEPT_LIST_SIZE	0x200f
+struct hci_rp_le_read_accept_list_size {
 	__u8	status;
 	__u8	size;
 } __packed;
 
-#define HCI_OP_LE_CLEAR_WHITE_LIST	0x2010
+#define HCI_OP_LE_CLEAR_ACCEPT_LIST	0x2010
 
-#define HCI_OP_LE_ADD_TO_WHITE_LIST	0x2011
-struct hci_cp_le_add_to_white_list {
+#define HCI_OP_LE_ADD_TO_ACCEPT_LIST	0x2011
+struct hci_cp_le_add_to_accept_list {
 	__u8     bdaddr_type;
 	bdaddr_t bdaddr;
 } __packed;
 
-#define HCI_OP_LE_DEL_FROM_WHITE_LIST	0x2012
-struct hci_cp_le_del_from_white_list {
+#define HCI_OP_LE_DEL_FROM_ACCEPT_LIST	0x2012
+struct hci_cp_le_del_from_accept_list {
 	__u8     bdaddr_type;
 	bdaddr_t bdaddr;
 } __packed;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 9c8cdc4fe3c5..163caeac46a5 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -327,7 +327,7 @@ struct hci_dev {
 	__u8		max_page;
 	__u8		features[HCI_MAX_PAGES][8];
 	__u8		le_features[8];
-	__u8		le_white_list_size;
+	__u8		le_accept_list_size;
 	__u8		le_resolv_list_size;
 	__u8		le_num_of_adv_sets;
 	__u8		le_states[8];
@@ -523,13 +523,13 @@ struct hci_dev {
 
 	struct list_head	mgmt_pending;
 	struct list_head	reject_list;
-	struct list_head	whitelist;
+	struct list_head	accept_list;
 	struct list_head	uuids;
 	struct list_head	link_keys;
 	struct list_head	long_term_keys;
 	struct list_head	identity_resolving_keys;
 	struct list_head	remote_oob_data;
-	struct list_head	le_white_list;
+	struct list_head	le_accept_list;
 	struct list_head	le_resolv_list;
 	struct list_head	le_conn_params;
 	struct list_head	pend_le_conns;
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 932df458bc80..8cf1c0068d11 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -749,14 +749,14 @@ static int hci_init3_req(struct hci_request *req, unsigned long opt)
 		}
 
 		if (hdev->commands[26] & 0x40) {
-			/* Read LE White List Size */
-			hci_req_add(req, HCI_OP_LE_READ_WHITE_LIST_SIZE,
+			/* Read LE Accept List Size */
+			hci_req_add(req, HCI_OP_LE_READ_ACCEPT_LIST_SIZE,
 				    0, NULL);
 		}
 
 		if (hdev->commands[26] & 0x80) {
-			/* Clear LE White List */
-			hci_req_add(req, HCI_OP_LE_CLEAR_WHITE_LIST, 0, NULL);
+			/* Clear LE Accept List */
+			hci_req_add(req, HCI_OP_LE_CLEAR_ACCEPT_LIST, 0, NULL);
 		}
 
 		if (hdev->commands[34] & 0x40) {
@@ -3708,13 +3708,13 @@ static int hci_suspend_notifier(struct notifier_block *nb, unsigned long action,
 		/* Suspend consists of two actions:
 		 *  - First, disconnect everything and make the controller not
 		 *    connectable (disabling scanning)
-		 *  - Second, program event filter/whitelist and enable scan
+		 *  - Second, program event filter/accept list and enable scan
 		 */
 		ret = hci_change_suspend_state(hdev, BT_SUSPEND_DISCONNECT);
 		if (!ret)
 			state = BT_SUSPEND_DISCONNECT;
 
-		/* Only configure whitelist if disconnect succeeded and wake
+		/* Only configure accept list if disconnect succeeded and wake
 		 * isn't being prevented.
 		 */
 		if (!ret && !(hdev->prevent_wake && hdev->prevent_wake(hdev))) {
@@ -3823,13 +3823,13 @@ struct hci_dev *hci_alloc_dev(void)
 
 	INIT_LIST_HEAD(&hdev->mgmt_pending);
 	INIT_LIST_HEAD(&hdev->reject_list);
-	INIT_LIST_HEAD(&hdev->whitelist);
+	INIT_LIST_HEAD(&hdev->accept_list);
 	INIT_LIST_HEAD(&hdev->uuids);
 	INIT_LIST_HEAD(&hdev->link_keys);
 	INIT_LIST_HEAD(&hdev->long_term_keys);
 	INIT_LIST_HEAD(&hdev->identity_resolving_keys);
 	INIT_LIST_HEAD(&hdev->remote_oob_data);
-	INIT_LIST_HEAD(&hdev->le_white_list);
+	INIT_LIST_HEAD(&hdev->le_accept_list);
 	INIT_LIST_HEAD(&hdev->le_resolv_list);
 	INIT_LIST_HEAD(&hdev->le_conn_params);
 	INIT_LIST_HEAD(&hdev->pend_le_conns);
@@ -4043,7 +4043,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 
 	hci_dev_lock(hdev);
 	hci_bdaddr_list_clear(&hdev->reject_list);
-	hci_bdaddr_list_clear(&hdev->whitelist);
+	hci_bdaddr_list_clear(&hdev->accept_list);
 	hci_uuids_clear(hdev);
 	hci_link_keys_clear(hdev);
 	hci_smp_ltks_clear(hdev);
@@ -4051,7 +4051,7 @@ void hci_unregister_dev(struct hci_dev *hdev)
 	hci_remote_oob_data_clear(hdev);
 	hci_adv_instances_clear(hdev);
 	hci_adv_monitors_clear(hdev);
-	hci_bdaddr_list_clear(&hdev->le_white_list);
+	hci_bdaddr_list_clear(&hdev->le_accept_list);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
 	hci_conn_params_clear_all(hdev);
 	hci_discovery_filter_clear(hdev);
diff --git a/net/bluetooth/hci_debugfs.c b/net/bluetooth/hci_debugfs.c
index f5c423f44076..993ec233c412 100644
--- a/net/bluetooth/hci_debugfs.c
+++ b/net/bluetooth/hci_debugfs.c
@@ -125,7 +125,7 @@ static int device_list_show(struct seq_file *f, void *ptr)
 	struct bdaddr_list *b;
 
 	hci_dev_lock(hdev);
-	list_for_each_entry(b, &hdev->whitelist, list)
+	list_for_each_entry(b, &hdev->accept_list, list)
 		seq_printf(f, "%pMR (type %u)\n", &b->bdaddr, b->bdaddr_type);
 	list_for_each_entry(p, &hdev->le_conn_params, list) {
 		seq_printf(f, "%pMR (type %u) %u\n", &p->addr, p->addr_type,
@@ -784,7 +784,7 @@ static int accept_list_show(struct seq_file *f, void *ptr)
 	struct bdaddr_list *b;
 
 	hci_dev_lock(hdev);
-	list_for_each_entry(b, &hdev->le_white_list, list)
+	list_for_each_entry(b, &hdev->le_accept_list, list)
 		seq_printf(f, "%pMR (type %u)\n", &b->bdaddr, b->bdaddr_type);
 	hci_dev_unlock(hdev);
 
@@ -1195,7 +1195,7 @@ void hci_debugfs_create_le(struct hci_dev *hdev)
 				    &force_static_address_fops);
 
 	debugfs_create_u8("white_list_size", 0444, hdev->debugfs,
-			  &hdev->le_white_list_size);
+			  &hdev->le_accept_list_size);
 	debugfs_create_file("white_list", 0444, hdev->debugfs, hdev,
 			    &accept_list_fops);
 	debugfs_create_u8("resolv_list_size", 0444, hdev->debugfs,
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index c41fef24166f..760e8e14e0f2 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -236,7 +236,7 @@ static void hci_cc_reset(struct hci_dev *hdev, struct sk_buff *skb)
 
 	hdev->ssp_debug_mode = 0;
 
-	hci_bdaddr_list_clear(&hdev->le_white_list);
+	hci_bdaddr_list_clear(&hdev->le_accept_list);
 	hci_bdaddr_list_clear(&hdev->le_resolv_list);
 }
 
@@ -1492,21 +1492,21 @@ static void hci_cc_le_read_num_adv_sets(struct hci_dev *hdev,
 	hdev->le_num_of_adv_sets = rp->num_of_sets;
 }
 
-static void hci_cc_le_read_white_list_size(struct hci_dev *hdev,
-					   struct sk_buff *skb)
+static void hci_cc_le_read_accept_list_size(struct hci_dev *hdev,
+					    struct sk_buff *skb)
 {
-	struct hci_rp_le_read_white_list_size *rp = (void *) skb->data;
+	struct hci_rp_le_read_accept_list_size *rp = (void *)skb->data;
 
 	BT_DBG("%s status 0x%2.2x size %u", hdev->name, rp->status, rp->size);
 
 	if (rp->status)
 		return;
 
-	hdev->le_white_list_size = rp->size;
+	hdev->le_accept_list_size = rp->size;
 }
 
-static void hci_cc_le_clear_white_list(struct hci_dev *hdev,
-				       struct sk_buff *skb)
+static void hci_cc_le_clear_accept_list(struct hci_dev *hdev,
+					struct sk_buff *skb)
 {
 	__u8 status = *((__u8 *) skb->data);
 
@@ -1515,13 +1515,13 @@ static void hci_cc_le_clear_white_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
-	hci_bdaddr_list_clear(&hdev->le_white_list);
+	hci_bdaddr_list_clear(&hdev->le_accept_list);
 }
 
-static void hci_cc_le_add_to_white_list(struct hci_dev *hdev,
-					struct sk_buff *skb)
+static void hci_cc_le_add_to_accept_list(struct hci_dev *hdev,
+					 struct sk_buff *skb)
 {
-	struct hci_cp_le_add_to_white_list *sent;
+	struct hci_cp_le_add_to_accept_list *sent;
 	__u8 status = *((__u8 *) skb->data);
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, status);
@@ -1529,18 +1529,18 @@ static void hci_cc_le_add_to_white_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
-	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_ADD_TO_WHITE_LIST);
+	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_ADD_TO_ACCEPT_LIST);
 	if (!sent)
 		return;
 
-	hci_bdaddr_list_add(&hdev->le_white_list, &sent->bdaddr,
-			   sent->bdaddr_type);
+	hci_bdaddr_list_add(&hdev->le_accept_list, &sent->bdaddr,
+			    sent->bdaddr_type);
 }
 
-static void hci_cc_le_del_from_white_list(struct hci_dev *hdev,
-					  struct sk_buff *skb)
+static void hci_cc_le_del_from_accept_list(struct hci_dev *hdev,
+					   struct sk_buff *skb)
 {
-	struct hci_cp_le_del_from_white_list *sent;
+	struct hci_cp_le_del_from_accept_list *sent;
 	__u8 status = *((__u8 *) skb->data);
 
 	BT_DBG("%s status 0x%2.2x", hdev->name, status);
@@ -1548,11 +1548,11 @@ static void hci_cc_le_del_from_white_list(struct hci_dev *hdev,
 	if (status)
 		return;
 
-	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_DEL_FROM_WHITE_LIST);
+	sent = hci_sent_cmd_data(hdev, HCI_OP_LE_DEL_FROM_ACCEPT_LIST);
 	if (!sent)
 		return;
 
-	hci_bdaddr_list_del(&hdev->le_white_list, &sent->bdaddr,
+	hci_bdaddr_list_del(&hdev->le_accept_list, &sent->bdaddr,
 			    sent->bdaddr_type);
 }
 
@@ -2367,7 +2367,7 @@ static void cs_le_create_conn(struct hci_dev *hdev, bdaddr_t *peer_addr,
 	/* We don't want the connection attempt to stick around
 	 * indefinitely since LE doesn't have a page timeout concept
 	 * like BR/EDR. Set a timer for any connection that doesn't use
-	 * the white list for connecting.
+	 * the accept list for connecting.
 	 */
 	if (filter_policy == HCI_LE_USE_PEER_ADDR)
 		queue_delayed_work(conn->hdev->workqueue,
@@ -2623,7 +2623,7 @@ static void hci_conn_complete_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		 * only used during suspend.
 		 */
 		if (ev->link_type == ACL_LINK &&
-		    hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
+		    hci_bdaddr_list_lookup_with_flags(&hdev->accept_list,
 						      &ev->bdaddr,
 						      BDADDR_BREDR)) {
 			conn = hci_conn_add(hdev, ev->link_type, &ev->bdaddr,
@@ -2751,13 +2751,13 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		return;
 	}
 
-	/* Require HCI_CONNECTABLE or a whitelist entry to accept the
+	/* Require HCI_CONNECTABLE or an accept list entry to accept the
 	 * connection. These features are only touched through mgmt so
 	 * only do the checks if HCI_MGMT is set.
 	 */
 	if (hci_dev_test_flag(hdev, HCI_MGMT) &&
 	    !hci_dev_test_flag(hdev, HCI_CONNECTABLE) &&
-	    !hci_bdaddr_list_lookup_with_flags(&hdev->whitelist, &ev->bdaddr,
+	    !hci_bdaddr_list_lookup_with_flags(&hdev->accept_list, &ev->bdaddr,
 					       BDADDR_BREDR)) {
 		hci_reject_conn(hdev, &ev->bdaddr);
 		return;
@@ -3538,20 +3538,20 @@ static void hci_cmd_complete_evt(struct hci_dev *hdev, struct sk_buff *skb,
 		hci_cc_le_set_scan_enable(hdev, skb);
 		break;
 
-	case HCI_OP_LE_READ_WHITE_LIST_SIZE:
-		hci_cc_le_read_white_list_size(hdev, skb);
+	case HCI_OP_LE_READ_ACCEPT_LIST_SIZE:
+		hci_cc_le_read_accept_list_size(hdev, skb);
 		break;
 
-	case HCI_OP_LE_CLEAR_WHITE_LIST:
-		hci_cc_le_clear_white_list(hdev, skb);
+	case HCI_OP_LE_CLEAR_ACCEPT_LIST:
+		hci_cc_le_clear_accept_list(hdev, skb);
 		break;
 
-	case HCI_OP_LE_ADD_TO_WHITE_LIST:
-		hci_cc_le_add_to_white_list(hdev, skb);
+	case HCI_OP_LE_ADD_TO_ACCEPT_LIST:
+		hci_cc_le_add_to_accept_list(hdev, skb);
 		break;
 
-	case HCI_OP_LE_DEL_FROM_WHITE_LIST:
-		hci_cc_le_del_from_white_list(hdev, skb);
+	case HCI_OP_LE_DEL_FROM_ACCEPT_LIST:
+		hci_cc_le_del_from_accept_list(hdev, skb);
 		break;
 
 	case HCI_OP_LE_READ_SUPPORTED_STATES:
@@ -5132,7 +5132,7 @@ static void le_conn_complete_evt(struct hci_dev *hdev, u8 status,
 
 		/* If we didn't have a hci_conn object previously
 		 * but we're in central role this must be something
-		 * initiated using a white list. Since white list based
+		 * initiated using an accept list. Since accept list based
 		 * connections are not "first class citizens" we don't
 		 * have full tracking of them. Therefore, we go ahead
 		 * with a "best effort" approach of determining the
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 28a477a7d320..3a16d19296bf 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -745,17 +745,17 @@ void hci_req_add_le_scan_disable(struct hci_request *req, bool rpa_le_conn)
 	}
 }
 
-static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
-				u8 bdaddr_type)
+static void del_from_accept_list(struct hci_request *req, bdaddr_t *bdaddr,
+				 u8 bdaddr_type)
 {
-	struct hci_cp_le_del_from_white_list cp;
+	struct hci_cp_le_del_from_accept_list cp;
 
 	cp.bdaddr_type = bdaddr_type;
 	bacpy(&cp.bdaddr, bdaddr);
 
-	bt_dev_dbg(req->hdev, "Remove %pMR (0x%x) from whitelist", &cp.bdaddr,
+	bt_dev_dbg(req->hdev, "Remove %pMR (0x%x) from accept list", &cp.bdaddr,
 		   cp.bdaddr_type);
-	hci_req_add(req, HCI_OP_LE_DEL_FROM_WHITE_LIST, sizeof(cp), &cp);
+	hci_req_add(req, HCI_OP_LE_DEL_FROM_ACCEPT_LIST, sizeof(cp), &cp);
 
 	if (use_ll_privacy(req->hdev) &&
 	    hci_dev_test_flag(req->hdev, HCI_ENABLE_LL_PRIVACY)) {
@@ -774,31 +774,31 @@ static void del_from_white_list(struct hci_request *req, bdaddr_t *bdaddr,
 	}
 }
 
-/* Adds connection to white list if needed. On error, returns -1. */
-static int add_to_white_list(struct hci_request *req,
-			     struct hci_conn_params *params, u8 *num_entries,
-			     bool allow_rpa)
+/* Adds connection to accept list if needed. On error, returns -1. */
+static int add_to_accept_list(struct hci_request *req,
+			      struct hci_conn_params *params, u8 *num_entries,
+			      bool allow_rpa)
 {
-	struct hci_cp_le_add_to_white_list cp;
+	struct hci_cp_le_add_to_accept_list cp;
 	struct hci_dev *hdev = req->hdev;
 
-	/* Already in white list */
-	if (hci_bdaddr_list_lookup(&hdev->le_white_list, &params->addr,
+	/* Already in accept list */
+	if (hci_bdaddr_list_lookup(&hdev->le_accept_list, &params->addr,
 				   params->addr_type))
 		return 0;
 
 	/* Select filter policy to accept all advertising */
-	if (*num_entries >= hdev->le_white_list_size)
+	if (*num_entries >= hdev->le_accept_list_size)
 		return -1;
 
-	/* White list can not be used with RPAs */
+	/* Accept list can not be used with RPAs */
 	if (!allow_rpa &&
 	    !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY) &&
 	    hci_find_irk_by_addr(hdev, &params->addr, params->addr_type)) {
 		return -1;
 	}
 
-	/* During suspend, only wakeable devices can be in whitelist */
+	/* During suspend, only wakeable devices can be in accept list */
 	if (hdev->suspended && !hci_conn_test_flag(HCI_CONN_FLAG_REMOTE_WAKEUP,
 						   params->current_flags))
 		return 0;
@@ -807,9 +807,9 @@ static int add_to_white_list(struct hci_request *req,
 	cp.bdaddr_type = params->addr_type;
 	bacpy(&cp.bdaddr, &params->addr);
 
-	bt_dev_dbg(hdev, "Add %pMR (0x%x) to whitelist", &cp.bdaddr,
+	bt_dev_dbg(hdev, "Add %pMR (0x%x) to accept list", &cp.bdaddr,
 		   cp.bdaddr_type);
-	hci_req_add(req, HCI_OP_LE_ADD_TO_WHITE_LIST, sizeof(cp), &cp);
+	hci_req_add(req, HCI_OP_LE_ADD_TO_ACCEPT_LIST, sizeof(cp), &cp);
 
 	if (use_ll_privacy(hdev) &&
 	    hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY)) {
@@ -837,15 +837,15 @@ static int add_to_white_list(struct hci_request *req,
 	return 0;
 }
 
-static u8 update_white_list(struct hci_request *req)
+static u8 update_accept_list(struct hci_request *req)
 {
 	struct hci_dev *hdev = req->hdev;
 	struct hci_conn_params *params;
 	struct bdaddr_list *b;
 	u8 num_entries = 0;
 	bool pend_conn, pend_report;
-	/* We allow whitelisting even with RPAs in suspend. In the worst case,
-	 * we won't be able to wake from devices that use the privacy1.2
+	/* We allow usage of accept list even with RPAs in suspend. In the worst
+	 * case, we won't be able to wake from devices that use the privacy1.2
 	 * features. Additionally, once we support privacy1.2 and IRK
 	 * offloading, we can update this to also check for those conditions.
 	 */
@@ -855,13 +855,13 @@ static u8 update_white_list(struct hci_request *req)
 	    hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY))
 		allow_rpa = true;
 
-	/* Go through the current white list programmed into the
+	/* Go through the current accept list programmed into the
 	 * controller one by one and check if that address is still
 	 * in the list of pending connections or list of devices to
 	 * report. If not present in either list, then queue the
 	 * command to remove it from the controller.
 	 */
-	list_for_each_entry(b, &hdev->le_white_list, list) {
+	list_for_each_entry(b, &hdev->le_accept_list, list) {
 		pend_conn = hci_pend_le_action_lookup(&hdev->pend_le_conns,
 						      &b->bdaddr,
 						      b->bdaddr_type);
@@ -870,14 +870,14 @@ static u8 update_white_list(struct hci_request *req)
 							b->bdaddr_type);
 
 		/* If the device is not likely to connect or report,
-		 * remove it from the whitelist.
+		 * remove it from the accept list.
 		 */
 		if (!pend_conn && !pend_report) {
-			del_from_white_list(req, &b->bdaddr, b->bdaddr_type);
+			del_from_accept_list(req, &b->bdaddr, b->bdaddr_type);
 			continue;
 		}
 
-		/* White list can not be used with RPAs */
+		/* Accept list can not be used with RPAs */
 		if (!allow_rpa &&
 		    !hci_dev_test_flag(hdev, HCI_ENABLE_LL_PRIVACY) &&
 		    hci_find_irk_by_addr(hdev, &b->bdaddr, b->bdaddr_type)) {
@@ -887,27 +887,27 @@ static u8 update_white_list(struct hci_request *req)
 		num_entries++;
 	}
 
-	/* Since all no longer valid white list entries have been
+	/* Since all no longer valid accept list entries have been
 	 * removed, walk through the list of pending connections
 	 * and ensure that any new device gets programmed into
 	 * the controller.
 	 *
 	 * If the list of the devices is larger than the list of
-	 * available white list entries in the controller, then
+	 * available accept list entries in the controller, then
 	 * just abort and return filer policy value to not use the
-	 * white list.
+	 * accept list.
 	 */
 	list_for_each_entry(params, &hdev->pend_le_conns, action) {
-		if (add_to_white_list(req, params, &num_entries, allow_rpa))
+		if (add_to_accept_list(req, params, &num_entries, allow_rpa))
 			return 0x00;
 	}
 
 	/* After adding all new pending connections, walk through
 	 * the list of pending reports and also add these to the
-	 * white list if there is still space. Abort if space runs out.
+	 * accept list if there is still space. Abort if space runs out.
 	 */
 	list_for_each_entry(params, &hdev->pend_le_reports, action) {
-		if (add_to_white_list(req, params, &num_entries, allow_rpa))
+		if (add_to_accept_list(req, params, &num_entries, allow_rpa))
 			return 0x00;
 	}
 
@@ -921,7 +921,7 @@ static u8 update_white_list(struct hci_request *req)
 	    hdev->interleave_scan_state != INTERLEAVE_SCAN_ALLOWLIST)
 		return 0x00;
 
-	/* Select filter policy to use white list */
+	/* Select filter policy to use accept list */
 	return 0x01;
 }
 
@@ -1076,20 +1076,20 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 		return;
 
 	bt_dev_dbg(hdev, "interleave state %d", hdev->interleave_scan_state);
-	/* Adding or removing entries from the white list must
+	/* Adding or removing entries from the accept list must
 	 * happen before enabling scanning. The controller does
-	 * not allow white list modification while scanning.
+	 * not allow accept list modification while scanning.
 	 */
-	filter_policy = update_white_list(req);
+	filter_policy = update_accept_list(req);
 
 	/* When the controller is using random resolvable addresses and
 	 * with that having LE privacy enabled, then controllers with
 	 * Extended Scanner Filter Policies support can now enable support
 	 * for handling directed advertising.
 	 *
-	 * So instead of using filter polices 0x00 (no whitelist)
-	 * and 0x01 (whitelist enabled) use the new filter policies
-	 * 0x02 (no whitelist) and 0x03 (whitelist enabled).
+	 * So instead of using filter polices 0x00 (no accept list)
+	 * and 0x01 (accept list enabled) use the new filter policies
+	 * 0x02 (no accept list) and 0x03 (accept list enabled).
 	 */
 	if (hci_dev_test_flag(hdev, HCI_PRIVACY) &&
 	    (hdev->le_features[0] & HCI_LE_EXT_SCAN_POLICY))
@@ -1111,7 +1111,8 @@ void hci_req_add_le_passive_scan(struct hci_request *req)
 		interval = hdev->le_scan_interval;
 	}
 
-	bt_dev_dbg(hdev, "LE passive scan with whitelist = %d", filter_policy);
+	bt_dev_dbg(hdev, "LE passive scan with accept list = %d",
+		   filter_policy);
 	hci_req_start_scan(req, LE_SCAN_PASSIVE, interval, window,
 			   own_addr_type, filter_policy, addr_resolv);
 }
@@ -1163,7 +1164,7 @@ static void hci_req_set_event_filter(struct hci_request *req)
 	/* Always clear event filter when starting */
 	hci_req_clear_event_filter(req);
 
-	list_for_each_entry(b, &hdev->whitelist, list) {
+	list_for_each_entry(b, &hdev->accept_list, list) {
 		if (!hci_conn_test_flag(HCI_CONN_FLAG_REMOTE_WAKEUP,
 					b->current_flags))
 			continue;
@@ -2606,11 +2607,11 @@ int hci_update_random_address(struct hci_request *req, bool require_privacy,
 	return 0;
 }
 
-static bool disconnected_whitelist_entries(struct hci_dev *hdev)
+static bool disconnected_accept_list_entries(struct hci_dev *hdev)
 {
 	struct bdaddr_list *b;
 
-	list_for_each_entry(b, &hdev->whitelist, list) {
+	list_for_each_entry(b, &hdev->accept_list, list) {
 		struct hci_conn *conn;
 
 		conn = hci_conn_hash_lookup_ba(hdev, ACL_LINK, &b->bdaddr);
@@ -2642,7 +2643,7 @@ void __hci_req_update_scan(struct hci_request *req)
 		return;
 
 	if (hci_dev_test_flag(hdev, HCI_CONNECTABLE) ||
-	    disconnected_whitelist_entries(hdev))
+	    disconnected_accept_list_entries(hdev))
 		scan = SCAN_PAGE;
 	else
 		scan = SCAN_DISABLED;
@@ -3134,7 +3135,7 @@ static int active_scan(struct hci_request *req, unsigned long opt)
 	uint16_t interval = opt;
 	struct hci_dev *hdev = req->hdev;
 	u8 own_addr_type;
-	/* White list is not used for discovery */
+	/* Accept list is not used for discovery */
 	u8 filter_policy = 0x00;
 	/* Discovery doesn't require controller address resolution */
 	bool addr_resolv = false;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b15af55c00d6..b6fa0333ca8c 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4062,9 +4062,10 @@ static int get_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	hci_dev_lock(hdev);
 
 	if (cp->addr.type == BDADDR_BREDR) {
-		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
-							      &cp->addr.bdaddr,
-							      cp->addr.type);
+		br_params =
+			hci_bdaddr_list_lookup_with_flags(&hdev->accept_list,
+							  &cp->addr.bdaddr,
+							  cp->addr.type);
 		if (!br_params)
 			goto done;
 
@@ -4130,9 +4131,10 @@ static int set_device_flags(struct sock *sk, struct hci_dev *hdev, void *data,
 	hci_dev_lock(hdev);
 
 	if (cp->addr.type == BDADDR_BREDR) {
-		br_params = hci_bdaddr_list_lookup_with_flags(&hdev->whitelist,
-							      &cp->addr.bdaddr,
-							      cp->addr.type);
+		br_params =
+			hci_bdaddr_list_lookup_with_flags(&hdev->accept_list,
+							  &cp->addr.bdaddr,
+							  cp->addr.type);
 
 		if (br_params) {
 			br_params->current_flags = current_flags;
@@ -6734,7 +6736,7 @@ static int add_device(struct sock *sk, struct hci_dev *hdev,
 			goto unlock;
 		}
 
-		err = hci_bdaddr_list_add_with_flags(&hdev->whitelist,
+		err = hci_bdaddr_list_add_with_flags(&hdev->accept_list,
 						     &cp->addr.bdaddr,
 						     cp->addr.type, 0);
 		if (err)
@@ -6832,7 +6834,7 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
 		}
 
 		if (cp->addr.type == BDADDR_BREDR) {
-			err = hci_bdaddr_list_del(&hdev->whitelist,
+			err = hci_bdaddr_list_del(&hdev->accept_list,
 						  &cp->addr.bdaddr,
 						  cp->addr.type);
 			if (err) {
@@ -6903,7 +6905,7 @@ static int remove_device(struct sock *sk, struct hci_dev *hdev,
 			goto unlock;
 		}
 
-		list_for_each_entry_safe(b, btmp, &hdev->whitelist, list) {
+		list_for_each_entry_safe(b, btmp, &hdev->accept_list, list) {
 			device_removed(sk, hdev, &b->bdaddr, b->bdaddr_type);
 			list_del(&b->list);
 			kfree(b);
-- 
2.31.1.818.g46aad6cb9e-goog

