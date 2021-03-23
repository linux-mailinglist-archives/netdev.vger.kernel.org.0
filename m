Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFB9345B32
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 10:44:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCWJoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 05:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbhCWJnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 05:43:47 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9010EC061574;
        Tue, 23 Mar 2021 02:43:47 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id f12so14452769qtq.4;
        Tue, 23 Mar 2021 02:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jtS9ZIUBeGm+Car1XcRrWGY+RpAJ9p6p/GMgJGpuzSA=;
        b=r8I2PgBaqbpaqz/hop4GR5W80JClYYoBef05T/kBKyHWY1Zv86W8z/jaN9js8zrxXW
         sSEJZzha1e5sCtLhd29NitTswFrvkBYL8IF5AAURWDeqNqAN+PGjnxazFV2rtyuxVZ+E
         TRyggrm/7YMzxbtOBIfUJNg4j2x2silhfJQSGPJUIuFvvWFivzwZrLjjRzDupSMjTj7V
         /IzfHhi93AOHiXZXn+BR2N/0fUQrKg9dQw5d38TxaoVEmhzgX49FNqWHI+/O+6lDNOso
         EUSBoQo6KkCv2O1Mj6lk2rXxIioy38rOW1qOLvlfn+e2HOvy8W4q/yWmJHeRVA+qnLp5
         j5xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jtS9ZIUBeGm+Car1XcRrWGY+RpAJ9p6p/GMgJGpuzSA=;
        b=mOTp+tqM+eMpJ1emgWSTZAtlOPVW1xmWNW38r/eebk96BDcDlMcLIHsIrhgPd8nUDv
         xxz+dM03zdtf2PYHJtcEnPgUfRzCyzAUQHUKyQYtXtUnNBs1xcPWxbGvI6XS8hjuF90y
         fWoVHIpHG4ZeOw9HSSNMt6JVSDsQx1k87FwQ/59LuYSz8Fb52WPKQOBCu15A7VK5Psgw
         /PsXavNq6I7N0Ga5jqexHHs3tZ2POD32UMX4FlCw+yRYoIN/TRLGFVVnZn3N6oNiQKLw
         LUiRI0hgxYmrjXvAIsZo8Nt9JrJGmdC1UyukrSAYGWPIG7ZomM5EFxHYy6MM9Mij6bdD
         kCLg==
X-Gm-Message-State: AOAM530bPBzb+vkiRi5oLhBaA3vE09aA9epwn1+cP6/cBoe9gQ/70xOX
        RHFoWnOU7YQIgry9oeTCMUY=
X-Google-Smtp-Source: ABdhPJx0Wk1NO/n3IiIbD1/cNVBH5NsahagRLR2LNU9s4sspmeHZt82MqXE/RUnilbAKvSnv7O+Pvw==
X-Received: by 2002:a05:622a:1454:: with SMTP id v20mr3531885qtx.372.1616492626889;
        Tue, 23 Mar 2021 02:43:46 -0700 (PDT)
Received: from localhost.localdomain ([143.244.44.229])
        by smtp.gmail.com with ESMTPSA id h5sm11677473qko.83.2021.03.23.02.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 02:43:45 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH V2] octeontx2-af: Few mundane typos fixed
Date:   Tue, 23 Mar 2021 15:13:27 +0530
Message-Id: <20210323094327.2386998-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

s/preceeds/precedes/  .....two different places
s/rsponse/response/
s/cetain/certain/
s/precison/precision/

Fix a sentence construction as per suggestion.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 Changes from V1:
  Bad sentence construction missed my eyes , correced by following
  Randy's suggestion.

 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ea456099b33c..8a6227287e34 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -74,13 +74,13 @@ struct otx2_mbox {
 	struct otx2_mbox_dev *dev;
 };

-/* Header which preceeds all mbox messages */
+/* Header which precedes all mbox messages */
 struct mbox_hdr {
 	u64 msg_size;	/* Total msgs size embedded */
 	u16  num_msgs;   /* No of msgs embedded */
 };

-/* Header which preceeds every msg and is also part of it */
+/* Header which precedes every msg and is also part of it */
 struct mbox_msghdr {
 	u16 pcifunc;     /* Who's sending this msg */
 	u16 id;          /* Mbox message ID */
@@ -277,8 +277,8 @@ struct msg_req {
 	struct mbox_msghdr hdr;
 };

-/* Generic rsponse msg used a ack or response for those mbox
- * messages which doesn't have a specific rsp msg format.
+/* Generic response msg used an ack or response for those mbox
+ * messages which don't have a specific rsp msg format.
  */
 struct msg_rsp {
 	struct mbox_msghdr hdr;
@@ -299,7 +299,7 @@ struct ready_msg_rsp {

 /* Structure for requesting resource provisioning.
  * 'modify' flag to be used when either requesting more
- * or to detach partial of a cetain resource type.
+ * or to detach partial of a certain resource type.
  * Rest of the fields specify how many of what type to
  * be attached.
  * To request LFs from two blocks of same type this mailbox
@@ -489,7 +489,7 @@ struct cgx_set_link_mode_rsp {
 };

 #define RVU_LMAC_FEAT_FC		BIT_ULL(0) /* pause frames */
-#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precison time protocol */
+#define RVU_LMAC_FEAT_PTP		BIT_ULL(1) /* precision time protocol */
 #define RVU_MAC_VERSION			BIT_ULL(2)
 #define RVU_MAC_CGX			BIT_ULL(3)
 #define RVU_MAC_RPM			BIT_ULL(4)
--
2.31.0

