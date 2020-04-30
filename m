Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501FD1C03C5
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgD3RVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:21:07 -0400
Received: from mail-eopbgr70055.outbound.protection.outlook.com ([40.107.7.55]:6237
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726757AbgD3RVG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:21:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hf5YkIiSJyjB5NSc9AIHG21kxnFit+95LV6h5H4i++5o12KebrwXyUp0kZfq+rhA8cvBXw/EEcHvxMa9Q32h+JkUaulSHePXVL/ONGE59Zld+zlgXZrKTF5zAzbbvZKAnkLPIyTTbElAoo43aGR4rfblc3N4RoyZ6IRc0WnnNk5FhNWV8KXXO+XQjnMU5KSboSDLCqYdWbeOSEAe8joK2UVMBq/yt74IfQemIAOaxkM1pUiSr9Y6kPaRCmjrEGTMsEFjHVRDYx+9zDG5DuWi/87tZEjTM2Jkyzj7CzkxPQN4tdv+RhfpXMEJIQkLHZta+Jjvz9e0ldkUnXTk5AzEVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdiQMtuIr0+GyCfwDeueu8/M/cqqt7BIbXqY7XaAuMw=;
 b=VZlsKRPfMMkxavDeE7i0UwwMESh2j3xZm4g4DHu4s1/6LPAchAGl6uXSZya/Ui9Jr/A+4bH/N1DT/hbYtuBfvOBch3ntdmLogFhxVAYsWx2EMxEJ5ISFDv28pezXLYPDSprKrVW/FORLb8Ap/Ypw/zdlurHA7S67gzTDsa7FT3sfadSdKuauiVdLqm5XIT9uPR2qzDnKmz1z9s6y7REZi2AWC3crr5Rh2tXUdyoHWjvU5gYYUm3tAaRLcj+eF34buPa/G6qxL/QaqH98lwllEtghS0lX++fk6ThT9zNJm4ujz1WwS/FgFWJi74MFnfzfbc1Ab8BNE3O3Gf0jPyA2Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DdiQMtuIr0+GyCfwDeueu8/M/cqqt7BIbXqY7XaAuMw=;
 b=Xb8xvxUVqN6/PJpZxXORb7Pw8TlvZ/Pt4wkvYrOqI3akDyY9UDaO8y8/+54rF61heQsk4rojUOfXeMKANnWcRu3E09q6gY2//YtqKr6uMFp7+cTIbn3nuMLJsYr92FsoGLyQLvCUrovgBMwTCfl3OzRsvj4KDNMqCaBCRfmvK+8=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB3296.eurprd05.prod.outlook.com (2603:10a6:802:1c::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20; Thu, 30 Apr
 2020 17:21:01 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.028; Thu, 30 Apr 2020
 17:21:01 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Zheng Bin <zhengbin13@huawei.com>,
        Hulk Robot <hulkci@huawei.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/15] net/mlx5e: Remove unneeded semicolon
Date:   Thu, 30 Apr 2020 10:18:23 -0700
Message-Id: <20200430171835.20812-4-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR17CA0030.namprd17.prod.outlook.com (2603:10b6:a03:1b8::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.20 via Frontend Transport; Thu, 30 Apr 2020 17:20:59 +0000
X-Mailer: git-send-email 2.25.4
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e57b4f0a-ff0a-419b-f631-08d7ed2ada97
X-MS-TrafficTypeDiagnostic: VI1PR05MB3296:|VI1PR05MB3296:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB3296B16840BEAFD9667E3ED4BEAA0@VI1PR05MB3296.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:229;
X-Forefront-PRVS: 0389EDA07F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BdDRI+IEM1Y1+lK+94TdrV0/v4PmYY0loMoT2JuxNHX9pMGJmSMly1FQKWXfqOTOhIeI/fDBBh+3Fo82ax8i+6+YckRIKljMqqpXeNKQfYkKpCiVALdRSyXDjQQedf3VXXHZ++pgrPDGv/VfG6fxl+k5aDTB0f31aDawB1lo4QkcYC7WtHtZ0c48lIh1+DWRVbsveHappFLRvmJfv3wnsjCcADXH/HsmZgTh+x3rd4/XX7naLWFwsld3CWSjM8GN0dOkjR7udr3eGGIEdkeOIOw7ycpX6/W18lbkeASkZ8fRndbiPdz1ZG6gMcgoNokI/L8FCEnBhJxRwQx+yQ7GnCJkGl22uf+Hnxri+gdyqn0Vuj96q76T2dZS/yW3cZEvLZe0KecJLSAYwvPY+fwrnCarW7mjNOqDfZ4Ra7rczPIoP5x30x4zufSArU8Xo+gVGIG4L6y6HElAmcV59UiPlTlUZ1iRiEohu+Wj4bmGPpxAxIPx322e2hG05DVZjvlI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(52116002)(6666004)(54906003)(2616005)(956004)(316002)(2906002)(478600001)(107886003)(4326008)(66946007)(86362001)(66476007)(66556008)(36756003)(6486002)(16526019)(186003)(26005)(8936002)(6512007)(8676002)(6506007)(1076003)(4744005)(5660300002)(54420400002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: rigC25KnlmxZOZw5hlcAgrIXl6uUoWXxa1cfinMlznVRidrvj20Tf+w50tGF2U+P0yhvHBnKB7N1upBCsSSB8G3AQS5Nq1vrX9aYJFVMJVtzmfqCLg5nYhnCZ6orgpKmRj02bMEe5TTWTL6KN3XNiuzxOFEDpqbHOaOe49Dbf3AOHjNBSODLhxQFzC0n05qdSNNwNrKYg+e3NGGQKNGthG1ALpNqeqhNYkYi+Y4jaN/RvP2ljqXO3VbB2cwuzsbUONDmWsoUnX3gzinyEKgtwU6qOvvInrW7rBZIZb/1atl9rNfiRbV9R1L8mjpUPOThzKfFKi8CmTrZeEZ1VhIualT3T3iSxC1OaznQsSawtxSn2QlQsFK9wu7qzDMQdyrJnLINmbrNzPtqpPVlZD1Si1d63Ch9AnfJ7Bn+QT1+tKbr1zvq5wgogTxb5VTs4IFC+IzKbe43xKchrSIuSuFQnIWGO80bfxpXWNUzXvFl7MaGLkwJpJtyDvTj17GZaJeHN1+iv8qtjoMSZsXdAjweQtTiuZu+1HP1CzSz3K4TePBB/oADQjn1FS+1OJNWveiQGz9VAYriXLOcCqmgjqhugh/9cv/NIgrhCLCgKg+rfSay8ll26+QC49qtSX3T+XKJWjhTADvFpN83jv+BMD1+iXkHPTV2Q3hGjY1uSROISWFDetp6fT5c3l8/uarIaZLAKGoT7NfOGRYxOGRJecY20KDa/Bo7Uarwu8srGyrn5z8SyQZ8g1Mdu82rKxWiAS16iaXVyryPqDaXhnlrwrDW4m3lh2hEfwJMWTxCjJLLE0g=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e57b4f0a-ff0a-419b-f631-08d7ed2ada97
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2020 17:21:01.2993
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uW5CFxiFpEcpdtOwntvvE8/jtCl+vMlHt5inaYR5gBkMCMfy1ekX65VsOfCHP9eIioxGh8B/2QsRsvpWWVvzvQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3296
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zheng Bin <zhengbin13@huawei.com>

Fixes coccicheck warning:

drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c:690:2-3: Unneeded semicolon

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Zheng Bin <zhengbin13@huawei.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 1079558d292a..77b3f372e831 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -687,7 +687,7 @@ mlx5_tc_ct_block_flow_offload(enum tc_setup_type type, void *type_data,
 		return mlx5_tc_ct_block_flow_offload_stats(ft, f);
 	default:
 		break;
-	};
+	}
 
 	return -EOPNOTSUPP;
 }
-- 
2.25.4

