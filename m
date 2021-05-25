Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCE5F38FF46
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 12:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232447AbhEYKd7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 06:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhEYKcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 06:32:47 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8975C06137B
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:37 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id g21-20020ac870d50000b0290230013e97e6so5208142qtp.21
        for <netdev@vger.kernel.org>; Tue, 25 May 2021 03:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HjaAVyjqWLnSC3FFXoJAmpMacfJ4D7tkLOeJEd/lVVY=;
        b=qZdJsQKmwaRh/S8yLEHNhohKTur3L8Wo6btuJkgZbFhw6mLXc3uFvkyynYP1ZW25sQ
         8A+t2ygyCl57P03POYdkVV7LgP9aXVJkunH6oxJT5jasFFdJ+6SkmzDieN+K7mFTMz3J
         0954A7mmnajLatFz5t0phcn517URZQtjrSNr92KsWQm3Nc8fTwFsP45ULlH2PC9rkMU9
         aHgkt+xSiFbZFxOiwio65HPy/okDvg9xZ402B0nvW1LuyL4YC2Ib11fLGJtS1hoEGvFp
         5leI9boxSg856kF6NroS/fhjHEcsg3EXW2zJZxcLIBO+mOpTAzfoFZ/GHwpwunoF6+RM
         BScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HjaAVyjqWLnSC3FFXoJAmpMacfJ4D7tkLOeJEd/lVVY=;
        b=VbO/wcn8rhpDP+OS5tLHIpgYT6WrBNPTsfNo+c7xplkU5MwiqNgPrreLMlEZdgelcW
         t7gtwtJ3trS2ujmGzZFFdlOGfRBpGA9Mqq0WHS/3WSS2o54KS7PotCTWePCQcT5Jr05Y
         4s+zVJbYsUgtMxKG7k9b1m9DdBDVqoptiboH6Lz2vTiz509KkY4Av+nY6U5XIK3eNIi0
         bxfCRaYMctmNPD05ln3lF0ADZcB6veHtwLZ3n1sfzN5HyGT5W8CV27nfbgQAx895AkGQ
         bQAgBeK1eU7dhfYRCpr9PPqADQw6GzB2HanEXE6dY0Nf9rk3bp9Kjlx3YoetpAAttmOU
         IMCQ==
X-Gm-Message-State: AOAM530IAQCZ4dTUVgjX7ULAQi3qmGxZB/cEIaAQREwPkjhASEbIaEPY
        fhdqzi0Ctb98w8OytA8GL4/gCV9lrpXp
X-Google-Smtp-Source: ABdhPJx3y3NV3+IgaLvjYGrwoSuEMZ4sv0qOlrPCZ3EWKqb59wYJD6XdsM9PFHw08/ZZjU653qgd9ZvOnX4M
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:8806:6b98:8ae6:8824])
 (user=apusaka job=sendgmr) by 2002:ad4:4583:: with SMTP id
 x3mr35782858qvu.39.1621938636956; Tue, 25 May 2021 03:30:36 -0700 (PDT)
Date:   Tue, 25 May 2021 18:29:41 +0800
In-Reply-To: <20210525102941.3958649-1-apusaka@google.com>
Message-Id: <20210525182900.12.I361d8bede7e78ecb42a83a42994f191b13e60279@changeid>
Mime-Version: 1.0
References: <20210525102941.3958649-1-apusaka@google.com>
X-Mailer: git-send-email 2.31.1.818.g46aad6cb9e-goog
Subject: [PATCH 12/12] Bluetooth: use inclusive language in comments
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
        "=?UTF-8?q?Ole=20Bj=C3=B8rn=20Midtb=C3=B8?=" <omidtbo@cisco.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

Use "peripheral" and "blocked".

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

 net/bluetooth/hci_event.c | 6 +++---
 net/bluetooth/hidp/core.c | 2 +-
 net/bluetooth/mgmt.c      | 2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
index 760e8e14e0f2..df5e17019e00 100644
--- a/net/bluetooth/hci_event.c
+++ b/net/bluetooth/hci_event.c
@@ -5404,7 +5404,7 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 		case HCI_AUTO_CONN_DIRECT:
 			/* Only devices advertising with ADV_DIRECT_IND are
 			 * triggering a connection attempt. This is allowing
-			 * incoming connections from slave devices.
+			 * incoming connections from peripheral devices.
 			 */
 			if (adv_type != LE_ADV_DIRECT_IND)
 				return NULL;
@@ -5412,8 +5412,8 @@ static struct hci_conn *check_pending_le_conn(struct hci_dev *hdev,
 		case HCI_AUTO_CONN_ALWAYS:
 			/* Devices advertising with ADV_IND or ADV_DIRECT_IND
 			 * are triggering a connection attempt. This means
-			 * that incoming connections from slave device are
-			 * accepted and also outgoing connections to slave
+			 * that incoming connections from peripheral device are
+			 * accepted and also outgoing connections to peripheral
 			 * devices are established when found.
 			 */
 			break;
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 0db48c812662..96fedef14723 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -794,7 +794,7 @@ static int hidp_setup_hid(struct hidp_session *session,
 	hid->dev.parent = &session->conn->hcon->dev;
 	hid->ll_driver = &hidp_hid_driver;
 
-	/* True if device is blacklisted in drivers/hid/hid-quirks.c */
+	/* True if device is blocked in drivers/hid/hid-quirks.c */
 	if (hid_ignore(hid)) {
 		hid_destroy_device(session->hid);
 		session->hid = NULL;
diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b6fa0333ca8c..9d316518bbe2 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -2959,7 +2959,7 @@ static int pair_device(struct sock *sk, struct hci_dev *hdev, void *data,
 		/* When pairing a new device, it is expected to remember
 		 * this device for future connections. Adding the connection
 		 * parameter information ahead of time allows tracking
-		 * of the slave preferred values and will speed up any
+		 * of the peripheral preferred values and will speed up any
 		 * further connection establishment.
 		 *
 		 * If connection parameters already exist, then they
-- 
2.31.1.818.g46aad6cb9e-goog

