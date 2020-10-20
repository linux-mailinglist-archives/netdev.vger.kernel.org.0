Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07DF229363E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 09:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405715AbgJTHy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 03:54:58 -0400
Received: from mail-eopbgr70085.outbound.protection.outlook.com ([40.107.7.85]:51586
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2405611AbgJTHyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 03:54:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltHHu7rjiQozftsASBx1wmTym5ifs8/w/rLDMkznDcRlIaKU6/h6kqIxuCRX7aSs7wyk+UcbYXAwQrl4D1j0WwhtLl3NdfQmHFlJWxb6rr6kqJnA72eUv3aD7Pb1pYjukOpalH8Ni6/PnPhQ99dlL93Rhb4S4M2Mkr08uOISMWSs9BHbdv4wiIazV2Iqg3yj/oNx/yIt2c7s9Ku2BUEm5X3+xQJny+de/WqpucJwJDpYW2A5DlbdnnZ7XYAg8dboT6EdUpjKocRYdJICC037I1ipv1bqu8pTQhJARL5vyw2wgcNDQzyv4otEpOjyR10+3o0lHMhgXtzvamJU2u8/3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GuCOGLBfr2TyjQ6iQxEv4ZcuLpQAskKQm+SwOKA27A=;
 b=chF5WYgbiUH6mHsVoqXgaIcIyjlSqMux95LoLglGo9vUdSqFlvHOXT2ddpVaXtYPfljfygBs3JO4P1hyYi+EfxGkSSpalAoJ4gxiskdEIjbPP9KV9R+XBuRASAxk3RbZrZA3koYdt/8RlwOE3vHLoYQ1sMPWWxBopCGeAWLpQbQbkiofjsAt1q6Swf0dBxN+RPuIVJJFvii8Q26d/vdknDzDvqUmnBFfNOsnWi5qMC0H0QDqe/rDjE57hQZNkAxUcs/+ZjvXv4aOw0OVbj0giU/M6Vv1eG4XM0O5ldJfnO7/lCHI4EQ2h2xyDcIldEElmjoyPr9IWTp2JWgJLXaioA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5GuCOGLBfr2TyjQ6iQxEv4ZcuLpQAskKQm+SwOKA27A=;
 b=S5qt2tJ8kIEtj3ClTOA5uwPV3PDqk15Je7VeC+j42bzWvHF3EnLIZ2otFU8r+qEnJGWdqnrzO+lXUXZEv2xlBURPGnivgztItHak6TiRlQRbhz/QWnu3o5pV9H98XEsiE4Is72siM65TYoMjZnc0hMPC0ZbUyxXl2jjwwX2mjhk=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7994.eurprd04.prod.outlook.com (2603:10a6:10:1ea::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.29; Tue, 20 Oct
 2020 07:54:36 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::3c3a:58b9:a1cc:cbcc%9]) with mapi id 15.20.3477.028; Tue, 20 Oct 2020
 07:54:36 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     mkl@pengutronix.de, robh+dt@kernel.org, shawnguo@kernel.org,
        s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, linux-imx@nxp.com, victor.liu@nxp.com,
        linux-can@vger.kernel.org, pankaj.bansal@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH V3 08/10] can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE -> FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR
Date:   Tue, 20 Oct 2020 23:54:00 +0800
Message-Id: <20201020155402.30318-9-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
References: <20201020155402.30318-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-Originating-IP: [119.31.174.71]
X-ClientProxiedBy: SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0015.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21 via Frontend Transport; Tue, 20 Oct 2020 07:54:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b651d4fa-f43f-40cf-e45f-08d874cd63d3
X-MS-TrafficTypeDiagnostic: DBBPR04MB7994:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB799456D1D2CCE7A2A6C39374E61F0@DBBPR04MB7994.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:372;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: igEYDc+C7qNYVN5EaK/RuhpxYeBvZOI/CYcw7S/osnNlNFDIWgGRE/hDpRgeAqb6frZGnRBigOtU4GfHXFMCEufTcxUgd07FJVgFN+LXeKDcJl7BOeBdj2esU7Dnt7b4lxBkUa+OyxbfkS+TNIOiSjs3fRXk0ZDhr7lBPLGRT/9eMTI8h4NX/BBVl5eRJS0FVFXjM5pJglizXH8SEdfIVldFmFRqgw9U8Chyt9Zp9BqZypPNEVrdK3ZdfcgFmcWRbmGnmlHxRh9G6udq/ZByqjVbFdjNvG/sopoTxpA5wGX330N2t2Rm8Hvo2OPTRpY982A1dl9FfcP9wPiw54rLg6hRQOlOvP366RqON3UDZ7YhxU9hMOmTIfDD+OrtAET+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(396003)(366004)(136003)(346002)(376002)(4326008)(6512007)(66946007)(2616005)(8936002)(66476007)(36756003)(5660300002)(478600001)(6666004)(83380400001)(69590400008)(26005)(52116002)(316002)(8676002)(16526019)(6486002)(2906002)(1076003)(6506007)(86362001)(66556008)(186003)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: XJeYxsXDU7V3GKyxXW3dcZfkys363/SRwSQPWnKtsYq8TKvegJ3ppTqZ91SjfJUMsYuasWHfmv6rAxluSOEcmlD1nml1RTs7mFxhEJnm7e1nJbgCGhY9kG+Hj+HoAqnp0RvKbuyIE5Fcq4/T6h79iQjv2qM7leb/eUhKavH7tUkl5byMJt1O+/3fcPkvuego0gzOly6tVGqCHjicggEyDuiJ66XLQ9gshTlWBEFROt6seRH5j5iLndwe2iN++tIQdVZGwubAm4pn51PvlUpxyC3FxRi8o8HEXvE5PYXtocfyG3BZQHZaMey3VqMJQzg/Q62mcUtzlz/M0Aai9wsDdriwqInMgfuoQ95Jj7EfrwCI1nCF1v6zqRi0bMA67oTV5QatK4x06vLfUDVC83xZLFA8OF+zrpgDGFL+aTYHitZ9/blpIa6RRjbxG9519opGAmRqVthhsok0FA6syVOKRBSQ3e6RLKwBklO+Im69tGVScQTniDUM0FhUslkcmsElGAmqK07mMBd4/VuJGxBe29VSmYTwY53UuVYO7sgLwewYPWXgc+Yef9ZODvI1l2xhwBMtN4VtB5DtwYrK7EpBT/gRQVeUXhskJgAzBCF1S6f7hjUAxd+wMjx7HLarkFlpX75za3bAIFH78wcfI1bNpQ==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b651d4fa-f43f-40cf-e45f-08d874cd63d3
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Oct 2020 07:54:36.6775
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdqzWA2Pfw0nL810jgzV+A5gD4XgpYYmLDaokmN097i245YxIvknI8aoxnQ4uCfxTa2QZ5dRkFI217Tw8DvTVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7994
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

