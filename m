Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFF951B1881
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726757AbgDTVgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:36:45 -0400
Received: from mail-eopbgr40071.outbound.protection.outlook.com ([40.107.4.71]:25204
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726039AbgDTVgo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:36:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7hg3vLVCQeUTtMQe08VnCcOydO111UBasdVxZDgmGWYCqdLeFYV/T6m8T8zb3axlGD+qO0/OWeMBZ/ClBRuwFOsChQWq9dlmW2SkmwlbxrX2twdU3PaL7orCqpSK6XlVO6I095PEf+4h0XXdxeU1V3/aUkdVW5JXkocpy7sz5HzX3zFDjVtGei+05TLxriykxg3YiBP9btXdigFpZRgwijA509B8v6CLKPFppcpxZLJxpl+OJ2L0WobCIUUw7YaZUiRG3P1UsmeZzFK2G3QD/7uWEAyUU6rYYM23xWVIsE78Zx0F73G7hDyXeL8+o/zi84b7AoJfVK0IJPlBzIHEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FULtSzHqRPsLM/F9vF/GdEvkXb3/gucUVJnTcJFCdWM=;
 b=byctvRlpWswDmF6jBykkk26IuKbXhoFlXpROMOLjpNqRNc2+XjOKEUrrWQfcEyE28lKk67xEIrTih5/JVRfJ3hEz0Us2aN4ictkJ3evUrqJ+akV5uPUoa3k1gafg3tnA+ZhEY18GAqw88BKurxciAKeWucUCBK/8F8HITYcn/SrbTn7DZNA8XpR5F+i7bo+b9wfxe5/o5ymGf9auw1Ylhhv9hSqXzThz05/UehTdeLuqZn1imTPVZSUhr2wqtlSx+j+jp40yrHRbJgiFJJETYmRgjm1qlX3H1Tk6kG2YmcYGVkNA0Sw+KQqhHZM1RY3waHIKvZKYx32ZZt9+uZZb7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FULtSzHqRPsLM/F9vF/GdEvkXb3/gucUVJnTcJFCdWM=;
 b=NDpEV4N4K3QvBaf/SzEcaQLU2kLmgiJOOZqxB96a4JCwJBolYRM743htd4Rbl4ky4xyfZORwyF7c0gRFZcTrp4STHbNp3E25/YgxU1IQq3mINRG+XkDP53/NyMg1RdLJ54TzfjCkOUIWiPN+47Q5WCJIIFnIDTkuoeAA+EV6Ox8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5005.eurprd05.prod.outlook.com (2603:10a6:803:57::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:36:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:36:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-04-20
Date:   Mon, 20 Apr 2020 14:36:01 -0700
Message-Id: <20200420213606.44292-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 21:36:38 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6168090e-a430-4b6a-f44e-08d7e572e92f
X-MS-TrafficTypeDiagnostic: VI1PR05MB5005:|VI1PR05MB5005:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB50054D9FC56B095046F270BBBED40@VI1PR05MB5005.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(346002)(136003)(366004)(186003)(16526019)(86362001)(8676002)(6512007)(6486002)(26005)(316002)(81156014)(36756003)(8936002)(6506007)(478600001)(956004)(66946007)(2616005)(107886003)(4326008)(66476007)(66556008)(52116002)(2906002)(1076003)(6666004)(6916009)(5660300002)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y+o/fg7LDDY80NAylQLUwjp6Ul2UHrcmPp/zyMX7v3qP6mui5Lk2BBeX0rGlC36/Tqo074DyHiE+rDHBQapwsgqnDFmT1epwudnBrEbtuLgufVeFCqHr9sgsEKYSaJmTbcICjsIBiY2LztRo29HA4suZZvM0njxoC1PevwYdv9ggSh9vleZ0ski49aflY8tcijUwqz04IVlzMSvEv40XD9wtHS0eNV4QzBRv+1DilZ1h6dYF8GnFajuU0WWoFpz4gcSjv9dpJi3pCnmvWwdy3+QC7OjjWTZkf0dg3k4ACLB3+98DZErOhQMlWC77Gx7mk8TTtEGWKVmXGidBdKBCtJx/aTPr9CNNP/6FnnfZTDh2v+SjagqSUa7z5s7MhDZh2wTuMc1LWDN5yyvYcCOG/49Wws8DOhAaNjjKxyrEIFt0UzCy9V+uSZcGQQP+DIDjEEppyGkfmVRJs1DHmPviEyJ3IUl6ljMiNcbwYpSEdh7gLdsw5g8lZFw5LC6wSlXL
X-MS-Exchange-AntiSpam-MessageData: 8FQ/PmH5fNVYz4dhpRL8tCXmHPohO9PsA5tuG4gWoql6q5MpzmdmnT4GtPgNQgy84x/wMDLnMy0TIs6cw4XeKcZcsRwmOh8N0k6PxbC8HkaTnWQeP5INIwIFooLyfJRh6DzgnW1CNiEE1Vec01iLag==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6168090e-a430-4b6a-f44e-08d7e572e92f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:36:39.9469
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: howmBT7T9p7288Dqt0iQ0zKmWQk4+tGQsXwX809lGzJdx09JRJRN2aGuyK3psVzVqVyTNR7QpH316WF6AajEHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5005
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 1c30fbc76b8f0c07c92a8ca4cd7c456612e17eb5:

  team: fix hang in team_mode_get() (2020-04-20 13:03:44 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-04-20

for you to fetch changes up to dcdf4ce0ff4ba206fc362e149c8ae81d6a2f849c:

  net/mlx5e: Get the latest values from counters in switchdev mode (2020-04-20 14:30:22 -0700)

----------------------------------------------------------------
mlx5-fixes-2020-04-20

----------------------------------------------------------------
Maxim Mikityanskiy (1):
      net/mlx5e: Don't trigger IRQ multiple times on XSK wakeup to avoid WQ overruns

Niklas Schnelle (1):
      net/mlx5: Fix failing fw tracer allocation on s390

Paul Blakey (1):
      net/mlx5: CT: Change idr to xarray to protect parallel tuple id allocation

Saeed Mahameed (1):
      net/mlx5: Kconfig: convert imply usage to weak dependency

Zhu Yanjun (1):
      net/mlx5e: Get the latest values from counters in switchdev mode

 drivers/net/ethernet/mellanox/mlx5/core/Kconfig    |  8 ++++----
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  6 +++---
 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 23 +++++++++++-----------
 .../net/ethernet/mellanox/mlx5/core/en/xsk/tx.c    |  3 +++
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  7 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  8 +++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c  |  6 +++++-
 8 files changed, 40 insertions(+), 24 deletions(-)
