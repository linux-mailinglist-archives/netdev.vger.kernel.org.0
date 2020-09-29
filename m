Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE8D927CA5B
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 14:19:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732191AbgI2MS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 08:18:27 -0400
Received: from mail-eopbgr60074.outbound.protection.outlook.com ([40.107.6.74]:35460
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728314AbgI2LgV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 07:36:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8KItFaEKaIABU7QxJtZ7WrhsNPH4VSya2THvoA2fgKAzWbpujEWhvKKUw/XqnD1mG1PjxLw1OrhGm7z/u/pWZhEJF/smvLNopY/OFs5Zx0APOhWo6jbfSxu7aTUpl5gh73FEMiXD0c/lubNiU8/RpxkE2H+4OEaETrPh8BDbnY+aYYgCRX/+67B/IvuNRKrWppswLvHGEiEkiHcaQ/L/6H6HlAXg9LthZUS5idIwAyCJJ/ebQbfxmZYDfqoVRDn1Dfw73t/l2mNBZ33gobnMO2JTl1RgSGwLPB2dPdbJTYWvVleBrR7VrD7ioWjm8IvAb+Ui+qajBeD9xq9mg7VmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5aRuf/ty1nzwsPjbmVy4F+C2kwoYE4sIHWyQHI6X+0=;
 b=OHQNtKl10pH1WPvJ6uAu++mU8gK7loUr7oQEvAuzclqBQm4czes3XTuH33ogmy3RSPtob7M2YA4XBLDixGqvwIBd/0vstnfQ8pidZLFkNo2za0w5lQrR9lppiED0d++jhGE6sgt4G2GChyQr8tO/Pchdkw3AdjDO8NmilbxXpLxTENeEQ4A0kbfW1lQ+1/KsK3i9lG6BUhi0VJ2yI9s0cTxdpyOqUScb3apulGVrYChAA3V7i5cmzoaNILWMYRb73q4r55Q+zSiTeMRcum4fIfFxsM7Zwrx5Wy1+Br++UO7kyC3f/N2iToRLbOwiyLG3uj4Sq6ViQ/gvsRUdz1gxPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=x5aRuf/ty1nzwsPjbmVy4F+C2kwoYE4sIHWyQHI6X+0=;
 b=FQ0U4jyZY4DNQYPJhulva/PWFNMNSBiqbWmEK3aO4qoa/7mYQYlaVXBzVziKbES8kEK5IFrBoTQdLJDz6ehrzDO+qkuT2yAHibNClb0ZIUFOOvEBVU3sJS99H8cxEJhZm7g1HU8gSuLUynJlPqjozKVnSzqpw8lWoD687OJkPVM=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB8PR04MB6794.eurprd04.prod.outlook.com (2603:10a6:10:11b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Tue, 29 Sep
 2020 11:36:16 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.029; Tue, 29 Sep 2020
 11:36:16 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: RE: [PATCH V3 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Topic: [PATCH V3 1/3] can: flexcan: initialize all flexcan memory for
 ECC function
Thread-Index: AQHWlX6LIgjQf3dNuUOzXhPgMCIyi6l/cq0AgAADNeCAAAcIgIAAAJPg
Date:   Tue, 29 Sep 2020 11:36:16 +0000
Message-ID: <DB8PR04MB679573BB9086D40522C7871EE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200928180253.1454-1-qiangqing.zhang@nxp.com>
 <20200928180253.1454-2-qiangqing.zhang@nxp.com>
 <32c4ab0a-2e16-5cf2-5c26-7917d91f3429@pengutronix.de>
 <DB8PR04MB6795C370AFF065F239935F9FE6320@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <95383b2d-698a-355f-2569-45e69bcbab0f@pengutronix.de>
In-Reply-To: <95383b2d-698a-355f-2569-45e69bcbab0f@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 18143155-bd6b-46bb-862f-08d8646be0da
x-ms-traffictypediagnostic: DB8PR04MB6794:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB8PR04MB679435F28D276BEDEC33B82BE6320@DB8PR04MB6794.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X31Cy88PpRr4gsYZlFTtvDmnhZ2JDjssce4Di6hXyvY+t3+XY7pep0V8Zy3ElMr2C4T6Hmja6/yh9YtYowIfr1Xw6MfvzWISn9cm8NM9hcZcTnu2azb4l24TuUWVx4VI+aL+DUG5LZ5XKT89a7IGK77aE5G131fLgDkJJGBoham3xkSdsYkjNgf36hGM4JbHJqtLyBjKZtvGZH2zbEqcf0yMW5sCLKmfQBwGuHLqQ6DfPQoDVLCNKjSJ5ZtxU9whrcRBB64uiG6vbaaxY53wScoWtd+TD0YKQ5XWR7+QovWLYcGoHfjDFgYlJHv0uDivegTGeBlvFjnKBhfTAj46FIuz6USKHxlC+zbjD0gQDSn7yDr9jcROus5pU2nehLq1D03KmJS/KTNu5VuSjcBW6KVRt2wn+irFTgYHDmRwFe4mo+qRZ28VvMAiRDWfIIctltYpSm79FUE0ovj67Y7+qg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6506007)(498600001)(5660300002)(53546011)(71200400001)(66476007)(4326008)(54906003)(66946007)(66556008)(7696005)(2906002)(55016002)(76116006)(52536014)(33656002)(8936002)(66446008)(86362001)(8676002)(186003)(110136005)(966005)(9686003)(26005)(83380400001)(64756008)(83080400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: WgRd0cX6ftSnewuw6KaK+/QD3ePlwEIxHR37pmZcV1xslPNLX02MdgVSe98Q2k+VI6hwwDH/hC1YYYrY/31wy63iXZoeIR48O+KJY/7/A30Vu0rWYDYfI566lmhP774K1HRa2cb8RHRvceC7fYc2c/bqcy8IaZWdRSkoofndH5mhmNFvXvlavdW3317rijLZxfMYyB97OfEFhlaH+Zd4lqTvx5Tq2oFXVSFMxdIJZM0thb4Fg4MsiXsb/OU2lrhrkNliXGCLX38wI/AqlmqRqWDUu95n0BbvPWeSJquQQSV165IgCi8OztOsZqrQDD3Gq2bvpnW4KVrMkcY2E8641sGL6Sh6MZPmFcUIQLkoSqUgdT1m5NX1qVvfzXvL3i46Nqy8nnceDKiBhUcwppKVSv3yYbe9qVJjQhoy3apuuYTaYzz/b7oVgCW7kRRGtriROh+Gud1hVv8xal6xlbfAgT8YwKPvYwCtLHujexCmhUCd/aLMMWBY/D6mLozCTlN/qsDfcJO6/noImS5Ayg9TcgEdiFvKXulaaesV344cHOWnSgPuZYzHDWQGXlSJVhciqFgJxLLJyROMXLFQtp7SddA/lWHX7j7Wr2WZUu5StLOU8djvXp/zUgmwby75DeiEAJqE30oKJdTV6q7yzxYN5g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 18143155-bd6b-46bb-862f-08d8646be0da
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Sep 2020 11:36:16.8605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: B9A3YommorFhFn974hgVZZzD0N55JqkzQJnYB7ysS+gPW6pFb+yZgqF34Jv9nmeV2uja0QjtT4MT+1DLqsGriA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6794
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjnml6UgMTk6MzENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkbC1saW51eC1pbXgg
PGxpbnV4LWlteEBueHAuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFYzIDEvM10gY2FuOiBm
bGV4Y2FuOiBpbml0aWFsaXplIGFsbCBmbGV4Y2FuIG1lbW9yeSBmb3IgRUNDDQo+IGZ1bmN0aW9u
DQo+IA0KPiBPbiA5LzI5LzIwIDE6MjcgUE0sIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPiBbLi4u
XQ0KPiA+Pj4gKwlyZWdfY3RybDIgPSBwcml2LT5yZWFkKCZyZWdzLT5jdHJsMik7DQo+ID4+PiAr
CXJlZ19jdHJsMiB8PSBGTEVYQ0FOX0NUUkwyX1dSTUZSWjsNCj4gPj4+ICsJcHJpdi0+d3JpdGUo
cmVnX2N0cmwyLCAmcmVncy0+Y3RybDIpOw0KPiA+Pj4gKw0KPiA+Pj4gKwkvKiByYW5naW5nIGZy
b20gMHgwMDgwIHRvIDB4MEFERiwgcmFtIGRldGFpbHMgYXMgYmVsb3cgbGlzdDoNCj4gPj4+ICsJ
ICogMHgwMDgwLS0weDA4N0Y6CTEyOCBNQnMNCj4gPj4+ICsJICogMHgwODgwLS0weDBBN0Y6CTEy
OCBSWElNUnMNCj4gPj4+ICsJICogMHgwQTgwLS0weDBBOTc6CTYgUlhGSVJzDQo+ID4+PiArCSAq
IDB4MEE5OC0tMHgwQTlGOglSZXNlcnZlZA0KPiA+Pj4gKwkgKiAweDBBQTAtLTB4MEFBMzoJUlhN
R01BU0sNCj4gPj4+ICsJICogMHgwQUE0LS0weDBBQTc6CVJYRkdNQVNLDQo+ID4+PiArCSAqIDB4
MEFBOC0tMHgwQUFCOglSWDE0TUFTSw0KPiA+Pj4gKwkgKiAweDBBQUMtLTB4MEFBRjoJUlgxNU1B
U0sNCj4gPj4+ICsJICogMHgwQUIwLS0weDBBQkY6CVRYX1NNQg0KPiA+Pj4gKwkgKiAweDBBQzAt
LTB4MEFDRjoJUlhfU01CMA0KPiA+Pj4gKwkgKiAweDBBRDAtLTB4MEFERjoJUlhfU01CMQ0KPiA+
Pg0KPiA+PiBJIGRvbid0IGxpa2UgdG8gaGF2ZSB0aGUgcmVnaXN0ZXIgZGVmaW5pdGlvbiBoZXJl
ICphZ2FpbiksIHdlIGhhdmUNCj4gPj4gc3RydWN0IGZsZXhjYW5fcmVncyBmb3IgdGhpcy4NCj4g
Pg0KPiA+IERvIHlvdSBtZWFuIHN0aWxsIG1vdmUgdGhlc2UgcmVnaXN0ZXIgZGVmaW5pdGlvbnMg
aW50byBmbGV4Y2FuX3JlZ3MsIHJpZ2h0Pw0KPiANCj4gYWNrDQo+IA0KPiA+Pj4gKwkgKi8NCj4g
Pj4+ICsJbWVtc2V0X2lvKCh2b2lkIF9faW9tZW0gKilyZWdzICsgMHg4MCwgMCwgMHhhZGYgLSAw
eDgwICsgMSk7DQo+ID4+DQo+ID4+IHdoeSB0aGUgY2FzdD8NCj4gPg0KPiA+IFllcywgbm8gbmVl
ZCwgd2lsbCByZW1vdmUgaXQuDQo+ID4NCj4gPj4gQ2FuIHlvdSB1c2UgdGhlICImcmVncy0+Zm9v
IC0gJnJlZ3MtPmJhciArIHgiIHRvIGdldCB0aGUgbGVuZ3RoIGZvcg0KPiA+PiB0aGUgbWVtc2V0
Pw0KPiA+DQo+ID4gQWZ0ZXIgbW92ZSBhYm92ZSByZWdpc3RlciBkZWZpbml0aW9uIGludG8gZmxl
eGNhbl9yZWdzLCBJIGNhbiBjaGFuZ2UNCj4gPiB0byB1c2UgdGhpcyB3YXkgdG8gZ2V0IHRoZSBs
ZW5ndGggZm9yIHRoZSBtZW1zZXRfaW8uDQo+IA0KPiBBQ0sNCj4gDQo+ID4+PiArDQo+ID4+PiAr
CS8qIHJhbmdpbmcgZnJvbSAweDBGMjggdG8gMHgwRkZGIHdoZW4gQ0FOIEZEIGZlYXR1cmUgaXMg
ZW5hYmxlZCwNCj4gPj4+ICsJICogcmFtIGRldGFpbHMgYXMgYmVsb3cgbGlzdDoNCj4gPj4+ICsJ
ICogMHgwRjI4LS0weDBGNkY6CVRYX1NNQl9GRA0KPiA+Pj4gKwkgKiAweDBGNzAtLTB4MEZCNzoJ
UlhfU01CMF9GRA0KPiA+Pj4gKwkgKiAweDBGQjgtLTB4MEZGRjoJUlhfU01CMF9GRA0KPiA+Pj4g
KwkgKi8NCj4gPj4+ICsJbWVtc2V0X2lvKCh2b2lkIF9faW9tZW0gKilyZWdzICsgMHhmMjgsIDAs
IDB4ZmZmIC0gMHhmMjggKyAxKTsNCj4gPj4NCj4gPj4gc2FtZSBoZXJlDQo+ID4NCj4gPiBXaWxs
IGNoYW5nZS4NCj4gDQo+IHRueA0KPiANCj4gPiBIaSBNYXJjLCBJJ20gZ29pbmcgb24gaG9saWRh
eSBmcm9tIHRvbW9ycm93LCBzbyBJIHdvdWxkIGRlbGF5IHRvIHNlbmQNCj4gPiBvdXQgYQ0KPiA+
IFY0IHRvIHJldmlldyB1bnRpbCBJIGNvbWUgYmFjaywgc29ycnkgZm9yIHRoaXMuIFRoYW5rcyBm
b3IgeW91cg0KPiA+IGNvbW1lbnRzIG9mDQo+ID4gImNhbjogZmxleGNhbjogYWRkIENBTiB3YWtl
dXAgZnVuY3Rpb24gZm9yIGkuTVg4Iiwgd2lsbCByZXdvcmsgdGhlDQo+ID4gcGF0Y2ggbGF0ZXIu
DQo+IA0KPiBGaW5lIHdpdGggbWUsIEkgdGhpbmsgd2UgY2FuIHB1c2ggdGhlc2UgY2hhbmdlcyB2
aWEgbmV0IHRvIHY1LjEwIGFmdGVyIHRoZSB2NS45DQo+IHJlbGVhc2UgaXMgb3V0Lg0KDQpJIGRv
bid0IGtub3cgd2hldGhlciB0byBydXNoIGludG8gVjUuMTAsIHNpbmNlIEkgd2lsbCBiYWNrIG9u
IE9jdCAxMnRoLiBJZiB5b3UgaGF2ZSBzdWNoIHBsYW4sIEkgd2lsbCByZXdvcmsgdGhlIHBhdGNo
IHJpZ2h0IG5vdy4NCkFmdGVyIEkgdGVzdCwgSSB3aWxsIHNlbmQgb3V0IHRoZSBWNC4NCg0KQmVz
dCBSZWdhcmRzLA0KSm9ha2ltIFpoYW5nDQo+IE1hcmMNCj4gDQo+IC0tDQo+IFBlbmd1dHJvbml4
IGUuSy4gICAgICAgICAgICAgICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4g
RW1iZWRkZWQgTGludXggICAgICAgICAgICAgICAgICAgfCBodHRwczovL3d3dy5wZW5ndXRyb25p
eC5kZSAgfA0KPiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICB8IFBob25lOiArNDkt
MjMxLTI4MjYtOTI0ICAgICB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2IHwg
RmF4OiAgICs0OS01MTIxLTIwNjkxNy01NTU1IHwNCg0K
