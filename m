Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49A32DEC30
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728715AbfJUM2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:28:08 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:30678
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfJUM2I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:28:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aNrPl0XyGg5y+jWO0Y8GQ/OZMhSJtnKgfFL2kPnJ006/uQaWLtEgSiJMOlV1cpCvYfgZTaMQdd/W1AZxLeULbKIHGrOywgJnJFRMDvX/4k0ErcVa4/izraXSciu9AXR5p5gzodtkSmhvCd4yb5FZpjYv7L6uDmO9VARcQUg9neA1Bo8Z6dYRTPjulwhGI3nz6Hc+IfDjgAEJtH+kimgKMn9+rZetutUUXWyUWBFrhBOjzlR14cDpwl2Vlw/3WTd8qXKAhra7BXBB7rRbWv2Q+qZk+LzGdiZt5ZahjMsg9HxhQGNUB7sHAgzEx/KeV/vD+pn2h9S6nlkR2gx5zf431g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0MsBTaidZuomhrD9inzOzmNiKe4GsRnxUAph4fB2rg=;
 b=Yys+Oq6s6epYXDzoLEAFUFpzTJw4DOLxC8duc+lNU0gUB2lrTKIO3rqGvQlK3tk8Rr1Eu8wmA6Lkvmdc+BXtW/GihRw8LvcG7cariVzlBvYzsYeMSI9Dbbma/sDeLg7qHk9t6ZribMpU73KJWnRPaesOn1Wmjcbwx/25OjjtgXvCCh0qbl4Ko7rZ2E3TLlpTBS7IG2OOovVeuK+bjFnLe0GT+GVTQAYtX84xl35bEvGEn/HFpwgtT0POKew0yg5TgUE9hajShzoz8ppFdA2Go2yhe6j8debmQS5TVwF0cyJMdNBTtTI6R8t8gJFFAONNwqr5t2I+sLrwetXFFzdvKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U0MsBTaidZuomhrD9inzOzmNiKe4GsRnxUAph4fB2rg=;
 b=TVpLa9EQsFmNcLD87RSKlfTKDcqO6pJSOz6006qkXFFKiWhiE+W/tMnWPylYCCu5x8pXjWGTAf6fbzE+yHalwdstWO8RDeaijs9SPEuFUmN7I65085XyMirC+IAuZXAQx+fso7ikUMhGy3njgnJVje7AAxVPHRhyAhLx8dWYsRs=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5807.eurprd04.prod.outlook.com (20.178.204.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Mon, 21 Oct 2019 12:28:04 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 12:28:04 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 6/6] fsl/fman: remove unused struct member
Thread-Topic: [PATCH net-next 6/6] fsl/fman: remove unused struct member
Thread-Index: AQHViAr8GmGDiDi9WU6Aie3P/rPRJg==
Date:   Mon, 21 Oct 2019 12:28:04 +0000
Message-ID: <1571660862-18313-7-git-send-email-madalin.bucur@nxp.com>
References: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
In-Reply-To: <1571660862-18313-1-git-send-email-madalin.bucur@nxp.com>
Reply-To: Madalin-cristian Bucur <madalin.bucur@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [89.37.124.34]
x-clientproxiedby: AM7PR02CA0022.eurprd02.prod.outlook.com
 (2603:10a6:20b:100::32) To VI1PR04MB5567.eurprd04.prod.outlook.com
 (2603:10a6:803:d4::21)
x-mailer: git-send-email 2.1.0
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae55ac4f-86b1-443a-1317-08d756221ec0
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB5807:|VI1PR04MB5807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5807DDE6BF3616E90865348CEC690@VI1PR04MB5807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(189003)(102836004)(486006)(3846002)(26005)(6486002)(446003)(11346002)(2616005)(476003)(6116002)(2906002)(3450700001)(36756003)(86362001)(25786009)(8676002)(6506007)(386003)(7736002)(186003)(305945005)(99286004)(4326008)(6436002)(52116002)(81166006)(81156014)(76176011)(6512007)(66066001)(14454004)(50226002)(478600001)(54906003)(2501003)(8936002)(316002)(5660300002)(110136005)(66946007)(14444005)(71200400001)(71190400001)(256004)(66556008)(66476007)(64756008)(66446008)(43066004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5807;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Kcv9VCJ51xqHy+Mbo2EMuZFAGjC2XSYfrcgAc8QM/tLLJE1b7/oBPQIXZ8X/wdl+7b3KqQfd3VzR62j7vYp7weYGTKZ1UjuE1P1f13yaWHnJZ9s7orFVPmMBly5e2kehisHM1+CErpuAsVuA19crubOcGhIyKSl2r/d0Hgvvs6AEbDnIbgj2e32DhNK2ClS3SpMm6jJwUGIYuJVaP9ag1tWDWCrjoks0EqbafOXllWRplPZfvVm0fabO+HBAOr++k391gbRKZH/6arxxRyPWMdeQDJejeRZg7bloFbFQmhtruZ92MixyG8nM436q3IbbSMvjF4c0GbM055CkNRhrkRESDDMpZoOyuISbAXQFKMgm8vpziBeEyxUhefRU/dcXrlID2HPqU0199dG873kdiqV9LHGPY9b8WXEp2WWegNeg03KnuPt402CULYwsEM5Z
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6F5CB5DC809B2C458B3CC602DF03E589@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae55ac4f-86b1-443a-1317-08d756221ec0
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:28:04.3574
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SXbBlqoI41GxdL7sXb4AdlCSdLkIFw3EHMhGlekZ12aO9iSxOXO15q3Lz8YNvlNjEFnmC3tv6FkQKmgioX0p4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove unused struct member second_largest_buf_size. Also, an out of
bounds access would have occurred in the removed code if there was only
one buffer pool in use.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/fman/fman_port.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_port.c b/drivers/net/=
ethernet/freescale/fman/fman_port.c
index bd76c9730692..87b26f063cc8 100644
--- a/drivers/net/ethernet/freescale/fman/fman_port.c
+++ b/drivers/net/ethernet/freescale/fman/fman_port.c
@@ -435,7 +435,6 @@ struct fman_port_cfg {
=20
 struct fman_port_rx_pools_params {
 	u8 num_of_pools;
-	u16 second_largest_buf_size;
 	u16 largest_buf_size;
 };
=20
@@ -946,8 +945,6 @@ static int set_ext_buffer_pools(struct fman_port *port)
 	port->rx_pools_params.num_of_pools =3D ext_buf_pools->num_of_pools_used;
 	port->rx_pools_params.largest_buf_size =3D
 	    sizes_array[ordered_array[ext_buf_pools->num_of_pools_used - 1]];
-	port->rx_pools_params.second_largest_buf_size =3D
-	    sizes_array[ordered_array[ext_buf_pools->num_of_pools_used - 2]];
=20
 	/* FMBM_RMPD reg. - pool depletion */
 	if (buf_pool_depletion->pools_grp_mode_enable) {
--=20
2.1.0

