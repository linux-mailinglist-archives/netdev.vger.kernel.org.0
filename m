Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B406F159C48
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727566AbgBKWfp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:35:45 -0500
Received: from mail-eopbgr130042.outbound.protection.outlook.com ([40.107.13.42]:49622
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727041AbgBKWfo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:35:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V0Qx/oKnFohknloi/b88R4g0aDZ7/9prFoBuiEkkyX77ARvVafyXK1xW5C+honzoYp1q2fW32G1YRU+7L16SmgsAUxD4oRRBKPuVuByzmqs6DGW4YWW7ibQjDEh4yHmn0ORbY/LNBRU2MBL+abd8xN0Btszz0qIfL3NZIW7hRA3OgRipZhwnBxRFa6eC0aRYqHGcbaNfRTOj6gTiWOCV9msh4PRXEJHoRcAHTCVRKGlAn13eAp8zAXqO1BNzBmE1v0FC50RivdlVzjXHk7TYck62ReD3PmeufQD6bm7xSkmH5VytcfKWdyapyNfnlcbPT2cdCb6dyRd6nk782xytag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCyhlKYdjA4ePluy3X7IJhTSpF+NtoSw2d+QhWFP01E=;
 b=nia5sd/ce+4t6FqtUTId8AcIQaIqK1uCbtbH8+Ftlct3gT6x4X4dezCBj/ffJKVNUJySYmMkDrhRIZlANjuI7EeqWhegCnSm4zVWUpsFJtqjJER6tOza2sbxDapErNI5oNVnUr5Dh7evwSjKzqM8TUxVvdILPQzWkVDzpCLhRs4k6d8e8ukbtyRjuHhrTkxH5V0l01ntJ8b1Ru5CXNZT7wiWwN132nbQpFQbULNoG9M4OZ7gNrhpi0VNhRuKqmeX4r/+VHLgMnOD6tZ1ErcGX4ZpY3c8W2xboyrPlVzEb1hHVNFc0sJf+sxt2jfChaWt2AvQvmX0jMTletT/BWxSmw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vCyhlKYdjA4ePluy3X7IJhTSpF+NtoSw2d+QhWFP01E=;
 b=hHrekyZzzofIrRt5Pk5obcPvl4P+V/Cktsmr12tHdIaxY0rkVku4A2iUtE+EnI/dKQWvKpHQrg890r/qebKDYRTg/nyZA7GOG5a3hoAWB8wOifd+ULC/xlpP56/hGxMEX/58HiagJS8o/FUgpy8qXCZ5a5K6vU9WYGTsD1xK/eo=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4383.eurprd05.prod.outlook.com (52.133.14.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.23; Tue, 11 Feb 2020 22:35:37 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:35:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next V3 00/13] Mellanox, mlx5 updates 2020-01-24
Date:   Tue, 11 Feb 2020 14:32:41 -0800
Message-Id: <20200211223254.101641-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:35:36 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fcd547f8-4ead-4268-fdda-08d7af42b749
X-MS-TrafficTypeDiagnostic: VI1PR05MB4383:|VI1PR05MB4383:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4383BD754DE221B7805B383FBE180@VI1PR05MB4383.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(136003)(39860400002)(346002)(189003)(199004)(15650500001)(110136005)(36756003)(5660300002)(478600001)(6666004)(81156014)(6512007)(1076003)(8936002)(2616005)(8676002)(81166006)(956004)(2906002)(6506007)(316002)(4326008)(66476007)(66556008)(52116002)(107886003)(6486002)(86362001)(66946007)(16526019)(26005)(186003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4383;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Q0kcsa+W7s3cSsUW7Zj8UZKU31Iulc1x+iPte7lZDcnVhvVhzOW+UigiITbQIwmvpqmZYBlncmJy5AM2H8DKAkhuqGFzrCk65uqDDW38mavuY/QBawYBa3fraZ3gze/YksKU4yNyxyIk5Y+D0ubPLkF9tEgfGT0XBsT1kI4gjPqM7QVismWu4ftZN0nzN8GuPcg8GFnvHjDcYQogKD9JE2tWXf67XVjKla4LFYE4U1WEwfS1y++SO2Dv+8k7X7K83L+hVqZ44sLFzFuJsxta9ei8Vk90zbKBN9zyot3TEcNadiBEOX6lcWJh/5DsMxuLrpQ+deWgMQkI85vj3hxQ4NSA9Zv35McfCD6iAbbhdOTW1Fbw/buLb9iOfYfUVuNZ+IkbQK7NXjIPI2OqJpxKk86ffVcOulPl+eTzZf3zDA+0Uwk8CQeJigIMzERea4DsPk8baCn5JNSFthKexOqJG50XC+YAG1+9ff+cojtU4ITJoJkNULnARCiEdCUu6s/8V22Kf0ixDzT3hQv7FlnJOiqjN43r0gT3BhxHoBf0aL8=
X-MS-Exchange-AntiSpam-MessageData: AcTX8cmvJWBudvecHy4OxCNRw6JrOZjom8PRdqeoRNyKHypBzZWfI3TXTASWt+U5PuKlA8hWTEG35ruGEFe9mgETtMpYTxEu2P4wvzv+EBPr6DxSBIngYAvhuz3H1TwHGc8Soj8aR0NpEYxag7CDrg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcd547f8-4ead-4268-fdda-08d7af42b749
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:35:37.5815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JIDh9IIMg89JmPmiWON1zWoHe9RucZ2F4OooTAFI7vhTvT2yK6THdAUij2X5mhqpHwxKswBR+xGiJCI2euJJeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4383
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds some updates to mlx5 driver
1) Devlink health dump support for both rx and tx health reporters.
2) FEC modes supports.
3) two misc small patches.

V3: 
 - Improve ethtool patch "FEC LLRS" commit message as requested by
   Andrew Lunn.
 - Since we've missed the last cycle, dropped two small fixes patches,
   as they should go to net now.

V2:
 - Remove "\n" from snprintf, happened due to rebase with a conflicting
   feature, Thanks Joe for spotting this.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Note about non-mlx5 change:
For the FEC link modes support, Aya added the define for
low latency Reed Solomon FEC as LLRS, in: include/uapi/linux/ethtool.h

Thanks,
Saeed.

---
The following changes since commit fdfa3a6778b194974df77b384cc71eb2e503639a:

  Merge tag 'scsi-misc' of git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi (2020-02-08 17:24:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-01-24

for you to fetch changes up to f71bd4fb494bd360abe6075240b654f4791df44e:

  net/mlx5: Remove a useless 'drain_workqueue()' call in 'mlx5e_ipsec_cleanup()' (2020-02-11 14:26:12 -0800)

----------------------------------------------------------------
mlx5-updates-2020-01-24

This series adds two moderate updates and some misc small patches to
mlx5 driver.

1) From Aya, Add the missing devlink health dump callbacks support for
both rx and tx health reporters.

First patch of the series is extending devlink API to set binary fmsg
data.

All others patches in the series are adding the mlx5 devlink health
callbacks support and the needed FW commands.

2) Also from Aya, Support for FEC modes based on 50G per lane links.
Part of this series, Aya adds one missing link mode define "FEC_LLRS"
to include/uapi/linux/ethtool.h.

3) From Joe, Use proper logging and tracing line terminations

4) From Christophe, Remove a useless 'drain_workqueue()'

----------------------------------------------------------------
Aya Levin (11):
      devlink: Force enclosing array on binary fmsg data
      net/mlx5: Add support for resource dump
      net/mlx5e: Gather reporters APIs together
      net/mlx5e: Support dump callback in TX reporter
      net/mlx5e: Support dump callback in RX reporter
      net/mlx5e: Set FEC to auto when configured mode is not supported
      net/mlx5e: Enforce setting of a single FEC mode
      net/mlx5e: Advertise globaly supported FEC modes
      net/mlxe5: Separate between FEC and current speed
      ethtool: Add support for low latency RS FEC
      net/mlx5e: Add support for FEC modes based on 50G per lane links

Christophe JAILLET (1):
      net/mlx5: Remove a useless 'drain_workqueue()' call in 'mlx5e_ipsec_cleanup()'

Joe Perches (1):
      mlx5: Use proper logging and tracing line terminations

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.c    | 286 +++++++++++++++++++++
 .../ethernet/mellanox/mlx5/core/diag/rsc_dump.h    |  58 +++++
 .../net/ethernet/mellanox/mlx5/core/en/health.c    | 107 +++++++-
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/port.c  | 253 ++++++++++--------
 drivers/net/ethernet/mellanox/mlx5/core/en/port.h  |   8 +-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 266 ++++++++++++++++---
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   | 181 ++++++++++---
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   |   1 -
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  71 ++---
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  12 +
 drivers/net/phy/phy-core.c                         |   2 +-
 include/linux/mlx5/driver.h                        |   1 +
 include/net/devlink.h                              |   5 +
 include/uapi/linux/ethtool.h                       |   4 +-
 net/core/devlink.c                                 |  94 ++++++-
 net/ethtool/common.c                               |   1 +
 net/ethtool/linkmodes.c                            |   1 +
 19 files changed, 1136 insertions(+), 225 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/diag/rsc_dump.h
