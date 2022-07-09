Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D348B56C96E
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 14:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiGIMot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 08:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiGIMot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 08:44:49 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3FFF4C639;
        Sat,  9 Jul 2022 05:44:43 -0700 (PDT)
X-QQ-mid: bizesmtp89t1657370648tq64gdvv
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 20:44:05 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000B00A0000000
X-QQ-FEAT: 89zkXg0mlYZO48zndYkhgG+NXJJJj15O7inoRCXCj2z1xHrOcCFfZXlNufKds
        VmAApYwCEqONtsUZMVdrG6B/Qx/MUk9OUZW3nI+i7Ko3qemdHGlfbJUbONRY7W5dLb6Egl6
        m1krrpiFISbYr9n/M4W7h3D/sJxvaarb9s6Yv7S7GvnaO/pzEXGg95t18MAMIGQrmhE1sqN
        xi8zauKRH0sUUjcRu9QtBAUk1wwthxspHZJtaPviWgzbLd8Ei/GysDcjOILgCFxInrJWkBa
        naARImL0cq4vaqQG3LLP2MQyxEpPHDdrOpsxxjThbMTR7Gus1zUxSggRa5w8jDvKSMij5n+
        5d3/wz5QejSVGm8LzUSw/3dea6U5U8UIyUCAIIq
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     wcn36xx@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: wcn36xx: fix repeated words in comments
Date:   Sat,  9 Jul 2022 20:43:56 +0800
Message-Id: <20220709124356.52543-1-yuanjilin@cdjrlc.com>
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

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 46a49f0a51b3..a1afe1f85f0e 100644
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
 
@@ -4142,7 +4142,7 @@ struct wcn36xx_hal_dump_cmd_rsp_msg {
 	/* Length of the responce message */
 	u32 rsp_length;
 
-	/* FIXME: Currently considering the the responce will be less than
+	/* FIXME: Currently considering the responce will be less than
 	 * 100bytes */
 	u8 rsp_buffer[DUMPCMD_RSP_BUFFER];
 } __packed;
-- 
2.36.1

