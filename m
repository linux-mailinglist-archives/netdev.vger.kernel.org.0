Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE0472A94E0
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 11:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727249AbgKFK40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 05:56:26 -0500
Received: from mail-eopbgr10065.outbound.protection.outlook.com ([40.107.1.65]:41045
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726901AbgKFK4Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Nov 2020 05:56:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaY8sQA0SxdEq6ihzbRKewAu0ge2+kS4FjEsYOiwVltoiX9dOCjyykNjjjKkISVNfCEYLnBEIb2bcKihlxDZsHxRrvLrv/6sEWI/hBc851gU3JJmu7LZx6zgRa3Pf00Ui7YE4gYwsffAeYINMUVOvVqznPo4tGkTzWWYQcYYdHrgcr7xwcZnVmWFtLFhvcMELubbHcZPj47yiDmLXYIKwn9ITo/srEYDXJFkmEhjEosLS9+Bl35lMSR6zfRTKnvLwPBwJMbECUq0qAoTHy1fiiiZfM8tJsKHn5/CIV+XvrAuIVNuqQ3Ss1rV6+YwvqSgSot17tXqt+Y2FbbWaB4+sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GuCOGLBfr2TyjQ6iQxEv4ZcuLpQAskKQm+SwOKA27A=;
 b=Ni1Bp3q4agvk87JQBzlCfJ4t1TjQfU8mkfnOuBlY5/VanKw19udh54v5NMBgelkWekXUv3bYKe8ic8D3m3a7H/gw+wMLL/4+U+VgYspyeMHvpOyLs5M8t5106z4cB/2mCZ5A/x/d7+eO9oivGRhOjkTo0RVCGtR7P9u/G6aSceT3Xj1+arz3BRNO9syb+3PhCmheb8Lqsg3q5bcV3O5aPrXcyy5HskP1JjgJEy3E2lngjhYSgtKm4v0q6efGKKMtW42qGElUahe276y9UVFjID3Vq6cfLo9Mhm4kwzO+59Yqqc5VedDpJTTkMy4zD0jXJ7P6Pz2+GAT1uxPMQpptlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GuCOGLBfr2TyjQ6iQxEv4ZcuLpQAskKQm+SwOKA27A=;
 b=OTKmGLkpqci6H/1igbR6AW4uilHtv3ORfMlhDcSdT9oBfqARDttmTyYhP3YKoS5OJfbEnY+7qZcW8ye2HOsbAaCAqtiP6YuY856G7gN5WUUZ8A2JcHIB+9A0G+Ar01q7wcCRJ1hHqCEOcEXEqMn0FzkGCXsmDjjxJW8Irixy/hk=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB7PR04MB4282.eurprd04.prod.outlook.com (2603:10a6:5:19::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Fri, 6 Nov
 2020 10:56:14 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3541.021; Fri, 6 Nov 2020
 10:56:14 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V5 3/5] can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE -> FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
Date:   Fri,  6 Nov 2020 18:56:25 +0800
Message-Id: <20201106105627.31061-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
References: <20201106105627.31061-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SG2PR02CA0055.apcprd02.prod.outlook.com
 (2603:1096:4:54::19) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR02CA0055.apcprd02.prod.outlook.com (2603:1096:4:54::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Fri, 6 Nov 2020 10:56:11 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 9e3356d0-cb9d-4574-f6c0-08d88242943a
X-MS-TrafficTypeDiagnostic: DB7PR04MB4282:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR04MB428271886C074DABE30FD9C5E6ED0@DB7PR04MB4282.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 15IiW0L3XR6ucT9rzH9kRBNFywWX14sEucd72Zal40Hvv4P053GCPHioh2wxfatmQFzBGgzewNAQLpJaopzCQuJY84ABbWA/gkEKx3/hokF4QQd7jm9rVZb1n4rIrAd6hCVa0Rd+pXItgbWVe/1KfaOTaUcf6or3n4Uq9k4wWX1MsuWZ2r7vKTePeFJwpG3gGIcq7FeO5HUgxA3Lg8k1vWplW2Wabrsl8eNrb6YxlVJbGLvUxfTzoU5evk8Yjc/CAmcd/3vknaLFOgrUEv7naTkPgu+sQ/qhrDV3cNvox5EOBOrNnyapOUXamSbTltI0EbfCmc5eAx1l5ffvsaObP5Qbqqi9j9ig4oWzs+ByJU4OL5zCNGJWdXZm6tPXEvby
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(6486002)(5660300002)(478600001)(6666004)(26005)(4326008)(83380400001)(6506007)(956004)(36756003)(66476007)(66946007)(8676002)(69590400008)(52116002)(6512007)(86362001)(186003)(1076003)(2906002)(2616005)(8936002)(16526019)(316002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FPaWr3C9z4iYmgv3O/531Tkg/6EmP4iQ6XHc6OFavk+OJfEQt3yt+FxtNJL82ry7P+8LZZCnNNxRFbLI1F+slrsYmlaCQ2nkSuqRD3EGL5eVb15bFiRQZxRhZkk9h93yK7vlb40zru11SnPnzyjSt14Z8qHeVM0YCHZrqXU78cJzknQwfn1XpqzLxXB8IyTgwvhDY0v3Yi2Suk75IHfBAQBxXxl4d3lj3jSr0B7YSFhGsuQr5TEbHBmJl50SrcMJUOpMZ6kHVIDYG4+LuQIpm8c/zOPrIt1Qq8u5jjIYxnSjQRyBWUqjCCLjjWO0ErAD1dUZwKe1pl0n5AW6W6vl7MPVyjWKbXD+nIuON0oROonxgT3C3JDJHVkdQiYaSzW3BCsiknLfZ/auHk8TukbphuM5FYS5sHJ+AUgI+mPEcwfE1p1+hTVRAwQLHwSXOApuy2JOfwU37o9EzmWJF+uv4ZhkNLRcdx4n5de8BXJVhianHTuV2pxLWY7d/0zznKGxkMVnt8U/Y9GMCVOWPujoOJbkdja8rUV9yGh/ar8vpZH/NIDPz8TKlnr2SLU3OqUlC0ne9Pzcwh10YSqU6Y582K2yQmgaNBeMAj4EjYphh5RyFhetFSIRr93h2/MrY10nN55K/49OULMmLkvGPNwIXw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e3356d0-cb9d-4574-f6c0-08d88242943a
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2020 10:56:14.1310
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e7gL0ArSKf6CRQToDzriUddLm9Yo6owNXAWz2Ql/53ZjA9+QbN1fr/edbmZU6kLi30NQWyUePsums//DVXzqJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4282
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
index 881799bd9c5e..8f578c867493 100644
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

