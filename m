Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFBB94B5F
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 19:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbfHSRLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 13:11:18 -0400
Received: from mail-eopbgr30062.outbound.protection.outlook.com ([40.107.3.62]:20964
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727398AbfHSRLS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 13:11:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mHTCwGDwtUtTuuzxoSF0DYsIvTSA4tSc8r7dgh2NYgnz4CaBvFAnU4gG3COwNXBbNVeQLKVOW6YXXiwybUC4LowRAcmOMISDt/QTIC+ylwVbjTKwYwpnW6Jp54jB6eV+3xVIvaoacqdubiExhH3atcuZzMNOvkf5ifDX63IfyAJW2OERlSJ9FyGjRA3/4xprDC4mHv+eXKgo4RoAR6qGW+sJrpzbggJHkAKblPM7l2rCzKSAtgrKC7fSEd+AwHzSkFWgbiQhgXK+hswAIG3D3niPslKfeU+ztoRRzxcNhOhvO/Ts/dvNjtSgKpF/lE22eQ6eUb4AiaIAZ7SH0EgDeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZ4/t4hwC5Ir+vn8G9F1t23vtpyPOd+wPPZ7wX2I3yE=;
 b=N1p5+CLLvXS+4UHvzYmA5UyOoDM0X6xW4fPQtt3SNde2f0ZX5eTMUclj9rxFogBs+OiVxpCPQZJRESfUzdaA5tQkQsXM+k8rgwPC5CEb2EVEBw9Mr0iD+IVHUA6x9rAM04+ZS5OF6MnP4mXaKMjWwROgeIIl5V1t9TgN6iMeBKNNUY2Uho8ekY9Uh/iSFsJO29cJRbDdPhiJElrQdfAK+IuC/8pau32K2AcIS24rThhsvmN9yIbHC1q0QuucnaqELDL8EgKS3c3uE6NRclBHyG5D68MRGHHdsdbgWZyCp4TcJ3L+DmaQQc5LA0dWdqq4K/2ix8eGBjHaG2fwnvkmoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZ4/t4hwC5Ir+vn8G9F1t23vtpyPOd+wPPZ7wX2I3yE=;
 b=BeDR3QRmKSpX2ujboivrWQeirsRPLEJGxmTSryMNCNDk36Pm14O9aZT59hFbEREKTk+qornSb2qED5knYVsXZCCwjJ+IdOH6ayX5YWb9cwj5F8dO8tyJug7n+pXGILvD1bbHzL29mAJ5TSnpEOhg6paojh8Pio6EmwcNpT9itCQ=
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com (10.172.248.19) by
 DB6PR0402MB2888.eurprd04.prod.outlook.com (10.172.248.135) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Mon, 19 Aug 2019 17:11:14 +0000
Received: from DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90]) by DB6PR0402MB2936.eurprd04.prod.outlook.com
 ([fe80::3519:c2fc:4322:4f90%2]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 17:11:14 +0000
From:   Marco Hartmann <marco.hartmann@nxp.com>
To:     Marco Hartmann <marco.hartmann@nxp.com>,
        Andy Duan <fugang.duan@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Herber <christian.herber@nxp.com>
Subject: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write support 
Thread-Topic: [PATCH net-next 0/1] net: fec: add C45 MDIO read/write support 
Thread-Index: AQHVVrEbaaUHZXnfyUWEGTy4sTss5Q==
Date:   Mon, 19 Aug 2019 17:11:14 +0000
Message-ID: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
Accept-Language: de-DE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR05CA0109.eurprd05.prod.outlook.com
 (2603:10a6:207:2::11) To DB6PR0402MB2936.eurprd04.prod.outlook.com
 (2603:10a6:4:9a::19)
x-mailer: git-send-email 2.7.4
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=marco.hartmann@nxp.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [217.111.68.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8de3efc0-b674-488e-bf89-08d724c83d99
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0402MB2888;
x-ms-traffictypediagnostic: DB6PR0402MB2888:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0402MB288882AC20CE33013DE20BEF8CA80@DB6PR0402MB2888.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(199004)(189003)(66066001)(25786009)(66556008)(478600001)(66446008)(14454004)(64756008)(66476007)(53936002)(3846002)(6116002)(2906002)(52116002)(5660300002)(6506007)(6486002)(386003)(7736002)(4744005)(14444005)(55236004)(256004)(26005)(4743002)(305945005)(66946007)(44832011)(86362001)(2201001)(71190400001)(71200400001)(2501003)(6636002)(102836004)(99286004)(186003)(316002)(81156014)(81166006)(110136005)(8936002)(36756003)(8676002)(50226002)(6512007)(486006)(6436002)(476003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0402MB2888;H:DB6PR0402MB2936.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3nJTKvx/voWEqzkAZeDZwXqNnKSqHEm0RrXmAxooj4ZcFt00ABIlRkvzfiGOYBtVe4qJbKxJxZXlJ3oRyX64aTiGD+tjCDmmpRrOR3i6+e7YwjUbHTY72+LR6ZzAT0IcKkhj5298QWqp0BTAvTuHLIrOEOo38+/AblW//gqpDsGzayNyj7uI8F6nkq8S0T0+wO9I7Zx+yyeTmwJhN6h76Nul6wbSSiOKXM2wB78xCviHkv4Yypt7EN3qVrfpMfinvr+xwyErqJJH7yvzR7eNmty/nwF5BatsxE3DOlvAjuqajbSMkg3itrspyun0ZPi3Ghd8W9ncly+XDOuXBze+kIiKYsiYqdfVHy1dtqxaT/eL6w1l4Evq791FFnsSSsjpRxa9DUexKRVsuCwjzWdtxRJLQ4Sb1Yoho0gcfI6r3lY=
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <F1EEADD381CB8F44994EDA4F5BDA6E79@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8de3efc0-b674-488e-bf89-08d724c83d99
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 17:11:14.3928
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vZDJWcpmkwBxX6KFw5kxPCfm8Sh/r3V9OMquxV4r7dX6n8rZloEEHYv+01J3YawhTLKbA80qotqgT6VwmrMTPQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0402MB2888
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As of yet, the Fast Ethernet Controller (FEC) driver only supports Clause 2=
2
conform MDIO transactions. IEEE 802.3ae Clause 45 defines a modified MDIO
protocol that uses a two staged access model in order to increase the addre=
ss
space.

This patch adds support for Clause 45 conform MDIO read and write operation=
s to
the FEC driver.

Marco Hartmann (1):
  fec: add C45 MDIO read/write support

 drivers/net/ethernet/freescale/fec_main.c | 65 +++++++++++++++++++++++++++=
+---
 1 file changed, 59 insertions(+), 6 deletions(-)

--=20
2.7.4

