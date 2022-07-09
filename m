Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EC7F56C982
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 15:22:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiGINWR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 09:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGINWQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 09:22:16 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F7CE32ED0;
        Sat,  9 Jul 2022 06:22:10 -0700 (PDT)
X-QQ-mid: bizesmtp87t1657372907tk53euzj
Received: from localhost.localdomain ( [182.148.15.109])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 09 Jul 2022 21:21:44 +0800 (CST)
X-QQ-SSF: 01000000002000B0C000C00A0000000
X-QQ-FEAT: MFQNDABwGMnbI3+zPdQ+CVJ73bFABe6xFN9qPX+xShDslADrWhdoXqR9M+dNl
        +XmcI5B7nHUCBjX6Fcvlbm9GK0VuuV9j18dYTQVk4jaTTIU06bGXqQmK4fgcjXKSz3mA7eu
        nRfxUXIyeivvB5QE3P89kxAzGWtuKz8HIJy5sfmhP4gHdRBLsenLauD1WW1Kx1HvhRTvXUQ
        HP09r7ShF25B4Uct2Yt3k2LEHexJ2BwrE0TXV5+UPffH9YUNno8Rskl5KqNrliXv9N/3XQL
        BWi7VWUms0Gg6/S40ycpJFu5P1yDp7UsvIK5bzKUraUMKZk/PjUCwf7I6tbJIsZ5GDRHuCT
        IITpxEOSh16vphVxgOCd66sxDnOK1PSBdNzyKc8oJcX3m+WSwY=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] wifi: wil6210: fix repeated words in comments
Date:   Sat,  9 Jul 2022 21:21:37 +0800
Message-Id: <20220709132137.12442-1-yuanjilin@cdjrlc.com>
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

 Delete the redundant word 'for'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/wireless/ath/wil6210/txrx.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx.h b/drivers/net/wireless/ath/wil6210/txrx.h
index 1f4c8ec75be8..1ae1bec1b97f 100644
--- a/drivers/net/wireless/ath/wil6210/txrx.h
+++ b/drivers/net/wireless/ath/wil6210/txrx.h
@@ -356,7 +356,7 @@ struct vring_rx_mac {
  * bit     10 : cmd_dma_it:1 immediate interrupt
  * bit 11..15 : reserved:5
  * bit 16..29 : phy_info_length:14 It is valid when the PII is set.
- *		When the FFM bit is set bits 29-27 are used for for
+ *		When the FFM bit is set bits 29-27 are used for
  *		Flex Filter Match. Matching Index to one of the L2
  *		EtherType Flex Filter
  * bit 30..31 : l4_type:2 valid if the L4I bit is set in the status field
-- 
2.36.1


