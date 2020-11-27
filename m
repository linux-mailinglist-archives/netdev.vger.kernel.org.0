Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D170D2C626A
	for <lists+netdev@lfdr.de>; Fri, 27 Nov 2020 11:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgK0KAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 05:00:06 -0500
Received: from mail-eopbgr130107.outbound.protection.outlook.com ([40.107.13.107]:47246
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726202AbgK0KAF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 05:00:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q8+Pr7lCkfMfhJ5q5aw3jum0MPYOWkocLBFH9moOpJJymxQgosC98dLV5vTWR0+3Ya/cpUzq63Fre9XGrtmX9SKxDwwjnR9ASSiIPwAfZN7+eiSkwqh6XHnSXR9jxdexwTeBv3Zqegkaqt80eIdJega4Qa4lSwWLD3F8b6OlERz/yIuYfgLqNXx5cvMAGo7ZxjzkX7MWEc+d8w/re14iogy3fAg9+uUgP0CYzAR+N1D5YQO99cE1abUTInfATJxWdAeapT9zuKNEUFHCs5QMt5qLONQQtRxVu1XRiH6zDutSHlhP0mUJlaHI9kncgGm4W4IDCHTvdEP1kc6pYKsn3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wks1QMzkhzTgGsx8UFhLJhGRl3QwctLTwGTqIshxVxQ=;
 b=moU+1XiNjOBtAYvoNIOqP76seLI2dMq2FoK5lvxKhqq1mEgJjjTNCDpaAFTIFUxPhdovTor98KU/5dr7OqMSt9aDn/A8H9ylEoi5WeLp0Ib1ZhpAVa+2Rr9g82w5FIcQMhAvcKqbmP3GuYSGcenJRI38/YaZUFF7z3Lj2Syio5OcwdLFPJBscSDGMC1T/uzCTy0UARt/cG9NbjuL+zer/5xd+Wjer5F4rRBYZPfESlNAdFLmmuBFdRG5mN2+RGjCb8GadKV+PGpK+r5ogtqsKcEXlO15MdDU9BfXJihf5gqdtFrhLyUc3jy9OzuS+FWwedLb7Kt7jVGLfGv1XSmzWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=victronenergy.com; dmarc=pass action=none
 header.from=victronenergy.com; dkim=pass header.d=victronenergy.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=victronenergy.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Wks1QMzkhzTgGsx8UFhLJhGRl3QwctLTwGTqIshxVxQ=;
 b=X4OjPD03qbRoAkO58OibHDLP2PudURpXQMj+eW4MDMF6lhX4kFRi3AiJtJQRliawo8oERhMrz7THDxq05jELIB3tXHhRvN2fGQSyPS+cblGY3/kjtvnzdqfzl/7I/aSZF+aOI/eBGzna9iI4LWDJzpss5JPn048SvIbGAbq0yes=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=victronenergy.com;
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com (2603:10a6:10:192::11)
 by DB6PR0701MB2453.eurprd07.prod.outlook.com (2603:10a6:4:5c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.9; Fri, 27 Nov
 2020 10:00:00 +0000
Received: from DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c]) by DBAPR07MB6967.eurprd07.prod.outlook.com
 ([fe80::ad22:24cb:3fd:617c%3]) with mapi id 15.20.3632.009; Fri, 27 Nov 2020
 10:00:00 +0000
From:   Jeroen Hofstee <jhofstee@victronenergy.com>
To:     linux-can@vger.kernel.org
Cc:     Jeroen Hofstee <jhofstee@victronenergy.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@siol.net>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Allwinner
        sunXi SoC support)
Subject: [PATCH] can: don't count arbitration lose as an error
Date:   Fri, 27 Nov 2020 10:59:38 +0100
Message-Id: <20201127095941.21609-1-jhofstee@victronenergy.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-Originating-IP: [2001:1c01:3bc5:4e00:e791:efe6:bf00:7133]
X-ClientProxiedBy: AM9P193CA0012.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:20b:21e::17) To DBAPR07MB6967.eurprd07.prod.outlook.com
 (2603:10a6:10:192::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2001:1c01:3bc5:4e00:e791:efe6:bf00:7133) by AM9P193CA0012.EURP193.PROD.OUTLOOK.COM (2603:10a6:20b:21e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.20 via Frontend Transport; Fri, 27 Nov 2020 09:59:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b8c4f2b-54c9-40ab-8112-08d892bb33b2
X-MS-TrafficTypeDiagnostic: DB6PR0701MB2453:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB6PR0701MB24532B5C44ADA90514C47A3EC0F80@DB6PR0701MB2453.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KQFzuYj1E0dv7YNNkQ9GPclF5Ok3NKAqYhwP19e7GePlkOjlBfAscImUz53x54kA7909N/+TBWWd9pvEIfzXRuAVrB0zr3+60oJh1TusGGl4Tj8VLrt8B5qUnH/s6QfhB3QbLLH3y3wIz5fTvBzmpWTrul04OXGQfYhe0glpU/6J3PJ5+X38rWQ7UDCtuXfKWl7faygglm+/0Wr3lsJ4k3jSQqRZfk+NqZWuF/+CXeEMEvz0RqGyh7hPAbBFIf+gHA0cTNt0SLMaiH4Q3jakaxwc8eFXf0iijUSC1kMo5WulyHQlOffWSFE3qH4hEXeUNMSn8kPT/PMoAWe9NWJGBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBAPR07MB6967.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39850400004)(396003)(366004)(346002)(136003)(16526019)(6666004)(6486002)(4326008)(86362001)(36756003)(2616005)(54906003)(6916009)(8936002)(316002)(186003)(8676002)(2906002)(52116002)(6496006)(66476007)(83380400001)(66556008)(1076003)(66946007)(478600001)(5660300002)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?lpQa9xHWJjA0aXXsgg/p5YL2vxyoay+j2CIZi4sJHMdVN+nr+k9lwiS8FDdN?=
 =?us-ascii?Q?QPEak0iQUg7CdV6e3f2ab5+3ftU54DacLj85kTnVM/H09GY1O6L8oewpzZ87?=
 =?us-ascii?Q?4SRiBr7HGg/BxeaoWOYR9DlFT5+vBjHFEPakSKusALr0Esu1I+sA12a8aoD+?=
 =?us-ascii?Q?GZVbfIxeU33Ou/48Ho7KBGJVaY41zHJidJv2CZsNMA6zLyc8SZZFaV15sWtE?=
 =?us-ascii?Q?ZEqmgigHThtihRk6HpJcM4jz9bL1ERQXDvD6MyLaC3Id+pUoJUBhNCS2bI7I?=
 =?us-ascii?Q?LvdYx1gTK4rjMaluEfNynLJY0cz7asnJe8R5S7+3a4uhsjYajnoRNsT5QVi/?=
 =?us-ascii?Q?ROXnXO1s3rzFawSb3A25YDTi7csDZiFWPlc0n0udFLB8crLRoO5Nl/wNVXio?=
 =?us-ascii?Q?rI70+ezBZdveviwxHk15vX09UA+c0DBitkzKVtFS6CGaUIe5H/HxzaNohjsI?=
 =?us-ascii?Q?AXvoDXYF5Ux/4k79s9L7KM4DOmiDtT5VivxO/3Ny/RayS3nggf1qG0J2uL3V?=
 =?us-ascii?Q?BIxKM5p5A7PYcx4rdCbzmm2QnVFptvaWyUsTteoNxOhOaMxl/uyw+tETIDYK?=
 =?us-ascii?Q?00shy/zA6holBChEmIesekHpN8az0pvBfxywvagq24+9HgmvGq7uS1ldReyK?=
 =?us-ascii?Q?IrPjIVmTEljImGWVb9ZfEw8Mt21hU+KWbgqIRqQwNilnkmzyb9D8+51vhHFj?=
 =?us-ascii?Q?TAmZlGgQy7S8Y0J759mmGl5c+C8JYhXXBfXmaRAYSg+O4p+5r7Dv6PShU0HG?=
 =?us-ascii?Q?FJReMOMHb0R9XUTgT7iiQ9cw7VvV4+jYurE0EIL6b55hs/75UG8K8jw2Co7i?=
 =?us-ascii?Q?whw12FKb84XCYhmUsinYuLbmqKuekj7Eizcfe/oG+4DZqeUjmnC8g108IZma?=
 =?us-ascii?Q?WZFJSocDRlgkkvOObcEV87j75CcKtFyU19vSl4fjtIBNqIwri1X3hmI/q03n?=
 =?us-ascii?Q?puFlv5RTP8lVoA+3F1fxpCRAxqiZ7cPztrlTsurvnhkB/XRqBAK2m5WeBBiQ?=
 =?us-ascii?Q?H1W3mYisR2JGT/9KWDNp/dpO+I2dLJtqWEGZXbatZKuUmNNlPjkOHpAc0F5k?=
 =?us-ascii?Q?rwHKPps2?=
X-OriginatorOrg: victronenergy.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b8c4f2b-54c9-40ab-8112-08d892bb33b2
X-MS-Exchange-CrossTenant-AuthSource: DBAPR07MB6967.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2020 10:00:00.1590
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 60b95f08-3558-4e94-b0f8-d690c498e225
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: leKjGGNx17/4pYZp2zu4ggaD+bk2IRFR9rRR0bC++fR9Lkq9FfsTM2J3rtd7HM5y3xnEhXZgVamLc6zXdVLDylZcS4JEhxVqUpYrvw6v8sM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0701MB2453
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Losing arbitration is normal in a CAN-bus network, it means that a
higher priority frame is being send and the pending message will be
retried later. Hence most driver only increment arbitration_lost, but
the sja1000 and sun4i driver also incremeant tx_error, causing errors
to be reported on a normal functioning CAN-bus. So stop counting them
as errors.

For completeness, the Kvaser USB hybra also increments the tx_error
on arbitration lose, but it does so in single shot. Since in that
case the message is not retried, that behaviour is kept.

Signed-off-by: Jeroen Hofstee <jhofstee@victronenergy.com>
---
 drivers/net/can/sja1000/sja1000.c | 1 -
 drivers/net/can/sun4i_can.c       | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000.c b/drivers/net/can/sja1000/sja1000.c
index 9f107798f904..25a4d7d0b349 100644
--- a/drivers/net/can/sja1000/sja1000.c
+++ b/drivers/net/can/sja1000/sja1000.c
@@ -474,7 +474,6 @@ static int sja1000_err(struct net_device *dev, uint8_t isrc, uint8_t status)
 		netdev_dbg(dev, "arbitration lost interrupt\n");
 		alc = priv->read_reg(priv, SJA1000_ALC);
 		priv->can.can_stats.arbitration_lost++;
-		stats->tx_errors++;
 		cf->can_id |= CAN_ERR_LOSTARB;
 		cf->data[0] = alc & 0x1f;
 	}
diff --git a/drivers/net/can/sun4i_can.c b/drivers/net/can/sun4i_can.c
index e2c6cf4b2228..b3f2f4fe5ee0 100644
--- a/drivers/net/can/sun4i_can.c
+++ b/drivers/net/can/sun4i_can.c
@@ -604,7 +604,6 @@ static int sun4i_can_err(struct net_device *dev, u8 isrc, u8 status)
 		netdev_dbg(dev, "arbitration lost interrupt\n");
 		alc = readl(priv->base + SUN4I_REG_STA_ADDR);
 		priv->can.can_stats.arbitration_lost++;
-		stats->tx_errors++;
 		if (likely(skb)) {
 			cf->can_id |= CAN_ERR_LOSTARB;
 			cf->data[0] = (alc >> 8) & 0x1f;
-- 
2.17.1

