Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A97442279F0
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 09:55:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbgGUHz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 03:55:27 -0400
Received: from inva020.nxp.com ([92.121.34.13]:51886 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727901AbgGUHzZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 03:55:25 -0400
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 29A431A0574;
        Tue, 21 Jul 2020 09:55:24 +0200 (CEST)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 1CF541A0570;
        Tue, 21 Jul 2020 09:55:24 +0200 (CEST)
Received: from fsr-ub1664-016.ea.freescale.net (fsr-ub1664-016.ea.freescale.net [10.171.71.216])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id DA77C202A9;
        Tue, 21 Jul 2020 09:55:23 +0200 (CEST)
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH net-next v3 4/6] enetc: Drop redundant ____cacheline_aligned_in_smp
Date:   Tue, 21 Jul 2020 10:55:20 +0300
Message-Id: <1595318122-18490-5-git-send-email-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
References: <1595318122-18490-1-git-send-email-claudiu.manoil@nxp.com>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'struct enetc_bdr' is already '____cacheline_aligned_in_smp'.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
v2: none
v3: none

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

