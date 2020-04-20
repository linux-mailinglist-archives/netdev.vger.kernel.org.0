Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A58F1B1850
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbgDTVW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:22:56 -0400
Received: from mail-eopbgr30067.outbound.protection.outlook.com ([40.107.3.67]:27996
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgDTVW4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:22:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8Nd4uH+d5YnqBiAZPUI2/cUrHbHm3JEyw78/udFs0rfVjZlfkgvQLWGk/72Tg9FeSXpFNxeVpmgomtySi0+tEZIiXeok7aKJrTQKvX30TWCTDpobmYdSf/zfO0axc5FGMCB6YidVaebc04ItLTBtAmyl2D4uMSPGRWu+87qmrtXtAgHMEEtN3tIpskuWbORZ7zWERQ5p5i9/SV4CRS59wBcHl2p95Y4yjZyODKf537F7Wj3WHz4yyV6XPmmZoGWYYw1key+w8iJnt1I48hp5NCCLEWUiIZUFB0memHqPUmIr3oZ19V3twhuI7TD5i0wwvTbsEODWjsDJ7/gt0ji8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gyH5Dw+Rr3xpqPZuJIjEuC2oCfwiM9t7vWOW0lK0/Q=;
 b=SkbbNhjBrxijYwHOm/h9xwmg3D/McIvqDWsoKcon/KK23cMn5PkCgg98ACzUqoRn4VtrPXWutCxBNN74D50UtOepiDGZqbsHNRGbBYZE7Qavx4L40RCo8Tk9zMQA6xyZE+ORGE57ujmSHZ3Nn6r7KHKRjY3WjUCRq8isjuuoFX7JdWlKZoelU1OrTs37wkhcq6MtYtlrYqgoFViQkxF+FhxNWspPvS1M+HcxifE5bOYob4Iz06UmqYyYm1fKmPvuL5qD59b3bl78dXG5JwDuVQZnQ1LZxh/i/uZ2Ea78gMkAnaAgFq62bia8I+JK68Or5g44PqVVva0yFVG8knA+dQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0gyH5Dw+Rr3xpqPZuJIjEuC2oCfwiM9t7vWOW0lK0/Q=;
 b=lGVDbcZu43uKKpJKQu0p9X5Kjy914kzGACAxim19wPcdFR98n6ULORMGuAebUdzaZF+PRBTO1/uFeGD22TIpBx2u+InIq67nTmWf3nvc1a1ASHkTTr3J7BPc9XJP1/R/7UsGl6sJQamsNTiK7BCW0KQjTIqW7ik2r12MxFRgXMw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:22:52 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:22:52 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/10] Mellanox, mlx5 updates 2020-04-20
Date:   Mon, 20 Apr 2020 14:22:13 -0700
Message-Id: <20200420212223.41574-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:22:50 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe226ea4-77bd-4ff7-25fc-08d7e570fba8
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6478030C42C9554717CDC060BED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(15650500001)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JRgs5D4/sPwN925K1y5n4dAXuTUhFCZJq52KSWqs1wGzWo6osvRcIQRWvWsd78oTc1ZGZfmQrZg6rTk60KV96Enpcu0Dhya/OfdiSp4LNxpLPa2AXW3hZyH3gOPG1VPuF+XZA0ihhiziZAidMvi0UlpiM8kQkcuM2pIas895MDAs20IVTRSLErKEJZRwiBJ4XzL9/9SM96Duv12qbtcJsLLSyPqZREgBprb2A6grw+KiJ4VkmDLPu5PIJ5rfifghw579nKoSouqRnkuEyBj16LsNcOeNv7NG8lcOSSH1y8EkRLsJKLtsXlkoJHm9t03qxB0PxgRKSVirhrRk8nnqQhjrtDmtDgjBMHRSExdhWwfgDvbmZQc8hYKVBQxdCSJGAgUynriCK8d9xBxQ/VnNXSFYuLQDOkU9fXdbGDcMjbrKJraPTwLlaes5gbJgwBhSV3xBohHVU1NNHHK4mWtgaHtOGaYqjWrpBEhd5lZropkqV+xDEsy+jhJmC+mh+iyb
X-MS-Exchange-AntiSpam-MessageData: 4ceADtYqKbmaNLOqwhw9yPzmOV6urnqHvR4DaM/YOv3ba0SG+zU/2agWJKZQVK3j5uwb+4PJF5g8sLMLgY5zr1j961P0KUNSNN5ug6m2BCN/OAI6khGhavFcuM1hs2SRA315ItA5e0/soo2Otwfolw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe226ea4-77bd-4ff7-25fc-08d7e570fba8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:22:51.9891
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ltoQdC3ko0H4ooRwVK819/S+RGv2/Hx9hCmlicUA0Xr+SKvZmq+OIekOF7QZQe1YHdF05+Xl3BpeuTbRV3+Fuw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series adds misc updates and cleanup to mlx5.

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit b66c9b8de22b666718c2fcb0ae84ce620f9b81c0:

  selftests: pmtu: implement IPIP, SIT and ip6tnl PMTU discovery tests (2020-04-20 12:08:06 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-04-20

for you to fetch changes up to 6533380dfd003ea7636cb5672f4f85124b56328b:

  net/mlx5: improve some comments (2020-04-20 14:20:21 -0700)

----------------------------------------------------------------
mlx5-updates-2020-04-20

This series includes misc updates and clean ups to mlx5 driver:

1) improve some comments from Hu Haowen.
2) Handles errors of netif_set_real_num_{tx,rx}_queues, from Maxim
3) IPsec and FPGA related code cleanup to prepare for ASIC devices
   IPsec offloads, from Raed
4) Allow partial mask for tunnel options, from Roi.

----------------------------------------------------------------
Hu Haowen (1):
      net/mlx5: improve some comments

Maxim Mikityanskiy (1):
      net/mlx5e: Handle errors from netif_set_real_num_{tx,rx}_queues

Parav Pandit (1):
      net/mlx5: Read embedded cpu bit only once

Raed Salem (5):
      net/mlx5: Use the correct IPsec capability function for FPGA ops
      net/mlx5e: en_accel, Add missing net/geneve.h include
      net/mlx5: Refactor mlx5_accel_esp_create_hw_context parameter list
      net/mlx5e: IPSec, Expose IPsec HW stat only for supporting HW
      net/mlx5: IPsec, Refactor SA handle creation and destruction

Roi Dayan (1):
      net/mlx5e: Allow partial data mask for tunnel options

Tariq Toukan (1):
      net/mlx5e: Set of completion request bit should not clear other adjacent bits

 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.c  | 19 +++--
 .../net/ethernet/mellanox/mlx5/core/accel/ipsec.h  |  8 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  2 +-
 .../mellanox/mlx5/core/en_accel/en_accel.h         |  2 +
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.c   | 87 +++++++++------------
 .../ethernet/mellanox/mlx5/core/en_accel/ipsec.h   | 25 ------
 .../mellanox/mlx5/core/en_accel/ipsec_stats.c      | 88 +++++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  | 59 ++++++++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.c | 29 ++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_stats.h |  2 +
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 32 +++++---
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   | 31 +++++++-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.h   | 18 ++++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  3 +-
 include/linux/mlx5/accel.h                         | 12 +++
 18 files changed, 242 insertions(+), 184 deletions(-)
