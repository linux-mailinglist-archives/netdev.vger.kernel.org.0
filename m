Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9EC51E12B8
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 18:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731501AbgEYQcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 12:32:12 -0400
Received: from mail-am6eur05on2054.outbound.protection.outlook.com ([40.107.22.54]:14305
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729338AbgEYQcL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 12:32:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ver2fit75HB18A5Ze9y0RPx/Zv9n/5OTT3dGFDXH5hPRmSg612oifBo7fVvUryoepOcM4XM3to8K9VXCs6ggj5MupAXzMQZ+8H4dWPjCe1RsMNqw3JAc3cNWdYcAASXYKjSrBYSr2glxeya6v5s1U9WP5E8SUFe5Z40kHpNL6pkzj2IM2idNp4Ny9dRChY6yUL+KOamgjFwo6mTdsKx0YaUQ/gtG6CXiNKk1TBFoH7ZKRteA99E0Z1GwFL7ZRacyJdum6PpZBNv3fgb9T0vpLxDDZ3hsW6uDtadCLrvHNpIoWpbl8g+oLGObydyRNbVpCWOBmrp/+gyR7T4IGDpLtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oc6lpQOFhjm0n/xUFkiNawNM1CeqxeR5SfymSlBzCGM=;
 b=LeEcdGnIsOaGE5dvw/4d5GD3CfPBU91QbdJDjOcwr+idNtbAYLQ18AS8jMpmY+/Ga6ynd9rX2SR0KmVAhF/ieIcOPSWONwCrjHuiirOVCvnQBYQQ3UYnjwzPmQhPz14Ud4bBuOOWPRUZsrJ4ljJlT3Fvl3TS+mU8o1g4n95b5qAV+bpqCwTTu9bnrdTXDZOzIEpTtFU0XFXM40ve+xDWP7Knpv2qb14RXoupmucQAmVQxJHcJYdxNjdj87zhseeLQa4E1Bf3lWSA3dy6RbDZCLDPqQdorUsypT18u/4QvbpC7z3jcrjwTiG2k4q8vYFmvlkZgaa5Qj0ZjGiC+6qK4Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oc6lpQOFhjm0n/xUFkiNawNM1CeqxeR5SfymSlBzCGM=;
 b=eHcxwuyWB8Qq97LONKp4GWUi9gJnY2rwbeWt7gm4PwXDukr+9lcuOc9x+yTgIyu/i0G118n6D9jTvLKHBb0NKY6vAlwsa0pjvenfQlHq6lo4jfOy0A7GPg3FbC0Eh5AoU+3w8JrPkSNvgIGAiygX0zLM1KsAxEk1HhQoBx5sMmU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3846.eurprd04.prod.outlook.com
 (2603:10a6:209:18::24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 16:32:08 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 16:32:08 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net,
        s.hauer@pengutronix.de
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v3 2/4] dt-bindings: fec: update the gpr property
Date:   Tue, 26 May 2020 00:27:11 +0800
Message-Id: <1590424033-16906-3-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
References: <1590424033-16906-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0102.apcprd01.prod.exchangelabs.com
 (2603:1096:3:15::28) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR01CA0102.apcprd01.prod.exchangelabs.com (2603:1096:3:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 16:32:05 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d18dce29-305f-4714-686a-08d800c92b2b
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3846:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB3846879CEF7C367CA5999068FFB30@AM6PR0402MB3846.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vaA6CG8pz727TvoE4R3Uwljy43OTelNVaOAF90mE7ax/ICY0iNNor+Ro8ZIx6TXm9mjIfkxBaoISJcAVp21Halab3BTi1aN0Tsox2QD2vUngqpgdwwPdr0GN95J+2T6xm1zw1KokXcNazjbIdObzr1ird/23qFwwUWNvJaMYaraTHCBOsMIBr7aBhFjh8EJMlzSNRbZ5s5KFFw4ZrJpOIH1qMNcKmQhhTxcMb2NdRaroNhZs56trnHXNUvbkQ/mdIV54AI8gcAAAUfwatx4L2Mjak+9/LKjaPg7mWO7X2UQH3dAt2EOu9lXYyJdPVJdLoYxXiT/ckQEwaXc+JlsLqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(396003)(39860400002)(366004)(136003)(376002)(6512007)(9686003)(4326008)(36756003)(16526019)(86362001)(6666004)(316002)(6506007)(2906002)(52116002)(5660300002)(26005)(186003)(66556008)(8936002)(66946007)(66476007)(956004)(2616005)(478600001)(6486002)(15650500001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: nJc+VfzWDFzJ+n9Zjdwq2HZ56bI7MCuZeNlsSpRU3riYVIWLCAWT6MLw0IaIFZ448JpwLDkNQRpurVarm0kcW1khLjQaK5UH+cbZjMQ7HPwuWdXP8e4rBmBsa9cIuk48rzWvKy/hkBXu+l0prUospmEgVVa5BaCL4kPhCNCZVCjwgUzmegsXJwMquncaZkLGdw6ipXQSrGlIPjkS7AlQJqzayYlj9KahNFkIigrjOyMHBDNLWx074lnGs90qqpWnjb8qZ4q9W5chH2R8qOwFjDNxtsPYUyNjkrOGmlof0PRN/pZ8mSFsLSObt4mt8pB9nEpSmCe7fu4t7hfKORpdAzxAhKvSPs0pVZ673c1WbPY/x3UeP9gTwHtD0YXagsIYIPLjIFLzR1QXBVp7uJu5TQKQw87N79Xabte3XizkU4tGrplejsqTTD41LQ4pjAOA1vELnR5eYSyigFF4oa6Y6ByC7IOkjaPU0HoGtvba0LBYWBT8MYZROpTeq2ssJ7eK
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d18dce29-305f-4714-686a-08d800c92b2b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 16:32:08.7535
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tfALw5hJ19tCdkdxHIy4FJ/fwmGO/UqugFsMRP2D8k2gSyiiVt35r6CY1PIBvXrrx5c/p3VgJUzZCVwtXUCUjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3846
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fugang Duan <fugang.duan@nxp.com>

- rename the 'gpr' property string to 'fsl,stop-mode'.
- Update the property to define gpr register offset and
bit in DT, since different instance have different gpr bit.

v2:
 * rename 'gpr' property string to 'fsl,stop-mode'.

Signed-off-by: Fugang Duan <fugang.duan@nxp.com>
---
 Documentation/devicetree/bindings/net/fsl-fec.txt | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl-fec.txt b/Documentation/devicetree/bindings/net/fsl-fec.txt
index 26c492a..9b54378 100644
--- a/Documentation/devicetree/bindings/net/fsl-fec.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fec.txt
@@ -22,8 +22,11 @@ Optional properties:
 - fsl,err006687-workaround-present: If present indicates that the system has
   the hardware workaround for ERR006687 applied and does not need a software
   workaround.
-- gpr: phandle of SoC general purpose register mode. Required for wake on LAN
-  on some SoCs
+- fsl,stop-mode: register bits of stop mode control, the format is
+		 <&gpr req_gpr req_bit>.
+		 gpr is the phandle to general purpose register node.
+		 req_gpr is the gpr register offset for ENET stop request.
+		 req_bit is the gpr bit offset for ENET stop request.
  -interrupt-names:  names of the interrupts listed in interrupts property in
   the same order. The defaults if not specified are
   __Number of interrupts__   __Default__
-- 
2.7.4

