Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE7BD6498C7
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 06:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbiLLF62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 00:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiLLF61 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 00:58:27 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FB41130;
        Sun, 11 Dec 2022 21:58:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=jiapeng.chong@linux.alibaba.com;NM=0;PH=DS;RN=11;SR=0;TI=SMTPD_---0VX1lmfb_1670824695;
Received: from localhost(mailfrom:jiapeng.chong@linux.alibaba.com fp:SMTPD_---0VX1lmfb_1670824695)
          by smtp.aliyun-inc.com;
          Mon, 12 Dec 2022 13:58:23 +0800
From:   Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
To:     shshaikh@marvell.com
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH] qlcnic: Clean up some inconsistent indenting
Date:   Mon, 12 Dec 2022 13:58:13 +0800
Message-Id: <20221212055813.91154-1-jiapeng.chong@linux.alibaba.com>
X-Mailer: git-send-email 2.20.1.7.g153144c
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No functional modification involved.

drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c:714 qlcnic_validate_ring_count() warn: inconsistent indenting.

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3419
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
---
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
index 1ee491f78c6b..c1436e1554de 100644
--- a/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c
@@ -711,7 +711,7 @@ static int qlcnic_validate_ring_count(struct qlcnic_adapter *adapter,
 		}
 	}
 
-	 if (tx_ring != 0) {
+	if (tx_ring != 0) {
 		if (tx_ring > adapter->max_tx_rings) {
 			netdev_err(adapter->netdev,
 				   "Invalid ring count, Tx ring count %d should not be greater than max %d driver Tx rings.\n",
-- 
2.20.1.7.g153144c

