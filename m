Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1181599D7B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 16:28:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349519AbiHSOUG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 10:20:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349376AbiHSOUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 10:20:03 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150047.outbound.protection.outlook.com [40.107.15.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF52F883DB;
        Fri, 19 Aug 2022 07:20:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KRMkpzlmKzSaRcdggsokNn4RtY8l7TlpglVFIkbHTVH45NHUBAnYolQQUL3KP/Jb83StW9fp+ymp8tekhuN4neBnCYxp5T85+oA0GaoomKaA+M+JtET5EahRxy8RdDWrG5sfwp9uxR/bgQ6dt2f/0HJm9sWbJH1G7BBUqmVMCxdEYyyFiU16SskZXQqxGOpSt0Vc9qQD4SlQ5QjGFF7Qr4CeioXvuw+ubQQLPLew3THlmcmOv5ACaTyqXrl/OcSDFu4/FJW874Xlfnn1s3FvAhicP9YzzFmX7+9uGgaDgMm37hXHRhbjWsE7in3/tOH5dDgbnf1iu9iofdcFrkEjwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SF20d+4VDknEH5d4tJQvOCEJAmkw1njeQQ+tUCS7rOQ=;
 b=N/g9QiAnGyvtzzaLmklCGL1graNvV2AFVcOdtIt4ujenWzpc0j9OWgnCgDYz1xSnzocHSEZCAmV4HpdvpIToGbEXOHWzs/RGhTX/NFWsSsQo5QZtaONPWfSO9jPJ+0H5kpNej9+pyKJu1HqjGcy/RhU++IGs+4cu+bHBcnObICsdSSLrNpa7OgjtsrmRWP9M9aFgxyoV4KPVsWXIg2fiMSVcb429agCfc/fxDCfCx2hs5VSNlNkyFp7Ge0FMJ9YnGGog3X+9R00WuslXhKLg/GpsiLN5bqEz8F8BnOOYYH3Zym+u2yAuTVrtvbVcvhPNEddSZ6uxAI2uRLDIhv3tSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16) by AS1PR01MB9348.eurprd01.prod.exchangelabs.com
 (2603:10a6:20b:4d2::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Fri, 19 Aug
 2022 14:20:00 +0000
Received: from AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 ([fe80::19b7:7216:e4a2:b0b]) by
 AM6PR0102MB3159.eurprd01.prod.exchangelabs.com ([fe80::19b7:7216:e4a2:b0b%7])
 with mapi id 15.20.5504.028; Fri, 19 Aug 2022 14:19:59 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v5 1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
Date:   Fri, 19 Aug 2022 17:19:39 +0300
Message-Id: <20220819141941.39635-2-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
References: <20220819141941.39635-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: BE0P281CA0006.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:a::16) To AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
 (2603:10a6:209:3::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ee427097-a9e2-4716-1362-08da81ede646
X-MS-TrafficTypeDiagnostic: AS1PR01MB9348:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Tg/jGm2g3jxeish9TCt3hQ6GMjtWYFfsa9nx4YfEI7W6uvVZb7v2rucuK25sAq6AsNk/fg7n1zpU/dozjgeYgvKcl9soeY9CeRklb2kGiWrAzrCXnMzNusqMAonHS9XKnOEiNb9+S7BBsWOT6Kh7yfVaYqofbJh2Jkm4ztvxV5GQCDpizpAKBgJz575RX2mqMjoMpLGGr7J91eB348LKV6cfw5j57/gPApDs3h49OqijR50y/JwLqw3ng5uHBbJYe6CpHiD77NKK5GAvDi2FFdpEi1amLVCcj3x6mnm9uF+dPPxXk30eY8IxlBy5KOcSidrLegH3zMBaAmHFTneuRt2p2Zccoh3c2fLMubRnaASciLNDa3SwyIxHEcQQ+z6DJUdc+lNygBuWUTuFKtieIjQgEVMdVKqc67BFkSW6paIKPOl/wVDLYuWmMONyYX8ET6bQ+k5Kl8ajINL94s5hqvV4nMmQjSAL6weX6/wt4ozV8UaFU94Y9PvWq1eXeEn2WVQDNEaKd+skcdbYLYPxlB28xhrBu+19rvMT5Ih6RjjZykTS7wYHlSTeUQncTPQtF/ePKYs5YMFGIFv2xwF8vGKTOD+P3SveiJhC6yZqISPx5PjUrpbOLEq66sEBmElvBHEetYGl/zyp3vRt3wkrXPA424os9M+4ZQxDHKiv/bUanMFcbsBfxYTJ+EYyC6EqtGLvhvuaAJZFf303+AfkPg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR0102MB3159.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(39860400002)(396003)(376002)(41320700001)(6916009)(5660300002)(786003)(316002)(1076003)(66556008)(4326008)(7416002)(8676002)(2616005)(86362001)(66476007)(186003)(66946007)(8936002)(38100700002)(41300700001)(6506007)(52116002)(2906002)(6666004)(9686003)(83380400001)(6512007)(478600001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qbGWXcC2XLlT5+4GeCBeQAOuY3NhJy8akcrHuczcrIHY3/SzbnFh0r93K12L?=
 =?us-ascii?Q?bnq8yA+HXdQfPFbPUx1zzWv5UVToHtZYCg4Myfr1jYqPBZmBc1uMobVOQkw3?=
 =?us-ascii?Q?bc3wyW4irRs6XIKEsxeShaz3jZ8Okwl4TJttyQdBDI782Yc6xYQIYrbSQPr9?=
 =?us-ascii?Q?YfBpE7uHuP4fXveGZSNHa0X/CuOvxSgZT1+WPRig+fUu7xT7+dQZWq3Gru1s?=
 =?us-ascii?Q?zJ+9JSFVjmfqPKeiekpIKpoU9Vrm96KNCBDNP0NlIoZkwrV+QuStY0etdnXf?=
 =?us-ascii?Q?3mB2LtvIlV4N3/a4WvI9wlbTcu4i7YJoQIYZQgY23rMEJ9bzigKKssuRKt2y?=
 =?us-ascii?Q?I+XjMHN2vLjrLC6BdYwW/coki6P5UDxbo5RoRTVEGi0Iq1oQGuKXebAYm54Z?=
 =?us-ascii?Q?p+rxS1XH14crX0Ddp/OiHXqJAO38LJXDBQFvq4Txd27z4XqXIXxZoauuI27k?=
 =?us-ascii?Q?J8ViOVtsJ+K+6hhJwjGl86MZ9CEk4ORaKL16a93oO3H8RicGpeSZr6HXVSmr?=
 =?us-ascii?Q?2AjJiNVlDIosjpqwolEtmlWqRLaEvrqpEYIsX6sj0NMC8xMo72WiKT0k5XaY?=
 =?us-ascii?Q?VO0+kJY5yaK46yzK4/CJwoYCjgCjOfHHL4F9u54kqtff+1dO7cTOvOjAbG1Q?=
 =?us-ascii?Q?nCp+fiwzq/JaeO18rsnOffk/4vXRDtYfKkbO5TBh5rHa3F5hUVRnmd/ztBwo?=
 =?us-ascii?Q?t9E3+djyqtw82Q94KcTPObcPuJpeZmuumSFf4JBJSK8AfLY9aoB2voMhNo76?=
 =?us-ascii?Q?83r/MTxJ4gjhhRZ3OcLniWAeAWZ7OqWGqoN/aZnscBGt3Z+exPtA/9LT0y5N?=
 =?us-ascii?Q?9EakEopWSm4xlDG/0k6VWou3TFPxpoeYbTH730zMRIhxsKkx5bvSVGqJdZM7?=
 =?us-ascii?Q?UFP00kYCYBcGWwxiTORAOuEt0vnxEj8f9SEJvVt9xZG+xzmTFa6P8jUIIu29?=
 =?us-ascii?Q?0vBGKnPT4oJj1KJetXWGt134jPXoABd+8LewZyBwUW82+i+HkAZz1wLi0xnD?=
 =?us-ascii?Q?AuQZj8D3UgapQFHDDpdp3A/Z4Kpdk0+7Ce5WwsZgkIKQTGBcxVqw9fycyL2F?=
 =?us-ascii?Q?DCX38DqY9ttfVfapLMK3GT688iXPi60Kh4xMmLml0WWbfSi/KDkmyU3ag9f8?=
 =?us-ascii?Q?Du2PIk889Q0Pe2VL29gHgHYIqXIfQ5xBgR7JjengmSqqWS4LfE5ype7pK58F?=
 =?us-ascii?Q?6EhbXxA+1qVY/mJ0mipP3jZG1QU+VwCXfE36YnbccVsn/g4pqs3t+Pyd5sGL?=
 =?us-ascii?Q?W0yIeQ4gLnddTi91nzVnSlOpsXJJ4Ihy/UvPtBA/0mU/fxbKO6k4ihzDl68W?=
 =?us-ascii?Q?BQxS6FVNcTek3IdvamoOAEGq8Fdjde8dIq3UqonTuM78StObEOIZgRxVk6eF?=
 =?us-ascii?Q?CyctYCmW1UaKpLMHdGKS/20Lxk3DGCk/xMWe+g6M+Y1fYkE6dIChUfsPbvhC?=
 =?us-ascii?Q?wqqXy/ihYxsQ6LJ6aIBi1A6gQ3gc9qM+AWytMgCwigWy5S9aTe7A6ifPlI3c?=
 =?us-ascii?Q?kIn9c9/960RVQjkOgTWhJBPqJf25a5c227kWeyTlvr4aVEifJ8+I8Y508Kns?=
 =?us-ascii?Q?Z0+puwdrlzCb0qARlo3TU9Wctwia9AHZKpuG8xt0BZCXbezPSOeWqyoo2y73?=
 =?us-ascii?Q?7VciCpmvKT+SBNn1sFZAszhhHRjc9hABLTI8NUr4naBTMZXwBu6Gj51SWyHJ?=
 =?us-ascii?Q?mf/BcQ=3D=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: ee427097-a9e2-4716-1362-08da81ede646
X-MS-Exchange-CrossTenant-AuthSource: AM6PR0102MB3159.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2022 14:19:59.8962
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ynZPTydvWqzgHvLrZoIKD1dVvStO4TGgtV2H+DW34fG9OvH+6I02X+Cs0I3yE8znPMvXWsKTn6HqcFi+tIrjKoDjAeWDxdKiL/uIQwnqhgE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR01MB9348
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

