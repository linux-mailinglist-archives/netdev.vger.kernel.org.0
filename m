Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CB792203FB
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 06:29:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgGOE3A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 00:29:00 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:25072
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725772AbgGOE3A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 15 Jul 2020 00:29:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gqjQjdQ/lVTsC59dC98BwTu3S3+n5y2oiV9nV2AX4S8jAZBAwo3MEzelliO+3YRRmBtQlTHpspgb3tRQW7hkVIY1Z4rLFR+5f5tgsinRSZLAXYfpY9cqz6uq8Ee7vsGHEkj3fhDN4KH5DX1ZJHPSH3ABAzbL0n0fQYEjsFzcV5oatIkxPLhzWvLNzIVRM30QIhHDtrhPv0cLOcFY/8XQbTD6SAQd3tI85fTAbxjOgIGLlh0UuhP8TWy4NXdZjmifeXkIzy5Y+MvJE1l/Ex+6/RaQQFCMaHjvvOBq70yNbpN4A2qV/PejYaKwc4XJxBq6vFlzSJIVEIf5P0NEGlxlpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/ZfEqCXLnf7p6WY9wr07ZYCSQFmWOAdZiELYHx/hZg=;
 b=YfGPsVqfn1RjlPvA3twbdclfBUMPQKBRTgYBpZbFFWQT8GBBuiZMKJrL/6Yc9Gj9TU30sNOAZ1NG2eUt7aIiAncfdKms8yJmEEfGHIeLnjvyXajNtGZAR4obpMFfgzDkv0zdG2R5nm1KpCkNyTETV5nFjvXz1T+1x9IssKPdT7y6UIuwUcPJspdAM3pUHDqeHlDWCbwZHtjiZtP7VTj779leSrbsyqGA/cLax+atCkYC1UxS1gbQvzzvDO+2gYfPJtbad4P5ZisDduI2MFlf3NuzFOTywdtEfZj+OLN1Xaz1OD9Nl3UMoLu9nnl+0NuJNV1cc9qkJF+ERSvMiphafA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t/ZfEqCXLnf7p6WY9wr07ZYCSQFmWOAdZiELYHx/hZg=;
 b=G9H1kKP+OdssXOk6YO4LxUUdK2HD4GkEPRKIcmYhH/iy8pwq75TDOwrm2DwoVNqUfQrjSnKDJD+NSNv/B058jg1Dfg82VYuFH6OeBhsZrkrujtVO8tbgHa/mlcEoN0iflGeW+DVPgY5Hs8yA6D2uWu9NOm8PY4EryYu4EhtREJ8=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6655.eurprd05.prod.outlook.com (2603:10a6:800:131::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Wed, 15 Jul
 2020 04:28:57 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.026; Wed, 15 Jul 2020
 04:28:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/4] mlx5 next updates 2020-07-14
Date:   Tue, 14 Jul 2020 21:28:31 -0700
Message-Id: <20200715042835.32851-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0096.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::37) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0096.namprd07.prod.outlook.com (2603:10b6:a03:12b::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22 via Frontend Transport; Wed, 15 Jul 2020 04:28:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: dffd6cd5-06d9-40f0-af5f-08d828779694
X-MS-TrafficTypeDiagnostic: VI1PR05MB6655:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6655A0301DC486335E88DD87BE7E0@VI1PR05MB6655.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLIF6b2cakRpfo4WkpsfOtG5SEB0paBzhvLAkRe/6RFtAoD/o3fjamyso5JFDM9DVBHsI6ZNPOyYcWrchE7NwnOmKSM5BB3ENie30x50GMPTYoZ2PRp9zDsv8q7NtaWM+UO9r0vSJHqT/vxNwdV4C78lpvqQj8lGLazD56cgl1NKkiTUtJxMbM23gH5VCxGGUOAsrcR0m5OEKuJssyqdDuLJ9iCl10Dl+BEdzqeABCl1gystVeUWyKKZ5UwDjBNS9t+EiuxKFBmJhMezNH7IqkiWUToI0+gN4E/ZJwP2hbMDSxMN6Kc3jyIvhCt/DA1SZWLuPFEWL3G3SL9gxtJ2iBFA2/FMYBYmtq/XVPwCBOHeOuTqMKuJWdJ85FPYO3Gc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(376002)(346002)(83380400001)(6636002)(6512007)(2906002)(1076003)(6506007)(8936002)(6486002)(4744005)(478600001)(52116002)(86362001)(110136005)(8676002)(15650500001)(5660300002)(6666004)(16526019)(956004)(66946007)(66476007)(316002)(36756003)(26005)(66556008)(450100002)(4326008)(186003)(2616005)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TPwHLxc3Mv1GyOuY00O+iYX9SC+tcDssIyr0/zsv1jtY4g7NGmfTOm/r+/+i3IZ8T7cnUxH/hna7jYdV+TOmqCIogWXEuePgiTmHOCs+1pF00BvH4MXHIx8VL1dupGgg7kaP6o0N55jigLi+xzCjm5nv37S3KHlOGvqEaTDax+ST9HE7sbUrZLvOlronvzu6SXl2M4U9VMWTQZhV3jvZJjzY3OzEmsEV6INiB0/cuLAWSEJBH4c6/ItTnnTIbZItYbVD80s/8MpWvQUi/GXtSoRe/n13SLloxkKdDE8Q1C+vqL/z2/8QSwHLit5eOW05Twfx6lTZE8B9M5JxRLKaaIcQ5Kr5eHbK5LBltXhdVZshXxMPJSJzzlJIr49qXvsTbGbIpkAohfZpi4z3o6fjvqx1Fbpd7k3iHIpM9NECfTyGqrbn6kRu2zzvofxECJBg2vzCKbc5N60gflfL+Kiv6XR8+ZuFGHhk6lGVw7MjzNc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dffd6cd5-06d9-40f0-af5f-08d828779694
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2020 04:28:56.9078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tKrbt0HW1evCna+rMgtwSoilM/iEiiveyG5EfOtcmuFf4xNmh6k2ZK9Q56m+OZbR/0FXy9rXIVUjaE0c84JODw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6655
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

