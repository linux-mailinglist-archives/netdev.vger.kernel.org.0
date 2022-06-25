Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB9155A78D
	for <lists+netdev@lfdr.de>; Sat, 25 Jun 2022 08:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiFYGms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jun 2022 02:42:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbiFYGmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jun 2022 02:42:47 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 414B54B847;
        Fri, 24 Jun 2022 23:42:42 -0700 (PDT)
X-QQ-mid: bizesmtp78t1656139278te75do9l
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 25 Jun 2022 14:41:14 +0800 (CST)
X-QQ-SSF: 0100000000200060C000B00A0000000
X-QQ-FEAT: k0yT7W7BRd3wntKL/YJRsvZqvoe18jQRjCkfoAIvCmT51Syav24ubf2T4Ak3X
        BUQl7AhllX1nJXxwQDSls4Q8mHKbqnGW5D93DsaXzXNLiqVCHwsUNLkGHFMnKdP+ku02wvm
        eL2s6t60BQESVQ3tjqfjDfPodTdlzkHHf0JAR+6j8rzYwolyzXh1ag3isIuyiqi84+re5wX
        DO/oGUPsjvwdoUhUbAlshwtnyowJ076NZuhkvzmXN3CfY3ldmym5FHlParFHbLnHMJbWxNZ
        8fL34n8rM1DjLQhBOQcJehVXljiJwkiYGnWZRcgqPq+/2qxV5wJ8TehmsT6fX1RKvtq7pxq
        nqxln8Q7+j5L9NSiwM=
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     timur@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] qualcomm:emac:fix repeated words in comments
Date:   Sat, 25 Jun 2022 14:41:07 +0800
Message-Id: <20220625064107.57362-1-yuanjilin@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete the redundant word 'and'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/qualcomm/emac/emac-mac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qualcomm/emac/emac-mac.c b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
index 06104d2ff5b3..80c95c331c82 100644
--- a/drivers/net/ethernet/qualcomm/emac/emac-mac.c
+++ b/drivers/net/ethernet/qualcomm/emac/emac-mac.c
@@ -1465,7 +1465,7 @@ netdev_tx_t emac_mac_tx_buf_send(struct emac_adapter *adpt,
 	/* Make sure the are enough free descriptors to hold one
 	 * maximum-sized SKB.  We need one desc for each fragment,
 	 * one for the checksum (emac_tso_csum), one for TSO, and
-	 * and one for the SKB header.
+	 * one for the SKB header.
 	 */
 	if (emac_tpd_num_free_descs(tx_q) < (MAX_SKB_FRAGS + 3))
 		netif_stop_queue(adpt->netdev);
-- 
2.36.1


