Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF322F8577
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 20:31:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388427AbhAOTaM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 14:30:12 -0500
Received: from fllv0015.ext.ti.com ([198.47.19.141]:36986 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388344AbhAOTaL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 14:30:11 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTSTE008601;
        Fri, 15 Jan 2021 13:29:28 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1610738968;
        bh=RVk08ZYJ9d6t9cvlnZCVuB1ibN+rBkiw/DHXFibDelI=;
        h=From:To:CC:Subject:Date:In-Reply-To:References;
        b=sZXyARS2PpzrGY48UTHKlvA1ddKZwQ+F/mrQUvPfmZBbkpuu6PCsH/t5ucNbyUfcr
         4HmTIIetjMsoYuLIdH4kF7JJC8+cxTSgy7OomnYoZS89mDn2l6Db6WPQwCYG0QQ49T
         mFRGHaQZR52srrLNtJO8gYciwCtH5iVkiceRBTKQ=
Received: from DLEE109.ent.ti.com (dlee109.ent.ti.com [157.170.170.41])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 10FJTSnO026422
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 15 Jan 2021 13:29:28 -0600
Received: from DLEE103.ent.ti.com (157.170.170.33) by DLEE109.ent.ti.com
 (157.170.170.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Fri, 15
 Jan 2021 13:29:28 -0600
Received: from fllv0039.itg.ti.com (10.64.41.19) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Fri, 15 Jan 2021 13:29:28 -0600
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 10FJTRVP007666;
        Fri, 15 Jan 2021 13:29:27 -0600
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Peter Ujfalusi <peter.ujfalusi@gmail.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, Sekhar Nori <nsekhar@ti.com>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [net-next 6/6] net: ethernet: ti: am65-cpsw: add support for am64x cpsw3g
Date:   Fri, 15 Jan 2021 21:28:53 +0200
Message-ID: <20210115192853.5469-7-grygorii.strashko@ti.com>
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

The TI AM64x SoCs Gigabit Ethernet Switch subsystem (CPSW3g NUSS) has three
ports (2 ext. ports) and provides Ethernet packet communication for the
device and can be configured in multi port mode or as an Ethernet switch.

This patch adds support for the corresponding CPSW3g version.

Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index d060744dd0b2..1850743c04da 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2115,9 +2115,16 @@ static const struct am65_cpsw_pdata j721e_pdata = {
 	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
 };
 
+static const struct am65_cpsw_pdata am64x_cpswxg_pdata = {
+	.quirks = 0,
+	.ale_dev_id = "am64-cpswxg",
+	.fdqring_mode = K3_RINGACC_RING_MODE_RING,
+};
+
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
 	{ .compatible = "ti,am654-cpsw-nuss", .data = &am65x_sr1_0},
 	{ .compatible = "ti,j721e-cpsw-nuss", .data = &j721e_pdata},
+	{ .compatible = "ti,am642-cpsw-nuss", .data = &am64x_cpswxg_pdata},
 	{ /* sentinel */ },
 };
 MODULE_DEVICE_TABLE(of, am65_cpsw_nuss_of_mtable);
-- 
2.17.1

