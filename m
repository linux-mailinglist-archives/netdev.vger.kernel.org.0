Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF8133CB61E
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 12:30:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239287AbhGPKcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 06:32:19 -0400
Received: from mail-eopbgr60057.outbound.protection.outlook.com ([40.107.6.57]:36628
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239113AbhGPKcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 06:32:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTEjMNqpmbaoMbO12tlGcKnJCfb2lVuE3lyRxH2NUFLSvFU6qKKXsIrDzCkr3lDnUXkPkY4kOLP7LyZvBEvqPO/qy/mobcjSpJ/OKA8oUcLHpLQNihBYS05DBhMI3kYgCi9CeUu5cwaQWrY85XwTOuoQaf+40jDDiiFx9fJwF/JGCa2xvb6M9cre2cktV5/1CUlsduj0NfnqCX9upMbCtkLbpcUVvo6qIo77+119pFyp/NlBr9/+vLb2tZkHKpHXeDvokPrCmo9b35VmJB2Fzt3iM/3UeX4xoBo+QMw9qI3lX8O0+5S2Qq35MfPkvhOQ7P/ZTwGvShp3TufvTNVleg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DVdX2Is8wVT7CL0bxK+EKx4uFNLSksf0FFgl8R4Nzg=;
 b=UsWmGkwaLSCEA8KB2FucXTw3YQF1yffFxw0fNBFwJ5IkmzLRlFf17NTVJgx41aLnmn27kbgkqbYP3h1xZj/leYsMFjxb30RP/GjyCycprGQcrIQXFVwWvlb7S/GgXCxJw+/hMfr873yUmPN9hXi6kwbvu3ZdZBKzPn8hsAQU2u8duhZ3eqYHbCdnSfav93sf6abgg8oRgshOdH3rum0jT7LEOtzP9g270dbVIK13BKU4kWvzAMUkWK5eTk3OZBMIqujVmgMsNHaVWeRbZjpUkDKGRd6ZcxKjkb/RsmomCgqGRkFaj/bsdkPEtsoGQAfbgFsKGD/pioA5fcJchnQfKQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+DVdX2Is8wVT7CL0bxK+EKx4uFNLSksf0FFgl8R4Nzg=;
 b=C3bfvKw84xHG197cr/mCO/9nnw2kflvefETzStQiSkIptE9bxXz/azLEyHEm3UJV971w8mFH15JaZ5mEwm7cwkZMqTZICFSpTDWX7MFaa4nB7sH5nPZIzgp6yeMjqAHa34LmXztvgFMpuHSEMxwvF2PqQrZ0V4Ts71LVKO638s0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB6PR0402MB2725.eurprd04.prod.outlook.com (2603:10a6:4:95::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Fri, 16 Jul
 2021 10:29:07 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::9c70:fd2f:f676:4802%9]) with mapi id 15.20.4331.021; Fri, 16 Jul 2021
 10:29:07 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de, kernel@pengutronix.de,
        festevam@gmail.com, bruno.thomsen@gmail.com
Cc:     linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH V1 3/3] ARM: dts: imx7-mba7: remove un-used "phy-reset-delay" property
Date:   Fri, 16 Jul 2021 18:29:11 +0800
Message-Id: <20210716102911.23694-4-qiangqing.zhang@nxp.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
References: <20210716102911.23694-1-qiangqing.zhang@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20)
 To DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (119.31.174.71) by SGBP274CA0008.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Fri, 16 Jul 2021 10:29:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6c017561-9d42-451e-c53d-08d948448a7b
X-MS-TrafficTypeDiagnostic: DB6PR0402MB2725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0402MB272548AA78BF39889F5D72D5E6119@DB6PR0402MB2725.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:569;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 72x9JL7NU6RfSZyLXK3M82GFUwjRmIEeXC05q0KAxnK9O1LRUrGG8BPSDST7LtiPvQyoS2CE5FPKfggYeHTZtYMJrKmqp+RAVF+BQH21odYwnRd9qEAWtyUiwwpA7NZ/zZEb+2NMGtKVl41GTs7kFlz6MhXN9S2xZrVoNwZWcO+tlqrD+djBdQ3LYjVfAFGXVilhfSlMCemlb6sHxo9iz22G+6w0RVhBqEeVOVhwDbehceQTQvXypp7+Pd7CLFdA66aM0nGb095V9oc5jAAc2hHTB3dzGiE4BGy/97E0Bph8cI+XyLBk/ns2cIQru2W2RGNy5lESPAxIGt4+Yi7de45kySLTGof+tF8gVi2FdMpNM00MUrAhoRSiWB39Scny0BuU1fSM0sS0sxBtAydxnFj4vY9mTyq+ddUaI10SMPisF858jmmFrOCLJ8WldUC/ENLf5HKYfEsXJuDLtITjEMWTiQFl2ScKJDYxS2VnIEv5bdNGOQeU3gC9qoUREk3CBbdjMxjkrwqxN58m/o85kRtBfCX925d/YlUOuSa6QTyZfQakijdk728utsaVm9onVL/uWnhaRQzi2ykoHGxyupEH36Prkbfqf+vktWLUKXlJRBx2Ar8qq/xOXPUoe16hSvava4t1Rb9BXxIW8FT7GzaaLP/6bfV8Ktib4hC/G2Rd9Yuf88EN3iKLqhW26cfjblBn4KqEpQQE+h5rs7fdsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(316002)(83380400001)(478600001)(5660300002)(86362001)(66476007)(1076003)(66556008)(52116002)(36756003)(66946007)(2906002)(4326008)(26005)(6506007)(956004)(2616005)(6486002)(8936002)(6666004)(7416002)(186003)(8676002)(38350700002)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q+Z0sGj4czjuZwpRkUbzDn2s5JEe+CwRYMefCa/Omm3qI4T0DmvdXRmE8HxY?=
 =?us-ascii?Q?mPCVlmY44myGkXccE3TI+A8aJk/IurM4IDgoQjUj/IcvNmTEVtx5tAvdF/ka?=
 =?us-ascii?Q?xHPLDs8V8FOKoKa//0Bepc9dAEGUero8ibxfJQLRjnJ3dIW2vtQkUWCPlqGK?=
 =?us-ascii?Q?q27GRgZM61u4lVKg+EMLJunPIpzEBmIFprKArH8owDBZxJRYBVNyhO+MkOpg?=
 =?us-ascii?Q?BnT0K65sl0WLf0FQ8GWl9arVqcpRNCHGuA1tA+DJ1b7Cwz+z98tbb2HllD+V?=
 =?us-ascii?Q?RDJ5oKVDFP3Yk06ghFc/Cj/yfCd1k3mNvwHpMTmZpcDMyztpfgzIpBitGpDE?=
 =?us-ascii?Q?rJrpcMCYBC3kVXkzVwAQoV1w4Y3e5Q98tUAGWrEcercqnU1pRk/pjFTjwQLY?=
 =?us-ascii?Q?7Ew7gRXiP+NMA0DgedSBss/rVg/9fQL8z8as0/WBow6Zqh2xQKLJ6fBp8iao?=
 =?us-ascii?Q?hlM+RvgQHVajIRI/84zSgSY5GfqjcpoQESBTwH6Siwts1rUD/N0BAZS5F8Kn?=
 =?us-ascii?Q?KZPbhwTRLQwcXHn7fuODYdbOk/E+qLV+0paN8ngcqMLutPn46uVUlX8nmQ9A?=
 =?us-ascii?Q?fx66D97zjvcXE+JVqmx+mdCNVToyn623WBr3XttQ7VqnnLK34BbfT89khK9n?=
 =?us-ascii?Q?DrIhMvJPmVGxQ/vVZ3t+B0ugb+LCmcUxsvhRv7SbBWH8T573X97bboEFmyJk?=
 =?us-ascii?Q?fzK6Vi3LE4AqgV/Wv7QqwqerbwjIyOX9FH/IF9iA1kNyowetFlxftAEL+Jk4?=
 =?us-ascii?Q?/AgeGF4zwdwNf3oj7I43mE2grstNYx8kIlv0DwnieSzyk7Zjcb2FX+Aoxc9Y?=
 =?us-ascii?Q?VjcEh/A15Hi0EjXwQZM7DHGIZQwj7LPIAhHVOsHXBXpuQZ4ScLRgkN0kAC6I?=
 =?us-ascii?Q?R/d/vZRIJ32Lv/fOhjfKjT75UQ84Iyfxjbsu6J1rQxtCDg2A4c4Sw6UipH1x?=
 =?us-ascii?Q?/XSQmeDlUdNZk7MaSosP9GwOWQ+g5eVJk2IsJU48GdeJhmQw1lVMv7+xSE5g?=
 =?us-ascii?Q?wlH67coQFIPGVbfsaVohn1cFOQesfV2dSk3l+EP6SR79+cZGOmxrW7gDjXqb?=
 =?us-ascii?Q?kf/LIRvosM7pR2GlMmN4eTPpmFlfPXq0F0/0cbrnq2q2TTcMsho3ajGhzkNp?=
 =?us-ascii?Q?rKtIdkwNryNV1qAgVitTYm85pZ8jsVEBzDbHSV540ganlqB4EqPRD5u3bYuL?=
 =?us-ascii?Q?J1e+Z0mIz5UCmAPxcAEcNijm//xEfArOPIN7wP7NiG8j5PstQayjFMei38tR?=
 =?us-ascii?Q?0HKyhDvxlvzGrHMNpDLuHVX8FX96N9hMM+wsnfnNERQvVtMfnFnzqdY79bAe?=
 =?us-ascii?Q?igB0GekygX9DTqDvmVdadUUk?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c017561-9d42-451e-c53d-08d948448a7b
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jul 2021 10:29:06.9372
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0xm4OFZA+u3VCfTDL+5qDIZYlBBj4BSB0cEY0v9tg3IVolhSLW9jWAi2fG+cnEXTz0MHKWcNp2gwaohQKwjatg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2725
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove un-used "phy-reset-delay" property which found when do dtbs_check
(set additionalProperties: false in fsl,fec.yaml).
Double check current driver and commit history, "phy-reset-delay" never comes
up, so it should be safe to remove it.

$ make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- dtbs_check DT_SCHEMA_FILES=Documentation/devicetree/bindings/net/fsl,fec.yaml
arch/arm/boot/dts/imx7d-mba7.dt.yaml: ethernet@30be0000: 'phy-reset-delay' does not match any of the regexes: 'pinctrl-[0-9]+'
arch/arm/boot/dts/imx7d-mba7.dt.yaml: ethernet@30bf0000: 'phy-reset-delay' does not match any of the regexes: 'pinctrl-[0-9]+'
/arch/arm/boot/dts/imx7s-mba7.dt.yaml: ethernet@30be0000: 'phy-reset-delay' does not match any of the regexes: 'pinctrl-[0-9]+'

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 arch/arm/boot/dts/imx7-mba7.dtsi | 1 -
 arch/arm/boot/dts/imx7d-mba7.dts | 1 -
 2 files changed, 2 deletions(-)

diff --git a/arch/arm/boot/dts/imx7-mba7.dtsi b/arch/arm/boot/dts/imx7-mba7.dtsi
index c6d1c63f7905..5e6bef230dc7 100644
--- a/arch/arm/boot/dts/imx7-mba7.dtsi
+++ b/arch/arm/boot/dts/imx7-mba7.dtsi
@@ -216,7 +216,6 @@
 	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio7 15 GPIO_ACTIVE_LOW>;
 	phy-reset-duration = <1>;
-	phy-reset-delay = <1>;
 	phy-supply = <&reg_fec1_pwdn>;
 	phy-handle = <&ethphy1_0>;
 	fsl,magic-packet;
diff --git a/arch/arm/boot/dts/imx7d-mba7.dts b/arch/arm/boot/dts/imx7d-mba7.dts
index 23856a8d4b8c..36ef6a3cdb0b 100644
--- a/arch/arm/boot/dts/imx7d-mba7.dts
+++ b/arch/arm/boot/dts/imx7d-mba7.dts
@@ -23,7 +23,6 @@
 	phy-mode = "rgmii-id";
 	phy-reset-gpios = <&gpio2 28 GPIO_ACTIVE_LOW>;
 	phy-reset-duration = <1>;
-	phy-reset-delay = <1>;
 	phy-supply = <&reg_fec2_pwdn>;
 	phy-handle = <&ethphy2_0>;
 	fsl,magic-packet;
-- 
2.17.1

