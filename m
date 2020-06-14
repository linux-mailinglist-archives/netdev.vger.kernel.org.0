Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D191E1F8778
	for <lists+netdev@lfdr.de>; Sun, 14 Jun 2020 09:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgFNHUR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Jun 2020 03:20:17 -0400
Received: from mail-eopbgr60108.outbound.protection.outlook.com ([40.107.6.108]:22259
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725265AbgFNHUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 14 Jun 2020 03:20:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S9y5ka4kiUaq7CgPxdd3cqwvQZ7MdY5NaP6+ctV8gUE0vaIZU6y2Ozv10OMhVeasm8MUpJVyslqwf/25xOvf5K1VTd+jQiy5RSW58B5cuPgNi9VZoHhQ4bhi7A3jDBB0BTm3u+jYDXyzZKqJ3p5XRtrfHq4igfP67mjvUq0147RfQHIaujE0gFjAQNWHLmKc4Ju/odZGn1aHxQ9c4VzY8mTvgp9HOEfxxsJD2Iurwawc4fZ3sJUFPsA8asOHkgpJ9imt3GvdRFXBbG2HPKZBcEVOxaL5pfVKWEPAR1wG04QO9CyHvu+7Ju/VvRFH0zkP4oA8gp+4oOj/VlwKh16bFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pc0uTALffUXCu2pVd0I4XMLdD2ZGguj7uF8BCnHRjM=;
 b=RmzNiyv+VzLUFW+/4vcmaGe5JVekjdvkaQtafjaoZRSuf+xKR08sXCKMlNxDCpyJKh1KJ+LpSfMo3EeqkQZTeW3XTIJjFOaaytxVuLL+0Yj8/x4JwOiebSyIysorSkoZf5MibQ3qzKO8HwlqDDcP03TLhqSnoiWCkWuCSYeXcVaGeOECBB8u3GnNpJTXbWafjfs9a+vxpjM5MwAYR+k/qiQX2VOGGwKIEnhdWBXQT8MnLZy2fg/ALXzE8Czqt05V4boseNYtTFP7mZbxIvT5nO3/hM5K8Pq20MmKuCLm1Lz+CBEjXuMb1YyiGG7VdaT0X7TCIuvEI1yldYoQP+9oFg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1pc0uTALffUXCu2pVd0I4XMLdD2ZGguj7uF8BCnHRjM=;
 b=PCtBDcbOQPetw3QoxROK6RK1M622tqaV8Hq8Sb0OfBjB1AZWkhq7R7w5ueNiJNelTxZWh9h0QD0taQh+SgF/PPmv5fTXzhh9BjCaPpIKh7y3AxWIC6z77vrzJIXjICsCr/xNUbmI2eo2BbSBjp1EAEajMlBA7QGeMdCk9dnH51E=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from VI1PR0501MB2800.eurprd05.prod.outlook.com
 (2603:10a6:800:9c::13) by VI1PR0501MB2608.eurprd05.prod.outlook.com
 (2603:10a6:800:65::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19; Sun, 14 Jun
 2020 07:20:13 +0000
Received: from VI1PR0501MB2800.eurprd05.prod.outlook.com
 ([fe80::b9a5:d4c8:be33:32c5]) by VI1PR0501MB2800.eurprd05.prod.outlook.com
 ([fe80::b9a5:d4c8:be33:32c5%6]) with mapi id 15.20.3088.025; Sun, 14 Jun 2020
 07:20:13 +0000
Date:   Sun, 14 Jun 2020 09:20:12 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, gregory.clement@bootlin.com,
        maxime.chevallier@bootlin.com, thomas.petazzoni@bootlin.com,
        miquel.raynal@bootlin.com, mw@semihalf.com, lorenzo@kernel.org,
        technoboy85@gmail.com
Subject: [PATCH 1/1] mvpp2: remove module bugfix
Message-ID: <20200614072012.xyhvghdgvs5xj5ta@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: AM0PR03CA0005.eurprd03.prod.outlook.com
 (2603:10a6:208:14::18) To VI1PR0501MB2800.eurprd05.prod.outlook.com
 (2603:10a6:800:9c::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (149.172.153.214) by AM0PR03CA0005.eurprd03.prod.outlook.com (2603:10a6:208:14::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.19 via Frontend Transport; Sun, 14 Jun 2020 07:20:12 +0000
X-Originating-IP: [149.172.153.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: abd525e1-75e7-49ee-faa7-08d81033614e
X-MS-TrafficTypeDiagnostic: VI1PR0501MB2608:
X-Microsoft-Antispam-PRVS: <VI1PR0501MB2608F76CA59B44BB0AABDAABEF9F0@VI1PR0501MB2608.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 04347F8039
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: easHMdbvCuDETGSUJRYNucFQ8EPsVRJfIijWT8NcGo2e1UUSm3tMn46pTX2Ws0U0IdMp1SFtBqMEmJ21FezeJ/j6R+hkz4UBArIIGqdFraXiDC4nz49mMD8obiVJDtcN5EssFaQO2eBvLn8xOSIAGkcRh3pke3g9okGzNbyVrrRsGTErmH/j4QFzr69sYFVbplTCvWaxn2AcwelPfBFv/rITEGFdrEfMUG6aBAPIMi0W2vj+DcB2wHz1m+CoptdDhfGr1E6HIVS3RX8w0PErI8k4dfCT2B4VJQnoS0Ppc1QYCd2oKcGZTxv/ZheHOoP8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0501MB2800.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(366004)(39830400003)(396003)(136003)(346002)(55016002)(6916009)(83380400001)(9686003)(66556008)(86362001)(66946007)(66476007)(2906002)(4326008)(5660300002)(956004)(52116002)(7696005)(316002)(44832011)(16526019)(508600001)(26005)(186003)(8936002)(8676002)(1076003)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: PR7Qsg45OZSQY/o7aqSAdJZ4J7PetsOPmwTqGIVvOTQQUmurPWW9Agq0cmBQiqiO1+M6/JKp1ioe884NPZ9ejI0O3ON00aoY3NNSi1NkjAKik6fIuTXEZbbAllq3etUy/ej90s6JmCW0TtFUW36SVBaMDOdJnsn4RGpixyea2VO3G1xo9Bz7M9imV+752h3TGyiq9VtYR0DIrI/vtm7TF2VkwFbadRifN15GDDNJThCk7695PT3qsLWJnZWQ9HoiXkQEIRwojLCnJcdWS+VgCsMUNq9Tl0I6ix3MApNwImcp80zl8cPvn4G47/XBls14MNgAQM4mvfviMvvzUszTdifSy8RUJ74zmUSF7suNUawlrjzonp5E8MfThLRShNFYpIZZQ6S57jgGdTMiDOxY6r30NEplKpoqrMlVPGbbqwM3LkvpqaWWw0Es0xojEmQ1lzot4hBURK+lfmy5Y3qGAisooJXMfTP4liWv0HmTXABHcNYoZ/crDO/ct4XuBONy
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: abd525e1-75e7-49ee-faa7-08d81033614e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2020 07:20:13.6516
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: abUj4axfbWzT8mh3HNId/cc5PxV+tBu/wfiQBs1lf29J6Kb4qN0CPnuC7yUSMrEbeo+4kgoSy/zr6ty+ibIk+C8AqH0JPc7qd5lPEThxfRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The remove function does not destroy all
BM Pools when per cpu pool is active.

When reloading the mvpp2 as a module the BM Pools
are still active in hardware and due to the bug
have twice the size now old + new.

This eventually leads to a kernel crash.

Signed-off-by: Sven Auhagen <sven.auhagen@voleatech.de>
---
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
index 2b5dad2ec650..9d08312c1c47 100644
--- a/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
+++ b/drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c
@@ -5984,7 +5984,7 @@ static int mvpp2_remove(struct platform_device *pdev)
 	struct mvpp2 *priv = platform_get_drvdata(pdev);
 	struct fwnode_handle *fwnode = pdev->dev.fwnode;
 	struct fwnode_handle *port_fwnode;
-	int i = 0;
+	int i = 0, poolnum = MVPP2_BM_POOLS_NUM;
 
 	mvpp2_dbgfs_cleanup(priv);
 
@@ -5998,7 +5998,10 @@ static int mvpp2_remove(struct platform_device *pdev)
 
 	destroy_workqueue(priv->stats_queue);
 
-	for (i = 0; i < MVPP2_BM_POOLS_NUM; i++) {
+	if (priv->percpu_pools)
+		poolnum = mvpp2_get_nrxqs(priv) * 2;
+
+	for (i = 0; i < poolnum; i++) {
 		struct mvpp2_bm_pool *bm_pool = &priv->bm_pools[i];
 
 		mvpp2_bm_pool_destroy(&pdev->dev, priv, bm_pool);
-- 
2.20.1

