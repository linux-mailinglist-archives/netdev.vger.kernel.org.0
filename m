Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C6F39572B
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhEaIlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhEaIkk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:40:40 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A39C061346
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:51 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id g9-20020a25ae490000b029052f9e5b7d3fso12897650ybe.4
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=AEPyucLyrMot2MOCwhvpaOx5eGUi7rDbkpCG2Tc5gVA=;
        b=IoUxB/iqmJldjMym61T+WpCa29hrts4nqA12rXDjr+GiO26ya/wb4by9HjWSMm7e2e
         mFH4eZ+yyhEU43palGpOIFzy2Mjn555LnrzT3cs/RiW7Yyv2v3c9MKSPXs2qkFvm8M8X
         HlcgQ4jwr8kdZEfsQMQEZEYN9U9lzZT8Ea+SYmiQp5vfgntYOG/X8ZJfoWKRRVPRrs2i
         jEuxZjP9RBaFncuEOiOCMiBOXjtAncQvI1ImWpbRxMyUIGXEZe0F1Tn/mfN3hESKN8mv
         fToLWjff2uCIq85vCajpGz/RPBuZNUzUrtUxRQXDUHnUBK9gGgFY5bVCQT8pNBwjcF1V
         d0Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=AEPyucLyrMot2MOCwhvpaOx5eGUi7rDbkpCG2Tc5gVA=;
        b=mOWHBW1F/UfjRNe9Y2dZJ0jaNGIj+Atzs92lecLTHaBgYUpz0BlwOLt2LsU6SQ545N
         xd7ZsKzAm0ZuRQUl8VCfFw8ISiSMV77A/GjUd4LwVX8GF76GBUxdnybm/YWE9Mzxf5UG
         9T/6EktqEFvFGS51O6fMwun4TeW/uVZeYgR1sIbzglmjXFmaNzOpVPHdXM6glveiKIVE
         pEr2A76iEw2jt30IAZFUSAlitGWHB96ySDHFQ4Qwz3j14QcmV+YmYqgEqShTc8foVGSV
         e/hYiDrzDuDLFPEqmutLiqWmZQy8eVHn3azqMChOlh59fWlMog9Uuv5Mc+f2anig3itB
         2U0w==
X-Gm-Message-State: AOAM530sOjfPy7iHfvuAMYLeNv0uty4U84Tc3xTIgbfxwnCA8DyyGOic
        hXqNPoEYkNY2SznHQ+PEZGQR4YJx8YwK
X-Google-Smtp-Source: ABdhPJwoZc3czhEFeRI5q9BpBdL1DqA560GpwEkpvSWHfQ6ZXMycz3rC/PADyU8hbFGtrpKL53NRWpo+O6Q5
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:a6d1:a727:b17d:154e])
 (user=apusaka job=sendgmr) by 2002:a25:6088:: with SMTP id
 u130mr30969042ybb.257.1622450330401; Mon, 31 May 2021 01:38:50 -0700 (PDT)
Date:   Mon, 31 May 2021 16:37:24 +0800
In-Reply-To: <20210531083726.1949001-1-apusaka@google.com>
Message-Id: <20210531163500.v2.5.I4401b43eaf53e45e02ccaadef43cdcd3396173be@changeid>
Mime-Version: 1.0
References: <20210531083726.1949001-1-apusaka@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 5/8] Bluetooth: use inclusive language when tracking connections
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

 include/net/bluetooth/hci_core.h |  6 +++---
 net/bluetooth/hci_event.c        |  4 ++--
 net/bluetooth/hci_request.c      | 17 +++++++++--------
 3 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/net/bluetooth/hci_core.h b/include/net/bluetooth/hci_core.h
index 929768f6ed93..cfe2ada49ca2 100644
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
@@ -122,7 +122,7 @@ struct hci_conn_hash {
 	unsigned int     amp_num;
 	unsigned int     sco_num;
 	unsigned int     le_num;
-	unsigned int     le_num_slave;
+	unsigned int     le_num_peripheral;
 };
 
 struct bdaddr_list {
@@ -894,7 +894,7 @@ static inline void hci_conn_hash_add(struct hci_dev *hdev, struct hci_conn *c)
 	case LE_LINK:
 		h->le_num++;
 		if (c->role == HCI_ROLE_PERIPHERAL)
-			h->le_num_slave++;
+			h->le_num_peripheral++;
 		break;
 	case SCO_LINK:
 	case ESCO_LINK:
@@ -920,7 +920,7 @@ static inline void hci_conn_hash_del(struct hci_dev *hdev, struct hci_conn *c)
 	case LE_LINK:
 		h->le_num--;
 		if (c->role == HCI_ROLE_PERIPHERAL)
-			h->le_num_slave--;
+			h->le_num_peripheral--;
 		break;
 	case SCO_LINK:
 	case ESCO_LINK:
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index a809e90326d7..c5871c2a16ba 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5384,9 +5384,9 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 		return NULL;
 
 	/* Most controller will fail if we try to create new connections
-	 * while we have an existing one in slave role.
+	 * while we have an existing one in peripheral role.
 	 */
-	if (hdev->conn_hash.le_num_slave > 0 &&
+	if (hdev->conn_hash.le_num_peripheral > 0 &&
 	    (!test_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks) ||
 	     !(hdev->le_states[3] & 0x10)))
 		return NULL;
diff --git a/net/bluetooth/hci_request.c b/net/bluetooth/hci_request.c
index 3465862429fb..a5d55175176e 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1519,13 +1519,14 @@ static bool is_advertising_allowed(struct hci_dev *hdev, bool connectable)
 	if (hci_conn_num(hdev, LE_LINK) == 0)
 		return true;
 
-	/* Check le_states if there is any connection in slave role. */
-	if (hdev->conn_hash.le_num_slave > 0) {
-		/* Slave connection state and non connectable mode bit 20. */
+	/* Check le_states if there is any connection in peripheral role. */
+	if (hdev->conn_hash.le_num_peripheral > 0) {
+		/* Peripheral connection state and non connectable mode bit 20.
+		 */
 		if (!connectable && !(hdev->le_states[2] & 0x10))
 			return false;
 
-		/* Slave connection state and connectable mode bit 38
+		/* Peripheral connection state and connectable mode bit 38
 		 * and scannable bit 21.
 		 */
 		if (connectable && (!(hdev->le_states[4] & 0x40) ||
@@ -1533,13 +1534,13 @@ static bool is_advertising_allowed(struct hci_dev *hdev, bool connectable)
 			return false;
 	}
 
-	/* Check le_states if there is any connection in master role. */
-	if (hci_conn_num(hdev, LE_LINK) != hdev->conn_hash.le_num_slave) {
-		/* Master connection state and non connectable mode bit 18. */
+	/* Check le_states if there is any connection in central role. */
+	if (hci_conn_num(hdev, LE_LINK) != hdev->conn_hash.le_num_peripheral) {
+		/* Central connection state and non connectable mode bit 18. */
 		if (!connectable && !(hdev->le_states[2] & 0x02))
 			return false;
 
-		/* Master connection state and connectable mode bit 35 and
+		/* Central connection state and connectable mode bit 35 and
 		 * scannable 19.
 		 */
 		if (connectable && (!(hdev->le_states[4] & 0x08) ||
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

