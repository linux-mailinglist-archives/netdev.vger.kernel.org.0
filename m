Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6C0205C36
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 21:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387523AbgFWTxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 15:53:08 -0400
Received: from mail-eopbgr20045.outbound.protection.outlook.com ([40.107.2.45]:63363
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387474AbgFWTxF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Jun 2020 15:53:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3jca+xwQeBedySrYM/DtEMH6qKBwzhKQ/AoDHzbvav4FDYPOSwp8fP2MAhP1Gj1d0+NdSf5LAY2DiZgz9rAL92qmoZQ0S5oZAom8/sp7WdImp9SmUfrJ1q1oRJD3SdHCYJor3Dye2n7XdsKI79M29lhjqUR12IwyednMgN6i9mHxsrVnUVOU6K85aOGr81OipsXjla4M0OmjtDlacfd3eb4h8CxfOvFYb18eZgd4lqW/iXq04i+d4ywfFhH3xG8kJrpgORlX62LhBAHFUqjVufsaOZmzO1Onn1pkvE+MJLDBqNFR8LZ9hYiHuvH1Ai/L0C1Ie9w9se6NutiRmOgug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=VtUWqTRbCd5d1pzFK5zIEvsFkg+VBxv/pcwI4YH2y9PjST/m9HKhHNabHf6dLYTofYlmHCcqSfYCNO6orQcoByP2NF8+LuFJ6hKKi0vyY8M4o3nUC1HmYW+dgPsB7D1eLnumEJoaIHlzzqUzRZCZVTHMVydaEmsIm2r2wpofiG8WK/vRy0967u966kwllNsQ8E8gvP+5iFLl+TPbwdnWHq78tDvlwsno5qSBS+WEJvRAE6yOD1ub6Qr1L03+NewNvE3huYtR0Bg5skvIFESk9SS6fG+tBR6q9y21YCRcvQPMl84meOBGa10l/8vEt//7VD+Bh7cjTSxUjob0fb/m9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=571NT07tMexOGWUDw9lkMSfLxuBGVsPtYDngHakIEl0=;
 b=ozH+VDEMq7tyjP6YxIpT2t+mRUo2sdamVtsrRSiQY07f1kgW3S3xWvRLJC0Sab5NMivd/r06Hi/QoNDSXpYQad4T7UN/02QrOyIIX+IGtVrdo86h1p5al/po55sZMsVmYfKSTnczldj01MhrGiVCQT/m7NxcEMJVxEPCLd7yXW0=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com (2603:10a6:20b:9::29)
 by AM6PR05MB4374.eurprd05.prod.outlook.com (2603:10a6:209:41::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.23; Tue, 23 Jun
 2020 19:52:57 +0000
Received: from AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5]) by AM6PR05MB5094.eurprd05.prod.outlook.com
 ([fe80::b9f1:d8a2:666:43d5%6]) with mapi id 15.20.3109.027; Tue, 23 Jun 2020
 19:52:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hu Haowen <xianfengting221@163.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 02/10] net/mlx5: FWTrace: Add missing space
Date:   Tue, 23 Jun 2020 12:52:21 -0700
Message-Id: <20200623195229.26411-3-saeedm@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200623195229.26411-1-saeedm@mellanox.com>
References: <20200623195229.26411-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR11CA0081.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::22) To AM6PR05MB5094.eurprd05.prod.outlook.com
 (2603:10a6:20b:9::29)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BYAPR11CA0081.namprd11.prod.outlook.com (2603:10b6:a03:f4::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Tue, 23 Jun 2020 19:52:55 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1d531298-a54e-45e6-0163-08d817af06a4
X-MS-TrafficTypeDiagnostic: AM6PR05MB4374:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB4374E08CB775225E834B5120BE940@AM6PR05MB4374.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2000;
X-Forefront-PRVS: 04433051BF
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yTC1phKevIhRvMxsdBzYFv4+OreQl2lm71fSNkMEoFDmgjPCdOQyPiQEIzIIQ9F5KHGcwf1EtaDbiDvJtQ2v/h0AMnefiHj+qZwwI+0Px0CLn02TiMCHye/8dP+JioVrC9tm5O3275Qs/I5OO6s75gxwC2/WVQBORnBrZJrz6UJ6Pvmf26k5klnIFsKjmhw9K1/32fPTdLbfn5z+UKKaDw6WVD02hAA5lY8s6fjoJGAh9/b+0THHi0JYuwfQQR6+0q2Fd0V3DQY2KxRqx+qN7W3p+fKJHx5E148mGqb75y5kYHCyidNLjqPubJM2XgnBJBvzPy8qSL7Cu2NXAczF12N5TucYXcLu7iMk1fwdB9hInoDBZKy1cD2SX4JWv52l
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB5094.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(39850400004)(346002)(376002)(136003)(6512007)(2906002)(26005)(4326008)(16526019)(186003)(107886003)(6506007)(54906003)(316002)(52116002)(36756003)(478600001)(8936002)(1076003)(8676002)(5660300002)(86362001)(6486002)(956004)(2616005)(66556008)(83380400001)(6666004)(66476007)(66946007)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: kG18qYhHbKVWKskBMMyeP3gNlqHNpr2pxKZSF2EHumO3pUdrE5A8Q8OViJt0yqnqe12QSAxHThCiLm+JtPfoCuUeNKKeYHWZ9HD9veB2ZRTl/uOfVlFyoX2rK+rzthnLbMiavaVyRzDX4bFfN8QlksvpZKBXezs8HGblLdgx/Gh2XQYjvG07HRRYyBNS8Wb4yPcilAuaw3dPB8Ov6OimHcpvq6TBtT0P2sbU0NMhjGmUCkh/c56SbqOHHmG4Zc6kZKEcZ58dGZeTxVqbyolLAWQjPBmVKrxoKwaBoUaTneGFisN0sKMB1lKE1OeUjHbpEaqb5v19jx43RxCkFzf0FAI6PjjWWei/rS65NY+AWiHOCpliFU+kJtEl/F61PGWOtm1VvQNvkvBUbXcTgsX6RyMr5XJ9rGRVDpybs4aHBgZvdL6Ps4Ji3HQFldeO/2EhegKYmASqjAl5Rctwgkq5eqsXPIDdGpgIjiq1RInX4mQ=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d531298-a54e-45e6-0163-08d817af06a4
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2020 19:52:57.4420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CX62dfLwdSoZJseBrLGkQqWpYIOk7YD6iEGDPVcI4SjDPRu4y5lXTz32GfdUX33eS7NfjyK1WHvTJBX51e2X9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4374
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

