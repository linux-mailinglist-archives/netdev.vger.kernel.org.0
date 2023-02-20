Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABF669C5C6
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 08:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbjBTHFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 02:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230387AbjBTHEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 02:04:40 -0500
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43131BD2;
        Sun, 19 Feb 2023 23:04:11 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=yang.lee@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0Vc0kkcN_1676876399;
Received: from localhost(mailfrom:yang.lee@linux.alibaba.com fp:SMTPD_---0Vc0kkcN_1676876399)
          by smtp.aliyun-inc.com;
          Mon, 20 Feb 2023 15:00:00 +0800
From:   Yang Li <yang.lee@linux.alibaba.com>
To:     kuba@kernel.org
Cc:     davem@davemloft.net, ecree.xilinx@gmail.com,
        habetsm.xilinx@gmail.com, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Li <yang.lee@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
Subject: [PATCH -next] sfc: clean up some inconsistent indentings
Date:   Mon, 20 Feb 2023 14:59:58 +0800
Message-Id: <20230220065958.52941-1-yang.lee@linux.alibaba.com>
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

Fix some indentngs and remove the warning below:
drivers/net/ethernet/sfc/mae.c:657 efx_mae_enumerate_mports() warn: inconsistent indenting

Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=4117
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
---
 drivers/net/ethernet/sfc/mae.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/sfc/mae.c b/drivers/net/ethernet/sfc/mae.c
index 6321fd393fc3..2d32abe5f478 100644
--- a/drivers/net/ethernet/sfc/mae.c
+++ b/drivers/net/ethernet/sfc/mae.c
@@ -654,8 +654,8 @@ int efx_mae_enumerate_mports(struct efx_nic *efx)
 								     MAE_MPORT_DESC_VNIC_FUNCTION_INTERFACE);
 				d->pf_idx = MCDI_STRUCT_WORD(desc,
 							     MAE_MPORT_DESC_VNIC_FUNCTION_PF_IDX);
-			d->vf_idx = MCDI_STRUCT_WORD(desc,
-						     MAE_MPORT_DESC_VNIC_FUNCTION_VF_IDX);
+				d->vf_idx = MCDI_STRUCT_WORD(desc,
+							     MAE_MPORT_DESC_VNIC_FUNCTION_VF_IDX);
 				break;
 			default:
 				/* Unknown mport_type, just accept it */
-- 
2.20.1.7.g153144c

