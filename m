Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F01158FBCA
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiHKMBi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235106AbiHKMBb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:01:31 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938169677F;
        Thu, 11 Aug 2022 05:01:20 -0700 (PDT)
X-QQ-mid: bizesmtp76t1660219254t3aqw9fh
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 20:00:53 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000000
X-QQ-FEAT: qcKkmz/zJhyFwIFRW/S+BormVTTMr+aQcws5VFd79+EcYEvhMhQnzn17Hxo2I
        LSp+OOFUhUyNOum8t8MfUwBfRQyJTHSD0FCJOORYaPaPS7KSHwj7py/I8YNwVgvSAkm1PCQ
        Vh+GMDqn34qqDqp3ezsCDbUnF2eVXTXLlaGfkl/7xllbCVBk/DQmHbBfivxuLcYLrWxPr+t
        zsbq8B10jh1ph+N36jPLX/XEFG1TucVMilVG432ddk0TRrnOEDQIsuUDeET925pHqpLA3ks
        WmpGMENeshftj1guUYHtWy89+pdM4AgRwgqcZXSHE/L6renEDrftZnMCBaQTKG3AgtpptsU
        9hP2ShGDFp2fYKc0FZcGC5fMmmd55u/ma4IItmmhe9hcwdLDuRQ7Jy/ZmCvqg==
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     gregory.greenman@intel.com, kvalo@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mkl@pengutronix.de,
        keescook@chromium.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] iwlwifi: Fix comment typo
Date:   Thu, 11 Aug 2022 20:00:45 +0800
Message-Id: <20220811120045.9422-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `only' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/commands.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
index 75a4b8e26232..5c81de8f1a17 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/commands.h
@@ -2021,7 +2021,7 @@ struct iwl_spectrum_notification {
 	u8 channel;
 	u8 type;		/* see enum iwl_measurement_type */
 	u8 reserved1;
-	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only only
+	/* NOTE:  cca_ofdm, cca_cck, basic_type, and histogram are only
 	 * valid if applicable for measurement type requested. */
 	__le32 cca_ofdm;	/* cca fraction time in 40Mhz clock periods */
 	__le32 cca_cck;		/* cca fraction time in 44Mhz clock periods */
-- 
2.36.1

