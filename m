Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 716DF57F3D7
	for <lists+netdev@lfdr.de>; Sun, 24 Jul 2022 09:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239745AbiGXHw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jul 2022 03:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiGXHw5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jul 2022 03:52:57 -0400
Received: from smtpbg.qq.com (biz-43-154-54-12.mail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A410813FA7;
        Sun, 24 Jul 2022 00:52:50 -0700 (PDT)
X-QQ-mid: bizesmtp64t1658649135to0nr012
Received: from localhost.localdomain ( [125.70.163.183])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Sun, 24 Jul 2022 15:52:14 +0800 (CST)
X-QQ-SSF: 01000000002000007000B00A0000000
X-QQ-FEAT: gwP3ao7taPxKn1hUHux/OYblWpgzhFa24pHKI5+H9+0YCbGoTJQMTUVEjZggu
        AMr5XteIbxTN8yLk5IuVK1ZXvMwKxyzFYw08gU8wg77QEcxK0F4ovmEXHu2Fdoy4t5FSZpt
        xRs5UeXeiL+CdoEh+VW9gng14Byig3ul6KSxG+BR9qiNLfhWbV7w0v0cy1dHF58FOI7+NeM
        Ax7elRGEDlxMQcmopnqYQA6q1RjvzGR44EJ3T2x2If7tIKXmdsuujKQuozWGNXjbb1+BO4r
        c/qaatWAnlB9wibDmiLiI7O/LPYA0MuTDtZZrll6T6XbB1yFSowJqcIc29SaN1/aa4D6DKM
        ZLgtmJNnxLmdgXRucOiAmORR+DG0mf1VTNhZsA9
X-QQ-GoodBg: 0
From:   wangjianli <wangjianli@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangjianli <wangjianli@cdjrlc.com>
Subject: [PATCH] sfc/siena: fix repeated words in comments
Date:   Sun, 24 Jul 2022 15:52:07 +0800
Message-Id: <20220724075207.21080-1-wangjianli@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr7
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,RDNS_DYNAMIC,
        SPF_PASS,T_SPF_HELO_TEMPERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 Delete the redundant word 'in'.

Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
---
 drivers/net/ethernet/sfc/siena/net_driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/siena/net_driver.h b/drivers/net/ethernet/sfc/siena/net_driver.h
index a8f6c3699c8b..b3ca2db09869 100644
--- a/drivers/net/ethernet/sfc/siena/net_driver.h
+++ b/drivers/net/ethernet/sfc/siena/net_driver.h
@@ -838,7 +838,7 @@ enum efx_xdp_tx_queues_mode {
  * @xdp_channel_offset: Offset of zeroth channel used for XPD TX.
  * @xdp_tx_per_channel: Max number of TX queues on an XDP TX channel.
  * @rx_ip_align: RX DMA address offset to have IP header aligned in
- *	in accordance with NET_IP_ALIGN
+ *	accordance with NET_IP_ALIGN
  * @rx_dma_len: Current maximum RX DMA length
  * @rx_buffer_order: Order (log2) of number of pages for each RX buffer
  * @rx_buffer_truesize: Amortised allocation size of an RX buffer,
-- 
2.36.1

