Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90C993456C1
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 05:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbhCWE3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 00:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhCWE2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 00:28:25 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D156FC061574;
        Mon, 22 Mar 2021 21:28:24 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id c6so14098434qtc.1;
        Mon, 22 Mar 2021 21:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQxVkNiVM8UV8IHnKGNUWqzyC2HDMRY5fES8wozWivI=;
        b=hcyJutkUV28x+qZD/KN5G4F59DEugD7nt3R5RX7R7+QhAiskjWduYqqQ+6PBHEmWy3
         M7WWlk+IlayTPLVpzK2h9AXIutQZNhjH6gj3eM9Kkn7X6pl6rJdAGys2slz2UOIgayZj
         0e9dJK/IPm1pSuq1KDCaaM485tGBgCkksx3zrX1w8X/h2dpkTagCzvYxJg87ahQZ8rDC
         u15GnF/TQ3Gb4U+6oCYCfmOuoJgseHrjujbKMBEu+I+gbgY0M+l5V84kLelCntjsbZRj
         wp+ugwG2wA/NMl2g1HulmR2YvJyaB6L9G+TqgSSZJ4ppmpZqsdqRea/I3MNM02E3CBhn
         u7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BQxVkNiVM8UV8IHnKGNUWqzyC2HDMRY5fES8wozWivI=;
        b=U+6oRNRC0HHAhK9VZyiCNdqCLP6+Kv4CdvI5a62TBOMVHNk2/1YMvWeP/yCYxtQPyN
         rGp9yQ98FaYMug3fi2HdSrqC/HjCSyUZsyLqTlva5R9Ef3DNnI5DO4ge5+7wg5E+PpXl
         5DDeoPjUgMbWax5c126ncieQ/+mQCcRR3oOhrJgn13NbmVQyxODA3fqZYcCU6m+QZmHW
         lNSVqiFCcKwuJ+/ghAT4G+f04ATTfobwdb/EXk2DR51/fElSE8QzEdwIwFiN58puKwOc
         /E3jR3nsQuqfXx8ez0Dyk/oZF1eg69KEm2iVL8arWYRPfhEyhDhBQXJ/Yx2TVbqKvXpn
         rDgw==
X-Gm-Message-State: AOAM5333OsXTxhDzvEUksuDhKZiqvvEfOdF1m430bmWl5fgnuKyYO0FM
        LZMPn1pjOlSmH8gyS6COjlA=
X-Google-Smtp-Source: ABdhPJzkX04ovpUYRkWxYCvb5rMf/hVg9BEa2oUv9weCYG22NY/KKXelqFOMF7N3Ihmio9fmmSIBzQ==
X-Received: by 2002:ac8:7951:: with SMTP id r17mr2957175qtt.207.1616473703933;
        Mon, 22 Mar 2021 21:28:23 -0700 (PDT)
Received: from localhost.localdomain ([156.146.54.208])
        by smtp.gmail.com with ESMTPSA id j26sm10341273qtp.30.2021.03.22.21.28.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 21:28:23 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        jerinj@marvell.com, hkelam@marvell.com, sbhatta@marvell.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] octeontx2-af: cn10k: Few mundane typos fixed
Date:   Tue, 23 Mar 2021 09:58:00 +0530
Message-Id: <20210323042800.923096-1-unixbhaskar@gmail.com>
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

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index ea456099b33c..14a184c3f6a4 100644
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
@@ -277,7 +277,7 @@ struct msg_req {
 	struct mbox_msghdr hdr;
 };

-/* Generic rsponse msg used a ack or response for those mbox
+/* Generic response msg used a ack or response for those mbox
  * messages which doesn't have a specific rsp msg format.
  */
 struct msg_rsp {
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

