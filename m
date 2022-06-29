Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC485600B0
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 15:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233549AbiF2NAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 09:00:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233540AbiF2NAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 09:00:52 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3438239153;
        Wed, 29 Jun 2022 06:00:47 -0700 (PDT)
X-QQ-mid: bizesmtp80t1656507622tuzdmy19
Received: from localhost.localdomain ( [182.148.13.66])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 29 Jun 2022 21:00:19 +0800 (CST)
X-QQ-SSF: 0100000000200060C000C00A0000000
X-QQ-FEAT: l2baldexF9lz4YrvL/Ghtyw7zcN9rjvBWiNTgC25NjmcRaWXYr90zV9Q5Re0h
        DnTY1Eo5ztSf3RsKM9CLWbnMj9ZawSKhOLxtZk6ck3FSl7xKjceHS4tbcSLr9gTBGkxEr/m
        au0lB8Sae4NCCR8kQERX/W1QM31ZihDEJGJb5aw7GTJYEN1iANQ8tricZoMF9SpJ+72geoD
        FGPDbISvRP7d5XG8Ueu97MQke9aayYq28y/MExfrDRJVVsdxRsfJmlVIpVANbP8GjgP98U3
        Wdm1JjDFjxGuTAQzy+qvgCUvaFyQ4eDv1njolZdxTlRDqwKVn+BcpWubeDfjbJRHozGGavT
        VCOLs1l
X-QQ-GoodBg: 0
From:   Jilin Yuan <yuanjilin@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jeroendb@google.com, csully@google.com, awogbemila@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
Subject: [PATCH] google/gve:fix repeated words in comments
Date:   Wed, 29 Jun 2022 21:00:13 +0800
Message-Id: <20220629130013.3273-1-yuanjilin@cdjrlc.com>
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

Delete the redundant word 'a'.

Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
---
 drivers/net/ethernet/google/gve/gve_tx_dqo.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve_tx_dqo.c b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
index ec394d991668..f7ba616195f3 100644
--- a/drivers/net/ethernet/google/gve/gve_tx_dqo.c
+++ b/drivers/net/ethernet/google/gve/gve_tx_dqo.c
@@ -795,7 +795,7 @@ static void gve_handle_packet_completion(struct gve_priv *priv,
 			     GVE_PACKET_STATE_PENDING_REINJECT_COMPL)) {
 			/* No outstanding miss completion but packet allocated
 			 * implies packet receives a re-injection completion
-			 * without a a prior miss completion. Return without
+			 * without a prior miss completion. Return without
 			 * completing the packet.
 			 */
 			net_err_ratelimited("%s: Re-injection completion received without corresponding miss completion: %d\n",
-- 
2.36.1

