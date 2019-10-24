Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F866E3E39
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 23:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729400AbfJXVbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 17:31:39 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:43586 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729344AbfJXVbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 17:31:38 -0400
Received: by mail-lj1-f195.google.com with SMTP id n14so235244ljj.10;
        Thu, 24 Oct 2019 14:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qJ1EX0Kq7Hc0I2gigYhsf29QyA4q3H6fD9HN+WxlrxM=;
        b=HkUBCzNj3n7ceVTxU4Xyljb2pGfrTPCKI4p+XSmlcnewOtBiSIZZb9cNEASe/f+LkL
         JGk+ijl88YSlSuZ90IGg0PdPBMg9yf16pzHcmjJBJSSCW4T4T+3T3fZlFrfQHuWnVQ+p
         W73+tq5Oj8XLAV2pqoPSNbm63V+iSVUmQALYKJbQKrlOR0sMs4AJ2EeuIFekOkBj2+/d
         DV3JzcSh4rcJxrMOBrx25VTcG/7yFiOnn6h4nt9BgfAv0o1zE7a571kVs36yvKCVHm/X
         bvGirqUkyRtWXhIxW+9oKwDHGYbhEY8+ZbshngkRiD7mMSFgwCKK/0P0kQfKFcTicsOb
         5i4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qJ1EX0Kq7Hc0I2gigYhsf29QyA4q3H6fD9HN+WxlrxM=;
        b=KyIbh0qniX+de/1V8Fi7yG3ak7SFDCfegk6uk77jmln+HC26HdIA+uXYRNiTjoxjW7
         CbbrZxqgw7ZOh+UQsK0KvWzoX0rmSir1yydOuYLwerHTY8/4ZlkLG0/siOGm9IhLHwSx
         a8oKNwxOlKQTU5heIZUeYEvA17BhhjjJFQyjP4W3G9iC8YlAoq47PTMsthMKz/8J2gdi
         YMnDARzlu0pBPbURID9c9qZMK7RfzWvWWa9ghS+9/s5L8N04pDMWylLX9EnYQgxmh6A+
         VCUKf6hCnXT1wMSC4v+gS/auI/MTTgqrGPJJFHrSyT5IRsY/N2Mm+QuckQpNkbd6TrZN
         Gf1g==
X-Gm-Message-State: APjAAAWVHE4lYwqeQWPHfupR1Lj9w/Vx8l0PrEI5UGoK4pYB3PeMwqhN
        x73/5KtjlffY0qqHcHbYGmD1XFoxIrWKkg==
X-Google-Smtp-Source: APXvYqzIj60l+A4N79gkrXJ4HjaMcU8j8fLJgIG2KyVEZA/boUiDpRnesazwsJT7l4XcLOGXuVqJ5w==
X-Received: by 2002:a2e:2e15:: with SMTP id u21mr23801724lju.31.1571952696368;
        Thu, 24 Oct 2019 14:31:36 -0700 (PDT)
Received: from localhost.localdomain ([93.152.168.243])
        by smtp.gmail.com with ESMTPSA id t8sm20228336ljd.18.2019.10.24.14.31.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 14:31:35 -0700 (PDT)
From:   Samuil Ivanov <samuil.ivanovbg@gmail.com>
To:     gregkh@linuxfoundation.org, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com
Cc:     samuil.ivanovbg@gmail.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] Staging: qlge: Rename prefix of a function to qlge
Date:   Fri, 25 Oct 2019 00:29:40 +0300
Message-Id: <20191024212941.28149-3-samuil.ivanovbg@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
References: <20191024212941.28149-1-samuil.ivanovbg@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Function ql_own_firmware renamed to
qlge_own_firmware and it's clients updated.

Signed-off-by: Samuil Ivanov <samuil.ivanovbg@gmail.com>
---
 drivers/staging/qlge/qlge.h     | 2 +-
 drivers/staging/qlge/qlge_dbg.c | 2 +-
 drivers/staging/qlge/qlge_mpi.c | 5 ++---
 3 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index e9f1363c5bf2..d3f10c95c781 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -2280,7 +2280,7 @@ int ql_wait_fifo_empty(struct ql_adapter *qdev);
 void ql_get_dump(struct ql_adapter *qdev, void *buff);
 netdev_tx_t ql_lb_send(struct sk_buff *skb, struct net_device *ndev);
 void ql_check_lb_frame(struct ql_adapter *, struct sk_buff *);
-int ql_own_firmware(struct ql_adapter *qdev);
+int qlge_own_firmware(struct ql_adapter *qdev);
 int ql_clean_lb_rx_ring(struct rx_ring *rx_ring, int budget);
 
 /* #define QL_ALL_DUMP */
diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
index df5344e113ca..82bca35543d3 100644
--- a/drivers/staging/qlge/qlge_dbg.c
+++ b/drivers/staging/qlge/qlge_dbg.c
@@ -1209,7 +1209,7 @@ int ql_core_dump(struct ql_adapter *qdev, struct ql_mpi_coredump *mpi_coredump)
 
 static void ql_get_core_dump(struct ql_adapter *qdev)
 {
-	if (!ql_own_firmware(qdev)) {
+	if (!qlge_own_firmware(qdev)) {
 		netif_err(qdev, drv, qdev->ndev, "Don't own firmware!\n");
 		return;
 	}
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index efe893935929..ccffe0b256fa 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -101,7 +101,7 @@ int qlge_soft_reset_mpi_risc(struct ql_adapter *qdev)
  * we are the higher function and the lower function
  * is not enabled.
  */
-int ql_own_firmware(struct ql_adapter *qdev)
+int qlge_own_firmware(struct ql_adapter *qdev)
 {
 	u32 temp;
 
@@ -122,7 +122,6 @@ int ql_own_firmware(struct ql_adapter *qdev)
 		return 1;
 
 	return 0;
-
 }
 
 static int ql_get_mb_sts(struct ql_adapter *qdev, struct mbox_params *mbcp)
@@ -1270,7 +1269,7 @@ void ql_mpi_reset_work(struct work_struct *work)
 	/* If we're not the dominant NIC function,
 	 * then there is nothing to do.
 	 */
-	if (!ql_own_firmware(qdev)) {
+	if (!qlge_own_firmware(qdev)) {
 		netif_err(qdev, drv, qdev->ndev, "Don't own firmware!\n");
 		return;
 	}
-- 
2.17.1

