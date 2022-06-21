Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 640CA552D44
	for <lists+netdev@lfdr.de>; Tue, 21 Jun 2022 10:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347731AbiFUIm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 04:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347120AbiFUImw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 04:42:52 -0400
Received: from smtpbg.qq.com (smtpbg139.qq.com [175.27.65.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB6E126103;
        Tue, 21 Jun 2022 01:42:47 -0700 (PDT)
X-QQ-mid: bizesmtp62t1655800827thxhgv8l
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Tue, 21 Jun 2022 16:40:20 +0800 (CST)
X-QQ-SSF: 0100000000700020B000B00A0000000
X-QQ-FEAT: PdU/eI8FBMBl1IdPvcHmsGWurxRZzc3gyPCrL4rg/Mk3lwQDrh4gAyv3C7N0L
        KelugZBJLjhQWTxYgGr3xCpgZ5yH5Q1cmxNvpXO7Qzv7vKsJE8o3vN5xiiG9K7Vm42BciDK
        UY9U8QhAD+wlpaf4YrC37MXy1gmTdK81v4imci1owLTB0QTP+A2urjZV3pg3LZkzaxJ6Uxd
        riWMGpoyGvzp2GlwxBdeoDS2+QgX6u0JeOGXDxAdi0HW22ua5h4ZZiWR0fRR18ESPsKXIs3
        5HVoqI8KCl0tB4oqYB9ULTE4nbLi3RPG9xAGIMGKRGXDR5f9Xj2XpXshfl+F42Hn5tNIDkc
        4Jspl6o
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     loic.poulain@linaro.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] wcn36xx: remove unexpected word "the"
Date:   Tue, 21 Jun 2022 16:40:18 +0800
Message-Id: <20220621084018.56335-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word "the" in the comments that need to be removed

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/wireless/ath/wcn36xx/hal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/hal.h b/drivers/net/wireless/ath/wcn36xx/hal.h
index 46a49f0a51b3..a36d9af69225 100644
--- a/drivers/net/wireless/ath/wcn36xx/hal.h
+++ b/drivers/net/wireless/ath/wcn36xx/hal.h
@@ -1961,7 +1961,7 @@ struct wcn36xx_hal_config_bss_params {
 
 	/* HAL should update the existing BSS entry, if this flag is set.
 	 * UMAC will set this flag in case of reassoc, where we want to
-	 * resue the the old BSSID and still return success 0 = Add, 1 =
+	 * resue the old BSSID and still return success 0 = Add, 1 =
 	 * Update */
 	u8 action;
 
-- 
2.17.1

