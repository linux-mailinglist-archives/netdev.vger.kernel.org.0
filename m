Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A667F15405A
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 09:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbgBFIfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 03:35:25 -0500
Received: from stargate.chelsio.com ([12.32.117.8]:13674 "EHLO
        stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726365AbgBFIfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 03:35:24 -0500
Received: from beagle8.blr.asicdesigners.com (beagle8.blr.asicdesigners.com [10.193.80.125])
        by stargate.chelsio.com (8.13.8/8.13.8) with ESMTP id 0168Z2tR029369;
        Thu, 6 Feb 2020 00:35:03 -0800
From:   Devulapally Shiva Krishna <shiva@chelsio.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     nirranjan@chelsio.com, dt@chelsio.com,
        Devulapally Shiva Krishna <shiva@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Subject: [net] cxgb4: Added tls stats prints.
Date:   Thu,  6 Feb 2020 14:04:43 +0530
Message-Id: <20200206083443.19461-1-shiva@chelsio.com>
X-Mailer: git-send-email 2.18.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Added debugfs entry to show the tls stats.

Signed-off-by: Devulapally Shiva Krishna <shiva@chelsio.com>
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
---
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
index 9d1f2f88b945..de30d61af065 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c
@@ -3403,6 +3403,13 @@ static int chcr_stats_show(struct seq_file *seq, void *v)
 		   atomic_read(&adap->chcr_stats.fallback));
 	seq_printf(seq, "IPSec PDU: %10u\n",
 		   atomic_read(&adap->chcr_stats.ipsec_cnt));
+	seq_printf(seq, "TLS PDU Tx: %10u\n",
+		   atomic_read(&adap->chcr_stats.tls_pdu_tx));
+	seq_printf(seq, "TLS PDU Rx: %10u\n",
+		   atomic_read(&adap->chcr_stats.tls_pdu_rx));
+	seq_printf(seq, "TLS Keys (DDR) Count: %10u\n",
+		   atomic_read(&adap->chcr_stats.tls_key));
+
 	return 0;
 }
 DEFINE_SHOW_ATTRIBUTE(chcr_stats);
-- 
2.18.1

