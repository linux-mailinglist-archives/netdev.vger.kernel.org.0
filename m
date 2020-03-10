Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A32C17EFAD
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 05:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgCJE2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 00:28:19 -0400
Received: from mail-eopbgr60071.outbound.protection.outlook.com ([40.107.6.71]:26552
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726342AbgCJE2S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 00:28:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VdRG+duEOSF5mdSFhFn9o0WTLRuAJUrgfjaKzN2Cc67d/mLyQU0tzNsDcCllfIsojX6XhGrCbEmY1Rr5nBtdYWBbrrpbTC5EwWR/oF4Bgo+fR9T/LPuwVR2kg8WWMKfQ3ebHggX9578Hw9VglbP1xSGFncQ8IPEh1IVv3X3n2n2I5aEvJYJnEmUwGFD65xc9G5kUjqHs4BnukdSDuCh9E6Ss9DafTfmpF6PeApQMsRG06YnJZ/6An3GJ9uhJRw4CHzPH2hj7k2EYd9evMDLjxd3/Mi8VHiopsgvRFbafWvuGcF2cETJnFBCytFoim/I/KDsS3vrlbspTFOyqOdX8/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3KVCQAuWns/FR2Aecm+25bRRH8Z8YuJbnqRqXBk1xw=;
 b=buUWNp0v8iHX+hruMc5cSEo3yduBHjkJ2EXBP4KW0wOAfXlBFKPPLxWM3fsl6e79+JQonqi8GR5EDtdBaPgz9ZghjXleHfqFyZ2CUvv+pYkiT3KD2e+0YwL/RyuStT/mM/ucNch7K4xnOuxXY24pDoUOa7WlHF4JExoAxaUKvFParW0/Dc1UUzgRVammWs8MLBxiL/oCjekYbVhsGivgbuRDjGupfdlrSzgzYCnpByQZIdBA2VZX9JN84rSFt1iIeT8TYKjw6gjO3R3CTKzWOaFflYKjfosmWzk7P2tlISi+ycpMfs1OLYyTgCy22kG3oDhucfH5X+P2QJbc34bnuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3KVCQAuWns/FR2Aecm+25bRRH8Z8YuJbnqRqXBk1xw=;
 b=b36wcJvfMd5Ri/t2E+ECtrLHrnIjCZ0qtuWyR4L3QsDYH8jMyyJChkw0yNGtdAlC4Uw4RljpcmSHvS59mzS7y1zat5HdMX8fRJN4Y+PpRzRMq8Nd9lPN12dDAF4yXZ3whNLFTGzVpxZ6E8ptCXD2fxWbHaArxFluGbzsUewMSLU=
Received: from DB7PR04MB5242.eurprd04.prod.outlook.com (20.176.234.25) by
 DB7PR04MB5290.eurprd04.prod.outlook.com (20.176.236.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.16; Tue, 10 Mar 2020 04:28:15 +0000
Received: from DB7PR04MB5242.eurprd04.prod.outlook.com
 ([fe80::d55c:9106:6fb2:cc34]) by DB7PR04MB5242.eurprd04.prod.outlook.com
 ([fe80::d55c:9106:6fb2:cc34%4]) with mapi id 15.20.2793.013; Tue, 10 Mar 2020
 04:28:15 +0000
From:   Ganapathi Bhat <ganapathi.bhat@nxp.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Lennert Buytenhek <buytenh@wantstofly.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH][next] wireless: marvell: Replace zero-length array
 with flexible-array member
Thread-Topic: [EXT] [PATCH][next] wireless: marvell: Replace zero-length array
 with flexible-array member
Thread-Index: AQHV63+AsCX3xTX2i06uJeo56Kx146hBOFgg
Date:   Tue, 10 Mar 2020 04:28:14 +0000
Message-ID: <DB7PR04MB52428EFEFA7CD058331CFF848FFF0@DB7PR04MB5242.eurprd04.prod.outlook.com>
References: <20200225020413.GA8057@embeddedor>
In-Reply-To: <20200225020413.GA8057@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ganapathi.bhat@nxp.com; 
x-originating-ip: [115.112.95.158]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c8144e9c-555b-4ba0-f2f1-08d7c4ab7367
x-ms-traffictypediagnostic: DB7PR04MB5290:
x-microsoft-antispam-prvs: <DB7PR04MB5290B07C057BD59BA2A43AC88FFF0@DB7PR04MB5290.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 033857D0BD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(189003)(199004)(478600001)(52536014)(54906003)(5660300002)(110136005)(55016002)(55236004)(6506007)(9686003)(66946007)(66556008)(7696005)(71200400001)(64756008)(2906002)(316002)(76116006)(66476007)(4326008)(44832011)(86362001)(66446008)(4744005)(33656002)(81156014)(186003)(81166006)(8676002)(8936002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5290;H:DB7PR04MB5242.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DrQz+sO7xkgtVtRDVoQ7Zy2PVHR5ZnioOBfrvOvatO3ZzCnwqUKtwByt/1r+por1pQC6YH1Mqj/enH9dwUf1G5Ac2VUu4VwXw+Rh/HEGkLWTmtNDnJPiZbFGqHdCHk2cJJmS32wuPOhnM/v1JrtWhTkQo8BUJc6wavuUqG0ZEx360WIuFfaXZY6/XS5rXCGC+Y9IjW9KpB5Fsazu91pBBiZmR2wvz9EHEYB7t4GNXYmIEYh9/slaTbt6XChx+sCazwe5hyf1ZJnoGUsN/LOHfSKmoMtwzowL28C8pAlka7a6OSyNQPFOOLSB/lKieqhF3raR7b/06Nxxh0e8en7OSGxqMvhZhlKPplhLHPBn3ELUiGJPjtHXGm36epeb5r81QqG+Mf6k+kPallE1+6Gk42ACbuhbK/W97mSXObir2kaFIzzVRnAM7U8cyEfXmj6f
x-ms-exchange-antispam-messagedata: g7MbakOv0WLTXWMT5BtmFA1fW+zIl9/XS70kLzSBIVSYoC6/26kdHZwwwQFQvOP+ZwxtiYIHSHp8ta1ZAquQkE7B5rnpQPi/+RwTKTpqQKH1mkpA1OOTWnKydG9l5yb0qmSTZaMgxUsU499wxw5AgQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8144e9c-555b-4ba0-f2f1-08d7c4ab7367
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Mar 2020 04:28:14.7460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ehJ5UgxYrjJawg8YPGzUTAK4IPZ41jfCnWvYQNHcVwKyKbFmpryI7xDJUlURpdAf/CmaL3Yv72ykK/69NT9QXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5290
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Gustavo,

> The current codebase makes use of the zero-length array language extensio=
n
> to the C90 standard, but the preferred mechanism to declare variable-leng=
th
> types such as these ones is a flexible array member[1][2], introduced in =
C99:
>=20
> struct foo {
>         int stuff;
>         struct boo array[];
> };
>=20
> By making use of the mechanism above, we will get a compiler warning in
> case the flexible array does not occur last in the structure, which will =
help us
> prevent some kind of undefined behavior bugs from being inadvertently
> introduced[3] to the codebase from now on.
>=20
> Also, notice that, dynamic memory allocations won't be affected by this
> change:
>=20
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of zero-len=
gth
> arrays, sizeof evaluates to zero."[1]

Thanks for this path.

Acked-by: Ganapathi Bhat <ganapathi.bhat@nxp.com>
=20
