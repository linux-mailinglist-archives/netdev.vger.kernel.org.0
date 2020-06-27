Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF94A20C291
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 17:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgF0O7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 10:59:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725922AbgF0O7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 10:59:12 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11144C061794;
        Sat, 27 Jun 2020 07:59:12 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id d6so6156923pjs.3;
        Sat, 27 Jun 2020 07:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvZtbrDBRF/tkY1XUgsUhw4qRWkNkbAOPkZ951cjMrY=;
        b=bjr0POXXaMCOymlz4SgDHKbO1AYNXz9oYSXbPnaECMs7PocSZpzV0uxbtqo4PnCcvQ
         4v3LL4MczAKdpgUbDJ9zIr1Ssb8BFxeX1h7ej2fA4rP76uLOX6oLVajgPWcl6aE/BU66
         EMXqQg+EA/bgGvIj6dAIoMoy8Ge7yfyQwOV8b6h9rrZvkSmEpUQgTVHgDMPS2meAnVUS
         RljkKPuJzGRqzoMylOmM+eXzKTTWxacfu5NdAyQrBwif/54skhHkA/BefmcyI+ywwbYG
         bFQwTDTPbiMjhQu+7Hki0ZTuhhPt145Qj0c+ig46vxKH8SMhE88t6aTYwq450zIeXEJG
         8fhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvZtbrDBRF/tkY1XUgsUhw4qRWkNkbAOPkZ951cjMrY=;
        b=kR/GfE9iXCo/B0KjpuPEk1E4j+BX7Zx+y9EmPQbdTuWS0YHi4aDaHE4z1z2LS/l/3C
         UGnCBVrWFIMOMRom1i3Qep5CQR0juP7ICbO1DKStVP0adROd9dMLTlyUcmEUZKVlqlDn
         iCbwfQOnJtCz9Bm2RNfdDG+oFl0kpsRh8uoobGc0ogO/PNIpR2g/j8AXF6Vt8XF/0Bip
         QW/FYG1EToZgP7M7QZGM5dTE45UdKZaCHBOqzsSbOZBb0CPajlmqOpKFlTQEhNt3wIDS
         DrbNKaTrSekbb0cK36XgSSIML0ZzM6yrr5Z2/dR4XTpVMmuEtTu0mDeQcoHknSsQ1GYy
         MqRg==
X-Gm-Message-State: AOAM532aPvC6E4uTRXloZl8QVxILwREZ8waVUPWfSe6pYC5Oh6h0tI+S
        6oSAtcxd2/kdy+9mp0kNIkE=
X-Google-Smtp-Source: ABdhPJzFnW3F/3yWFP0IF5Wn1W1Qyd+qjEZB8LeeQUjOgxLy4iwMEGSjBbzXZcVjLXznMCuHI4cX0Q==
X-Received: by 2002:a17:90a:e018:: with SMTP id u24mr8583786pjy.204.1593269951699;
        Sat, 27 Jun 2020 07:59:11 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id a29sm28631118pfg.201.2020.06.27.07.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 07:59:11 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     joe@perches.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER),
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 1/4] staging: qlge: fix trailing */ in block comment
Date:   Sat, 27 Jun 2020 22:58:54 +0800
Message-Id: <20200627145857.15926-2-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200627145857.15926-1-coiby.xu@gmail.com>
References: <20200627145857.15926-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove trailing "*/" in block comments.

Signed-off-by: Coiby Xu <coiby.xu@gmail.com>
---
 drivers/staging/qlge/qlge_main.c |  3 ++-
 drivers/staging/qlge/qlge_mpi.c  | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 1650de13842f..aaecf2b0f9a1 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3244,7 +3244,8 @@ static void ql_set_irq_mask(struct ql_adapter *qdev, struct intr_context *ctx)
 		 */
 		ctx->irq_mask = (1 << qdev->rx_ring[vect].cq_id);
 		/* Add the TX ring(s) serviced by this vector
-		 * to the mask. */
+		 * to the mask.
+		 */
 		for (j = 0; j < tx_rings_per_vector; j++) {
 			ctx->irq_mask |=
 			(1 << qdev->rx_ring[qdev->rss_ring_count +
diff --git a/drivers/staging/qlge/qlge_mpi.c b/drivers/staging/qlge/qlge_mpi.c
index 60c08d9cc034..3bb08d290525 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -389,7 +389,8 @@ static void ql_init_fw_done(struct ql_adapter *qdev, struct mbox_params *mbcp)
  *  This can get called iteratively from the mpi_work thread
  *  when events arrive via an interrupt.
  *  It also gets called when a mailbox command is polling for
- *  it's completion. */
+ *  it's completion.
+ */
 static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
@@ -520,7 +521,7 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * changed when a mailbox command is waiting
 	 * for a response and an AEN arrives and
 	 * is handled.
-	 * */
+	 */
 	mbcp->out_count = orig_count;
 	return status;
 }
@@ -555,7 +556,8 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * here because some AEN might arrive while
 	 * we're waiting for the mailbox command to
 	 * complete. If more than 5 seconds expire we can
-	 * assume something is wrong. */
+	 * assume something is wrong.
+	 */
 	count = jiffies + HZ * MAILBOX_TIMEOUT;
 	do {
 		/* Wait for the interrupt to come in. */
@@ -1178,7 +1180,7 @@ void ql_mpi_idc_work(struct work_struct *work)
 		/* Signal the resulting link up AEN
 		 * that the frame routing and mac addr
 		 * needs to be set.
-		 * */
+		 */
 		set_bit(QL_CAM_RT_SET, &qdev->flags);
 		/* Do ACK if required */
 		if (timeout) {
--
2.27.0

