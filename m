Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE003FA08E
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231570AbhH0U2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:28:31 -0400
Received: from mail-vi1eur05on2069.outbound.protection.outlook.com ([40.107.21.69]:32769
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229591AbhH0U2a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:28:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kvf5EnDroI2OgGkKn15tsvAAtiOe9AcR0LXOEdvpLw89max/92yrOg89Jc7wnCe1ISBc0KcyfLnKG5hGVo2pE6OXiPAm9dRtKbcHdCh8lliy6GxiI9iUbYIQaSmQkDvkIsCjee8tcFCltZOyLsPpPOSfMeWH5X78Aw1kngHut7FeXZKtvLM88f9pR/O/dOymU1oCXk8fo699NqL4Yyc2Vlh4iJVGzXvs1+vIgb+HbYda9lrpdCkRRdNiVqrmOxPI2OWXVOl4a1h0PcArdHfuMEkZQ4ve3nS1OAinSbzC+GYl27cPmD2rlTLKE5cZZjB0xmF9qiWarFfXLxFzllGEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPROTzm9OUvDuh3TtQAkyxwNeQcLJQVytdffhfQdSYM=;
 b=bcRtTiZ45XC7nj9PVgNVa8fFdwNBvo7ThKL/LCd+0l8Fdm+oDHJUzp+WUKmUUmKrBqp0Q/6FGxbujxj16+bR18l2FvvmNFgfleoDwC3ykCE3uaOCSO88E5afq6EpDnHW8Y8h5PGWwk5Oc1IqhucexRsoQFQiTH/h7TPhyiSx5aJ9gRY0SIjwXSzFDq1jmABYjgZmhl7ZxdehPkXa838LIVTpc7VER059sZKus2SguHZ20L4+Uj+8zjAwXxhGDhFit+eY6hHgkhmvPu5FELAu+neV2FUF49eIWLbMcFQ3LDJwsgbC/omsHJnmM77h9sNNi5JBK5W+nzeBmSjR2+URuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aPROTzm9OUvDuh3TtQAkyxwNeQcLJQVytdffhfQdSYM=;
 b=aZeV3sTncOMqMzvcV8ayUGvG77oij9pGQA/EBPYFr89K9XWvv8zMNiAfmgx6eLAvF+yGVCqTSElwBr4hh+lbZ4ofCs5p4WyzrZJbBIArpIaa7y/GfJBqBixFgsgNZfaSR9Kk2zxZRxYpGzDdjLYw/qMN/ebWJS6aKsmCeypkiew=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB7374.eurprd04.prod.outlook.com (2603:10a6:800:1ac::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.19; Fri, 27 Aug
 2021 20:27:37 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.027; Fri, 27 Aug 2021
 20:27:37 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org
Cc:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        Li Yang <leoyang.li@nxp.com>
Subject: [PATCH devicetree 1/2] dt-bindings: arm: fsl: document the LX2160A BlueBox 3 boards
Date:   Fri, 27 Aug 2021 23:27:21 +0300
Message-Id: <20210827202722.2567687-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0051.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:803:3c::40) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (82.78.148.104) by VI1P194CA0051.EURP194.PROD.OUTLOOK.COM (2603:10a6:803:3c::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17 via Frontend Transport; Fri, 27 Aug 2021 20:27:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b455f373-4def-4f03-d4d5-08d969991c14
X-MS-TrafficTypeDiagnostic: VE1PR04MB7374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB737422355379331DEC1B8707E0C89@VE1PR04MB7374.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7hqsM4xmySPQeM2IP23SO7zqmsh9IK62tToMWwlk6fth+Q6Rwn2Gtc6znXEQ4KIC4lh4TBbhVtD4bWtDerD4pS6RyXnA96MDvuVU/vu2EhPQVJ88hZDfHftSDEbVHbTsu7P0ic0J2Sj9Xc0Zm7N/AeiMoXsYc0Vg7tZwkT0KlAkRUExelnoC8JliEU3DkCwJE0kZfuXMHjCL1k5WX3RWKzfLw/Tv8cznfIy3hq9/aHN0deq4Xzgr8RvpQE4WHIbgMixG/vxoCLbeStsoYa5O51hTxuSprg8UB/5Ewm27OIm1CiZNbQtdK+/xXFtjT5oPp1JLbEwnpXQ0hXjHjU0UA+u9hy25yiNQEjc09i/mHu57Vkcb4+xdQIMaBTTpTj5u4iRKMAZV3TbMVLKtvAJ3nGshZyCFjxTpybmmyje4/RSMullgsL1sG5z0o/QgVdHmdlZskmPDiyM9HyqKBANprRLgH7IsRJncgb9gCvZG03pdfnDuC18SHDab3mhIU0RS4vULbX8SlphrkXVbg4MFo7vRtxq+XQ5XKpj1pZ/Mi8BJJYrviyq44zxwOogSWtPwKAR25w2EmpKAHrvYgrQL2OhUczfuxIVYwwcbGbxxrvQvQZHErWLOjOStUls4s92YQLylBakHn7U8mkvsGzeqY8gVrBsMXFXCeqVkOqr0hs69/NUg8iTFj2XQkpjSJi2RLUm77fY8vIen+xBwIGy0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(396003)(376002)(136003)(346002)(366004)(2616005)(38100700002)(38350700002)(66556008)(8936002)(66946007)(956004)(6486002)(1076003)(26005)(316002)(4326008)(5660300002)(54906003)(8676002)(66476007)(44832011)(478600001)(186003)(36756003)(4744005)(86362001)(2906002)(6512007)(6666004)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5sOoQAlnWYMAetTI9CFVQBUzDw64FsacDFiIOSy8Zu1E34h8ypq4FYfv/Rq2?=
 =?us-ascii?Q?EETAcccmhOA9ZRV2sbERAcjVD17ox3Ek04QOLdaevK1E5RIZbdy0+FQlxFTq?=
 =?us-ascii?Q?r7cmNuEWpJ8YwL73lh8nMEPlg/QbG1EbiOnvmDBDtzMzBGLynilPumu4y5NR?=
 =?us-ascii?Q?QSLIm6wGSrp1BArS64CvEm1SUf3+fOT7rY+iW8IoiWlvxM+PiIzi6IfFsnJG?=
 =?us-ascii?Q?5yTuPMpEJ455Bp2W4+P1j8YroYlEFOXOp8Ptox3JWn5ozLbCokKjQjqPbtmU?=
 =?us-ascii?Q?PnL2yQMslWI2S5sZqgDZ+ZCDrXPpJxDSNLp1Mn2ISDpFky7cV1PMKj4sH4h/?=
 =?us-ascii?Q?Bi3uJnB+fzB+Xr9+EC96sgdSJbbVRKEu+lsvNCP8LaTm62KF2xLmfyscs8ZC?=
 =?us-ascii?Q?CPt/8D6Er5xoJAQNWG7HcC5/ZWfyuS61qD4pGtdLD2kTtfEpkNLezJ7Ka9Y/?=
 =?us-ascii?Q?/77Bqhj50Z0XTT20NfTre1NDY7QB68N4o6vC4uMHhT3jtOUzyvNEZmbzvqiu?=
 =?us-ascii?Q?1LgNZhgmRZ7FcMFcjDd3RXgCimwshwO33eIekbbF7UGf6ylnfaKcetGej1MT?=
 =?us-ascii?Q?4ESf9hILwj15jhA0pO1HsB8Bllo/DmCEvhleEfsDVg7aXBQ2ZFItd3zlI02b?=
 =?us-ascii?Q?ITd5A8uRfSvkYw1AAeBQKQxh7bYJP4STHnudXANwddaBBoOr9qYYxQl0I+2c?=
 =?us-ascii?Q?STT+AE41LdTJ3B56I97ndpjmhW+cZ6HC2uD9WOrrVGK6Gn2FuIKwfmFD3q1r?=
 =?us-ascii?Q?JdRZa407oBy2OIStNtZqF/VmeTlQ+B2Yk8Qj0vJlDaHumX4zJmiVMHIvtADi?=
 =?us-ascii?Q?pvhX2pm6bUu0oD5J0WJb9OFsAN141zp1xJvs0TDgPvTOP9bohLYZJ9lqWq3+?=
 =?us-ascii?Q?fPxmjkT3LAa6dbSE3wnA2nN2A4HBDdYZJWjUe/ChPR7FIfHUkzWlbS9LHJvX?=
 =?us-ascii?Q?uh4c58q3vnGPHZI/aidTdMYGw8H4I+IwMJmj8kcQ8/TqRmYq57CW7Za2GGRk?=
 =?us-ascii?Q?7/V+cJqzpD9cl/mQSHIL5ZAn9x8n0ljKwPvgzmsMVbatx1HxAlzWbapoy1kQ?=
 =?us-ascii?Q?5udw9KoIHmBEpkRRpXybiyrvblDbl6KnEUDfG0CcbH5vNU+rGpL5+nqcM7FV?=
 =?us-ascii?Q?eVmqDYmleMFxbQqnKawNt1PQQHQ+zg8IkRrdm6uyVDknhtQEyZhyiH1JWOcZ?=
 =?us-ascii?Q?HzToRjVL7x5Yf1fOlLfYKXuydLjA2P86ccxe2EU2k+FgzYT5GaD9NcJxbQZn?=
 =?us-ascii?Q?cbRrVfmoPQVbGgF/ln0d0YJD6Wt4MqM6i/D/cZVY+1Y8HIjFmdc8khoYIgtv?=
 =?us-ascii?Q?L1XFDCG1Opikv/8BPBB0Eadx?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b455f373-4def-4f03-d4d5-08d969991c14
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Aug 2021 20:27:37.3774
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LFF2yEYWXR0MxLHIHbJORTVXl8SpqRdAOBe8yVyYgUY/7vRriUhsgaMpCO7n01gjSLdoKvx04ToZ/vKxC2Jcag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7374
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the compatible string for the LX2160A system that is part of
the BlueBox 3. Also add a separate compatible string for Rev A, since
technically it uses a different device tree.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/devicetree/bindings/arm/fsl.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/arm/fsl.yaml b/Documentation/devicetree/bindings/arm/fsl.yaml
index 60f4862ba15e..d31464df987d 100644
--- a/Documentation/devicetree/bindings/arm/fsl.yaml
+++ b/Documentation/devicetree/bindings/arm/fsl.yaml
@@ -979,6 +979,8 @@ properties:
           - enum:
               - fsl,lx2160a-qds
               - fsl,lx2160a-rdb
+              - fsl,lx2160a-bluebox3
+              - fsl,lx2160a-bluebox3-rev-a
               - fsl,lx2162a-qds
           - const: fsl,lx2160a
 
-- 
2.25.1

