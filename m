Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A91238FF35
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232115AbhEYKdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232117AbhEYKcY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:32:24 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 580C6C06135B
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:19 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j84-20020a25d2570000b029052695f1929dso2229841ybg.3
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=UXo23GwK/luqXob/Py9T0EVZy2iOWx16pZJGz6ZxQDU=;
        b=aKPYkXbNTpTI1/TPsoRXDxDv/cdsJnQM4nvpvoTQ7XymGtPqhysT3wU42ITnSCKjhb
         6E4fWga6oPp0gsi6h3Xq5ncixCDa2W6gdIWy5T48dU78p7+naHvW1dM+CW3lMtEHvn2/
         GU8DuRkb3Jw3P4aeZHpVr5Gdd32h1+9sJIaeaLHA45+8AFnBc0YYEkHVuT659xtmMUlU
         K5d620FNPMlyOar2u+eH3UbyY2VmxgghFFZoPCYxtk5L+wt0ESbZURQPNRddRi43CAFX
         exJvRkxGu8qS6OGN/PPhPqoPIDQ3kA1xDaE6kX4ufWADOvw9TU4TvpMCPxgepAhRlK/y
         pMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=UXo23GwK/luqXob/Py9T0EVZy2iOWx16pZJGz6ZxQDU=;
        b=snpHayeyuUGFpTlEdAu/G21EPadU6LWQgduQjJCGOkynnbiaU1LmDGKHmy2mfCaJxY
         /ZTkR8r4AShwqYCJvwIHjYM6jw/kOh5aSdMXFqVUy1VEnnwXgZuB87XodGjKkoZzg89+
         dCfRddv7mLXBqRCkyfe8p/sMV/CNLWoccacXouDn96OP0Pg+t2w/YY2SxBcwH9OkhqCH
         mMeaTeUiFR21/V2TZq+Zpt06gwOJPHotDTMp3Xj0jJRY/6cd81XqP9QNYjz6ERQecdOk
         5Yk7x0N4BdX+cWHzKqX5+652mczgczMkw+TSM9sjzT23VC3tlxxQ4JoKpsjALcxjcos1
         mN/Q==
X-Gm-Message-State: AOAM531sbqmX4LacKyEJrJBfUuo4uWsgfupjj1MHfyMQ6f5BZ4NxbfN1
        YTrgMrLT2EBuE1Gex106ySNVoQqqN9wo
X-Google-Smtp-Source: ABdhPJyoV+Zo7rkBl/WtwI/KW4L1RCHSLbXle/C0FUYdwLdD63gI+j7VoQa/VBE9H4d0V6SjTGr8OFD7rB/k
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:8806:6b98:8ae6:8824])
 (user=apusaka job=sendgmr) by 2002:a25:6911:: with SMTP id
 e17mr4108665ybc.162.1621938618586; Tue, 25 May 2021 03:30:18 -0700 (PDT)
Date:   Tue, 25 May 2021 18:29:36 +0800
In-Reply-To: <20210525102941.3958649-1-apusaka@google.com>
Message-Id: <20210525182900.7.I4401b43eaf53e45e02ccaadef43cdcd3396173be@changeid>
Mime-Version: 1.0
References: <20210525102941.3958649-1-apusaka@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 07/12] Bluetooth: use inclusive language when tracking connections
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
index fa9125b782f8..28a477a7d320 100644
--- a/net/bluetooth/hci_request.c
+++ b/net/bluetooth/hci_request.c
@@ -1502,13 +1502,14 @@ static bool is_advertising_allowed(struct hci_dev *hdev, bool connectable)
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
@@ -1516,13 +1517,13 @@ static bool is_advertising_allowed(struct hci_dev *hdev, bool connectable)
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
2.31.1.818.g46aad6cb9e-goog

