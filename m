Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE01C3C9A94
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 10:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbhGOI3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 04:29:36 -0400
Received: from mail-eopbgr10047.outbound.protection.outlook.com ([40.107.1.47]:42016
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239431AbhGOI3f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Jul 2021 04:29:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EesNOz7q9ulk73m3AdtyFbLQ5UMk+VVwyBQ25Cm+OtNv4pzKjjs+ICv8IAq5cvHJaZaztd4ndboB7oD4JdlxaM7ACiMO7/Ivd5TPh/rGazvUs3HLAin++ZhdMp/nDus4cTIBvA62Mg9hE8l7DF+sn2xXTQHq+7RSeNjNyvT6rJfk7VB3ykbDc+xUen3wmmTVG/ekir9ru3S+i7g+xIliJLs1N0dX8Cwy0OYHkH2H82408TjNDgKMVUF22hQ64pEcwB5g0cxwC1UAD0CQrG74y5dWq64uzItW64LmedHgsvtOmoL37YrIQ1xx/R2LuQ1Pd5bPzOjSarE6CThawxUpFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EutayK4X8dve8o5EJDlLQSzlZefSo0iMdrGMoK1aHI=;
 b=MFKi3aQIuRcUmgjNPvWuqxEKjddMe1ZWnqEJcEfCc+jPmntZh+WQ3z4RLuJsNWQUombhzkjlvvgto+LXbj8/BAAaaMMXEAmxJhJplXSY9qrm1CnatGIwmjh2Va+G+I9fFgczv6P48nTe0fYvRj12vUWOJozuDFTukLGrz3IqY00AtE/23n9eqT5//h+1CIU0K+p8ZPSYq8kwVOdm/IMXUZryjx1pU9FW1xZf6t2OYtp7FInpAl2F9ppqNF7VW0PrRUvxY2FfIaTtTtFBPDbkJgEwALoXy2Vt0uvq/V4r4ysJf2zJis0GDT5BW/KEZIHQpN/mVn578dDI5y5ZEm2zwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9EutayK4X8dve8o5EJDlLQSzlZefSo0iMdrGMoK1aHI=;
 b=BuLc+MLn/aSl+FwSLhuyCJYrpefjaf5FJz1PFYoU574uk5UQ3umGP+6L+XxGi+40j5hWg2b3pVzR2coS8zWq4/1EIrrrSYb96DNAnU6spSs0cPWu4WuIGl7BXMCrcRWBjZMO/B/gD7YRaBb3dJGdHJYY1BZIOjlBlHcJ/QgfhyA=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com (2603:10a6:10:2c3::11)
 by DU2PR04MB8680.eurprd04.prod.outlook.com (2603:10a6:10:2df::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.23; Thu, 15 Jul
 2021 08:26:40 +0000
Received: from DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::9daa:ab21:f749:36d2]) by DB9PR04MB8477.eurprd04.prod.outlook.com
 ([fe80::9daa:ab21:f749:36d2%9]) with mapi id 15.20.4308.027; Thu, 15 Jul 2021
 08:26:40 +0000
From:   Dong Aisheng <aisheng.dong@nxp.com>
To:     devicetree@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-imx@nxp.com,
        kernel@pengutronix.de, aisheng.dong@nxp.com, dongas86@gmail.com,
        robh+dt@kernel.org, shawnguo@kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [PATCH 3/7] dt-bindings: net: dsa: sja1105: fix wrong indentation
Date:   Thu, 15 Jul 2021 16:25:32 +0800
Message-Id: <20210715082536.1882077-4-aisheng.dong@nxp.com>
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
Received: from localhost.localdomain (119.31.174.66) by SG2PR02CA0083.apcprd02.prod.outlook.com (2603:1096:4:90::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.22 via Frontend Transport; Thu, 15 Jul 2021 08:26:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 702cae62-c93e-4266-3bb2-08d9476a4512
X-MS-TrafficTypeDiagnostic: DU2PR04MB8680:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DU2PR04MB8680AD0A4EC62FFB5A6B8B5780129@DU2PR04MB8680.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1091;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AjXKpgC6Lo5wjTd0xs2E4kqo2lg9WKSzTPo4wXd4EA8sfAV8Zwp9BKFJJXAGKq03uYD9vPxEmdOV5q9EVjKqV9/Rhu2xjToMPKj1NaAU7LJ5WkNsziHyMBFwxLRb2irUP1cdFKEQQmD2GACEwP4hDfo0IlAEDl441yMG/uQd3RReUBJXHfpPzes5QDsK5OZZDe/uq4sEGHNF9MwRj5rDG96M2p8+lnN0kTvGDLiFJa1kUW5Zmjwen+/DlHrjYTMZJFsyx18JGXxLVa0Hdky3ftXjI6FKV1m9h7WK15xYws4rORpmBU0liDw59+NPAvWJu3Sr8aJOk7aqc820ZT+H/F4807y9gDx+mkaZgUra7QeQtmBRbHii2ZYk7H7bqVGbPwvMkFh5nx1MhEze5OoYPZ2C6JB2FqaDULM97uZ7jfAfRvzu4ouk5JjG8RWpNbfAOfut69b3FUczM2rz5MJe9AF2i+HyWSdm6bgTHjhyvHySTfOBT1g74kbqzL4ekw8M+T+1zo3soi5NBpOW1wdrC4WwRdiANWMBL5lrMiexpo73EHYoJ2CT1+20tv9R8VH5jJlLvLPa9xXpJUtyByAC/o4YXjpqn/7TUXzaAAk5dqqHjIokPYxGfQdE1r/SvDo/wDHPHvKzPfCcQFboKv90qhmfD0yDEHTI+ZTCXOjDQgJwCMDAEVDzMtClxMcPUBn+383+Y65UlDT/b/17RbkWDA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8477.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(39860400002)(376002)(366004)(396003)(6506007)(2906002)(7416002)(52116002)(186003)(5660300002)(6916009)(4326008)(6512007)(8936002)(1076003)(36756003)(8676002)(38350700002)(478600001)(2616005)(6666004)(6486002)(956004)(26005)(38100700002)(54906003)(316002)(66476007)(86362001)(83380400001)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RRAiaeIYvFKdrB5ec8BR/yARDik64jdomN4Rc3u+IbOtmchNZwT6DEsI/zV6?=
 =?us-ascii?Q?ccurKiX6Dk8P41aQ9bJphZa9YnZTb0QYixj1dWUKaxhHF7W96L/MXcHhWb7o?=
 =?us-ascii?Q?Lgr3vIGMLw/qQrGgwMN+gSBUQEUb+02pAplaIwj2WWe387VRiL/DAvazle0+?=
 =?us-ascii?Q?g8+3/vJgpR6HIhfkm2TKiYznV1kIY+LBhKCDENFs5bYS9lMUyCw/aZV6p/z8?=
 =?us-ascii?Q?oZhcEkg3eVGEdXTq421UscryqK/dIJiXkEo7mNIg3ywPN9m7J/OmuRBcxWts?=
 =?us-ascii?Q?9NgdA3ao4/r8w8LhfQsAasieLmipPTgn0NJudOxCkUSzDXcyreO1Azv4XZHU?=
 =?us-ascii?Q?53ioJpD6Gg6FhxBZQW4OYdPraLLnwpQGKwCML/depMKjP0BB1hDrd8JOMYYL?=
 =?us-ascii?Q?L/kuQvI+zlKPoNyvs0TJ9ty51MTUAqnWv2izvUY6EnOC2UQBQ24ta5Ehr8Nc?=
 =?us-ascii?Q?Jq6oRfPggqDCXYQ/9jjGqsNKoNDflH3P0eNffwyfmai0yiNTRYbi22edoqEH?=
 =?us-ascii?Q?vSKwyvwxz9nlgF8l/+l4ebbxU1RBgValWmCiov6uhUM2yVjrhMu0xgWKG6ff?=
 =?us-ascii?Q?VsnintmzT7Jc5JZf2AYYqRx2X8NI7+a8Ck21mvmGQPSMX2rDt8ap0FPK7F4l?=
 =?us-ascii?Q?hXbVEXvwjh0dHg6/4Ips83eZ68DtUf+zrWsZlQ3mfrCzUoxTg4JI2Zr96Gcr?=
 =?us-ascii?Q?FjZ5paTK6ZfHpm8KEuMxwX20H3c1Ric8BuM72D+D/NjvYSn685Ky4sI1juki?=
 =?us-ascii?Q?cAGfU4jY1FbzIqYLuaimr5lCa+Lp2XOTtFmWjY3zNoRcWuGLXi/fdEvQ6sfA?=
 =?us-ascii?Q?BGIFGkTnguJ7Ui/pwPCpy4gIUHC2Phy0QOWbmkGCpIMIebylFUVev2/kt+lQ?=
 =?us-ascii?Q?6LQ0eUR5dcIYtd9JfxVP4SSnvW37H1lt5JPp0s1BDOSssjeZTD/oBKSJGC+g?=
 =?us-ascii?Q?T1xgh9WP8BEXb7P8bxYCKlex4ZK3KgqwJm/Z2puAbb4jLj4oTzSPwRa/p7qy?=
 =?us-ascii?Q?Q7XQgsjwdSVbIL5ywOTlncnlKueDrgkzLUPz8euxDIZ7JSxr8vSNV/2dQL2n?=
 =?us-ascii?Q?ng5RQ5IBozz0ybr+Q/ZWTfGdEnFdk+DvgilKdJvN+yf9It8gK9mo+Fo7BMee?=
 =?us-ascii?Q?czxIQeEtmdpeudM6v35zwNjS3nU2ojwKPRmbBwVU0B0T3GkLPIK9so30vgID?=
 =?us-ascii?Q?OPSylGEiohUfgfHzSE8+qxnhYTqLjXbOIgAwEN2Ia+7Mld4ewzuftx/bAjIT?=
 =?us-ascii?Q?CkbQ6dV3sL34NKLlwJN1QS94wi9wLINQ9BgpF29emRwiAEWRdnWneLGFKl8D?=
 =?us-ascii?Q?AaCl63dqDylBy2xnlrs/vNO+?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 702cae62-c93e-4266-3bb2-08d9476a4512
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8477.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2021 08:26:40.3521
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hu5DybYFWIKDZqF1q3N4G/AQJ9kz3x0YPjZxpbCB72PW10rfmPCw0aQHwSw2Uq1CGzXoZ5wWnyf3K1EdKl7wxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB8680
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes the following error:
Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml:70:17: [warning] wrong indentation: expected 18 but found 16 (indentation)

Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: Vladimir Oltean <olteanv@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
---
 Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index 0b8a05dd52e6..f978f8719d8e 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -67,8 +67,8 @@ properties:
           reg:
             oneOf:
               - enum:
-                - 0
-                - 1
+                  - 0
+                  - 1
 
         required:
           - compatible
-- 
2.25.1

