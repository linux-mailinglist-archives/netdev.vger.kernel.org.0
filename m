Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE84DEC2D
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 14:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbfJUM2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 08:28:01 -0400
Received: from mail-eopbgr150079.outbound.protection.outlook.com ([40.107.15.79]:5347
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727322AbfJUM2A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Oct 2019 08:28:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nXeL7I7GoZxD8gVC32ERVRMuvDnCLDbr2V2awT3+RxEzHPb8ad07MfAbYhT8VYAxq/Tiy4EoVX28kMzRXRflQ5c/i4xThroUx7xL/gyfIL+C5pHcj7EpJ1A9306usr6rc7mJG9z3MGSjsSW5KmeciY4eF2DnI1V+q6Pi94/UTgPBHSErECPoERVDiapPk48JSCzgQqp0vnf7BB+XVKx16icqi1MtvUdIcNoZgIXecIH34z/LTIB9bCgevhr6Rw5+4eY7piXJwPrDnAeH/kYD1VLlNaQYzzfYaBcniRTDDWjlbvOxy+PpASxNcf5lVSy6MrMefnHTjVTthmJ8EGkVzw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC1zzDxcUvxLuAn916NjiU5kJWG8FL/hPoqyYXdHV84=;
 b=Nkf4FWTnW40vZfWtEmMnJRNB7lWZM7ZyJDGkJASWeNatSibaD12OOZn+K/tMruNRUohekSh5gaa5MK7Xh7tBPI/kPK4rUCT31AgMHOagpPat+cGSB9RpxWQm9W/nZvuZr9CSUyhOeznm35LQivl9kQ8vOod+23F9pAqdDqnFGkOeqzi3ZkHVRM/zEkQG4xbV8Wzh11M8UCwPbQLD1OqS0EcjKI54umu+8L8aJD3I16OkctB4TYspiUpu8xsnFgp+4jsQdTmNTgW1swyTtfy5vK6WJqZSpHYqiq5UN9OSxpbbj50F3xeriM6lWIDwGnohWIapSlZryP63Mstsf0Eduw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uC1zzDxcUvxLuAn916NjiU5kJWG8FL/hPoqyYXdHV84=;
 b=lTe28aF7Kk8mdbBdIXUzWNC5r/ke63mXXPUM6ofHB57QxW9kfJGWuV7immL5XOQMMBXASVqaKgj6aCajGC3ODKIlZtfevmNdQvlK/wGnZGsOD8zjau5PnajeZe5kDID614aq1U4wmV8iI9SF+agQ0eEROS9dupUEm/YmZjkXPe0=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB5807.eurprd04.prod.outlook.com (20.178.204.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.18; Mon, 21 Oct 2019 12:27:58 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::75ab:67b7:f87b:dfd4%6]) with mapi id 15.20.2347.028; Mon, 21 Oct 2019
 12:27:58 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Roy Pledge <roy.pledge@nxp.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Madalin-cristian Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 3/6] dpaa_eth: remove redundant code
Thread-Topic: [PATCH net-next 3/6] dpaa_eth: remove redundant code
Thread-Index: AQHViAr4mKAlrgJ6eUCy9/I8UPIH3w==
Date:   Mon, 21 Oct 2019 12:27:58 +0000
Message-ID: <1571660862-18313-4-git-send-email-madalin.bucur@nxp.com>
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
x-ms-office365-filtering-correlation-id: 9e57eef7-562a-416c-1ee4-08d756221b42
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: VI1PR04MB5807:|VI1PR04MB5807:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR04MB5807AD525B9B412A3C19C251EC690@VI1PR04MB5807.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1360;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(189003)(102836004)(486006)(3846002)(26005)(6486002)(446003)(11346002)(2616005)(476003)(6116002)(2906002)(3450700001)(36756003)(86362001)(25786009)(8676002)(6506007)(386003)(7736002)(186003)(305945005)(99286004)(4326008)(6436002)(52116002)(81166006)(81156014)(76176011)(6512007)(66066001)(14454004)(50226002)(478600001)(54906003)(2501003)(8936002)(4744005)(316002)(5660300002)(110136005)(66946007)(71200400001)(71190400001)(256004)(66556008)(66476007)(64756008)(66446008)(43066004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5807;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qfoy3554PVHqZAsrRxABAAa1Ox6ubkTTlXAlk6Wx8S8Rcpsx7yGPLaqqmjhBtG1z2FEGyG4ymaP+SJXlFDxSLXwkN0fom42tEA5InhOIMRS17mvMdlCpCQuejhtoIl5arqJtO85UEo/6wYwtIehzu8dEze3joE/LUjlb0lECnmB41Z/Sg8I/rH5u8EFpJRchnGUzhzZfR84eC1rUIEeYmOwCYx6d3OyUzVVjhojlmELXC4wPgxiLVvIrPQDx1IjRQ7Brt7jTPZY4CmQ84GODtnA9rT/pGZBWVzQxzwUyD90typR+xWgdRkEH2h+sVVrXajYlfkyxY4lUMXkMwV1UO51IJRrLyMiF0TFz18fkKCqJGIMSMnCDE7/ozapAP8+uNpypkDRxInqdoPZSY7tDU+bod5u5okKFPS00x+14msRUQ6Mu6yEzkJhBa6KyDCy7
Content-Type: text/plain; charset="us-ascii"
Content-ID: <39B63123F55D9D4F9367E6FDB21A39FA@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e57eef7-562a-416c-1ee4-08d756221b42
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 12:27:58.4678
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tz1fJc31GuYy0mHQNKEwxFJkCpuWrn79w6iW5zzowGDwKwm3r2DUwgAYaZ4q9kemGzxV/jUzeTblQC4ggPg+2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5807
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Condition was previously checked, removing duplicate code.

Signed-off-by: Madalin Bucur <madalin.bucur@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/e=
thernet/freescale/dpaa/dpaa_eth.c
index 75eeb2ef409f..8d5686d88d30 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2304,10 +2304,6 @@ static enum qman_cb_dqrr_result rx_default_dqrr(stru=
ct qman_portal *portal,
 		return qman_cb_dqrr_consume;
 	}
=20
-	dpaa_bp =3D dpaa_bpid2pool(fd->bpid);
-	if (!dpaa_bp)
-		return qman_cb_dqrr_consume;
-
 	dma_unmap_single(dpaa_bp->dev, addr, dpaa_bp->size, DMA_FROM_DEVICE);
=20
 	/* prefetch the first 64 bytes of the frame or the SGT start */
--=20
2.1.0

