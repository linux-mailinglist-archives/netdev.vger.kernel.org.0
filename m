Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8782D2306BD
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 11:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728440AbgG1Joe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 05:44:34 -0400
Received: from mail-eopbgr10075.outbound.protection.outlook.com ([40.107.1.75]:30084
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728320AbgG1Joe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 05:44:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R9NKM+iudVvkGGsVZ7hJsm7nK58mP0XWVdscfTqRg70qMpiWuW8qrglaNxHsh1bRVvAc4BfB8eihDeiJAiHh0fHpFSRK2KCRH0C4T6DSmF0EKK2/XYv5pRrzj24bOXCe6tZ+Tu0vypDPjzMGac7Xx2WzrB8VhhujJdji2+60MJg7ZYdUPapanw4DpB+7pD0MyWBi2tLlwq0Xfz2U6E0KeEiFIpmcXMXbYkmWt5EJVcaqka38axYvJ2idtjJavrQKbRbvya5Q23H/sbJpDKB7Xv5xjh5iUSBKjZfDS1uW8B4mpzGx6UW+lMDyzE4oScsZskEAVjsDBiWezLiIQONtUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6QEyarEBJwXjpFIlGG6p36JhfV4TXmdAL9OUr6zoNM=;
 b=GxqWEfiL6ggPnK9+Rv0JGDYd/vGK9M/xqWLEjcUGTiGc7dnzocEEvAy+fpzv9qum8lBOJEFQDOyql6T9wLI3KkUZ3IbhY0RygAjnU6UpMKWEGAYeTe+VWKa/45Ngx7YTDWJfzkv3AoAZmHhaw1A4Ochh0yAkuUM5aC70jA/66hGD9sgmHrpFQDdgllyhY1Rn/UuPbV+9MFrlYHWwbrqJk0vouzUO6ApwrGcN+tPIEkyv/q740T6oHxc7x7YdhvdD+ljDrbBz5HcxyqKFNgEPfiLv86nZuWuNooON6CWGe4s5vvy7o5nKDbhaTZkQJh3kG5bNNfZhzdfJbJZBT5k0CQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z6QEyarEBJwXjpFIlGG6p36JhfV4TXmdAL9OUr6zoNM=;
 b=I8iG8O4jAX9M2zyny9/WMXxvz0x6JoGWu2DjtaodIo76ysIQfDgQvJQ9UIlkvNSCc8gNHxDXHKD5KnbRvNtorN9Fi6pvskIgqOsctOqhA/7Rqf3bXz/LbZ0xttaXxMfrVSPhdXVWhO4oVo+h4AXev6icBi5dBmQAaSADmnLz/bo=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7117.eurprd05.prod.outlook.com (2603:10a6:800:178::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.23; Tue, 28 Jul
 2020 09:44:28 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::508a:d074:ad3a:3529%5]) with mapi id 15.20.3216.034; Tue, 28 Jul 2020
 09:44:28 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/13] mlx5 updates 2020-07-28
Date:   Tue, 28 Jul 2020 02:43:58 -0700
Message-Id: <20200728094411.116386-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR04CA0018.namprd04.prod.outlook.com
 (2603:10b6:a03:217::23) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR04CA0018.namprd04.prod.outlook.com (2603:10b6:a03:217::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.21 via Frontend Transport; Tue, 28 Jul 2020 09:44:27 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2bdecdb1-8b2c-414b-6299-08d832dad201
X-MS-TrafficTypeDiagnostic: VI1PR05MB7117:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB7117E000AC36D22E545DA5BCBE730@VI1PR05MB7117.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zw6XYHpX/IbZ0kxulzI1MUBEf5mfLlL484KhVFqvXVqubGez5SZTxQ62OrAOmFdPpQo0OSMP4ee7eg5nOyZbSRVTCe6Khy0sGfHBacTggQUOsBAp1s8SE4L9YNqUlFRl5+XhN2mV2F7LEefc5hjyG1upJULwlIdqW7XYMJIp8F37ccT6S61l2Dv0R0jNqny32jeAl5qtMqJaG6R/FW4GOn6+7ECgrG29FDYAPBpXb3ab7sw/SWJ153evSszl93uFiiMtC/XszIBpVWtbq0wNptvblfToMiNLGsozIubaVg7M3/5SSVPYX9LLzj6nrNiJqKSJRpZnpiCus0wxxYJ91PA9Cj9h6auvlKxKc5ldCmn/D+nS2FRVlfX0M00vinyH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(136003)(396003)(39860400002)(346002)(366004)(2906002)(83380400001)(8676002)(26005)(2616005)(5660300002)(186003)(6512007)(16526019)(52116002)(4326008)(8936002)(956004)(66476007)(107886003)(6486002)(66556008)(6506007)(6666004)(15650500001)(110136005)(66946007)(36756003)(478600001)(316002)(1076003)(86362001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kmkI2nOT11GFnl28ltjJ56fWEcpuCnuBIOEV8scaooRzjAhRmG9JAZWUdAEsCfkm5884a5TR6OTLcNhNn8lqC0FM5lxsONtoOSCIa7QfVSRnPl/yCmi0hbtYpKuefb290YvafQmFrh7acMbSImyLya4louFXj+17HV8/UiJUoeAxy3YHTvazy0paE2FPndAO0sElBg0My7/tL92Z/JIubJYVW2C8xecF75NQUEvnIvyc9dExYhXPM2jimClGj3g4YgJwn25eItG+Lxh+KbB8LTHcmiEhiqFUj/zCJvmSUh7B2CYjKmaurtGQPnjo7hT8Y41Mye3CD6K7cDNi6vQIBgdyIvcexgRAaLOHrUj4NXRX1JSMOaZc/JwrWKHkG7T7H+y2OJXrh/G89iBVwUytCcEfAhym5a9XIpBCxDUOQrX6acC/Z4JMtZax4qZFD8t28RBFDpB0zjhD+m7tsVGVMIJIhxbSNHzfuLJ5auNlCDk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bdecdb1-8b2c-414b-6299-08d832dad201
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2020 09:44:28.3180
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FRjEKvvlSxfzO4taOvasx9fMxsirk1Nk/Ch+CUdQmVjidh+TjneY1NEmtMzvZ9kj9aElWFeDxcqPqAr2h9uheQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub,

This series contains small misc updates to mlx5 driver.

Note that the pci relaxed ordering patch is now much smaller and 
without the driver private knob by following the discussion conclusions 
on the previous patch to only use the pcie_relaxed_ordering_enabled()
kernel helper, and setpci to disable it as a chicken bit.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 5e619d73e6797ed9f2554a1bf996d52d8c91ca50:

  net/mlx4: Use fallthrough pseudo-keyword (2020-07-27 13:14:10 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-07-28

for you to fetch changes up to 22f9d2f4ee810e6442185ba7ecab37e24de1b413:

  net/mlx5: drop unnecessary list_empty (2020-07-28 02:37:57 -0700)

----------------------------------------------------------------
mlx5-updates-2020-07-28

Misc and small update to mlx5 driver:

1) Aya adds PCIe relaxed ordering support for mlx5 netdev queues.
2) Eran Refactors pages data base to be per vf/function to speedup
   unload time.
3) Parav changes eswitch steering initialization to account for
   tota_vports rather than for only active vports and
   Link non uplink representors to PCI device, for uniform naming scheme.

4) Tariq, trivial RX code improvements and missing inidirect calls
   wrappers.

5) Small cleanup patches

----------------------------------------------------------------
Alex Vesker (1):
      net/mlx5: DR, Reduce print level for matcher print

Avihu Hagag (1):
      net/mlx5: Add function ID to reclaim pages debug log

Aya Levin (1):
      net/mlx5e: Add support for PCI relaxed ordering

Eran Ben Elisha (1):
      net/mlx5: Hold pages RB tree per VF

Gustavo A. R. Silva (1):
      net/mlx5: Use fallthrough pseudo-keyword

Julia Lawall (1):
      net/mlx5: drop unnecessary list_empty

Parav Pandit (4):
      net/mlx5: E-switch, Consider maximum vf vports for steering init
      net/mlx5: E-switch, Reuse total_vports and avoid duplicate nvports
      net/mlx5: E-switch, Use eswitch total_vports
      net/mlx5e: Link non uplink representors to PCI device

Tariq Toukan (3):
      net/mlx5e: RX, Re-work initializaiton of RX function pointers
      net/mlx5e: Move exposure of datapath function to txrx header
      net/mlx5e: Use indirect call wrappers for RX post WQEs functions

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  55 ++------
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  30 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/en/xdp.c   |   5 +-
 .../net/ethernet/mellanox/mlx5/core/en/xsk/setup.c |   1 +
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |   1 -
 .../mellanox/mlx5/core/en_accel/ipsec_rxtx.h       |   1 -
 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   2 +-
 .../net/ethernet/mellanox/mlx5/core/en_common.c    |  12 +-
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  55 +-------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   6 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    | 109 +++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   1 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  35 ++---
 .../net/ethernet/mellanox/mlx5/core/fpga/conn.c    |   4 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/ipoib/ipoib.h  |   2 +-
 .../ethernet/mellanox/mlx5/core/ipoib/ipoib_vlan.c |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   8 +-
 .../net/ethernet/mellanox/mlx5/core/pagealloc.c    | 145 +++++++++++++++------
 .../mellanox/mlx5/core/steering/dr_matcher.c       |  15 +--
 .../ethernet/mellanox/mlx5/core/steering/dr_rule.c |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c    |   2 +-
 include/linux/mlx5/driver.h                        |   2 +-
 26 files changed, 302 insertions(+), 213 deletions(-)
