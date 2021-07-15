Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F81B3C9A90
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 10:26:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239133AbhGOI32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 04:29:28 -0400
Received: from mail-eopbgr10072.outbound.protection.outlook.com ([40.107.1.72]:12478
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230310AbhGOI31 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 04:29:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kte3QX1yvXEe+x6l/ASiPOq6DJCTfHiJn5CjMiAiQaCyZ74lg9eJvk6+XZ3+4zoSxk6vhSjBH6dgvsnz5YDxtqF3/P/m6tE0mBo5it7kVx+vvjSP5CqH/+PLalNyggRFzYWdhCvUSGD42U8SRsXwikmvRpJZaMEI1/YKaR15yEMcvAY4r7OIpR4idl9L7uuyIVRqrqjdFlb+LbiBZ7jTPtVEQZLfrK6Ri9cMD0c7m46f0IMkasQN9xS4/TuvJqKflV63fhOS6TtoJ66XEs73tYy92+bO6soZII3UaJnvboUSssrExBzYii3V2/w9Nv7T7LjNhI8c0qMboGIK0ldCWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgrx0tpDSkjW5NldaxEIFiHlzAVwxQLwVKpyNW31RRo=;
 b=RX3cSgTc16zKro5LGaCVPkZ0ggUejhdingAluxEAeqeSLcAJF0vZMACreSQFAYjw6W5PoBO/TTyMnKzz7lm75WFky+I17ZABu6jrDyEyj8D0gb1fydGSOReadiutgrU+T4IsO5oUYobZdrsREp+Keu6QpQRccvBfBlGL8TKi1LW9BZIar7aNMFjmgPhdOqrDLzuS/R8VapBiPXXBWNgTKh3xg7SWMV2qZNJS/QgWP5L9EnThfVtSv0xdUNXav+P1Y/6xMUWp7WVi8KLG4lkzS2uRC2BuJF0ZRxR9gl7Jdzn/DTD85M8R5YbHUkwMbk3tEhGyjj0+veva7xWJphoK2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qgrx0tpDSkjW5NldaxEIFiHlzAVwxQLwVKpyNW31RRo=;
 b=FBZvkRJ1r3mc6YB4Na7tlz4O2Tl1xw2l7Ci7+sf+CBg8kqIGnYZ0QMqVZkwLrgS0uESDyMQ89lg0Duodz2YgYMNAf8Pe+vljKJyxOTvyxxBg4XzONPts1kXNbIG2B8bpvUvfFhbd4XVfAu8BKlMqPDOXHEKDk/cfbQ8qd3uC3qE=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DU2PR04MB8680.eurprd04.prod.outlook.com (2603:10a6:10:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 08:26:32 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::9daa:ab21:f749:36d2]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::9daa:ab21:f749:36d2%9]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 08:26:32 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        kernel@pengutronix.de, aisheng.dong@nxp.com, dongas86@gmail.com,
        robh+dt@kernel.org, shawnguo@kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 1/7] dt-bindings: can: flexcan: fix imx8mp compatbile
Date:   Thu, 15 Jul 2021 16:25:30 +0800
Message-Id: <20210715082536.1882077-2-aisheng.dong@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210715082536.1882077-1-aisheng.dong@nxp.com>
References: <20210715082536.1882077-1-aisheng.dong@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0083.apcprd02.prod.outlook.com
 (2603:1096:4:90::23) To DB9PR04MB8477.eurprd04.prod.outlook.com
 (2603:10a6:10:2c3::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.66) by SG2PR02CA0083.apcprd02.prod.outlook.com (2603:1096:4:90::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 15 Jul 2021 08:26:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8cb14f39-3fe3-4374-e019-08d9476a403f
X-MS-TrafficTypeDiagnostic: DU2PR04MB8680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB86807AE2217D0A557D6642E480129@DU2PR04MB8680.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vLUYMROXA4+GtLcFVaxWPq6iewt2Azxl/1OBwuOxr0CUJ94qmJZzneBnIkT2f6siZKB8jj3uSbG11KO9dEw9onjjjwpVzU15P7AVuHxiQpv5EtC7Lp+ys3IvYhgKq+xhemcFRGotl4KSGyNr2sHXg7h9SgvMF0yozKVc0VfK2y401ApMZQfXF4N4U5e9MLsPck+zG/dD75a3fyQ9Yj8DNzJJPuCQmKvgbDDO42JGOeSyQeAnyKqdMa9sOS5CcKJMvJWmqoaA7OQ3cLraaccBadMOfo1IzCpKIaPin/nzR5diz6jKFOFTo/Ccp4GeeKR7it/Ijqzm9xIW5hrEuHskLN5vKvzU8PGxAuUXH15MnGWQixNpkm0fLhhZ9zY+ywAQF0Zm8cFTsNHCFflGRpug7nQQ1ejnh9y/fAS46botZzaeX/c8TGXhGxoi8x+qCH3gI8EPWxjz4CzamoKvnjp3miwLKRB/GCTiueEfBw65PDicv5VHLKIOsUykI7Lx6BNXkYWpCPfvrSHSjcuIAiAiBxC0HwVEnqRu+hjP38pVDUzbTj7hvXbC04+c5akANJ+VM/LvjRamNpfSL5FZcra7ZCn6oll8c/VnBABCU8+lWAjeJub0W+DVUXugL6ryAWcmNjxAjm024niJMEEyTvHi2p/N7KKoFsu/+/5He1x2JNJ5modASpT9HOw/8FKWm53nTzXeyHvBfichNbKlrCaQjwzg5SO1vgLxx6tNUkcAzEw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(6506007)(2906002)(52116002)(186003)(5660300002)(6916009)(4326008)(6512007)(8936002)(1076003)(36756003)(8676002)(38350700002)(478600001)(2616005)(6666004)(6486002)(956004)(26005)(38100700002)(54906003)(316002)(66476007)(86362001)(83380400001)(66556008)(66946007)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?utY0hZTweyp7kF92anHXrP8vxL4K5yxrjtdVhUCLuy3dl9E2XDcqNJ3J0AOZ?=
 =?us-ascii?Q?Yi7wkgtwNUej38kEyPRbzqdSFZS5Ne0K0sY2vLrGP4bmP2TbxM27Jdlt02bH?=
 =?us-ascii?Q?UKWwp3fZl5p1LaXPD0B4vAvRJN/mB1QsjhdAbX+8t8FAnJO9nGP7gwSZveAJ?=
 =?us-ascii?Q?72R/oTfUqEaYkd+cQx4c0z4yVEjPc+78qXk2/GwIGyUg/khRVxzY1N2REAS6?=
 =?us-ascii?Q?dFBJHwIlVxiBpjOCvX3XBPlYvVziygk2rwbG1rLR8Hu2/4Tw2AMFPhgVZOrP?=
 =?us-ascii?Q?+wxeSv2a8H1ZBn3EqBVSw9yMhzJ94ui8hrruvKHEnlRuiMRa6gmWIYf9dmtC?=
 =?us-ascii?Q?pE0jzSCAxBEeIG5kNo5T+2nENIaiCY5mCbKkxffG8jWI3E604+GZ4PQn/5fE?=
 =?us-ascii?Q?56nUBNRQtlS/Q2CCBo/vGlS2rQEs9wHSWG9otpqEWEZWbZf5n1/pVSsqk6a6?=
 =?us-ascii?Q?GrlD9njeor+0eGHLd7PHKi1i/UXc08MrK6OBzwdqQzXI4vVWj1+rXavDuFje?=
 =?us-ascii?Q?6jyzfOCjto/S4qQECqKm+eRTO8DdJiX8AfnKVlYC4lY71dKlQUmu73HBH9Dp?=
 =?us-ascii?Q?jlCdRQ05AzW0RcEHRJKxaYyhWCwzbLsGeS2fubuFqGlVBfNjN2OsP/T5KuXZ?=
 =?us-ascii?Q?WSWbFPdpcZ/W1htf7I6mEJKo804Ep3JeoEJM1w3XUylhtZNZJwiaNL9ivch1?=
 =?us-ascii?Q?CNTUc1yOkJDQqNqt50fyosY2gVMTRJTCdFzkpIbZX8RWjfcPTJ/insuApOgn?=
 =?us-ascii?Q?xTf/cW25mrS2x/3n7SM34X0Y+PFMmIH9rKFHposloklmtvTETzccdWNsXHYO?=
 =?us-ascii?Q?Z3uVQzWBFlom4YCBF+/bNJyVhY2GoOLkmoeNhn1m0Q/K7Sgj2xv7iOTq+z3a?=
 =?us-ascii?Q?QWKYvJuuFgo0AGtTJp/Wa6tW84QZh+BehmY+Yy1M6JHibZrdvlPVgyRNDR3J?=
 =?us-ascii?Q?o/kTZQEowskwSiLr5B60vB13cr4Ab2mE7QtAjdRXw1+I8Qj7pLbNST/IZlK1?=
 =?us-ascii?Q?HJ37nwGaQ1r1LVO3a04YxX618UhaU35f2aYxlMzLLvjoSkiDiACbLj8RLu7w?=
 =?us-ascii?Q?nsu9K2aixp7VHeAQuSq2FAYa3Y51riIVZX2L5kXP9ReNeQBL4muGej0yyJ2V?=
 =?us-ascii?Q?vgLS2NUW6niaogg6ylbpZk2qAkevpPECz6q8tgBVAwkJl603dassU4JDJqfj?=
 =?us-ascii?Q?QnGnwi+o6vewyP/hrrZjd588heo05EZJbKQeiR66QFpza/PY4zpA2BVv43y+?=
 =?us-ascii?Q?Hzwb7ztnUpE8UVvcfJ52HJhnG5bufeca+26jmkZcDx2ZBdnywCqbbNwNa56T?=
 =?us-ascii?Q?NWMW+wIRBjDLm2VqEPHOIqnG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8cb14f39-3fe3-4374-e019-08d9476a403f
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 08:26:32.2317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mtcK9AFr1i6WuHj8suMlxmkGv0e6njzINw7W8YGCZ1o0A3XPQyM2ezkhBHYhOqZykYvOvX3Sa8D3lcm3Gs1X5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8680
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following errors during make dtbs_check:
arch/arm64/boot/dts/freescale/imx8mp-evk.dt.yaml: can@308c0000: compatible: 'oneOf' conditional failed, one must be fixed:
	['fsl,imx8mp-flexcan', 'fsl,imx6q-flexcan'] is too long
	Additional items are not allowed ('fsl,imx6q-flexcan' was unexpected)
	'fsl,imx8mp-flexcan' is not one of ['fsl,imx53-flexcan', 'fsl,imx35-flexcan']
	'fsl,imx8mp-flexcan' is not one of ['fsl,imx7d-flexcan', 'fsl,imx6ul-flexcan', 'fsl,imx6sx-flexcan']
	'fsl,imx8mp-flexcan' is not one of ['fsl,ls1028ar1-flexcan']
	'fsl,imx25-flexcan' was expected
	'fsl,lx2160ar1-flexcan' was expected

Cc: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Joakim Zhang <qiangqing.zhang@nxp.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: linux-can@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
---
 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
index 55bff1586b6f..ca9caac68777 100644
--- a/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
+++ b/Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
@@ -18,7 +18,6 @@ properties:
     oneOf:
       - enum:
           - fsl,imx8qm-flexcan
-          - fsl,imx8mp-flexcan
           - fsl,imx6q-flexcan
           - fsl,imx28-flexcan
           - fsl,imx25-flexcan
@@ -33,6 +32,7 @@ properties:
           - const: fsl,imx25-flexcan
       - items:
           - enum:
+              - fsl,imx8mp-flexcan
               - fsl,imx7d-flexcan
               - fsl,imx6ul-flexcan
               - fsl,imx6sx-flexcan
-- 
2.25.1

