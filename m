Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9812728CF78
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 15:49:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387913AbgJMNt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 09:49:26 -0400
Received: from mail-eopbgr130088.outbound.protection.outlook.com ([40.107.13.88]:3086
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387848AbgJMNtX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Oct 2020 09:49:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hqF/jSpxIhnRQY2RUkhWjTSXl6byoRyo+9KjuRD8WyNzEt9+IYFwWifm2/7l2YPPnL9bncn/8cSZ4TBob7V8WZPfqCGUug8oyAAEuja5ZBp+QJdKbqVVgUAJ0tzMtZDHJb+Pre4Y/w37L7WMgoU7gLSeNk9GaN/YCsLT8nKtda3mmEP9UHQlfOlgsY2C/eN0IEaGamVv/IW7SYnjTfWuBe2jCd6hHuPnR+te6tlJfvhETmd2MfzIavR7Oppm3BoTDG48iGKGPTSHTbGLvf57U90d3OKQt2Jes33qY10UIniR25gu9TBX5uZBVazlGT6z31Z8Ou2+Zq3ajmQQo1zfaA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BC4D4OnO1eQXDsjIxw/V2G51bH+gxbP/voifeC/4GHg=;
 b=H34Pz7yxNP3LfNxs54d/3dMlhy7vEX+Yo7CCd5hKJ8/nm/09MdcgwQsafKt5XHQ+MspzSs5Lwl1Hty1tuwusulQFGrtlDndtvdrdqtkUM3jSurf27qZTmRBcxpp7rqU27XVc4P7Jt1StxABRMzV3g8QdBoV3YlRcPO9S+SJ5Khk8ri5PZhe1aDr2kInq7B/j9qjI+pOH0QB85jve1/3rcOcekZJP9rNj1SmR7taTmffkzCciEv46eK55OsVDsj/+ifCrkL14mbgVCwIdqqMKWtuT7itrlw+uE9jfGF+EvSSXNjbMAf+nToh+iQ5ohSzOmqG6aon+JcPCoCUbDEHOBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BC4D4OnO1eQXDsjIxw/V2G51bH+gxbP/voifeC/4GHg=;
 b=UjDQxrPlgB6NWaYXgKAqtdepve2eJpiOoMPyyVb1UWe/tjWoqVJEQP8LUEvjMbvEmOYl0RJ+9ysCOka+I3E4ZkiQwmF4tEbk4mm8mZkyIx+o4V+/GYRNeHcPc5ZPxY8CIWreNxWRBkuZxi4stCYlwD9xrT/g4/hiHU72OrQP+ik=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB2863.eurprd04.prod.outlook.com (2603:10a6:800:af::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.23; Tue, 13 Oct
 2020 13:49:19 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.020; Tue, 13 Oct 2020
 13:49:19 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        alexandru.marginean@nxp.com, claudiu.manoil@nxp.com,
        xiaoliang.yang_1@nxp.com, hongbo.wang@nxp.com, kuba@kernel.org,
        jiri@resnulli.us, idosch@idosch.org, UNGLinuxDriver@microchip.com
Subject: [RFC PATCH 07/10] net: mscc: ocelot: delete unused ocelot_set_cpu_port prototype
Date:   Tue, 13 Oct 2020 16:48:46 +0300
Message-Id: <20201013134849.395986-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201013134849.395986-1-vladimir.oltean@nxp.com>
References: <20201013134849.395986-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.174.215]
X-ClientProxiedBy: AM0PR01CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::25) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.174.215) by AM0PR01CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.20 via Frontend Transport; Tue, 13 Oct 2020 13:49:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: d669c4b2-645d-40e8-5bb3-08d86f7ec87c
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2863:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2863E39F90F2924AEAFB2679E0040@VI1PR0402MB2863.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:53;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qKIF3NTvlb1WxV8tU0BcnGq5Fs9bFfwxGpOPckZ8cDHtIqv3ibRQK5C2UZjRnMyFO7g1pbBO3n3n1DfxKatqOus/iegW2l+PbT4JZeNTpyHy3blMuzHPXNLT7LHus75Sr7e5OOeAtbitjLL3ljahpnnO4b6gUmUXy/XSq0ThDU34OFRsXLtso1wIWEz1ucp9HAsgSvrOycGomc2/U/Ve/f6x+odKzeCa+v3Z4dfqccYIvI295c80VgaUCpPHrpx7QUA+pujloMJJIfLM5j0GtSI5goEYGcbYMFRYKU2OOx6Nt1b6US/ELgGcNpPvL0zm661KEuaZNa+UFNVvDU0LMayxyBG3sCU+8xbeXgibS1gv9aUj3pp0huohFNUVldGU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39850400004)(366004)(346002)(376002)(136003)(5660300002)(86362001)(186003)(4326008)(8676002)(16526019)(66556008)(36756003)(4744005)(6506007)(8936002)(66946007)(66476007)(478600001)(1076003)(44832011)(956004)(69590400008)(2616005)(6916009)(6512007)(6486002)(2906002)(83380400001)(316002)(26005)(52116002)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: LVZ1wbFAg+AeuTTiHpy2y4EHlt+qm8i0JtAQsiTH1eeFcAe2fGfqSDFtjq4yOXcfmK/tf1vpdRVTyrrlN8iAgeVCTaJQ4pm9QD8Km/B/KPOcSpIjjSehqy9d5fAiHT39IKAXvOlesbYL2stY7AzJdLKHax2uvqYrwb3A9G8JGh1wAAci1H/htUa/BDmotsuLIarO+h3hH4jT1D9zvw6ofafgxJmdsXkymz/5M2QGBBucmyxpmaGGWs+0ekuakVGFHk8ubgP6/55ZOIQaxdfo0Cm8RCJCiFPn6qq3n1Fgi+yCs+v8kmzAQWDHI460Svo7fg5E11z0USdtnExJfNfGYtixx+KFURhF4kuAGNIt8iDDnvd7rKEKXwERcfkTetawOPfCKooSL9WLl0CCDli515ehVcHKSYWM1E7/G8co3F47PKV94uWlb1wkGI2ZXOLHHhzRE7kKseRD2hjVXtu6iyt19af1NJSjgvNI1kCOnDL1P0BVdHxk5hL6vrzbf1ITi0LzLqK4LVo/Q+w0UmB+Mn153FyU6uo/9bjne1jPtjjJGEyA+08aDYxcEVQE0kKK2+xhYZYYMmdS2vOOckVJ/aXfYaeBlMxl4x32vVB2p8vlnntHpEcfIa+AkGxstQ8XzsoeiC+GbNp6LGsGX8W5/w==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d669c4b2-645d-40e8-5bb3-08d86f7ec87c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2020 13:49:19.5599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O4g/x1nNx2lcx7fw6YakGuPKrOQZVn2PFxgoJJ+RkvOImY+uH0/PWFKRDo77C+DBk8FCEq0gC+OzMkFlAUWd3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2863
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a leftover of commit 69df578c5f4b ("net: mscc: ocelot: eliminate
confusion between CPU and NPI port") which renamed that function.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.h | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.h b/drivers/net/ethernet/mscc/ocelot.h
index abb407dff93c..8eae68e0fd0b 100644
--- a/drivers/net/ethernet/mscc/ocelot.h
+++ b/drivers/net/ethernet/mscc/ocelot.h
@@ -107,10 +107,6 @@ void ocelot_port_writel(struct ocelot_port *port, u32 val, u32 reg);
 int ocelot_probe_port(struct ocelot *ocelot, int port, struct regmap *target,
 		      struct phy_device *phy);
 
-void ocelot_set_cpu_port(struct ocelot *ocelot, int cpu,
-			 enum ocelot_tag_prefix injection,
-			 enum ocelot_tag_prefix extraction);
-
 extern struct notifier_block ocelot_netdevice_nb;
 extern struct notifier_block ocelot_switchdev_nb;
 extern struct notifier_block ocelot_switchdev_blocking_nb;
-- 
2.25.1

