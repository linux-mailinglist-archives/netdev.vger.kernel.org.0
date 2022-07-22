Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4159E57DC52
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbiGVI11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiGVI11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:27:27 -0400
Received: from mail-m974.mail.163.com (mail-m974.mail.163.com [123.126.97.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 924DF9B9C3;
        Fri, 22 Jul 2022 01:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=AWklX
        y87aAjJGpkYMEqAbUQ8m/hTyCJ+QZEc8p4iaYo=; b=aFWESxcB9jjmFLPcxcwR6
        16Ct1Q03mNIzWtsbfiDv+x5nXPOaVaQDNqvgFWEk00eB+DDGq6z6Q8YX8jjJn5Vu
        Ehtraigx9pGpsqvZQ03LThlNBQXbqw0zMmOsFMMKx/s66wQvppzBmhIYJpAhOVJs
        UxzHpJCoHAeyt7I4I3q28g=
Received: from localhost.localdomain (unknown [112.97.59.29])
        by smtp4 (Coremail) with SMTP id HNxpCgBntYVQX9pilNF2QA--.22010S2;
        Fri, 22 Jul 2022 16:26:58 +0800 (CST)
From:   Slark Xiao <slark_xiao@163.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, loic.poulain@linaro.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, wcn36xx@lists.infradead.org,
        Slark Xiao <slark_xiao@163.com>
Subject: [PATCH] wireless: ath: Fix typo 'the the' in comment
Date:   Fri, 22 Jul 2022 16:26:53 +0800
Message-Id: <20220722082653.74553-1-slark_xiao@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: HNxpCgBntYVQX9pilNF2QA--.22010S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCFWfWw17CFWDCryfAF17Awb_yoW5CFyUpF
        WrC392kr1kJF4DXw4xJF48AF95GanxKr9Fkr1vv34rZrW8AFn5KFyYgFWfAFyDta1DG3Wa
        vF1Utry7GFnaq37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pE66w-UUUUU=
X-Originating-IP: [112.97.59.29]
X-CM-SenderInfo: xvod2y5b0lt0i6rwjhhfrp/1tbiRxJGZFc7YxB8MQAAsl
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace 'the the' with 'the' in the comment.

Signed-off-by: Slark Xiao <slark_xiao@163.com>
---
 drivers/net/wireless/ath/ath6kl/hif.h       | 2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c      | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 drivers/net/wireless/ath/wcn36xx/hal.h      | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/hif.h b/drivers/net/wireless/ath/ath6kl/hif.h
index f9d3f3a5edfe..ba16b98c872d 100644
--- a/drivers/net/wireless/ath/ath6kl/hif.h
+++ b/drivers/net/wireless/ath/ath6kl/hif.h
@@ -92,7 +92,7 @@ struct bus_request {
  *     emode - This indicates the whether the command is to be executed in a
  *             blocking or non-blocking fashion (HIF_SYNCHRONOUS/
  *             HIF_ASYNCHRONOUS). The read/write data paths in HTC have been
- *             implemented using the asynchronous mode allowing the the bus
+ *             implemented using the asynchronous mode allowing the bus
  *             driver to indicate the completion of operation through the
  *             registered callback routine. The requirement primarily comes
  *             from the contexts these operations get called from (a driver's
diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 6b51a2dceadc..8a43c48ec1cf 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -1185,7 +1185,7 @@ static int ath6kl_sdio_bmi_read(struct ath6kl *ar, u8 *buf, u32 len)
 	 *        Wait for first 4 bytes to be in FIFO
 	 *        If CONSERVATIVE_BMI_READ is enabled, also wait for
 	 *        a BMI command credit, which indicates that the ENTIRE
-	 *        response is available in the the FIFO
+	 *        response is available in the FIFO
 	 *
 	 *  CASE 3: length > 128
 	 *        Wait for the first 4 bytes to be in FIFO
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index dc0e5ea25673..090ff0600c81 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1744,7 +1744,7 @@ static void ar9003_hw_spectral_scan_config(struct ath_hw *ah,
 	REG_SET_BIT(ah, AR_PHY_RADAR_0, AR_PHY_RADAR_0_FFT_ENA);
 	REG_SET_BIT(ah, AR_PHY_SPECTRAL_SCAN, AR_PHY_SPECTRAL_SCAN_ENABLE);
 
-	/* on AR93xx and newer, count = 0 will make the the chip send
+	/* on AR93xx and newer, count = 0 will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 874746b5993c..a1afe1f85f0e 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -4142,7 +4142,7 @@ struct wcn36xx_hal_dump_cmd_rsp_msg {
 	/* Length of the responce message */
 	u32 rsp_length;
 
-	/* FIXME: Currently considering the the responce will be less than
+	/* FIXME: Currently considering the responce will be less than
 	 * 100bytes */
 	u8 rsp_buffer[DUMPCMD_RSP_BUFFER];
 } __packed;
-- 
2.25.1

