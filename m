Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248353F3CAE
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 01:08:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231331AbhHUXGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Aug 2021 19:06:24 -0400
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:31556
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230343AbhHUXGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Aug 2021 19:06:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WhEQ0ACncKqgBUces2vD/fySZuo2xxIwYSsLOMwURJbiw+HzA7G30XmEjBCCYpRVUYFJff7tN9PII5Px64eRn/5oVZnqD96hh35pFZ2Qzx6aRYYAPLe1AsDTztqqDThct0P41d1nmal9veMsZVPBt5RxUcBHQfHpmg0hUqbS/T3GSzBLj3yu1WAfHIJoVmd+LYBg0pGQ+jOKgT9tW5yL2CDqI6ZYJxILz3F1UoYdB28+b0HMQU8i1Rbro3IOjvHqBf0GG848vocpsShUzucmnwQifggNVrjZocwSodtHLDRgSNmQP46Kqy4fy1Axi1i/TAk4ynEtrjrBDFhYtZToZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MX0xfVFSGIOJ5G+oqOXY25v1h+GK18vYoD1lvNdKD2M=;
 b=SLyu3DDOzEYlNuZ1IP4Yzl7/Jxwc5LXsEO/51FJQI1eEif+2l1m5WnjTriTebQHx00aZHBqMw7BLEvEgzPAz93Is4j8YZ9NiC+J1rb2ou9ZcBLDHk4QtWSHsXiPJvGBw4JYebsMiRjhbeiirq8ZjLx+/rwVE7RNDK5Ff9Ye1JHK0YIy5NG5RbgQ++P3i90BHf7plIlE035aU3Gtm7TQ++V+L4VqinTE0xacZAOT2WbzWc0BwosRoQhv4zN8sXV4oec/n5lz4uO6mJn26fzghlno4PP6wOqHA9iLE/bxnv8v8aA9gwYm8q+Rq6oLF8NmQMLZh0sUDFVcdyt1HwmC5PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MX0xfVFSGIOJ5G+oqOXY25v1h+GK18vYoD1lvNdKD2M=;
 b=O7I/aNlF+trT+92xZAcJROYm33quMrV43fwJCfH+WXLrYbFQxBK5SvWwV/MJrZOydO5lYUKIq1TMipdT7EY/rwNUUA3IsHNvlGfn9T5h5N0QMe8N4NfiHmxkbiVKiTUDswOljX/FPQmRp4GZxHOGq1dhrYOM2CLysbsvNvGhW54=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5133.eurprd04.prod.outlook.com (2603:10a6:803:5a::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.22; Sat, 21 Aug
 2021 23:05:39 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.022; Sat, 21 Aug 2021
 23:05:39 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Subject: [PATCH net-next 3/4] docs: net: dsa: remove references to struct dsa_device_ops::filter
Date:   Sun, 22 Aug 2021 02:04:40 +0300
Message-Id: <20210821230441.1371168-4-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.144.60) by AM4PR0501CA0047.eurprd05.prod.outlook.com (2603:10a6:200:68::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Sat, 21 Aug 2021 23:05:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f4f770fa-fef4-4449-3776-08d964f8313e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5133:
X-Microsoft-Antispam-PRVS: <VI1PR04MB51338DBF5BB3E6F3EEDBF39DE0C29@VI1PR04MB5133.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NBlVbBNBnyjrBaiwyksxbFnEdB3Ry54wAVPaSIB2Y/VLAew3m2nIZJUFbIXacS5Pxos0kRDAThrI2ygD8+d9u4qR8KrcnqiBTySnrR4dOty2Zb5CZg2yxmtWHtn0FzaBwr0j7+jEGgeRgxViAD8cx9WHZONPkP5LeQRMKOYPZiht06DgR+ux6++mpRqoif+iOMgrP4LyMVosJKehmxUMNZ5/5aXZAhMXN1RY8OV3q1bjRNBV0hrCEOiJQgEHba8LMoKun2P7cWQvbOMhZd9ca/TAIQURtGczluCIj8bzovrq0ANpwF8sG0KTAGSfwhAtPtcBiTv6qYLgq1naj06PfAPF8UxY71lJ3+7xQijRWEVH6fY9h4TtgNTZ8wmBpR3ZTju7pSxygcT02EKFlc6+G09S0PehueSXcFODgshmVogA1nKq9q4Yy6v7+49oHXBkuefBijCkQavAesQmNsOFeKXw6eihYJYhWD04fxnuvY/mB5ypXwBrGJoouier6gKeYexePuac9c9sMA4zZkPaMX47STofz1OxndDMVlioX5gRlbPknHCCWpaOaXYGcMBB5uZ6ysd6ZpFezoENpE19h2r2+nsNNah5dNKqfqGjBGl5jQfPuy5Z0DFCoMXMv7ZuArVwkxs1F79IkGnDGZxSFzIzvCC5ZrWhZ9xO/Dy10UfD9PSP4q9jumro6mPP8ZK3rZV12R6VFNHdLwuTLAyd3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(366004)(39850400004)(346002)(396003)(66556008)(66476007)(86362001)(66946007)(2616005)(956004)(44832011)(38100700002)(38350700002)(316002)(6486002)(1076003)(6512007)(478600001)(83380400001)(36756003)(6666004)(6506007)(52116002)(6916009)(26005)(186003)(8676002)(8936002)(2906002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7XqZOGHACH4X+tpqKppMJDSTG7f7s8F+jiCb0dtYr52vOAZoVGRIne62jCXc?=
 =?us-ascii?Q?IQrS0yJe39zILi28T7eOHMs958/pB44HuAhiiL2hdmg3s5NIfQMNR/Ow+F8g?=
 =?us-ascii?Q?wx5SMqnRCwI4iLJqDtNNLL7H6+9gU9SMDJLMCuFz6k1cAm/eX10WWcuz1uZo?=
 =?us-ascii?Q?O8qM2hJigzwl09KYVIy3Gq+mXLAPnuZRmy+ReZd/MepiQMMeDERPcfG4aq3q?=
 =?us-ascii?Q?gjL7qSSp66uBlVojBI2I7wfIu4KNcahCNUe43B2gcWz69x96AgfsHTg9PkpG?=
 =?us-ascii?Q?2APTB4tz5peYviqWU1a0SzFyZuAN1gyMG4ErcbZxUjrL3/XEo6k8VoAwH/aG?=
 =?us-ascii?Q?YRZpILma4WKIQMc1mcCMvgIbe2FDO11fM0+XSXdRlzOecI+YySPsIeSdBOEf?=
 =?us-ascii?Q?RfwM7CXpyMaV806fQ+/2t9d7TwLrD68PI+P54HxmDeD46bYU1900lX7H3Lvp?=
 =?us-ascii?Q?1of7dTKL7t0rs9QeVDBT6CjVq3MPSfx8bLx0FtfavjGo4DpNt1D72xbKfzWz?=
 =?us-ascii?Q?JZ/pN8aGrgAlrpUWgVKtXwQTBHC9cLYCO6Xb4hjtwM6qby+rtLiHAbJTPA2q?=
 =?us-ascii?Q?UG8ponRQyJU0ET2kQN4i6j9Orm+GH3aBPcZTJWsWotwh8ykqdglCv1LH267I?=
 =?us-ascii?Q?L7kZxgyb5WgnKZONB2Dn6mWb3HPHxsgKpXLGRmyG1MFAQtHZuaQ57FiQBNcZ?=
 =?us-ascii?Q?y6vYMgnk8ackqChVrSDqjTX0N7kW4U3R+CQD9JizRQYZ5PwTAhT9Rtysbdig?=
 =?us-ascii?Q?nLtV3UMGzeDGPtbcfp8vICiRF1LJz/jHysn9G8c5i5GTqzDC0mEUgW+NnnaS?=
 =?us-ascii?Q?1Saoxt1XriHI+IZUHNDzFAKKb6RI0MxpdY3mVnbO8OZULm0J+XleEDFkKL9X?=
 =?us-ascii?Q?TjI4GqC4cEmuaOdSFke3sNvLpG5jihX5QMi+AEZPuSKwgHI5TU1uwQCwLkzC?=
 =?us-ascii?Q?YIzB4Rvh/mUEfZ5cR4WO1+zdkd+hGbnogTCLLW6WOK8sOolomQsQ9A6YauS0?=
 =?us-ascii?Q?pd1o22J2O8ZNgwVUhdcH+mBR/Gnbt/4VGjyuIEafFvWxmKSihh6gCu2+o1F6?=
 =?us-ascii?Q?gAXNVr9VxQcygbo+gwpsSB8OuKK5ImB8CizOhmxBo6MKgqF+OBJt/EgGrBui?=
 =?us-ascii?Q?DncMBRvOb4oF4mHAzBMiaJqiIuAQXoD5mDYxD44cARfBKx13xDmZmZRNL3w0?=
 =?us-ascii?Q?l8ykIM3xZ51O5GsJD/4zM0Vtq69z2x0cBbXBFNLH8GDv1CAYtJdInqdu3bKJ?=
 =?us-ascii?Q?7sHacFCjLewcOhiJL1KYw/g5zs5QTdj9sKcbQO6I6LoJrO236GyXPKM8yDN2?=
 =?us-ascii?Q?dyr6VW/rWPkzAAfl9D0z41p2?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4f770fa-fef4-4449-3776-08d964f8313e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Aug 2021 23:05:39.1403
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vcD/Medc2ji2i5zyn39n5cRUX+86ZUQpjuUiW6FtmveO6QPT1VbIWQ5KgwLFiem0MWtd6KUF9ce3Amxo7zs+Zg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5133
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This function has disappeared in commit edac6f6332d9 ("Revert "net: dsa:
Allow drivers to filter packets they can decode source port from"").

Also, since commit 4e50025129ef ("net: dsa: generalize overhead for
taggers that use both headers and trailers"), the next paragraph is no
longer true (it is still discouraged to do that, but it is now
supported, so no point in mentioning it). Delete.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 Documentation/networking/dsa/dsa.rst | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/Documentation/networking/dsa/dsa.rst b/Documentation/networking/dsa/dsa.rst
index 20baacf2bc5c..b64cb4068c13 100644
--- a/Documentation/networking/dsa/dsa.rst
+++ b/Documentation/networking/dsa/dsa.rst
@@ -200,19 +200,6 @@ receive all frames regardless of the value of the MAC DA. This can be done by
 setting the ``promisc_on_master`` property of the ``struct dsa_device_ops``.
 Note that this assumes a DSA-unaware master driver, which is the norm.
 
-Hardware manufacturers are strongly discouraged to do this, but some tagging
-protocols might not provide source port information on RX for all packets, but
-e.g. only for control traffic (link-local PDUs). In this case, by implementing
-the ``filter`` method of ``struct dsa_device_ops``, the tagger might select
-which packets are to be redirected on RX towards the virtual DSA user network
-interfaces, and which are to be left in the DSA master's RX data path.
-
-It might also happen (although silicon vendors are strongly discouraged to
-produce hardware like this) that a tagging protocol splits the switch-specific
-information into a header portion and a tail portion, therefore not falling
-cleanly into any of the above 3 categories. DSA does not support this
-configuration.
-
 Master network devices
 ----------------------
 
-- 
2.25.1

