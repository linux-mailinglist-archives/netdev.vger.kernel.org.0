Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8417A20A672
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 22:14:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404916AbgFYUN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 16:13:57 -0400
Received: from mail-am6eur05on2051.outbound.protection.outlook.com ([40.107.22.51]:6061
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2404386AbgFYUN5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 16:13:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDyRBo18RWzPN198F6M2p+/c9zyeewqeVbyGYbDcPe3WcrZZkI/txCfPXJa+aVz5KKAmQfVxR5iu99JWHjLsrAlYADkQfBN41AkiM/emfK9qTbk0htAs2SdjzagyVMmh7GdOr/34b5RSexpq1WeHvQC1Jjyc2DFi4RJRU1nPL5lFUYPGJv3jSPN8Gr7mfWXI6neUfwT1VkWx8kuE0xzGb7tHFyh2ZXix7Etg6Z4WtSyXI6TPUMo5QHvH29gspTJD99uaumLCpX/FoK3lBYW3CljLH+GpS1tvDKIOK9g0WFMYkxQBf9eygC6JanL3dmOkrBDixrVZDmgZjNopX5dfHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=KAljc9VZwNEMs2DsanzkaCP4YOlhoNZXugWxXi5+H1wuXNXeaSpIw35qaoNp0uDTl05nMtOppIP5jAJI9XJU2HbrJeD1Vz1kDl5Uoe6S5LiFQ/eJQZkJdSi74gofO871k04SoK+zZJ/SaMGFqlXtEylty7VyYiLwFMqwLjyZHnFmpDJ5sI8qe3wdyz5TAJ2OKEd+4w1Izx+R1KGSkBDja6ekQuEZSJMASHOqg18dOhTU6u/yfdQLrqTGPZq7pjUSs+tLg5VN3IrQ7OKzWW5KOtj4dXSVGMVUbUCPEyHcm1v1wvky6C3xGP8vqKP5qcHfJ87/b1hy3h2CQ3S+qLRgEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=Swty/C63KPrhetGGOdige0ylfLnH8Amtnyf3Q6/xrx6UjG2qkazKl+lGQuaGwiGd89nuYgAv7xnUEVbL2M3bRn2L1A2YSfugj2m8UBT1ab1vzjsx3ZBGxzi5/ZRkwrz4WY29wGqhA0LIz7C79bZ8gYGinPXGVugZpui3Xc22eOY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0501MB2448.eurprd05.prod.outlook.com (2603:10a6:800:68::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 25 Jun
 2020 20:13:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Thu, 25 Jun 2020
 20:13:51 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hu Haowen <xianfengting221@163.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V4 2/8] net/mlx5: FWTrace: Add missing space
Date:   Thu, 25 Jun 2020 13:13:23 -0700
Message-Id: <20200625201329.45679-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0005.namprd06.prod.outlook.com
 (2603:10b6:a03:d4::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR06CA0005.namprd06.prod.outlook.com (2603:10b6:a03:d4::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Thu, 25 Jun 2020 20:13:49 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d135e368-9cca-48cc-13d8-08d8194446dc
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2448:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0501MB244895B1172F2E6A3B0D2388BE920@VI1PR0501MB2448.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rhQnvyIyQmFs7jPnyiKOOoTBdoZYlM5s/cUTyWD1bfvg9dpT0S706YCVVr4aCFYb6ZoO1Py5wTVG9UBulY5Mr0Xi/POxYTkuXnwbz6Hq4G6zn8Aa683uOsNpPXzPoDCjd/qBpOxDuJhyHRAR3umG3RMWOfWrYoq7jDONgcknSLFQliUyYhTW9ebH/qFXPbuyoLvWwTBG3DgF6jWFnRob6XD+tcWXa758pW3FVF7s2ctTrbduOVeVAXVFdcAI+yKyx8ETzDr6K4Q5JBrM+I/pH+Qk/qUjtFwqgruceSdEbhMhuGZCcRw7uVq9MBVZTrnnCV8cbA36LRWsTs3ASy5B6HHyY9SFnDsqLXjc73s9dd8vzOda0wJ5CCa+MaLVCAXD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(376002)(346002)(8676002)(4326008)(2616005)(6666004)(1076003)(316002)(956004)(66476007)(6506007)(186003)(8936002)(66556008)(16526019)(52116002)(66946007)(26005)(2906002)(54906003)(6512007)(478600001)(86362001)(6486002)(5660300002)(36756003)(83380400001)(107886003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: oVZTxmeg48g7j0TzyiF95AELnUl+uBAnwk9FgxgxoTr8s8sDKJeiaxwb13tq1Ww8gtDs3eFMS+TsqbDeMHj3tlPmGssLPj4R77DGDZvlwMrAWaZoqAf7O1clSAq0NNInP9DMy3z2AzFw8ctgHF40KMNspkqGRgytYqglYoqL+ELH7aOoPvgmCbudpUadcnochJOVfYcHXEJmqqsjmOxJFLLdV0CqXantkXnZEJFdfNOR/TqmfgRZrxZyoSvHyOSUvyZIisu658PRXoWcnIFWdYMRwOytcyd4sb03tqA9ZI2CgtRi/rh4NLvRi1daLNO/LA/A6Cpy+GVjroBNsoMEd+pcQvTOyi/yz80CDIrtuhZPHgg96E1whSuwNRcrkZneyvrULuzYW4GPvweR5aiTQWmr+Cep5vwUji9XpUL5O7Hi2oPqhIba7KOYE5kE8wxZaeeqBTlcKHMWxWkx/OxuBwUSnUydD6ROW0NuoaysiQw=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d135e368-9cca-48cc-13d8-08d8194446dc
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 20:13:51.7539
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DPN/bXU1Hzl45woipfghtbNNr9MEv/Ac2dWAy4BltRvVV53VWWM1uEHVxCsvW0FXh3YCaSwsgkMrubZklcLbpg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2448
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

