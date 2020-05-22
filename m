Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C74881DF34A
	for <lists+netdev@lfdr.de>; Sat, 23 May 2020 01:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731273AbgEVXwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 19:52:14 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:35520
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726546AbgEVXwN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 19:52:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b/ywNTI7sOmjzH3yey5qUwCnBfVwKZACWcoqRju28RIXDbBXj9lbluqViiAU6vNX3T/Wv38yUOF/i9l0e/rU0FAzyX8tVMD+7Rwcdx8WBcDfLit5NZYIa1gtwKRm0ZnQOClszbfqtLcmNC7PCmcpBUVAgdCGvJuV/QpopO5UJrJjSjZUUGXJM5dczqwF8ypFHJLs3KaER0JuoPUexi8Fuuo6xGIVoe94+Xz8MmpM0t8MGgvH7oGhu/wnkTzCNwOqun8W3hxyp0EOt3mOS875jCkHYZfruwNHSkVMWRZcWQ5FOgerJrASiU99Nyh6c/+o1RGA5LTpeYjgcE2PglQwBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtJsFiUx98eJ+5SeaOwJAixtQVmjmmEtwHHre6Rjndo=;
 b=eR/hk14ExeY0obX/EZziQtdYfhTiZm3TELEbwCjk5HJ+ymHmgdiYpjSg8JFKRYhx8ZSAeh1nlpZmwi814DyZ2lRMy17DPgsxGJHOzBrWTZMmkamiCAW+aid644mgP4dl7xW3iAWpumwonW09yfplDbQEikxzD1OVLPDdMBmsXjRrVC+u/4mNnMziKhc+j/+ClMxnlbrhPoffAu31j6RknYrgm1ZF/7jiaPWFAud2NF8KUwun45qArlpJ6BXpa4PE8dI2JZ+A8IgzR6jbtmmtW3hU31+5Ed9M2pGgBqHUXGpFOW0im0gRTrFz9el3texuCAxKdnVt3tX/SFINwAFIvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RtJsFiUx98eJ+5SeaOwJAixtQVmjmmEtwHHre6Rjndo=;
 b=hc06iYyztETlplWPqZv1di78G4U6XUsv+6RgBa3gRDLBzoRloqGOtrp2l2wQa8CExSt/nD74d0z8wrKHptPFBdx+cFt8jOD0jEzGFsgtr7a0BGzi7T0m3//S5EPx1Ap+HWF+ahLZ794wRutRrsz7/hToQWoCHtX4eiDQAP/e2vA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4544.eurprd05.prod.outlook.com (2603:10a6:802:5e::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Fri, 22 May
 2020 23:52:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3021.026; Fri, 22 May 2020
 23:52:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/10] mlx5 updates 2020-05-22
Date:   Fri, 22 May 2020 16:51:38 -0700
Message-Id: <20200522235148.28987-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR10CA0015.namprd10.prod.outlook.com
 (2603:10b6:a03:255::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY3PR10CA0015.namprd10.prod.outlook.com (2603:10b6:a03:255::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.24 via Frontend Transport; Fri, 22 May 2020 23:52:07 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 948a3398-c01a-4de5-8061-08d7feab237b
X-MS-TrafficTypeDiagnostic: VI1PR05MB4544:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB45449F7EF6C510E9867DE6D8BEB40@VI1PR05MB4544.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 04111BAC64
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MIVuqOQq2VQYIIhdYrBgkHoTUpgOlS9bR/2dU/pyA+heSdB/8SbDN0R82weWgXNcxfmqF7kMXOt2ArZbBROpPP0vBGTOM+SyQH10sK3GBPr/wuoTiB4oBEQuVJvqkodBx4sUtatoi8UV20zZH2lspouNhSqCILkkysx0+RxInAbUtdCADXkOsPr8JK+qbbSG5I4Ye6oTQ3ZV5S+8J7iW6GtUkpoEn5UqGNcsPJ8R9ZHEi4qgrO5PmGBlKwqVhgk2XP+ngmEh9XnLadDtj58Zo1StY8vVtQ4uA6y1Np4q8HKyiWPy0R6wppmVGIkeNbNP+2g6o0tDJWn8SJxa5zjJNC3YIzXPbqqGwFJYsxeqMDlJkEEuKOvtv06/1xaFB1pm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(366004)(346002)(396003)(136003)(66476007)(956004)(6506007)(66556008)(2616005)(66946007)(107886003)(6512007)(1076003)(16526019)(478600001)(186003)(52116002)(26005)(4326008)(6666004)(316002)(6486002)(86362001)(8676002)(36756003)(15650500001)(8936002)(2906002)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oMJ0EdYHHfeZKJgvsW1sPt5Zh6hJGOdP+tt/d4dcCUJqwQZEPclBhgTlERBuiWvdhYFxzBRffqQSm+MR7qQcOw1VfWfrhVw3vtWzJjN7lvS61nuBFfppbST6577xQek2SaudHeaZxEtn+XGzskIxVCTTi7CE8GTWh6hUsfCRqTlWL63TGZWri85FNnfI/LYLx3lLkOaKB4EQ3jhJdv6p2wzKd6iQ7Nldfa7cUWJH8bQ1sNG1usHQ2MezpF7+d1H327TguPTQLyrlNu5Xyd7DJjAKi/3gLjkG9ahnwjRVbnxA/3ZQQ86XnxXPNJolRboXUZZnfjnC7G6W/12CLZwNYzDZDDV8F2eWmA8a+TXTzoDVzDCwPibJSjvuA+egEGkpUYjwm1RTf8hKSnMDfsl8rmiyTNR9SdbO0If7Ixw5JghLDn2lZuITIjaGGoveICmerxy5Hl9o9xBvdqoqFfdVu5/ZGq/YkKYU7wgpIounVmk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 948a3398-c01a-4de5-8061-08d7feab237b
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2020 23:52:08.6562
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Acglaf0DK8WIk9EWNmKWMigMuoHkPw9FnYOwNzQdtHkh8fOp1QZHGaYKT/+kCyjeqDrK4uHx6UPoChwsQxJc0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4544
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub

This series adds misc updates to mlx5 driver.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 593532668f635d19d207510e0fbb5c2250f56b6f:

  Revert "net: mvneta: speed down the PHY, if WoL used, to save energy" (2020-05-22 16:09:42 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-05-22

for you to fetch changes up to 582234b465edfa12835b20477c0aa2bc91a02e18:

  net/mlx5e: Support pedit on mpls over UDP decap (2020-05-22 16:46:23 -0700)

----------------------------------------------------------------
mlx5-updates-2020-05-22

This series includes two updates and one cleanup patch

1) Tang Bim, clean-up with IS_ERR() usage

2) Vlad introduces a new mlx5 kconfig flag for TC support

   This is required due to the high volume of current and upcoming
   development in the eswitch and representors areas where some of the
   feature are TC based such as the downstream patches of MPLSoUDP and
   the following representor bonding support for VF live migration and
   uplink representor dynamic loading.
   For this Vlad kept TC specific code in tc.c and rep/tc.c and
   organized non TC code in representors specific files.

3) Eli Cohen adds support for MPLS over UPD encap and decap TC offloads.

----------------------------------------------------------------
Eli Cohen (5):
      net: Add netif_is_bareudp() API to identify bareudp devices
      net/mlx5e: Add support for hw encapsulation of MPLS over UDP
      net/mlx5e: Allow to match on mpls parameters
      net/mlx5e: Add support for hw decapsulation of MPLS over UDP
      net/mlx5e: Support pedit on mpls over UDP decap

Tang Bin (1):
      net/mlx5e: Use IS_ERR() to check and simplify code

Vlad Buslov (4):
      net/mlx5e: Extract TC-specific code from en_rep.c to rep/tc.c
      net/mlx5e: Extract neigh-specific code from en_rep.c to rep/neigh.c
      net/mlx5e: Move TC-specific code from en_main.c to en_tc.c
      net/mlx5e: Introduce kconfig var for TC support

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  17 +-
 drivers/net/ethernet/mellanox/mlx5/core/Makefile   |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.c | 368 +++++++++
 .../net/ethernet/mellanox/mlx5/core/en/rep/neigh.h |  34 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    | 711 +++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.h    |  81 ++
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    |  10 +-
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.h    |   2 +
 .../mellanox/mlx5/core/en/tc_tun_mplsoudp.c        | 137 ++++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  41 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 887 +--------------------
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.h   |  21 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 509 +++++++-----
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.h    |  58 +-
 .../net/ethernet/mellanox/mlx5/core/esw/chains.h   |  19 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |   3 +
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   6 +
 .../net/ethernet/mellanox/mlx5/core/lib/port_tun.c |   4 +-
 include/net/bareudp.h                              |   7 +
 21 files changed, 1816 insertions(+), 1121 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/neigh.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/rep/tc.h
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_mplsoudp.c
