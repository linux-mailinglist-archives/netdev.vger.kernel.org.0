Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAB35213293
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 06:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgGCEJI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 00:09:08 -0400
Received: from mail-eopbgr30041.outbound.protection.outlook.com ([40.107.3.41]:4299
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725294AbgGCEJI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jul 2020 00:09:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MnUE/fnaHHTvpkAwf6Lkc1nkYl48TB3NBU3k7GVUCqv+QqryoTELgyqguNcUTBuWcvvKMaf2ao3hrJedhtWXC+SEd2FpD6g53fDnHxDASy68HuduoBSXXXhRe3fWW9i+otOj+xddmhmKzQJi2Uyl36NUtca5KeO5YVNUv5PiP70DJZ4oNcsdqqp3dsw9JqNlnm5niFlVrFszyIYjNwa/b0Zqu7yXFZFgyNHkESpTgl1EY58pVfN/tr4PVfx8Z5Y1vemEdFPQTC+eOrSjUpEEydlIviKtvxEEAF5iHfbDO13FjDhApvx0VC6+SISiB2dIJ+kfQIa2yZtZdNYDblh5Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KgDSQZJWB4d8YlN6lD0h4yH63c21BImGF9O4noLynk=;
 b=G53FM2630tH/u9PbvETYTO7Q+u8++dfsY/2GRmC3ktrW2crB6weFp03HoRPsDSSZasisfMVPNRd+gsgJM9oHmgIJ4FoIDPXtPljdKK52DrvEynMIOv95Bj1nbnReiCtvBaXT37smTS5XyLtmChdGFA9aDXq2WVDx5J+Te3io3OyocsL3NucBhXvc/G0Abb6naVYeCNU4qhn52+WgDw5l5N4wI+hyAW9w1WHIa6vwHqACoWkPWAbGHu+Z7rQ+jw18LIoOW/MgrRAytnx/J+MdiH12vt+LcrJMJknUOH/UNTKnX6gz85fi33AppWc23LWVG6fRbSeaEasR1eJZ/OEhAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KgDSQZJWB4d8YlN6lD0h4yH63c21BImGF9O4noLynk=;
 b=SAby76iHiRBJBmANSeH+nA3V/5S3SdDdW++tbY48wobDKKbKOCpzl6g033tYyNlmX+n8qpmXJVzEiQ7tNwp49ZjiLyV6w54Ur5lfOkw/D056ziIaN0MJ8uwpRQ8auGtQd89nQIYamq9DBCnf5yjfZ21kPO7Vxd5DIJfPCFmgjzs=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5534.eurprd05.prod.outlook.com (2603:10a6:803:9c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Fri, 3 Jul
 2020 04:09:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.023; Fri, 3 Jul 2020
 04:09:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 00/12] mlx5 updates 2020-07-02
Date:   Thu,  2 Jul 2020 21:08:20 -0700
Message-Id: <20200703040832.670860-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42)
 To VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR01CA0065.prod.exchangelabs.com (2603:10b6:a03:94::42) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.24 via Frontend Transport; Fri, 3 Jul 2020 04:09:02 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5d51abb3-8dd5-4dc3-8eee-08d81f06d2b7
X-MS-TrafficTypeDiagnostic: VI1PR05MB5534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB553488372A7F6AFCF264304BBE6A0@VI1PR05MB5534.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 045315E1EE
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n+pOTjby6OcDY9WBvFatxfjD01p72v5M4TOP05uPQHVkgxallWeexW6rxsoER306H/pzdI74FlSeec9wMqvDNkxp1YLTEHYKKdeJkrafm16bZMm1iEBq+XxutvfUx+dFrxIdv5nYdmWFdcyP8rqlgiM+OmsyCZrU7rjXspLpQbnz8NouKRpBVowcqnbyO6Ze3RkR7/tBE52XsTuz0ASkIc4uvCnmj4vT2X4/KbQhfBi/y49E9IQpKEvtuTWs+xlKHcB8tS1ewrPAl7/0etvMG73UPS9Jw6JntxUkTcXv6wZoPwBedIo9bZt7ePPVLdOR7TBuh4NfYMY9L5TR7u5QCDUYriSwDMHMFAyS7qAHYLMyRyGiV7I7TktknYR6KtJk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(366004)(39860400002)(396003)(136003)(376002)(6486002)(107886003)(26005)(16526019)(186003)(2906002)(1076003)(6512007)(83380400001)(86362001)(66556008)(66476007)(36756003)(66946007)(956004)(15650500001)(2616005)(5660300002)(6666004)(478600001)(4326008)(8936002)(6506007)(8676002)(52116002)(110136005)(316002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: s7tJ8NBKZXiufpoa7MQYaARLXqnU6HEmFrLYrBSwBEHtHqt6ahSQ0BAUW3wxfyhSpUU/8LC0LV9NOli+N4fihuNgP3QHBS/oxhmpKkM0cFGQg5d5w7UT3EvRFSoCZrRzdx7tmvoHmtrx+IKu8ArtFynGeoIxruH/Y/NyZCBWALjzLGcJNDQ966Bq4NTWBCHp59NiYjhuPb5wDMz8YQGvE25WT5cFaZ1A8Y29v9U37dAHpiD+aKaj8Bf7lf/glWjHjoqA7Kv7tsIuPBJQktBIhQWXRWrB7KWcciZ0SIpp4Udk5lGdG6VpSL5HukUKqKhDbNcNHV49A4RlYjp32oQO6Ymz0UzDNkdmoCs0S9ubPVqZuEsLXvrjF/xHe9r+uCqrsJkEZRThV5JsCruhyBcq4E0kQoviFIzioOawrLhHiDb4PVheiQ9icPqYZboRJRUJRlJ2UvFDZTf4EAZ0G7jH+0+uJ4w+ViWKy5dBwz2rqFI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d51abb3-8dd5-4dc3-8eee-08d81f06d2b7
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jul 2020 04:09:04.0263
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCNBrk5ivgWkxEHHFDY/78p8aNABD/IUdX+706N7JR1Ay5GMw1Y2y0ce8wSuRHgsjSu0kan/g0EO7y/HcXKE1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5534
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave, Jakub

This series adds misc updates.
For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 8c8278a5b1a81e099ba883d8a0f9e3df9bdb1a74:

  Merge branch 'sfc-prerequisites-for-EF100-driver-part-3' (2020-07-02 14:47:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-07-02

for you to fetch changes up to e62055642797a6de80f3576c18e212cbbf5b4361:

  net/mlx5e: Enhance TX timeout recovery (2020-07-02 21:05:19 -0700)

----------------------------------------------------------------
mlx5-updates-2020-07-02

Rx and Tx devlink health reporters enhancements.

1) Code cleanup
2) devlink output format improvements
3) Print more useful info on devlink health diagnose output
4) TX timeout recovery, on a single SQ recover failure, stop the loop
and reset all rings (re-open netdev).

----------------------------------------------------------------
Aya Levin (11):
      net/mlx5e: Add a flush timeout define
      net/mlx5e: Remove redundant RQ state query
      net/mlx5e: Align RX/TX reporters diagnose output format
      net/mlx5e: Move RQ helpers to txrx.h
      net/mlx5e: Add helper to get RQ WQE's head
      net/mlx5e: Add helper to get the RQ WQE counter
      net/mlx5e: Rename reporter's helpers
      net/mlx5e: Enhance CQ data on diagnose output
      net/mlx5e: Add EQ info to TX/RX reporter's diagnose
      net/mlx5e: Enhance ICOSQ data on RX reporter's diagnose
      net/mlx5e: Enhance TX timeout recovery

Eran Ben Elisha (1):
      net/mlx5e: Change reporters create functions to return void

 drivers/net/ethernet/mellanox/mlx5/core/en.h       |  20 ---
 .../net/ethernet/mellanox/mlx5/core/en/health.c    |  58 +++++++--
 .../net/ethernet/mellanox/mlx5/core/en/health.h    |  16 ++-
 .../ethernet/mellanox/mlx5/core/en/reporter_rx.c   | 145 ++++++++++++++-------
 .../ethernet/mellanox/mlx5/core/en/reporter_tx.c   |  80 ++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h  |  46 ++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  14 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx5/core/wq.h       |  15 +++
 9 files changed, 266 insertions(+), 132 deletions(-)
