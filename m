Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCF911B1887
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 23:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgDTVh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 17:37:27 -0400
Received: from mail-vi1eur05on2059.outbound.protection.outlook.com ([40.107.21.59]:19937
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726392AbgDTVhY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 17:37:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7FkN+nfOLXpZKjXeXqMGRjASlv3DbT3khMRBucW5wWSeLxKp+6Md+JSrw8c2j4eUWZvV7MR5fAKRpF+6MpsendJmAaMrHr5nhbZBteZQ2eQWbONKQ5NEQrGvECUtitrspLAjOPz4vGSeQzSylp4MJqxkaSS0zP0SfwqgiF2yaKyJ1RQ8LFhRdkGbbVcq+Nj+Aq6Kdba2xA7nRXkXK+dD6MyM9FX+mjxmUuH1cAKzFZxMeNyIz0sqUR9G3yP/Plvtxs0kVtUJ6Gi45aqFutgKTO20zxGL35yf3edLlx4Tesb0kTdBLzqWiMd3MYt83+6ltrXnhlkg7r0GpDeslSpAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLAtYCs+Rxl73ZfmKuj9sJV7WiWfec5d91RtKkq/mjg=;
 b=OeVcOECeoXTXpDDbk+WVOgaRpZYIjwOVdnh3UpEAnQJbXkpa0spMWzL79IryORzJp1OMEUnr3dAxmaVWGutDe04uTD2W/8Yb8mMS2GF46u4rzdazksRlzYG+1h6dBMCY4euOWRegBTT2gr3S26ldlsgLWrv6IYgaFvzmyIxw48nOYtUjNEwDQq6q/6p4yZpXWa5dP/FBwjM6DtfVIjiiqjQQhezzXD9CwxoCb3K/LSuw2+0+2PCBPaOrtvW/RrdxdmK429r7kEwtHlOv8jUuz4eBe6vRzYIid8BwN12RA6zrX2funItgZk0t1jWpfu3bCaznfcB78p00HiuTvIfYKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XLAtYCs+Rxl73ZfmKuj9sJV7WiWfec5d91RtKkq/mjg=;
 b=nNaqxq27G9iDE167siy1D4hx127FvFFB1lDrOHW/zWPe8pJxBuYfs4WL8SMtQVBjT24CTXnfkB9DqcesMjAQgj4UojgN4j+5ORhbLDC9VjbImt9MGnC5IpVA6FZNAV3EoKAlK6rwViMNGK9wnBbHKa1YkMig8tcHnoWkxGikoTQ=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6509.eurprd05.prod.outlook.com (2603:10a6:803:f5::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Mon, 20 Apr
 2020 21:36:49 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2921.027; Mon, 20 Apr 2020
 21:36:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [net 4/5] net/mlx5: Kconfig: convert imply usage to weak dependency
Date:   Mon, 20 Apr 2020 14:36:05 -0700
Message-Id: <20200420213606.44292-5-saeedm@mellanox.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200420213606.44292-1-saeedm@mellanox.com>
References: <20200420213606.44292-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::30) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR20CA0017.namprd20.prod.outlook.com (2603:10b6:a03:1f4::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.25 via Frontend Transport; Mon, 20 Apr 2020 21:36:46 +0000
X-Mailer: git-send-email 2.25.3
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 48b71065-d68e-429d-1c71-08d7e572ee41
X-MS-TrafficTypeDiagnostic: VI1PR05MB6509:|VI1PR05MB6509:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB65099DF1FBC3BDB13F341508BED40@VI1PR05MB6509.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03793408BA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(1076003)(6486002)(66946007)(26005)(36756003)(6506007)(81156014)(66556008)(8936002)(6916009)(54906003)(2906002)(52116002)(66476007)(316002)(8676002)(5660300002)(478600001)(4326008)(956004)(86362001)(2616005)(6666004)(6512007)(186003)(16526019)(54420400002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O5VoMszbkLNsqJlBmr7hhj7TXrKDiis3vtwVsRCJQ3V7JnhoNW9GiaidziLeVrrvaYRmKQJsIF+dg3Px++m0apdJ2euEmhoEPPJN02wK6WdbOvUjhwFXZJ4GFzwCTll8MjM4704dpWhcg19+6X9SsbORb5zBKzOecgLtR9Z/9vHgORxc6Hq5yYJJwIEjxQXgHfKLkWPOMvEQ842r0H2DNp0R9Bs72IgGI4RgwiZBLD0UJwDYSbk32exkiAfOw9Tdt529EaX4Vtk7FSszADPhMmgvpyJwB91T8Wc6ZPu9YiTIjoh3Zx6TkwA8N3cHrqaZCnGYnc4+c5+w59uYrdGKSWo1ycp9v+4IK9e0gk1WIylZYmMd3s0nLuNgZ3lEGyBKDt2kP7APBiMWbo5JPEWpA4irw1EIt2dlg0P/ZrJIBpLMq6Q6AXvHiYTSlpCNtMa/SVkTeXA9hJdLdrdt1BPY82KgkjyZjuZHsfX9ySjz0cpAUVynxHv89/HCOlNRSzjz
X-MS-Exchange-AntiSpam-MessageData: mcsJxbsO2J1XOgNOUMeBd07wK11u/4ZGWQ5daOIRfeuWI56X6D+Hb1y7ezoIR5jRnjsrp+0WwbFTj0wUZuxfsLuW6q6i6fhlVgHO2k6PfQMSn9uYJxR5NXTmkud/5mFVl0NLEpxlY5b93hpMm/eHTQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48b71065-d68e-429d-1c71-08d7e572ee41
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2020 21:36:48.7478
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4UsGYTp6Z5hhdvi56nRPyye7Zqnm1bfffBQOhtku6Jgl73ON5wKu/dBSh6xklZTXXpg8MH+nIBxY4NMT8fHbwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6509
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MLX5_CORE uses the 'imply' keyword to depend on VXLAN, PTP_1588_CLOCK,
MLXFW and PCI_HYPERV_INTERFACE.

This was useful to force vxlan, ptp, etc.. to be reachable to mlx5
regardless of their config states.

Due to the changes in the cited commit below, the semantics of 'imply'
was changed to not force any restriction on the implied config.

As a result of this change, the compilation of MLX5_CORE=y and VXLAN=m
would result in undefined references, as VXLAN now would stay as 'm'.

To fix this we change MLX5_CORE to have a weak dependency on
these modules/configs and make sure they are reachable, by adding:
depend on symbol || !symbol.

For example: VXLAN=m MLX5_CORE=y, this will force MLX5_CORE to m

Fixes: def2fbffe62c ("kconfig: allow symbols implied by y to become m")
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Nicolas Pitre <nico@fluxnic.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/Kconfig | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
index 312e0a1ad43d..7d69a3061f17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
+++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
@@ -7,10 +7,10 @@ config MLX5_CORE
 	tristate "Mellanox 5th generation network adapters (ConnectX series) core driver"
 	depends on PCI
 	select NET_DEVLINK
-	imply PTP_1588_CLOCK
-	imply VXLAN
-	imply MLXFW
-	imply PCI_HYPERV_INTERFACE
+	depends on VXLAN || !VXLAN
+	depends on MLXFW || !MLXFW
+	depends on PTP_1588_CLOCK || !PTP_1588_CLOCK
+	depends on PCI_HYPERV_INTERFACE || !PCI_HYPERV_INTERFACE
 	default n
 	---help---
 	  Core driver for low level functionality of the ConnectX-4 and
-- 
2.25.3

