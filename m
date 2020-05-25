Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7659F1E0798
	for <lists+netdev@lfdr.de>; Mon, 25 May 2020 09:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389038AbgEYHOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 03:14:37 -0400
Received: from mail-eopbgr70053.outbound.protection.outlook.com ([40.107.7.53]:1606
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389030AbgEYHOg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 May 2020 03:14:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Brvkcl3ADxMyWmtrHbxJzWrltDLwrKRNR5DaEhfept4k8usUcNdJZR5mF1S6fHKVGKIHwKk2/9M3keLqWWxqQTmDTaMplzb1wVxNLpTDBK2r5afEI3HyH4oWUt1vYcV07Rc1fVMI1uIQsokQiiqTLFwS/OqkjXsmU2FnKf1jTXOKa0Vlj3AEmDvQ7vkxUNZL7xNMy+htn4xzJNMEWJy+Dndi7p1WwiWZ4yIZSxxSjoCwifY1COjNKh5rxNwSrUn+pj9ccb1EDFqfjN1S8s1ZE84K6DUuBg79BQTxvi/slsBAuqKUPBocy+ft1YV2rdrAYSPigo047kE20MgQZdzKrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oc6lpQOFhjm0n/xUFkiNawNM1CeqxeR5SfymSlBzCGM=;
 b=S2IULBliwhcTDk9ej9bZLt4seezZhEHNg5dAruNagcNpTvc9U+WuerFilv1d5otJd+pnUtqXhsQ4OFNVl25TniQyItSjJRahhwLb1JVfLjQSSnce58yrkKq9qeB3FrYY8MB85xMocrxZdHoGX31XR2RwVjWjktrDRwR9jM7Usm4+B7PbZW56Vr0eDdVxILZPy2jgV1s63et9xWMR732hgwYLeYY2YSavX3ZXfRCJhQ0qtwVpZkaq61flV4zIozqFEb//lHmHFWH+yx+ZxIeTxbIvhye5n6SBpGKPWF7QQXvqH8f4gY2AC4UhDlIfAZvmuiStoU6g+tKwKpSZm/ICGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Oc6lpQOFhjm0n/xUFkiNawNM1CeqxeR5SfymSlBzCGM=;
 b=D7bbdHVmAlPksXsIoINp3z8MZH5dZ+SnVnPBi4aQ9tkslqa7RzNt1WGuEAvyQJ3omrapHJZgD9JQN74UXub8afXFYO3UudTFJ/0e6YzhGfy2jaP9CFZnCpZagt7DGcVa4ATy9k/GNE6ECrbXXLhCwlbBPdzaAWU3CeersEx6Pqg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18) by AM6PR0402MB3735.eurprd04.prod.outlook.com
 (2603:10a6:209:1a::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Mon, 25 May
 2020 07:14:21 +0000
Received: from AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1]) by AM6PR0402MB3607.eurprd04.prod.outlook.com
 ([fe80::35f8:f020:9b47:9aa1%7]) with mapi id 15.20.3021.029; Mon, 25 May 2020
 07:14:21 +0000
From:   fugang.duan@nxp.com
To:     andrew@lunn.ch, martin.fuzzey@flowbird.group, davem@davemloft.net
Cc:     netdev@vger.kernel.org, robh+dt@kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org, kuba@kernel.org, fugang.duan@nxp.com
Subject: [PATCH net v2 2/4] dt-bindings: fec: update the gpr property
Date:   Mon, 25 May 2020 15:09:27 +0800
Message-Id: <1590390569-4394-3-git-send-email-fugang.duan@nxp.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
References: <1590390569-4394-1-git-send-email-fugang.duan@nxp.com>
Content-Type: text/plain
X-ClientProxiedBy: SG2PR06CA0213.apcprd06.prod.outlook.com
 (2603:1096:4:68::21) To AM6PR0402MB3607.eurprd04.prod.outlook.com
 (2603:10a6:209:12::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from b38611.ap.freescale.net (119.31.174.66) by SG2PR06CA0213.apcprd06.prod.outlook.com (2603:1096:4:68::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3021.23 via Frontend Transport; Mon, 25 May 2020 07:14:19 +0000
X-Mailer: git-send-email 2.7.4
X-Originating-IP: [119.31.174.66]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fc094bd8-213a-4b0a-b2d5-08d8007b3f5b
X-MS-TrafficTypeDiagnostic: AM6PR0402MB3735:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR0402MB37357E9A8D2A7474F269EC0CFFB30@AM6PR0402MB3735.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0414DF926F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kLlEAp18AxDY748taIFyYFwuWxFXEpqV8/Eqg6W6O7xg54wvOfYtx8N+l/axBUXGmSDbeGAFIcVebc/XUYepynnaX97cC60Sy5kwTqzf0bQRvNWa9ulGvbGT8RAEz/AfNqyY4hjmRBSiUcnV86gSOxDQGgIYmOZlvs5Vixh5NrzyzWiqEihvlCBv1HUXPHMA2ArB45CgUzxh5Wn1UX9gOqAwpA24ox0ZKqABHcbwGAKMwPuoZKLJvS+VwsLwG8m2UAw5jZFH1V5SjAmdMywKh5QBf2m7mAO9JzgDIU6+ZXp5I+oYNY5go0uDHF2jK4EItoOnxiO2OGkQkvVtx5spRQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0402MB3607.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(39860400002)(136003)(346002)(376002)(366004)(316002)(956004)(2616005)(66476007)(52116002)(6506007)(66556008)(66946007)(86362001)(36756003)(26005)(5660300002)(6486002)(16526019)(186003)(6512007)(2906002)(8676002)(9686003)(15650500001)(478600001)(8936002)(4326008)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: c9rF6+Yu5MlFePPHA0bduWwtFL8ycbX/7B40pZkmEFteOOcxjz4hg37f2x7ToH4HVp/8tTm+wfHPPx8DY8kbEKcAthN+vYOd6ITSoFjoLQAcWr+Cn0t+l5jitDyh7BCkg0VfazhzNNLOmIbj/eJnaYDrd3p/gw2DmFNlJEQ/IlSkY3ndk8eToKVXm7CqksIeeD/dqb9lNC5jpDFSVzVB4BCu4a3OBlqLU5IaS/DI50fNAZLb0kK2+0jAx9o9wftd6XOILUUD4n0JN3dQwVBoxKN0wjjSHepmn2R28RLiLYgC04BBHBzQPCXISx3vorPhsc83/B7V9dYOUaEylAzgsKEmj0Khi6icpvRlcpt8HCTFTAx8A9ctHK81gxKhv4lAWG337+zZ1NJzj26JrnjbetzlH9vL2zF+gs5L6dDoeoXnC6nMsM/cdW/fqcQCmgI/wBFzyWUINyO7/BpN4m9yF2QOOmVpDqEMEv15uazUb8Owjj3BBB5g7bjeO6VQVWyj
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc094bd8-213a-4b0a-b2d5-08d8007b3f5b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 May 2020 07:14:21.8805
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s2FX46c4S7mMERKO73ThJ1mJqX3VKiL0Z0S3GWFGsVGFyPDVPE+f6BdlqiM+SKs7or7j3/uwNtRYCeqmf+pJwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR0402MB3735
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

