Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1F3A2201B0
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 03:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727101AbgGOBUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 21:20:51 -0400
Received: from mail-eopbgr40052.outbound.protection.outlook.com ([40.107.4.52]:60266
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbgGOBUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Jul 2020 21:20:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4Faq2FO0/+KXPgCvFExRw3uo/Rm18hvXWg8xn/tLcgUFB0PaiiiTElcpOzXLrl84W21vdnbOSQrlcqu8mTqBxthmNJVX7tf/p0RHdr77xeeX1l7wuHwr3pPdG10YVyT6MHN5pc/FVanlcFVFG9200mfc3kvp2vPXmaWLAl8Lsx+bDpH/0uUdF1ivvlPMRQC3uaU8kuphllh3zDlGQAQiO4imgIbpZfEqeNvoO9HHIYt4zDPPrn7EX7PyGzYmNwZ/PDM7beftR505nLIbhpm/w1mBicPRj040UCdiHX1fgWXOB2L4t4gtb7I9CB4Bp45SIJtkBGCUna2Th9WWzVpnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/ZfEqCXLnf7p6WY9wr07ZYCSQFmWOAdZiELYHx/hZg=;
 b=WH9uy28zgHBMbDZ7qlbeuE58mND42ohnwft3nq5jrNZDTU5FmyUh2wl5Ua33YRyigkePL+JuvyqexD0jb9Fcc7VUP5uqIWPFwGuNQ68xILpG0Ge8zMvqbJYiSh8iBz+s8U0WWTrX1VwyCWoU0D55F9kRVFK2RCCjS2UvgXs65ISeo0UCKnEyBd3Ra4Fm+j7y0yWO1jD0Vlm6c9jJSIQvopSzMW+yQqk0L1WtKSNWBV3Um+AMz+3hghg3ZRE5MHyVqy7lLvkUUmmPhn3Kxnvj6LRis9ImUe0EHQPTfv9A5AOGlmZpbN4FCkX0xGd354A2pfT7ZfrpwrMd+PQ7B+l6/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/ZfEqCXLnf7p6WY9wr07ZYCSQFmWOAdZiELYHx/hZg=;
 b=rfk6mY929H2ID/2m80N6hPrcx0rvt24lVQ/0mrWzECJdqIOttwUrLSMF/KHrrSygCMRtKGF2HuBMCz59X9L1rZHoQZje/ok+/3VMfGAfCI3g3r9/1LESy3tjpMTP/KBlU7Ohdnd0tNbnD1SH0Yl/dSFe305rdYe7gDkAKc8aSr4=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6109.eurprd05.prod.outlook.com (2603:10a6:803:e4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17; Wed, 15 Jul
 2020 01:20:46 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 01:20:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/4] mlx5 next updates 2020-07-14
Date:   Tue, 14 Jul 2020 18:20:07 -0700
Message-Id: <20200715012007.8790-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0043.namprd17.prod.outlook.com
 (2603:10b6:a03:167::20) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0043.namprd17.prod.outlook.com (2603:10b6:a03:167::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.17 via Frontend Transport; Wed, 15 Jul 2020 01:20:44 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0ba0faea-7fd4-4e11-0ed8-08d8285d4cce
X-MS-TrafficTypeDiagnostic: VI1PR05MB6109:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6109DD7EF6B20D616CAF9D24BE7E0@VI1PR05MB6109.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: g8IRTymMu95ONcfwMu0gMOTbIVQgKbpMT1DUqP0AAH1+GJl0Xj/yAcU93IkTOHG6e5lxACJKwb5kuQ9M2Zs642oCSQselXyFe3Zceci3J4E4yLK0Jz0WumzS2H+1w+zu6fUyEBIhJhhF5thKV2KbLeNWMUTkU/E6sPP4sDd/BWu+igXJUnyCeAes8uYu31773Qfgtn5FTA5RwWW/Z8sHanbRzgPrjcLGupTDQv+5y1jlzIoxDrKs2avwv3JzJJBaMmKdIcS2iZA+5gPND/9EVrKZbQXkRFeYLW1YOUvqkfWqxLm4EpW0T5zpXKRAP3M9nMUUc8I3pNL1rI051GhI3QHUBHUEZWdQeD/pUJOkXAORSU4BL9ZSwSnE19mKT0EP
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39860400002)(136003)(366004)(376002)(396003)(8676002)(6512007)(6636002)(6506007)(4326008)(2906002)(1076003)(6666004)(52116002)(478600001)(2616005)(6486002)(956004)(15650500001)(450100002)(66476007)(66556008)(8936002)(86362001)(66946007)(26005)(36756003)(110136005)(186003)(83380400001)(316002)(5660300002)(16526019)(4744005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: I24LNqO3ukzVGml2YTFmfZTEJEvAGraT223Zuj3qVQ4KTnQ3GgK+KG4GIGL9e7PAVFXCkqBSv0jp/ip3ZenJvnO2gs1uEuO874Bs6kvNEGf1gjk5yVJiHadqngZKWOK4M9f5Mena9cDhCHrv4MWvu6R05i0yMcSi4PZ/XkERzH4kqCjK9sNVDUocMQ+z8RJVnnwxwS1joq5Nexm3NiVg6GXYCuvBTkoDH7QW8UNNHHiCe4nfgX+2LIt1jaQQYuu82OC/1jPmGgxDLWAD4NSkiZnIpCuCMnIf/lnyKdg+OIqm2PWeFJUwno6WlwG11x6XIxB6fBr1rbUwD9hrrsii3SdZgU+hTvNep/sC41M9Y1eC5tFtVv9AxF4XvM54O0S2vWYgoeCmVqJECB/KS7zPSntcbMk8J7xkd77gGvFV0AD3o62Jnw/lxWs3Gbbh18OnrZTj413RiijLzB0/YXYw9nx1YUPJfpcCEyckQVmpFMY=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ba0faea-7fd4-4e11-0ed8-08d8285d4cce
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 01:20:46.2515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: QaHNZlcKKfT4xYQVZ+5HQRr2DiS/W5iXA5mJHdqdK5vfYAtsV8scUSLNWrDeFZmqC4u0wZk5pwzLmWMw/ube5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6109
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This patchset introduces some updates to mlx5 next shared branch.

1) Eli Cohen, Adds HW and mlx5_core driver definitions and bits for
upcoming mlx5 VDPA driver support.
2) Michael Guralnik Enables count actions for simple allow steering
rule.

In case of no objections this patchset will be applied to mlx5-next and
later sent to rdma and net-next trees.

Thanks,
Saeed.

Eli Cohen (3):
  net/mlx5: Support setting access rights of dma addresses
  net/mlx5: Add VDPA interface type to supported enumerations
  net/mlx5: Add interface changes required for VDPA

Michael Guralnik (1):
  net/mlx5: Enable count action for rules with allow action

 .../net/ethernet/mellanox/mlx5/core/alloc.c   |  11 +-
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |   1 +
 include/linux/mlx5/device.h                   |   4 +-
 include/linux/mlx5/driver.h                   |   2 +
 include/linux/mlx5/mlx5_ifc.h                 | 118 +++++++++++++++---
 5 files changed, 118 insertions(+), 18 deletions(-)

-- 
2.26.2

