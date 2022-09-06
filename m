Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6145AE25C
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 10:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239146AbiIFIWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 04:22:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239122AbiIFIWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 04:22:48 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80072.outbound.protection.outlook.com [40.107.8.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CE1475FE7;
        Tue,  6 Sep 2022 01:22:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DF3H3WxdPOztwKJxUOw9l9TVmhFRfqexr5fOwj/NLU0BK2GCPDpYwzx6YRKoznPvgAQDFHxA3W8yPm1vgoH+bsZ+e4kZFQVCwJLlH8ed6B0ZmUSE2rwgghrMnPp5oW0fklQZ8Lz5w5k4ZPrDDI37DjcAGgMrcPjXa8W+7jXfnXQiUM5F2pM6utFsWTWMWK+LQPMeXNeDox6qUCmnbGG/DGE1e7L/Z2quXz0dyeR2tfp1zJgNJj2GaeM/Fx5AcmrnAEI3L9ppP/nSDdnZKdWZXykxsGuv2DNKWnfSRJhpJ5IrWxlcXtomme8Yq0VrNXTujkTBxCIJUyndTcioMHZxeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SF20d+4VDknEH5d4tJQvOCEJAmkw1njeQQ+tUCS7rOQ=;
 b=nrj76fsUwjB3dpyG5deP/sIsIvkJ7A+dZDqY3+mp3XNdyvI1trN9IB4SXeCGX4WXP37QKaqQPzn4oxv7Pq86/iIMlYIpiZBlsVbJNItSrvSaQafdqqHZdSreZEJ3sbF0Lnd3LOUBqayNW5cFLcpANrSmhXxAdA+pleBI6y/BV3++Qx5E1kdnOO8d3ByOdjY9NivHdb2sNREZovziUHg+ifO4GhKGJyuGPyrDJ4I0FNKmk7ZZCVbjeOQoHjZC2jAvEKQvSYpngZLtRFE0ADdQb6C4Q3FZtNbPozZjEi3skjPDy7RMLzAX0FWwfxjk6/+tiDXA6U9aDIOrtfrFPxwQtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=stud.acs.upb.ro; dmarc=pass action=none
 header.from=stud.acs.upb.ro; dkim=pass header.d=stud.acs.upb.ro; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=stud.acs.upb.ro;
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11) by DU0PR01MB8877.eurprd01.prod.exchangelabs.com
 (2603:10a6:10:350::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.11; Tue, 6 Sep
 2022 08:22:38 +0000
Received: from VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 ([fe80::792e:fa13:2b7e:599]) by
 VI1PR0102MB3166.eurprd01.prod.exchangelabs.com ([fe80::792e:fa13:2b7e:599%7])
 with mapi id 15.20.5588.012; Tue, 6 Sep 2022 08:22:38 +0000
From:   andrei.tachici@stud.acs.upb.ro
To:     linux-kernel@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        devicetree@vger.kernel.org
Subject: [net-next v7 1/3] net: phy: adin1100: add PHY IDs of adin1110/adin2111
Date:   Tue,  6 Sep 2022 11:22:01 +0300
Message-Id: <20220906082203.19572-2-andrei.tachici@stud.acs.upb.ro>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220906082203.19572-1-andrei.tachici@stud.acs.upb.ro>
References: <20220906082203.19572-1-andrei.tachici@stud.acs.upb.ro>
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ClientProxiedBy: VI1PR08CA0231.eurprd08.prod.outlook.com
 (2603:10a6:802:15::40) To VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
 (2603:10a6:803:e::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f065319e-9e7f-49dc-2311-08da8fe0f573
X-MS-TrafficTypeDiagnostic: DU0PR01MB8877:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LsyjlJ1yeTcNRjfg4LBdf8Lrj3azYrBtnjAE/5CdLFcMbz0BzaAFcH4h1gxBmr/rmxhAegeV8UgHTr7EVn5Oted0JqEu1T2+y8lKY0OVfhbwkYrElWftACi4XCqUUoXnVsblCGJGNMwxfyl/jyrNKeiPs0n2OeklkC9ouuWxZmA03UqS/k+qa9dwuEFSNSy+RfYpHJPJn6KHNMAkNN7jpXogKHirGYlKlGoTbCjaZvBjojQmjKGzJUEgHcSguVcnKbiPGBS6JLDUFJAcHaMuil6r15B5ign3IrTunABMrVxjo6+LtMv2fLasvGugtdub45tggwRmPPqESyja4Xui4qu1FOs83q9Qu05PbRA38U2WO9QIfVvTloj+vouCgt8h/P6PiAlB32OMRnWs3BcgWBrdt0VFV1WALqf51Sprlsih9fYYLoxV8T9tqqL7cXDDpqw/kIeP1ZH9PPZ4cTNqxm/4m6uCXHAd/p4PP5N2yO3VUZzVg2+pCqCi1O3pdVP1ojTZKmtncdW6tIesr7PTwbLCJD2QJ9BHK0kjCWOFSgSIAfXJ1LW1EhItah8CtngPQs0jO3pDM2ZU8iZJdJULLmGN9qwfECX8A2ufqpi9RkrsHnhgd0OrwqGbfmBou1P1V40/q9rVyAlsmqsD1YOFF6stMMDfAMrA7WRgEJ/Jm3+X3qwhGgMX5wtQTkKCq7+053V5WpwherYUOUDbc/VbxBYFwyjeaOh5hDWEmPWH1eU1A7/o/aroZHZtLE1YuYq8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0102MB3166.eurprd01.prod.exchangelabs.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(39860400002)(346002)(366004)(376002)(396003)(5660300002)(2906002)(66476007)(8676002)(4326008)(8936002)(66946007)(66556008)(316002)(6916009)(786003)(478600001)(7416002)(6486002)(1076003)(9686003)(6512007)(41320700001)(6506007)(26005)(52116002)(2616005)(83380400001)(186003)(6666004)(41300700001)(86362001)(38100700002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8x//RbmrRvaqcl8O2Mz2z+Ly1ImVb+FtYpms4+ta/dTqv8jHZX649BPApefy?=
 =?us-ascii?Q?p4kKrlNYDsOdX+bKBWID0rQ1u+3Dueeq97RuHZ/X479i60nnsOKfgRq+Nkiy?=
 =?us-ascii?Q?dA7j+mdX3slGKBrdKoGez9TEDzDrAMnZAceZJ85Icyssd63dUmmrJuYTjg89?=
 =?us-ascii?Q?KDZ7vR06U3dbwGsHDWYwUlFjNzaoA/+iWpi9RPcuE0CiYciEFv4oS80L2E6v?=
 =?us-ascii?Q?V9SC64IG50F0Q93e4irY61Ba5eQWA/NmlSthzZp8uwp3BZ+8GqFgE8pwix4J?=
 =?us-ascii?Q?NmGBBOOJRrqQJA/upVrkw6yyTzgH0Pk+upjlg4XxI9+9uQszdyoZyMUqVcZr?=
 =?us-ascii?Q?4lNf3FEGnkaO4cHuSL/KCoxAA3OZWAiJUzz3jKigRvfRulgEwz+8w3YKJuAy?=
 =?us-ascii?Q?8z5Bl19W//nproHHHcaUiyU/3uoWas8osjasNUDaMQla/kjpG/8PxX3H/N4S?=
 =?us-ascii?Q?GQzxYfCo0f9faDPN2SuD3W7FR97TxKL/0tpy4vZ8UjZt8xUvX8H+Rc66k0iz?=
 =?us-ascii?Q?Vp0GsY9QV3N7x3YDOZYdBOVJMH5h3SBBpyDK/kHZRj4bXa+J4YjdX1JaIJsD?=
 =?us-ascii?Q?1NgMdWM5Hp3q3Zce0ML1x76ooahHK4/12L5TKMRO62FlgyMQgrF/ULpo+Son?=
 =?us-ascii?Q?04Efthamr90UcFQTHx+ig3XsNjiocOVzOGL8qby49pSlyQ2Z1FxrN5O5fwoy?=
 =?us-ascii?Q?Gwxx9z8PA1IoeH1cz0+M5ztBIfHy0VkreW8PPE3ZMnG+QKrKx8dWq2KUMWB1?=
 =?us-ascii?Q?K9G37Wec+al7xDTR82nNfGtsdzOlUS87w2dBbisOHspQbHBi9YVspkJaBlo0?=
 =?us-ascii?Q?6S97+vebKX+TbmyQRcL6Cx5Q2X76jJ0ST+2phq5m9Dj6YtUyFnWujnpLiWqH?=
 =?us-ascii?Q?H1xRM+/5KcsuCSwpiFiQ+MQdPPuHh3v5kDjDZwY3F36i+IUqyevniLhJFn1m?=
 =?us-ascii?Q?vj0H5BJLyr2r/AJukKSJR9vhmuASZFMopTiv7cBBTqcFgywFptKNsSizUhFh?=
 =?us-ascii?Q?kdTjBCqHTKCU8uHZ0l5MzrZZKUoBHFZK93WIBAFPK+yubqZZdR3yuuBTb2El?=
 =?us-ascii?Q?vhzeD0rKTrj2lRohIRB0Kv32d15Zk5QuYvqWf8VQivhCpFCOHm13uGVw/2jG?=
 =?us-ascii?Q?Z7Isbk9bcypWyPVxk2ZLjtQ061yG2b6LGuTSmpXl8vUtzAij1r+iHizdDC5d?=
 =?us-ascii?Q?Y0ztwkO0OLmpzROTvDE3SXTdzIgHbtFPRmyPme7rzkUdWR0fPRukGAFEUWDr?=
 =?us-ascii?Q?SNpNcc75zUBzS2y/It/VU5KLczERKzcJ/f7MlykmaISUeJUz7mghX4Zf/VHe?=
 =?us-ascii?Q?wfNZbBKHAGtdJ5qHhpn9V7CRKTMJNRjGIEnxQ8b6EFqfr0SH7CgpsZOGLDyq?=
 =?us-ascii?Q?ILmJR/xvZNqOm5pUK8a+6uZrL0l5t0L9ZEUg9EI7KgraujR0h+p2kTruIY11?=
 =?us-ascii?Q?myWvtUHrKsC6WLyPCU3kR7S3wuNsxnwn0QmFt2i87fElkLuv1s8FG/Jdym2E?=
 =?us-ascii?Q?oZ8TWX4MvF4yqKgarUi87Xdwfz0EYVAvcAx8gW8LIufiNQQLy85dirI5d+1I?=
 =?us-ascii?Q?IGbgf85eYz8WkphPYrMDKxZ9W2Q/4wXOhh73d64T2eG4d7Sh+iUtD3EG4ENa?=
 =?us-ascii?Q?8I0Soeo5dKK5n5jyXksel1Q=3D?=
X-OriginatorOrg: stud.acs.upb.ro
X-MS-Exchange-CrossTenant-Network-Message-Id: f065319e-9e7f-49dc-2311-08da8fe0f573
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0102MB3166.eurprd01.prod.exchangelabs.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Sep 2022 08:22:38.3818
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 2d8cc8ba-8dda-4334-9e5c-fac2092e9bac
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8gX+X+5tAV+k3OePtmyu3I1Mmlgce/3eDHFlTRXvaa1BNJA1VqAbToI9vALGgnPGKFKzV4R2CisEYth9bRRNcEdaHZiZm2Mj1GXSJ6O0+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR01MB8877
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

