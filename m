Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B876E197570
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 09:17:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbgC3HRY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 03:17:24 -0400
Received: from mail-eopbgr60043.outbound.protection.outlook.com ([40.107.6.43]:55440
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729373AbgC3HRY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Mar 2020 03:17:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g2r3CZOs6Du5oATL2BcePG7o7n2M6mkYwO+AJTSdOGCJwJszkKwxhyY+x3zazBCJCA0OCn0yRWho8iCpOyl9JSMOzNMnWN0K22/6QWMvX93EBpeiOcm81hnf5rqCJKuNMolFOJ0GXhP4E5D92Y/e8SlMHG0SaCPN1A/6IZRylf1U5m623hhgUCXP4zHl8nVYLQ3VDVkULrbEM+VsRjG0/pB8EyH/wX26G9UvwXLl36WmYH4MLlMq2eWlJfsYpxF1rykney3Rs14CbHLD8nceRBBx643XI1FcJV4YguozYosK04y3AtUgAB7afnepGSssHE3jtKKrr54FK/Agf7sMOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsoZOVZarRkngkYf/Hjuni14jGwobpXIYR8ZgUc/wB4=;
 b=Ob8MRaC6QL3sdGCie4Rf0H0qu9PEY53+1e4hHf3zYv29NTj42mg+qwHBn4bnnlKGkYfhqiRUA0l7PE2HHbaIawZU7y/GmL6H4r8Ah3P+qDuyy8lybcPEOqXUgbDY+w1hyZT6wqK0eCbmzeOQ5NrupG9zPbV8VliRm1NkrMYCSx+7OPQhnvCoUwToCnZ9Iz3rWgS6a8Px5nvDiDFKcI/KEBUapiHXaCZAfuuGhSFBqBoogWcHn7XSazc2XhW8i2oGOjVVLejqXLJEWl2oKKnOuTX92sD8IKGvJNqmuYink9qZ1VePmDins/48t8bxFpi6dnHkxW7LtbSqFrCVU8YWxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xsoZOVZarRkngkYf/Hjuni14jGwobpXIYR8ZgUc/wB4=;
 b=gdposR9njiyy/emOzl7qtt0YgNAb1+MP79ayAoDID68oUi0QlTT2OPGpzHsieTuqPT1yCP/CI2qhRxy3QvcC2jlagfMgWOSlUcPLkZoEUsz5xX8saXYC1P9y1/Ep+S2A/NTZ1Znw7R40szVZOWTsSsoE0RC3Fblkv9u0tUD8Mo8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4989.eurprd05.prod.outlook.com (20.177.52.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.20; Mon, 30 Mar 2020 07:17:19 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2856.019; Mon, 30 Mar 2020
 07:17:19 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 0/4] Mellanox, mlx5 updates-2020-03-29
Date:   Mon, 30 Mar 2020 00:16:51 -0700
Message-Id: <20200330071655.169823-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Mon, 30 Mar 2020 07:17:17 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8aedc188-594e-4b58-034c-08d7d47a61cf
X-MS-TrafficTypeDiagnostic: VI1PR05MB4989:|VI1PR05MB4989:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB49894FE2238327D998DED876BECB0@VI1PR05MB4989.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0358535363
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(5660300002)(6512007)(8676002)(107886003)(478600001)(81156014)(66476007)(86362001)(66556008)(4326008)(6486002)(66946007)(6506007)(16526019)(6666004)(52116002)(1076003)(8936002)(81166006)(186003)(26005)(2906002)(316002)(956004)(2616005)(15650500001)(36756003)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z9qC9aGLhAWOyl8lUQlKAk8jgOIRgmPk+ZAzxI8rYrVyjKVytaQGkSlDU3Dd3+ybmZRT/Rc2kjrEwyhH2uA4NLRz/iNHy8/O3IrJ9BlNeKEUu6LE9trtgD8a5KHrfZbBJk0K8TPotK8z0WCjJdOI2nUVJ/Xi9xY4tVqIoykgpS7Q/ciH2acbsqPnL7c57z0wd2HA/31NB3xJzLJrqFQfm/lb3SWcbwKez/n0SueqC/mJZkm47DoJvnIew0Ng1wthofkzFr8L+Yku3BnTOuZtjzkniN3CJy3ApTu71ndR3XkCdFSus/jSldumDx7v1dd3zlE2MDddyDKPHRz9cWzRHRqZIDguJY98KYdD8thawR+/wSKmDm/ZWZUfev9C/0WxShf7w8YKdxSjJEYy/Xh/OWOSJEx7I566+qwNKlmikHNCcrsI035PdA4QmOH/L2IUznmWOdp0brNcErd/pbYAv2tvZFgfjGB2TgWh95Aq2hR3NejGhRs1+Jsl3vIIfW+I
X-MS-Exchange-AntiSpam-MessageData: sWP7eKo7rURWmLa8ejzQFt+eFYWM3EUkpiCwrd8umSsJyJOzMt4boy8wuPhg4MpTAOU+7e02FtbF/2kSMaTaGjNrrfZWQPtMkVAS2KEhnc42ExL4+CXukUuTn3d/j9G2MI/y0vT3c2sYIa5re9IhkQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aedc188-594e-4b58-034c-08d7d47a61cf
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2020 07:17:19.0708
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gzIUGMnrHjQr1rXUzCunvwBIW2hdsrGW1LBmbJ2IJnHQuweDEQAQ/nd4it/sq5Pu0iCmTe3rgLT+Vt0h1lm/Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4989
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This is a very short series which includes some leftover stuff that I
had to take off my hands before merge window.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Please note that the series starts with a merge of mlx5-next branch,
to resolve and avoid dependency with rdma tree.

Thanks,
Saeed.

---
The following changes since commit e999a7343da734f24643fcfcfa821e214126480f:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux (2020-03-29 23:42:11 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-03-29

for you to fetch changes up to 07c264ab8e6c76efbc2eb06839f8dcd9fd0c3ebd:

  net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support (2020-03-29 23:42:27 -0700)

----------------------------------------------------------------
mlx5-updates-2020-03-29

1) mlx5 core level updates for mkey APIs + migrate some code to mlx5_ib

2) Use a separate work queue for fib event handling

3) Move new eswitch chains files to a new directory, to prepare for
upcoming E-Switch and offloads features.

4) Support indr block setup (TC_SETUP_FT) in Flow Table mode.

----------------------------------------------------------------
Mark Zhang (1):
      net/mlx5: Use a separate work queue for fib event handling

Saeed Mahameed (1):
      net/mlx5: E-Switch: Move eswitch chains to a new directory

wenxu (2):
      net/mlx5e: refactor indr setup block
      net/mlx5e: add mlx5e_rep_indr_setup_ft_cb support

 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 93 +++++++++++++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  2 +-
 .../net/ethernet/mellanox/mlx5/core/esw/Makefile   |  2 +
 .../{eswitch_offloads_chains.c => esw/chains.c}    |  2 +-
 .../{eswitch_offloads_chains.h => esw/chains.h}    |  2 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   | 14 +++-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.h   |  1 +
 10 files changed, 91 insertions(+), 31 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/esw/Makefile
 rename drivers/net/ethernet/mellanox/mlx5/core/{eswitch_offloads_chains.c => esw/chains.c} (99%)
 rename drivers/net/ethernet/mellanox/mlx5/core/{eswitch_offloads_chains.h => esw/chains.h} (98%)
