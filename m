Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5147020C09D
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 12:15:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgF0KPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 06:15:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726356AbgF0KPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 06:15:01 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 631BAC03E979;
        Sat, 27 Jun 2020 03:15:01 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 207so5574233pfu.3;
        Sat, 27 Jun 2020 03:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zvZtbrDBRF/tkY1XUgsUhw4qRWkNkbAOPkZ951cjMrY=;
        b=lWBq5lH1N4RNQEpfj4eXQ3XAEunPzNYAXDbCI/Z/KigFjM8fvvqV3Qm+vX+BkkPExK
         hU4P+VxxMziUIdO+NoiUCj8SqFfyncwHiayLHNKJlwI51ZLM2Tcw9A50g006FLTrgkOu
         BDp90GoE2TC7lRPJkHHDoiPDN7w1udpQu5t15fmrmu7Z0ZiS81gdIkeuy2Wmob6+geNm
         Zgk4Jr+pyqnhpUjx9J2/WDknrPyXfxtWVWzu0ZnJeeLAUdsUI17uE7E97HA3nOadOs9O
         M3q++pGSOyT+jZhbZ/iI646vq8k6ThRjFFGqgU8oBKdXA4sQoTzOmsXzZuJ/h77or8cD
         h+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zvZtbrDBRF/tkY1XUgsUhw4qRWkNkbAOPkZ951cjMrY=;
        b=HncR8d8aYn95GeQKubftsfZTNcB0YwY0DhQitAW2h4YU3l9g/4tO5Ua/zPL7D3QSx1
         9rb6UZ9Uuon81MpW/5tsYzASNQltmQIVPefKzlbc8Co0uLFoKx49etPRVmvbsrglhiYm
         PUcmOfE4Sv+Ngv6HCA3G0V7mBP34rT4L7EA4IsXq4JtudF7QpwJzSaohviL3qpt0G63T
         amyFwDEgTzV/UXhPMi18MlkK9MtUmkKDoQ9NnVUQjZpH2fYu2DBr91ldemXRZeUvjKU2
         gVhKewsqI5H/W1+p9KESbDuHvBJvzcKSmQH/J4N3lu7qzlSrno1oH661hX2AUbTdI7rh
         /HRg==
X-Gm-Message-State: AOAM531DLR+4bXBV31cU7miJ9wWxayfPvEje+NmBNA7spvg+wkc9Dlan
        J4nEBTgNtzUaeru3pOVOCkg=
X-Google-Smtp-Source: ABdhPJxwFvGhZ5/vaZU76/wPRYf7RJ85weAZ+H1vcEX5LZNHMLFX8MVMfbdlW3uRtOwZ1QUWNyclhw==
X-Received: by 2002:a62:fc4c:: with SMTP id e73mr1580773pfh.308.1593252900940;
        Sat, 27 Jun 2020 03:15:00 -0700 (PDT)
Received: from localhost ([2001:e42:102:1532:160:16:113:140])
        by smtp.gmail.com with ESMTPSA id f15sm9624849pfk.58.2020.06.27.03.14.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2020 03:15:00 -0700 (PDT)
From:   Coiby Xu <coiby.xu@gmail.com>
To:     devel@driverdev.osuosl.org
Cc:     joe@perches.com, dan.carpenter@oracle.com,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com (supporter:QLOGIC QLGE 10Gb ETHERNET
        DRIVER), Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org (open list:QLOGIC QLGE 10Gb ETHERNET DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/4] fix trailing */ in block comment
Date:   Sat, 27 Jun 2020 18:14:44 +0800
Message-Id: <20200627101447.167370-2-coiby.xu@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200627101447.167370-1-coiby.xu@gmail.com>
References: <20200627101447.167370-1-coiby.xu@gmail.com>
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

