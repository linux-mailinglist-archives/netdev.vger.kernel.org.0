Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D253D1B1852
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgDTVXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:02 -0400
Received: from mail-eopbgr30060.outbound.protection.outlook.com ([40.107.3.60]:29966
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726050AbgDTVXB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MbpcB7ST+CrUtFlo1QF1WSZIbXrSwp6ESZTCCIU8CrNhM+hRm3G7WSVmWK41pJo65iuQoMveDxFrxGzIIHbVR4h/euDEdMViupyecYhhOY/VTPqvx8G44v30YCLeQkL+y8iCsTFEB4AdC/5iGL5kySz0ID2on+t3PgHpomGqWWN1nAahkJbPvAu2A1qentgRCs1+Sjtcco6+j36MmqGZoVGi9086mOlaC7bq6licSlA3MzlAb7R0+58grx/mDQevaz60az7QkivH6TIqG51EajU0Hv2M9u2jBute92WMZoEy6hjFpoEInZnqmJArpjomIJxpYA2E6JJUuJ1AkCntOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fv+qZiIKNQoKOBJZJbb90aUsgh9//jYhU2BJFcr4dIU=;
 b=DvswMC9BJKPKsMi+WV2HJb+30zMlnUQXYzZ5vPZP7I3z4tK8khtb72tZdR1I4Bq0DhvNFqhzD7yun3VkCDBr+RjYyph6vVvJCP/uZfpc3CfLH9a+d5gr/N8uTem/bK9eYHbhC8j0Zqv9gYA5xGWr1744suDw9o19MDsIFtozqx3VS93dzAYNDB57dtF+goKKfQoW8oig8d2Z2vro0bMPRq9mdhb4NqnJFCm3Lhuq2i2Cy6py6kGDBn/Bgg1ugCSaBMd+tNrRW05w8bZgA3g2dba8rPUCYW+65vJN+Ni549OByvYemHIq/RBHu1plRYTe/Q9CMYKd+Kt7cfhctTIgOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fv+qZiIKNQoKOBJZJbb90aUsgh9//jYhU2BJFcr4dIU=;
 b=DAriEVL3j8ksnhxKmHrzqr+QtOVF+A92RDlWwGyB0j2xiNWVTWBJYlYAOXWAX3sgRuelg/QbN7vEtJe5WyZvBvxnPrAIndJIe9uOe900kYYzIRaUCFyeaYt8TpgEWiq0qIdDMqOHXTxNOfLYSoB5ZTAL6aEWX20tJTZCgd8B50U=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:22:58 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:22:58 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Raed Salem <raeds@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/10] net/mlx5e: en_accel, Add missing net/geneve.h include
Date:   Mon, 20 Apr 2020 14:22:15 -0700
Message-Id: <20200420212223.41574-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420212223.41574-1-saeedm@mellanox.com>
References: <20200420212223.41574-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR04CA0032.namprd04.prod.outlook.com
 (2603:10b6:a03:40::45) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:22:56 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fe133eef-002a-44af-4a35-08d7e570ff71
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB647811E86B81B62386639F45BED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:103;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mKPdIWpOIl6NX5nk8j6oGPjACNtA1nadBboCIIVyzp/oKGDwBBzSK6p8wCRCPu6An+aJiQ/jHljtMi73FAOyLjh6IMH3OgfDnjGqoxrQhM5abRfI9rlqzaY2uJYzEYy7n182DHFyiHDfIdGTM0F/CGCcSQexrVyAy8hH6Wx+9dJAXx4Ilb7P5jPIKO2zEEOf7XfGUewNH1VoTSq9UqZ7SL30QwRkJc7o5AiG5aoJ7lF6C2mSWJVcHIf+y2N2IJxOgBksT9XJ+/0jt+WD1JdVvvYHSdA6GMMDpbo/2gBhH13kWVGBWI1xUznuVKsplAPu8ufonOf5FdH9XortlOJ2JFEKqjwbuEMjmzpYL7qc32hKnlEBDXCqK6YDfW6bigpfDnMG1LP2rdWFYjBd/PuZC7vDgFC2FHSk65wu8rmfKUxAIl2OHmwCPrT3lmov24NjemCHb5s0d6vpgnF462PkEPSWFb/UpQMb606bsLucn0cvq/W2Wk4RrrzBkNdWIyCN
X-MS-Exchange-AntiSpam-MessageData: pOAQElZIWHFwUH5uaHIPG4ighaUOQvdO9HSuH0fI0e2R/p2V2JbeGjdIoWGGpgBENnf8qWBhpdJoNip0H3pazOw2A8bNyh2IH0zmiPsImPMSYFydqaEUbyMdTxyJJqHwTZjS37EImWQFbchym/eQ1Q==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe133eef-002a-44af-4a35-08d7e570ff71
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:22:58.7793
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1muqQlnkPZGPSw4QS0+/F/oBIUOO2EYzhXsmHdFBf2bnGg1GiZxo+xpNdO5C784AUESTYrIH0c5XnAf35m+RGA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Raed Salem <raeds@mellanox.com>

The cited commit relies on include <net/geneve.h> being included
implicitly prior to include "en_accel/en_accel.h".
This mandates that all files that needs to include en_accel.h
to redantantly include net/geneve.h.

Include net/geneve.h explicitly at "en_accel/en_accel.h" to avoid
undesired constrain as above.

Fixes: e3cfc7e6b7bd ("net/mlx5e: TX, Add geneve tunnel stateless offload support")
Signed-off-by: Raed Salem <raeds@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
index 3022463f2284..a6f65d4b2f36 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/en_accel.h
@@ -42,6 +42,8 @@
 #include "en/txrx.h"
 
 #if IS_ENABLED(CONFIG_GENEVE)
+#include <net/geneve.h>
+
 static inline bool mlx5_geneve_tx_allowed(struct mlx5_core_dev *mdev)
 {
 	return mlx5_tx_swp_supported(mdev);
-- 
2.25.3

