Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57A3549D27
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 21:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343578AbiFMTO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 15:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231962AbiFMTOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 15:14:42 -0400
Received: from smtpbg.qq.com (smtpbg123.qq.com [175.27.65.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 360833524F;
        Mon, 13 Jun 2022 10:33:14 -0700 (PDT)
X-QQ-mid: bizesmtp86t1655141323ts5rjl84
Received: from localhost.localdomain ( [223.198.87.69])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 14 Jun 2022 01:28:24 +0800 (CST)
X-QQ-SSF: 01000000008000C0I000B00A0000000
X-QQ-FEAT: qd+n8kjduJOL9mL+qbz/S+IdFhzIP1C9Pp5ki6IN83DZRU31j+HxGWsZ3XOXZ
        VTfkLU6frAU7tzVH3SzqsIucu9KcyCPyRFuVHyJyJgnNNWBwpt8NhRun6/0TLscJ/1wg6oR
        VWTNbmIG+B4njX4wduZYKWzqQW865ECTx7IfQnA4GNyCoK0C8x65Ysv87mSup24r8jcjRKh
        odfIR8m/j2TdZ8aQw1aU4hPiQZmLGviQX+Y0aDswiS7M6ldOnq7qlN73TTo8coddp6ZrJal
        n6s3qfzlBJ+KA/ZK/PFMTmDTm3Rcnr0qnnfpLRl7AYM1QnUB11cQreDRM=
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     kvalo@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, loic.poulain@linaro.org,
        wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] wcn36xx: Fix typo in comment
Date:   Tue, 14 Jun 2022 01:28:18 +0800
Message-Id: <20220613172818.7491-1-wangxiang@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'the'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 46a49f0a51b3..874746b5993c 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -1961,7 +1961,7 @@ struct wcn36xx_hal_config_bss_params {
 
 	/* HAL should update the existing BSS entry, if this flag is set.
 	 * UMAC will set this flag in case of reassoc, where we want to
-	 * resue the the old BSSID and still return success 0 = Add, 1 =
+	 * resue the old BSSID and still return success 0 = Add, 1 =
 	 * Update */
 	u8 action;
 
@@ -2098,7 +2098,7 @@ struct wcn36xx_hal_config_bss_params_v1 {
 
 	/* HAL should update the existing BSS entry, if this flag is set.
 	 * UMAC will set this flag in case of reassoc, where we want to
-	 * resue the the old BSSID and still return success 0 = Add, 1 =
+	 * resue the old BSSID and still return success 0 = Add, 1 =
 	 * Update */
 	u8 action;
 
-- 
2.36.1

