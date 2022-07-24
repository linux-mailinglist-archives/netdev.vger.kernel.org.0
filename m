Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4436357F3D2
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 09:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239714AbiGXHsd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 03:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235555AbiGXHsd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 03:48:33 -0400
Received: from smtpbg.qq.com (unknown [43.155.67.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4315D12ACB;
        Sun, 24 Jul 2022 00:48:28 -0700 (PDT)
X-QQ-mid: bizesmtp66t1658648874txic6mjy
Received: from localhost.localdomain ( [125.70.163.183])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 24 Jul 2022 15:47:53 +0800 (CST)
X-QQ-SSF: 01000000002000007000B00A0000000
X-QQ-FEAT: 7jw2iSiCazriGTijezmDdhAg1CmcIVF3SK01r3qE/a1g8cuJYpyvxnj5tPdzV
        KQ3UX9d66lxni7Jn9iKw/Lw+rcOrxJUH2l9U9xo8sdvtWqlYoYOprqko0vDA9lzO4jx1HxR
        DX3w9ojplaP6mhx32saO9Jerim+DWeXvxBtRFZUPBySTKQgHN8uWq0dVGZsPtAIq8MyjeG8
        +Qd8AGyCUa3xlPV9s2CxJ7b23XiS2J/v2pcil8Vv0PJkrZEtZcqaMU4abumgnLqbU3E2yoN
        gN5x/8pBEnZJ+Vh8hoRv6O///3RauPKlhD4YyKIQT9/G8WHIqqv1fggKqnS3XdXN/df7IvP
        3Mkfp/1oEM91oWead+jwKewbIEYiyBXKgZE7/QogP7uyGkw4oq6Qe15KjahvA==
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] sfc/falcon: fix repeated words in comments
Date:   Sun, 24 Jul 2022 15:47:46 +0800
Message-Id: <20220724074746.19550-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,RDNS_NONE,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'in'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/net/ethernet/sfc/falcon/net_driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/falcon/net_driver.h b/drivers/net/ethernet/sfc/falcon/net_driver.h
index a381cf9ec4f3..a2c7139f2b32 100644
--- a/drivers/net/ethernet/sfc/falcon/net_driver.h
+++ b/drivers/net/ethernet/sfc/falcon/net_driver.h
@@ -679,7 +679,7 @@ union ef4_multicast_hash {
  * @n_rx_channels: Number of channels used for RX (= number of RX queues)
  * @n_tx_channels: Number of channels used for TX
  * @rx_ip_align: RX DMA address offset to have IP header aligned in
- *	in accordance with NET_IP_ALIGN
+ *	accordance with NET_IP_ALIGN
  * @rx_dma_len: Current maximum RX DMA length
  * @rx_buffer_order: Order (log2) of number of pages for each RX buffer
  * @rx_buffer_truesize: Amortised allocation size of an RX buffer,
-- 
2.36.1

