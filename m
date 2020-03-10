Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9E0717EE16
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbgCJBnJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:43:09 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:6078
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726284AbgCJBnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Mar 2020 21:43:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FVfbJ1RhJ0rPVgGz4UiFPrnG3svpI7QK3WCRqquXl3UT+0W9SgejKGtWf77xtHpyzhxvXqYyT1dcKUtez6rtlR0uztnVNvZO9FbakhIzt3a0QCGhiwEkgFVcJBslGB/FbPhuu8KM9Wi49oDsVfKGoxlkizUwY03RmgZhLOHN6aeBV0vqmuG48QjqfR0eZwJ1e7kAmX7TQFufDvhV3N7tLTkwboClcukc6g89DOmafhzMQ+C3T8kKYjcl6fwstUcl7scAZnQTuY+7/GFyFPQZK3YEu5pktNHU3Cul++UuaZ/YlPYK5Qv19peq9YRxygZCYP80Ht6mRjGK5BxQozzAGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKmFpx4LNLb5p9Ko+7gWghMQqXZcAOHX6hK+/90G06U=;
 b=Yd1N2LrxyJS/TlHYKGZe4J4EuP50K2IWh4EYsGMeY+fKNyCdVvVKP+Ak03GWuMWz4Sc75OvG0Uy9lex9xYBgSvG88vPzlM+m6UsUiEVJye8FXzKJLgo2H8z2b+k2z8KsYC3It60ZH5lMl8/Yf7ecS4X9MbfcT8zvb8WFciqxi8YHgoM1WMRgv/wFcDs8xMNYjxm/sM47kVIjrdbJbCaq+B0/lk42z+5i6Dvg0xwUVgPf1AtqYYJ4jsByRUVn3MQtGrgtnE6gN7ViJ4V5pHhdS4bSRot8t2S5v09P2mV2C86nZhDJjTS/GB+vuNgSghvOM2kfjuT27FAI3aNV6ffonw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKmFpx4LNLb5p9Ko+7gWghMQqXZcAOHX6hK+/90G06U=;
 b=sK0q6Iuf1B55cfYUFKyDiAHMj38XU7IpEZChgSRkdu2a5j4edyP7efi98wY89WQ9Te/AU6LQ4CO6BmGm6L2rcds4WkBHR7ZZ+zWL4T7yzK+HxdUqziwTuU7d4iXiNhoghguVeCSrEIMZKBa0fsAZu3ikb2A1m/gdt1EMhGIqrrI=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1SPR01MB333.eurprd05.prod.outlook.com (52.134.27.161) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Tue, 10 Mar 2020 01:43:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 01:43:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/11] Mellanox, mlx5 updates 2020-03-09
Date:   Mon,  9 Mar 2020 18:42:35 -0700
Message-Id: <20200310014246.30830-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0068.namprd08.prod.outlook.com
 (2603:10b6:a03:117::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR08CA0068.namprd08.prod.outlook.com (2603:10b6:a03:117::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.15 via Frontend Transport; Tue, 10 Mar 2020 01:43:02 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 12251011-20b9-48e9-ceea-08d7c4945fcb
X-MS-TrafficTypeDiagnostic: VI1SPR01MB333:|VI1SPR01MB333:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1SPR01MB333692A76C18588F65CAAE6BEFF0@VI1SPR01MB333.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 033857D0BD
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(366004)(346002)(199004)(189003)(86362001)(316002)(8676002)(956004)(5660300002)(2616005)(6506007)(81156014)(52116002)(8936002)(26005)(478600001)(81166006)(2906002)(16526019)(186003)(66556008)(66476007)(66946007)(107886003)(1076003)(4326008)(36756003)(6486002)(6512007)(15650500001)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1SPR01MB333;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Hd2ipMHEqLgYOBiZl6FMWdwK7N4TAW/sQVP03K9gDC3b/1SGW+XstXeiEDBm8rceFltx+Grhvp1Y3XfNnSbABoKCcUZBDzmqsBYhptHbtrB8ZIbdxcLXlsq8eexT94cyY+KXw1lJpxhxEGBeSIm0MCrsyWjVkLDcESflXlY44LjrMmSEDD56tNhsxWBXFVkv6bmEOM09BugrERfQU4IQSV0rnEVCP1Uy+IVrnULIJKZIfYVQxdEMNNAcsZ/zLkRG1HR1J8VM49Fy/v7gpE6QuZZo0nfvt/27BkLuF2WwMUJQDGfhz4XHsTSGr/aN/gMIEQL6grW7Q9tLllEVaGDrkXladPNCzvaG2BON5EcYDf5wVtsqQ0dUAWv6X9gw0X2252mi8zCuz9No62FiFqqqKiCwi7FT1jlhEzsD7b7AXqU7RwwRQFXjxZlz00avc6p+kzoXBxeIBnEz6/dcSLOYZBpdXwPzYUWo32So3PHufRKgaHShpYvxnuyxWRkZJFT2epzu1tsferfhy386ZN+Y4yr0seZCxyqun6L1qeAfK+0=
X-MS-Exchange-AntiSpam-MessageData: Xsa27ipDkLOdkQ52eSTjWHe+WNGlXS076/jyyMCodRiOBefgUhJgVEzwGwIV9NfZUoM12NGz35VKA2XzoerxOcFp9VZaDpTw8d54K3HGl0r9q9C5CG3SLbELUc0LXeCStbCj7BRz/vW/4D4+wJndXw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 12251011-20b9-48e9-ceea-08d7c4945fcb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2020 01:43:03.9749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SvmOggSK6YMFrDmoULtm2TWzgSkaCc4EER/uH/WpuXZ1/hpeY/0zk+oRC1YVen7AMAp0yOqSiFEf588ZLCrYIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1SPR01MB333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates and cleanups to mlx5 drivers.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Thanks,
Saeed.

---

The following changes since commit a70ed9d8ecf395ca7d15c2d13782cc0055398ed5:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2020-03-09 16:58:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-03-09

for you to fetch changes up to b63293e759a1dd1d105f4c6c32d7ed150b6af8d2:

  net/mlx5e: Show/set Rx network flow classification rules on ul rep (2020-03-09 16:58:49 -0700)

----------------------------------------------------------------
mlx5-updates-2020-03-09

This series provides updates to mlx5 driver:

1) Use vport metadata matching only when mandatory
2) Introduce root flow table and ethtool steering for uplink representors
3) Expose port speed via FW when link modes are not available
3) Misc cleanups

----------------------------------------------------------------
Dan Carpenter (1):
      net/mlx5e: Fix an IS_ERR() vs NULL check

Eli Cohen (1):
      net/mlx5: Verify goto chain offload support

Majd Dibbiny (1):
      net/mlx5: E-Switch, Use vport metadata matching only when mandatory

Mark Bloch (2):
      net/mlx5: Expose port speed when possible
      net/mlx5: Tidy up and fix reverse christmas ordring

Parav Pandit (1):
      net/mlx5: E-switch, make query inline mode a static function

Paul Blakey (1):
      net/mlx5: Allocate smaller size tables for ft offload

Saeed Mahameed (1):
      net/mlx5e: Introduce root ft concept for representors netdevs

Vlad Buslov (3):
      net/mlx5e: Show/set Rx flow indir table and RSS hash key on ul rep
      net/mlx5e: Init ethtool steering for representors
      net/mlx5e: Show/set Rx network flow classification rules on ul rep

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |   6 +
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  37 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 122 ++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  65 +++++++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   1 -
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  90 ++++++++-------
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   4 +-
 9 files changed, 202 insertions(+), 129 deletions(-)
