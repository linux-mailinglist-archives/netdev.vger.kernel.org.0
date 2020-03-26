Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD4C1938B3
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 07:38:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726336AbgCZGic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 02:38:32 -0400
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:59543
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726014AbgCZGic (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 02:38:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d/J7TyJQXS8Zr/+kncVr/TBlyfVZ51xnBiW0BD/D1lowJ8BKltlv/D97X5Fwt4hLSl32ZZs+igZH1HlaTf1hMW3lUq6GfpZImYJatW5LxuIZkL2TN8mwvFtI6V5VHhe/plVQ5g1o15+nI9BOwEgrb3NEoOvouCqo4BwxJ1NQsZm6QQIggoayYQ4O4p1uMnjMbBqApsm/z9Y9473kyTOY0QVUbqm0YFEPnxbq7fwhLkJQ96073LsaaFanfycaUPcjBmn8FwF1zc7+/oKv9pWMs67ERW3JAurEEhBtUkU0L8x/7sk2iQ5bz3x4Ln1FEUiP3uKvEzxYSE2zD+36ldQ/FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeIwM51O/GkIGoOwaV9jJkcWjeVPhnziajy014h0qbg=;
 b=KjUxIX9eM/KdS9L9Tc42drFw69da1Ax2Iik9ni1ft+m8t9BpHHheTueYaqQehCgkkex6wBagO06I8wSAT5IfCra2HHyhGtL1FOKB0uzrv85Hwi7MFQPZZaw13HFmSAjOKH3vxZTgdLHsua2dWx4yTA58Hs3JtRHL0sm1FooOUX6Fp75pPQyM36+EmqOgprQPJV1eAOEfNEApnBOexPYJQeb6k0B0JeL9YJSLUZTJ4xewBbGsD8aP5RrTt7HkrZ9cH3q10TGB5U/qr2nbdi+rEqCPTEHywn0s2YO3Sld9/q6py4jpaGKLdgwOfBgWTy417ExHad7q5bZDlvMYpI1tyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aeIwM51O/GkIGoOwaV9jJkcWjeVPhnziajy014h0qbg=;
 b=b20LRGnbecsm87h6w+6BnfLb8vxX891yxm6CssDYMDV8WF5Da6W9nQkxqB929N7d3X7nlybxhyNOTg5mTOieKP9/G6MC4lqPF5WT7cvkJOlyo/H1B4RHBItTx0o2++b6JILGoltDldHF6AiyfokHE42PFVWl2e10Xow62Rnt+C0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6479.eurprd05.prod.outlook.com (20.179.25.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.23; Thu, 26 Mar 2020 06:38:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 06:38:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/16] Mellanox, mlx5 updates 2020-03-25
Date:   Wed, 25 Mar 2020 23:37:53 -0700
Message-Id: <20200326063809.139919-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR03CA0020.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::33) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR03CA0020.namprd03.prod.outlook.com (2603:10b6:a02:a8::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Thu, 26 Mar 2020 06:38:25 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f776f089-1d42-4cea-3d05-08d7d1504a55
X-MS-TrafficTypeDiagnostic: VI1PR05MB6479:|VI1PR05MB6479:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB64793ACFCC680F93A0B46E23BECF0@VI1PR05MB6479.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(478600001)(107886003)(52116002)(6512007)(4326008)(86362001)(6486002)(8936002)(54906003)(6506007)(15650500001)(36756003)(1076003)(81156014)(81166006)(2906002)(316002)(8676002)(6666004)(66946007)(186003)(16526019)(66556008)(66476007)(26005)(5660300002)(2616005)(956004)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3+WBRjy/vkO46W9mtcHTp96njrVf5p2l05Hj7nFIN78Gd8ZkwKZgrrejOxx7msy2rxc4BfOtJq9vbQGWLl+i0w7aZLa1SDepK9ndDimUd0O7Flc0c7x1ulr3JZtO7WV2udIDO0VgcRXUQlU+THOE1yrDQ3wFpjOWhqB6pXCe2iRAiBxyQz/iag4pagmmUS4fZoF7oBRGvyoaqrh1RJxSqcOIO1MGh46DXoZ1VoKjQvhJMy5Vmh4KYvAxxPeUietK45T30A/JrzDHWkgo3LBiu2gJPZ9xamN6zX43ZlvXVdoS2XRvMf8LrriTxPlYa5rtHWxWo6K+UhRJU6bY1qoYFCl2XN9YFvNQcVtM3ACcDu2fp5d204cVtt1jrh007AbwWtZq0kzNgix0mVIDukrXzUzoRZsXXw6iofej/g+ehfY6VtrPyJhfkXrMVZQ+OtMXDb3WipZGFFKyEEDsRJmHRADATmOfKEfhrDy93vDxKXUedVCZpdtxjdeBHimNmnHq
X-MS-Exchange-AntiSpam-MessageData: bQ2VDbJYQcFQ+qC/1zSQCIqsS2qfyFmyLEXgAjfhPAZCHaOTkjGokX5h56ow9SlFD2KHHy3V1itGd5PfBYrVaRSQPgJ3NfXsVppsu6X3NCXeVKBRst0zfvnlyJBPa7GWtpkFv9TI7nOb/qHkV9Nnqw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f776f089-1d42-4cea-3d05-08d7d1504a55
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 06:38:27.2892
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bDRe1w6vkeUKSsctinHgtATx66+gbRZb5xlyRic0ct7Q8Z5CXDBmE/ygNU40mTQST/+V9jwftOAxv4TEROdx9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6479
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series include mainly updates to mlx5 flow steering core and
E-Switch.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 29f3490ba9d2399d3d1b20c4aa74592d92bd4e11:

  net: use indirect call wrappers for skb_copy_datagram_iter() (2020-03-25 11:30:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-03-25

for you to fetch changes up to 8e0aa4bc959c98c14ed0aaee522d77ca52690189:

  net/mlx5: E-switch, Protect eswitch mode changes (2020-03-25 23:19:25 -0700)

----------------------------------------------------------------
mlx5-updates-2020-03-25

1) Cleanups from Dan Carpenter and wenxu.

2) Paul and Roi, Some minor updates and fixes to E-Switch to address
issues introduced in the previous reg_c0 updates series.

3) Eli Cohen simplifies and improves flow steering matching group searches
and flow table entries version management.

4) Parav Pandit, improves devlink eswitch mode changes thread safety.
By making devlink rely on driver for thread safety and introducing mlx5
eswitch mode change protection.

----------------------------------------------------------------
Dan Carpenter (1):
      net/mlx5e: Fix actions_match_supported() return

Eli Cohen (4):
      net/mlx5: Simplify matching group searches
      net/mlx5: Fix group version management
      net/mlx5: Avoid incrementing FTE version
      net/mlx5: Avoid group version scan when not necessary

Parav Pandit (6):
      net/mlx5: Simplify mlx5_register_device to return void
      net/mlx5: Simplify mlx5_unload_one() and its callers
      devlink: Rely on driver eswitch thread safety instead of devlink
      net/mlx5: Split eswitch mode check to different helper function
      net/mlx5: E-switch, Extend eswitch enable to handle num_vfs change
      net/mlx5: E-switch, Protect eswitch mode changes

Paul Blakey (2):
      net/mlx5: E-Switch, Enable restore table only if reg_c1 is supported
      net/mlx5: E-Switch, Enable chains only if regs loopback is enabled

Roi Dayan (2):
      net/mlx5: E-Switch, free flow_group_in after creating the restore table
      net/mlx5: E-Switch, Use correct type for chain, prio and level values

wenxu (1):
      net/mlx5e: remove duplicated check chain_index in mlx5e_rep_setup_ft_cb

 drivers/net/ethernet/mellanox/mlx5/core/dev.c      |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c  |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |   3 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 107 +++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  17 ++-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c | 143 ++++++++++++++++-----
 .../mellanox/mlx5/core/eswitch_offloads_chains.c   |  38 +++---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  59 ++++-----
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  24 +---
 .../net/ethernet/mellanox/mlx5/core/mlx5_core.h    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/sriov.c    |   3 +-
 net/core/devlink.c                                 |   3 +-
 13 files changed, 263 insertions(+), 147 deletions(-)
