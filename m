Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6B6172DA8
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:46:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730559AbgB1Apz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:55 -0500
Received: from mail-eopbgr130059.outbound.protection.outlook.com ([40.107.13.59]:43406
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730250AbgB1Apw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVt1PV8Yhwmj9NekIgnJsTqs/cwkE2UpbGalj1Di0Q0zDpBx3CrZ+vSu2ldAA2eKnsJ3vYAFPfnu3Lh10B/bucx+QIjTWDaeiyNX9V46D4SpdtsLZEO5+q4tcsmTB64WFIz8cjETmHjiUEUnJggBQYuQfLynKLFpWSqrYEbA46BrC1NZtSnAVI7bAIeiM7vfnQuf/fNBt2K9RWrNlhtJgm6rWygAcGMD+SEydBzzuswhqmfMRUp28wK4FGw8LEqkDtwhcSlwNEyF2YKoEb4NmqUUj02onh7LMdNWdnYoeDQrKNCf/vgFH33vm/3POl2R2MN6B3hTNgdZkmedEoRuMA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9R1PnBW4nnUmh9khkFpLnYyIYZ6ZFzXdwHByotbWK8=;
 b=S6A59RgvBENdA66qWIHIZ28fbWStVTV04mNzhl+YT/Wdfh48kIckVjkzisSqkMhdo5A2kkzgWlsHa68MQnCdEI9FWum0o6rnG7gChUxg2VdIChrvDK3mDU2MY/wSBnCQyGES9ktaqv+0Nl0ZokdOw0IBRZ+Jq9gilAdT4f/yk2cEMFE0UI9Kcr/ipcG9g3UwGYjI/owAyydJqahAFZyEBqKFpxC3PGOfZFk2v3SZlxSa15pz2XEUQMbefcQ74x5JxuytCBwk2uysv4k/U/q2+ILFQ+mcHOUdaqZr4NnfzARDYCq+HYokduREGtl1iz/fQmOujGaB1qR7tweISC5b7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n9R1PnBW4nnUmh9khkFpLnYyIYZ6ZFzXdwHByotbWK8=;
 b=kdY2E+SZoWAQinoYtCJoHmNvXkt2SbenT0L13WTOHR6KK3vqMS3QzL/Z7LmxCdItRl4LaDmQ2eKLpyTgCECYEYeswkaRiaR4oA6zTktjNhcrfN9dZ/hHrc9ozVoNv2dBqjWbA4CxltQ6XeLAm2/i3pT1jSHS2uSqdKE94N3+JFg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:44 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Eli Cohen <eli@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 16/16] net/mlx5e: Remove redundant comment about goto slow path
Date:   Thu, 27 Feb 2020 16:44:46 -0800
Message-Id: <20200228004446.159497-17-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:42 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 620970a4-3c50-489b-46ea-08d7bbe78ad2
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4189A0394207BF702977323FBEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lMH7j7xURCxUN8F/989FZd2sb7QO7OMcwdYh2uqXN5xdaKLiR4gmzIShGk+3FdD2FHsq6H/q1a2w7XEUfoQmqOepNYWaABUZSj26czzLgfmsbKNefbVS0wNoeou5wekZlO/0aPresdusP7OJpmrs5TB65HqvXxuwHkPc9C5jpehVmAghqIpLG0ypSiO8BTcy0UmkPaLTKl/HkzybWFvqpHBF9TaheMYItCVKIZEIjg3RnL8BbBePCxBZb5bFBsY7Y+fHzyZ0izk/taDOlcEJ4+9L7eZIRXeVxsFse61QAioEHD8tAOeXR237HPkjWMT/VWlpVT2EvZXiVE5jSC+exNeaBuATTKusgHFPni9QNYrLixfPwuIMYfQbAoWmiQKqBJasSt3y8jZTJYLmiZqwbrERH0sjL3GpTe4fa6LmP6NAxMiakzGKbAuGnbsq2jnWneObUuxgAVgpdGu9dNmuuO51hOV5/rnk8PsaTd//cmXdGCb8kflhJ8MOV4uAzfdOeNg/P0LVnJ3Xexk2v5MvfqCLktf1qYHOnX1LDfp0SdM=
X-MS-Exchange-AntiSpam-MessageData: KdamCuTJK+UZulVmqc+fn5/QAuMFytPcHjXT7mTjMfDp+mOLcuWWrpY8E1QLr53sH1I+f20XLTjejfd20gwgSBm+7BiTYsCRO9XRg3FpskhQHfYweDQol11n0Vfb/KwG80TBAwt5C+DgVDCsWvRrUw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 620970a4-3c50-489b-46ea-08d7bbe78ad2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:44.0738
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dXK3lGOcRROlvHvl6D/sUPnaYNZTBwf1BTvrIpHPEbVZDhi1UF57+BUalSlr36pFlSsBE+rQaO7ZKZVWOnJNLA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

The code is self explanatory and makes the comment redundant.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Eli Cohen <eli@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 333c3ec59b17..4eb2f2392d2d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1241,12 +1241,10 @@ mlx5e_tc_add_fdb_flow(struct mlx5e_priv *priv,
 	 * (1) there's no error
 	 * (2) there's an encap action and we don't have valid neigh
 	 */
-	if (!encap_valid) {
-		/* continue with goto slow path rule instead */
+	if (!encap_valid)
 		flow->rule[0] = mlx5e_tc_offload_to_slow_path(esw, flow, &parse_attr->spec);
-	} else {
+	else
 		flow->rule[0] = mlx5e_tc_offload_fdb_rules(esw, flow, &parse_attr->spec, attr);
-	}
 
 	if (IS_ERR(flow->rule[0]))
 		return PTR_ERR(flow->rule[0]);
-- 
2.24.1

