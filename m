Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36C9416F4DC
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730215AbgBZBNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:47 -0500
Received: from mail-vi1eur05on2054.outbound.protection.outlook.com ([40.107.21.54]:6064
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729949AbgBZBNn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kpMSGBYsBf7v6KUqOwBvbIyd6TA6UK/yxbFrMia8pSZUgmUFRsUrZqa6TAmUe1B3t+veetG//nZwpGmZS8XVchTi/zXq5xX+nWAp56HEfHNZNrCiDoqXYwtVlEfQoUxEkqsZ2igmqZqo2t70S5IA6PiCendULmvM9f2vxFVSuXE26fXuJHhg81gLvsufFqJFm7JLUqkEl1sHZagGkXrYkv2wJsaVWzx4DvPj7STGgLz9/1aZlY59CooCQSwlIP5Sv4wXDv47LtD75THPWITjKE9CdAYxBykwe280Gi4dKg2z1S14RMPSHS/AvWayq6j0w+2rDNF4QTDb/A9KjTN4/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vplJ9TpOaFdUP4dxeovhN+W/XRGA6PwN25sqHlTWCWg=;
 b=iLtJTCIzrVmzEzVLugefHft0tErHfzxZQXQPjEze0YggjQw/kyHZvJu8reJcoPpQk9Buhp5VHPitTBM17DSBdPtt5vAR/1AONhe+WRjh6cXbPZetvUPEWtHmI+OlUbyXODyoKh/n5HdlpClqSOSfsmfUCQ5RPGs5sgKtxmcl3ahP/Ovy0COKbgBq+K/dB5i2QSA/ABjDHMXQ+9lavkH+mCKwVL8p9kdz3XgWqvuBpogsFIg0/OpHNdIABPyqrCyRUzmqTVoQBpLm1824Jj5I5PducKGVGFMKb7/s1ua5xZjwZITtB3McFIAJJciVxuiid5od9YkNJHvhLdJ5+YpBAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vplJ9TpOaFdUP4dxeovhN+W/XRGA6PwN25sqHlTWCWg=;
 b=nFRvPHzBjQN6ZwdkpYZwQbZP7eikh7mz7dkZZ+d077LtFhOqXcIigiGK4iR2f10JKd1xvsr2nTHWGwrAQZ1jNxu9Rc1Q0YqmDyIwYvWkVxTsKZlLUYAZCikBziRAL8hQIK1abFuHQa6Ch6CjGk0HEF3eS/9DDz4Br/gY72VJ4m0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:40 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Hans Wippel <ndev@hwipl.net>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 13/16] Documentation: fix vxlan typo in mlx5.rst
Date:   Tue, 25 Feb 2020 17:12:43 -0800
Message-Id: <20200226011246.70129-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:38 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f051aa4a-9de6-44c2-9c3c-08d7ba591cd8
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB58690BFBF52ED3CD56C3A2C3BEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(6666004)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(956004)(36756003)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mVjsmm/QZg47qZAuMbr3D/MCyb1T2qJ44hIJ5NFBorRHegJwtXKkCmD10jEjaCxgKKLgcSnrC9TXsJEYuVv0S5FqQlvblswo99G4bAG+Sa99w8FGCQGEb45MdMi7HssUZK18Bvq7gClUo7s7AStbChw7JfrLcjtyBzYzn/c8IvwCz7vy3zpfIQkzSTQ/ncUxenk17PnlLjf8tJEqN/tM57LTJgzuiAhKN+KJDsFPsvjzjbkr+EeZt6T+9q/Tct3NqfNEPbJApSweEY0tH479zkmyXmJ4kss7SyfRTuRgrOiz8D6PGXR7efd2JAWNVajMG4JPyD8NmcRiMewW4Yb0f2YG9zcN7dRCjjMzjattZ6M8iDesmipahdacDqhS79llqmybmMaCS6MHvxY4fqpB/LIEbB+M6hE+VsCZiAMKJqObDTHvc0AaqHl36csaU8Xte+FzY3JHcypvetar7QCAJmMm9rynAuF+yP2RZSpKmlwyATS2f5b/7RsVVZ/30xNkBsnDl/xiN3tYbvoKMU0X5SOTMHb0H3JWcTrlavQmASg=
X-MS-Exchange-AntiSpam-MessageData: 9w8ffESIA5VjAtTBU1KGi3/zI0Mwx/oGALZF/3XJuDELNvryn/+3bFAyi11ehRJaQVzIcIFTESb+k/PzX8lJWXXGXQygz1UqW8Ce4+boMyLVr4KEDgX2WKbMrnh/tEoMiQ+3X/QO5SpHUflTFOfbtg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f051aa4a-9de6-44c2-9c3c-08d7ba591cd8
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:39.8955
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L5Nn3j+gyETCsSLtqpwI7RJycY2ctSm7FAyDvX0/xPnaQwO7Wo+GLhr0LXffPMqAnSWjItiEd1Z6MzJ8idEb5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Wippel <ndev@hwipl.net>

Fix a vxlan typo in the mlx5 driver documentation.

Signed-off-by: Hans Wippel <ndev@hwipl.net>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 Documentation/networking/device_drivers/mellanox/mlx5.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/networking/device_drivers/mellanox/mlx5.rst b/Documentation/networking/device_drivers/mellanox/mlx5.rst
index f575a49790e8..e9b65035cd47 100644
--- a/Documentation/networking/device_drivers/mellanox/mlx5.rst
+++ b/Documentation/networking/device_drivers/mellanox/mlx5.rst
@@ -101,7 +101,7 @@ Enabling the driver and kconfig options
 **External options** ( Choose if the corresponding mlx5 feature is required )
 
 - CONFIG_PTP_1588_CLOCK: When chosen, mlx5 ptp support will be enabled
-- CONFIG_VXLAN: When chosen, mlx5 vxaln support will be enabled.
+- CONFIG_VXLAN: When chosen, mlx5 vxlan support will be enabled.
 - CONFIG_MLXFW: When chosen, mlx5 firmware flashing support will be enabled (via devlink and ethtool).
 
 Devlink info
-- 
2.24.1

