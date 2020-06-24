Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BA81206A05
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 04:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388201AbgFXCVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 22:21:18 -0400
Received: from mail-eopbgr60051.outbound.protection.outlook.com ([40.107.6.51]:63460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387794AbgFXCVR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 22:21:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAchqruAcJ9kqSrctJV5/7z/Ri686KJdMw/DAtyxQ0WvzubNYs0IRg+G3hTcDTDbXYCegoK76Yhx94yzNBVfdpJmlJCIiBcV0L2U5RMQpfy2o0FczEcLIl2h9V4RuV734X1KLYjgDGLyDpsg/gjCcTBwksetRNamkHZsxaYh1HqVSm4cK3x4/rVepdI27fuV/7zjgPX10wZKEqZwo5LZ3De8zQl7VCOsxM4vNRE6krsZkiKkWGtbqQmC6f69gpWeqc/aqnR/FthUJExiv4FiJREUkReN9W2xEOAwH+1LwQOqoxWlDPuvgPhctu5/YB+LJPvKCIp4fj9xoh6Q9SZ5SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=Yife5PkmbVL97Wh53QKnSTpYB+dDefMF4ysPppcoPOOdMV7SpPaa7SxaIStaKtffz4wBUWBwGlLAqgTgv8+RA3oGax9a1F4RsiSuoNbE+OI5kNZ8VR/6gi6Y4DbXONw7skygYU9JWWIlfWNIH8odfdofT9Ka32gT+kveT0NgDNKu48ziQC/DGUvVgA5VD+9jd18by00yHuOnaYENmggTLvaPAi5eDCW52seLtWfAquPE2AdWM/vEgeyyz1S08+QAw7kXXdgXMeLpfN2z/nPYwR8cXu01M2TOue3ohyZh/z9bYDQZ/0vkhHsB6Fy72OTUWRUvh+Uyc4tV650CmLgsrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=LunMUX9rKg7LRNrnWI2sJkyXj6ei3H5+z26SH32UKvlaXCnernr/TBWWbC1LwfaJiRaBdjB8qO4xa7G2R6SPPkwVs/nnrOreUIIBzDy//VBCR9sNjNsFz5aDwGy7Lv3KUlPF6d0GN/BQ1zR2mqEAbfDEsWpGJRh3TZ9pf/LPqNk=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB7022.eurprd05.prod.outlook.com (2603:10a6:800:184::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Wed, 24 Jun
 2020 02:21:11 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 02:21:11 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hu Haowen <xianfengting221@163.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V2 02/10] net/mlx5: FWTrace: Add missing space
Date:   Tue, 23 Jun 2020 19:18:17 -0700
Message-Id: <20200624021825.53707-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200624021825.53707-1-saeedm@mellanox.com>
References: <20200624021825.53707-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR07CA0077.namprd07.prod.outlook.com
 (2603:10b6:a03:12b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR07CA0077.namprd07.prod.outlook.com (2603:10b6:a03:12b::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 02:21:09 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d013f121-b1ba-4868-1fa8-08d817e542eb
X-MS-TrafficTypeDiagnostic: VI1PR05MB7022:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB702249C3595CC4383B07DA89BE950@VI1PR05MB7022.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LHWyQkJ/pdDsl/HX984633B08JZ/H1rMfENehWBxPf3hVW22Pd48SL9MMwxueOuZXgqGYBIY7NDDUiNDmul818lOicYud9VAGDzO6jTcn0zz8qKpSc7/G9KSKM7qe5ell3xtNrYlFf6PA7m6o5nvvUd0YZWFIpyTtH/c/kBbZyHoSZAzqqjcTh+iY2FtN9mkI6LHsBZo0PefqUeVKEJtssf382X51liiRX3Iulvj9MoYCXwS40NRiAyB5JqCZhEP47tQ39jvV4iMyBjpx62CTUsF3QJMVGC0YyvCoozQr/vszZWBMT1d4tgbCzeXbm4mziszrnXOfKCy5VK9VkUAh5u/nldWf1g7s/MBFUw7XeRWi/2ICdNCtzq6XU1gl1Gy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39860400002)(366004)(396003)(346002)(376002)(8936002)(316002)(478600001)(107886003)(2906002)(2616005)(16526019)(956004)(6666004)(186003)(1076003)(26005)(4326008)(8676002)(5660300002)(6486002)(66556008)(66476007)(83380400001)(6512007)(66946007)(52116002)(6506007)(86362001)(36756003)(54906003)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: FZyhLuDS0bz/dDovVLgon+ZZLfGoBj/egbJbAEutiE++vXbWUBZIw4FWWyWqp1k/aeWKtmmdjjcnPazuFr5JDHstA3C3edIdXgKhvpF2Gmt7sURlRigi4ESZmnWKrmieOdRnA295IHD8FmXfK3jhTV/c0yPyCl+BrjkW3qrul0F8uERaM3QwVpl1uns+k1otYui0ytLG5PPnBfaKcXlD1DwCS8boHv/WFq0c7WcGMnd0xMqFaIAlWvD9rRIhx9dzU1H3kNBn98MyTkil1bSeyYi8ZODBXWMFlxjqd0QlTz7PH2OSe5BFztm4H53uHnH2KZLRHs8TUTe1u5JH/3lZPa230xZNvk0SdoKxoJXOyIlNnmEP9VaXEkeUUx/m99V8U9cpsO13QHx6pFCpqH8m3jebQydTvRFvWwWocDnBdYRI7N6sNMnLsaIB0gwMz4ZOt7tr7oR7oS4b07+Ym08I7OUtersCma+ExRj15FRE2tc=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d013f121-b1ba-4868-1fa8-08d817e542eb
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 02:21:11.4278
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: it0cGLF2zn1vniv/REC40MzrPgmNKc3XWeaOifuHEst9+jDyLwc5XyoM9Cc/FSpOKObfiOX9KrrlZaLScOY/Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7022
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

