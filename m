Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A44A33F75A
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 18:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232648AbhCQRpc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 13:45:32 -0400
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:58097
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232499AbhCQRpQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Mar 2021 13:45:16 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGb9BXinGWWnbNLCrJKc3Dd3JU5BVuxeRM56uGvnc93RYkjdHdRCPFhEtACIyBtzKt/Cq/Pjh8bXT8CSKGLK/G8yERNulIMExLoc5SyRSx3w4PW8Qq6I0l3Jg/G2Da8Jid+KKBB3wxSQ05uu6DTJ0yWXxf3SgD24j/HraY9aEcfltiv6docsPjNfTGFFgsSQ+Bq9swTfvpLYcACc+cmsqMs+hl7UdUVouWfd+v+BNtobOwipRHoIP4c5Vj/17C6N21XY5cRAqZECaaWlDRfbqfVU5ekXRn9y++3qUw19I8KviYlcHHSysRvUJdjTqhaNVSpkFrHT66ONlM9AAqbnxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwaxEMeBgdd/ho52YjoxMOn6VqH0dDMZKdz1HZALJL4=;
 b=OYn2MtulKgIBc+a9dL4PL1bueISa71faoDvQzxfSKMAkC08G+dy2r3Jpe4zItU6+0tRlfcVFIw0TcXQpzQe1QlIQsrdnTEIKSnRXsYlN3PFQNG5sHfbUmnQUfrfuqhQlAvwIjWA87cy3jbb4OCgA2fwjbGZKfR67T/C/NduT2oRYk2XC3ihADa9WbiPuD7OuoRuF+uIX7jYYwUDky2amjOeEea+FsgX5fxD37ZbHGiRlM2GVyJELhTdHuBpMHorusRblqT0TBVLTIVALrqdtj794BVJ5248CgXv3Sh8mLZTaFKIk5KoqQ9OoBsYt5kNRyotBReHUNK0z1kYd4NeEKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IwaxEMeBgdd/ho52YjoxMOn6VqH0dDMZKdz1HZALJL4=;
 b=ai6OSZABOcr7tye9dMafhvgoPKubn0UUs7n3UbvPhaHIajBa7B4Lm0DHUftRIRU7iHAqP32AHyz2q/ms9+kxibBLr8+18ZkkJAnazuu9I6cfFwpfUdLQJsp1ExYxBcMEFRbeE3lzVUCS0dX/vbcR3xJaJnNz93aIk58zsFGZye4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB7119.eurprd04.prod.outlook.com (2603:10a6:800:12e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Wed, 17 Mar
 2021 17:45:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::f0c0:cb99:d153:e39b%7]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 17:45:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH net-next 3/5] Documentation: networking: dsa: add missing new line in devlink section
Date:   Wed, 17 Mar 2021 19:44:56 +0200
Message-Id: <20210317174458.2349642-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
References: <20210317174458.2349642-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.12.16.165]
X-ClientProxiedBy: AM0PR06CA0106.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::47) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (5.12.16.165) by AM0PR06CA0106.eurprd06.prod.outlook.com (2603:10a6:208:fa::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 17:45:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28d83703-216c-46e0-151e-08d8e96c6bc3
X-MS-TrafficTypeDiagnostic: VI1PR04MB7119:
X-Microsoft-Antispam-PRVS: <VI1PR04MB71199156A556D68E004C324DE06A9@VI1PR04MB7119.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qmE9gS9wN0xdnDfmpzYKBx8ZtGdSl7DN9zjTq/GU6wGVZ8TguIUnj5elbDOOFnxP8FZ00s4wPEJ1RUdX6zTI1NjOPV9MBMslTgD9GMVcOV2rrjcnI/tJ49C2+FyGzT4Y+6WURTnMyz3/LkfuO/vXbgQoyIp/uJcjcldeZPTNvek1LCGnscn9UXkpA/zmuz4qc+9qKfJ/wUJ8M3lZs9xGRZ84QurQKl02rYzVQlCGijJeJe82FrxE9G/JSe22myQ8Pd9GTHbrdeHLvzxXDx5e3UApB1WE7oDimuqdgfV0YT7aOmdOxGQZd22RIFHqFnxaYSfvJhb8Jf/QEYLVyCn+m5XuySWjtUoQmw1xsQBFyfJ4zhwfPruM2hKprbXjx2cylf7ERyB1fV4HTT/oJj2lzLD6TgCFhXogEb+bwuKDjD6dYU2BoE1MlilC/HfN/ovWmHErKLcu8j7BHowkxm6zETOhLTjBLcu/tCbQ4LvTdyVWIhCv5nHEvVAK17acABpUr838z5kNZaSl7TMenjzIBHj3Ss93IGXaO7BHvCmOUcXs4rt9hCTtpidFcl9kBZ6FBVbO0pL2CWE9utlz2WsrpZ1UAnO+R/aMyyitAkTJYQmQxQeheXCzPqEbQpJBC/S/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39850400004)(346002)(376002)(136003)(396003)(86362001)(110136005)(83380400001)(69590400012)(6506007)(36756003)(52116002)(6666004)(1076003)(186003)(16526019)(54906003)(66946007)(66556008)(2906002)(26005)(5660300002)(6512007)(2616005)(8676002)(956004)(4326008)(316002)(44832011)(66476007)(6486002)(478600001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?cEaaX6Sc2SsRLVNH4NH0qZcF4JtN7G845+w1oMnHYNgmAOKBIjAgSbyP4sA4?=
 =?us-ascii?Q?OoftNYUL38QehRcz+/cfO29EWwrTNJGs0SU54UvwQoMrFpnQEWD35qT5PG72?=
 =?us-ascii?Q?ixYDg8n8ch04qgZ5VGCeSpKIl5CLyWWATO+S460Bq2pFjcVcqWusR5UHQFk9?=
 =?us-ascii?Q?EDNVaUfjxlbRoheDVHQ9vRKlyhQT4mm6kiaNJf2++ZaKiXWjc3ePk1AOMSbb?=
 =?us-ascii?Q?xYelIG2AGX4fEB6fZXYhZaeZ48YN6Jh2tWegSaKUlg4engByHEiWDxMvKNfb?=
 =?us-ascii?Q?FNsuwErA9pq0Jo7iqxfzRHJQ2Tb8XBy3yxdYD15bSKftd8moVuLpb9VzVuL3?=
 =?us-ascii?Q?J5sA5K0cqEyM4+2eBLivdDQ7XpJyfwLF8WEnNC+6HMV5XptQkLHZEj1E7boq?=
 =?us-ascii?Q?pOm9ZF7BcBaiC5gMl8CLclLf4Kn0UHv9DWrC6M0Gdth+ac0wR5eWCrd9ygFh?=
 =?us-ascii?Q?t6gNwP7F/rp6s98fbKwZTRV6oCM4fmkPvwystv4KGifyE65G/KPfDx2mEbn6?=
 =?us-ascii?Q?SjnbbH5IGQ6WmQ9D1nTW73VU/3tyWqiMMh8vg+QHKz5bL7HoE52Wjk9CNRx1?=
 =?us-ascii?Q?UUJO3aCMkGZeZA3qwSMxwOsD8Y3bo76MQTV0YeRx8YQebRCTkn6Azn3o8/+P?=
 =?us-ascii?Q?S49KEx1Qj4cwW7PvJRZjRNBZ8jYW5PMeLT5n/UhGpnClTwF3s9foETCi00W5?=
 =?us-ascii?Q?f+PG4xqn3spAOuIOLnDZdfwkSBYpTS+l05ZidJbZEGxPhkEvmIinD2Pi3Kn7?=
 =?us-ascii?Q?1Xjyqd4GJRdA/Cr1sFK/As6aSdp68Z1OavOAuClImM4YbSjLvrBN5zMoRIZB?=
 =?us-ascii?Q?lZc0MFW8SKoyzomJf9UMR7irOFn+Te/QII/TTamXaxlBgPT/qpxCIIimPdpE?=
 =?us-ascii?Q?7LqUWgLLKEUtuNOBWjCojBKAZmGvVlKqcjc+GtVvscMMSjf/8VrY1ETh9RV1?=
 =?us-ascii?Q?0iilxAf20cGvYQbNyn/XB702LQc8Kl1z5Me9rkZ84Pe0jZYqbMQ8D6PY1vu7?=
 =?us-ascii?Q?Yh0X1VMNzeVWGuoNcIm8AsW+aOblOEoKtugvQ0curKtQMn58jyN+4KdRED8e?=
 =?us-ascii?Q?DWdWfxIJ4OIMvxofZCTIYLr53VEL1dd7NqschPW3SamCmwex3cZ+kPojSXsq?=
 =?us-ascii?Q?GcFo8vd/RXzLPF9Yzg4j/VXqS326kBP73Tyit0z8klL/NygrYICF2BjbvgqK?=
 =?us-ascii?Q?LKqAYkl4J8RoQXLp9mruJQNpFhdgyt4lYsnvgJgxg/vAlbKxRpORpXpkg3ZX?=
 =?us-ascii?Q?t6ahn2p2txE0uVp5uYx0G/KBND6GuSp36ldHO5XkWGlmgq8sC1s3vSaAO4pz?=
 =?us-ascii?Q?fUBjkTGvQFUVqnpXY1vMMtBa?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28d83703-216c-46e0-151e-08d8e96c6bc3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 17:45:14.8570
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ixsnGVnB3YvuYMbXNUkdmL//yWIPpgFxWZDEGhAiUM8A64VZ0jr06N0YzS0wgVtm+BZsekIWwxaLYMy5J7m7Rw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"make htmldocs" produces these warnings:
Documentation/networking/dsa/dsa.rst:468: WARNING: Unexpected indentation.
Documentation/networking/dsa/dsa.rst:477: WARNING: Block quote ends without a blank line; unexpected unindent.

Fixes: 8411abbcad8e ("Documentation: networking: dsa: mention integration with devlink")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 69040e11ee5e..8688009514cc 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -464,6 +464,7 @@ For each devlink device, every physical port (i.e. user ports, CPU ports, DSA
 links or unused ports) is exposed as a devlink port.
 
 DSA drivers can make use of the following devlink features:
+
 - Regions: debugging feature which allows user space to dump driver-defined
   areas of hardware information in a low-level, binary format. Both global
   regions as well as per-port regions are supported. It is possible to export
-- 
2.25.1

