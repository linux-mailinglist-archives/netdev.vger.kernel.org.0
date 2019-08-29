Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52BFCA185C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 13:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727182AbfH2LZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 07:25:26 -0400
Received: from mail-eopbgr70041.outbound.protection.outlook.com ([40.107.7.41]:44238
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726379AbfH2LZ0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Aug 2019 07:25:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltXMsH6kGHFu/0QpjEklwRLvsBS71VGrxabeCIt0Oje1Gf7Ai70ZyR9snXMQ8oszAwnFYMbtHfdUnkGM/8IBsqxP1c2+OBYaMrP3TMxHL1XiOUiVJ4/HqQTKqh9EEu/Z87WYAqweafcoF/yW/MlGSy4wHhvOavKl3XLgWKxZqKVTjUoFu1hV2DjGVm8PjYB831IQXpcxFvZK0yxrN9+Z89Waw887/xdtHsn01qHS74Oll8orqkTRT17la0yhNHS1IsOFYIxXwNSQFUqLugKPUCHDMT6XyBqb2vFK0Y8Eje0VoK2GD4NWMPWelc9glDGjaiNQqfuI+LDDnIk/e4hXzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JXQ3zK/PbKLonjojBql8a+mqy0TP1lVhGa03o1YqT8=;
 b=DfffNJLTszoSG/NJQu02r2N9IQAdmyRP7qKaoMm2Jxis3Vxb/nBG+ck375fQ+1LSErYSwt5WDllFn6Afxx/ZlipnR2F4FqMDRtDEjuASoMmNgGEYoa1U6ZmGMsrwaCumCFMRRmC7nEsgw4GZXzFLpkzUWNq+xi3hg4zxDVYooLhfRsUnoNVhQHMGvhPJ2RwfMmkEpzFP4xGldisTV++/mfsafPuNpvHhp9WEKekaNivAelLQhfNswl1Ldo0HfaMVY++ZJ7iJuJPmFmi0RNOq7xPa5HOpS3xdHbc4X4u5dJV2nyDXMiBgcY/gtKGGTsiNAzdT9TUpHNNGD3EnzPQQ5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9JXQ3zK/PbKLonjojBql8a+mqy0TP1lVhGa03o1YqT8=;
 b=IFrxUdc3J9smq8qOCxBCM26uAJnW0b+Bd5IYDvR/01q8XnEk2bKKadsY4mE4xwrNId8DeYNppcg4nOiCaTi2J0I1HS1DQBJo4A+sSCJi+oCJUVZjNb7XNPgCTHl7MMC/F/bjFFWOG5eQCofapVnj2iqWIoESifNBblQMv69Gq3Y=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB6784.eurprd04.prod.outlook.com (10.255.196.14) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 11:25:19 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::2029:2840:eb0a:c503]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::2029:2840:eb0a:c503%7]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 11:25:19 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Scott Wood <oss@buserror.net>,
        Valentin Longchamp <valentin@longchamp.me>
CC:     "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] powerpc/kmcent2: update the ethernet devices' phy
 properties
Thread-Topic: [PATCH] powerpc/kmcent2: update the ethernet devices' phy
 properties
Thread-Index: AQHVOo+tR9+M1uKJD0mq0Qh89ZXPe6bgRm6AgAA5LgCAAmO2MIAPAsiAgB5UQQCAAgjGYA==
Date:   Thu, 29 Aug 2019 11:25:19 +0000
Message-ID: <VI1PR04MB5567F47E3CAA778F96F25533ECA20@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <20190714200501.1276-1-valentin@longchamp.me>
         <CADYrJDwvwVThmOwHZ4Moqenf=-iqoHC+yJ_uxtrD8sDso33rjg@mail.gmail.com>
         <2243421e574c72c5e75d27cc0122338e2e0bde63.camel@buserror.net>
         <VI1PR04MB55679AAE8DDC3160B9CCE073ECDC0@VI1PR04MB5567.eurprd04.prod.outlook.com>
         <CADYrJDxsQ3H7b_BHOfmfTNb1OuXt+vzTg4k8Goj8tKPaaOMz_g@mail.gmail.com>
 <b535dcfc3d6b06ca583dc26703d4adc958eacdd8.camel@buserror.net>
In-Reply-To: <b535dcfc3d6b06ca583dc26703d4adc958eacdd8.camel@buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a4c3c1cf-aed0-474e-1643-08d72c739313
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB6784;
x-ms-traffictypediagnostic: VI1PR04MB6784:
x-microsoft-antispam-prvs: <VI1PR04MB6784E12248CD7EFF2967B308ECA20@VI1PR04MB6784.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(346002)(136003)(39860400002)(366004)(13464003)(189003)(199004)(478600001)(26005)(52536014)(2906002)(186003)(102836004)(11346002)(6116002)(3846002)(76176011)(4326008)(33656002)(14454004)(8676002)(446003)(14444005)(256004)(486006)(229853002)(99286004)(110136005)(71200400001)(54906003)(71190400001)(316002)(25786009)(305945005)(66574012)(5660300002)(15650500001)(6436002)(476003)(7736002)(74316002)(86362001)(9686003)(66066001)(53936002)(55016002)(6246003)(53546011)(7696005)(6506007)(64756008)(76116006)(66556008)(81156014)(8936002)(81166006)(66446008)(66946007)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB6784;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: RiJaTdTDCQnBack6Rq6T0nSBTXu2Z5niyUUViOmLjo+Lhovzkmti/N3Ws75nZ25stuFe6stCj5Meo0qpaR2aYA2wm0HimxLnA/dLMeJnffuuVBbyA1Uz20r1CoAftkw5f7vd1/31iA23E/rhlUmGbjH5H5ZpxMj/1aJJFHqU7aNPbX+YnEZHaO5lZPwM7nJPnd03gNQIAMM9OEvg+5mYOWwQ8jKTZmNvwRhXtHz+Rmbb9lGzat47Yv4Y2Ue2lqj+h12CStJOoP86XYGFpl3mdQw9LgRNy6Si34swSHcU+wMp92VmLDKppGxkG98jbE/wDdVslmwiuDVxVyjV4JPWkZboIk7G2oYd7o4rMs6U8slM5iJRhJ4Ewy6a3S5ZNg+hnNnJHYDNMegUAbrwmV7U+HEv8/Uvor3bjcs/jg7BgU8=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4c3c1cf-aed0-474e-1643-08d72c739313
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 11:25:19.5797
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EQll0M3YBMOFSSW3hQzyBxYvSEHwZdg6ogEX1NK/EvPU8HYAU1RVy/jupj4+iwb/z09tmcgMHrIb/DHNcdJqXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6784
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTY290dCBXb29kIDxvc3NAYnVz
ZXJyb3IubmV0Pg0KPiBTZW50OiBXZWRuZXNkYXksIEF1Z3VzdCAyOCwgMjAxOSA3OjE5IEFNDQo+
IFRvOiBWYWxlbnRpbiBMb25nY2hhbXAgPHZhbGVudGluQGxvbmdjaGFtcC5tZT47IE1hZGFsaW4t
Y3Jpc3RpYW4gQnVjdXINCj4gPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT4NCj4gQ2M6IGxpbnV4cHBj
LWRldkBsaXN0cy5vemxhYnMub3JnOyBnYWxha0BrZXJuZWwuY3Jhc2hpbmcub3JnOw0KPiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIHBvd2VycGMva21jZW50
MjogdXBkYXRlIHRoZSBldGhlcm5ldCBkZXZpY2VzJyBwaHkNCj4gcHJvcGVydGllcw0KPiANCj4g
T24gVGh1LCAyMDE5LTA4LTA4IGF0IDIzOjA5ICswMjAwLCBWYWxlbnRpbiBMb25nY2hhbXAgd3Jv
dGU6DQo+ID4gTGUgbWFyLiAzMCBqdWlsLiAyMDE5IMOgIDExOjQ0LCBNYWRhbGluLWNyaXN0aWFu
IEJ1Y3VyDQo+ID4gPG1hZGFsaW4uYnVjdXJAbnhwLmNvbT4gYSDDqWNyaXQgOg0KPiA+ID4NCj4g
PiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+ID4NCj4gPiA+ID4gPiBMZSBk
aW0uIDE0IGp1aWwuIDIwMTkgw6AgMjI6MDUsIFZhbGVudGluIExvbmdjaGFtcA0KPiA+ID4gPiA+
IDx2YWxlbnRpbkBsb25nY2hhbXAubWU+IGEgw6ljcml0IDoNCj4gPiA+ID4gPiA+DQo+ID4gPiA+
ID4gPiBDaGFuZ2UgYWxsIHBoeS1jb25uZWN0aW9uLXR5cGUgcHJvcGVydGllcyB0byBwaHktbW9k
ZSB0aGF0IGFyZQ0KPiA+ID4gPiA+ID4gYmV0dGVyDQo+ID4gPiA+ID4gPiBzdXBwb3J0ZWQgYnkg
dGhlIGZtYW4gZHJpdmVyLg0KPiA+ID4gPiA+ID4NCj4gPiA+ID4gPiA+IFVzZSB0aGUgbW9yZSBy
ZWFkYWJsZSBmaXhlZC1saW5rIG5vZGUgZm9yIHRoZSAyIHNnbWlpIGxpbmtzLg0KPiA+ID4gPiA+
ID4NCj4gPiA+ID4gPiA+IENoYW5nZSB0aGUgUkdNSUkgbGluayB0byByZ21paS1pZCBhcyB0aGUg
Y2xvY2sgZGVsYXlzIGFyZSBhZGRlZA0KPiBieQ0KPiA+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4g
PiBwaHkuDQo+ID4gPiA+ID4gPg0KPiA+ID4gPiA+ID4gU2lnbmVkLW9mZi1ieTogVmFsZW50aW4g
TG9uZ2NoYW1wIDx2YWxlbnRpbkBsb25nY2hhbXAubWU+DQo+ID4gPiA+DQo+ID4gPiA+IEkgZG9u
J3Qgc2VlIGFueSBvdGhlciB1c2VzIG9mIHBoeS1tb2RlIGluIGFyY2gvcG93ZXJwYy9ib290L2R0
cy9mc2wsDQo+IGFuZA0KPiA+ID4gPiBJIHNlZQ0KPiA+ID4gPiBsb3RzIG9mIHBoeS1jb25uZWN0
aW9uLXR5cGUgd2l0aCBmbWFuLiAgTWFkYWxpbiwgZG9lcyB0aGlzIHBhdGNoDQo+IGxvb2sNCj4g
PiA+ID4gT0s/DQo+ID4gPiA+DQo+ID4gPiA+IC1TY290dA0KPiA+ID4NCj4gPiA+IEhpLA0KPiA+
ID4NCj4gPiA+IHdlIGFyZSB1c2luZyAicGh5LWNvbm5lY3Rpb24tdHlwZSIgbm90ICJwaHktbW9k
ZSIgZm9yIHRoZSBOWFAgKGZvcm1lcg0KPiA+ID4gRnJlZXNjYWxlKQ0KPiA+ID4gRFBBQSBwbGF0
Zm9ybXMuIFdoaWxlIHRoZSB0d28gc2VlbSB0byBiZSBpbnRlcmNoYW5nZWFibGUgKCJwaHktbW9k
ZSINCj4gc2VlbXMNCj4gPiA+IHRvIGJlDQo+ID4gPiBtb3JlIHJlY2VudCwgbG9va2luZyBhdCB0
aGUgZGV2aWNlIHRyZWUgYmluZGluZ3MpLCB0aGUgZHJpdmVyIGNvZGUgaW4NCj4gPiA+IExpbnV4
IHNlZW1zDQo+ID4gPiB0byB1c2Ugb25lIG9yIHRoZSBvdGhlciwgbm90IGJvdGggc28gb25lIHNo
b3VsZCBzdGljayB3aXRoIHRoZSB2YXJpYW50DQo+IHRoZQ0KPiA+ID4gZHJpdmVyDQo+ID4gPiBp
cyB1c2luZy4gVG8gbWFrZSB0aGluZ3MgbW9yZSBjb21wbGV4LCB0aGVyZSBtYXkgYmUgZGVwZW5k
ZW5jaWVzIGluDQo+ID4gPiBib290bG9hZGVycywNCj4gPiA+IEkgc2VlIGNvZGUgaW4gdS1ib290
IHVzaW5nIG9ubHkgInBoeS1jb25uZWN0aW9uLXR5cGUiIG9yIG9ubHkgInBoeS0NCj4gbW9kZSIu
DQo+ID4gPg0KPiA+ID4gSSdkIGxlYXZlICJwaHktY29ubmVjdGlvbi10eXBlIiBhcyBpcy4NCj4g
Pg0KPiA+IFNvIEkgaGF2ZSBmaW5hbGx5IGhhZCB0aW1lIHRvIGhhdmUgYSBsb29rIGFuZCBub3cg
SSB1bmRlcnN0YW5kIHdoYXQNCj4gPiBoYXBwZW5zLiBZb3UgYXJlIHJpZ2h0LCB0aGVyZSBhcmUg
Ym9vdGxvYWRlciBkZXBlbmRlbmNpZXM6IHUtYm9vdA0KPiA+IGNhbGxzIGZkdF9maXh1cF9waHlf
Y29ubmVjdGlvbigpIHRoYXQgc29tZWhvdyBpbiBvdXIgY2FzZSBhZGRzIChvcg0KPiA+IGNoYW5n
ZXMgaWYgYWxyZWFkeSBpbiB0aGUgZGV2aWNlIHRyZWUpIHRoZSBwaHktY29ubmVjdGlvbi10eXBl
DQo+ID4gcHJvcGVydHkgdG8gYSB3cm9uZyB2YWx1ZSAhIEJ5IGhhdmluZyBhIHBoeS1tb2RlIGlu
IHRoZSBkZXZpY2UgdHJlZSwNCj4gPiB0aGF0IGlzIG5vdCBjaGFuZ2VkIGJ5IHUtYm9vdCBhbmQg
YnkgY2hhbmNlIHBpY2tlZCB1cCBieSB0aGUga2VybmVsDQo+ID4gZm1hbiBkcml2ZXIgKG9mX2dl
dF9waHlfbW9kZSgpICkgb3ZlciBwaHktY29ubmVjdGlvbi1tb2RlLCB0aGUgYmVsb3cNCj4gPiBw
YXRjaCBmaXhlcyBpdCBmb3IgdXMuDQo+ID4NCj4gPiBJIGFncmVlIHdpdGggeW91LCBpdCdzIG5v
dCBjb3JyZWN0IHRvIGhhdmUgYm90aCBwaHktY29ubmVjdGlvbi10eXBlDQo+ID4gYW5kIHBoeS1t
b2RlLiBJZGVhbGx5LCB1LWJvb3Qgb24gdGhlIGJvYXJkIHNob3VsZCBiZSByZXdvcmtlZCBzbyB0
aGF0DQo+ID4gaXQgZG9lcyBub3QgcGVyZm9ybSB0aGUgYWJvdmUgd3JvbmcgZml4dXAuIEhvd2V2
ZXIsIGluIGFuICJ1bmZpeGVkIg0KPiA+IC5kdGIgKEkgaGF2ZSBkaXNhYmxlZCBmZHRfZml4dXBf
cGh5X2Nvbm5lY3Rpb24pLCB0aGUgZGV2aWNlIHRyZWUgaW4NCj4gPiB0aGUgZW5kIG9ubHkgaGFz
IGVpdGhlciBwaHktY29ubmVjdGlvbi10eXBlIG9yIHBoeS1tb2RlLCBhY2NvcmRpbmcgdG8NCj4g
PiB3aGF0IHdhcyBjaG9zZW4gaW4gdGhlIC5kdHMgZmlsZS4gQW5kIHRoZSBmbWFuIGRyaXZlciB3
b3JrcyB3ZWxsIHdpdGgNCj4gPiBib3RoICh0aGFua3MgdG8gdGhlIGNhbGwgdG8gb2ZfZ2V0X3Bo
eV9tb2RlKCkgKS4gSSB3b3VsZCB0aGVyZWZvcmUNCj4gPiBhcmd1ZSB0aGF0IGV2ZW4gaWYgYWxs
IG90aGVyIERQQUEgcGxhdGZvcm1zIHVzZSBwaHktY29ubmVjdGlvbi10eXBlLA0KPiA+IHBoeS1t
b2RlIGlzIHZhbGlkIGFzIHdlbGwuIChGdXJ0aGVybW9yZSB3ZSBhbHJlYWR5IGhhdmUgaHVuZHJl
ZHMgb2YNCj4gPiBzdWNoIGJvYXJkcyBpbiB0aGUgZmllbGQgYW5kIHdlIGRvbid0IHJlYWxseSBz
dXBwb3J0ICJyZW1vdGUiIHUtYm9vdA0KPiA+IHVwZGF0ZSwgc28gdGhlIHUtYm9vdCBmaXggaXMg
Z29pbmcgdG8gYmUgZGlmZmljdWx0IGZvciB1cyB0byBwdWxsKS4NCj4gPg0KPiA+IFZhbGVudGlu
DQo+IA0KPiBNYWRhbGluLCBhcmUgeW91IE9LIHdpdGggdGhlIHBhdGNoIGdpdmVuIHRoaXMgZXhw
bGFuYXRpb24/DQo+IA0KPiAtU2NvdHQNCj4gDQoNClllcywgSSB1bmRlcnN0YW5kIHRoYXQgaXQn
cyB0aGUgb25seSBvcHRpb24gdGhleSBoYXZlLCBnaXZlbiB0aGUgaW5hYmlsaXR5DQp0byB1cGdy
YWRlIHUtYm9vdCAodGhpcyBtYXkgcHJvdmUgdG8gYmUgYW4gaXNzdWUgaW4gdGhlIGZ1dHVyZSwg
aW4gb3RoZXINCnNpdHVhdGlvbnMpLg0KDQpBY2tlZC1ieTogTWFkYWxpbiBCdWN1ciA8bWFkYWxp
bi5idWN1ckBueHAuY29tPg0K
