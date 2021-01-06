Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 467102EBE4E
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 14:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbhAFNLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 08:11:20 -0500
Received: from mail-eopbgr150083.outbound.protection.outlook.com ([40.107.15.83]:6405
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726701AbhAFNLR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 08:11:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=InsAQxvlnRUn5xIyKhjaDfJ+aQuhlS3mU/uVMFJ2poTni2SY90uQjV74P0AN5smE/Evu8Amh8naHPGYfSMR9LWtmelgUVAnTWjabGyj2FnQRqsuwQDjsyM/kXArESn2uu0qIB2Gn5hwGNLQIQ2QcwT/NuF8+CFrEEu/wqWpoSMK71TcVKGfAFXWhCONK0ydmPH36yrHd8787vBUDJkxjDam1xsaMf6QoSm5Xj887c0Cd32km7eU2DQWTePf/JZlXf+NQtWm3eW3qnuvE1iVHTH+sfUDp/7IZq4nZ/8lC7P0kDocz7cOXhSrsS1jtxhjDDfPURCn91or303o5jcsloQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXvp3Qq0Z1jTd4IAfVLxEytoIeM5v4HA3aAI0e7zPpE=;
 b=Dwj+z2ExJW+VclJWH89r5jBPFo1P6N6wfFUTi0VUyNczg5bN42UpQZip46AQho3Z1nvP+eiEtj0md+89z9PjROS+9qESlCX/rUCFAqQ0xDc0aC6RajeLkXP/+guDCtMcEWArfLbko2MzcOWMMnXzi0pVcanrAP6pmrgOS9PnX+KoH41bzXos+8KWEbq4jK5itTOPyHeU+KVc74AzIb76kATA2v7jL2oRRcHY9zpUMJ69Xva8wu37EsQZlPs6ZSphYeFphM42uIsvPMw3mzo0+rh7aCcb1bldMZDuYRqM5nr2/APdFVwtEaBIqFQch0eely5MiTBzOBSnn4vZexNS/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXvp3Qq0Z1jTd4IAfVLxEytoIeM5v4HA3aAI0e7zPpE=;
 b=lA/6eZs8UOCHqOD1QRxF/x56xMI/KQSVvDaibE3D39rCNFd2347v9V2E9WodueJNz1lADR3eCFhZiouezJZgtHyr6hp/LuYKOFIfdjtkFPp/Yx22l/kBUD5FNJv7lLsRG+uWFqM2wujYq2EYl16YWEmY/e3mh7FI/iy5lSgOb+k=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com (2603:10a6:208:cd::23)
 by AM9PR05MB7858.eurprd05.prod.outlook.com (2603:10a6:20b:2c1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3721.21; Wed, 6 Jan
 2021 13:10:28 +0000
Received: from AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec]) by AM0PR05MB5010.eurprd05.prod.outlook.com
 ([fe80::f463:9a6:abe8:afec%5]) with mapi id 15.20.3742.006; Wed, 6 Jan 2021
 13:10:28 +0000
From:   Danielle Ratson <danieller@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, kuba@kernel.org,
        andrew@lunn.ch, mlxsw@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: [PATCH ethtool 5/5] man: Add man page for setting lanes parameter
Date:   Wed,  6 Jan 2021 15:10:06 +0200
Message-Id: <20210106131006.2110613-6-danieller@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210106131006.2110613-1-danieller@mellanox.com>
References: <20210106131006.2110613-1-danieller@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [37.142.13.130]
X-ClientProxiedBy: VI1PR06CA0138.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::31) To AM0PR05MB5010.eurprd05.prod.outlook.com
 (2603:10a6:208:cd::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by VI1PR06CA0138.eurprd06.prod.outlook.com (2603:10a6:803:a0::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 6 Jan 2021 13:10:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5371c4ee-b03c-40c9-19ff-08d8b2447021
X-MS-TrafficTypeDiagnostic: AM9PR05MB7858:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM9PR05MB7858D3817BD0367808E083F2D5D00@AM9PR05MB7858.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ieq6qNDTKh8XHMANcZPoE5JfCMYfZhjps3UxxMUh1z8pGSzICFMJfzAnH0hJz5pYKyp4AkwnR9JHke9whevXkS8dybN3XkrxxpnpG64q1nABpjMViuaqn9js+pO9hOqWLcb9EfMJ25hObu/PzSeO9OPhr2gKvxpQ+Md12PswOcOLvuV710vS6vbD8/IlKp1DvM3IeuaIvrLIZrcnrjH4l/5U9mQfbuWCRJldw0vVQbddSJXBuvNAjLj5XvnkcLus4Fivt2mBRrXO8Hfh9H9yTkHob1N2C7CWGzfFIaSUrKTlcsD+frPXrUXKT9AYoq2eXoiQsdnE8sg4dYFdPgxzBUqCjgY5QUXdGqkjyf0kukf4oK0uZPO0/Xc3WjHYBEvQnAQhi4FQnJQ0IqLRMpRHTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5010.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(346002)(136003)(396003)(8936002)(8676002)(4744005)(4326008)(66946007)(478600001)(1076003)(36756003)(6506007)(26005)(66556008)(956004)(5660300002)(6916009)(6666004)(16526019)(52116002)(316002)(6512007)(6486002)(83380400001)(2616005)(86362001)(66476007)(186003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kF4TP1onVOjkPUAGllmZCQ22yn7swdSyzmnoZs+zFyxdTk3aECMbFHC4M+JN?=
 =?us-ascii?Q?GaKSLEUIpFn7LzbK8ihj/BAJsuUNVrOA7fcn3zSP7ewEUtnCyj3zrJISNoU9?=
 =?us-ascii?Q?X0pw2RbrvlQLOyQWOKQRTU8prkkiU6EFCE3+unz4dAe4l8wZQc3kLv1B6XwA?=
 =?us-ascii?Q?3NZNNO5VRekqDXhWoxoSqGevr2SNgRgbT1rfO4KeP8jiwaZRxVZVv9COnitf?=
 =?us-ascii?Q?1JIVU20vXssagmi7tsEceDAqO9T34C6SwdKy4icPLDsgNxy3gJmwRsqjLtYs?=
 =?us-ascii?Q?oEPKIYqshgp1wCjNgLrT9in8IelYN82Qc1ROyR5jiabgMqMA12O45cCtbl+m?=
 =?us-ascii?Q?VSv1vjybZ3mCXcB3r1bq/FcO511ubwJ+Cgmo8uOeFXflOl4Dhnq35mT8g6LQ?=
 =?us-ascii?Q?l3hC+Epw8Irky5/OCMaU9R2uw5sTmRmPQ8zjLkyZi1gCu1vhcPQG2t+Mpb57?=
 =?us-ascii?Q?bEXwk05IB0b5CGXyHOnY3+BFfdyHBeHFXoYN09L0wrfXdYABUlJv8IZTDmze?=
 =?us-ascii?Q?O77616wzZu9vDUr+F5gXb98aaEjyCE4APpNfAY6yilFAvlPUfZLi0CGY5NdJ?=
 =?us-ascii?Q?f3ZP+mIpcTFW+8Okd75EJVHaQLg7eLJiW8sx3b5s0mcvO7N/rClvF5nDxS0p?=
 =?us-ascii?Q?JX6JU8TwL/EdLj9iAJqcv4K7wmRNUfl18yFlJYqTtMn5bZ5PtZKkvrTQQo0g?=
 =?us-ascii?Q?IpYppKT4t5I7z+sHW/0iw/BmOnZLruOzC/dolho1qLq70bc4NAHpTJRc0oOq?=
 =?us-ascii?Q?PDbhF4Ai+OUccK/DNKwO8c9EeeW8FLI3wvCMdUUGTdW2XCv5WnbfVVkEHChl?=
 =?us-ascii?Q?Q7sVeAhYLI/MVLDDiUY+bt4zbofvMhksJ2JppRJ4vAq31eLREc5qrM57PmRc?=
 =?us-ascii?Q?G3+m5SolBe9jtAM1Ukprcxxy4jlys2Gr0n7Fym/ElWgeNXx//A7Mcsc08qaD?=
 =?us-ascii?Q?0HgsV6lMSFAyhlwvMoz9yW2ylCblRmKI9YjDLMuAapTOx3+Nkh9UgHtQc6ge?=
 =?us-ascii?Q?y2By?=
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB5010.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2021 13:10:28.1173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-Network-Message-Id: 5371c4ee-b03c-40c9-19ff-08d8b2447021
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8CVtGy90ldHsvZg8FQTk1fyd6jWF5mNgAqcSJ3/27e1Chk9W1NfRbWFHChXS926RwhKS1L9Q7InA7RyApBjKVA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR05MB7858
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Lanes parameter was added for setting using ethtool.

Update the man page to include the new parameter.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
---
 ethtool.8.in | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/ethtool.8.in b/ethtool.8.in
index ba4e245..fe49b66 100644
--- a/ethtool.8.in
+++ b/ethtool.8.in
@@ -251,6 +251,7 @@ ethtool \- query or control network driver and hardware settings
 .B ethtool \-s
 .I devname
 .BN speed
+.BN lanes
 .B2 duplex half full
 .B4 port tp aui bnc mii fibre da
 .B3 mdix auto on off
@@ -685,6 +686,9 @@ Set speed in Mb/s.
 .B ethtool
 with just the device name as an argument will show you the supported device speeds.
 .TP
+.BI lanes \ N
+Set number of lanes.
+.TP
 .A2 duplex half full
 Sets full or half duplex mode.
 .TP
-- 
2.26.2

