Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1FF23AA2A0
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 19:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbhFPRtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 13:49:25 -0400
Received: from mail-am6eur05on2107.outbound.protection.outlook.com ([40.107.22.107]:18144
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230350AbhFPRtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 13:49:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A2jDqhlIfxVKh/YQzojnle2n3VqUgOyflA2p1t2/BrQTo/fFznq5G2hp62oY8Mvv3yuY413LTKZqRuBkkxLaxLqD4aEpl7hhDqoPObY11/npkZsRzQWPWH/RFNsndujO6zVTlZQjOfWnOBnTVcUmBIU28ktjdOoAu9fT7cLjx2MGM6N03P4cskTsVjMFlMzXC6HRpy1aa/AIpGsaoCUReA5aaHnIctN4nPRL0qnoeSulyU2oakTt6tYIlePpZ87dcob2v2xu0hvzzWZ0YWDyZ/KzvOOOXGrsteT1OOyN5iIL1m6IFNErswqRxc4O9DTeAW1/JwoSAX+TOIpgd5lAIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AogVmUp52BBfHJWp9+du5AVRXQtau1nxojZ4MLZGdU=;
 b=F5Rd3MCiVkOcmDlTRNpzRjcmZTrWCkn44IXJo64OuL2N7wLYDElz+D7LE3fE7vfpntNCh0wzgMcE9stQoslUmFWA06i/9IAVKPGkeolu8QrKBqqH9n/ftQnGOZIYGP5VLl43aKOrXmWxSeRHS/LtUqZOKp5lM5l6tCsDLfwJHtUXal+QEw/OxnQFnC/1fYXWic49Oc27Mc0Kn12QD1Un3V3h2cp+aSUgHsWNcD4ywXIkfV2GursiMZxYGMpP3juUOL1sW5f6ruG5t3xFJ25+cBe6yfIsABx2RrdIVRg++jzSKrAk/ij8FGozGOOQyUXqYsIT65FS5cgWknhAMOPl+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8AogVmUp52BBfHJWp9+du5AVRXQtau1nxojZ4MLZGdU=;
 b=HZPcrwBKztYvF/PxJ7/J6ZJgqm2Y9ycr9XZO+qBJMRG3wuRfs92Zyaj7Y6BsNe6SiFXlRR2rP1jIQqiNtzLxpLHz7DuxLms3s6T1hge5PP2ahHXUqe1mpBmsPAKmbrODRXXsKmSyDbAXXvusmU5sIUAT9omKeHosUbKuiqk1gjM=
Authentication-Results: plvision.eu; dkim=none (message not signed)
 header.d=none;plvision.eu; dmarc=none action=none header.from=plvision.eu;
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:19b::9)
 by AM4P190MB0052.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:5c::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18; Wed, 16 Jun
 2021 17:47:15 +0000
Received: from AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe]) by AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 ([fe80::d018:6384:155:a2fe%9]) with mapi id 15.20.4219.025; Wed, 16 Jun 2021
 17:47:15 +0000
From:   Oleksandr Mazur <oleksandr.mazur@plvision.eu>
To:     oleksandr.mazur@plvision.eu, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadym Kochan <vadym.kochan@plvision.eu>, andrew@lunn.ch,
        nikolay@nvidia.com, idosch@idosch.org, sfr@canb.auug.org.au,
        corbet@lwn.net
Subject: [PATCH net-next v3] documentation: networking: devlink: fix prestera.rst formatting that causes build warnings
Date:   Wed, 16 Jun 2021 20:46:07 +0300
Message-Id: <20210616174607.5385-1-oleksandr.mazur@plvision.eu>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM6P195CA0014.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:81::27) To AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:19b::9)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from omazur.x.ow.s (217.20.186.93) by AM6P195CA0014.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:81::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.18 via Frontend Transport; Wed, 16 Jun 2021 17:47:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 02a943c7-93a0-469d-ac2d-08d930eec738
X-MS-TrafficTypeDiagnostic: AM4P190MB0052:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM4P190MB0052E38CFEF8B4D5B287DFB3E40F9@AM4P190MB0052.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:311;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZhdfzxanQ6lWe59+JCJYKFcla1ER4NSIbsQ2lZb1kMFItKpGTGU5ICxwgl30sXe4vtlYF7WOe+xvdE965zHEGrmPHjgA6q4Zi5/c6Z1QCrcRTHlq3sSfW4Bj8b5eeJjag8ZK+V4MXuJpN48lmN0Tlkgo80F0L0HvSYU7CArCPXueG7tYy+MtmYPSuJaIJtQtrspCoRukqAceBQ8OEVQ2jNSsR0+LzIYpTvQBZRwMtph0Uz1mD/KrPdKfAbOEnaIsWYxmG18P+/S42TtN4ZW4Of+hgg4HX8QGy66mSGjloAR94G3hWvWbs5YB+FPdNhtBrnUJ6SxJiKY+8EEpMa77Zxk6BwZzAEelS0kmPqdhyfyp7m+cP/Y1D+FoZIK+8zfSZaVSzd5wIq/edqmpf4UDwAnA0GFnzyyjE9POLvxpfjj/7hud0NGhw7N2RdjmIw5v4yYH8lF5C8g+ABptm60SZfT26V0g3hnOgNr0ZbWIdclhGsvP8DD7Tl7BV4FcjIdajlkfCfFzR7TdfrHz0I7r2KrQBBqjSxI4CPcgH1w2M/560rvKeEmCFF/Q4PKVlZd7IUCKjLjJXDwTsE4ktww5ybiTtbnH5rKcABws6PdA4Dtf41QyzQ66xBHX8ngN1yv41KdyDJv+dM/LIKNM0qQUiQL9teEx9cstFvRKLoJGREU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0738.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(346002)(376002)(396003)(366004)(136003)(39830400003)(38350700002)(2906002)(86362001)(38100700002)(36756003)(316002)(26005)(44832011)(8936002)(6666004)(6486002)(8676002)(16526019)(186003)(478600001)(83380400001)(7416002)(6506007)(66476007)(5660300002)(4326008)(66556008)(956004)(52116002)(1076003)(6512007)(66946007)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?U9DZk/FkiWUivz0W4aR2BNAd3plBGH6H9G+3hhr7AjeE0qBk7ZeGLhw82kYe?=
 =?us-ascii?Q?8+fqx6j0Xc4XxhFH95RVzyUvu0j5aP/eIAFIXoEm26NdcCfrgXlH0Jro2++X?=
 =?us-ascii?Q?x73D7VvOPsQ183y2xpo6sS6DDuzKnGkhwIy7PKF5SmjgXlTckUzA8nVuFHuw?=
 =?us-ascii?Q?ERBKKsm9QDqEE3xrSesAb680buWIQzUYBZNfVrg+g7T8qYcvcj0DLK0ZY91z?=
 =?us-ascii?Q?NLjE4vg7kU0zK4F0fUqs6JibGz2t8aWxiYYPrpfoaBKXaEyzz1uM6/LF1DZU?=
 =?us-ascii?Q?5GrwZ8aVmREMPiTKDYyJ06NeLpCzAs8Xt1pA7uPxwAfY1gUmN4cYrPUklIad?=
 =?us-ascii?Q?L7LNYCsySFHVg6iXhsNeHk8VEUqK/yP/bawy9ti2egGGrrJhEDOBUm2gV6NB?=
 =?us-ascii?Q?gMVTgmDbIJt/TIFnn6m1jfVwtqENUJFXYUr5EHvEy0AShTFF/TqoTfeyWdUB?=
 =?us-ascii?Q?DwBYiPIzFc4t60qf5QRK53AIkSbLKD2GipIpPNWbOWLyBX9sZCDS2GFwN8MP?=
 =?us-ascii?Q?YcuzwcyC/u9mGr+/yBkd7zxYmro48Yu6n6H3zebtgE/cb3Oxd3/3KxvoPCbF?=
 =?us-ascii?Q?8KrPbYPjrPZcLQPce0AUd0njK/kK+5n2XPlIc6vtoRlL+p6nlhKkX6znyAJ4?=
 =?us-ascii?Q?Lqb4wl3PcXkNKxMJ4Tsjrd+XjTYXqRy8I6ZHaimaWqDX3QUYaWnu1tty1nA7?=
 =?us-ascii?Q?XR4v50UOzsfeFP0Ed9tXRwpPmJ+aa6NjKuBTu++9LMRTIy5buGSUEH0WfFyu?=
 =?us-ascii?Q?f4Lpkfpbm+vORxIZ5H06927VIIJzVsJuof66FSvCv8NJ8eOVAL38NRX/GU9B?=
 =?us-ascii?Q?iZtnBdG0dKTJrlKSbpvJmkbxph/WECRVG4lRkboLvzr7nK2KkNtShUqDWHuG?=
 =?us-ascii?Q?Wma+Jo/YOndnoUkiKlSLbWHov1jT7YQm/pk3iuXtMmxydB8oEOnt6c666T7C?=
 =?us-ascii?Q?2e6sU5WbPkYlm7pHNq0bZO8g30oj7GivXw3FzSDfmFATgBoupJcLjvSfimoX?=
 =?us-ascii?Q?pGJ1gCFYCTNgDr1E/UGVTS758lfvT/Apdl2cdhRIeikMdCq7Ut3qxoe1jElW?=
 =?us-ascii?Q?N/oQjj64uovpdnGN3H9MQZhvz/SZuGkXtZJ/Q2MwPNIFLsIHD76NibcIXtNW?=
 =?us-ascii?Q?O3M7Sd12cakximXFUvTE/Uf0QsNKRnmDf5LGwDkYQdm+YoutrSYMFuLc7Rlp?=
 =?us-ascii?Q?utsoPQNB178Xu5cO3LhCABEaywU7ygHRLna7WMDMPNtexiqNHrcY7OqzPPcj?=
 =?us-ascii?Q?/y2X15Nx1RFYniwvap8lqRW4h5BTtjq4/zTasTIt2SrwSmnMYm+HW7j70lyk?=
 =?us-ascii?Q?mMVGAXDvpN36wlORpzAssjFO?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 02a943c7-93a0-469d-ac2d-08d930eec738
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0738.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 17:47:15.3321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u7b28L8/6t7FMLpFbfnkREaRQDIezmF4FnDlDYRdCq5Ar5vscZSsdbjsYx68rj68pITX0GfaGTnEtGp1RzbP6KZbIe/Y9CVy9zm65vede30=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4P190MB0052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes: 66826c43e63d ("documentation: networking: devlink: add prestera switched driver Documentation")

Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
---
V3:
 1) use right commit hash in 'Fixes' tag.
V2:
 1) add missing 'net-next' tag in the patch subject.
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

