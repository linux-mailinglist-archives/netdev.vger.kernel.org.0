Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAEF557826
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 12:51:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiFWKu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 06:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbiFWKu4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 06:50:56 -0400
Received: from smtpbg.qq.com (smtpbg123.qq.com [175.27.65.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CF8D4B1E2;
        Thu, 23 Jun 2022 03:50:50 -0700 (PDT)
X-QQ-mid: bizesmtp85t1655981365t8g78aiu
Received: from ubuntu.localdomain ( [106.117.99.68])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 23 Jun 2022 18:49:21 +0800 (CST)
X-QQ-SSF: 01000000008000B0C000D00A0000000
X-QQ-FEAT: ZHWZeLXy+8efjliGw0J+4mgi5XMlzqjYXS1kQ9yhRyp8gNMRFxisYHk4hJi6O
        taHYdyTx4fRauf2pEpyCg4ZgLlsPACDR7zHo+ZE4YORkjVZ9JateavsPdLvQ8Oz3UkrNzjq
        scjr+61sHBlMQcdMr3U3aulfyjkI2h7vyNtDZuSGrFiJGEeMyBx685u9/kjZaXzFfltQ1EI
        aBkr763mto5E9cYSTG5ZgHwxw4C7IIJ3VPoZmHi+GF8GR+kpU6FDGJyTzwc1mtLSWa6yLZi
        N86F2cr7A+0ReqNCYzbCvitdMmK9M2Owjd2YptCfcS4Hm/73M69Giu8/exe84tW6OYjb50Y
        tdyiN/d+SlDcjfn2i2QOReV3nstMg==
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiang Jian <jiangjian@cdjrlc.com>
Subject: [PATCH] ixgbe: drop unexpected word 'for' in comments
Date:   Thu, 23 Jun 2022 18:49:19 +0800
Message-Id: <20220623104919.49600-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam8
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

there is an unexpected word 'for' in the comments that need to be dropped

file - drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
line - 5164

 * ixgbe_lpbthresh - calculate low water mark for for flow control

changed to:

 * ixgbe_lpbthresh - calculate low water mark for flow control

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 5c62e9963650..0493326a0d6b 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -5161,7 +5161,7 @@ static int ixgbe_hpbthresh(struct ixgbe_adapter *adapter, int pb)
 }
 
 /**
- * ixgbe_lpbthresh - calculate low water mark for for flow control
+ * ixgbe_lpbthresh - calculate low water mark for flow control
  *
  * @adapter: board private structure to calculate for
  * @pb: packet buffer to calculate
-- 
2.17.1

