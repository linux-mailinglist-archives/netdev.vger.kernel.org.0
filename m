Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A231FA7C6
	for <lists+netdev@lfdr.de>; Tue, 16 Jun 2020 06:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725928AbgFPEff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jun 2020 00:35:35 -0400
Received: from mail-eopbgr50120.outbound.protection.outlook.com ([40.107.5.120]:8435
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725306AbgFPEfe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jun 2020 00:35:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I8Mw8JBTXZ6TZYWUapz9Y1nxgW7pvIbeTXlGuD50WFYQpNpOx7FWAiUKk962T4kbP65496IPrFELvtFmErL4UZ/3lmmyfBip3bRE43qdxKVi+8ViH2CTj+egJMf9q4TWMMDheQIThv8tuiydwhKJiT/UNfly/PcgktAVacj0BfASdskPGYYGFwSnpJBdJekWBQuSYunVLLe8kVEFJvxnQ38bXqtN1uAR61p1lZyc7YpwpmkUrmHmV12wD2QOfyRfAckHM/8HcJY3mL+4AY+hY3tTgZXzrgNVQkF/rvunJDxw0FrXjsyovcDUKXGDh/6QT29hE8ckowXwsacZsK2mxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZh16/9/LFm7WS4n7QuQOW1sflssmbGfR9+F4k4oF4I=;
 b=DpR3rOCmpnS4lq6lARCeEqdTpcsyrVciBKsKGJN/ro4zVseJukIhnLymjQZuiyFRvHcu7tnar/Ug4htOujY+DYpTvxNtK+fywPvm1E2vNWc0Z7NMLtvMxDOH1X/1XcCJPT4FsEzWCQsrHmQXmg6nARYE0S4ny55B1XwnL/4KOI+iBuH/MQB04lfg4F8FFhwhuhBFAne9S/IDSGkUWUqelTtkumf5d++/qBWTG4FwMzJxXuL7z81UKHepa03uBl5Q0XAfUzmE57GSQJlJFH7mgxR+q7SUT6E7QjJ8b46TreLpd+OzMjCB9pkV94sdEAZd259Gs657SDjo+WUAal+NnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sZh16/9/LFm7WS4n7QuQOW1sflssmbGfR9+F4k4oF4I=;
 b=cDpjOPO/Z3lMJfzisviSVPbcX3aklebwzvBg/L57lfSgIC0B7i1AJiw3VVU7C05QTxZnWjAQ05ArtCtUw9L8WEWZ1JN1YBR1PUZvijLHEGbIiHgE4pffezNoYahjVYIBSTgKKth6R8LOsnmnQNWxHE8b6RzKEzDhaRW7KSxn6zg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=voleatech.de;
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11) by AM4PR0501MB2658.eurprd05.prod.outlook.com
 (2603:10a6:200:61::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.24; Tue, 16 Jun
 2020 04:35:30 +0000
Received: from AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39]) by AM4PR0501MB2785.eurprd05.prod.outlook.com
 ([fe80::39a1:e237:5fef:6f39%11]) with mapi id 15.20.3088.029; Tue, 16 Jun
 2020 04:35:30 +0000
Date:   Tue, 16 Jun 2020 06:35:29 +0200
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     netdev@vger.kernel.org
Cc:     antoine.tenart@bootlin.com, gregory.clement@bootlin.com,
        maxime.chevallier@bootlin.com, thomas.petazzoni@bootlin.com,
        miquel.raynal@bootlin.com, mw@semihalf.com, lorenzo@kernel.org,
        technoboy85@gmail.com
Subject: [PATCH 1/1 v2] mvpp2: remove module bugfix
Message-ID: <20200616043529.gs2vcdryka7t4hjo@SvensMacBookAir.sven.lan>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-ClientProxiedBy: FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:14::11) To AM4PR0501MB2785.eurprd05.prod.outlook.com
 (2603:10a6:200:5d::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from SvensMacBookAir.sven.lan (149.172.153.214) by FR2P281CA0024.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:14::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3088.18 via Frontend Transport; Tue, 16 Jun 2020 04:35:30 +0000
X-Originating-IP: [149.172.153.214]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ccd4766e-8b7c-47eb-3767-08d811aeb365
X-MS-TrafficTypeDiagnostic: AM4PR0501MB2658:
X-Microsoft-Antispam-PRVS: <AM4PR0501MB2658D35DB48CFAE463043B39EF9D0@AM4PR0501MB2658.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2512;
X-Forefront-PRVS: 04362AC73B
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: veYOhN7zGl7IehWkd4hOuSuTiYhp/AHw+JvkC7mHgijeMvRxfvneIPhewc3nNF29V6zgf+qUPwESWUQtCfpHU0Mtvo3RhCq7ycRiE5YTVZdMaocTCSc6HE5t7sv9AapOCKcK6GRxLZYDEbC6DBIY5nVyzCqSTJlZHU4v13i6wprKnOcqSLtrlveIU+DZ0B6JUfh8HD2a6srk3FXgZqFECn7VPRU8MhJErMJWYpRxiJ7dR675Q9dPVWHJ0cVlxv8MFN0PJOeco4Dqx37eGyNCcXanNmn7A2SPKQW5UdeZigs9KfhTCJ9yI4RI1L2BARPT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0501MB2785.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(39830400003)(346002)(396003)(376002)(366004)(6506007)(186003)(83380400001)(1076003)(16526019)(4326008)(44832011)(2906002)(8936002)(508600001)(26005)(9686003)(55016002)(956004)(6916009)(66946007)(316002)(52116002)(66556008)(66476007)(86362001)(5660300002)(8676002)(7696005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 3qRboGvn7wa2Dc0AZP1SuHQ1ZTgpEtHdminM1at4+Q9nHIDN9f9xA0zYI8Fao9bwhz0uXd0q62dXPwy/vZhHhgs8vSAD2D7PuiNBrZYDeJHDY0ZCMKWgmK6D2PpiMi8YkOKJpO0tYIikg/GW5F9ppYHg2zryNCKH8u6YN0cXNrlYTeWPx+6ujB0+wLI6BzamGGeYtZm8h2qGKpFmPogkDi3Xm1m8ZCpmiZ69L1MOrGxVD9SlCrHhaPrj5/VqLDSD/l0VoVVwzlpW8DtcSVs3axpIgYithHePSo6A4oUIf1AB0hjCEODso/SzWxV81XMh87pv7EB9HJi9gQcIOHM0qhw7WgX+LZANWQbztBFuzsUML4/t9nTwRgO+vnIEE/7e8tVamZXj1aOkqRupYnXP8K0u6n5RFILiQhpJalTLssgQbcsdl0HGCZpJ4yvtFXC7diRk70FLaus1Mvslm/efb++K9TvzpF2EdD1MllFHUfdHcR2bnZEjTsZWucbUhMqO
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: ccd4766e-8b7c-47eb-3767-08d811aeb365
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2020 04:35:30.6990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvN/llTZJG8dqchnmn6AxTUjntetaaC8yvc+CGnq/AucZMyoynTokvMhg9mRm7QdsO2MCtxxL54awC8pW4F5YoEwjfKAoZjUS3uhF2+jtcY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2658
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

v2:
* add Fixes tag

Fixes: 7d04b0b13b11 ("mvpp2: percpu buffers")
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

