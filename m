Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B357A56029E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 16:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231508AbiF2OZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 10:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiF2OZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 10:25:39 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A2E324967;
        Wed, 29 Jun 2022 07:25:33 -0700 (PDT)
X-QQ-mid: bizesmtp80t1656512707t4q4eqwx
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 22:25:04 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: TwPVgCEnUPnJO5LRHT5GJze7vZ8UMdtnokyDiXgpBnFr3S8dIu5E6zQolWsMZ
        R9RQhNdONWtFEZCORBctel/rSVnKlNE4CRFpY4nGmY/2YK1PYQeJ+JfeRnZIWAY0K6/tgI1
        HcVdFe/Ttv0O9PZ+GZXVeC1KaU4TnWoGCpFk1/yeV1wTVxVFaxOx/rA7GDn6uTE6xV3b4XW
        Wy7kKctW33NRgf/StvjuAt2d4S/5q5P1UXnU+djjkv79v3/38G34xoI3f5zVFf8qE/BYaZB
        gjfR4F29/GgEr1u9CVklgTVmfQhhAWJyQt2gKk18GWfaQDHreAj3S6hTqZRFxc0/DGUKBNG
        C/Q0a/BgEGT2M8XOvs=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] intel/igc:fix repeated words in comments
Date:   Wed, 29 Jun 2022 22:24:57 +0800
Message-Id: <20220629142457.16887-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'frames'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/intel/igc/igc_mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 67b8ffd21d8a..a5c4b19d71a2 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -193,7 +193,7 @@ s32 igc_force_mac_fc(struct igc_hw *hw)
 	 *      1:  Rx flow control is enabled (we can receive pause
 	 *          frames but not send pause frames).
 	 *      2:  Tx flow control is enabled (we can send pause frames
-	 *          frames but we do not receive pause frames).
+	 *          but we do not receive pause frames).
 	 *      3:  Both Rx and TX flow control (symmetric) is enabled.
 	 *  other:  No other values should be possible at this point.
 	 */
-- 
2.36.1

