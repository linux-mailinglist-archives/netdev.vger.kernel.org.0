Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907D721D662
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 14:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729775AbgGMM4S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 08:56:18 -0400
Received: from inva021.nxp.com ([92.121.34.21]:48758 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgGMM4N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 08:56:13 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A9B1B2014FB;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id A80442014F1;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 7ACCB204BE;
        Mon, 13 Jul 2020 14:56:11 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 5/6] enetc: Drop redundant ____cacheline_aligned_in_smp
Date:   Mon, 13 Jul 2020 15:56:09 +0300
Message-Id: <1594644970-13531-6-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
References: <1594644970-13531-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'struct enetc_bdr' is already '____cacheline_aligned_in_smp'.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 drivers/net/ethernet/freescale/enetc/enetc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index cec7e05ec523..af5a276ce02d 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -199,7 +199,7 @@ struct enetc_int_vector {
 	struct napi_struct napi;
 	char name[ENETC_INT_NAME_MAX];
 
-	struct enetc_bdr rx_ring ____cacheline_aligned_in_smp;
+	struct enetc_bdr rx_ring;
 	struct enetc_bdr tx_ring[];
 };
 
-- 
2.17.1

