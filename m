Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B92587F9A
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 18:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237215AbiHBQAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 12:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235161AbiHBQAG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 12:00:06 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e1b::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40630BCB;
        Tue,  2 Aug 2022 09:00:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b4UZ2mNPMyh/RkhL6q3UrBi+kkKLbSP/peiqEBzmUqj4iWYayWpnfi271bO8wRFF9DJmpZcd+soxhAQj+2+6N1fDV7ydXCzwKs2MqV6C6RJFhtoccdsfLyWDMcJG92vnoxpU0iXc1YsxHolvElaPz+HJd8UCmpK77ipxbW3A4PKrQBXP6Njr0PEAEJGJt4YqN9JbOVDmRQCsYK5maC2GjDY1xvI/Pt3MND+BifSKcYXy6ndhhuiEijBDSh9La1t2f/T+s3y9GnpbuPXmbdxQYB/IeggFN5wLR2qdLx0+8oPfHotLLg7IMNe2uWlefnQ1laIuY1RXkCGG8PKFHFEBzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2IIC/FDvsCZG0SuQSAlEJoMEuskYRMGhkKu9i3/oHcQ=;
 b=JmuuvApOy9ijTR5wWm6tfKWMSOzll3NeeJNuTn7J67znrvu+xJ73Ym/VgPmJVwIg8Nrgzv6mKvZKy2+TbRZGkUn6f/8IMNaQ5do39j+mebBCEjL17MvwA2N5/unWXBuSsis17JBLM26AM9Qxtr4kLX1IcIR+H1BeYMyd2imGPRdZI4Cl4Hr3lxA0FUYqvPU3yBIXTQo3J4ziBsdf0kHHBJjHQM5kz7DpuyI81+InDCVX3qmhkmIeIOMcAQ5h0SoEgrHK1mLtWNN88wrnIHd9Xvr23EnPG2vP2v9W93o+ot7VWJcZTLdH+xGPOLOZ715dQV47lR3Ckw372DVZ+zTSDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by AM9PR01MB7252.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:2cf::18) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.10; Tue, 2 Aug
 2022 16:00:02 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::85e9:83cf:765b:ca12]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::85e9:83cf:765b:ca12%5]) with mapi id 15.20.5482.016; Tue, 2 Aug 2022
 16:00:02 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v3 1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
Date:   Tue,  2 Aug 2022 18:59:45 +0300
Message-Id: <20220802155947.83060-2-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
References: <20220802155947.83060-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: FR2P281CA0009.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:a::19) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b083bc4-c2fa-490c-e8dc-08da74a00efa
X-MS-TrafficTypeDiagnostic: AM9PR01MB7252:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2Ze/C9+w3D6CSoOz81ZN5rLn9jBQJMVG/KUbZBhUcJPR4GpfWtp5lVtlEUVu2v0nEKUB72vsGBnPXADtiEwDo+qe4ze0aStczIx/yRe4fuD/s4fSCIk+1Tz8XMa+QjTeqcIbL/9puoV0mCzbMLQacSv+As5ROmt6wapkuaZCXSmuZgf3W2Oo/VnoQ4qCS3b11YykD9AjujIZiDNKuOdErfDSCubEgXn1PWAUOqNGU0lh++HpFpC6b7jcNPnLYjCcPiPQgIMSbRLF7eAAG/Sb8nmCtib4V+Kx8PAIZgS4LkOHEgZa8x5TAat9/YSKE45rGs/KKagj9/T224MtyDgaskvqgWl/EFwpwD7eDiM8LwOp+TigYdOKXT0pErRvkNM42kBusRqRyHJVxbf3D1/fM0kfM5NgK/vxNF2PsHgi8l/r/eWazKmuDqB2SfKg3LHs/FDZpatXj6+JDmB1m6Z11D20djAjblJ8Wkh8qUbJde/peMvVuYlEcMNeFONZzWAQwWxR7s8OSXmP4WRCEgV5exl9IE8jlQTbwyjyWel5skdDYoK+ptNTh1+fBgF/37a7zNklWgwyUnCJSz5gM3Ewv40JOC7k/LLQDd7/Jy7WBIfKzbVReV/+xjbo9FubUTYm13OE7zE/2PK/8NkA492J7o16HjHL8sjxtldE/5VtutFCI5za0iWb0OIw26LK+kG6ECBeYrEyjjYGrvRjb9044wbdhi5gGKuWRW7dbj5urPM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(366004)(39850400004)(376002)(346002)(136003)(41300700001)(2906002)(2616005)(83380400001)(86362001)(6666004)(6916009)(52116002)(6506007)(1076003)(9686003)(6512007)(186003)(38100700002)(7416002)(6486002)(5660300002)(66476007)(66946007)(66556008)(8936002)(478600001)(8676002)(4326008)(41320700001)(786003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iEp69fWHmknvrKi/EEoizBKUJSxZZ9wzDo75wJz4JIgIcR43+zGzVrfTyJ7K?=
 =?us-ascii?Q?Togzx03vrV7eSuT96hM7pm/qsI2EQ4mPOjnGIFDmEgNAnLuj0w47NGEqOD1C?=
 =?us-ascii?Q?beNEtkK0VZpoBiSS77Xza0VSGuiV3e5l29LZAOCCNxGkIkY08mUcVzjCUfVo?=
 =?us-ascii?Q?JGYniK1BdhzY9cDYzlrU6YllBSuTOFitDOT2iqPy34W4vSRUVtDgQClAlV+4?=
 =?us-ascii?Q?YPHgvdiUNbbaCvXET0o0suaghLQOTmuNl+viUdfeGj6VjGpnl5oCMVA4CWpf?=
 =?us-ascii?Q?AfYHVSLRMcwk3q90yuiNPJUXLPAwqR7jh4j3atMXMYjrw645s7E/+Yh1Qw0V?=
 =?us-ascii?Q?Mzu6r43PjhoOSgHphZOuFrsudQ4JDU2oCUXNiBkTvk3F5eklcZi9qtPGrx4k?=
 =?us-ascii?Q?kURMO/nKzlQwknwBdkgmIL95AJ8xmgso+7iO75DKqCAlWcIvGcCHGu8iWUUw?=
 =?us-ascii?Q?8hDtsf0DrsvDXtnnRLGeZa+WRAnyH9jSQx0taNge9m3/GNMBxUqONq9MwUmZ?=
 =?us-ascii?Q?mJZY4aa8h80BTeQC7YBXQZvG9b6RqGkh/c5F3xAEI1ovXrd7I68PTK4ue0Wr?=
 =?us-ascii?Q?myYQxa71xNiusJcNGkQvlxRJ1vKWlQjjLwUkNaDv8kjY5AzUQhVlpPQV7uur?=
 =?us-ascii?Q?PzMdFVKd/g4EzbHYqw2PtmOjWq0nd2740DAzyDyYvUpldpDYwGfVxjfbFfc0?=
 =?us-ascii?Q?awuoK8lDfwyP3NLQfuHhWxoC6/6H2EL3u87Pamd4J1ons0/Z/V9J4XpLlaiZ?=
 =?us-ascii?Q?MTnFSU5zmN/4pwuLFGSvqnQ/Yd1TL6l7+eIcUFo+rh6CnuGe7DszGrXLwUh8?=
 =?us-ascii?Q?JQ2egiF16YnSd6M1VSmNP2C3/dg+kfliWVchbonlGIG8uu4Vq6LLrK2q8mjz?=
 =?us-ascii?Q?syfLFNDWWR2DVKBkYg3I3LlQ1gbsakobIBV2BPUad9iSRFuj0L8aapbwOZxn?=
 =?us-ascii?Q?yOAhlH7gBqFDVOv1FiUWfPHU2xQZUDIafHGXsnlCYIvRdNYtknEnWdymYxge?=
 =?us-ascii?Q?1vWSrD28/PhXQWPsA/y1VJG7WmVTK3kVwlgYqLoa8fbZGt/UKcTHp5AeZbUs?=
 =?us-ascii?Q?RErG++4hsPrS7eVgB4xm7aamoz7vcATO1WyHgHruWgzOZ4qKijKoiHGgGly7?=
 =?us-ascii?Q?3lfnIRQEdUiFoVluSR9io6oBEeclIZknbeQhPzAUHFV5ZFcNSWYEUYheJYEh?=
 =?us-ascii?Q?5Gf9IC4W47bvLbt27O3xrvgXRp5fQs2EZLu7wcJPAYz6mE+rrLLPEFvCVyHt?=
 =?us-ascii?Q?zOlNhzq1vWcUaU8bTkIXnvg7X6ULFn2U+PNc8s6zK7McM+UK5SkrQFn1MhVy?=
 =?us-ascii?Q?vxcM2Wu0kFb7+W/evOv9fHIKgJmoBFWjPWQ19Jj+hcoe+kWQKB33DlE7H8on?=
 =?us-ascii?Q?vl2dB0ib2+9zExkjubptYeX56E9qN7+UXnfjZeMErbUttt7GRB8VQv0Ajt4P?=
 =?us-ascii?Q?8+tkGi5ZsqEqNHkJPP3ubp0lNbMmBDP+vxeTOj0/bViC1U8ecJWW2L+ZLr1b?=
 =?us-ascii?Q?BfgT27JECcsULoOjSj4urQhNIALhJVmTb7SKjHrIs/Lyi0mPmFJtaTJXgv0m?=
 =?us-ascii?Q?7iCvVCfJ+t0KJNUxfwcaYtowfNLBXS4CjoESr5yMageNBMyk+KsSIVledORH?=
 =?us-ascii?Q?sC1Tj6ULHGnoxk+9u2oWcHWWeoAlWqRE9gOdIleXRie6deUL6+99wlW4kicI?=
 =?us-ascii?Q?c8YjhhO2rMayILXcalj7C+ws04k=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b083bc4-c2fa-490c-e8dc-08da74a00efa
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2022 16:00:02.2822
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /RirgAON+PExcA6RmeMPIVLGHRUMbnJ/VqKH5DfQcLY2rB0G25REHFQXIqNZCHkc+MkU86rivzKRutiv53F2ZnjDtYQvOivo9LR9RAyYBB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR01MB7252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

