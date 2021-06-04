Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AE8939B4DB
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:27:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbhFDI3b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:29:31 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:57169 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhFDI3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:29:30 -0400
Received: by mail-qt1-f201.google.com with SMTP id i24-20020ac876580000b02902458afcb6faso519517qtr.23
        for <netdev@vger.kernel.org>; Fri, 04 Jun 2021 01:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=rkwFW1rTtpipvPo2i45vrrpv7tHxndFtqZdOdDuII3A=;
        b=TqrRKVn7by4f57Ty0NBYM9ZQi0Yel60OrNYMMrjdSVWyfN/pZriGeyU44PbO89UH+P
         KcXpb6FIgJGL4eZm6mJ2RjgoXhiQCswQJfQwdDai4ATO9xluo0Rry/txCJsBUnpF+h4y
         NPHqWomi88TH4sHmoUCSGUoPfgt2GJgFv7fYazgcXz4lL+ApLzKomWX6tKnyQ1D/8vG7
         LTYS8oIpLAl5ZA0AYkSW6gCY8u26jL9khDnOPV6B/ZamX9UXq0PpyOw/bVlVYCHlJfl/
         pG/Bbo+7XPbMbjumsX6r9K6hc4QSAobk1RJviQ2TkGIJ0rUs8OtvzupajxV4OdlfiUOM
         DPeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=rkwFW1rTtpipvPo2i45vrrpv7tHxndFtqZdOdDuII3A=;
        b=GGuihvkFcnZP2+Wf712eVxeaQW2Z46atSXYADs6psMMnQbaIm1dX9HaAQI6gCcSJ7A
         2b/VDpwO5WvZ4YABfUIXQGgEUMOyt2g2iBX0vMv5HfOuhhO8jMGu/KVTn9u2iBAr85db
         wyozWMnJqQ18Uc9hRas/SA/DVnQd4VSgDT1g/EoiBgQyILPu6m1zcFpUNmlkdvDGn6oi
         9LEmOMFxhbuJN9x+OLqmHJPEct3rSMyO+MF5hVVsaY3g9BJh6I1k0e4qDLt8eq+R9pQF
         Dqvoprb943S0SJNFRueXV0UIBn3l6gB579zIL7kRdOkoBpl0lILvaQc1xLFsnks6MUiz
         j0bg==
X-Gm-Message-State: AOAM533gWogtsOof/FhnG5J9dTA2h9r+k6Ej0lpWakshcySH9NEMY/pc
        2oZQLRsPp7fujveccioI38+bCsdIlAC+
X-Google-Smtp-Source: ABdhPJy79J6o/QLMeaKcj/RXYOyZshshwOG8QXnezqwQnLqPs+Ls7Rbq+Jrw45UofuZH6InyGCdACZ3fMjbT
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:c6ff:1ed3:74cf:2ae3])
 (user=apusaka job=sendgmr) by 2002:a0c:d80f:: with SMTP id
 h15mr3586315qvj.17.1622795193532; Fri, 04 Jun 2021 01:26:33 -0700 (PDT)
Date:   Fri,  4 Jun 2021 16:26:25 +0800
Message-Id: <20210604162616.v3.1.I444f42473f263fed77f2586eb4b01d6752df0de4@changeid>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v3 1/3] Bluetooth: use inclusive language in HCI role comments
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
master -> initiator (for smp) or central (everything else)
slave  -> responder (for smp) or peripheral (everything else)

The #define preprocessor terms are unchanged for now to not disturb
dependent APIs.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>

---

Changes in v3:
* Remove the #define terms from change

 net/bluetooth/hci_conn.c   | 8 ++++----
 net/bluetooth/hci_event.c  | 6 +++---
 net/bluetooth/l2cap_core.c | 2 +-
 net/bluetooth/smp.c        | 6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/bluetooth/hci_conn.c b/net/bluetooth/hci_conn.c
index ea0f9cdaa6b1..2b5059a56cda 100644
--- a/net/bluetooth/hci_conn.c
+++ b/net/bluetooth/hci_conn.c
@@ -257,7 +257,7 @@ int hci_disconnect(struct hci_conn *conn, __u8 reason)
 {
 	BT_DBG("hcon %p", conn);
 
-	/* When we are master of an established connection and it enters
+	/* When we are central of an established connection and it enters
 	 * the disconnect timeout, then go ahead and try to read the
 	 * current clock offset.  Processing of the result is done
 	 * within the event handling and hci_clock_offset_evt function.
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
@@ -1119,7 +1119,7 @@ struct hci_conn *hci_connect_le(struct hci_dev *hdev, bdaddr_t *dst,
 	if (hci_dev_test_flag(hdev, HCI_LE_ADV))
 		__hci_req_pause_adv_instances(&req);
 
-	/* If requested to connect as slave use directed advertising */
+	/* If requested to connect as peripheral use directed advertising */
 	if (conn->role == HCI_ROLE_SLAVE) {
 		/* If we're active scanning most controllers are unable
 		 * to initiate advertising. Simply reject the attempt.
diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 43c324c46c0b..da013d485f14 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -2795,9 +2795,9 @@ static void hci_conn_request_evt(struct hci_dev *hdev, struct sk_buff *skb)
 		bacpy(&cp.bdaddr, &ev->bdaddr);
 
 		if (lmp_rswitch_capable(hdev) && (mask & HCI_LM_MASTER))
-			cp.role = 0x00; /* Become master */
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
diff --git a/net/bluetooth/l2cap_core.c b/net/bluetooth/l2cap_core.c
index 9ebb85df4db4..b76c5d00b082 100644
--- a/net/bluetooth/l2cap_core.c
+++ b/net/bluetooth/l2cap_core.c
@@ -1691,7 +1691,7 @@ static void l2cap_le_conn_ready(struct l2cap_conn *conn)
 	if (hcon->out)
 		smp_conn_security(hcon, hcon->pending_sec_level);
 
-	/* For LE slave connections, make sure the connection interval
+	/* For LE peripheral connections, make sure the connection interval
 	 * is in the range of the minimum and maximum interval that has
 	 * been configured for this connection. If not, then trigger
 	 * the connection update procedure.
diff --git a/net/bluetooth/smp.c b/net/bluetooth/smp.c
index 6777f5313838..53f984d11bc1 100644
--- a/net/bluetooth/smp.c
+++ b/net/bluetooth/smp.c
@@ -909,8 +909,8 @@ static int tk_request(struct l2cap_conn *conn, u8 remote_oob, u8 auth,
 			hcon->pending_sec_level = BT_SECURITY_HIGH;
 	}
 
-	/* If both devices have Keyoard-Display I/O, the master
-	 * Confirms and the slave Enters the passkey.
+	/* If both devices have Keyboard-Display I/O, the initiator
+	 * Confirms and the responder Enters the passkey.
 	 */
 	if (smp->method == OVERLAP) {
 		if (hcon->role == HCI_ROLE_MASTER)
@@ -3083,7 +3083,7 @@ static void bredr_pairing(struct l2cap_chan *chan)
 	if (!test_bit(HCI_CONN_ENCRYPT, &hcon->flags))
 		return;
 
-	/* Only master may initiate SMP over BR/EDR */
+	/* Only initiator may initiate SMP over BR/EDR */
 	if (hcon->role != HCI_ROLE_MASTER)
 		return;
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

