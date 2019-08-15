Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F204F8E5D6
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730767AbfHOH67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 03:58:59 -0400
Received: from mail-eopbgr40049.outbound.protection.outlook.com ([40.107.4.49]:5761
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730363AbfHOH67 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Aug 2019 03:58:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bf/7IMNQrCXxBca54fxhwWu9Oh9Bh5yUdGgqOhMGcn/UY+u0rp6pmfDQ8lz+mLgntUZWEaTHErin2AhW4/LDiDuUITEyZin/Xe75n1m0/xAR2S3wdbE+ang3jGp1R4DueDqx6TEqsVVUTOaskVhJLmBTLezUA1LneeqNclQkGSF1ciZFGiXY4sW/m7DHp6Eiw9hzhuo/cj+oYyOHgj1XMKhNNdMHVlAybeEyD9k9dzTeyJFq3eqi4AeIvcUOg+7+ZVoxr2y579xuncaE9ziHCe1VUpUUw1BySyofnQW4Gwc43cmvOWSIpb9P9SeyB4GNww36rDFViW53mWvys3QuGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5/Lejk+FIL1jdjXz3Rl75TOwHW1Y2Yj+5lDNsmyEKE=;
 b=Mv2S2svBOdWPJK8r+7WDLVDugTTHNYf/Q5wTZzuovlJPvCqvKO3an+rWQnynjHHNPmjf0T6KMy72KDZRZBrloVXztFIvyrrg1n0BOudwlU98+wlJAw/sokXoQJKv+1tQWkj/+uggnmBW5/5BrVlprOK4X/otgAjflW1q5NcVDjQW19B7hMR6cwW0zxbjyCpSohZoLo67fBr+PEgMQdj4ZY7nmsUu5qHfU6UCXiybRVW7Hx3Kep9gTln4nkOSeyF795gONDTsIKUphbE5EQHrX52TxWl1AP6747so2K9itPo2JDY57X8czO4mDLqg2ATok7rWkNf08owvYTcrqAQVhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5/Lejk+FIL1jdjXz3Rl75TOwHW1Y2Yj+5lDNsmyEKE=;
 b=LETQKJIYMwNaRT3RsBvO33eKOQofZ/Hwfa/xITJnRXJtjnDc9JRitEqUU2dOoI0L5DPh3dyGpVRxzFnW9N0HiK70IJSHo+fpSF3jb8NAYMM2WL4lRw6OF5Fyqbs+zUojI35hLFJpp3ttE6GaLtjosko4gMvo3pfF2OKnvrWr5dU=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4633.eurprd04.prod.outlook.com (52.135.138.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.16; Thu, 15 Aug 2019 07:58:56 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::c8ca:1c9c:6c3:fb6f%4]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 07:58:56 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     "mkl@pengutronix.de" <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "wg@grandegger.com" <wg@grandegger.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>
Subject: [PATCH] can: flexcan: update hardware feature information for i.MX8QM
Thread-Topic: [PATCH] can: flexcan: update hardware feature information for
 i.MX8QM
Thread-Index: AQHVUz9JHtFxWG8yHEWEXi8hhLkhPQ==
Date:   Thu, 15 Aug 2019 07:58:56 +0000
Message-ID: <20190815075638.23148-1-qiangqing.zhang@nxp.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.17.1
x-clientproxiedby: SG2PR02CA0037.apcprd02.prod.outlook.com
 (2603:1096:3:18::25) To DB7PR04MB4618.eurprd04.prod.outlook.com
 (2603:10a6:5:38::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4862539d-ffaf-48fe-18e9-08d721566bfb
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB7PR04MB4633;
x-ms-traffictypediagnostic: DB7PR04MB4633:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4633E6CB53DE45490F0CED65E6AC0@DB7PR04MB4633.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:949;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(486006)(99286004)(71190400001)(71200400001)(50226002)(25786009)(66066001)(6436002)(6116002)(3846002)(6486002)(305945005)(256004)(14444005)(2616005)(476003)(478600001)(2501003)(15650500001)(4326008)(66946007)(66446008)(64756008)(66556008)(66476007)(54906003)(186003)(110136005)(4744005)(316002)(81156014)(52116002)(5660300002)(81166006)(36756003)(8936002)(1076003)(26005)(53936002)(8676002)(7736002)(2906002)(102836004)(14454004)(386003)(6506007)(86362001)(6512007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4633;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OLkB8mVY8iY6X13013wq09OuXB4nRcrTPWpNDmqY8c9bAGz3qLMw3vpiiCzdk+x1XzX0JtBEWyn4dkirv0rnZDuf/VOxh/Z5FZBBhGWAZe5VHECtgBB7IlUC+Jy8A/Ji7OAR/Qh/nrWPEZUvaeXryzEKrRE/FgubUt9XzqXHITHCROn/AjWdQz0Zac9M9I0aK/D7EUNlTCQTY8H3y/LEagcRDn4w3Hflse/kQo0msgyA88TTO/7jBV2T8rFYkGI36KXk9BoEan1elS2V1+cOHUb23v+EXm8SBv4LZ20V+Aq/1jqB2OIwhtj1t63zsFlH3ITp8e7V3OzuaEwsbgR/GQvEYP6ZReFUcrDwT/vsmY3QQWxYVVQvg/1/1GRPZeZn/GWKVAilrNb2YyunQabp/e9vzsm4mEMH8W8/NKtmwZs=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4862539d-ffaf-48fe-18e9-08d721566bfb
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 07:58:56.2434
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zXVnbGFRYTbGj620MWMTcggWzsCkGCGRDrT+ELQaBP5F81hcAAFxfjTxw4A6rCImCmwTF+uJJRZIoldqaD83wQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4633
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update hardware feature information for i.MX8QM.

Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
---
 drivers/net/can/flexcan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 58a794c7387b..def8cbbc04e8 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -207,7 +207,7 @@
  *   MX35  FlexCAN2  03.00.00.00     no        no        no       no      =
  no           no
  *   MX53  FlexCAN2  03.00.00.00    yes        no        no       no      =
  no           no
  *   MX6s  FlexCAN3  10.00.12.00    yes       yes        no       no      =
 yes           no
- *  MX8QM         ?  ?                ?         ?         ?        ?      =
   ?          yes
+ *  MX8QM  FlexCAN3  03.00.23.00    yes       yes        no       no      =
 yes          yes
  *   VF610 FlexCAN3  ?               no       yes        no      yes      =
 yes?          no
  * LS1021A FlexCAN2  03.00.04.00     no       yes        no       no      =
 yes           no
  * LX2160A FlexCAN3  03.00.23.00     no       yes        no       no      =
 yes          yes
--=20
2.17.1

