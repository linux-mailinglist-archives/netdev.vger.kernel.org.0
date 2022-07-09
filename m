Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 989F956C961
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 14:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiGIMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 08:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIMdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 08:33:15 -0400
X-Greylist: delayed 74571 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 09 Jul 2022 05:33:09 PDT
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF87E17E03;
        Sat,  9 Jul 2022 05:33:09 -0700 (PDT)
X-QQ-mid: bizesmtp82t1657369958tkb4jeu2
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 20:32:15 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: 2y6l/C9CgvuTB3CSaiaIXWePfVtVmlUFyEU2Pp2+wmActmh89r3aVOCDl9kXP
        zketmaxcnJ4HNXno09F9ppO8I5OKkaXYI/6TIcldsYNiJc25Yv1IOAXA+snUC27qdhna0xf
        uJe/PFdEnVZZ7w+UaQI2hVpkdIZ8Bf1e/v+L62EjPxiSTbEEBXW1ucUoQSwXs5xsJ3IqSYv
        yrnFyp9LSe6bTtSCKFvhgX+UXm2UyJ8/MQuYg/9Arhnn+KIB7cXako4isE5c2fjS8p7pXvV
        jdghPMVHAbw0Iai5XQcZ6uorhrkn+a6PxiGFrm3jXI/Eb00clCuWIkZkltmCqt4fJSunPxA
        kviCXfJVhxtE8nUXNz7MNtG5SDjIQ==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: ath6kl:: fix repeated words in comments
Date:   Sat,  9 Jul 2022 20:32:08 +0800
Message-Id: <20220709123208.41736-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.
 Delete the redundant word 'of'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/ath6kl/hif.h  | 2 +-
 drivers/net/wireless/ath/ath6kl/sdio.c | 2 +-
 drivers/net/wireless/ath/ath6kl/wmi.h  | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

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
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index 672014973cee..7eeb7ea68518 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -698,7 +698,7 @@ enum auth_mode {
 
 /*
  * NB: these values are ordered carefully; there are lots of
- * of implications in any reordering.  In particular beware
+ * implications in any reordering.  In particular beware
  * that 4 is not used to avoid conflicting with IEEE80211_F_PRIVACY.
  */
 #define ATH6KL_CIPHER_WEP            0
-- 
2.36.1

