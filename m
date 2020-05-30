Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 300711E8DC8
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 06:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725987AbgE3E06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 00:26:58 -0400
Received: from mail-eopbgr130058.outbound.protection.outlook.com ([40.107.13.58]:61765
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725889AbgE3E05 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 May 2020 00:26:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E8Ny1lZqzzLIueggc+JthJCxfaMMk04qcG2idkUtEM6aCEi8bnL7kGsSMETlnvynXlZyv/J8v3IDkEzxgARSY7P8xWP40b56wGjNJ3PbCHoh4SXQ4/PdTAqi+DG5qD8aPH1t6qhwAGZ72l4PUTWgTfrkSitVo7iVDB0/M+IL/OjoAAHETAHWNN9lfbjHUohHNmWS3Uo/wncDH6Nb8wkqkvOJ7rjh8tLp6bqH9e8XHPB53GdvhpFRODdDqsq75EaYZBR9DQY4O9bgtsJBCL6vK+40kfHV8aqmc83nGjTq/TsxmzusSV/JZL8hTZiKv1FsIsKWnjJTLLIic471Y8ielg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ymRM/Ii5nLKWGxLqUlFdR+kFBEB47GBtoZb8RenGUg=;
 b=POSgz7Pi/egH7mrXyijFTX88Ij1LwrFHqtVLyWV1jcqC5ASpyg63tHsirH5Gut5UVWb53n2WzDcDeQ9oHnHhA7iyNJ23PqllHB6179PM33lp0MkotgXvE0KBOZdw8O/eM6bBKPFKf38YU2EkXgUtky2PXeFOHppNZnR3cxSrxpcWbtPT5+D3rnwmqLVnOaLaBesLst1ClI8lRT3YTjwWRXRgG17ZMpR7NTP1oL5MO5rrvXIMH8dhQ0xi7lfF+XA/0ZME/0qpy8Sb5ZSgWMKYdprd1Z6MxVXKpXeHHCq8q0xX5FM3LUaW9vtYIkAnnjgiZbpdK2eWmNvblRI2DkJvBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ymRM/Ii5nLKWGxLqUlFdR+kFBEB47GBtoZb8RenGUg=;
 b=KWZvFSdY22xtCDeB0OyvEButETnXxMJGC+tpta+ISi7eZWxzzwVN5mpjbJoXHqUU/Rzb55Q+7r7JtN/LG6zD403kXenwSoekE3gmjuQw5kV1BayyTQev4OudZxtZ+4Yja8bFf8c/Zd5QihaPLCdiyFR38iFkKC9pRoP+MkXAF/Q=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3408.eurprd05.prod.outlook.com (2603:10a6:802:1e::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.18; Sat, 30 May
 2020 04:26:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Sat, 30 May 2020
 04:26:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Subject: [net-next 02/15] net/mlx5: Kconfig: Fix spelling typo
Date:   Fri, 29 May 2020 21:26:13 -0700
Message-Id: <20200530042626.15837-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200530042626.15837-1-saeedm@mellanox.com>
References: <20200530042626.15837-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR05CA0004.namprd05.prod.outlook.com
 (2603:10b6:a03:c0::17) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR05CA0004.namprd05.prod.outlook.com (2603:10b6:a03:c0::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.7 via Frontend Transport; Sat, 30 May 2020 04:26:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 133c891f-af26-4bdf-6062-08d80451acde
X-MS-TrafficTypeDiagnostic: VI1PR05MB3408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3408B71157ACC47D5497CFEBBE8C0@VI1PR05MB3408.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-Forefront-PRVS: 041963B986
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +4QijyOvHE6qaNJFWiQfcksyAnDelaHUsmzYRk7TVHNWI87v38lGk80GMTdgRy70tEO+cGQwOShn3H0NRtPVLasaMCnIL2NCSIVUvHXGTpFSfpdokOR7ehS1GkgYLMt9+W1GVibDCVCKLzThzcJmFXp7lgjvl8noaVbSnHcL+Aq0x/zImxkN8iGOBTuMKB79dKO6pO/EZLyd63xI27UYsBoD1GG5UAFB2VlL9GnV+g3zM2IZCUP4ec05zjJihdArFc4Aj+MGhxiZKQQoQ0Q8IVik/GyHKnWFerrgyBPnCTkyJ/CuM+xOpG1W1Wxw73K9mHNmLQ2oUNefsiE5CuVBLadeoNTH86v57YFo1MrYem8N8GRGotgS6H8FpVVG7gD4
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(396003)(136003)(346002)(366004)(52116002)(5660300002)(6666004)(186003)(66476007)(26005)(16526019)(66946007)(478600001)(1076003)(8676002)(4326008)(6486002)(66556008)(2906002)(956004)(86362001)(6512007)(83380400001)(316002)(6506007)(36756003)(2616005)(8936002)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: t0sJs+LfvLqTmBlc3sn/FsaSFAswrjbQbIy/NbgGnhsUSrGAYrt+AN7luF9iK3KHgwwVMZKa5rJPfL6beQyMmvRa5bJYEH/OcAazedx+pA+3KL4gDHSq5p1TjFRI8ExTTdIdFDoO8QyUpv0nrz6Eu3Rnx3S3jl/1rZsy0LodLRbT8nH4/aE7gX6LhhOmWSB7n9r8BzHaqrVNkgtDxDB38K0/DF2rQ1uyju0xj3eInDXo0HDZ2owtCkELijI79zIZNdBGvuWz1MT0c8LfloWm2tYnWuN9xpLSUw12C/KzopVUtxIfvxpSGyjfmvh0A4jWbdkoXnsQucxkQaTTbCTksCuD5iujnM46MrhUDaTRU1NjpH1l/uY604W6+uNvfSa/c0zCLoyJRUxI2VA8Pq9+KLRZA2puTpCgTIrqzfUamilxh0GJHYTPtrH1HttTSMuwd40xEDxPOsGNGUgdnoDGMGXe0H6dykhQspELf5MEuNE=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 133c891f-af26-4bdf-6062-08d80451acde
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2020 04:26:51.5729
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ydQ4//mlNCLUFyubu24tPshJVnuhB5fZM9QyPuq7MmqfSG4hbVin/4+QFv8lyByPyvK6nx7aYy6AoPEp6BrYZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3408
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"mdoe"->"mode"

Fixes: d956873f908c ("net/mlx5e: Introduce kconfig var for TC support")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Reported-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 4256d59eca2b3..b6ffd1622cfdd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -84,7 +84,7 @@ config MLX5_CLS_ACT
 	default y
 	help
 	  mlx5 ConnectX offloads support for TC classifier action (NET_CLS_ACT),
-	  works in both native NIC mdoe and Switchdev SRIOV mode.
+	  works in both native NIC mode and Switchdev SRIOV mode.
 	  Actions get attached to a Hardware offloaded classifiers and are
 	  invoked after a successful classification. Actions are used to
 	  overwrite the classification result, instantly drop or redirect and/or
-- 
2.26.2

