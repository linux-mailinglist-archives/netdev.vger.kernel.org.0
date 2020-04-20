Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A18C1B185C
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:24:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728284AbgDTVX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:23:58 -0400
Received: from mail-eopbgr30068.outbound.protection.outlook.com ([40.107.3.68]:52910
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726056AbgDTVX5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:23:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMXnq2MelJN5NlHbJ7AtM/7xK/6iZ1KX8u+j64Ern0XMUrUPa3prCPSuC8vF+oF3z8yLbftQhbRVihgY4XQFJxhoyQV8pWqfE/yvWCu0Ws08VILgNiVsP84c+4mMqhI8Wlj+qm6sVa9u/O3I/CZfTKUrtBuctomGuKB7xoL13VwKFoFhMXh46nRyLqRE80Ce3KvoXGyKmOGFW//rUf0ZaluH7U4PNkKs9Y95WwlfQEt2XmYkS4EldHNpv+nex8BE/FrSGwRw5ayyLjZ4SCKEdGt3nY+tXNpiXXIK7eiyJ5Ly2DmhrOHiF7feFAjbqOYIX3KBAesWvFraQmVLF6Ycyg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6/knVzbPmrOFjfjjDSorwuQC49iwOEqKl+wa1qmOEI=;
 b=h1Mths269hSr7KddFk0XebJQqM/zZuEsUefetA7Jr3SsdJkourYWlSFjuo1kDGDjYrrpZsgbdHWR5RZpsyuRqYV5FYObbcW+817FwWHZ+yUYbkmFrOkHpV/3kGED0OYMUaxAMkoaevSDBEyKic8NNCU4q9KlP658JBaOg0hYC2ZdTVWn5Gj719ibwFZbDwIaNwklCfMN1+1+MVVZjcB463wf6C2Bc8RAgwspLxzEiUe2F+iIxJzjfb8lgX3QQINbfKTI/eFPO7iA/vb3Rq3Th8nZRULSzlBJmXpNkNqg36I+B9qHSnPJ6Gu07cnOBEflMvWgAXV0uto+Y7wg5H4VrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q6/knVzbPmrOFjfjjDSorwuQC49iwOEqKl+wa1qmOEI=;
 b=Y8Kj/LnVe7D4jLh5uJRws+3ETBf82OoKZJrYexuh4HirC/u+gTKl1QAH7de4VwbUshcfq47zkhxSHj5F2gjRxF9kCXuCnrZ2phnXVBxePK9NSJ+gTIZYrVS8GTSrAdJGNceSnZeCHhh1bpy8OjKqzSC0004ZjLZSF9ntHs7FCOs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6478.eurprd05.prod.outlook.com (2603:10a6:803:f3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:23:20 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:23:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hu Haowen <xianfengting221@163.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/10] net/mlx5: improve some comments
Date:   Mon, 20 Apr 2020 14:22:23 -0700
Message-Id: <20200420212223.41574-11-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BYAPR04CA0032.namprd04.prod.outlook.com (2603:10b6:a03:40::45) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.27 via Frontend Transport; Mon, 20 Apr 2020 21:23:18 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 479b43d8-f882-4d20-917b-08d7e5710c28
X-MS-TrafficTypeDiagnostic: VI1PR05MB6478:|VI1PR05MB6478:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6478C58BD2F4BAEF777A7165BED40@VI1PR05MB6478.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(107886003)(6506007)(86362001)(2906002)(186003)(16526019)(26005)(4326008)(5660300002)(36756003)(316002)(1076003)(66556008)(478600001)(956004)(6666004)(66946007)(52116002)(66476007)(6512007)(6486002)(2616005)(54906003)(8676002)(8936002)(81156014)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BQFjUKQ0d3gsQAf6fjU2nsJs9iqKYoprJmDfIIscZNmJlxD1rLpzpBoJCRmlgfQmg/1cYG7gWwldzE4B/aMmMLR+5TM4tU4Hb9lttfqeZZvY0IIDtw7hd7VU2LB9JzIMfUU1czdwSMSnvlVFnuruzjcVLJQe6xnmdpa9rGLZHF98PKJCYU2kemKseVp/v/E31n+DR3ZvWTwulKxgfEyDiWlmxrpldQrYOphqj3myyMFTu4jl/kdeKzBUs1Zp7UhLABh6YCvgR2rmejIl7qfNG9FK6rQKUA4sXxzBr+/MwaJVWwEPlu/GMAiq/yBAUqBM0cU7fJrEdCHgD6ljg3I3eEujKmfdplZDBzJey6ZmwcBTR9J6WsrZ/vvD0zQmWBYOZKDvOt3ZGCg+erY3ng9WxQPqmS8kNIfVNso402mN7aKkESsZgWEijKKOX3wlqbofhSzbZpSjMvxb93fK8s1FCU3HQTAGqntTcobUI+LnyNS/KaaujZUp2Bh31qAcbkO4
X-MS-Exchange-AntiSpam-MessageData: 6+HIubMgU9hVqfKtouKfiVZD5CFH25IDNKP3yk3r92rIW0apIbSr5pZK+UsETek7ls4njVLH7Koy99YL3kBMGCFl78RyjpSbnKhVCOsJJ/GMf5hceL8FrhWuVFGCCN5qedjG4cLH8SR9Q4JHMKjDbA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 479b43d8-f882-4d20-917b-08d7e5710c28
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:23:19.9152
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SOkB6vCAofUUCRLwL3aVBYqcKH2dLS13bBlZKrYg3qq3xW1typBUHq6DPo3UtGNwhrwz7ptbn9RZJ9PHg0D6dw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6478
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hu Haowen <xianfengting221@163.com>

Replaced "its" with "it's".

Signed-off-by: Hu Haowen <xianfengting221@163.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index c9c9b479bda5..0a8adda073c2 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -684,7 +684,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 		get_block_timestamp(tracer, &tmp_trace_block[TRACES_PER_BLOCK - 1]);
 
 	while (block_timestamp > tracer->last_timestamp) {
-		/* Check block override if its not the first block */
+		/* Check block override if it's not the first block */
 		if (!tracer->last_timestamp) {
 			u64 *ts_event;
 			/* To avoid block override be the HW in case of buffer
-- 
2.25.3

