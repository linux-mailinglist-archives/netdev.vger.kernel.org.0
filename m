Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA3528FDBD
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 07:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390418AbgJPFnh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 01:43:37 -0400
Received: from mail-am6eur05on2083.outbound.protection.outlook.com ([40.107.22.83]:33504
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389978AbgJPFnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 01:43:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UP0GUlenMN31SpNa6dUWtGPxPeABCcmirbhfa8sfkHP+4b+dTBDePu69cCn45ehsRiJ6p213MTJwGFdqXq4hgNbvRgUPH24LFBTMft8M7xxcA0iLkjuAaMOtoFlzO18GsCZcU8RLNE8SJNExUL5ggtll8IbqQvzt0e0qBZskiOysgeS2IuaI7N6/hjKU6dy34KeFF3YSVhgP+BnxIumGm1A+WIHb8mu5oos4Qw2+AT8bZlhfRRLhGjUZV4+KENAK/mKTjRMDUbgzNv0xSpe29MdNAw8eMOlcJbbxEzxklDYpTSO4BNuWR/18hq/OGTYjFRVK89zIwYHBuodPPoMP7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAsOfwr/51jOQ/yJM9ZhHR0Mks3JEnQV+TIO8/4hZ3E=;
 b=V3D8Pz0sijwL8R52qdW/w3kYwrqjy2GpcG9DeGW1LAB9iIkOX7Qsbh0z+p80vQTXJFgS5t9iFjO0EdmnlQiCJJDgqbj5XTnsOHxzqC0T4ZNBTwgtAmWdWAEFkFFk76PKY465l/ZhQS77dY1MwutaeKCr0100+LJ38KBiTATT6yqSWFl/nVin5+kMYQNmb5ZR30ddbQjMvHMFTvzpEW39lqZHCSFwJ2Zr+cVnMvqQl3u4TJmm/kDVFeGCnOXtEgkqVwZCC2EZJLVtAH2NUImcYj6etzZmaiLUTNkDsG1ovNl+9ztHVcZ3ET352G1noX0fJLp2eti/7XDvPuBhUTv35g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dAsOfwr/51jOQ/yJM9ZhHR0Mks3JEnQV+TIO8/4hZ3E=;
 b=KtQJXOjGHXSMVwobVg//VzkjdPg2mrC5d/K4FHtC/Iep15d0HV3ykVgg9zjcBDZm1FB7DU/vW0gU8ByZHj5YYpzBhAvRkpPwVYeYPjxossFwN+wl6CvrSL1aSQamBBv1Wq3yVTXZ8538bLtJecXdrz9cfNhC6f9qJXiGPfmcmoo=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBAPR04MB7333.eurprd04.prod.outlook.com (2603:10a6:10:1b2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Fri, 16 Oct
 2020 05:43:14 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.021; Fri, 16 Oct 2020
 05:43:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        peng.fan@nxp.com, linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE -> FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
Date:   Fri, 16 Oct 2020 21:43:18 +0800
Message-Id: <20201016134320.20321-5-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
References: <20201016134320.20321-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0068.apcprd02.prod.outlook.com
 (2603:1096:4:54::32) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0068.apcprd02.prod.outlook.com (2603:1096:4:54::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Fri, 16 Oct 2020 05:43:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: eafbac88-e13b-4994-0bc7-08d871965fe4
X-MS-TrafficTypeDiagnostic: DBAPR04MB7333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBAPR04MB7333CD0FB8ED261DC082038FE6030@DBAPR04MB7333.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0TsC5FzAV24sospcTDttuimer/ptXC+sEvJaAu8VzVRfjuhl8ATuzAC2ounj6AIbqoLpjTuQCCVhR6RnY2xyvjmiDVqP4OvGTsDLl8NHuiH2wh5IUJeJfAwl1mIE5X1wvJ+L06UM7eeZcPJPQghoxBN08xpFWKUQWu2tpX8Wvv57O55BW8xW3himRZ1S/LQW9NJwwNcJldfFMSSBtz1JL0zuJYO7tU3qzgX4jKQdYpSps6Rf0B2ub6VCFFqBOdm45OHEIeOrnUgvvenUTX7oDWnD+xQB6BSKwJ1Jh2K30HxOaiKsdNzKLm5v/qlyfznNO9MBY3JK8mHdp/xaU6McJVCLkAiaPfSTKBzEKXDRreYQWgmuR+aA1NOr3BazGua1N3Jf41SE+CdiK58hCe9KMbQGh1mWK2xhDB5EXZNLCCI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(366004)(136003)(34490700002)(2906002)(316002)(6512007)(8936002)(86362001)(5660300002)(1076003)(69590400008)(478600001)(52116002)(6506007)(6486002)(66556008)(83380400001)(36756003)(4326008)(6666004)(26005)(186003)(2616005)(956004)(16526019)(8676002)(66946007)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: vWQkW+4AXkDds1yoUqlWb8lFPF7iVZucqBti59ZgQ792k5fOAl/6zWdUD4jnA5SoKPbAPWk0Rt0jLMJGBPzacawo4O5/kCV0Fxjzf2k0VqkeFGMhsmzls9Dl/L4IKr6h7/OxLugmoTM5kgkjuVhboa1mJuvswHX/4DurL95DmSYfKalq6y9tPXbuj/E23voH5BSOyPRmw8d8zQgpgcpiB3kU2svLe1RYywlEZXI9MaqJaRdJGhJcGCVvWSLew5EvujXDvAei+QMGaIETsMwxF6jvp7gqUaTV3mzIJpgmsFocpxA+K6fTe9nMW4dnYpOEtG6GifsCeKqA9+rnu9BurhvH5NgMcU6Ytx+DPS49kFg396ciaqBaeRK9smT4FcOcDop3vuyfmHkgxU18lqNOefOjBMye6TMoNvfkhQcxZDwPXIEt7kvv/FrLaX1WwhKqeKRCsUjLaA1dEfwBf5W2cozScAP2VZdqRninNGTCx8YPzbqq4G1RwrvHIq8/LXPvVxD0Q4ImCIyoklhyyYW/ZpZveZ56Kw594DV7WnIsK7N5VSxaYUdfKyEJZp9CwM5dKYIjDK9yl+uDZr3iY8oC6OPxFwlD9YQT55r+pZakdPcJl2NjZ0LGAGu/Rl8eOrig7r10gtt2fVWb7FlVRZO2Nw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eafbac88-e13b-4994-0bc7-08d871965fe4
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Oct 2020 05:43:14.3297
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ilV5T0MAMbxWU7xnEmLg23Uz38RwON72vjk+vHs4bTEwg9PXERRsQWGKXLeo0uUydOlG66aFIGOquYtWpvN+vA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR04MB7333
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch intends to rename FLEXCAN_QUIRK_SETUP_STOP_MODE quirk
to FLEXCAN_QUIRK_SETUP_STOP_MODE_GRP for non-scu SoCs, coming patch will
add quirk for scu SoCs.

For non-scu SoCs, setup stop mode with GPR register.
For scu SoCs, setup stop mode with SCU firmware.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 4d594e977497..e708e7bf28db 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -236,8 +236,8 @@
 #define FLEXCAN_QUIRK_BROKEN_PERR_STATE BIT(6)
 /* default to BE register access */
 #define FLEXCAN_QUIRK_DEFAULT_BIG_ENDIAN BIT(7)
-/* Setup stop mode to support wakeup */
-#define FLEXCAN_QUIRK_SETUP_STOP_MODE BIT(8)
+/* Setup stop mode with GPR to support wakeup */
+#define FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR BIT(8)
 /* Support CAN-FD mode */
 #define FLEXCAN_QUIRK_SUPPORT_FD BIT(9)
 /* support memory detection and correction */
@@ -381,7 +381,7 @@ static const struct flexcan_devtype_data fsl_imx28_devtype_data = {
 static const struct flexcan_devtype_data fsl_imx6q_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_USE_OFF_TIMESTAMP | FLEXCAN_QUIRK_BROKEN_PERR_STATE |
-		FLEXCAN_QUIRK_SETUP_STOP_MODE,
+		FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR,
 };
 
 static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
@@ -393,7 +393,7 @@ static const struct flexcan_devtype_data fsl_imx8qm_devtype_data = {
 static struct flexcan_devtype_data fsl_imx8mp_devtype_data = {
 	.quirks = FLEXCAN_QUIRK_DISABLE_RXFG | FLEXCAN_QUIRK_ENABLE_EACEN_RRS |
 		FLEXCAN_QUIRK_DISABLE_MECR | FLEXCAN_QUIRK_USE_OFF_TIMESTAMP |
-		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE |
+		FLEXCAN_QUIRK_BROKEN_PERR_STATE | FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR |
 		FLEXCAN_QUIRK_SUPPORT_FD | FLEXCAN_QUIRK_SUPPORT_ECC,
 };
 
@@ -2043,7 +2043,7 @@ static int flexcan_probe(struct platform_device *pdev)
 	of_can_transceiver(dev);
 	devm_can_led_init(dev);
 
-	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE) {
+	if (priv->devtype_data->quirks & FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR) {
 		err = flexcan_setup_stop_mode(pdev);
 		if (err)
 			dev_dbg(&pdev->dev, "failed to setup stop-mode\n");
-- 
2.17.1

