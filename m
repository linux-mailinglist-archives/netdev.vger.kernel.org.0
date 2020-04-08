Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 464E21A2C04
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 00:51:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDHWvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 18:51:51 -0400
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:45409
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbgDHWvv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Apr 2020 18:51:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNNxRJG3Qe6E+q561w7cdVvqAew+fUeWab1UCf7RyJopusxNqMzIX/cvgCOa0o1i/E6kHQJmiFlkQl+cOt39KHPd6uyOm8JP8uYsOwdsuHkAPQxoWWVtzWGMGrIMov2vaLas1zbXq9L8nGi0auVFTsOz9Ce7legfs3V+A7isBsQJXkxXFZTFDPBhGwvmSyiraI/qeEZYlDKi4nrWQ6cfupq3GDlm4KNdeSHcdIi6622beTSm4uTm51a0Rl7mrJH/L7Ak+fjSzub9qvjMcSwamjnaESHOu5ab/u86KG3PhsPuw1VUWenDAt6r/1HfwuqC78uWFuOh7ZyCFlOSK44/Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr/lYn2CCqfaMvJSIudkZNem4SRpMPktxJoiq+OQudc=;
 b=f3ziSJW3iCwtGGqJ//hS6ZkKFsGPRzumFtEoFSUCdSLdQFzgPsB5bgzaIBfnAv7JTwQQRL7NQYstdsRk+be3ulOi3QcDTkKKJGLMT5RhsxSqD8npdHfFuBQ7mekuOqZSVFCZUZYDzik0OA/QbAJ54gx+rUfaZBW1iE4suwNh/Fx7JAQBhINFVU5G7qLZMLxvS+0zt1JGeYcKqfiBJVfo4CPkstOTfGNfjHnJnl/E7Sup1AnNvFFaupdv9NjB4u1WJtrSaoYCrH+eMDsIbKszsolQcwUTGMNMKQHpzskVMQgZM6pM0OqbryTWGXB2rk2cBk4wruRPulWGoJYxgCATOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wr/lYn2CCqfaMvJSIudkZNem4SRpMPktxJoiq+OQudc=;
 b=QAHp/kQmQPWODUBltD1Q14xA4HBYFhHlMcChebRCJ6EGHxjFILtDFHgjBE31Eqns5bFYeanrw0F+xVAK8aqikdBA5/wOjrLNpiCK1JTp+5hWsErNH1bFcRAXNRgpvvMOpL0AHNxjzvEUlykVbvDnzHDbz5lb1jTFJ0rmOs2wwFQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6365.eurprd05.prod.outlook.com (2603:10a6:803:f3::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16; Wed, 8 Apr
 2020 22:51:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2878.021; Wed, 8 Apr 2020
 22:51:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/8] Mellanox, mlx5 fixes 2020-04-08
Date:   Wed,  8 Apr 2020 15:51:16 -0700
Message-Id: <20200408225124.883292-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0026.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::39) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0026.namprd06.prod.outlook.com (2603:10b6:a03:d4::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Wed, 8 Apr 2020 22:51:40 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a6607c51-168c-43d5-c56a-08d7dc0f678a
X-MS-TrafficTypeDiagnostic: VI1PR05MB6365:|VI1PR05MB6365:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6365EEDD8640810D06A3794ABEC00@VI1PR05MB6365.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-Forefront-PRVS: 0367A50BB1
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(136003)(376002)(39850400004)(366004)(396003)(16526019)(956004)(6486002)(26005)(316002)(478600001)(6916009)(4326008)(2616005)(107886003)(186003)(66946007)(5660300002)(8936002)(81156014)(36756003)(86362001)(8676002)(66476007)(1076003)(66556008)(6506007)(81166007)(6512007)(2906002)(52116002)(6666004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ena2bv4zpQvMFaNnyiYnsSQ9dwmZCGb1ymBdkZ13TnP8eFeLsENh3LVUd6MuQS32jiLzO66B8a/B/dEnbPI1i2FFVeNLLdu1lyr/zqHYSrldyskmWk8sN1k6u1Kbc9K77sIAUMMWySbX0ui011ZTu5wB+ekw4ATvehtnYB3UXeqUrt1vg3UUnCYCDVrXINt+LhOU/RUJLmHKkNArmxzMe/jDUE5MRk5fhzJ3ZGdvn9+UPK+xnJk5eem9+284zJJKCSwmnzqc6yYRVclwOcnbJCS3xSSRADFHM/K3lU/Yiycw1jKGSzvjZy++zLXlnppGeUkgcUiM8uqVxKQsPT/vPCRtbyVuABOyjrcsowR2YwAWkR0/3gWyioMowr5K9XtEcDGmwCIELnJqGbpzJbdPzqr2a+K2ek0IzRE6YexAyf3wXpYi8v/POjdP5KbcGayRCIAqvJf1vdfrkN2YZnmqhVsPo17/rYTpe0i3pDreZbL+rJkfm7cWKXhyCh+8cYpp
X-MS-Exchange-AntiSpam-MessageData: Fuwu/BarEjzHofXO3PH+1FZTk1Wa7Pd8I6wICz+Uhh29lHeMzCOvEWXOMNM0VlS2f0xuEBZBicSxI6mm67m0ySlfN78JzZbTU+oAher2iTMNTE9EcWc9rTclt8dBwF3KMW2RRvOX0RR59sQbKG51Xw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6607c51-168c-43d5-c56a-08d7dc0f678a
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2020 22:51:41.7991
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uSDS5hnrhoKdpajP1jDXppQ4mO4JVHoc8YnxTLf11eWiPKb8xsRdUEPsJj6fnzPbbHqU+KFnNZj9A9Y38HiDdw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6365
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v5.3
 ('net/mlx5: Fix frequent ioread PCI access during recovery')
 ('net/mlx5e: Add missing release firmware call')

For -stable v5.4
 ('net/mlx5e: Fix nest_level for vlan pop action')
 ('net/mlx5e: Fix pfnum in devlink port attribute')

Thanks,
Saeed.

---
The following changes since commit f691a25ce5e5e405156ad4091c8e660b2622b7ad:

  net/tls: fix const assignment warning (2020-04-08 14:34:02 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-04-08

for you to fetch changes up to 9808dd0a2aeebcb72239a3b082159b0186d9ac3d:

  net/mlx5e: CT: Use rhashtable's ct entries instead of a separate list (2020-04-08 15:46:54 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-04-08

----------------------------------------------------------------
Dmytro Linkin (1):
      net/mlx5e: Fix nest_level for vlan pop action

Eli Cohen (1):
      net/mlx5: Fix condition for termination table cleanup

Eran Ben Elisha (1):
      net/mlx5e: Add missing release firmware call

Moshe Shemesh (1):
      net/mlx5: Fix frequent ioread PCI access during recovery

Parav Pandit (2):
      net/mlx5e: Fix pfnum in devlink port attribute
      net/mlx5e: Fix devlink port netdev unregistration sequence

Paul Blakey (1):
      net/mlx5e: CT: Use rhashtable's ct entries instead of a separate list

Roi Dayan (1):
      net/mlx5e: Fix missing pedit action after ct clear action

 drivers/net/ethernet/mellanox/mlx5/core/devlink.c     |  5 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c    | 19 +++++++------------
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c     |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c      |  9 +++++----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c       |  8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h     |  1 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c    | 12 +++---------
 drivers/net/ethernet/mellanox/mlx5/core/health.c      |  2 +-
 8 files changed, 26 insertions(+), 32 deletions(-)
