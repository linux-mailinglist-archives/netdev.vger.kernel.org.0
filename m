Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 352EB14460A
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 21:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728831AbgAUUnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 15:43:25 -0500
Received: from mail-eopbgr150075.outbound.protection.outlook.com ([40.107.15.75]:29568
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727350AbgAUUnY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jan 2020 15:43:24 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DR/hUu+c4qE4a2Xp8ojW0DVZEiohG15fVGKM53nKSmOhC+HLP/knjJGzIfezdAnFMJYDroXVk8Sf+fzcEveD4ecqPDQH1qKQJqz6CWXVnAbPucovjlUKtmuonmrmkTnRLgIli4nkDhQYsE+9XhBefHnoWJd38l8tNCH+C6BiZwo6iuWK+gfFtmCRosEq1d0FMHIWNhZZhnTPp7asWlvH65zdXP1Kkb9cLjLM/dXnjQHK5mEp4l2Xa669RXtUugaUBn0NS5PXhZ4qqr6E/r1Ny0amnWG79alUaPsOBCvR6N23CTXTLnu/Pruy2nYOHweVaX7cl7jK8kkXEBq1kizluQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qg3G7ZeSc+09BiNWsTfdW1cA1un1LFn8tbWesspmPYw=;
 b=n9PMg7v3eqaSkkLbZ8FX1Y4NvtNlZzEWgxAfVBlrv64jJ2ti4pqdo1uUto868hJl3V+FMOzWknh1h8eKBF5e68V1VmciichrP/6YKGuOKRd+O/7Es+LcxnLoBP3lx33WH5kkVD7tvGD7q8wlp8Ks9fRfv1USYavAa9IQOurGfXE13NAPZbwOAOgnIhBEVuRzjzJdq8j+T+Ta1EPXZHNEa2kTadF6ArOEICQshWXjzSL3BUFsSS4AzaImmoxP/CavIrYxOqt8QOAq5Gi9AR2I5yKzeazQvJadZ7Q1Ax/Kk792XUdONKruqL5D14hcgCf4pvUC/EgUDVmDxSDI2FOvtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qg3G7ZeSc+09BiNWsTfdW1cA1un1LFn8tbWesspmPYw=;
 b=J+cyCw/xYIxY8fNAOwvZD5t0VuynjmjocuYpiwvjU0g/dVLAkhDU2kEm9lmil2vZrdz5Z7wsJrKkiLJoquURURcp8mSDHQvf4ZeuERh1mGv1DHjcpPyDduYtt/4GwOkzadfk2Y7lWa7k+BTE0lmULmoagTONwTKoBU2c9Sbykmw=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4381.eurprd05.prod.outlook.com (52.133.13.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.25; Tue, 21 Jan 2020 20:43:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.027; Tue, 21 Jan 2020
 20:43:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "olof@lixom.net" <olof@lixom.net>
CC:     "joe@perches.com" <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix printk format warning
Thread-Topic: [PATCH] net/mlx5e: Fix printk format warning
Thread-Index: AQHVtsqd/1iQZ7q6aE6djst+rs1pTafCRruAgALUZQCADp69gIAg7A4AgAEjTwA=
Date:   Tue, 21 Jan 2020 20:43:18 +0000
Message-ID: <028a4905eaf02dce476e8cfc517b49760f57f577.camel@mellanox.com>
References: <20191220001517.105297-1-olof@lixom.net>
         <ff6dc8997083c5d8968df48cc191e5b9e8797618.camel@perches.com>
         <CAOesGMgxHGBdkdVOoWYpqSF-13iP3itJksCRL8QSiS0diL26dA@mail.gmail.com>
         <CALzJLG-L+0dgW=5AXAB8eMjAa3jaSHVaDLuDsSBf9ahqM0Ti-A@mail.gmail.com>
         <CAOesGMhXHCz+ahs6whKsS32uECVry9Lk6BQxcvczPXgcoh6b6w@mail.gmail.com>
In-Reply-To: <CAOesGMhXHCz+ahs6whKsS32uECVry9Lk6BQxcvczPXgcoh6b6w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 240f0191-23d0-4b1f-6a2c-08d79eb28c1f
x-ms-traffictypediagnostic: VI1PR05MB4381:|VI1PR05MB4381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4381211D15A6F48A6D3612D9BE0D0@VI1PR05MB4381.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0289B6431E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(366004)(199004)(189003)(6486002)(36756003)(478600001)(71200400001)(2906002)(6512007)(4001150100001)(4326008)(86362001)(8936002)(64756008)(76116006)(8676002)(66476007)(66946007)(81166006)(66446008)(81156014)(66556008)(91956017)(54906003)(110136005)(5660300002)(2616005)(53546011)(6506007)(186003)(316002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4381;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: orBY+PUh7p0WcBv8A1ccL54hr82kQPUkzlfUdnB2JzrUSJ0uap2wfF9qks9IQ33ZkCdVgUDKEmhNWQaLoNOf4FjQtxVXUotpI2IdQ+Uddxz21xTNNzSigi8tBNowISMHgRiVTw0IuIQXyiuKkiX0Yyxu6PzAZxb3xckmGqphf5tWe+G8BQEnlbu5HQ538U+9CZsbky4K7h/OtwJJMutf3X2fOzeBDw6Z7+bVrVEvN4NrcXSH8mjLAqLPNCOlKFiKgkv5pqmvCFN3PKcZYHnhPcf1zW2HqPH0QXU5/TGhGvCq93xZxGfGvnDL3YCl6AtmwMh1HSk+fbs/Jxv+WgJttL82jgPsADacoiJMccJHKpK/Cem6/6oQcaskbrCFFYxbRtZUyAa8J1kNLJxHjAsAM1sPq0bdg+NrIpZvS1X0SkNX8gHCODrNUxYapZLgocZM
Content-Type: text/plain; charset="utf-8"
Content-ID: <0AA72A79AB6E2846A43EA8DD6E8650A6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 240f0191-23d0-4b1f-6a2c-08d79eb28c1f
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Jan 2020 20:43:18.7821
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oJq1kHHQRxpL56JFc1pE1JZWUdTa+asOTqhdjuG0JBdA/HmuHgolCwxPJgNPp1TK5GxsZA2RG9K6Cny3Ets2XQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4381
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTAxLTIwIGF0IDE5OjIwIC0wODAwLCBPbG9mIEpvaGFuc3NvbiB3cm90ZToN
Cj4gSGksDQo+IA0KPiBPbiBNb24sIERlYyAzMCwgMjAxOSBhdCA4OjM1IFBNIFNhZWVkIE1haGFt
ZWVkDQo+IDxzYWVlZG1AZGV2Lm1lbGxhbm94LmNvLmlsPiB3cm90ZToNCj4gPiBPbiBTYXQsIERl
YyAyMSwgMjAxOSBhdCAxOjE5IFBNIE9sb2YgSm9oYW5zc29uIDxvbG9mQGxpeG9tLm5ldD4NCj4g
PiB3cm90ZToNCj4gPiA+IE9uIFRodSwgRGVjIDE5LCAyMDE5IGF0IDY6MDcgUE0gSm9lIFBlcmNo
ZXMgPGpvZUBwZXJjaGVzLmNvbT4NCj4gPiA+IHdyb3RlOg0KPiA+ID4gPiBPbiBUaHUsIDIwMTkt
MTItMTkgYXQgMTY6MTUgLTA4MDAsIE9sb2YgSm9oYW5zc29uIHdyb3RlOg0KPiA+ID4gPiA+IFVz
ZSAiJXp1IiBmb3Igc2l6ZV90LiBTZWVuIG9uIEFSTSBhbGxtb2Rjb25maWc6DQo+ID4gPiA+IFtd
DQo+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21s
eDUvY29yZS93cS5jDQo+ID4gPiA+ID4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvd3EuYw0KPiA+ID4gPiBbXQ0KPiA+ID4gPiA+IEBAIC04OSw3ICs4OSw3IEBAIHZv
aWQgbWx4NV93cV9jeWNfd3FlX2R1bXAoc3RydWN0DQo+ID4gPiA+ID4gbWx4NV93cV9jeWMgKndx
LCB1MTYgaXgsIHU4IG5zdHJpZGVzKQ0KPiA+ID4gPiA+ICAgICAgIGxlbiA9IG5zdHJpZGVzIDw8
IHdxLT5mYmMubG9nX3N0cmlkZTsNCj4gPiA+ID4gPiAgICAgICB3cWUgPSBtbHg1X3dxX2N5Y19n
ZXRfd3FlKHdxLCBpeCk7DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gLSAgICAgcHJfaW5mbygiV1FF
IERVTVA6IFdRIHNpemUgJWQgV1EgY3VyIHNpemUgJWQsIFdRRSBpbmRleA0KPiA+ID4gPiA+IDB4
JXgsIGxlbjogJWxkXG4iLA0KPiA+ID4gPiA+ICsgICAgIHByX2luZm8oIldRRSBEVU1QOiBXUSBz
aXplICVkIFdRIGN1ciBzaXplICVkLCBXUUUgaW5kZXgNCj4gPiA+ID4gPiAweCV4LCBsZW46ICV6
dVxuIiwNCj4gPiA+ID4gPiAgICAgICAgICAgICAgIG1seDVfd3FfY3ljX2dldF9zaXplKHdxKSwg
d3EtPmN1cl9zeiwgaXgsIGxlbik7DQo+ID4gPiA+ID4gICAgICAgcHJpbnRfaGV4X2R1bXAoS0VS
Tl9XQVJOSU5HLCAiIiwgRFVNUF9QUkVGSVhfT0ZGU0VULA0KPiA+ID4gPiA+IDE2LCAxLCB3cWUs
IGxlbiwgZmFsc2UpOw0KPiA+ID4gPiA+ICB9DQo+ID4gPiA+IA0KPiA+ID4gPiBPbmUgbWlnaHQg
ZXhwZWN0IHRoZXNlIDIgb3V0cHV0cyB0byBiZSBhdCB0aGUgc2FtZSBLRVJOXzxMRVZFTD4NCj4g
PiA+ID4gdG9vLg0KPiA+ID4gPiBPbmUgaXMgS0VSTl9JTkZPIHRoZSBvdGhlciBLRVJOX1dBUk5J
TkcNCj4gPiA+IA0KPiA+ID4gU3VyZSwgYnV0IEknbGwgbGVhdmUgdGhhdCB1cCB0byB0aGUgZHJp
dmVyIG1haW50YWluZXJzIHRvDQo+ID4gPiBkZWNpZGUvZml4DQo+ID4gPiAtLSBJJ20ganVzdCBh
ZGRyZXNzaW5nIHRoZSB0eXBlIHdhcm5pbmcgaGVyZS4NCj4gPiANCj4gPiBIaSBPbG9mLCBzb3Jy
eSBmb3IgdGhlIGRlbGF5LCBhbmQgdGhhbmtzIGZvciB0aGUgcGF0Y2gsDQo+ID4gDQo+ID4gSSB3
aWxsIGFwcGx5IHRoaXMgdG8gbmV0LW5leHQtbWx4NSBhbmQgd2lsbCBzdWJtaXQgdG8gbmV0LW5l
eHQNCj4gPiBteXNlbGYuDQo+ID4gd2Ugd2lsbCBmaXh1cCBhbmQgYWRkcmVzcyB0aGUgd2Fybmlu
ZyBsZXZlbCBjb21tZW50IGJ5IEpvZS4NCj4gDQo+IFRoaXMgc2VlbXMgdG8gc3RpbGwgYmUgcGVu
ZGluZywgYW5kIHRoZSBtZXJnZSB3aW5kb3cgaXMgc29vbiBoZXJlLg0KPiBBbnkNCj4gY2hhbmNl
IHdlIGNhbiBzZWUgaXQgc2hvdyB1cCBpbiBsaW51eC1uZXh0IHNvb24/DQo+IA0KPiANCg0KSGkg
T2xvZiwNCg0KSSBhbSBzdGlsbCBwcmVwYXJpbmcgbXkgbmV4dCBwdWxsIHJlcXVlc3Qgd2hpY2gg
d2lsbCBpbmNsdWRlIHRoaXMgcGF0Y2gNCkkgd2lsbCBzZW5kIGl0IHNvb24gdG8gbmV0LW5leHQg
YnJhbmNoLCBidXQgc3RpbGwgdGhlIHBhdGNoIHdpbGwgbm90DQpoaXQgbGludXgtbmV4dCB1bnRp
bCB0aGUgbWVyZ2Ugd2luZG93IHdoZW4gbmV0ZGV2IHN1YnN5c3RlbSBpcyBwdWxsZWQNCmludG8g
bGludXgtbmV4dC4uDQoNClRoYW5rcywNClNhZWVkLg0KDQo=
