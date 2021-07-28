Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033413D8D19
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236151AbhG1LwE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:52:04 -0400
Received: from mail-vi1eur05on2074.outbound.protection.outlook.com ([40.107.21.74]:6048
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234537AbhG1LwB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:52:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DVVnBbsX7MAzcN8zdgy6sh5WcQgTfHeii3sYMZ4uEVAA9LNVDOKOXolOKHOQBJ+ucgmAQIIDVPJaUD8/M0xr9GtkWWTnte36cYqeso4Px6Xe6zDEYQlc1AT2UcmrGQ8muXyozLYsEL3hWU57j2EyxuDv90hzJ+RoGLRUr1Y/rIDf1xfdYnxeYrljUbk/XNcohzzYyZkDILYhKcjtYb1F+5CgL4L8ugg+5apkoYYHlBECo50KH8+fmUggtwj7y5Qo4YCuA7nPyW8MLJz4WYRxkoF/p4G6f+1BY7kcKQ2PmF3xEOKShdt8bmGjCWFaW/zKNUIigxmrW8PFnBTwZH2unA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dBoHA9YqpMrACSvbmy6Yl1sCrm2gEuAaQicnSnyxos=;
 b=VStl4fx7UNK79KsboPlB4fL8s99FyMC4jCa2aRHrDV6qIp75zY8oTItRpIB0ezQIJZaOVlDgppEYwPyAXLDiqP8RwvVTdTMU+ZnP3c4sKxymj8sU0QC7OeLEKyg69hTI3Rp9Xf9zxPFbcvNXUezoy3TF++njaKKv7iHfhSP1hI1jFQquhL7JY+9UXZY03FnQ3pI1nBjEn13a6Oe2lUjDPCOK5bjHndkIzdb1rQxgbyyqTJ3zU2MErYxqVab/GB88NSFKEKIIUTZQswVca57Mo6kUH9RFfgtiSEg9F83hlXtQ51bhjg7yixdNrbrEIbRx2I3wGdZIZI4wP5I13QVskQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4dBoHA9YqpMrACSvbmy6Yl1sCrm2gEuAaQicnSnyxos=;
 b=LHgYjqL7qaryvX4qrZjxtnF/y6zLP1yJu4G9G4te9G7IzH78/vI1EnMp0NcCGnXyujh3g43YZmKlwDKlip+mFlqWtm18fkAn1FzXwDyc1WVUH4EtGSRiMszFXrXCwy1Y2OogjtrHP9rCXvZxGXhOHUdbcaL/5OTbgkPyaOqvbbw=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR04MB3094.eurprd04.prod.outlook.com (2603:10a6:6:10::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18; Wed, 28 Jul
 2021 11:51:57 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:51:57 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 1/7] dt-bindings: net: fsl,fec: update compatible items
Date:   Wed, 28 Jul 2021 19:51:57 +0800
Message-Id: <20210728115203.16263-2-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:51:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a0f81564-aa55-494b-f9f4-08d951be1a1e
X-MS-TrafficTypeDiagnostic: DB6PR04MB3094:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR04MB3094F9135C159D68E61D9AE2E6EA9@DB6PR04MB3094.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:843;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qNUWaSpTX7n7j/ncDDu5Llbn2aMg4zv/cMYhNkZg5RGRh0WoQ5ALwQVP6Dy/z4jlXf3VGJ7rvIq5bzwo8md5vb4B5j0hoRzLKhgZaiVmyKip7ID5OQoJkKQ2pCOUTqI0ZKxtXYT8YEBYNNwwPOrkSbYw+Qj/IBbkyInyB88iMxGNonljVquSFVnXv1pxxdQeAWS+1v1vYRFIHNTggsFktFGHx1iY6qL0TWk9WpMkJIVtC6h+GI4GvPsplH9hC+0j5oHnIHQDMlOtvqHOr3fm2CIJxf3CYDr8IzkeB5DD28n4B7OTK7Wf2EJF764kg6aqmCXi9NgUUrGf+VftP1C6uKAyP/BLey5nNBNDIkzOgpCGZxiKUhBb49atpJ9zhGOBK32A9arbPWS0qrNp0coAJzBeJ1ZoInhKKGtTyFto98AamcUOWaVWQZk2m69E+JsTZr5v4R/r4pti8cWv9idtUqM0+tCqBz6zY4ieQPPRYPqQ4BbphSb012lWJcHg5bNTNMJ3GgwObYnNyQrtl7NqOfOMv3CCCVn5AMeNalGv0vHT8xUR3pjfv+qhd0cr+rfMNn/HUKWYbV4NjueF4tUO8FaPGbQeerZ2FApcD4bcf2AD6pltXTc+/4B8fvFYq7Z3gldvFkMNGf8GoR91OmVdQmY+NlMTuJg8kJC4/eEh0StQqocGpU1avz9/I1XTn1yE/SrblbWnirdVeSkNaANm3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(136003)(396003)(366004)(376002)(346002)(6512007)(7416002)(26005)(2906002)(4744005)(6486002)(66946007)(66476007)(66556008)(8676002)(1076003)(6506007)(478600001)(38350700002)(38100700002)(186003)(5660300002)(2616005)(956004)(36756003)(86362001)(316002)(52116002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eTsJ225OUUqZq26ThIv7UXzysuuitKXUiOgdMysbqh9i/Uc90qMTO3ESP20m?=
 =?us-ascii?Q?IkwuioCyLVNXJSiOCG/E5MfdQ+koSEI0VkuNTVfzo2/eZKOWQNJ2g6G0klBH?=
 =?us-ascii?Q?Z4phXVDDOV4Zw0PBOq+y+ZACwMIwpx8a67mryB6gomnE9Ls5kAcIy0fPdek6?=
 =?us-ascii?Q?VZH0Rjzu+3RRACpc+Hj9zD7RGrjv6Ai4BMwHNtgJjp3ipi3g9PSwmuHHIq4+?=
 =?us-ascii?Q?fKNMxLqouHk9+LBKBSJ0tOLRs0V5C0kwd8TLwlMpcAyZnorFd3JRLfGmIYbS?=
 =?us-ascii?Q?z/lynIR21666NjMFSOzPzks55JOgYK7nkZIcpRpXLIHjYmUUyCaOKmmjeaz8?=
 =?us-ascii?Q?jCkY1Ufqjx0zKIT7jQpj3eQVn0Vn72uE9vR3OMcFBW1AsHiBW8Q6wIThUmor?=
 =?us-ascii?Q?jgK6CUQ7j9F8UVJp605YDzwMvGLJJ7h3OJ51y9hjfo+ZZPO5PjpfEKPYN4xr?=
 =?us-ascii?Q?CkXABUpEXkQrfx/26v3UD2vLEiK3j/xV/f7nWxVtBviDohqt8rhPvN76+Wd5?=
 =?us-ascii?Q?K4PiVFMKJxsx2KJx+GzP8sfNbMeFVTXmQqAufAfTucd7ZmuqOvnvgxVwTcn9?=
 =?us-ascii?Q?sFdkQgNx9dmja+y2Q+A0oNgUblTfV5MCl0qizst+UL0zX3lgaSjYx9NTiiR9?=
 =?us-ascii?Q?poM3P3cpHAdTak1ZiWwy1IxdQU1fgAsRqIYQpjBdYDdUhcVJbE/UASfCFGhd?=
 =?us-ascii?Q?vU6f+kvwI8V1KxKPs7ECXDwSYDEgD3+/N4wFb807zCtbSpiyQZ+R2L5bYS60?=
 =?us-ascii?Q?9okmqbW48kzH9ShuEmHtqvvP4Fl9OywWlwc5fnQtX/kyDhmdA3hV5LBvH1BO?=
 =?us-ascii?Q?ZJh72J0kcrzQ84E2ozJ8aJCmfExRwGBfQ3ybMqqbL9ZyRYaERp0WIEKE30MY?=
 =?us-ascii?Q?NWhzUmnhymxWdcIJA78+sgtYNzJ4+ykAhCY9vf8jH2UglxqqwiFJCQk3jaTV?=
 =?us-ascii?Q?A4woDrJETWC4LNPqx8jcRl8ucUF+yl8IMK02zfaSjL284NHW8kYPN+bF7NFu?=
 =?us-ascii?Q?sBsgcBue0mBI6wZ8VheJ156y+R9yPZJJDpC9zAzAUKXUKZSLSe3ditfcn0pU?=
 =?us-ascii?Q?j8T7Sh0KmxPQSZMKkXN8tGryx8TwVtz0znMH3tm2H3v0500JgiSvLtqZhLrl?=
 =?us-ascii?Q?rVO1vx0ydTL+sVqh/KvcissxTQEOUzvh9RyV4HcmsQcEzJmzzaaWG/L2mTHH?=
 =?us-ascii?Q?RXnmHIFzoE4AjMN8IR0C2HjDx0JMjMy3Gh9VFLBTbPaBo1KgQBaGzg+XBlMB?=
 =?us-ascii?Q?y53THWcGaEk8RcQ3Po9zHUVKt3N7Eyt8FiAZvBEz2StTFCwbSYYrEt2aT65I?=
 =?us-ascii?Q?pdND75P/CI6pO47ib9AEznBU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0f81564-aa55-494b-f9f4-08d951be1a1e
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:51:57.6566
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ZZCzB9hRPeLAYKjpclxDPV/eiufqNn1s6J4Bon47kCq3i3IJj0fw7SdKNmGWG8lf17KnuMIzzqkDGfucqSQEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR04MB3094
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add more compatible items for i.MX8/8M platforms.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 .../devicetree/bindings/net/fsl,fec.yaml       | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/fsl,fec.yaml b/Documentation/devicetree/bindings/net/fsl,fec.yaml
index dbcbec95fc9e..b14e0e7c1e42 100644
--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -40,6 +40,24 @@ properties:
           - enum:
               - fsl,imx7d-fec
           - const: fsl,imx6sx-fec
+      - items:
+          - const: fsl,imx8mq-fec
+          - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8mm-fec
+              - fsl,imx8mn-fec
+              - fsl,imx8mp-fec
+          - const: fsl,imx8mq-fec
+          - const: fsl,imx6sx-fec
+      - items:
+          - const: fsl,imx8qm-fec
+          - const: fsl,imx6sx-fec
+      - items:
+          - enum:
+              - fsl,imx8qxp-fec
+          - const: fsl,imx8qm-fec
+          - const: fsl,imx6sx-fec
 
   reg:
     maxItems: 1
-- 
2.17.1

