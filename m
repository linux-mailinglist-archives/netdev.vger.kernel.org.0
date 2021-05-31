Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E5F395726
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:39:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230523AbhEaIk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhEaIkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:40:18 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F5DC061760
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:38 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id c10-20020a0cca0a0000b029021772507de5so3922699qvk.23
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9r21AyqsmQHvyUtyxiaJxCTMlJZ7EnY4HZMY3OoMpaQ=;
        b=lpFGNDUwdGfJOWYtCwF2MSQWgmwjA0H5Kh6EezPDF9zzT6dKfskh/M2QrAoWC+UUrB
         PHatFOaZBKW3kRWRtiJtk3AcQFA7GhmAButXV4ChGAex2z4EsH8tC1MsjSGbq34XKNTc
         j4vLvaC0eQcUJLLfHfpBLzEJYqITzwKWmu2wta/nZPyAaXOj3BKbOrBvttks6v7/rJwp
         3eG9yPNQaY5oE5aGuT6/kWuvFUKCaRL5P0e5lHAy+lf3KhNuvqiOX7ySRhMb1LayyzV6
         lq8O4AV5KNzNm2XZk/qSSHriWiD0nXuOLr7ulTITp1/0ayRICVWhqs82dy0j7GYiYbUi
         uxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9r21AyqsmQHvyUtyxiaJxCTMlJZ7EnY4HZMY3OoMpaQ=;
        b=NmDq5wueMZ0wF3cInrcLg+Pdj/MU6ofNPWH9/SmKfy7/Rykpjkoj+KgE2Z9vZzlLw7
         a7kbuJoUnkcQbL//vRpF4Uwo8jo8Rjo4ncXlOpzG6fRxvNs+pEbBJEFf/xtgc8kA116r
         OxzjnUn16wObxt61Xr9utqR6nh8a7uvyUeJDEEZ1jglUp2Q005QSYESZ3o4z9VooEVfI
         +aP0CpdVq43Le227XVIMkrom3iefqa58DXqRRzRQlSpAZDfmhKQ4l2I1pGNuLqPBmktd
         1sCDMC4ZdYcQqzWV7EyV+9vpqM41BJG/kqUZ55EzGSdbpidQlGW8CSEijm38CnYNTnu0
         8YfA==
X-Gm-Message-State: AOAM533Cbs23m21tQtQtiydmPh5ryP4Ie/nYy94+RlRKY/IkFi3VjYR1
        eQ7+ZfpRlmwK9nwpBrURTNpo3IXDQSED
X-Google-Smtp-Source: ABdhPJz4dzWcW79/HylOZxkLtC618BQpt9/mn7BND/etToBSCd+vBUb5i7UlBAtGxtGF9BzDoiyK+5bQd0Ww
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:a6d1:a727:b17d:154e])
 (user=apusaka job=sendgmr) by 2002:ad4:5be5:: with SMTP id
 k5mr15792611qvc.55.1622450317259; Mon, 31 May 2021 01:38:37 -0700 (PDT)
Date:   Mon, 31 May 2021 16:37:22 +0800
In-Reply-To: <20210531083726.1949001-1-apusaka@google.com>
Message-Id: <20210531163500.v2.3.Icd1fee7b40dcfec866286803065a3d19dd9ca7ed@changeid>
Mime-Version: 1.0
References: <20210531083726.1949001-1-apusaka@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 3/8] Bluetooth: use inclusive language to describe CPB
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

Specifically, these terms are replaced when describing the
connectionless peripheral broadcast feature:
master -> central
slave  -> peripheral

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

Changes in v2:
* Add details in commit message

 include/net/bluetooth/hci.h      | 26 +++++++++++++-------------
 include/net/bluetooth/hci_core.h |  4 ++--
 net/bluetooth/hci_conn.c         |  2 +-
 net/bluetooth/hci_core.c         | 16 ++++++++--------
 4 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index c3efef266d6d..a7cf5a2d87c5 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -36,7 +36,7 @@
 
 #define HCI_MAX_AMP_ASSOC_SIZE	672
 
-#define HCI_MAX_CSB_DATA_SIZE	252
+#define HCI_MAX_CPB_DATA_SIZE	252
 
 /* HCI dev events */
 #define HCI_DEV_REG			1
@@ -472,10 +472,10 @@ enum {
 #define LMP_EXTFEATURES	0x80
 
 /* Extended LMP features */
-#define LMP_CSB_MASTER	0x01
-#define LMP_CSB_SLAVE	0x02
-#define LMP_SYNC_TRAIN	0x04
-#define LMP_SYNC_SCAN	0x08
+#define LMP_CPB_CENTRAL		0x01
+#define LMP_CPB_PERIPHERAL	0x02
+#define LMP_SYNC_TRAIN		0x04
+#define LMP_SYNC_SCAN		0x08
 
 #define LMP_SC		0x01
 #define LMP_PING	0x02
@@ -877,17 +877,17 @@ struct hci_rp_logical_link_cancel {
 	__u8     flow_spec_id;
 } __packed;
 
-#define HCI_OP_SET_CSB			0x0441
-struct hci_cp_set_csb {
+#define HCI_OP_SET_CPB			0x0441
+struct hci_cp_set_cpb {
 	__u8	enable;
 	__u8	lt_addr;
 	__u8	lpo_allowed;
 	__le16	packet_type;
 	__le16	interval_min;
 	__le16	interval_max;
-	__le16	csb_sv_tout;
+	__le16	cpb_sv_tout;
 } __packed;
-struct hci_rp_set_csb {
+struct hci_rp_set_cpb {
 	__u8	status;
 	__u8	lt_addr;
 	__le16	interval;
@@ -1184,14 +1184,14 @@ struct hci_rp_delete_reserved_lt_addr {
 	__u8	lt_addr;
 } __packed;
 
-#define HCI_OP_SET_CSB_DATA		0x0c76
-struct hci_cp_set_csb_data {
+#define HCI_OP_SET_CPB_DATA		0x0c76
+struct hci_cp_set_cpb_data {
 	__u8	lt_addr;
 	__u8	fragment;
 	__u8	data_length;
-	__u8	data[HCI_MAX_CSB_DATA_SIZE];
+	__u8	data[HCI_MAX_CPB_DATA_SIZE];
 } __packed;
-struct hci_rp_set_csb_data {
+struct hci_rp_set_cpb_data {
 	__u8	status;
 	__u8	lt_addr;
 } __packed;
diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 368e16fdf441..929768f6ed93 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -1394,8 +1394,8 @@ void hci_conn_del_sysfs(struct hci_conn *conn);
 #define lmp_edr_5slot_capable(dev) ((dev)->features[0][5] & LMP_EDR_5SLOT)
 
 /* ----- Extended LMP capabilities ----- */
-#define lmp_csb_master_capable(dev) ((dev)->features[2][0] & LMP_CSB_MASTER)
-#define lmp_csb_slave_capable(dev)  ((dev)->features[2][0] & LMP_CSB_SLAVE)
+#define lmp_cpb_central_capable(dev) ((dev)->features[2][0] & LMP_CPB_CENTRAL)
+#define lmp_cpb_peripheral_capable(dev) ((dev)->features[2][0] & LMP_CPB_PERIPHERAL)
 #define lmp_sync_train_capable(dev) ((dev)->features[2][0] & LMP_SYNC_TRAIN)
 #define lmp_sync_scan_capable(dev)  ((dev)->features[2][0] & LMP_SYNC_SCAN)
 #define lmp_sc_capable(dev)         ((dev)->features[2][1] & LMP_SC)
diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index 703470b6b924..7b8784d4da96 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -1842,7 +1842,7 @@ u32 hci_conn_get_phy(struct hci_conn *conn)
 
 	/* BLUETOOTH CORE SPECIFICATION Version 5.2 | Vol 2, Part B page 471:
 	 * Table 6.2: Packets defined for synchronous, asynchronous, and
-	 * CSB logical transport types.
+	 * CPB logical transport types.
 	 */
 	switch (conn->type) {
 	case SCO_LINK:
diff --git a/net/bluetooth/hci_core.c b/net/bluetooth/hci_core.c
index 4ac6022f7085..b9ebad0f8fb9 100644
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
@@ -545,24 +545,24 @@ static void hci_set_event_mask_page_2(struct hci_request *req)
 	u8 events[8] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
 	bool changed = false;
 
-	/* If Connectionless Slave Broadcast master role is supported
+	/* If Connectionless Peripheral Broadcast central role is supported
 	 * enable all necessary events for it.
 	 */
-	if (lmp_csb_master_capable(hdev)) {
+	if (lmp_cpb_central_capable(hdev)) {
 		events[1] |= 0x40;	/* Triggered Clock Capture */
 		events[1] |= 0x80;	/* Synchronization Train Complete */
-		events[2] |= 0x10;	/* Slave Page Response Timeout */
-		events[2] |= 0x20;	/* CSB Channel Map Change */
+		events[2] |= 0x10;	/* Peripheral Page Response Timeout */
+		events[2] |= 0x20;	/* CPB Channel Map Change */
 		changed = true;
 	}
 
-	/* If Connectionless Slave Broadcast slave role is supported
+	/* If Connectionless Peripheral Broadcast peripheral role is supported
 	 * enable all necessary events for it.
 	 */
-	if (lmp_csb_slave_capable(hdev)) {
+	if (lmp_cpb_peripheral_capable(hdev)) {
 		events[2] |= 0x01;	/* Synchronization Train Received */
-		events[2] |= 0x02;	/* CSB Receive */
-		events[2] |= 0x04;	/* CSB Timeout */
+		events[2] |= 0x02;	/* CPB Receive */
+		events[2] |= 0x04;	/* CPB Timeout */
 		events[2] |= 0x08;	/* Truncated Page Complete */
 		changed = true;
 	}
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

