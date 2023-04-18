Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA98A6E5FD5
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 13:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbjDRL3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 07:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjDRL3b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 07:29:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7731544AB;
        Tue, 18 Apr 2023 04:29:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 15DE2625AC;
        Tue, 18 Apr 2023 11:29:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0530BC433EF;
        Tue, 18 Apr 2023 11:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681817369;
        bh=5Di3Le3AukaVeIUScEuQo/HCneGbuzQkRSFTX1xQVBY=;
        h=From:Date:Subject:To:Cc:From;
        b=SbdGi2/d/2NgIwj9G59ftW4NXmQ7BvR6uGNGxIhAkEnBgJBMqqtH+GeUCjzjrtiaD
         BfGCGgmBQaUpBMkJAoxWPGCaKyPeLe5pkMUvumcNBlSPiWj5g2KaG1v1d/v2BhuabE
         8ylPo1LQS7QgPUmdFExlvSPfZJVUaDcqoA/SiKe3rH3+PWH9PTGh/2EQiQnOXP9tG5
         ql7Rd+arkR1ArAFHhDCa0xZk4poilJU5Nh7Qvrg8JXxy8TSfuocnaHx2XdiJNBwc0G
         gmpkTlAaW6cysVlLQ6PZdyBHNHzg2iufKnIjo4dnRfsgA32RvTiPhgbGclYKOexHlm
         z+SVCCBLEVbRA==
From:   Simon Horman <horms@kernel.org>
Date:   Tue, 18 Apr 2023 13:29:22 +0200
Subject: [PATCH] wifi: rtw88: Update spelling in main.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230418-rtw88-starspell-v1-1-70e52a23979b@kernel.org>
X-B4-Tracking: v=1; b=H4sIABF/PmQC/x2NSwqDUAwAryJZN6DW2tdeRbqIMa2Bx6sk9gPi3
 Ru6nIFhNnAxFYdrtYHJW12fJaA5VMAzlYegTsHQ1u2x7pqEtn5SQl/JfJGcUZhO5wtPPfcdRDW
 SC45GhefoyivnkIvJXb//zXDb9x8vVcCOdgAAAA==
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
X-Mailer: b4 0.12.2
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update spelling in comments in main.h

Found by inspection.

Signed-off-by: Simon Horman <horms@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/main.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/main.h b/drivers/net/wireless/realtek/rtw88/main.h
index d4a53d556745..61106742394a 100644
--- a/drivers/net/wireless/realtek/rtw88/main.h
+++ b/drivers/net/wireless/realtek/rtw88/main.h
@@ -88,7 +88,7 @@ enum rtw_supported_band {
 	RTW_BAND_60G = BIT(NL80211_BAND_60GHZ),
 };
 
-/* now, support upto 80M bw */
+/* now, support up to 80M bw */
 #define RTW_MAX_CHANNEL_WIDTH RTW_CHANNEL_WIDTH_80
 
 enum rtw_bandwidth {
@@ -1871,7 +1871,7 @@ enum rtw_sar_bands {
 	RTW_SAR_BAND_NR,
 };
 
-/* the union is reserved for other knids of SAR sources
+/* the union is reserved for other kinds of SAR sources
  * which might not re-use same format with array common.
  */
 union rtw_sar_cfg {
@@ -2020,7 +2020,7 @@ struct rtw_dev {
 	struct rtw_tx_report tx_report;
 
 	struct {
-		/* incicate the mail box to use with fw */
+		/* indicate the mail box to use with fw */
 		u8 last_box_num;
 		u32 seq;
 	} h2c;

