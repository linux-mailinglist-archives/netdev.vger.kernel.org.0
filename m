Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BD211BB6A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:16:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfLKSQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:16:24 -0500
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39341 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731213AbfLKSPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:30 -0500
Received: by mail-yb1-f194.google.com with SMTP id o22so9390008ybg.6;
        Wed, 11 Dec 2019 10:15:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iiFVpSnEWoAI5R62qeTqc9Vgw7AEh710Lxji7svUNEA=;
        b=in/Egki09JlpoeSxqCOxyS54KCobNG3vpIsGPsVFTREmPwAUi/ZeSpFrx6P8fQQobC
         Vv3qTbbrCqyyYWFJmz8IZ0xm5V4NKkxX0Z0U24YGnT5pXcVAx8byU32QxsF4z4+EZGDS
         tRJKVGq7+LGTVLWZoTXuSOno05pO7N9HzZytOgcQYxDgnZuMPGAOeA6dqcSz6vkqvhYu
         uCxXxJ6RdpV5IviI/8AP8DDiMUQ0ZE6oFLsmrPlTyGAAhtNO6I5EONPK7By5+MD2X8d0
         EHNhrVd+WZFuP3XYNHjvw5FV3jSR0DRdJ2+2ejC1r+wbuXeyEkSemdhrG26n5KobtTCa
         zvQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iiFVpSnEWoAI5R62qeTqc9Vgw7AEh710Lxji7svUNEA=;
        b=bfiIJPm7Tzo/55R76c6EWU2AZTuq6MvYrnTk/apVKNG8d+OANNYOxivIjZmAX+1DyB
         yOV3hG9VQ4MIQBcAayD38mRK0I80ItrDTQpDZL3bd1ScecH8UGB+DPSgJ2udN8xOv4ej
         RHMEx/EAj1C3W0rohux6/kbveFWvPFlN5NN20TokUUimplbjSX58HQ7/tZ629z+Jzyv6
         n25o5p4xSA9a5Shq0bqPvnE/tulehi3TCMwuVcELSWTEyS9tRIFdDVzai+AvE5W0eqUB
         BPq1mQjZ2iryBmsaRYLKsFPl+FN04Ii7PY6ptiR8jM1m4orazzIt6SHBx59/lLKTkTLo
         oKdg==
X-Gm-Message-State: APjAAAV378sYn8HK+UEVCKuUJHc/5yLQYQib/Y4otdxCuvZoDlvkmOM4
        qJXjdKH5B+Fl2LeqcbyIxCW9BMcHo7Ideg==
X-Google-Smtp-Source: APXvYqz8ZTuisla3xX6/1VncT2Rdnup9D6H8Y6fHzqh3RCHeCkjUNoIJSopgI4hyhYFEN9JsTPWTDg==
X-Received: by 2002:a25:3753:: with SMTP id e80mr955164yba.123.1576088128934;
        Wed, 11 Dec 2019 10:15:28 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id l39sm1361379ywk.36.2019.12.11.10.15.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:28 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 16/23] staging: qlge: Fix WARNING: Block comments use a trailing */ on a separate line
Date:   Wed, 11 Dec 2019 12:12:45 -0600
Message-Id: <8343f9fae11abdd131898a0e6dad5653f7d65cdb.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: Block comments use a trailing */ on a separate line in
qlge_main.c and qlge_mpi.c

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge_main.c |  3 ++-
 drivers/staging/qlge/qlge_mpi.c  | 10 ++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/qlge/qlge_main.c b/drivers/staging/qlge/qlge_main.c
index 024c77518af3..90509fd1d95c 100644
--- a/drivers/staging/qlge/qlge_main.c
+++ b/drivers/staging/qlge/qlge_main.c
@@ -3255,7 +3255,8 @@ static void ql_set_irq_mask(struct ql_adapter *qdev, struct intr_context *ctx)
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
index 4cff0907625b..15c97c935618 100644
--- a/drivers/staging/qlge/qlge_mpi.c
+++ b/drivers/staging/qlge/qlge_mpi.c
@@ -391,7 +391,8 @@ static void ql_init_fw_done(struct ql_adapter *qdev, struct mbox_params *mbcp)
  *  This can get called iteratively from the mpi_work thread
  *  when events arrive via an interrupt.
  *  It also gets called when a mailbox command is polling for
- *  it's completion. */
+ *  it's completion.
+ */
 static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 {
 	int status;
@@ -521,7 +522,7 @@ static int ql_mpi_handler(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * changed when a mailbox command is waiting
 	 * for a response and an AEN arrives and
 	 * is handled.
-	 * */
+	 */
 	mbcp->out_count = orig_count;
 	return status;
 }
@@ -556,7 +557,8 @@ static int ql_mailbox_command(struct ql_adapter *qdev, struct mbox_params *mbcp)
 	 * here because some AEN might arrive while
 	 * we're waiting for the mailbox command to
 	 * complete. If more than 5 seconds expire we can
-	 * assume something is wrong. */
+	 * assume something is wrong.
+	 */
 	count = jiffies + HZ * MAILBOX_TIMEOUT;
 	do {
 		/* Wait for the interrupt to come in. */
@@ -1180,7 +1182,7 @@ void ql_mpi_idc_work(struct work_struct *work)
 		/* Signal the resulting link up AEN
 		 * that the frame routing and mac addr
 		 * needs to be set.
-		 * */
+		 */
 		set_bit(QL_CAM_RT_SET, &qdev->flags);
 		/* Do ACK if required */
 		if (timeout) {
-- 
2.20.1

