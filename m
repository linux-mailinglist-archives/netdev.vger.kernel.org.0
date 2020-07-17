Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0840E223FB2
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 17:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbgGQPhI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 11:37:08 -0400
Received: from inva021.nxp.com ([92.121.34.21]:51708 "EHLO inva021.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727021AbgGQPhH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Jul 2020 11:37:07 -0400
Received: from inva021.nxp.com (localhost [127.0.0.1])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id F03DB20098D;
        Fri, 17 Jul 2020 17:37:05 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva021.eu-rdc02.nxp.com (Postfix) with ESMTP id E4A8A20098B;
        Fri, 17 Jul 2020 17:37:05 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id AEA3020466;
        Fri, 17 Jul 2020 17:37:05 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v2 4/6] enetc: Drop redundant ____cacheline_aligned_in_smp
Date:   Fri, 17 Jul 2020 18:37:02 +0300
Message-Id: <1595000224-6883-5-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595000224-6883-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'struct enetc_bdr' is already '____cacheline_aligned_in_smp'.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: none

 drivers/net/ethernet/freescale/enetc/enetc.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.h b/drivers/net/ethernet/freescale/enetc/enetc.h
index 0dd8ee179753..81e9072e10d4 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.h
+++ b/drivers/net/ethernet/freescale/enetc/enetc.h
@@ -195,7 +195,7 @@ struct enetc_int_vector {
 	struct napi_struct napi;
 	char name[ENETC_INT_NAME_MAX];
 
-	struct enetc_bdr rx_ring ____cacheline_aligned_in_smp;
+	struct enetc_bdr rx_ring;
 	struct enetc_bdr tx_ring[];
 };
 
-- 
2.17.1

