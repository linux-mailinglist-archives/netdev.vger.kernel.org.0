Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A24AC56C966
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 14:38:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbiGIMiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 08:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGIMiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 08:38:13 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC6071137;
        Sat,  9 Jul 2022 05:38:08 -0700 (PDT)
X-QQ-mid: bizesmtp66t1657370254tzjrdzrn
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 20:37:31 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: eUlXn66MQ6YPndm96X3cpIVz+Cn60QEX4ARGPzL4RKHQMPi4JPJfXnYwbxRON
        CLPWaFxK2Ou/3FpOOauqf6mw3wI6WskzL/ekpPaYuNgeJfdkhsWNX3Icb5j3VQ20Hbr0ZNl
        JfpD2eBrqJw8c7xHk6FHuJ5esDYX0Sv2omsjWxZHYDyjGYmtJHU++muDQAN71dFQCx0L8xZ
        OeJvtZhOdLIKIPVWmeynySDvcYLw+3XJGw+MJ2+D8Hzkhfg1Bt7OPhHhjdy34eTC7s3z0Eh
        wVUFShR7PX2fIAiknwhX797i6GbgYRztspq/CJRZkcdxEVpiP7FTe+Xq2RomZjcoPpGGgCv
        sdDhdl7deIg90FEcCxh1Mm7Au41baOb4dTpv+kzi/Yw6FSkrBE=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     toke@toke.dk, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: ath9k: fix repeated words in comments
Date:   Sat,  9 Jul 2022 20:37:24 +0800
Message-Id: <20220709123724.46525-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr4
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'the'.
 Delete the redundant word 'to'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c | 2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.c | 2 +-
 drivers/net/wireless/ath/ath9k/hw.h         | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index fcfed8e59d29..ebdb97999335 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -498,7 +498,7 @@ static void ar9002_hw_spectral_scan_config(struct ath_hw *ah,
 	else
 		REG_CLR_BIT(ah, AR_PHY_SPECTRAL_SCAN, repeat_bit);
 
-	/* on AR92xx, the highest bit of count will make the the chip send
+	/* on AR92xx, the highest bit of count will make the chip send
 	 * spectral samples endlessly. Check if this really was intended,
 	 * and fix otherwise.
 	 */
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
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 096a206f49ed..450ab19b1d4e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -710,7 +710,7 @@ struct ath_spec_scan {
 /**
  * struct ath_hw_ops - callbacks used by hardware code and driver code
  *
- * This structure contains callbacks designed to to be used internally by
+ * This structure contains callbacks designed to be used internally by
  * hardware code and also by the lower level driver.
  *
  * @config_pci_powersave:
-- 
2.36.1

