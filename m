Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA91362684
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 19:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240489AbhDPRPQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 13:15:16 -0400
Received: from mail-eopbgr20054.outbound.protection.outlook.com ([40.107.2.54]:37093
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235011AbhDPRPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Apr 2021 13:15:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lwfSV2m6lvAgdmstw+DLPqFuhnq9JulMxz831XzXpzcrC7NBb2hO2Y8k76h4w/oZZkstnJU4HhEgYwHuVR8OE+El/u1/ZUGBj6kNCiOIE1vErkKbBWqIOEWe0XFtyFKBP8Ei85/4PaPoH4xYIkTvDQXrCVy0SKl1Xv4T4LSAZEXlg2fH68c+P+usS2U00HV0wD8QGEvKQKi1gmq0tM+1RIx4VwDOxEk3l60Ps8gIoyd+sp/FHU73o8TEgbP6QrqePPgA69C/Pq4zsiX1Nwyu2zUFj40UhdIkF+0XK1Mtz7VD8yufoobrkp0DqjLssNndmfMqqLX13Tgn6A2/k8tgvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKgtzMScuRRo/afCfPWFSq/xDYXgqWEI9EOiZEP4AaA=;
 b=lp/AYKnHkjq7DhkPnhgx9gAwpMVAFSIrebkw6f0QS95wQwTI8zazns2cQQ72KvkSAM0G98LRAL2WOROfmj3TSsZjhXVjeCEgd8cNasXuqXbRGwU4fgLTivII0nXrF854sVzMBdg39rNZOvhC19c67QiXlI4Y5Y0lsFYRHnqaeY8iC9KxHEJf7HxUEd0zchwJroJkHMZcAX0s+/e1mhtx3KPGpcuhEBX832F8MM5KPfvt5jTB7WzlfFn1VE1syFB5uk/DnFcDe607lukeTWu7JlYA9MnhmoalfdnNUi9Bv7gheSb9Sk8FbjTK1wLeBi9+YmzpfjWtr7BfcD8AZOWNhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hKgtzMScuRRo/afCfPWFSq/xDYXgqWEI9EOiZEP4AaA=;
 b=ZEnbuY3+hE9gX7jtH0pST7kHNwwrOiQqu9gvXAUTxYUBBvw74DxOJpAFSiueJQs+FyX/OuzbVXNmhuNNSq6BiNL5i55XrrchWx4lygD+7y76tLTE+Je5veK2ZZhLYdHnTxyMhinbk7o4hjb70v8OIQmuvYuMIJJ/Jw1U4lQaTBQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com (2603:10a6:208:170::28)
 by AM0PR04MB5140.eurprd04.prod.outlook.com (2603:10a6:208:ca::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Fri, 16 Apr
 2021 17:14:45 +0000
Received: from AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a]) by AM0PR04MB6754.eurprd04.prod.outlook.com
 ([fe80::f12c:54bd:ccfc:819a%7]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 17:14:45 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH net-next 2/2] powerpc: dts: fsl: Drop obsolete fsl,rx-bit-map and fsl,tx-bit-map properties
Date:   Fri, 16 Apr 2021 20:11:23 +0300
Message-Id: <20210416171123.22969-3-claudiu.manoil@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210416171123.22969-1-claudiu.manoil@nxp.com>
References: <20210416171123.22969-1-claudiu.manoil@nxp.com>
Content-Type: text/plain
X-Originating-IP: [83.217.231.2]
X-ClientProxiedBy: AM0PR05CA0088.eurprd05.prod.outlook.com
 (2603:10a6:208:136::28) To AM0PR04MB6754.eurprd04.prod.outlook.com
 (2603:10a6:208:170::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from lsv15141.swis.ro-buh01.nxp.com (83.217.231.2) by AM0PR05CA0088.eurprd05.prod.outlook.com (2603:10a6:208:136::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19 via Frontend Transport; Fri, 16 Apr 2021 17:14:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0db8c0de-c84d-4dfd-e1fc-08d900fb21eb
X-MS-TrafficTypeDiagnostic: AM0PR04MB5140:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5140DB53039DAE5C06B6F43E964C9@AM0PR04MB5140.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:530;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GLWMe0fbyW4dvJ8FQv+Z+EN+bspHsbxg/5kifZPLAaFQhVlI9AEXFq30TGzxt4ibyE67dpCjx39PC84uwbe83uHZXdJdGEso+zg5jpNO19BJMXcvL61wtQI4vgqPkwcG9mEgFtBjR+pqFslzeHsS9CLW2rSpw1yin8/7knFnNQWXdcfYIkzx7ginnFXZiUz6ZewBDM87h9juygatMogDAGV4WOqCgoPRVNEazCoMOC5s1N0ujnNufLaJ9XsbnB94f6qTE7B/9o9UaDx+QAqsDNmgADMgoqqFM3b+HhxiyQlVntyuuumPDs3DN3uvisoM5q6iOh5zHa3XXpYozsKJjrfPDUrUv60t7IO4Po+i00HU43NVuA9Xxjq4kk5VGz5CJ3SoIxa6Ab6AZIpOd2ZYu/HqwW+4HDA2C06R3POjC5ppLllSjntmIwBOR5cShDDDAaMA0itD/nXQczoWNlNzH2S/CvTMQr/+3vKA8qZExjtM3zRR83BQzWz8+IcfAtwyvpauR7E2S1bJBnuHy4R0fwqOVUdpYAE4MfIiMQTmABhiSzTrFKsDRi/D5QQOHN/QqQf1YNn8ZevlCoPisKg6aJ7M8m11oQvFYg/God1VYHpBNKc05KgKecSmQNxLz6bWE2PNmhUwmvYdmdXBXlodAcEYMzfryBxYtvIQVXKhRcg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6754.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(376002)(346002)(39860400002)(366004)(66556008)(8676002)(38100700002)(38350700002)(2906002)(16526019)(4326008)(8936002)(5660300002)(36756003)(52116002)(86362001)(7696005)(66946007)(66476007)(6916009)(316002)(54906003)(186003)(1076003)(26005)(6666004)(6486002)(83380400001)(478600001)(956004)(2616005)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?+1znHluxBFUPiMoCiS9+YAc7wtMW2gug8TbktsuW6ePZEpjcBxm2DKNE1qvv?=
 =?us-ascii?Q?BBnRo7Ok/1zD3bSMgoptNPd/Z4jO5/e/SdHm/GuaMrjBF8VTQI/mcD2LFrE4?=
 =?us-ascii?Q?RPzSgeFQaUqbY2WDhsnixNI6LptsRG3uLmbQDETVJXbfBMyjyK41WXhccB+o?=
 =?us-ascii?Q?wJ4Hx0S6bq5O44EFn8HhmYjTze9NDPuCI0ehdHYR8E19SOboG8m89NdrP5RI?=
 =?us-ascii?Q?0h7+GSR+WM2BjesRbd/j3KzAsnpAUQobHGweWMCRIA3tDe6cFMXDl2cOI4Zs?=
 =?us-ascii?Q?RNjIXuVFIGyAOJZUe5H88XCF6gbTyaPJ29kQOEkX7iTJZmZrkXu2yQ5r18YZ?=
 =?us-ascii?Q?TyFZ1PjSv3F3xAfDM4BS1sg9GUgnRd8ueZpaLzYmzI2ZHss9opo8GeEOGQRJ?=
 =?us-ascii?Q?wySx/BjcH0boDRIZP+XCmADRfr+2SRUq8th+gWnlq8V1uCtFLsF9o4uDW1+d?=
 =?us-ascii?Q?w+HzLLNsgP099xr/F6Mvyv4bmtEP19gvqzK8PTpDUswJIK/G1X9GZA/9Lja0?=
 =?us-ascii?Q?uuJT369KbAo+OW/UgZ70aWDGPWej5yLbvuFty9g4yHvuWzOAiEgxyE9lTNrq?=
 =?us-ascii?Q?DxCbumx1mke50TDZWz9GfhIJE+alcFp0vLd8M4XTNgUzPQyTPh1opZF56BbL?=
 =?us-ascii?Q?ZdgWlLNqYdsV70i18/gidzt+6LmIJUoVyQyiguyPHtE/JXxPtwea5xHp/RDo?=
 =?us-ascii?Q?VaZQWqspxDjlaUn+WqPisESvWRdEv3PHkJG4V8PAqZ1k0RTnVoE9v5N+ADku?=
 =?us-ascii?Q?d3VCp5aPCGC4jWXm6YftPoovoawhOFkT3XEYKTL9EEQXAOeDQAtKbhNe4/ue?=
 =?us-ascii?Q?ZdlRSk97VKcJID2tFbsXQKALPc4T1SQnmljop/pjd9EEdlqiTnGXRZKipbVY?=
 =?us-ascii?Q?IvAOipARXzkvYo4pmD1+Lhql5JVbHizRenGqRpGAVKVDBv9n8mp3609KOp1P?=
 =?us-ascii?Q?2L26Mpzx/siDLEFCnhhvX/E2ql6m5pqFR2XtkX0HP3sAQXRp4X9qjpRsE7iG?=
 =?us-ascii?Q?u//Yo8T0qI6QeRSLJFs6x/vfL/xaQ0wBRnvA2v4CJB4E7jqoe4L4+UNMXQ1Z?=
 =?us-ascii?Q?pCr4RmhdeZFTCC90o/AmulCsQexJI72plMTgSmzkEkmWUGg42mQDitdDG0Ax?=
 =?us-ascii?Q?HhHTDQi4imcayRw6ipyA9szEF5aT1KpO4x3j22uyy7DfIcGyGlr6vHTQjeW0?=
 =?us-ascii?Q?0TxFTAWsj0xwdjdn4svNvIHUZiQeoQSQDopwD/rr7nl2T2ETIpU8textFz3F?=
 =?us-ascii?Q?NWOnVxxUGQ1+9YhTbDCj8VAxDrob80T7WN3Icuq0JteVz9lNHwJoO7myqTZH?=
 =?us-ascii?Q?ljKMCQkF2aJMg1yBDKCdFY/t?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0db8c0de-c84d-4dfd-e1fc-08d900fb21eb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6754.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 17:14:45.7183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /HrzVmz1eyUfdMEGrb9cE/tGsDebCL+GvRlZ8A/DpJc8YeaGefgR4OW9VLDQyY2S0bKLTxfz2DLpnADy0hVzHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5140
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are very old properties that were used by the "gianfar" ethernet
driver.  They don't have documented bindings and are obsolete.

Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
---
 arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi |  4 ----
 arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi |  4 ----
 arch/powerpc/boot/dts/fsl/c293si-post.dtsi    |  4 ----
 arch/powerpc/boot/dts/fsl/p1010si-post.dtsi   | 21 -------------------
 4 files changed, 33 deletions(-)

diff --git a/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi b/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
index 0c0efa94cfb4..2a677fd323eb 100644
--- a/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/bsc9131si-post.dtsi
@@ -170,8 +170,6 @@ timer@41100 {
 /include/ "pq3-etsec2-0.dtsi"
 enet0: ethernet@b0000 {
 	queue-group@b0000 {
-		fsl,rx-bit-map = <0xff>;
-		fsl,tx-bit-map = <0xff>;
 		interrupts = <26 2 0 0 27 2 0 0 28 2 0 0>;
 	};
 };
@@ -179,8 +177,6 @@ queue-group@b0000 {
 /include/ "pq3-etsec2-1.dtsi"
 enet1: ethernet@b1000 {
 	queue-group@b1000 {
-		fsl,rx-bit-map = <0xff>;
-		fsl,tx-bit-map = <0xff>;
 		interrupts = <33 2 0 0 34 2 0 0 35 2 0 0>;
 	};
 };
diff --git a/arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi b/arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi
index b5f071574e83..b8e0edd1ac69 100644
--- a/arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/bsc9132si-post.dtsi
@@ -190,8 +190,6 @@ sec_jr3: jr@4000 {
 /include/ "pq3-etsec2-0.dtsi"
 enet0: ethernet@b0000 {
 	queue-group@b0000 {
-		fsl,rx-bit-map = <0xff>;
-		fsl,tx-bit-map = <0xff>;
 		interrupts = <26 2 0 0 27 2 0 0 28 2 0 0>;
 	};
 };
@@ -199,8 +197,6 @@ queue-group@b0000 {
 /include/ "pq3-etsec2-1.dtsi"
 enet1: ethernet@b1000 {
 	queue-group@b1000 {
-		fsl,rx-bit-map = <0xff>;
-		fsl,tx-bit-map = <0xff>;
 		interrupts = <33 2 0 0 34 2 0 0 35 2 0 0>;
 	};
 };
diff --git a/arch/powerpc/boot/dts/fsl/c293si-post.dtsi b/arch/powerpc/boot/dts/fsl/c293si-post.dtsi
index bd208320bff5..bec0fc36849d 100644
--- a/arch/powerpc/boot/dts/fsl/c293si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/c293si-post.dtsi
@@ -171,8 +171,6 @@ jr@2000{
 	enet0: ethernet@b0000 {
 		queue-group@b0000 {
 			reg = <0x10000 0x1000>;
-			fsl,rx-bit-map = <0xff>;
-			fsl,tx-bit-map = <0xff>;
 		};
 	};
 
@@ -180,8 +178,6 @@ queue-group@b0000 {
 	enet1: ethernet@b1000 {
 		queue-group@b1000 {
 			reg = <0x11000 0x1000>;
-			fsl,rx-bit-map = <0xff>;
-			fsl,tx-bit-map = <0xff>;
 		};
 	};
 
diff --git a/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi b/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi
index 1b4aafc1f6a2..c2717f31925a 100644
--- a/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi
+++ b/arch/powerpc/boot/dts/fsl/p1010si-post.dtsi
@@ -172,29 +172,8 @@ sdhc@2e000 {
 /include/ "pq3-mpic-timer-B.dtsi"
 
 /include/ "pq3-etsec2-0.dtsi"
-	enet0: ethernet@b0000 {
-		queue-group@b0000 {
-			fsl,rx-bit-map = <0xff>;
-			fsl,tx-bit-map = <0xff>;
-		};
-	};
-
 /include/ "pq3-etsec2-1.dtsi"
-	enet1: ethernet@b1000 {
-		queue-group@b1000 {
-			fsl,rx-bit-map = <0xff>;
-			fsl,tx-bit-map = <0xff>;
-		};
-	};
-
 /include/ "pq3-etsec2-2.dtsi"
-	enet2: ethernet@b2000 {
-		queue-group@b2000 {
-			fsl,rx-bit-map = <0xff>;
-			fsl,tx-bit-map = <0xff>;
-		};
-
-	};
 
 	global-utilities@e0000 {
 		compatible = "fsl,p1010-guts";
-- 
2.25.1

