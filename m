Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C0223F3CAF
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 01:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231372AbhHUXGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 19:06:25 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:31556
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231271AbhHUXGX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 19:06:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kOHeMCGFDE89cBy5qhpy157sxBBqg0z+QL+gxuruP08Ye3TZd4+QxETXHyd1mU+hHT8cgTTjp5ugShUDsDMkMxYAO1T+tBJtIyHlEjAcSlo5t+Lvk2vTbDv8KnqJF9bPorPgEPl5IWaKdai+AWGkQZxvG2Icj7RUp6Zihh+hPQxxTdddU8PiiYTqE5YKkJodjRWNKPcvZhjlQGs686XKEz8mjynwtw+iGTuWzwjip96mpgz/2B9/Nx0Xx9O3oFEtzYpr2jlH2M1WIJGhLLgmFfmDdtk7leHro5+QS41jGy/nTxAFea3QRkOAJtAQb1supuxrbxEbJD6VkR4q8qlCqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYGBf4GyZH0+A9LBR9Ndam5KLHkQG7xKXkqjU0capXI=;
 b=n0jnaYRFLR8o+HKel2ACbt0+KllfhZr6Jjbli4/q8l1jVp99eqPOIQc4DYJGdJqO7HO4t484WTH+y8qjoimMrI3A9tgyRcTkT169BymMutoEtNZdZ2a58nKY/GZYB/2NKFOLClK6mp39/+5kBeLCaApzCKBvK6uZZoSWsE33kmtWHdf0YNCSxW6SvILD/Pj/YbDbAySiFrj1m4W+4AxyrC/1n9A4UVldrOTgizLfijPl8pq4rbrzAv27Dj+z9zX3uzzV6A75kSwS1tfCj2NOhm8T3EIyrq+lCZevX5A5MCxcGHHPKtxtjQXNNg+0QumBykuPF/aRoGPNXuiIqb3fkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lYGBf4GyZH0+A9LBR9Ndam5KLHkQG7xKXkqjU0capXI=;
 b=g8gxnB8Xg9pFnLs0HApp7H2X8d3X8c7viHNz8l/ILzZz1tfVxbORy58Cxgk94SwzFEdFtn+Rip/X8lYE9tCaPqexERnzgQbVSF3IPtq1fmIga7huhtV1kIBc7Q4VHpus37CzdHGYUBzoGPwWiz9E7m6YJQxHHGU1MeW0Ky7Bb+o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sat, 21 Aug
 2021 23:05:38 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 23:05:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 1/4] docs: devlink: remove the references to sja1105
Date:   Sun, 22 Aug 2021 02:04:38 +0300
Message-Id: <20210821230441.1371168-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
References: <20210821230441.1371168-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM4PR0501CA0047.eurprd05.prod.outlook.com
 (2603:10a6:200:68::15) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by AM4PR0501CA0047.eurprd05.prod.outlook.com (2603:10a6:200:68::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 23:05:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 446fa425-9882-450e-1426-08d964f8308e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5133CE850F5580A61EFD54E6E0C29@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wSFXOImKzrbtcZezo4iWKHKzey1xERosPUQEiYW1dF4JsuQqx3fwfwRXh7RaOUF4hvQDPHkK71Ux9+ICfUMPXm5Em397DDdJ6S2bpPLZ5HsQErNZ5ci6el8egAKzvUqDd2eoTAReyCRsmbCnVTK/2CzPJX4AKYQx48tu0R+by7fEnVpsKRfw01Q/gtbUfJpZWSGi9kjR800GB8XMUCbFpJlouGYWq1bZpv9exVPhJAZbuMh7JuP+62j6YLJtLm99UQVGG7Vgq0dA5WcPqp3dMOwJx33p4aZvDIYbnt6m0Z5skTUiCENO5FznbG0+dHPtrpTjO1EEmOXonPfH7jfkRi8nE/JrwNtJiQ2gtwOHhnHaQhXBzfH1RNfevKaPq2GoJFW6rhzyTR6sdA1v5Wuf+lixonzu871UKPWlL7C/BywClVd4lEGMtl+blcQZEZmHv8sEsraXip1ctrnDLyVcWdBw8BgxWNkIUJ4GWheGVBFAfRUKCXIbOc6BOUaiKqt+dXO/0S/b1RVkiQIOuZDxbUeJgAeWnait5Dl9Go2uikGDllo/vogM2CO2HcKvOqVW3stPgf26XVv3IL8s5gcTuk/pOJgH8qsXA8TaVz47XBHml94q3VCEF53vS4TTI0sQJgo7xpOcviNJIyShMxqxYfBXgN7RHMruN5PSDRu6vNDDN0xxQEdMp2Ncy7oDgS8m9o2Usgckq9uKCXeXnFlnyg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39850400004)(346002)(396003)(66556008)(66476007)(86362001)(66946007)(2616005)(956004)(44832011)(38100700002)(38350700002)(316002)(6486002)(1076003)(6512007)(478600001)(83380400001)(36756003)(6506007)(52116002)(6916009)(26005)(186003)(8676002)(8936002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?IzaPzAWzZNB6uuFc5oqkEtF+t8CeeZZDKcmoLhEFnukQ+4vDUfIcZm3dMOmT?=
 =?us-ascii?Q?IzdVd4pd6Ql5KENiOabhLj+WkHJGQiSIs1+yIlV2y7wSWgBp7acdKqzwGjQb?=
 =?us-ascii?Q?H4Z/mTWaNyn1/wjYK1n43s+iQIVNR2KR1JYUVOZ8mqA/wy0JbPRvUwJVE6FM?=
 =?us-ascii?Q?XWMiGcRxQ61GlWC9Rd+5Jnj0KaAUO2Ddoh6eUXShIOaXAmMXfVB9JPrVEYjv?=
 =?us-ascii?Q?bCvwvNORUjliR5kSoLmSe9YCu+lp4vSldKKcCTGhTrqfMaHQ4I7o9h2r9j5L?=
 =?us-ascii?Q?DSplr1iSV0alB1mnGVQ2ubygsSd0Tu+c5NsR7slQNhnCKfXi3Pz2MxbLcZaZ?=
 =?us-ascii?Q?I4MPbCfGM4RCfqF8dczQMn6QWo0AgydgIlUBpgmxPYCWD0t2FDguPtabIZgG?=
 =?us-ascii?Q?3OpJoaCDR9T42E/HZZ4WdcBSk+BxSUi7d0wzN40JwPBFr2AjTptuhlUoqcyx?=
 =?us-ascii?Q?kkLVd3OlrFPh+BI0hUiSf/NyRBZlZ3l+D2v/eiNJ6greoMLpWGB0UrMo9Oon?=
 =?us-ascii?Q?1ME53sv5bmp4k/bk8Nnd3OgfkivxopHCAqbr36zijFAmVhA0K6T+tdirN/VN?=
 =?us-ascii?Q?ame6D6g3k6putBPYkq+Mtr4p8DEPvHHWoV+KDwI8EJlXZkhyN3X+iQQvyHl2?=
 =?us-ascii?Q?6r698EpkZcTmYqjCKTWvApfWkytySg1jpGHwX48FmLLIwR5FYdZH4tpa/zKy?=
 =?us-ascii?Q?dr1uy14FjLVDmTxNQeb25K9Sj+G411qAm4L/HSG5KlHQ+bhYCYFuvki6gzGn?=
 =?us-ascii?Q?GLfOgzEjKZ8eT1oYqBphHTHdqkMkZcEkSzJrttUPjfxJXPG9DUoXFF0uqNLs?=
 =?us-ascii?Q?bO9uU0hAT+AIk2+1mb69CxHzSbfUn7qbvZ6ZtA19ZmS7aLiO2GbHmRm1FzH7?=
 =?us-ascii?Q?UDut/9tQRJ5Nq8wSL4bcMNegWDas4XuSMUAQuVducRdaJLPfXnHWtL+Ftpp5?=
 =?us-ascii?Q?UCm2wrgskQjpbfEaw7l3nTmSc5eZCR+MbPtlxUrvwJ3lW92QIJvB4UgMknF6?=
 =?us-ascii?Q?1OdnUy9Y/uj7bZPcpu+qjB48T8Nxx/UPecvNQRSPekY31G6KQBuzp4Dkr0LK?=
 =?us-ascii?Q?ou18/7eYPfiNGsY7XdwDKGVSY+ldVoAguZX7i21CN/uFmCyvpZs8tJWqszwB?=
 =?us-ascii?Q?HOXhsWbSVgKLys6umOJAOvvMcjO0qR3VuqR4jvUz6QLsPqpegmbuxsVN+N2g?=
 =?us-ascii?Q?7Tlh+o6Frv52bIUSa1a3T8IwhF+xO0dzx9FohftnOiP0pn7kX9M6dtAJNImk?=
 =?us-ascii?Q?DbF2mswNuYt9tEMmhBXZhuMskECZ3pyktVLwGYhiJrHjqxhsQ5QwzCI1oVWL?=
 =?us-ascii?Q?OraC+zevkcuCNRQ2iZFNzI/N?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 446fa425-9882-450e-1426-08d964f8308e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 23:05:38.1538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UaBVDLG3htuFni+6vzTQ2Rd7ttqX9qKyzrifwh6cdXyqLxBqgmdD9N/6KP53/DkvblkComUNpUcu41gO/g7H/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 driver has removed its devlink params, so there is nothing
to see here.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/devlink/index.rst   |  1 -
 Documentation/networking/devlink/sja1105.rst | 49 --------------------
 2 files changed, 50 deletions(-)
 delete mode 100644 Documentation/networking/devlink/sja1105.rst

diff --git a/Documentation/networking/devlink/index.rst b/Documentation/networking/devlink/index.rst
index 03f56ed2961f..45b5f8b341df 100644
--- a/Documentation/networking/devlink/index.rst
+++ b/Documentation/networking/devlink/index.rst
@@ -43,7 +43,6 @@ parameters, info versions, and other features it supports.
    mv88e6xxx
    netdevsim
    nfp
-   sja1105
    qed
    ti-cpsw-switch
    am65-nuss-cpsw-switch
diff --git a/Documentation/networking/devlink/sja1105.rst b/Documentation/networking/devlink/sja1105.rst
deleted file mode 100644
index e2679c274085..000000000000
--- a/Documentation/networking/devlink/sja1105.rst
+++ /dev/null
@@ -1,49 +0,0 @@
-.. SPDX-License-Identifier: GPL-2.0
-
-=======================
-sja1105 devlink support
-=======================
-
-This document describes the devlink features implemented
-by the ``sja1105`` device driver.
-
-Parameters
-==========
-
-.. list-table:: Driver-specific parameters implemented
-  :widths: 5 5 5 85
-
-  * - Name
-    - Type
-    - Mode
-    - Description
-  * - ``best_effort_vlan_filtering``
-    - Boolean
-    - runtime
-    - Allow plain ETH_P_8021Q headers to be used as DSA tags.
-
-      Benefits:
-
-      - Can terminate untagged traffic over switch net
-        devices even when enslaved to a bridge with
-        vlan_filtering=1.
-      - Can terminate VLAN-tagged traffic over switch net
-        devices even when enslaved to a bridge with
-        vlan_filtering=1, with some constraints (no more than
-        7 non-pvid VLANs per user port).
-      - Can do QoS based on VLAN PCP and VLAN membership
-        admission control for autonomously forwarded frames
-        (regardless of whether they can be terminated on the
-        CPU or not).
-
-      Drawbacks:
-
-      - User cannot use VLANs in range 1024-3071. If the
-	switch receives frames with such VIDs, it will
-	misinterpret them as DSA tags.
-      - Switch uses Shared VLAN Learning (FDB lookup uses
-	only DMAC as key).
-      - When VLANs span cross-chip topologies, the total
-	number of permitted VLANs may be less than 7 per
-	port, due to a maximum number of 32 VLAN retagging
-	rules per switch.
-- 
2.25.1

