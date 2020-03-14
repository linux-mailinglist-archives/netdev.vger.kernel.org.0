Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B08851853BA
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbgCNBQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:16:46 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:20602
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726637AbgCNBQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:16:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWy7oVVS1MSsIYqGhMXv/6iDSycMuDR5HXBLzqdH32zSNR2q58H90Sqv3Fi1mrwSYY13XA6DhXf5F04wPJ90mnaJeWt+eJLQcNmlB/BlbD7qmwq88SW3v0Vb4TUA+UaHuXIAxm2qfHedAzYKq7UZGz26HGJs+UnWk+MVN5xzNP2vbhLO53Jlf38mPEJ88kipT+J7Vclm/Tnq+pujX8X/ddsPSHGxdbbg29Tmry1gsHj2SNT56d/8FN/ni6plyVeV2yShjShhpgk3ixq9lis5kOsIieCHce1IW3ZCuaOrpdQM6Uq38M46vI3Md7EmmGW55MD3A/PvJpFICaX0xWe6qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oK2CTXAOn4GcV4FcAkXjsh7ppt30gKdXJZCZmBaJ2dU=;
 b=XFzq5M7ndS/eUUWm/vjiABFynA1xVTUYpeEuiDgQarvUiliNQPLlAXBBGucEwX2cJ0Sh3Y36RxKb5BOSE5yX2gO4MbnMAtTNPD6b8ir5mr7TJiVKn442Pp8st7InAQgD8ju/5zOsPD4GU2qo5D93AOsSJ1rCR3UW6gTNc3XWr3rDTSuwHZ1YfTRtpLlvM+wZ8HthovWzjecwFgxGiK3mIQQNQv4zGX6+Z8tOaanghC4eG4W9I+vQSSZFBoTUltMftaPnDPpfCHaRELY4+x6ZoKcjHMxtpM1oXz8b4aSZJKfLN9KB/FbhG923nmw7m3kOawhwy13PoNw4hw3WCbAcHg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oK2CTXAOn4GcV4FcAkXjsh7ppt30gKdXJZCZmBaJ2dU=;
 b=c0dl0lv7t0KVrZ9wxI+eMrvJ1A31t0YxgruJDqAE/2UEA4RFpGLerHyqa82GwsD5DPQGcoOO/Qsg/Gfvr3cFJvuZVlPjgyvkDg1tgUV+3PqRdqs+Eaq7r9WXZaY7rJTfNlyzXrzXyRDFZ2pACOZme1TKial309IpzZj0NyL+HIY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:41 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:41 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/14] Mellanox, mlx5 updates 2020-03-13
Date:   Fri, 13 Mar 2020 18:16:08 -0700
Message-Id: <20200314011622.64939-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:39 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a593e69b-6ea3-4839-ef5e-08d7c7b559ec
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845D45C61E03EF0D72299E1BEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(15650500001)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HYYqeJ9VzrRKpzt6BLRBeWNhtnE6hTlT0uF+QPP0J1mIa7CELwjG/+IqhMcBJ+MXNS/RxcsA6rOKkYVvXkmO2cJVaww+NmGXxcMSn02osGcn44m9WvvQfgGHZXL2r97+2NaQdgH8RovvQx4pvVhYJYzNjUTi+kIoKX+s0K9y6lfsPftoYL5XTYr/7cltKPAallwFZDlKdOdJHgeJmwzsVvnE1RUMXfYbG1sXiOuUQ2MpNfM7zWm9+1OHI8nGJEzZzQYvHtDBp2kgGDeIlRxAlMGKPIJLlfETxC/GjRkc18B1frCZ6QPpp+GAK4crJbHQ2uiwm+oXTrwu52NmIZQkpAquAO5G4GBC2N9l32lftxWWWUQRWjMecNwNVGDZRKUKA9+VD+TBtWa1g9fkTd15pRsKgb7mYd6sJGJe8QUzG7RJS6eCMTMm3AIk4ioLeYIfdYQJdfrT8z8Au+oxlWkpmgXox9e4PW0bTCzsciKDPbRrOGElXgDxF1w0+VssSmjzLFSnAi1HhntPpIT2Av4IkpxnZMEilZaoKgtbzx0cKaU=
X-MS-Exchange-AntiSpam-MessageData: alR+Ri6J5N6j2z/HpagIyWxrtDfM2bsNTJXDtJio7RiCWE3lzuKKcC44LW3VDX7WflbVTK9VaDrbSgrG5vceNA6O8SncD+9sGWX+cP4tItWYYDVuwsyMXt+RLqmwPTn+TnX3xB1i7JobhYR7cu+01A==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a593e69b-6ea3-4839-ef5e-08d7c7b559ec
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:41.0960
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: R9z2gaq4GAZ3sM8sov/9QT2ZSaxuIy7bvyi3tCpbmfRhf2roMXlJtkFdvHyajm1yYw/9dzmww5OMHuMUL13tEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates to mlx5 driver
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 1d343579312311aa9875b34d5a921f5e2ec69f0a:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2020-03-12 22:34:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-03-13

for you to fetch changes up to bc1a02884a33f9d49cda0c77dc8eccebd6c5c0e5:

  net/mlx5: DR, Remove unneeded functions deceleration (2020-03-13 16:26:28 -0700)

----------------------------------------------------------------
mlx5-updates-2020-03-13

Misc update to mlx5 core and E-Switch driver:

1) Blue-Field, Update VF vports config when num of VFs changed

From Bodon, Various misc cleanups and refactoring
for vport enabling/disabling routines to allow them to be called
dynamically and not only on E-Switch load.

This will allow ECPF (ConnectX BlueField Smartnic) support for dynamic
num vf changes and dynamic vport creation and configuration as introduced
in "Update VF vports config when num of VFs changed" patch.

2) From Parav and Mark, trivial clean-ups.

3) Software steering support for flow table id as destination
and a clean-up patch to remove unnecessary function stubs, from Alex.

----------------------------------------------------------------
Alex Vesker (2):
      net/mlx5: DR, Add support for flow table id destination action
      net/mlx5: DR, Remove unneeded functions deceleration

Bodong Wang (8):
      net/mlx5: E-Switch, Remove redundant check of eswitch manager cap
      net/mlx5: E-Switch, Hold mutex when querying drop counter in legacy mode
      net/mlx5: E-Switch, Remove redundant warning when QoS enable failed
      net/mlx5: E-Switch, Prepare for vport enable/disable refactor
      net/mlx5: E-switch, Make vport setup/cleanup sequence symmetric
      net/mlx5: E-Switch, Introduce per vport configuration for eswitch modes
      net/mlx5: E-Switch, Update VF vports config when num of VFs changed
      net/mlx5: E-Switch, Refactor unload all reps per rep type

Mark Bloch (1):
      net/mlx5: Accept flow rules without match

Parav Pandit (3):
      net/mlx5: E-switch, Annotate termtbl_mutex mutex destroy
      net/mlx5: E-switch, Annotate esw state_lock mutex destroy
      net/mlx5: Avoid deriving mlx5_core_dev second time

 drivers/net/ethernet/mellanox/mlx5/core/en_arfs.c  |  15 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 245 ++++++++++++---------
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  11 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 237 ++++++--------------
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |   3 +-
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |   4 +
 .../mellanox/mlx5/core/steering/dr_action.c        |  18 ++
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  12 +
 .../ethernet/mellanox/mlx5/core/steering/mlx5dr.h  | 104 +--------
 10 files changed, 266 insertions(+), 386 deletions(-)
