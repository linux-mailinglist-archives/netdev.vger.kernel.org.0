Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B14D550513
	for <lists+netdev@lfdr.de>; Sat, 18 Jun 2022 15:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232363AbiFRNWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jun 2022 09:22:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRNWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jun 2022 09:22:04 -0400
Received: from smtpbg.qq.com (smtpbg138.qq.com [106.55.201.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723C413F08;
        Sat, 18 Jun 2022 06:21:58 -0700 (PDT)
X-QQ-mid: bizesmtp77t1655558199t25n54gy
Received: from localhost.localdomain ( [125.70.163.206])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sat, 18 Jun 2022 21:16:33 +0800 (CST)
X-QQ-SSF: 01000000002000D0I000B00A0000000
X-QQ-FEAT: CGxwVt8GOWGFEeW73tj4RczCShawCiIIyxtelmzc6swLpayI+7CWhrazB0Nne
        S6a2ynQ6uTLg7sbxo/TxM8cr3LEvqo1acl1woyLJSmfxDQOI1qpz+yd4MBo7cAy+OoT+M3h
        FuvyxWwqQ5THNly2vr8XgIlIuFpIT+ZPeFDSc/BHTmlITSBe+WHOPjcZmnFN00wMX9GIZvU
        aehGAytTSxvkM7Y4yPXCn+6hGVsTcWw+puvEU6PddJb4OVBtOUA3A/XGf0EOAqRffGJjNL7
        xbsX3tDeTFc9MbuShZMn/Qf/O0X5a1n9iSN5w/CSqqb+00/PWptqBznhjC4X1S88z6ohh7h
        1xgh9lLO0vgVaPPQAw7syOnHC8IxQ==
X-QQ-GoodBg: 0
From:   Xiang wangx <wangxiang@cdjrlc.com>
To:     timur@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xiang wangx <wangxiang@cdjrlc.com>
Subject: [PATCH] net: emac: Fix typo in a comment
Date:   Sat, 18 Jun 2022 21:16:26 +0800
Message-Id: <20220618131626.13811-1-wangxiang@cdjrlc.com>
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

Signed-off-by: Xiang wangx <wangxiang@cdjrlc.com>
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


