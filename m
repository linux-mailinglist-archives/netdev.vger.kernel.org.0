Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6F2D1101A68
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 08:39:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfKSHjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 02:39:21 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:63007 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727146AbfKSHjV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 02:39:21 -0500
Received: from localhost (scalar.blr.asicdesigners.com [10.193.185.94])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id xAJ7dH3K022957;
        Mon, 18 Nov 2019 23:39:18 -0800
From:   Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: [PATCH net-next] cxgb4: remove unneeded semicolon for switch block
Date:   Tue, 19 Nov 2019 13:00:56 +0530
Message-Id: <1574148656-21462-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: git-send-email 2.5.3
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Semicolon is not required at the end of switch block. So, remove it.

Addresses coccinelle warning:
drivers/net/ethernet/chelsio/cxgb4/sge.c:2260:2-3: Unneeded semicolon

Fixes: 4846d5330daf ("cxgb4: add Tx and Rx path for ETHOFLD traffic")
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/sge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/sge.c b/drivers/net/ethernet/chelsio/cxgb4/sge.c
index 09059adc3067..a0400b9a11e9 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/sge.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/sge.c
@@ -2283,7 +2283,7 @@ static void ethofld_xmit(struct net_device *dev, struct sge_eosw_txq *eosw_txq)
 	case CXGB4_EO_STATE_CLOSED:
 	default:
 		return;
-	};
+	}
 
 	while (pktcount--) {
 		skb = eosw_txq_peek(eosw_txq);
-- 
2.24.0

