Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF98F3A8156
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 15:49:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbhFONvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 09:51:42 -0400
Received: from mail-vi1eur05on2098.outbound.protection.outlook.com ([40.107.21.98]:32793
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230106AbhFONvk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Jun 2021 09:51:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=no3pSOcHJAOFiczmFz5UcEqQPIy73ZS4kMxl4wdxrQUca4e1A+fofn9oerQAJYBGP6kBwrlDb22joOEcVJ/o3gVOhQ9g70Kdb/CAt9hxXcid4d7WEumjgWXht6KvwOLM8bXeWTBMyb8aSVV9s8T63RuRNo7x8CcXG9zx/runL9DkOJFfcyO0ym9OTdOuH4v5LJWgtECgDo/bK0l3QmEQRxeDOlzjQOOFUVGen4jIG0sEZfDrgLdJrMGYCS3oJGoYJL0mZ/opDLl7l5PdWM3L62WBO52CQr9ytwZyNfC3X5jdRS/ZjZbjZJbvNoWDOcYjI2RQOBHSTnZ8ZBqonbbCtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+p2Jx5NvhAKyqyA0vaimPN4RF98mq2gfCGgmMsS3pE=;
 b=Q1MhWD5r9Latn/BhYFDh2QtJ5k9v9l9VC+NDfGzdW+rm+yd6/WHnMKSaZDwKLHK3BKVn9ZVD1PUjZfNTUS2Z+G5ECieiadI+P0FBY4uJO2cVfvlm0H4e1ShITeFl816XYuMMnY5pno/5DAaoVXoAiyvgQyA+mr9CfJ/ENxp314YaMD+mxPnt2kytba1xx+nYl/miI1UxUlCY8mNRJ6UTr6f+Kpwud1blJOBB1vU+tbUuANptB9Nh8wwJpXZ3QFa9rK5lRyZ572pFCtsDa7BELHJ4aBD/tM1KYglGaXPsfeX2w5faxaTpZizGipKZaLcNlFHLaQa+GHcszTNwsZSoaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e+p2Jx5NvhAKyqyA0vaimPN4RF98mq2gfCGgmMsS3pE=;
 b=r/Ljz5redcKqaC9lkJZ5vyPPmuvxaS9C7/zPMvNoORijOYxNLwPUVmnjOOCDf4hf0IBrYnUSDnazhXI4T9pafMx5z3/UvQWmFK34Mm4qZ6cNsAMh/awZrMyhzCB2gv/BAnfX1ibuiM5jOUsD4pqcB5E8976xMKBIquK1Cq1BhvQ=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM9P190MB1393.EURP190.PROD.OUTLOOK.COM (2603:10a6:20b:3e9::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.23; Tue, 15 Jun
 2021 13:49:33 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Tue, 15 Jun 2021
 13:49:33 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org, sfr@canb.auug.org.au,
        linux-doc@vger.kernel.org
Subject: [PATCH] documentation: networking: devlink: fix prestera.rst formatting that causes build errors
Date:   Tue, 15 Jun 2021 16:48:47 +0300
Message-Id: <20210615134847.22107-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P195CA0064.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::41) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P195CA0064.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.16 via Frontend Transport; Tue, 15 Jun 2021 13:49:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3c0cacb-e41b-4afa-f4e6-08d9300467f4
X-MS-TrafficTypeDiagnostic: AM9P190MB1393:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM9P190MB139327E211F107AFBB13C44BE4309@AM9P190MB1393.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y53JyBeNoluJgK7M6RQIZkpYjvv1MUxY/ZrZ9zNinPSwuplxR9sQjRuAdetCk/jC1+1OMeAvBBvedxZYGjFtxxvxc7Mvsv8T07I3dnfh+LHTLi3h+mYAG2ApW5x0Ud+nYe9gz0w7/WIRW++FAyUcESQ0AUg4oRzEMK96/Vt5aUYmP206uHGS7sI+Nxq+Q27QYHg4fB6OBLXoWP7TMPLCWf/De+eq0YQaG/218SHwI8erHDSepqy3JvGqikG0FSfWOOeRxD1Cv0zhwKay1Uy/HYEasVSaCvyU+MYi6F+CoJwQb92qT+ufTt89Ty8o9Do+dOHVIFqHwiJ17o6WIhagqq4mpvy8mFv4ndcliB1jvBrHhTJt+TkXKjU4z8I32KTXN47F4qipGzjT0YYi9jt/sMWWzGajVgzC2hyLZKEXKScKvJAtqnrRkQVITCGDEz+qT+WXWtftoTYhbx1CWl5sC98Rh7tleCt/pGq16/H2nEHep3MZngCyQ0hjWrOt+zVLP0NXCD4iYkL/TSyxEN+Nrv1+VPwEc+RSimNDFWVQXL45GWMGY5YwAXPXLnac/DtEeCBZDIVT8nETNycICbXNc6g/csIi6sRwIswxhmVs9Xw2qyYU3VgP1YSlQ9D81wFMvzQ9kJOqdDzUnZ3xeWV3yQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(136003)(39830400003)(396003)(8936002)(36756003)(316002)(6506007)(38350700002)(66556008)(38100700002)(66476007)(4326008)(8676002)(6512007)(66946007)(6486002)(956004)(7416002)(5660300002)(1076003)(2616005)(86362001)(6916009)(44832011)(52116002)(6666004)(2906002)(186003)(26005)(16526019)(478600001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?esT55bmYYWh9f6JjLH/JGE+DXcZOmB4bpJTNWa/2cGBZAzdbU+kapX6TPig9?=
 =?us-ascii?Q?QIVFhiDnu3eNXyt/HGht2TVys4Xve0FPM0WGSQzwy3CrEt2O9Xf48VIME7uy?=
 =?us-ascii?Q?dCQg5+9uVdrNSvjxhfPCcJMyKHU22blkobbatml1uIzR4cL2cfQ4aflfwdkE?=
 =?us-ascii?Q?bs/KIlQaGQAS2L77WCN6z2+5h5kjiaLvetzyTP1bc3JqAjwG/OHrRfqSJHX8?=
 =?us-ascii?Q?XnQrpIJKL/KAcQSmPppiKOglCf4gonYTUYy/Dlem/6YNu1YM/A9L6o4rfjJ4?=
 =?us-ascii?Q?xBw2V/itC9SuVZpg2pyX8BltHG3BMuccOge8NZ9PGS6grijR99BoWNBBbjou?=
 =?us-ascii?Q?Sc5xnbKpA1l+ub2shXPQMm1bMXvu+QvM5CKUFNgqGyOvsJPY0TJEmCFspdlk?=
 =?us-ascii?Q?400bmNuP98U5eBj37wOD5wINJJ+2GXm8R7HjG5KcLPUbbqQx5bnVjjlMHTmX?=
 =?us-ascii?Q?IFzzXnUzYmy9iSUYR1Vfyn9NQ1drfMTdRuE6f3aCLsMYGqE6a/9mmINnAK9p?=
 =?us-ascii?Q?Rz4uAEzQ3KGFLB1tdx2vTsnUNro9kf8r9dPZWUfaLAEV93XBgzJVlhx5+r3w?=
 =?us-ascii?Q?KdL57g7X02e3Dm4R7KhcMTolNNZ/+olRY4o46EgjkS2vi/5gmPjRmHRhP6xT?=
 =?us-ascii?Q?n5LUWdhoR8sH0AXz4WNu7LQ82xDt25GiujiwUBHAng2CVNVrExYRDV35dryl?=
 =?us-ascii?Q?bNU4X0V4sY9Xusn6OBIWraJQ015rYkdvP1HEDQmpcTf+9/ODcZT58st3AOu1?=
 =?us-ascii?Q?VdP8+VneBlC3CQcEx3WHxo4sZxxsEYYy5jq03iiDQL1RF1vn/eHWcFthvTe0?=
 =?us-ascii?Q?IQ82SKJRdB7Fax7Xc6dn8p1OhqSXGBpA6OCOpyESjhBW/2ViqB9HfR5Q0FP0?=
 =?us-ascii?Q?Vm31xJ+sXTlpdWzOLLpvixVjXWS4KXgbquPV1WmGlHUs2Yx3RBTYTiPVHPt/?=
 =?us-ascii?Q?l1QoS/7LBDS5qTgdX0m97GNb4EIM5qB1aWgsJJu1PgSffBkdFdZfs+BEmSn1?=
 =?us-ascii?Q?O5FG0/UxzuzbgyJW2pGaQB04dr+Tgd4oiqwAmn8UeDrhAlyjt1SCP0D2yfZQ?=
 =?us-ascii?Q?7BXc9V90lMTzjEScyotV//H7opp6ILKjH50cHw1EADa2PwEEeVn6Wshvax8y?=
 =?us-ascii?Q?go3kdwNSH6TpbDCovH2bOWJLKSu8IobfJHONp54XcmkRIsPNRxP69ejt+dAo?=
 =?us-ascii?Q?EA+b5dbaE3lDMdfmhbhTGRjkftCkF+NYs4iNpwXiuhBft1rV/Sw1z+3Mddj1?=
 =?us-ascii?Q?WsmXKwlS9Tx9YM8hvxFD9wCutVUDfNSWwwbqkbSIZ66xk53ZHUYQ5UJ2MIwK?=
 =?us-ascii?Q?GhWWzHsjCsOVD/DHbFIWeQnJ?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c0cacb-e41b-4afa-f4e6-08d9300467f4
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2021 13:49:33.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XfNMEUtcah65PgdnUEMBEh+0+cx2LgrLpWQS+LIwvPzvgypNFtTnoiW72kW7iIi4lrT3Ldx1KxrHur7QTmAUEBhim70tw+FNqNoGWyjyFi4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9P190MB1393
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: a5aee17deb88 ("documentation: networking: devlink: add prestera switched driver Documentation")

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
 Documentation/networking/devlink/devlink-trap.rst | 1 +
 Documentation/networking/devlink/index.rst        | 1 +
 Documentation/networking/devlink/prestera.rst     | 4 ++--
 3 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/devlink-trap.rst b/Documentation/networking/devlink/devlink-trap.rst
index 935b6397e8cf..ef8928c355df 100644
--- a/Documentation/networking/devlink/devlink-trap.rst
+++ b/Documentation/networking/devlink/devlink-trap.rst
@@ -497,6 +497,7 @@ drivers:
 
   * :doc:`netdevsim`
   * :doc:`mlxsw`
+  * :doc:`prestera`
 
 .. _Generic-Packet-Trap-Groups:
 
diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 8428a1220723..b3b9e0692088 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -46,3 +46,4 @@ parameters, info versions, and other features it supports.
    qed
    ti-cpsw-switch
    am65-nuss-cpsw-switch
+   prestera
diff --git a/Documentation/networking/devlink/prestera.rst b/Documentation/networking/devlink/prestera.rst
index e8b52ffd4707..49409d1d3081 100644
--- a/Documentation/networking/devlink/prestera.rst
+++ b/Documentation/networking/devlink/prestera.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-=====================
+========================
 prestera devlink support
-=====================
+========================
 
 This document describes the devlink features implemented by the ``prestera``
 device driver.
-- 
2.17.1

