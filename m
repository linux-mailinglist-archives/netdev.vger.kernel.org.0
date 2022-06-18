Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8FE550519
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 15:26:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233322AbiFRNZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 09:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRNZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 09:25:50 -0400
Received: from smtpbg.qq.com (smtpbg123.qq.com [175.27.65.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3F2140D3;
        Sat, 18 Jun 2022 06:25:46 -0700 (PDT)
X-QQ-mid: bizesmtp83t1655558365tg1dsuxv
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 18 Jun 2022 21:19:21 +0800 (CST)
X-QQ-SSF: 01000000002000D0I000B00A0000000
X-QQ-FEAT: Mzskoac49Og1pKkwi0Uw9KBm5Fj1PumroRIkYeuk3XTUDQBxv7NrUYkg3WW0P
        4OIkMxlCjpaJYUZbJwZEr7gUIZCsbNHQGpH7qEbFkdstCq7GVjExwgV9DwyfVe9SJSmb8so
        HAqs15a+tJdTGPNtwncDvUOkRyXOP0SZ3Xp5aFdCAkRblHZIuIC1x54Bs6ialJaHXRB0uqT
        HD8EA4qaZS9uKxfna1naMSHybS1brWg2etkIXrG6hb5V6h1Fm0NgYh8KEsHmr1keT9KbNY+
        RaXMltxoHKAbrONujOkGYVrPl96/qrJZ40DBQNZGb7JHMt86R+nEIvKZeiTn9z2EjR2ttd/
        pcgAP1z45nykPqldPe508RgdSIaDg==
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] sfc: Fix typo in comment
Date:   Sat, 18 Jun 2022 21:19:14 +0800
Message-Id: <20220618131914.14470-1-wangxiang@cdjrlc.com>
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

Delete the redundant word 'and'.

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
---
 drivers/net/ethernet/sfc/mcdi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/mcdi.c b/drivers/net/ethernet/sfc/mcdi.c
index 50baf62b2cbc..a3425b6be3f7 100644
--- a/drivers/net/ethernet/sfc/mcdi.c
+++ b/drivers/net/ethernet/sfc/mcdi.c
@@ -1261,7 +1261,7 @@ static void efx_mcdi_ev_death(struct efx_nic *efx, int rc)
 }
 
 /* The MC is going down in to BIST mode. set the BIST flag to block
- * new MCDI, cancel any outstanding MCDI and and schedule a BIST-type reset
+ * new MCDI, cancel any outstanding MCDI and schedule a BIST-type reset
  * (which doesn't actually execute a reset, it waits for the controlling
  * function to reset it).
  */
-- 
2.36.1

