Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 979CF206B5E
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 06:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388763AbgFXErc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 00:47:32 -0400
Received: from mail-eopbgr150040.outbound.protection.outlook.com ([40.107.15.40]:19185
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388036AbgFXEra (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 00:47:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TwAXUDBnQSas2FdHtjiZ7wX6U7yih+NN+1PeENuNyyHbn39z4AZqjOdD4ZjU7b/41nGAZUJT7CstTIRsW/Os+6PuFjurn1zGyKmhSjs5mJBZ4wZulove1skdkI96Gj0hcTtl+3ROMtjjeK1QBP03c6DE5u3AzF7EzPoyrabg48ktY0UJqkmVVu0Z4i1qvufXhFwzrn7+IMTark71PQXoHLH2Fm8Je7FUDL4PSs+DllqT3KMav/rddo7Ild2CWkWBgy6nELiqQ0VmILFAgcCgSc0/wwLFTe4eSff/j+NEqf/zKnc0O74NM5z9aesvU1+GY6KlcbvT/2Vx5/vHVjTmHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=eOJH0cvgWAqaKbuMomVxrak0EJSBdLa7NTJq/FLU5ouciMYYVOcw7ioSe89DmV4owAb+gIHFn+4m2WInytJTWlLIqgQGlhRVzReX2KBZ9+FmTSDwAu3anxxUt0nuQU7Zva8M6dabLgIO/pc1ZfCLmIVQplkwQHchodA4dTNmXorWqw0b0nb09xptfcPCd/ak+pbffD3dNlJB5cBzor3r3g0+2QpiFMQdAly0xqp7igOPuPCJyMKiKgh6H8HE73UoG/raZpz/TEPfq/r4lXAERyKDjODhtYvY6+f0QO8UrQdBUGolykMtfSuV4Rl55u9SJA2VZ+RgZm6rUIWfRHa+Hw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=CUQEWUJGTdOfiATHXy66Unihll3yXX3peG/T3pkjyHW92ButrEoZiT+6Vs/9KoisunQdrTOEV1MBN3Kbwn6oWng9jsso1KtIHcnL/aJG4Vb8HHJv1cOsTjGcU7ZXBiHsmCol4BXvEFvUcdrqJ6Y9vlGLIFJF/U2zUhGhJ5MpIIA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB5135.eurprd05.prod.outlook.com (2603:10a6:803:af::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Wed, 24 Jun
 2020 04:47:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 04:47:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hu Haowen <xianfengting221@163.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 2/9] net/mlx5: FWTrace: Add missing space
Date:   Tue, 23 Jun 2020 21:46:08 -0700
Message-Id: <20200624044615.64553-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR02CA0051.namprd02.prod.outlook.com
 (2603:10b6:a03:54::28) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (216.228.112.22) by BYAPR02CA0051.namprd02.prod.outlook.com (2603:10b6:a03:54::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Wed, 24 Jun 2020 04:47:19 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [216.228.112.22]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: deba3c29-8d0b-4535-678b-08d817f9ade6
X-MS-TrafficTypeDiagnostic: VI1PR05MB5135:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB51353114264B914AD3697FB7BE950@VI1PR05MB5135.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FthnLwKwrHL1Q2RyrROzQhAkDRN6xV0LCYRJJ+qDuhkVNOTfwv4VX3FJS5LwR9yxzEcm3VEHhNZukVHBLIqrDoR+8Y+e953Ph18aohtV4aWIWdnJ3YtTwYzcYK8XOoIo7YOEoWEfIpacSwtMjHXZLlG2RPknGQ8lDGbHz6JVy0u9r2I9i99K17/WnWDytuXD+KLpEqOyWEJsuG75tDMgwjTKQUDGWoguG0eQP05KNXfeR8InF3IP4MI5cyHbgOQo3uwhqYK758WhLDHTI6vwnke20YskrWt4xth1HuKOyMhTwnV8vk0mI0p+zBl2LG5++CxNNw6283Hn/S2raeQI70G+xAIl0u+25CkWkdR/t86x5oTUYJkeMCMoCFrR4YUa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(39850400004)(376002)(366004)(396003)(136003)(107886003)(52116002)(86362001)(8676002)(8936002)(478600001)(26005)(83380400001)(5660300002)(6512007)(2906002)(54906003)(4326008)(956004)(186003)(6666004)(16526019)(316002)(2616005)(6506007)(66556008)(66476007)(6486002)(1076003)(66946007)(36756003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ZRsiKm4T2oPz6UXYNGZxUY9RLLwPB0jbirtoaPMYapbzjABBSPeSU8M6zhd0kWNqGfxIcMPk3unKzSLiemJ+CT5XqQpi02UxSJT2D3Wnr7LTYVWvjQzJ8nNfgaL54t/NEaHo7+FybP+LbcK8ktm65eq7Xrihe+koyEnBuXEtBVdXjEOxNMOUhwzmMyFICh/0wgzpqNz+heEZP6N8+YyrosPBu0J44maWpkpRW8zsvllknuZb83Yql0sSmXRGiOAZsYSkySzdxKHhCRddz7/K11Y8w8H7fEUL28kJMf4CAY40qBK4z6RdN0fa8E+BAILEsXM8tdv9mPVoC2BQvf74pCm8DCC9WdjnBeNp2R6ahOOytV0SuSttjlmkOhrIxJNzHkYo1NcQ6W8HeoXeoaWOLDHT3CIjpEKxQ3Ps26mepgrXVMmkqIsuzzVBlt4yNY0ZDt5KrrQBBjXshK5pBBdltVF+uqbxRYgii8ey/qjOpXSXg+ELGcoVSafuTRElSSOk
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deba3c29-8d0b-4535-678b-08d817f9ade6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 04:47:20.9236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eV3ZtliBBJCJYpLa+tTVXUeK62Ayz12gJrUY55+MvKU6+9MnwCOjQdtDB4XJD/S4CaBSnyZw1i8r0r4aoiAtXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5135
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hu Haowen <xianfengting221@163.com>

Missing space at the end of a comment line, add it.

Signed-off-by: Hu Haowen <xianfengting221@163.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
index a7551274be58a..ad3594c4afcb5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c
@@ -676,7 +676,7 @@ static void mlx5_fw_tracer_handle_traces(struct work_struct *work)
 	block_count = tracer->buff.size / TRACER_BLOCK_SIZE_BYTE;
 	start_offset = tracer->buff.consumer_index * TRACER_BLOCK_SIZE_BYTE;
 
-	/* Copy the block to local buffer to avoid HW override while being processed*/
+	/* Copy the block to local buffer to avoid HW override while being processed */
 	memcpy(tmp_trace_block, tracer->buff.log_buf + start_offset,
 	       TRACER_BLOCK_SIZE_BYTE);
 
-- 
2.26.2

