Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E1727A4F1
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 11:44:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731715AbfG3Joy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 05:44:54 -0400
Received: from mail-eopbgr70058.outbound.protection.outlook.com ([40.107.7.58]:49058
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727582AbfG3Jox (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Jul 2019 05:44:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DmhpVYwNsmAlJBK8zCEDjxExejFWd/TYgh41cToe4DFH8dq+SpjHofVrhgt7f89KmbzJwW0cpmvEVDcaRsW00jH3azjvZIiKp6wriiWbVX60g3wMFmag64AnIkI7ZYiym40PsJdiBBam+DuC3L/R4o96quPwzpva44kEc7GwjWSduqUnY76X3BkE0LGpl75+KsOvsefX8kU0xdbqA3nJwjC1I7IcCUH14r+puFqxAVoVBNGmOEt4uazWgq4IxsLbYPqsj5ED7WoxvkiSDCCwnhx6AVAthfbjswlJmVwaSuB20NO4SMmDoRjr2mCb94hHwa8W4AWO3cmbWgzYZFoxlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spNztdvJ4d6OQ0BYSigcTka7faAip1kAKsM+wiKw4uM=;
 b=j4ifKwbCKTxI5GuAardJ4ROVAhs5/xHZyDFASnU1QfjHKuNSAaGjOx1eCDwGvqbk7jjRkJlj4NJyXeOdiXPVq5Kj5lM7T/CUnhyCIEf++kiWWnvsGsgvLbz4ywLrnAElVlvlYHxCzWVCQlhLngEq/f7Ib2LU6b3LaWdWpoIF9YG9OhrSH+4xQ/gNz1P7T+Jx4oww2um2BD4PYfLqn/ijvyMKpSc31P6ak8WNtn/4fGogyFWpsd2Pol1iO98Q9PF9T4qK2BIvB8AmjlPCORgUOa41IP4nIqxAdyI8+sd97wtRTVVGK35X+slK4R0dbANuq6VZjizmOAfuVW5MdGEMNA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=nxp.com;dmarc=pass action=none header.from=nxp.com;dkim=pass
 header.d=nxp.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=spNztdvJ4d6OQ0BYSigcTka7faAip1kAKsM+wiKw4uM=;
 b=ZzqN4C427iRJKxnVz/r+Kwh/KTXqvJ7Cd/vhI7k2lBVl5hybrrCKxyqsALAkfyKvpdwh9ULBURM/YnGurProxi2ZTI8JbB1ffyeb5JhetaVOTr+S3Fg9+DJlLNV52SglRzSAETKZL8KLnrcGfFPNMuhbPvPT8eCEJ2j4W2Io4Vk=
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com (20.178.123.21) by
 VI1PR04MB4094.eurprd04.prod.outlook.com (52.133.13.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 09:44:49 +0000
Received: from VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::ccf:422c:9d58:311e]) by VI1PR04MB5567.eurprd04.prod.outlook.com
 ([fe80::ccf:422c:9d58:311e%6]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 09:44:49 +0000
From:   Madalin-cristian Bucur <madalin.bucur@nxp.com>
To:     Scott Wood <oss@buserror.net>,
        Valentin Longchamp <valentin@longchamp.me>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        "galak@kernel.crashing.org" <galak@kernel.crashing.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] powerpc/kmcent2: update the ethernet devices' phy
 properties
Thread-Topic: [PATCH] powerpc/kmcent2: update the ethernet devices' phy
 properties
Thread-Index: AQHVOo+tR9+M1uKJD0mq0Qh89ZXPe6bgRm6AgAA5LgCAAmO2MA==
Date:   Tue, 30 Jul 2019 09:44:49 +0000
Message-ID: <VI1PR04MB55679AAE8DDC3160B9CCE073ECDC0@VI1PR04MB5567.eurprd04.prod.outlook.com>
References: <20190714200501.1276-1-valentin@longchamp.me>
         <CADYrJDwvwVThmOwHZ4Moqenf=-iqoHC+yJ_uxtrD8sDso33rjg@mail.gmail.com>
 <2243421e574c72c5e75d27cc0122338e2e0bde63.camel@buserror.net>
In-Reply-To: <2243421e574c72c5e75d27cc0122338e2e0bde63.camel@buserror.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=madalin.bucur@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4c9c7ce-d6af-4c46-6909-08d714d290a7
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR04MB4094;
x-ms-traffictypediagnostic: VI1PR04MB4094:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <VI1PR04MB4094753B544A41CD182D6E7FECDC0@VI1PR04MB4094.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(39860400002)(346002)(136003)(396003)(51914003)(13464003)(199004)(189003)(6506007)(53546011)(25786009)(256004)(53936002)(102836004)(186003)(74316002)(26005)(6246003)(8676002)(4326008)(14444005)(3846002)(2201001)(15650500001)(2501003)(66066001)(81156014)(81166006)(11346002)(446003)(33656002)(76176011)(8936002)(486006)(68736007)(476003)(99286004)(7696005)(66556008)(14454004)(66946007)(110136005)(55016002)(229853002)(6436002)(86362001)(966005)(6306002)(9686003)(66476007)(305945005)(6116002)(64756008)(71200400001)(66574012)(76116006)(5660300002)(71190400001)(52536014)(2906002)(7736002)(316002)(478600001)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4094;H:VI1PR04MB5567.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: MHp2XVe89h7e1Q9LBT/VqZ1Pzt/xvJCLhqADjCuPwoxFvkouDf86fi4mOnfNeSx/rIpiWK6SP9L+J9n6h6rwNe2cawz7HzryCYV52Kyu0ZX9XXPM7TpPjFzGmPnlA9389Rd/LFHriHsZN8vUYym6nKXDpLWTB0Au0rxzJkmQJeM2EXjoLVgEE/BgxJUFO/b2JnQt6j3MQ+Sr39EWRBWjXHwHC1BGiWniqBxcfiDK2JUqfVUS0lFhk/GQbs7JCOpxbMms9ooKQA89kJUSQli3gglO9B1im/Y2zTR+lElv9l09i0t/KjVaNS+Fn108BfmeWk8xolbubvPlG7zGznqJ1u4YM4Q3Te1ibm6peCbnewj+DQcZM/GqD0zzUljWNLpsOifvDuo1xrfKDuI5RBH2+4c853GYpxoVTzHKEq2zTpA=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4c9c7ce-d6af-4c46-6909-08d714d290a7
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 09:44:49.7333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: madalin.bucur@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4094
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTY290dCBXb29kIDxvc3NAYnVz
ZXJyb3IubmV0Pg0KPiBTZW50OiBTdW5kYXksIEp1bHkgMjgsIDIwMTkgMTA6MjcgUE0NCj4gVG86
IFZhbGVudGluIExvbmdjaGFtcCA8dmFsZW50aW5AbG9uZ2NoYW1wLm1lPjsgbGludXhwcGMtDQo+
IGRldkBsaXN0cy5vemxhYnMub3JnOyBnYWxha0BrZXJuZWwuY3Jhc2hpbmcub3JnDQo+IENjOiBN
YWRhbGluLWNyaXN0aWFuIEJ1Y3VyIDxtYWRhbGluLmJ1Y3VyQG54cC5jb20+DQo+IFN1YmplY3Q6
IFJlOiBbUEFUQ0hdIHBvd2VycGMva21jZW50MjogdXBkYXRlIHRoZSBldGhlcm5ldCBkZXZpY2Vz
JyBwaHkNCj4gcHJvcGVydGllcw0KPiANCj4gT24gU3VuLCAyMDE5LTA3LTI4IGF0IDE4OjAxICsw
MjAwLCBWYWxlbnRpbiBMb25nY2hhbXAgd3JvdGU6DQo+ID4gSGkgU2NvdHQsIEt1bWFyLA0KPiA+
DQo+ID4gTG9va2luZyBhdCB0aGlzIHBhdGNoIEkgaGF2ZSByZWFsaXNlZCB0aGF0IEkgaGFkIGFs
cmVhZHkgc3VibWl0dGVkIGl0DQo+ID4gdG8gdGhlIG1haWxpbmcgbGlzdCBuZWFybHkgMiB5ZWFy
cyBhZ286DQo+ID4NCj4gPiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzg0Mjk0
NC8NCj4gPg0KPiA+IENvdWxkIHlvdSBwbGVhc2UgbWFrZSBzdXJlIHRoYXQgdGhpcyBvbmUgZ2V0
cyBtZXJnZWQgaW4gdGhlIG5leHQNCj4gPiB3aW5kb3csIHNvIHRoYXQgSSBhdm9pZCBmb3JnZXR0
aW5nIHN1Y2ggYSBwYXRjaCBhIDJuZCB0aW1lID8NCj4gPg0KPiA+IFRoYW5rcyBhIGxvdA0KPiAN
Cj4gSSBhZGRlZCBpdCB0byBteSBwYXRjaHdvcmsgdG9kbyBsaXN0OyB0aGFua3MgZm9yIHRoZSBy
ZW1pbmRlci4NCj4gDQo+ID4gTGUgZGltLiAxNCBqdWlsLiAyMDE5IMOgIDIyOjA1LCBWYWxlbnRp
biBMb25nY2hhbXANCj4gPiA8dmFsZW50aW5AbG9uZ2NoYW1wLm1lPiBhIMOpY3JpdCA6DQo+ID4g
Pg0KPiA+ID4gQ2hhbmdlIGFsbCBwaHktY29ubmVjdGlvbi10eXBlIHByb3BlcnRpZXMgdG8gcGh5
LW1vZGUgdGhhdCBhcmUgYmV0dGVyDQo+ID4gPiBzdXBwb3J0ZWQgYnkgdGhlIGZtYW4gZHJpdmVy
Lg0KPiA+ID4NCj4gPiA+IFVzZSB0aGUgbW9yZSByZWFkYWJsZSBmaXhlZC1saW5rIG5vZGUgZm9y
IHRoZSAyIHNnbWlpIGxpbmtzLg0KPiA+ID4NCj4gPiA+IENoYW5nZSB0aGUgUkdNSUkgbGluayB0
byByZ21paS1pZCBhcyB0aGUgY2xvY2sgZGVsYXlzIGFyZSBhZGRlZCBieSB0aGUNCj4gPiA+IHBo
eS4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBWYWxlbnRpbiBMb25nY2hhbXAgPHZhbGVu
dGluQGxvbmdjaGFtcC5tZT4NCj4gDQo+IEkgZG9uJ3Qgc2VlIGFueSBvdGhlciB1c2VzIG9mIHBo
eS1tb2RlIGluIGFyY2gvcG93ZXJwYy9ib290L2R0cy9mc2wsIGFuZCBJIHNlZQ0KPiBsb3RzIG9m
IHBoeS1jb25uZWN0aW9uLXR5cGUgd2l0aCBmbWFuLiAgTWFkYWxpbiwgZG9lcyB0aGlzIHBhdGNo
IGxvb2sgT0s/DQo+IA0KPiAtU2NvdHQNCg0KSGksDQoNCndlIGFyZSB1c2luZyAicGh5LWNvbm5l
Y3Rpb24tdHlwZSIgbm90ICJwaHktbW9kZSIgZm9yIHRoZSBOWFAgKGZvcm1lciBGcmVlc2NhbGUp
DQpEUEFBIHBsYXRmb3Jtcy4gV2hpbGUgdGhlIHR3byBzZWVtIHRvIGJlIGludGVyY2hhbmdlYWJs
ZSAoInBoeS1tb2RlIiBzZWVtcyB0byBiZQ0KbW9yZSByZWNlbnQsIGxvb2tpbmcgYXQgdGhlIGRl
dmljZSB0cmVlIGJpbmRpbmdzKSwgdGhlIGRyaXZlciBjb2RlIGluIExpbnV4IHNlZW1zDQp0byB1
c2Ugb25lIG9yIHRoZSBvdGhlciwgbm90IGJvdGggc28gb25lIHNob3VsZCBzdGljayB3aXRoIHRo
ZSB2YXJpYW50IHRoZSBkcml2ZXINCmlzIHVzaW5nLiBUbyBtYWtlIHRoaW5ncyBtb3JlIGNvbXBs
ZXgsIHRoZXJlIG1heSBiZSBkZXBlbmRlbmNpZXMgaW4gYm9vdGxvYWRlcnMsDQpJIHNlZSBjb2Rl
IGluIHUtYm9vdCB1c2luZyBvbmx5ICJwaHktY29ubmVjdGlvbi10eXBlIiBvciBvbmx5ICJwaHkt
bW9kZSIuDQoNCkknZCBsZWF2ZSAicGh5LWNvbm5lY3Rpb24tdHlwZSIgYXMgaXMuDQoNCk1hZGFs
aW4NCg0KPiA+ID4gLS0tDQo+ID4gPiAgYXJjaC9wb3dlcnBjL2Jvb3QvZHRzL2ZzbC9rbWNlbnQy
LmR0cyB8IDE2ICsrKysrKysrKysrLS0tLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5z
ZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvYXJj
aC9wb3dlcnBjL2Jvb3QvZHRzL2ZzbC9rbWNlbnQyLmR0cw0KPiA+ID4gYi9hcmNoL3Bvd2VycGMv
Ym9vdC9kdHMvZnNsL2ttY2VudDIuZHRzDQo+ID4gPiBpbmRleCA0OGI3Zjk3OTcxMjQuLmMzZTA3
NDFjYWZiMSAxMDA2NDQNCj4gPiA+IC0tLSBhL2FyY2gvcG93ZXJwYy9ib290L2R0cy9mc2wva21j
ZW50Mi5kdHMNCj4gPiA+ICsrKyBiL2FyY2gvcG93ZXJwYy9ib290L2R0cy9mc2wva21jZW50Mi5k
dHMNCj4gPiA+IEBAIC0yMTAsMTMgKzIxMCwxOSBAQA0KPiA+ID4NCj4gPiA+ICAgICAgICAgICAg
ICAgICBmbWFuQDQwMDAwMCB7DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICBldGhlcm5l
dEBlMDAwMCB7DQo+ID4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGZpeGVkLWxp
bmsgPSA8MCAxIDEwMDAgMCAwPjsNCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgcGh5LWNvbm5lY3Rpb24tdHlwZSA9ICJzZ21paSI7DQo+ID4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHBoeS1tb2RlID0gInNnbWlpIjsNCj4gPiA+ICsgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZml4ZWQtbGluayB7DQo+ID4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgc3BlZWQgPSA8MTAwMD47DQo+ID4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgZnVsbC1kdXBsZXg7DQo+ID4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIH07DQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICB9
Ow0KPiA+ID4NCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGV0aGVybmV0QGUyMDAwIHsN
Cj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZml4ZWQtbGluayA9IDwxIDEg
MTAwMCAwIDA+Ow0KPiA+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBwaHktY29u
bmVjdGlvbi10eXBlID0gInNnbWlpIjsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgcGh5LW1vZGUgPSAic2dtaWkiOw0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICBmaXhlZC1saW5rIHsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBzcGVlZCA9IDwxMDAwPjsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBmdWxsLWR1cGxleDsNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfTsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIH07DQo+ID4gPg0K
PiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgZXRoZXJuZXRAZTQwMDAgew0KPiA+ID4gQEAg
LTIyOSw3ICsyMzUsNyBAQA0KPiA+ID4NCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIGV0
aGVybmV0QGU4MDAwIHsNCj4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcGh5
LWhhbmRsZSA9IDwmZnJvbnRfcGh5PjsNCj4gPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgcGh5LWNvbm5lY3Rpb24tdHlwZSA9ICJyZ21paSI7DQo+ID4gPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgIHBoeS1tb2RlID0gInJnbWlpLWlkIjsNCj4gPiA+ICAgICAgICAg
ICAgICAgICAgICAgICAgIH07DQo+ID4gPg0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAg
bWRpbzA6IG1kaW9AZmMwMDAgew0KPiA+ID4gLS0NCj4gPiA+IDIuMTcuMQ0KPiA+ID4NCj4gPg0K
PiA+DQoNCg==
