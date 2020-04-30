Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF8761C026A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727057AbgD3Q0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:26:20 -0400
Received: from mail-eopbgr60079.outbound.protection.outlook.com ([40.107.6.79]:10070
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726336AbgD3Q0T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:26:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZml3v0HV/pYfoLjy535QrezNlFy4WpQzjWtesl9oCliWhNw5/4a2uXWm2AXKQSgl8jdaU8jxZPMr3gw1onIB8yKFhZy6BDrTLm7cA+iBZZwfnNAobyGW85EbJw0nYeDMGc3vWKKne/f6pPQ46Fj4mcc52bCdW+0aL0cB1FrRdTRyTWANxlR+z/HdoES+4n9/RAruQdwUcBFgEYiFz8/vAKE2oBjhOpt8Nu0yk5RZ8XAo5yvqrHlNTRxbQd595FJbkmzhTpFNYVWLbkI1LeOiRrCs/SQUMOkNCNjn7UqZRr5MdtKQMXCwkUJnRHzucm5wqEGnPSBAN414lGIL/39lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/Mh6domjzP9GRVOuySKOG8mJUyRZmz7j4kBNk6Ytlo=;
 b=O8vnbGNlwPpu0ZqPN9zK7yPTfNjCFxTaa3x8FLQ3Y1ZgPje8c4C64ojTA9Qbg6tv/xt44TeBZFu8IENfsWfgVHlKBKsLuDoB0IP38nF8O6rJM3KDhAhpd4ACIAh7k4yjHrVQwRpbucUhr189U6JZjqTHwZhcGA25jeLMY74NN8jQjW+WbqmF50w+7eIsDPdjqvlAuVFoeQhcqrlNqcmainfXwt3MP0mvU79ZhHyEbEKuE/2QF7kEZyDRe3rk7Kp6DLQcTXLK7xMmJo1UIPcuAEaGQV8cNmPhmzvGPymI7ZvHT81J8krHnoN+cjUVeNZsyk39uAdLKASNIWh7mCRArA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J/Mh6domjzP9GRVOuySKOG8mJUyRZmz7j4kBNk6Ytlo=;
 b=mkTP804uO6rUXsEpb5sHXThK+5Q1IjbG/XfjOaERBP42TS2qibxbLW2bqa7V2aIxq8I4RZXdiK/GP2DAEx0F8o4+JFmB9SvH92OzW3Du5n/GrdSir8yJX0UyuQpUQuzaYJPQ7ZWbTCQN3GLUmdfy6P9/IdgdQPtc6WhxAKKrLzA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5376.eurprd05.prod.outlook.com (2603:10a6:803:a4::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19; Thu, 30 Apr
 2020 16:26:15 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 16:26:15 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net V2 0/7] Mellanox, mlx5 fixes 2020-04-29
Date:   Thu, 30 Apr 2020 09:25:44 -0700
Message-Id: <20200430162551.14997-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0070.namprd02.prod.outlook.com
 (2603:10b6:a03:54::47) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR02CA0070.namprd02.prod.outlook.com (2603:10b6:a03:54::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Thu, 30 Apr 2020 16:26:14 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 254e5eda-1e33-4ee6-89ee-08d7ed23345f
X-MS-TrafficTypeDiagnostic: VI1PR05MB5376:|VI1PR05MB5376:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5376F238F804C0BD7DC1112EBEAA0@VI1PR05MB5376.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: su5ENrDRL8XhAdaHlhAa4vw6q4sAtBiiykzOtoDWWolo67XxSxFqSj6xzwyLx/6EvlZIOI9ix3qYAqVaCTV3hV2Ys9LUZIuCnAB3ecQxea+kFGNV6MnQH8yz48+MNMWSpnraGjnyjSGjvjmco2Ubyvjy+x8+HqOWrey8K+VgP23TuoKltn5bo9EbQ8MVh5GlcR4yzrYl5eGZ5pBAGpZ+YfAsnpX8HdkDuHFErcyCmkZjFvNjf/w+ya0ho61CyFwvCiRiZHupilHpG0Vt4g3BY2O3rQSo51PR9xuj/30KB4qLXhpqclkDqhIr6RpcyWyoPrpb7EbQ/Z8QCZ1A5Gbv7wnZRkZ0q9YTGxc6LXZQtmdhHeWmVTW45lUhXCIOatpCA8kKbVcraBDVCj2toS6+ELfbXApS07iQOC4ovjY2Lvg3Vse/04vZ+wBT5AkvWcvO4i3sH7eMORJF05pOsdAEzgTDyG7g6lJpbrb9yfTYN2FfLsn1ZRmD6gy0zss2U3+4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(136003)(39860400002)(346002)(8936002)(6916009)(107886003)(36756003)(4326008)(66476007)(6486002)(8676002)(66556008)(66946007)(2906002)(26005)(6512007)(1076003)(316002)(956004)(6506007)(86362001)(6666004)(52116002)(2616005)(5660300002)(186003)(16526019)(478600001)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: qQLx4FA4oSNfjBn1jFRb7yfURSaRQlzgi21YFI67Zx/m3Hob5bi5o8H+L/n+dCuzCW56IbEc0FmujNprjST2iWbYUv8BsNXgIBEyMe48/GFC4T4krvyXXyEgIv5klrHz3aHFYfpX4VrEnW+burxL/joefDuxs0HjhKLmTnBgxhwo6pT1AQD9e9BGFpPcDHvpBTaf7eyestkQFcXXS7QrmkWouIz9lN8wS3o5u6ww9MD63X02oiOcrN9yPkXTKMPy7Q45/3VEjjwAdxj69ZnSp5cJZ2V5otZ3ZBZ3vAzWn1PULTCZ7LviWMt6a/3abL2Crc6hQsr4kp1155dLIH+/x3VMPj+kIf1i+hi2w47oPTd3SbVR8bVWginJa0ttkkEE7KfvwJL/hVEE5/7LR2yEuVCGGp3Pdvw3ezbnFCeXaQZnsdx050GvCECfw5nyRTyDYVVepVpsRphGS2YVBrwb91Q+hqD98l0Ygz/DjzgvI3+idhKzX9seKoJDjSok+uilnvJEbMFbRqVLG248dAAWAZF/rukLiGchyam6/EGDNL978m3YTX7jqMY3UJnlINrLHUq0FkD7AxBvbWaTIXI68kGIDVmv813pvJhtad5QqDAfBo1v7+PUfSC4xbldO+JYaPBzRiUtAIsL0QPRSHtXz8EFGH6YcgY/w4dEh99+WO89SYxMZNbh48tf74hD5DtYD66BuXTcNwUi4Z9ZgXo7Wm7VYoF+NqH+IpBecOCO9nqd+3J3rwzV5moHleam7yM4TSS/XWFy7/f6ZEXI5vtEbwrtXENp7LpXC3Ij5T259ZM=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 254e5eda-1e33-4ee6-89ee-08d7ed23345f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 16:26:15.6618
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KQNqfd0/LtazEBtRvCi47hJH89rxNT6vq7nqBYokoCqxs0dJR28EKK41S6siGTthuhE6w/j01PRgUxnE5cCM1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

v2:
 - Dropped the ktls patch, Tariq has to check if it is fixable in the stack

For -stable v4.12
 ('net/mlx5: Fix forced completion access non initialized command entry')
 ('net/mlx5: Fix command entry leak in Internal Error State')

For -stable v5.4
 ('net/mlx5: DR, On creation set CQ's arm_db member to right value')
 
For -stable v5.6
 ('net/mlx5e: Fix q counters on uplink representors')

Thanks,
Saeed.

---
The following changes since commit 30724ccbfc8325cade4a2d36cd1f75b06341d9eb:

  Merge branch 'wireguard-fixes' (2020-04-29 14:23:05 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-04-29

for you to fetch changes up to 67b38de646894c9a94fe4d6d17719e70cc6028eb:

  net/mlx5e: Fix q counters on uplink representors (2020-04-30 09:20:33 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-04-29

----------------------------------------------------------------
Erez Shitrit (1):
      net/mlx5: DR, On creation set CQ's arm_db member to right value

Moshe Shemesh (2):
      net/mlx5: Fix forced completion access non initialized command entry
      net/mlx5: Fix command entry leak in Internal Error State

Parav Pandit (3):
      net/mlx5: E-switch, Fix error unwinding flow for steering init failure
      net/mlx5: E-switch, Fix printing wrong error value
      net/mlx5: E-switch, Fix mutex init order

Roi Dayan (1):
      net/mlx5e: Fix q counters on uplink representors

 drivers/net/ethernet/mellanox/mlx5/core/cmd.c          |  6 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c       |  9 ++-------
 .../net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 18 +++++++++---------
 .../net/ethernet/mellanox/mlx5/core/steering/dr_send.c | 14 +++++++++++++-
 4 files changed, 29 insertions(+), 18 deletions(-)
