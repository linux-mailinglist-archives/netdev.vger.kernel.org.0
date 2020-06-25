Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8342F20A210
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 17:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405841AbgFYPg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 11:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405394AbgFYPg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 11:36:26 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 888CBC08C5C1;
        Thu, 25 Jun 2020 08:36:26 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id i4so3405027pjd.0;
        Thu, 25 Jun 2020 08:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y3kkWJ/JOzzDXyxNZr6XcUI/1J7xSry3mHpwhIQzL+E=;
        b=OMVoJg1tPn70JBLaclMof0/+Dc7ez6g+JlgUw2qkgyFZprwMTXR96TOGPWXMLf1iTc
         qNPxlfS6d/2f0VA+ob9zAbZeyRBcRe3YGZ3pCRYTJqeYrGj9uU2SWnmd2UC9eYLeOmoU
         wP8E6ECohKGe61Ct78Xm6xD8+wqiWKprtxWFvDjIol2lWrh6v+0syC0Rm05WqPXTXym6
         T2k8dONjQjXQe5IyDlRNBh6huh42wiiXtt4C+2/66o/yvnsYsVp4vUhHXLSVeZcaT0U9
         tFYhhABhzFzefIM934Erz3dlwdn5Ct3EDsrVY4yBV8Lz4zDisKpk1zLPvn98noofsij9
         hezw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y3kkWJ/JOzzDXyxNZr6XcUI/1J7xSry3mHpwhIQzL+E=;
        b=FPVV+2MdwxrolNTzkkvwoxxZeLhSCZ8tBLVwZ8B3KyJOF8Kw4MDEZcRH65FWgPv4uq
         g+e2+lxFQCj89WYEsea8ULD38ue49upYnrArvNR/Wvlh59agFxIK/c30lpxEOGA0B3nc
         GQdeefTiDqREvdaDw5JA247lccbxfkGZ8HYqRm+xtS9jMa6ZWB4O77ihaokDl0BB0tMx
         hu0rSBDefTo3V5nlhRdolHZRUw/9MN3FmC6zwbctCmyUQu84wHttKL8YOzrwdRNw7Wul
         qMr/FcEbiFqZY62aBKBtLTRQEEE1mcFNHTh2sXRDCacPMA3r38V15/9u+PZce5F8RUnb
         cyng==
X-Gm-Message-State: AOAM533otpiWOtoBMtITsvEVmeUVz4XWUyHbA6V26mgZNXTKDf+ekTkx
        Pk0YCdfabseTobJw1hepCto=
X-Google-Smtp-Source: ABdhPJwFb0pWt9Rj/wa4mbgHdYQwaBWsYomXSN7c8EZ8E45HhDdKTr397uSuflAWFZM9ti4g8cageg==
X-Received: by 2002:a17:90a:1b69:: with SMTP id q96mr4072875pjq.198.1593099386081;
        Thu, 25 Jun 2020 08:36:26 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id f6sm25413406pfe.174.2020.06.25.08.36.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 08:36:25 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] fix trailing */ in block comment
Date:   Thu, 25 Jun 2020 23:36:13 +0800
Message-Id: <20200625153614.63912-2-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200625153614.63912-1-coiby.xu@gmail.com>
References: <20200625153614.63912-1-coiby.xu@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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

