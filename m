Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D910231C4A
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 11:49:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726480AbgG2Jt0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 05:49:26 -0400
Received: from mail-mw2nam12on2081.outbound.protection.outlook.com ([40.107.244.81]:49728
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726208AbgG2JtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 05:49:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kHWG10Z4s+BVam3Whv62ePmi01RSf2pSn1+35Jf3wum8FHetgo3whp7z8Zp2Vxbi0/9lFN/Ur8yD+04/k2w2gCX1970t0ka3ToA2R/hKrKymQL/OZ6zQdH/NHT2ttzeU3uxO53ejHfkC9hFNgMpvPksO5KKMU888ombVgobaYZU4J9+qS5PHN91ecQPUJP0e6O9lUTrJiN/He61RlMjn/yNaLwtYZ2bMHnkrHEOfXx9Tib2FpcAB6nqHMgcPoU6qYDHLxikord14S7uwQOI1MDius35z2IwOxOPHkwUvKRXKet+b/iY+POjb13PZuey17+72al/C0x6yasSIWbks+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1oODdtWTygAw/5Leu5j//YE2hVfcwPnWGb1ogFhWpQ=;
 b=TWwaKHYuSG3vphngAHM0mfykPq5hwezOIJ/T5mTPKevMq422skbGPybafXo4evbNeFnjeUPZWg7nmlPAoGE4n7D/6tjASYDH48rIBh047CYKzPPzPo5vgx4uSxY4GX/rCXpPa1DIa4D5lpuM1eAM1gpLQ29GiHNogRTV2fXHojsdyHGsSQljUg2sGO5JlBHYurOOcuXi1zzDAtGXT28TQs9g62P0swMhmXonMeMPx84FQU2o0ZBdBwXlSVf8PUgIeHx7haLlPulbAVU1G0KcvOQQThED/EoJ/wPvV/4vMmwt6cIEMUJgk7QJ254ttb5+ntgg69drLvSAEjnOwlBYhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=synaptics.com; dmarc=pass action=none
 header.from=synaptics.com; dkim=pass header.d=synaptics.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=Synaptics.onmicrosoft.com; s=selector2-Synaptics-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1oODdtWTygAw/5Leu5j//YE2hVfcwPnWGb1ogFhWpQ=;
 b=nfg4/SC0dIngfuXhxxboTKtla1XT+r1Bw5JVuUqGvTLQjgxUGAc23K0Ky726Z0FpT/ziMAU1wul5JwyGXLty1PbEMQBn6LHOj1D5G43AP4UiTHu9sWxtWECqQd6wWkRG6DDp/CFKs44dQrK6LL6U/f+0X90IJddvgpJNPheynJw=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=synaptics.com;
Received: from BYAPR03MB3573.namprd03.prod.outlook.com (2603:10b6:a02:ae::15)
 by BYAPR03MB3638.namprd03.prod.outlook.com (2603:10b6:a02:ab::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Wed, 29 Jul
 2020 09:49:24 +0000
Received: from BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c]) by BYAPR03MB3573.namprd03.prod.outlook.com
 ([fe80::b5cc:ca6b:3c25:a99c%4]) with mapi id 15.20.3216.033; Wed, 29 Jul 2020
 09:49:23 +0000
Date:   Wed, 29 Jul 2020 17:49:09 +0800
From:   Jisheng Zhang <Jisheng.Zhang@synaptics.com>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2] net: mvneta: fix comment about
 phylink_speed_down
Message-ID: <20200729174909.276590fb@xhacker.debian>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0122.jpnprd01.prod.outlook.com
 (2603:1096:404:2d::14) To BYAPR03MB3573.namprd03.prod.outlook.com
 (2603:10b6:a02:ae::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xhacker.debian (124.74.246.114) by TYAPR01CA0122.jpnprd01.prod.outlook.com (2603:1096:404:2d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.16 via Frontend Transport; Wed, 29 Jul 2020 09:49:21 +0000
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
X-Originating-IP: [124.74.246.114]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6607b31f-fde6-44fe-62fa-08d833a4ac73
X-MS-TrafficTypeDiagnostic: BYAPR03MB3638:
X-Microsoft-Antispam-PRVS: <BYAPR03MB3638BC3CFD1B1AFEF3347994ED700@BYAPR03MB3638.namprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1824;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xt7/u2bktzQiX8Ivbgi7JfHq5BIigToCeRBrm5yayejqSOaUKWZOf6sXci20IAydc6l/oWxZSMsPbFwCtlBgzTMklyas+j8XHNmkz2fgz6UFbC45kDAtfFx143jMUHuZ0bYfHAW9xThID5FiGi2kyQ10LBbgCxwMUqU5eUpnY44p97OP9VT/HGbspepIrRL7I/krDxwgLuGAen/IsvXzVharojX6lenqF+Bk2xoqeVAP+GF38HmUySvRmR6ZuW68ds/rTGYW1z/C/AnBsALBeihU5wQap56ZvqrFOukSx56YzTNS0Xf2omxhWiuik7no
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR03MB3573.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39850400004)(396003)(366004)(136003)(346002)(376002)(316002)(110136005)(8936002)(6506007)(2906002)(16526019)(26005)(4326008)(8676002)(186003)(55016002)(9686003)(52116002)(478600001)(7696005)(5660300002)(83380400001)(6666004)(956004)(66476007)(66946007)(4744005)(1076003)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TjlDyGewUkdNQnu77QpvRid5d9P1Znm5JT+bl8gyViR7tGzniUV0ZMm4K790tRoMjn84LJ419q5PPyTr/4vn5kc6XSFbX4og+TDctPmsoTRRO16Fnx+nTFoUViAJIJG7pKwGcA6b31hN3UJJIw/KXf6Tnm+MJWP31bCmYscNGB5/VQU6qDgiLogNDBX6p5TH4CJiVRWXqu7wrXF/hzycqNCRVqFbyJL1JHcWDLK3k1dU6Z0/3g26I7jGDqclBUd2VpnK2ar6Pma4fWLqsudi2s0rm4b67Z7UgopztvyX/+MS+vuZbTACl9crtPzU9/axHQMnmSOotPUArOUlgvYiVG8snta9C1B+bIyTlWO4XizDhXHWRpLOSrcJAgVPcOTBu8AVs/U/e4PB8EUbv+eB4YdWXgBdCsPVk6Xd0Bqex6XZ36zLM9rrYGRQStjw0A+atypU/1djXaKtLi154JroazpCa62RAqFIy4F8TaJKkP4=
X-OriginatorOrg: synaptics.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6607b31f-fde6-44fe-62fa-08d833a4ac73
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB3573.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2020 09:49:23.6579
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335d1fbc-2124-4173-9863-17e7051a2a0e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4L69hHgESqWbrmVLv2oQNu8M31CuaVw0MmtkoCtTWQMzrJQNch8BkqrNJy0br82Q7xk5qcX2qWmJKGQh+z7RTg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR03MB3638
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

mvneta has switched to phylink, so the comment should look
like "We may have called phylink_speed_down before".

Signed-off-by: Jisheng Zhang <Jisheng.Zhang@synaptics.com>
---
Since v1:
  - drop patch2 which tries to avoid link flapping when changing mtu
    I need more time on the change mtu refactoring.

 drivers/net/ethernet/marvell/mvneta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/mvneta.c b/drivers/net/ethernet/marvell/mvneta.c
index 2c9277e73cef..c9b6b0f85bb0 100644
--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -3637,7 +3637,7 @@ static void mvneta_start_dev(struct mvneta_port *pp)
 
 	phylink_start(pp->phylink);
 
-	/* We may have called phy_speed_down before */
+	/* We may have called phylink_speed_down before */
 	phylink_speed_up(pp->phylink);
 
 	netif_tx_start_all_queues(pp->dev);
-- 
2.28.0.rc0

