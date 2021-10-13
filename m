Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEFB42B7EC
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 08:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhJMGvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 02:51:35 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:2742 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229951AbhJMGvf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 02:51:35 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19CMejmK004308;
        Tue, 12 Oct 2021 23:49:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=PcVJO5VfHRDZmz9U2z+XDOGu7e+BLtdU45WMqAzHsJk=;
 b=fH5DoYeYpvoHuu6Blv7ySs5r4Isf71B5NInhFJsM2NulmzJu/yVQihb9i+he8QIncAdp
 tvJWTDw6TFpXEmsZ4A8Bk6cyPaaqYHYklf/OieXDW8eP/sIGQldI7akcozUWBp5WdLFN
 fe3QIMJAgjl01LwkJKQ7XF3S51IH7zPiLEFTfdevX2rz28tRz5r4OccCmztXOyVpC2oq
 ZECfbYR0zQvXKfCZPPjt6WBpBfH5SeoGMJdInxzNRjWVaOd7D3UrNR5Nd3Wh98XZhXlj
 PdhAzqtnZcqnLPS954SpASUhfC2gXEmQYn5r0ht8fv5U4NsfHYB//ma6wargzcd1ZeIn VA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bnkc5ssdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Oct 2021 23:49:27 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 12 Oct
 2021 23:49:26 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 12 Oct 2021 23:49:26 -0700
Received: from jupiter069.il.marvell.com (unknown [10.5.116.92])
        by maili.marvell.com (Postfix) with ESMTP id 2BF123F7062;
        Tue, 12 Oct 2021 23:49:24 -0700 (PDT)
From:   Yuval Shaia <yshaia@marvell.com>
To:     <thomas.petazzoni@bootlin.com>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Yuval Shaia <yshaia@marvell.com>
Subject: [PATCH] net: mvneta: Delete unused variable
Date:   Wed, 13 Oct 2021 09:49:21 +0300
Message-ID: <20211013064921.26346-1-yshaia@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: MBOUaFTPkoFqPLVmygeOxi1gO0eHEa2C
X-Proofpoint-ORIG-GUID: MBOUaFTPkoFqPLVmygeOxi1gO0eHEa2C
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-13_02,2021-10-13_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The variable pp is not in use - delete it.

Signed-off-by: Yuval Shaia <yshaia@marvell.com>
---
 drivers/net/ethernet/marvell/mvneta.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 9d460a270601..3c3e01dec314 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -1914,7 +1914,7 @@ static int mvneta_rx_refill(struct mvneta_port *pp,
 }
 
 /* Handle tx checksum */
-static u32 mvneta_skb_tx_csum(struct mvneta_port *pp, struct sk_buff *skb)
+static u32 mvneta_skb_tx_csum(struct sk_buff *skb)
 {
 	if (skb->ip_summed == CHECKSUM_PARTIAL) {
 		int ip_hdr_len = 0;
@@ -2595,8 +2595,7 @@ static int mvneta_rx_hwbm(struct napi_struct *napi,
 }
 
 static inline void
-mvneta_tso_put_hdr(struct sk_buff *skb,
-		   struct mvneta_port *pp, struct mvneta_tx_queue *txq)
+mvneta_tso_put_hdr(struct sk_buff *skb, struct mvneta_tx_queue *txq)
 {
 	int hdr_len = skb_transport_offset(skb) + tcp_hdrlen(skb);
 	struct mvneta_tx_buf *buf = &txq->buf[txq->txq_put_index];
@@ -2604,7 +2603,7 @@ mvneta_tso_put_hdr(struct sk_buff *skb,
 
 	tx_desc = mvneta_txq_next_desc_get(txq);
 	tx_desc->data_size = hdr_len;
-	tx_desc->command = mvneta_skb_tx_csum(pp, skb);
+	tx_desc->command = mvneta_skb_tx_csum(skb);
 	tx_desc->command |= MVNETA_TXD_F_DESC;
 	tx_desc->buf_phys_addr = txq->tso_hdrs_phys +
 				 txq->txq_put_index * TSO_HEADER_SIZE;
@@ -2681,7 +2680,7 @@ static int mvneta_tx_tso(struct sk_buff *skb, struct net_device *dev,
 		hdr = txq->tso_hdrs + txq->txq_put_index * TSO_HEADER_SIZE;
 		tso_build_hdr(skb, hdr, &tso, data_left, total_len == 0);
 
-		mvneta_tso_put_hdr(skb, pp, txq);
+		mvneta_tso_put_hdr(skb, txq);
 
 		while (data_left > 0) {
 			int size;
@@ -2799,7 +2798,7 @@ static netdev_tx_t mvneta_tx(struct sk_buff *skb, struct net_device *dev)
 	/* Get a descriptor for the first part of the packet */
 	tx_desc = mvneta_txq_next_desc_get(txq);
 
-	tx_cmd = mvneta_skb_tx_csum(pp, skb);
+	tx_cmd = mvneta_skb_tx_csum(skb);
 
 	tx_desc->data_size = skb_headlen(skb);
 
-- 
2.17.1

