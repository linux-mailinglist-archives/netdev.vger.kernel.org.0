Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FA56C9B3
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 15:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbiGINx4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 09:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiGINxx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 09:53:53 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F031120;
        Sat,  9 Jul 2022 06:53:45 -0700 (PDT)
X-QQ-mid: bizesmtp88t1657374806tsc63ebp
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 21:53:22 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: rl11S5XfjROmodCS3QjJDmHwffQNuDJ6HOK8x0NH5FW6lTuC5ig1Ym3b4yQrx
        nElxIau1yJDjh+A4vmQVH17OPlXcRmErNPbjUNTzkeu7zFusCqGQfVE8Aku752c0u0KIv/7
        z8DWKw3Ox6rNjx1ncw1bgUQg8lYI00BFZqh9VrFUXnrQ+RG/6+cAvCdhdkCsd1WwXECeFDu
        qsLVrp/aHcV1P63wOD3iCtaBH7p8c3uulq2yTLM+3r3UAMzNtNssLXsdJ3c09HRgO5xgbqW
        H9sy0h6+SH6ang/dG/0WzOyatALL2aW25fcEVmwbZfsgtXwZXUJ50w6MUp1q86/kG6rMhLQ
        UyOYjJv6U+S+nx9P9ohTGQrafoQ7tSVv7OsJEZ7pBoEyfKTjqiaIwJ6TRLsHw==
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, stf_xl@wp.pl
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: iwlegacy: fix repeated words in comments
Date:   Sat,  9 Jul 2022 21:53:16 +0800
Message-Id: <20220709135316.41425-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'to'.
 Delete the redundant word 'if'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-mac.c | 2 +-
 drivers/net/wireless/intel/iwlegacy/common.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-mac.c b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
index d93900e62e3d..943de47170c7 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-mac.c
@@ -6690,7 +6690,7 @@ il4965_pci_remove(struct pci_dev *pdev)
 	sysfs_remove_group(&pdev->dev.kobj, &il_attribute_group);
 
 	/* ieee80211_unregister_hw call wil cause il_mac_stop to
-	 * to be called and il4965_down since we are removing the device
+	 * be called and il4965_down since we are removing the device
 	 * we need to set S_EXIT_PENDING bit.
 	 */
 	set_bit(S_EXIT_PENDING, &il->status);
diff --git a/drivers/net/wireless/intel/iwlegacy/common.c b/drivers/net/wireless/intel/iwlegacy/common.c
index 8299d89e7505..e40c4c41de10 100644
--- a/drivers/net/wireless/intel/iwlegacy/common.c
+++ b/drivers/net/wireless/intel/iwlegacy/common.c
@@ -4816,7 +4816,7 @@ il_check_stuck_queue(struct il_priv *il, int cnt)
 #define IL_WD_TICK(timeout) ((timeout) / 4)
 
 /*
- * Watchdog timer callback, we check each tx queue for stuck, if if hung
+ * Watchdog timer callback, we check each tx queue for stuck, if hung
  * we reset the firmware. If everything is fine just rearm the timer.
  */
 void
-- 
2.36.1

