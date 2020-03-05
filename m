Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97C9D17B225
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:18:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgCEXSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:18:00 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:62017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726049AbgCEXSA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:18:00 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J7TOJ1nCbOSuNKrcGeGzIaUPHtLHnDsVzlmFnwv+j2TjxMLZ2zGUSHQpENl9m90CAMz3v4OI9oGM8ouhItNxOVyUWw2b8IEu+IVWhO5qNgAaW1MZjMF/hDZVLKEsKJUIyagZNycXtsCnQLO3uF4oeVHcG6f4L41csIjwguZUza2s+K4MtIyvztSyrIHcXh6t1pdgighMTb4cFBVuHBPy8Gpw1ga59D9E1HUZUdEi8Vn5cED+jZ9etgLp7k0U5nWKjcx2NPTzgcilsuVNadJfbUCoaZixWg9DgHmOv8jce+ioIh++I3iOWy1OR4pDOhccGdR7W4cwbtVEym14bCtxiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/aLV/ojFDNIjurfCxtwDyrJM5qShxFu3pa8llBn/dM=;
 b=dB5vMLBXbCW76RJQJfQ9qeGagJ2gXptVB3UbQQoKwbJSYjdQDfoOPLVhXYYwoEcmweApbUO/ekOvJYP34a1/3iJYlh6pNT+I+DpFqQUfnVMF7ZKNTBfgoMpK6pjUYySE6YxKyMaW6fH8BnPQM0K0Se5x1bS/n8oLqBHvBBlam1bJvKSXLeXnXwmTsZ0z4VSeTo5ohAd9Ee2lNmuquvRcA4qvpnPYLtK71cUkcZlHz5qghMzzQu4BnitvaxV2D2pe5NkW1qvt5jeDxPO5Xe2w6NrlZFOpSeTvUcOwYXm48figa1z3wSR6shYqPlGyIqJAUTZaow/sO1lNImEqFpMTVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3/aLV/ojFDNIjurfCxtwDyrJM5qShxFu3pa8llBn/dM=;
 b=j6g3X6v/S+aJuvuTai/lBxFkkPL6SXyZoRa+WzFoL1GLeQaVOXupqo8eqJv93zIxeqtxqQYB4VOlEYG4HMFxExkfWcDdQ/EqjvQkCNTyKps2UJkzd9zkVQg6nk+a2sn5rvP3J7GLgH7qfz4CzhoZaDjg41QXP0di/X2JXTxDfxA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 23:17:56 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 23:17:56 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
Date:   Thu,  5 Mar 2020 15:17:34 -0800
Message-Id: <20200305231739.227618-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0042.namprd06.prod.outlook.com (2603:10b6:a03:14b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Thu, 5 Mar 2020 23:17:55 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 3ec97f49-b95c-4a95-6256-08d7c15b6ffc
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41893183A88EA2E98017158CBEE20@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(81166006)(6506007)(5660300002)(6512007)(4326008)(81156014)(6486002)(52116002)(8676002)(36756003)(8936002)(66556008)(66476007)(66946007)(2616005)(316002)(1076003)(86362001)(6666004)(956004)(186003)(6916009)(26005)(16526019)(478600001)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x5DYLVx8KuvGE49/a0itCRHjyV68Wg17GHHFNZiW3QFqATYNLwkOHkGwcFhgEDOyya3HJWXFbNRg36q4J+tqBKcL898ADjrNBMMQ9A51R2kZh5BJB98HikqwpdCwJ1T70nNlGl+QBcVh7+4un3mXqrjAC2K1VQjO/kuDGw3xqOGvEKvDjtVE2nNm3pzcZlSRn74duyNvzcIL6ORL9+5l3rvGYiCPRYjVpOSul3xD7pPqL+embQ65Td2xEtpHk8EGS5aDIhSPem0HLB82l6kEUvlHOyeLAYb2rzs9Oy+Y0Sl/DtwaglczeGQH12+WY7GwU28kBN2nhz5k8LsmtT634dbH/yJjmNdzmlZ+mRc4Dwr2Aqxq6ns7PNaP4kt6+uJ+fzB7UiKIurWNaz31ubGYVCvvJnxDERidz86bUCZ7PXiVB/yi1XEyXCkxLNhoyCaMMWAyM9vWgG4+k7Mj+dSvlO9VoBsJYNYasIsJiPaDFo8TXxGozK1TvXZVnCGHUNgfzB6sHe1lBzwmSWzBJIIyx1tI5KWgUrfFeuo1/cQOAXI=
X-MS-Exchange-AntiSpam-MessageData: yhlkOoyHIoWR7/W7Yskx/HBywlqCjeL9+1+JiBjv+3FDnUOb25X9HKwtVbZZnb1Q78+CDHgkYJU6QugxoTd/iwP0Ii8lZUT90aBLbNXk4iQ31FUyZjv1qU1xAJ0ZTFccoCnGxLN8UldqOZz5yTzHXA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ec97f49-b95c-4a95-6256-08d7c15b6ffc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 23:17:56.2379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0qE4+cz9wdhX+RIKiCNOTUk4GCySBBUn8YFnToyQRPIKMd0a5IZAI1YiyASr+I+2gCN/DRoPGdtu8df/FKU1ag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

For -stable v5.3
 ('net/mlx5e: kTLS, Fix wrong value in record tracker enum')

For -stable v5.4
 ('net/mlx5: DR, Fix postsend actions write length')

For -stable v5.5
 ('net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow')
 ('net/mlx5e: Fix endianness handling in pedit mask')

Thanks,
Saeed.

---
The following changes since commit 3b4f06c715d0d3ecd6497275e3c85fe91462d0ee:

  sfc: complete the next packet when we receive a timestamp (2020-03-05 14:56:57 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2020-03-05

for you to fetch changes up to 0b136454741b2f6cb18d55e355d396db9248b2ab:

  net/mlx5: Clear LAG notifier pointer after unregister (2020-03-05 15:13:45 -0800)

----------------------------------------------------------------
mlx5-fixes-2020-03-05

----------------------------------------------------------------
Eli Cohen (1):
      net/mlx5: Clear LAG notifier pointer after unregister

Hamdan Igbaria (1):
      net/mlx5: DR, Fix postsend actions write length

Sebastian Hense (1):
      net/mlx5e: Fix endianness handling in pedit mask

Tariq Toukan (2):
      net/mlx5e: kTLS, Fix TCP seq off-by-1 issue in TX resync flow
      net/mlx5e: kTLS, Fix wrong value in record tracker enum

 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls.h      | 4 ++--
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c              | 5 +++--
 drivers/net/ethernet/mellanox/mlx5/core/lag.c                | 4 +++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c | 1 -
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_send.c   | 3 ++-
 6 files changed, 11 insertions(+), 8 deletions(-)
