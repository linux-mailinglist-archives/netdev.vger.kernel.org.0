Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76D451C03C8
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgD3RVO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:14 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726785AbgD3RVM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntFHFtBHy7HSdfHjh+uPCgrWliCBpF6YKIg0S+ILT7CR5OOd/t4wAAeGC9BBRzKTfe2eD3NMsHL+hvsEzJDPXdJSR1ShT8u+3eJ247JeCzjNF1wbo4PAufA0dlDfPoZRnUYQCdIgeLtbRAfLoeMv1r8fT4BueVsrVcGuAC5Zo7TYH2Bt/mZUVwATCwT5lIdRskMCXRAK1NM62g4Va7sIQEbEi+pGmuzQ4aFtHBJcuNFdHfDLLgYjKlymDlXtloxv6+izQz9JSSN15CAfnO3AJ9CMrv5t1i249lUoMXgYoAmdsszj7QL8cvTEHbpaRRBCm1Ejg7CiAj2fM9lYADVd9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEK3gVmUP+sKAUmJR5HetVzE693d1J7liiq3D0PTcZE=;
 b=RsogtZuDqF1XMLO567jOAvYR8jUqqDOeXZ5ksMf5orLldnIY5DAMKTpVWMlWBHD57o1oONQImS+qVjEsOdvFaVRE0JaAJ71Mz2kVTVvP7tQJmQgkUC/+D068tGOxYLrDQToqTIxjh5O6xS+dOHKqwnNTHxfaJ8SUz0/fdsT3qn8zT6gnPlnXyAZnbSsjCXXHAiAV0wCjCMIZc5Cai7BfUlVRKc6YM+m4olBNNXrhNZcs6UAmrJnRocipGozaAmBIPMOuC5RST3Ix1XCyPDWAW33Yb77IAypKS1sQQednZqpV7gliQKt/7uBEzeVJp2RDWQ/m0cUXhRSBMEepOcvD3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HEK3gVmUP+sKAUmJR5HetVzE693d1J7liiq3D0PTcZE=;
 b=rHpi6OowVXxj536vcd3Pd2m1dyJS2JEHAr8qpw/5G47A03V6yQtkyt7ZfzcFVRStcfD7qFzZpC6ki2aEN0Yfok3KpOUB2zINKi2/VnSziCJ84q6cotyfx9ou5XlnMLp+JPMq1rokB4zQiSwEa5ABPPTfF6G77XZxbKQeOc+Abq8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Paul Blakey <paulb@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 05/15] net/mlx5: CT: Remove unused variables
Date:   Thu, 30 Apr 2020 10:18:25 -0700
Message-Id: <20200430171835.20812-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <20200430171835.20812-1-saeedm@mellanox.com>
References: <20200430171835.20812-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::43) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:21:04 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 346ce432-5f8e-4df0-f6dc-08d7ed2addb0
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296A683A416C291DC6CFB87BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:146;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sv0S5zE3QTuNy4wV+Gh4PKTHEkV2MrZPbQNvhLX+MeyUQKzLqbT327QQe5DY6WpBXqPaAdi4EcD/N8N9TKZNIOOK1Yk4pPQ3ksg5wrSChwCEdM3c/0PEt5Rq7m6Jas0Hks4lvzpBGVI2JX6xAqnqjq8rcHj2cyl+9GZ7A/8T5itEs/o3k+TISIWh7lnMSUCDaKqc9YX7oU5ujhiBvs/N4LW4i9l2rUP0qC7qD/q5yh+lOxOM15Xs2qzEBxZe1MnwhF8HFD/N0lyQaTBIf+lCMuiS4l92ctvScN+KH3OLpyhNIhG//jFIYB4srUBRrfkqZCaUAsTbE+Z5uzFyipTZHefOcHd/M89XF+khel7Pf/tXA/08RSBu/7RdOpr/jMwqVrlb5EW9aThcKBsbA1x9AbwyXfq9vRYW7lWA2TheAB51ZYAySIwwVnwj3WQvuQjlQS04Eu/EO35g6jssw4y7dmI9NEr5ppUOXX397eT08/8urjcKlW++d3CATcTaYotv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: aEXq8CnE6X5jathULmgi8g5NI7ZMhyz+ldArLTRLVy/4SI8vShzqRJkE93wivfLbXGGjdMFxPUEbbyTiCSDjkmY2CArc+g00NtK6BOB3iZKPGLEyzcp/a/UU/BIy6vqpyHYDVQYsFIxSUD5PUfAW2OH5MhO8WuCYAoihINnCCfL5y94NbfY9gwaHFY5gMQyW9OEvgBtAsWkGM1BQfJMjfnr9YkVbLnhpQ1EW2LtS6eN2LZNc2u7DVbDjTpz2nX5Ex32AKyezgJ7F2BwXYu/tQMuUs3qEUxk2cW+9hp23cWCJEM93ynvvMA+6ANzhGI2w5T7VxNFA9XM0vQV02sk1SmpCPZHWpMCKsvPhB3yZCFtOVImQvKgyovc07M0b5hif3bM+HCJj5B4bM5guMsiAANovn+dwIss3GAOZSgK202g2a5AmEd7Dx3KX00h9p62HI08rfYP/9t6WgVHc7CRy4yI0ms1XIqsl7Z8qGpVSgny1rkEN8duOUHsUfRhwP8JCIuMOFOqwg9MpCrksad/PziWhfWXnxDqqAdfZRzWRun6pCTYWNg6YTinY7n2V7i0lLk1pisDPB5o2gUZOvg4XvpmFEc8veGGmCDzFHI7lTZ6eyJjXXUbFg0RHikRHwVbRchw3VetpPSbI1LlpnNAuf360dTh2X6Bpn3MO+T/ZvYz1ac7JDwq8wnaZQ7IsDOkavzY2j5bbW85ITs5wGvkTPocv28iEM/x/3PIkJ3AoHtH8eN24HyuClfjho7v1Vrb2JZa1K4zhoo8cNwaUSj6k36cB3zUJH91PjPORrDkrVhA=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 346ce432-5f8e-4df0-f6dc-08d7ed2addb0
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:06.3973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mIJriSb7kMcZJwOTlmo2Up3A6iy8s5jn4k/ePYkzONo8sc801vsbYUxdQDrHyh6Ar9DIyk3L2lBKHVXZR2gjng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Blakey <paulb@mellanox.com>

Signed-off-by: Paul Blakey <paulb@mellanox.com>
Reviewed-by: Oz Shlomo <ozsh@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 44f806e79e8d..5568ded97e0b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -73,9 +73,7 @@ struct mlx5_ct_ft {
 struct mlx5_ct_entry {
 	u16 zone;
 	struct rhash_head node;
-	struct flow_rule *flow_rule;
 	struct mlx5_fc *counter;
-	unsigned long lastuse;
 	unsigned long cookie;
 	unsigned long restore_cookie;
 	struct mlx5_ct_zone_rule zone_rules[2];
@@ -603,7 +601,6 @@ mlx5_tc_ct_block_flow_offload_add(struct mlx5_ct_ft *ft,
 		return -ENOMEM;
 
 	entry->zone = ft->zone;
-	entry->flow_rule = flow_rule;
 	entry->cookie = flow->cookie;
 	entry->restore_cookie = meta_action->ct_metadata.cookie;
 
-- 
2.25.4

