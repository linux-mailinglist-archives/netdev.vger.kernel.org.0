Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67253172D97
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730266AbgB1ApS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:18 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730146AbgB1ApR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GaamEyfx23QmGOSW68C8l3Uzd08HX5s2Usm44T3Lyjd7biwVkXGhcad7XoCZXHscfCxQvlA/iqK0K7YGYaYGSZufrMJEs7CX7PXruuneNl/T+3zE+cVajyPDbY7d/62cXyhXagZ8GSM6GdM6Y5u/wDB6mwUsqm2UZk1HX3S9PRh4f3G5j2ypxpXxE1nXv332DhV9mO1LxaDO6Zmy3Q3Xt0GdltB5hGee65nC6fQUBA743Czp8UokWv1ZgFyMlwHjrW7uUArqiCynM6NZg7ZN8w5LsztYHLv5Y3bdc/AfyLP78f70ik7qeViOt249uEBTDHRjhMRNXlIOfBVs3Hmjqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KjW9rCccMGp5CNaT76e5v5H7suzKxFn+LCailreISI=;
 b=Dt/oDXqBXETN4MKXc10T1otQ0d5BkswXqLwYSW4EFg08gLYzNPPUfG2IYCg8tjtms4y19vDQcEqDeJ4Xk6yfiqpckRbJljKud3+2X0dr8m4nWFlmsHntkEwXYOHWJ1di0rEfo2MN32gE4I8uu/DUQfBEEhc4BzqUu8GbCj3TO49Pze/3TaHGz2CShZdp67r746GNR1Yzi4s5kzUCZA0lZ2QUoQNC7Nw5qOGSaE4hGRMVVn3oy7h27tkoCTyzI3xMmj7s1+XqTW6xlDnM+rLnY8CUt8PU7pl0tL2UBjYNMIOUewhX4PUPpk/KvKHuW7VJw0glnVr9pAv64mDrNQLLZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8KjW9rCccMGp5CNaT76e5v5H7suzKxFn+LCailreISI=;
 b=tPCms1iALFyfTSVe/cVwDhA6Vgf/HiXHZ+HYaLQ61Z/7sJSv/y5VnVbwgXq08ERs9xsaj9YqtBcWkVT7Sdcy3EtpERx9IiMOmzJuJtYy1UykZ3jP2qI4+jBsCaAljC+YKHy0wq3qh+u68YQDnyqdUQIf5JrM3B+676tQchOSYu4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:10 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/16] Mellanox, mlx5 updates 2020-02-27
Date:   Thu, 27 Feb 2020 16:44:30 -0800
Message-Id: <20200228004446.159497-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:09 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 407a59af-9a6e-4c49-31eb-08d7bbe776eb
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189456E259A152A57E463C7BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(6486002)(26005)(8676002)(6666004)(81166006)(15650500001)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ol9lw8TmpNkIoDrNrc/nSjbCGRFaC+7pPsbNmyzFLKBvb+5s/0LziC/fcZp0Em02GQgDChIchU1NM6o0LvSkbcaPCDHVLhq7rYn76PTf+ta7Nh365NogzjhnK7WMg3p246e8eJRR0hccegnN2eT3DQaxct9DaqCEgaymKvce2btsNDpUvXDVIDbM9wxhH6lZnzrvgNH4fSyx/XPUcORo+ibcjh3lQswY7IY+/0WbZvk1zuZCDafGFXINEZsyBHgYgogEcIX5WFKRNiBhY6mpQbkCD1cXjGiNStLTz+YZh+ibJ8aONf5Rxs1TbJPvuRlR0VIddCKgK68AH9260RU+nBCp0HL/tIg2OidZVzpIqLWOJreGjoCDb1XfnEDjBCIEfJpDsXSR+rMha8EVZASp31K51FUCmeoRQ40iVXAFki7psFb0meY8gjAIiU2U4SY7QepRxH/ejKVDCUGO7Dd+fFakVe7qXhn1sy2vW8zdrrOfkMPzt0XbUsj5N5kZSLLCZ+lvhN2BDARe32xzNsGaFzHlhYBqPeE43NlyiuBYoU=
X-MS-Exchange-AntiSpam-MessageData: pTBLsRZy7RY9ORy77UbcwsVRnl3hVGMnae2oznI+FZYV1HlZjqEG2PG4ZTzdRM18Vo9oXejg6wXfyfhbmEfqvjPLnzmL5PuuHKH/rXe/QwNBB8MHgpwIn8Lv1nlvHK+yY6E2nfwOuHYTDqFTHtasqQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 407a59af-9a6e-4c49-31eb-08d7bbe776eb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:10.5348
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Yq7/b/iwui6L8hy4/KzaLQwb7AMuw7AXSvnd7DI5/2wDtPbLOLaVJFEN4ZmJ1AQmSAau/syXrCBJvWkujrifww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series includes mlx5 misc updates and cleanups.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 37e1244a79fd248ed31281259b478bc945b7bd4b:

  WAN: Replace zero-length array with flexible-array member (2020-02-27 12:06:55 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-02-27

for you to fetch changes up to bc1d75fa79860ec9d065cd3de041f86811d48563:

  net/mlx5e: Remove redundant comment about goto slow path (2020-02-27 16:40:42 -0800)

----------------------------------------------------------------
mlx5-updates-2020-02-27

mlx5 misc updates and minor cleanups:

1) Use per vport tables for mirroring
2) Improve log messages for SW steering (DR)
3) Add devlink fdb_large_groups parameter
4) E-Switch, Allow goto earlier chain
5) Don't allow forwarding between uplink representors
6) Add support for devlink-port in non-representors mode
7) Minor misc cleanups

----------------------------------------------------------------
Eli Cohen (4):
      net/mlx5: Eswitch, avoid redundant mask
      net/mlx5e: Eswitch, Use per vport tables for mirroring
      net/mlx5e: Remove unused argument from parse_tc_pedit_action()
      net/mlx5e: Reduce number of arguments in slow path handling

Erez Shitrit (1):
      net/mlx5: DR, Improve log messages

Hamdan Igbaria (1):
      net/mlx5: DR, Change matcher priority parameter type

Jianbo Liu (2):
      net/mlx5: Change the name of steering mode param id
      net/mlx5e: Add devlink fdb_large_groups parameter

Roi Dayan (5):
      net/mlx5: E-Switch, Allow goto earlier chain if FW supports it
      net/mlx5e: Use netdev_warn() for errors for added prefix
      net/mlx5e: Use netdev_warn() instead of pr_err() for errors
      net/mlx5e: Use NL_SET_ERR_MSG_MOD() extack for errors
      net/mlx5e: Remove redundant comment about goto slow path

Tonghao Zhang (1):
      net/mlx5e: Don't allow forwarding between uplink

Vladyslav Tarasiuk (2):
      net/mlx5e: Rename representor get devlink port function
      net/mlx5e: Add support for devlink-port in non-representors mode

 Documentation/networking/devlink/mlx5.rst          |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |  40 +++-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.h  |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/devlink.c   |  38 ++++
 .../net/ethernet/mellanox/mlx5/core/en/devlink.h   |  15 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  11 ++
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  38 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 115 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |  22 +++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  14 ++
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 208 ++++++++++++++++++++-
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |  20 +-
 .../mellanox/mlx5/core/eswitch_offloads_chains.h   |   2 +
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  11 ++
 .../mellanox/mlx5/core/steering/dr_action.c        |  10 +-
 .../mellanox/mlx5/core/steering/dr_domain.c        |  17 +-
 .../mellanox/mlx5/core/steering/dr_icm_pool.c      |   2 +-
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  12 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |  18 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_send.c |  16 +-
 .../ethernet/mellanox/mlx5/core/steering/dr_ste.c  |   2 +-
 .../mellanox/mlx5/core/steering/dr_table.c         |   8 +-
 .../mellanox/mlx5/core/steering/dr_types.h         |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   2 +-
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  |   4 +-
 include/linux/mlx5/fs.h                            |   1 +
 30 files changed, 519 insertions(+), 129 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/devlink.h
