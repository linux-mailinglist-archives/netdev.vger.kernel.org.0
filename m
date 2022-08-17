Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E254559738D
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 18:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240369AbiHQQDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 12:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240315AbiHQQC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 12:02:59 -0400
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-eopbgr60050.outbound.protection.outlook.com [40.107.6.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 037899F740;
        Wed, 17 Aug 2022 09:02:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b5Ryh9q+11szxoBbXhwf2B0fX/Elb6mn2CAs23J1J4hdYk48oaLEfwows6kU582UPVEVS4VMiT8oDQ319p+SVTX3k4KQlaTN3Wv/BJRU7Zgmhmo56yAS697VOC/S260FE/Hqs4zOopEuKWcgWAfDpX8eDPlwoIqmApQGOupyYkFjTe8exFSzplAXvmVV64AXA+zADc7RYOYTMH/4lIMaEn8OhTVU04Jq0kY8FkLtzeobpeT44LEjWSOuZiSAHjMcqq9qko7pWJabVDdxCXvTnQhxPOoFEzPcC7nplVpRXRR25RURQryINMGEO/99GJqc6Os8ew7UAdlqapmrQ/Os7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2IIC/FDvsCZG0SuQSAlEJoMEuskYRMGhkKu9i3/oHcQ=;
 b=HZHMFoHdJBjRvJOvSwB+JsKAWeY5pe6oWUEZICKGMbbZqgJDXA9IcXkS+byypkZowFDwcyktSa1QyZrkgpvYTeJzVtGuuIYq9bo2DrtxSS9pVYkczAr8VYvCV1gir9xVyTcBAzPtYGMpBfZ7SW1gW0F5Ksg4CZ8H86WjsKfi7Tm/1OQDpJYc5Zb/RwP4N+uZgPLMdki5dffbklhWzE82TQA2ISglydP0nxRgbEwddtwtolItvG0HD/h0h00htkofZ4iRju6tYetnk4BW8E1S4AHQQxtU+xMEJR9Zs27uyZ6VkwmDPT2FI6nHT/hNX3pkEtEm5E5YGicO/dUVHa9Ruw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16) by AM6PR01MB5734.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:fc::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.10; Wed, 17 Aug
 2022 16:02:55 +0000
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 ([fe80::19b7:7216:e4a2:b0b]) by
 AM6PR0102MB3159.eurprd01.prod.exchangelabs.com ([fe80::19b7:7216:e4a2:b0b%7])
 with mapi id 15.20.5504.028; Wed, 17 Aug 2022 16:02:55 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v4 1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
Date:   Wed, 17 Aug 2022 19:02:34 +0300
Message-Id: <20220817160236.53586-2-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
References: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BE1P281CA0062.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:26::20) To AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8a93da8-83bd-4848-11d8-08da8069f262
X-MS-TrafficTypeDiagnostic: AM6PR01MB5734:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Th0iZZUGrnva9fdRDmgWaqFThnY1AKS/+LS0zLqqS8NRbv7E68SqWyzctQcs6UkgIyDt3K9jR0QYqGktPi7ZShIIZTvjcnJ5hInNy0UIAP/nIOYQEuoKkeujBdLknCa6EIRLndW2UwFm4Dkmnextgao9OC3ky87kZLzG1QqXP4x+Fi4uJUoh9Ysn2N1Y7rtGF8hDYB2/fomQGThy55YavtOrN46FUI+MhZ+tOYqZKCj+zFSUfN9THE4WmAyDRS8LU0r+7tHxoiTlie3q/yJ+1pnH3hS5vI/ux/T6O6fgOKyCPkcf635ENBqxifQmZQxG+6+5qvsbyJAxICFNFklWFe/UPikkVmBRgDQVafjBt7Dxlsq/BszS2xOrDZII3hh0hFK+6JZko/qSDUmANrpj/gc+wDMbhUyIzBmUN5FC9x7w1ddSIv88Fd69OTiA07YijeJG2BY46i+EERzbpdLp+I6RHkUNO/jluCIXcHtuB5R64SaAjbAN5Pa8Iy9xkqsX2iIRWuvgCDsjwSplQO+zxTCV6nL9vYt/YK6SVGatf74P8A28BsR2I/KLhS0cS6pb0pq850lFbLOvr17w3Uw3ryg74hPCSJUWam4bEZ1WUZGRLW8W6jOYeAjpsl8vu4U7L4veug0vYT9XQDh7xqsgr1sTtF0TWkValdEiZ1VF8vT0ANVbEKM2S13RfNOfwavB1T6mHQ3W3uyqrXG+0s1TgfqfYiLkrrRDQVKKO4j1sto=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0102MB3159.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(136003)(366004)(376002)(346002)(39860400002)(1076003)(6666004)(6486002)(6512007)(52116002)(83380400001)(6506007)(5660300002)(9686003)(186003)(41300700001)(786003)(316002)(41320700001)(2616005)(7416002)(478600001)(2906002)(4326008)(86362001)(6916009)(66946007)(66556008)(8676002)(66476007)(38100700002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/5YwLK9woymsq9VlSLewWO2lhuO+pfsx200ZbGSV3MABxw+A1ts8dknskJv/?=
 =?us-ascii?Q?gJyV89IokQVMNwx9Bk9PFr5Y7avdCcjXw9G/lTkxjlkj4YGtfaF3ipmhnN/3?=
 =?us-ascii?Q?k7uF39hS/NnNxd2stE9GSlUIFwB+c0JMDhoSbOfDFmsr9EmXZ3AFGDJ/F5Gi?=
 =?us-ascii?Q?Cc5RJimHa0eMf3tiyP+9LFlRdOW2b5maBEvcBvgGM3wdXx1uPVeRFALatnL6?=
 =?us-ascii?Q?qn6IKAatepfdl6BeajeuYZfOn8VrdVjfkPG+HJFKkYxiTJfN0SVca0Zecyuu?=
 =?us-ascii?Q?1Q7/8OHvO/mtx6Tqj1pZA8iVB2N/mUE1HfJr/q35szVzhV2VmNFyZkjvj8wt?=
 =?us-ascii?Q?iGYaf0migftyslyFMhbM6zSByhTWCQL2raA5pbCdOrwqoF9XYbMo9talsRXx?=
 =?us-ascii?Q?+LljwD96BiMPrJ3/5egF25L4eqZ4T9voUiqU6jbVMnfQbgwXnCYqO41OoaDI?=
 =?us-ascii?Q?5ps4+UevTNyvBqloGziHHTAGQGJ2wUFQ2++YGj3nMEjpv1I1sJJC7tJhIRpE?=
 =?us-ascii?Q?sh/6wCNfLyIoIALUkFO1nNikF6IJL5stIWtlip3obdRpP/Im1+0Bzmo6fNfJ?=
 =?us-ascii?Q?9aL5D0ECIS//zKdhfrYesLM15x/b5xR+Lg8PRU5huYtTMUdQZmyS14hG9arc?=
 =?us-ascii?Q?dwe+CQoxbaoOB4DJ8noeX4hxcP12HwTW7VEhZzeMSlQJYT3m8aMXeuBZqRYQ?=
 =?us-ascii?Q?H8/ap65PcCxuI5onKQHGEVtytabI6nB3j3N5KnV4Cch9iYVtVTmXMbumbjoZ?=
 =?us-ascii?Q?/EhrudD1ZTyXjf0p+MjxnD33uNeF82QbF1rncR73JMxEKqbsy1MgREV3kxqZ?=
 =?us-ascii?Q?R6WRviAIqLqxNBie86TpXVDIOWCkbsWV5QMwSafeAZraEAMYJJOLH2UqFoHF?=
 =?us-ascii?Q?eXWpZoCXOvHH5IHldtcbTkgD35LnHO2T3MfxeYDWfHvdZQrFiPhaZwzQoSXP?=
 =?us-ascii?Q?MFHIREs4KeXBzu7ySPmmZxEUkrpRsMr+urqz4ra4uSSzXMeNNqvlUp82/5NY?=
 =?us-ascii?Q?sUemOE04wVZE+HWeSishfvy6Ng0wZlyH1bvXHbmsp/HxI6g25k2XNwhdPEFh?=
 =?us-ascii?Q?yF61iIRTw+xzQPZ4BHb3OLj9dgg00kOA2lgS4UTL26ReoLIWZvJHpEdlqkgR?=
 =?us-ascii?Q?G/4ieMDR9xM78aNDhCLYSJ8lIS1vHcK5fe2zYv4MiAhRgNuVPHOPkcxF+yyh?=
 =?us-ascii?Q?BZ0t9qH7xOkcY6MiIta9N8ww34gO/HtCp6+BrSiWQzJsIXVefPeHQhwnA/Pl?=
 =?us-ascii?Q?I5iUGSVDs3bDzmuUnXHwAs+ioOcDc1qtgIxQ7QXCQcRFeKUb7GsQ7rYxOSAF?=
 =?us-ascii?Q?DRzTHmNGEzw0l8GA0PiJ6/afTfHTRAc9mKnlvxKkERS3a1PkQLwogMsccoyj?=
 =?us-ascii?Q?sr14qIM3Y0ZajuXesEQszG6qOoXHWQjQOSArqr7z90FORxdT1CMxTgItyNpW?=
 =?us-ascii?Q?SvXUMcwpQxO/hIHz8901FepNPOFZALFBgkShRnaEmz6p2jzZ4e0O0btkYqH1?=
 =?us-ascii?Q?lgQEC4aoV5rZllSndn+zRhQoZKAo/sonoX1FTAwtgKyR652/cwwi26fkFmwk?=
 =?us-ascii?Q?yjDsNI1D1f49KQ3dC100ZnHhmImUV3d6X0yo6r0/wZ9ome7dnpF6pu8Ev9Wc?=
 =?us-ascii?Q?LH4+sumbqHtBgfm3pj60zEhsyV/qFILkgNQiuMt9l+MyEMRGMYU5HeMc8FcC?=
 =?us-ascii?Q?dpgLiw=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a93da8-83bd-4848-11d8-08da8069f262
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 16:02:55.4499
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2Hsvai8WDEHL8+ZY5lpoLB32qWGAkkdpJOBz0IsZiRgUHh8NBc+D91NlGzFO+yI/El2pEuBurJbd3yYetQQlJHf8rMSUy1YzbX4Efq7T1YY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR01MB5734
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

