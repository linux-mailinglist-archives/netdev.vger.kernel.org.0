Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2E82F8584
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:31:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388595AbhAOTbD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:31:03 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36958 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387537AbhAOTbD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:31:03 -0500
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTP9M008584;
        Fri, 15 Jan 2021 13:29:25 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610738965;
        bh=3IjVqGOZhHQcBqnx6T9Ccoy8SnNQK59sbvFW6QMtN50=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=nS5a7QLqy3GjR9KWFzmciP6s0uwKFTiX3oodPvNWU/veI/AQa14ZNBWqxGnv8bfa8
         /cKWLECYM6pUBpMDsnMRIw1CwEQZpr7CIwPinHobwhxeeGTAHr/2pnbWD2gq9vL6WY
         kLePeCMjtInKeszCnQ7e9Y7hEgUXhxpbm9gQ2n7c=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJTP1A040939
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:29:25 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:29:25 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:29:25 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTO6V058774;
        Fri, 15 Jan 2021 13:29:24 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [net-next 5/6] net: ti: cpsw_ale: add driver data for AM64 CPSW3g
Date:   Fri, 15 Jan 2021 21:28:52 +0200
Message-ID: <20210115192853.5469-6-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210115192853.5469-1-grygorii.strashko@ti.com>
References: <20210115192853.5469-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

The AM642x CPSW3g is similar to j721e-cpswxg except its ALE table size is
512 entries. Add entry for the same.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/cpsw_ale.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index cdc308a2aa3e..d828f856237a 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -1256,6 +1256,13 @@ static const struct cpsw_ale_dev_id cpsw_ale_id_match[] = {
 		.major_ver_mask = 0x7,
 		.vlan_entry_tbl = vlan_entry_k3_cpswxg,
 	},
+	{
+		.dev_id = "am64-cpswxg",
+		.features = CPSW_ALE_F_STATUS_REG | CPSW_ALE_F_HW_AUTOAGING,
+		.major_ver_mask = 0x7,
+		.vlan_entry_tbl = vlan_entry_k3_cpswxg,
+		.tbl_entries = 512,
+	},
 	{ },
 };
 
-- 
2.17.1

