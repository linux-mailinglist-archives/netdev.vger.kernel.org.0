Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3675AD5C7
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238653AbiIEPJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 11:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238414AbiIEPJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 11:09:04 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2049.outbound.protection.outlook.com [40.107.20.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CDD57888;
        Mon,  5 Sep 2022 08:09:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FQ/dS48ZF+sDleUizOqwazmw2NHrPXzvChV8c4Jnz6nvkOXhxAbTpt+60PUuJqii2cdIeBe0LM/bX6jpy/wSP5g8hVsTnqIGtHMAG7GStLyBfXcCfJiTrFX1K0ZxkxWe8pzXGFSWE+muU1n0p/SCx/Nvk/XRaS3LIWsJlVeApZmMZEo2UGW4EHmgGmLmGars0aDAzhrq+0SfSAPFtp13gBQhXrWYk0NV0BTojBhDH5gWLI375U+Trghy/Irs+rHmMu6VZHD+EgRg7ltQqRxGxhINuSwiwpUsXU3B1MlRb3vGaGvd2WrVnaYkFeRyL/yx2wI8RD+vo6qU07YDA4tLQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SF20d+4VDknEH5d4tJQvOCEJAmkw1njeQQ+tUCS7rOQ=;
 b=FHbTOu3EsXDlDtS4kBN8CXi+bdTDxgvxYrFXga6qpTAERENJ0DR4XbHqAr49m/mjsD+8qTDTjAPJE0m7KBBwHZkXawIs0nQKvR9wJcgEX1KGFXFEfalO/5YXZNla3TNqDmIIcBBwtJWkwOemWydEzNEosftZH1k4Qj50lY81fzwaEbaOrPe00mjohQvnW1WzeCbfp5iq3GqKBsTxeSi6avolLKggbMrKpTy+nBG8db/wlF8/tBVMA/ky2PGiT4kNKDKj6xG+MJjw+FMNF9p7eALN3KBcdRkGismDbwkRzskX0/k4Ph7vZYqSviaqgTQe8SWpptZ6UCzxLcYV6rSmZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by DU2PR01MB8655.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:2fa::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Mon, 5 Sep
 2022 15:08:59 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::792e:fa13:2b7e:599]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com ([fe80::792e:fa13:2b7e:599%7])
 with mapi id 15.20.5588.012; Mon, 5 Sep 2022 15:08:59 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v6 1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
Date:   Mon,  5 Sep 2022 18:08:29 +0300
Message-Id: <20220905150831.26554-2-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220905150831.26554-1-andrei.tachici@stud.acs.upb.ro>
References: <20220905150831.26554-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR0801CA0083.eurprd08.prod.outlook.com
 (2603:10a6:800:7d::27) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 050cc7a6-6103-410b-0728-08da8f508f0a
X-MS-TrafficTypeDiagnostic: DU2PR01MB8655:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GzBa0fOzjFNDnJCyhPulBcJALnOb/tIZspY97ZxftM6tYabHGYmnsmJA3gyq9PE2fX6AWVX9n8ucjdvvEBzcsI+T4yXFEWBYfMCFocnLxX4ofVqUblt52WnnC2LCm1czKMOKAaraz+t4UQoczjeve/YI3gt6EvGN4BrKrpapcekK9JX2KyCTdSbOYOaXq+xfgsfEIP8IRyRea0icej7dR1fR/DmZlUlGDPhvB2vFoJ7q0MavXIIRR8Y1Lvbhe0byfGfICiE/J97afDUf+bWot0ddwuXJvMbCksmIvVwASKJVSIxwWlWDEZJfU+5dAsclUguKx41xgH1GqjoBxVtLqY/c8Y4FCG8qiBIm68fJRc1ZeSOgg6NGAIXPnUFbxQXDHLRNjdW/PYj9l3OxrhXUZUNlsr0z34EoxEOTjiL3InHwad25zITBL5tacLMTeTIAgRBFVwy88BcS+87BiIRHBpefCUOOxy7ybO0Q8vwOozKUfoJIciv0DRzlMvCkC6hSH8Z6Nzu7l5WeOI80E42iEUsjlF6MADiO+XBVyXlgDF4nZelcv+IF4tRHf47uwPHUvHgWWV15pSSxQ7/wXtaMElgO7PwhwUgb6zMIX4wD/T0wTCOGP2oWy+i1pdbObWm23cQ3WrJE1nJxNBuMTI5Vf4UCo7nkq9r/vhNeCG3ncv3uaII9bwBeSUmgkJFCCrClwneZD0TbB/e7UfU6KJJpxSx4feqrcCQryYpfsbEOcPpH9sk++2wZMxJ7B9+jvCXG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(376002)(366004)(396003)(66556008)(6486002)(66476007)(2906002)(4326008)(66946007)(316002)(478600001)(786003)(6916009)(5660300002)(41320700001)(8936002)(7416002)(8676002)(83380400001)(38350700002)(86362001)(38100700002)(52116002)(6506007)(6666004)(9686003)(1076003)(26005)(41300700001)(6512007)(186003)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?7R0YWCqkXSkEM7TmR0nPNuv0oLlUxymU32QeWEy2Rnx/w050a+/4ZKtBjHKd?=
 =?us-ascii?Q?KCJ1JEOSze1pJog1CB7gEukE8zaSpY96c464woLpxNZLIgp0CySujlbg6vTL?=
 =?us-ascii?Q?wFB0+RLzm4chCpF44MnuavwT0GVl5SrQZ1NkWre3H9iYoPONrNSje8QZt/0p?=
 =?us-ascii?Q?VIzjUnJK1ic28K/GDcJhV4L4Cf/VJuzQ0hMtPu240LUv3o0CZAhnSK8C0noR?=
 =?us-ascii?Q?cNZUDZbH0K/ToRTETFyyfuSO1OcRRKXitX3Ar/PPVjD4SpFwh/DxzEFNxKF7?=
 =?us-ascii?Q?DB+BJkl0ITUGE3pNYM4FEGI9shdrDTo+SIMfFIxBOpjiwt5C2v0yBRB6XvPY?=
 =?us-ascii?Q?cOoIpb8IvBFOd1w9i7aLYi00L57uZnb9Z+bsKpdk0/bPRNKRF2bi89rwYzBY?=
 =?us-ascii?Q?kXaFWAGBgee26AtBxBUUP/M1QLXL9eZrixR7h9mgQLCWghVUGYW9ADnYiOZt?=
 =?us-ascii?Q?o0SnuVQOm1S8WnUPDwF9lYEAA9xakK3AjRAdN+r+0NA6OZl8KdLUgIe7vR4+?=
 =?us-ascii?Q?DX1clpciUH+9ZpHXGMxg17+9OdrcEyNesnC22he+5L8fqrhS1S9hk1MgSh8a?=
 =?us-ascii?Q?UfTmXsDDbjOmVZw2vrFq0EMrXVjLvfHX5yUJOMUJIw5xgxeUxHL5vGeSZb2Z?=
 =?us-ascii?Q?mm3sKr9cusY7lm435KyEgwe9sydiqhCsaWl2Dj1GTPnaG2paCOe6krJRF231?=
 =?us-ascii?Q?u5rgCR58OenRKWUZFTcpw8CoAqjZA2ryWvr+Hcpc2Zm0plOF+2oaf1687aSP?=
 =?us-ascii?Q?6s1wDF1gU5qsahcW0p9ggNWRFm40zUBhf+IlLhb5DfJLusqkd9oWpPy75IeG?=
 =?us-ascii?Q?5QF2rkn8Rp7MqCanORUXde8C627ExqB8Z9tKMuVnUQIzxgp+7j1PyzRLDLGQ?=
 =?us-ascii?Q?hlKTBn0KZEhq9KxuWBaowroFsnWTwmtZvm76abc7aVPn98m0fNL8alB933xb?=
 =?us-ascii?Q?xjApyCmoRmzIlrIh5FIYVLn0yT8o00nDevvDvR4P1wRTGMefFsloa9AE3pKs?=
 =?us-ascii?Q?A7hwfWw2EsafpUdh8AuTz1oMJf0ENB//SuRMwgFbN85divE3N7fv1TlFNCNu?=
 =?us-ascii?Q?kyPI20Q8uw9TXAxhkCX7OYn0MeoftoJSZm6yLzwmBpKCcZMTJzq+qOe/iR8P?=
 =?us-ascii?Q?jNEnUfruKn/hCPuYCPk4/hDIioJwa+Qxb102Q0xWeh5oemldip40ylve4H6Q?=
 =?us-ascii?Q?/QI4RBahyN/17vnqjN8HiTsh06EloYsTZY/9iYJI9/+I79wWiCb3EksW5/Je?=
 =?us-ascii?Q?+XJpc9Kvk38qXytNbExu9634seVdG93TABB0KvVy4QCaatHRrik57iGoIh/+?=
 =?us-ascii?Q?mopyafLlRTXrSwRXmj1tOPyPGjTVyOAZVSqjk01A3cbhRsatgLBXdDT+CeQ2?=
 =?us-ascii?Q?XdhlUrr7derAMXN3PxCmvqBkDCUHmyt/mdaUwy57VRJGaB1+V01NSSdJOmAC?=
 =?us-ascii?Q?OvNf1+7+td2PEal1J4xX567Tf/OZ2j9Nii4WKZ03Ah4So11vFOJB+XM6/STo?=
 =?us-ascii?Q?o5HJo+7pH59hL+OV7SeFU9Iv1oCwwfg3q/7WKzH3cFlT0W8Iso0myf8ScGyD?=
 =?us-ascii?Q?n5P0dz0mDHhP/0w188yYWyMD1RMkb7qNkaGX7rstthWVU3/fUpouHqEXDITI?=
 =?us-ascii?Q?3olaLn+6cobQEOj3cIBojWA=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 050cc7a6-6103-410b-0728-08da8f508f0a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2022 15:08:58.8957
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: edSXgN8wAtiJcoJJooo62F/nl2A8wdcY0NUqxdwQieeM05256cmKonEepCrwEbfpnPo8i1SBsnHzl8heaQwiUDxCJSedZIvNlYH8GnIwt3c=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR01MB8655
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

