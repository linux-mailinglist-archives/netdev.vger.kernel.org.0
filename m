Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 823DF3D8D2B
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 13:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236331AbhG1Lwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 07:52:41 -0400
Received: from mail-eopbgr80082.outbound.protection.outlook.com ([40.107.8.82]:39300
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236261AbhG1Lw3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 28 Jul 2021 07:52:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jB64N8guVLyldKGNd40qJy2oHBEdUXxYkiwAMxKXhQuSO2mX47w0baQ5kEJEiCJk4o/fOYiYYaJzDbZJWF9DUq6QrOJLlxs4xIegPmIrcA6dMKsfGIrcguQ37L7GCSRcOi3Wm2bRoRJmaq/6l14yWJTC3PELWWjqPGWoJZv5MWBA2DogqgdPVc8X/ctpR4jc17i0S8NKEoTdr060oKFT92IIZDxpmkSOiYpBnJjU9LPdbotMozIR8lP7RdyJ3DAFovIWGeAUHJCmOQIrOQfh7zLvMmrZGbNz3KFzXP63BOL2TJQiiOmpfT1LJMZkC1PdALnXGkh/mayUM5Z6vg99sQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tw7E2FfkX5J8YEhES8eQgZe6b+hT8Ylfb2aft6BzEbw=;
 b=GrzE6APxr8zIK1JaJD5tJG1jDmZ6EB7eWes+jVYqsyJFOK7Ssg1AcS56oct/F1fgl7VD/aQfpYM5+yqX9w10V4SCKwxZpm7iaUqmo8NWIlXc/c6a3qhAvZE8NI/zyIA9nCzkxnw168EM/5A40lS/Q2czuENmOerrqurki4f5f5B0yVvp71vil99uiQgmV5GldypihgZetXAmNNtop1a9NMchN52x5692MuZ/AnDDfpvc9JNyY9AAQKbIL/Z35FEiGRUMzTWEdzR1m/tV7od4YbtwN27pZYQyIP8DImjJ0bg24YBNxLEoJRdq4y2yqQYLOCz0nCJMaHyhezG35fSjRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tw7E2FfkX5J8YEhES8eQgZe6b+hT8Ylfb2aft6BzEbw=;
 b=QTn/IntgPDb4XqvSncg7IzQxN00XeUEXqNH+GijO0XyEnxEf44szw0vqCxvXNUCBwVOMEOJ45vOrk95W4FOPv6n7V0jnTbBcSIhcT8uFKBQbj+/7jww/hpKMzM1DwXNpQL5wYsaJbZ5yLSEpQMYk9g0QqtNh/lT1A1/HPbHYBxo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DBBPR04MB7900.eurprd04.prod.outlook.com (2603:10a6:10:1e8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Wed, 28 Jul
 2021 11:52:19 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4352.032; Wed, 28 Jul 2021
 11:52:19 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de
Cc:     kernel@pengutronix.de, festevam@gmail.com, linux-imx@nxp.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net-next 7/7] arm64: dts: imx8qxp: add "fsl,imx8qm-fec" compatible string for FEC
Date:   Wed, 28 Jul 2021 19:52:03 +0800
Message-Id: <20210728115203.16263-8-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
References: <20210728115203.16263-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0100.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::26) To DB8PR04MB6795.eurprd04.prod.outlook.com
 (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SG2PR01CA0100.apcprd01.prod.exchangelabs.com (2603:1096:3:15::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Wed, 28 Jul 2021 11:52:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e077de9a-9113-47fa-3633-08d951be2756
X-MS-TrafficTypeDiagnostic: DBBPR04MB7900:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DBBPR04MB7900045F4CCFFFC8AF175F74E6EA9@DBBPR04MB7900.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LUglQnW82YuxH5qgSsVQycHurA+4KOvtPajYMh3pfyZw39TaINwAMySmUk9s/k3XJ63xL9itxFtC6USDvzQOPcJSrwgdgsbGpXAAYd9QAkVgzTxs4Bf2qQT9aEVpwrAZms1taUqrdT4RY5viEMcUVEvA5HAzNwzKXxCgwJviSwPxLfPrZm6eeGfhRHfVMVEuMQ7fU/f5xMVI3ve2KxAF+EMXOp+szuNuDMk2/rUX6U6oHt2sRTLkT7JLe1hUxwpjaGK4dVGr0UqiCeZKBbBuHml83adu5hP/NSK3GLNAuSMGl/7Fu1umLy+nAu1vwR+HQgSTHb9EjQ0IqK6d1FjgtC/ZOPY+T/lMI2VZrJjpHnjf085C0TMUi6XtPVDHpWWQnoD+HPyi1FSADaCQp7F0HDvkihC6ug9ZFmdhdhQB+FI5lriM4caU8d6UZ0s9p1Q10glMU5DyqyCVClqv0MtdNWW90au5u5JcgTC26tgDEF5SB6qc9jlh7vTMK0NbLoRXW6cBgKEMKZMS8dxJX8sI6ris/DJdrjwE79M6t/7Jmp4CrMfoISiRSLw8Dx6yP4FMXmI/Z4iYTkyVzD1A/ZCb3De0fDioVmdpr83cl0R+s8fVRiKkJ+KEhTxG2E2pxkvJrU81Jv26dybSVBEv9l01kZPnXP6O54eALdmWvwDSmz3Y/6qcHWe6wG+DlJMvcreemluOjqAB3BWHHTe9qg/p1V7PhepjsmDE3sj0P9EXx0w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39840400004)(366004)(376002)(346002)(52116002)(1076003)(8936002)(26005)(956004)(38100700002)(2616005)(7416002)(38350700002)(478600001)(6512007)(6486002)(316002)(2906002)(66556008)(86362001)(186003)(66946007)(6666004)(66476007)(6506007)(4326008)(5660300002)(36756003)(83380400001)(4744005)(8676002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Z5++8VOuKub+uOzgPvvHxatz9DMKilsaltu7KCC0tuPWb41LDrGfjaNDsiNX?=
 =?us-ascii?Q?r9pWK30VRIope4DnmQopImqhnaW1tTy+KpHWsaGbWD0Zzg5GnOReoEkOvmfR?=
 =?us-ascii?Q?OfkHDgmseL0Lio4do87vs5k73MDVAhKsgZNO2HgsBD90k//cqiFWWx9oRgeL?=
 =?us-ascii?Q?Ah5XgZjJ0l4c9dS8tgpHsLBPOw15eJrvhqYt7f5FCd+cTcNpZVuBhTSvodWb?=
 =?us-ascii?Q?5qNBIR7qG8MmqAELSSnfN9eUPoqplscv77mnAwaBv+woy/KsbJ2/XRSOziHI?=
 =?us-ascii?Q?soxQ55Nusv71HLfMfSUoCvPwCTh0kJX4WXY9QWj0bgn3sa0w6swDqsChS4m9?=
 =?us-ascii?Q?EddS9ErMFKbT759lA9NQA9qqg1fpDgqZPxANQaHDI8b49Q1lfksdQ2uQqdtO?=
 =?us-ascii?Q?Yur/385iXkyZVf67DHJeiJxXI0AKWqG7sNgXvwBdFnBQgXazYfKI22LFMmAA?=
 =?us-ascii?Q?QU6v0jEW+Glg24Odxetg8zk8pKGEhq4hpzlFqWGmmajrdTZmj08Z8gbvKOoP?=
 =?us-ascii?Q?13sT8DL6CrNvE1ExtyHF1EAwZXtMTVDCoj0qD+OBsPNmxwtKvW9ZWpdH4U96?=
 =?us-ascii?Q?7Fx8uJlGxEY5hvqGnit72oP3se9AaJKWTtEi/+UrRRNYFlb7Xl/L5fduXtUP?=
 =?us-ascii?Q?H0eIR1zQ+efEBN13F04UTnTfT/ZFkFzfZyymIJ/xQe0P5kwuCBiyJ44BGArq?=
 =?us-ascii?Q?Gubpiz5OGw0O52K0S2dqTAuOcA5IKQvvpqtVcVcBVplH/vp5Ql9N3uNv/ssf?=
 =?us-ascii?Q?pNzLYL/fQXVrITdLjwHWN7IDyvD7TcjdGVD4pDstlF9T4jajt0Qt27AyCysE?=
 =?us-ascii?Q?BS0a7rpViLdpi4ksA5Y8KvxHiMRUax1wgTAPn0/lb6qaDoD34eeyLQpkRMD9?=
 =?us-ascii?Q?4/TfgT2ZqrfpAtMbzPgvbzaLsgRuOMbhQdMZQoy8ljFYVz8B28Susxl8BkVY?=
 =?us-ascii?Q?RjVdq0AttDbnWAqB6fJC6z/R53Ln75EnSvRcHnK2Fm0jikCXtiKrM3NWwRJU?=
 =?us-ascii?Q?RLqrHFrAclxyCIPunbJrSpLcfZru0zPVRVuqQxyXQS8wXlZwsxmgKZR6wB/R?=
 =?us-ascii?Q?alJJZ3VPkVk2e0SXczW+XFpuAxC9/Z9PCZN4SQVIOQ/1axouGJhwoiajTtHc?=
 =?us-ascii?Q?NsBfOlk6NPS9fsytV6DPtBOeAHyiAd6fB2ey2wLpOJA/XwpfLIvVV+NPxoi5?=
 =?us-ascii?Q?n6PiiFV6pKhB3q/uXiGiqBzp1eDeIJr5zwE4Eb1Tefm/7V3WFs4nEz/yo+n/?=
 =?us-ascii?Q?KLsspUwHAVcE5C8gDIme3ogaQkcuEdzFOU9rZSYQIoZVw0JZIXAnaQfyvcqK?=
 =?us-ascii?Q?yKiIJVlsZABPnFAO7OSDDQus?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e077de9a-9113-47fa-3633-08d951be2756
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2021 11:52:19.8628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hdq92hGIfx0xduQhDEcbmCN70dxMBYbL4RnPu6Ixi3kwz/PMrYPbBqqG9QUfRTh06RCAXk5dHCwK7SY0BGvssg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7900
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add "fsl,imx8qm-fec" compatible string for FEC to support new feature
(RGMII delayed clock).

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 arch/arm64/boot/dts/freescale/imx8qxp-ss-conn.dtsi | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/freescale/imx8qxp-ss-conn.dtsi b/arch/arm64/boot/dts/freescale/imx8qxp-ss-conn.dtsi
index f5f58959f65c..46da21af3702 100644
--- a/arch/arm64/boot/dts/freescale/imx8qxp-ss-conn.dtsi
+++ b/arch/arm64/boot/dts/freescale/imx8qxp-ss-conn.dtsi
@@ -17,9 +17,9 @@
 };
 
 &fec1 {
-	compatible = "fsl,imx8qxp-fec", "fsl,imx6sx-fec";
+	compatible = "fsl,imx8qxp-fec", "fsl,imx8qm-fec", "fsl,imx6sx-fec";
 };
 
 &fec2 {
-	compatible = "fsl,imx8qxp-fec", "fsl,imx6sx-fec";
+	compatible = "fsl,imx8qxp-fec", "fsl,imx8qm-fec", "fsl,imx6sx-fec";
 };
-- 
2.17.1

