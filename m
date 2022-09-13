Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C205B6D3A
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 14:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232091AbiIMM1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 08:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbiIMM1I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 08:27:08 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80043.outbound.protection.outlook.com [40.107.8.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B2C18357;
        Tue, 13 Sep 2022 05:27:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YLqRf9ZYWWbaeK5yaBP2JkGaHUX4wxb2P3KhQWC/fewRcL9+5qspCzrn0O6gOnN+sRD1FRTchfrMb+aEUMBep/yqVwbORJMRrLTV+XGRLvBi9lFq5+4Ceg0sTQ+lCGJdUOrfOMAKj0gpwoFOXAj4ajBgbfrp+heQJZ8F7/aJ1ofBjp1k+fv9m0IG+9GoborC+Ru83grMwkwSCBvaoJTQtGeGfFv2OOogvBv470AItV2MjJKSsT4rZ+cWihfH/ifcKXB+KTRj+65IAaSKFGD+pYt99lsHEmLCbchG1/yVuHqizOzr1a4nxk1z1Rdwr+Ts4I8Pqht2uIO2o91m3C1Opg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SF20d+4VDknEH5d4tJQvOCEJAmkw1njeQQ+tUCS7rOQ=;
 b=GaMXlvGAC7o+R7MHvGNDXFrcGYhUz9GCjzGhPApVAe7iwiD2llzUFuHfbEOyylDMxjOEnqaAOhiKEhik1bJJLMOO9TogFGzCOTgle/JCOaZRJ1oXcPTqRMpegVvzUgF2cFgczlVqVAcbxRngp2qAosE476B6OrBBD7TW2DbG4XRje1ICIzkHZ/luFqavFLOnG0wP42sTaQRd7BuZRNS+zco7F9Vii14TUZtu7tEGyPlvd8QRf1uQ9togzVnxiMzcgDPd3siVcj/dle1AlXGodTMMPwD2bpVm2qOPxyfWOPQYtfg45WPVeoEd6PiPHjEVCa3gMMktg5Ky9sBMYuf8NQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by PA4PR01MB7421.eurprd01.prod.exchangelabs.com
 (2603:10a6:102:fe::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Tue, 13 Sep
 2022 12:27:01 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::1829:8b89:a9e5:da36]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::1829:8b89:a9e5:da36%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 12:27:01 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v8 1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
Date:   Tue, 13 Sep 2022 15:26:27 +0300
Message-Id: <20220913122629.124546-2-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
References: <20220913122629.124546-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR07CA0287.eurprd07.prod.outlook.com
 (2603:10a6:800:130::15) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0102MB3166:EE_|PA4PR01MB7421:EE_
X-MS-Office365-Filtering-Correlation-Id: 9176b36d-4f0b-488a-5893-08da958341e9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6eQb8OzNWoANwfdTiCdoJHSK6Sp9LVVHS8m5vWUzCsKT5TkqK1AWRIaAzRnjRr870cmVtFJYbG9Pav6kUpcCFz4PYFRRyCetqx2MAB2x5bpOtf3AX3RinFDqlbwS1LdOI3AkFRyCMe1z9h5Y1ISwdWTeV7gMJmQhrCYSu5jnJuwxWS+PVzHnaWVw0Tm+lpc25pfH2/pgdCRXYKgL34sy38m3MTheCneTUIkzd3cqQ36vRzH9xHYzd4HTa85GlKJdsGjiFh2z0Fl5likXpgsJifTLJBtb0wLpPg9basgB0eamdbtiwpxRPjIvG20zYsd4qIMXMuBWE3KmArIdpARLga6cPdIaVZO8xxQ9nYMkrx3wHeMwiEUilYL2BB0QL4r+E9pn1ogwmi0bJrpZ4E+TGvDEiNv/2FZFzfIhrsW8FnoqVLaZMb0fcbbMtz2Mb47Ip2g27xrMm25Hi3cbm0yXR1lg4zEPeGRU8MUkVb1Ts4kJOetgPULy4+9dMF9Lll+EEx9Piq7tA5EsTUUdVK2L064heYo/jT9isnk+ttmaK+2qcDcute/FgPETsTbG/VfF2aZUOKVunUkXmvLSehqbIkvJvqtQxXNIXyMK0Cqg0080y+rBuRoxf2ZcrlKkIxvEZtkomP7V1eWPJ+soaoT8znoHSXh1Z93tawrpnWLTrxQeCY/J0ih365xO0+FiyEk+ly/sitwdABBB8uA+p+D9Je+EMGWqxh3O7uIIW0KGziFOkwI0uRdBPCvajGfYt+PJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(366004)(136003)(346002)(39860400002)(451199015)(83380400001)(9686003)(186003)(2616005)(6486002)(1076003)(8676002)(41320700001)(6916009)(5660300002)(4326008)(6666004)(86362001)(66556008)(52116002)(6506007)(66476007)(7416002)(6512007)(8936002)(38350700002)(38100700002)(786003)(478600001)(2906002)(316002)(66946007)(41300700001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+CKl8UWYCTHQZ9uQlC4kPoLByeLTUi8MOfJ+U1XMPlEEDjyEAJRSk0XPiLim?=
 =?us-ascii?Q?j3lswNhmMdOaPIA1He+2d81iGyAcpBKY4JGPU/OHz7sUBifbKnIrGCCc8PPJ?=
 =?us-ascii?Q?XdLH8fq210p5SoBx8XZN59eSV6TrdvXAco/QECDFKaLPqiZOtx3QEhlUFYnu?=
 =?us-ascii?Q?/QRqYc7qGJDsz+UPbDoPvguwu85oHXoBDvcwsk2vxYxuUqkZq3hcPgZzawWE?=
 =?us-ascii?Q?PCCO9o/NId+9GPnc9lay6bvLSRQi0SElrdptzZOUvvXa10+S3iUVOwtvOtlX?=
 =?us-ascii?Q?qSp/qSvemPeR595nIkNPACDhF1dG5srOxl+BA5jeOsSf4NPPUnPMiJcX5o+G?=
 =?us-ascii?Q?wsFyQRm0cTgpD4xVvOm1ovp62WK+pGF9bQ/2GczzC+LvvOlKAKdvg+m81IXX?=
 =?us-ascii?Q?1TldBsUM3AVbwYtlwNhy+eVp0tKOxSujaYbIayBt2sdAS6yYVVwzcphvdDyc?=
 =?us-ascii?Q?rYopsWsdcItX14ZewoiX6I7shwraiLia/7ffqGZkka/xlCQxl2gEvxboKA1W?=
 =?us-ascii?Q?jKXabY9u8cK0Nn6Oak2N8QeotKW+cVEucgwlmBKXpBM3mEx6syOp+teidyzQ?=
 =?us-ascii?Q?2mSkigNlBgzltT/L/rGLEHRV3XKPm+lyUEYCtjpCJlLrKBGs26bGgiwQLoOO?=
 =?us-ascii?Q?mKSZSZAJVQw890ZIeNGjEngGTu48RqX60mtmkMWdCkNsDJHHGHdHUOWKRVbC?=
 =?us-ascii?Q?bhqiSUK54xdr21GNo5KlRZxygpleCs/7/gOCLew7gqUerza2wnyaiX11/36x?=
 =?us-ascii?Q?ZPhqFJA8arJAyF3oGxngvKYPkEZzftKkxYCY5SQMGpCAfBlp64h7KbBF22YJ?=
 =?us-ascii?Q?wbLpzmheAuw1tELFtetL8reDolwqUp2J3lhX7dLufEOICl5o2QiihOvPk+v+?=
 =?us-ascii?Q?Ldm1ge4Z2xLNbzcv56WH/34kDsRXomV5c8whpOl/Yw4oNMRyeOeaVmUdmA8w?=
 =?us-ascii?Q?er1fkA4kJG1WCJvfshIZVUgxyiMp4coGN12jmkps73twySa7FPEfenJvhkyt?=
 =?us-ascii?Q?nb/rlQXidvY/uC13ax1VgaoVfKCHUpa2PA8CqD9s64vDlBoaKY8T64aQ3Lgz?=
 =?us-ascii?Q?CyXnSVnF2Hw09fmQynOLDf0ApJLRBF3Nu1xlLFYMtB5nuMuSYVV6aizWvUiD?=
 =?us-ascii?Q?Lde92if8kLL/JXPj6KCjp29A02/cuJi5We85hF8xZ55rpnIvKvlhULcK1kiO?=
 =?us-ascii?Q?2aGkSIsGWfjidDHSSzTnEQyoKAW4xmbUKHNyr/+mVVpRcMoY1qcHwGjDF0g0?=
 =?us-ascii?Q?Az6yzsTRWG7aQUe7NPl+LqV7/HfwYWvBIVq+g8tmLrH9A8sqyvhRNiK/qcDV?=
 =?us-ascii?Q?on188NH7dU1puFZRpCeCqBBtxySqPZBE5vk7iuLCDGPOpdZYI36QG5f3/MDg?=
 =?us-ascii?Q?4G9+Dp07gyxwnAhfUP9tpKQHwYKOSV+BrYA4Nc1UQnupsO7dRwYjLZnxYBLz?=
 =?us-ascii?Q?dQi+tKNbZ3n+Wo8RThR/LsfVRTjCZq80xJUV9J3qAdcpjFpRVn33jPCLGZ46?=
 =?us-ascii?Q?f3yd6M2EMxgaKS7qoqRUa3eQuh1gYrY7D/LxmidLSpgGcq3bRnNEGRqHZkfD?=
 =?us-ascii?Q?RyHKFYIiaNySgY6AQmH2YuNUvoSBs61UvW3JV+4hh8Kf7g7Ljzop8yVOebKe?=
 =?us-ascii?Q?QQ=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 9176b36d-4f0b-488a-5893-08da958341e9
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2022 12:27:00.8068
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d2wjSt7hhBw9vevhTq4kvlvIXzvNKmZ09iDapRu6Tm20kgf4w/RPV6rWe9wGdI9O8uZDgcYiMkDKQlR3pxu2ttPllMM0HuilChx+zFv5zDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR01MB7421
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexandru Tachici <alexandru.tachici@analog.com>

Add additional PHY IDs for the internal PHYs of adin1110 and adin2111.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/phy/adin1100.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/adin1100.c b/drivers/net/phy/adin1100.c
index b6d139501199..7619d6185801 100644
--- a/drivers/net/phy/adin1100.c
+++ b/drivers/net/phy/adin1100.c
@@ -15,6 +15,8 @@
 #include <linux/property.h>
 
 #define PHY_ID_ADIN1100				0x0283bc81
+#define PHY_ID_ADIN1110				0x0283bc91
+#define PHY_ID_ADIN2111				0x0283bca1
 
 #define ADIN_FORCED_MODE			0x8000
 #define   ADIN_FORCED_MODE_EN			BIT(0)
@@ -265,7 +267,8 @@ static int adin_probe(struct phy_device *phydev)
 
 static struct phy_driver adin_driver[] = {
 	{
-		PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100),
+		.phy_id			= PHY_ID_ADIN1100,
+		.phy_id_mask		= 0xffffffcf,
 		.name			= "ADIN1100",
 		.get_features		= adin_get_features,
 		.soft_reset		= adin_soft_reset,
@@ -284,6 +287,8 @@ module_phy_driver(adin_driver);
 
 static struct mdio_device_id __maybe_unused adin_tbl[] = {
 	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1100) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN1110) },
+	{ PHY_ID_MATCH_MODEL(PHY_ID_ADIN2111) },
 	{ }
 };
 
-- 
2.25.1

