Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B628B5D66A
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfGBSug (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:50:36 -0400
Received: from mail-eopbgr20044.outbound.protection.outlook.com ([40.107.2.44]:41735
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726291AbfGBSug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 14:50:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rJCMqi031XOuClcPCPTFsZcHQbF25hC9zVBYT+N7f+g=;
 b=XspYdgvmRusQTBDRnMdq16iKPn0Cp/x2svJTWGPm/bVmovOQTo04YVHuGKOcq6MAQD7i5tECoWVClCF1H8l6q5f5mcoVYGm8yfkIscBsNU7joGgZNykKtC3hRzLdPAymGD43mBJPMnYPMv1vhbTWRXMKptlY0ax0A/E+Tfr10T4=
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (20.176.214.160) by
 AM0PR05MB4147.eurprd05.prod.outlook.com (52.134.124.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.20; Tue, 2 Jul 2019 18:50:32 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::217d:2cd7:c8da:9279%5]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 18:50:32 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: RE: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Topic: [PATCH net-next 1/3] devlink: Introduce PCI PF port flavour and
 port attribute
Thread-Index: AQHVMAhn8T46v1pXDUi3XMXT/4YtI6a2aNkAgABHFVCAAOxagIAAD8wA
Date:   Tue, 2 Jul 2019 18:50:31 +0000
Message-ID: <AM0PR05MB4866C19C9E6ED767A44C3064D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
References: <20190701122734.18770-1-parav@mellanox.com>
        <20190701122734.18770-2-parav@mellanox.com>
        <20190701162650.17854185@cakuba.netronome.com>
        <AM0PR05MB4866085BC8B082EFD5B59DD2D1F80@AM0PR05MB4866.eurprd05.prod.outlook.com>
 <20190702104711.77618f6a@cakuba.netronome.com>
In-Reply-To: <20190702104711.77618f6a@cakuba.netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=parav@mellanox.com; 
x-originating-ip: [106.51.22.216]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1269f7b5-aeec-4009-897d-08d6ff1e28ec
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM0PR05MB4147;
x-ms-traffictypediagnostic: AM0PR05MB4147:
x-microsoft-antispam-prvs: <AM0PR05MB41471112D59E37910BCA18A1D1F80@AM0PR05MB4147.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(366004)(376002)(136003)(396003)(39860400002)(13464003)(199004)(189003)(68736007)(6116002)(3846002)(9456002)(66066001)(14454004)(8936002)(81166006)(81156014)(2906002)(8676002)(4326008)(55236004)(102836004)(478600001)(229853002)(26005)(25786009)(54906003)(86362001)(53546011)(52536014)(7696005)(6506007)(5660300002)(6916009)(76176011)(316002)(6436002)(107886003)(256004)(55016002)(305945005)(7736002)(476003)(186003)(74316002)(33656002)(486006)(9686003)(66556008)(66476007)(66446008)(64756008)(66946007)(73956011)(76116006)(78486014)(446003)(11346002)(53936002)(71190400001)(71200400001)(99286004)(6246003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM0PR05MB4147;H:AM0PR05MB4866.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +Iuyvid0xEo0kybpxvMCx9P8LMgy/RnZ4W5j9BQfi+e6nAAE8kwXUW1LrLO0YMq1toXZ3OPue97wP+vRQxYh3J5ExXhiZAPG55WGCMVZnVPAR/MY9mJF2JVYP+IGsJdrKVIWPSXVFk+AVlN51ZbtbF34bg2Znnt2qxuOjnZT8o5R5rPw8JBYH+9Vs55GmX4NXHYAwqoh3vRGln34V1Ur51hCEy1jLu7DaSUGRheN4osQGc9ystu6lvNu8x9OpvJOY21y8Y5jGvpyJhFZF6O4hY2++jthnZeJc3hro0fR1CNnRKybRWr3h9jBzg3S6uzd7MkoBLRO9tN7STyzmO4cqxZFddvjB6q6WPxfvXYWgeHZVNEh9On5T9MkNfPIf7aijn2RV+7xi6FevyBpudNypmmfb/ouE/Q79FAzjkl0P4M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1269f7b5-aeec-4009-897d-08d6ff1e28ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 18:50:31.8676
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: parav@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMiwg
MjAxOSAxMToxNyBQTQ0KPiBUbzogUGFyYXYgUGFuZGl0IDxwYXJhdkBtZWxsYW5veC5jb20+DQo+
IENjOiBKaXJpIFBpcmtvIDxqaXJpQG1lbGxhbm94LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IFNhZWVkDQo+IE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBTdWJqZWN0OiBS
ZTogW1BBVENIIG5ldC1uZXh0IDEvM10gZGV2bGluazogSW50cm9kdWNlIFBDSSBQRiBwb3J0IGZs
YXZvdXIgYW5kDQo+IHBvcnQgYXR0cmlidXRlDQo+IA0KPiBPbiBUdWUsIDIgSnVsIDIwMTkgMDQ6
MjY6NDcgKzAwMDAsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiA+IE9uIE1vbiwgIDEgSnVsIDIw
MTkgMDc6Mjc6MzIgLTA1MDAsIFBhcmF2IFBhbmRpdCB3cm90ZToNCj4gPiA+ID4gSW4gYW4gZXN3
aXRjaCwgUENJIFBGIG1heSBoYXZlIHBvcnQgd2hpY2ggaXMgbm9ybWFsbHkgcmVwcmVzZW50ZWQN
Cj4gPiA+ID4gdXNpbmcgYSByZXByZXNlbnRvciBuZXRkZXZpY2UuDQo+ID4gPiA+IFRvIGhhdmUg
YmV0dGVyIHZpc2liaWxpdHkgb2YgZXN3aXRjaCBwb3J0LCBpdHMgYXNzb2NpYXRpb24gd2l0aA0K
PiA+ID4gPiBQRiwgYSByZXByZXNlbnRvciBuZXRkZXZpY2UgYW5kIHBvcnQgbnVtYmVyLCBpbnRy
b2R1Y2UgYSBQQ0kgUEYNCj4gPiA+ID4gcG9ydCBmbGF2b3VyIGFuZCBwb3J0IGF0dHJpdXRlLg0K
PiA+ID4gPg0KPiA+ID4gPiBXaGVuIGRldmxpbmsgcG9ydCBmbGF2b3VyIGlzIFBDSSBQRiwgZmls
bCB1cCBQQ0kgUEYgYXR0cmlidXRlcyBvZg0KPiA+ID4gPiB0aGUgcG9ydC4NCj4gPiA+ID4NCj4g
PiA+ID4gRXh0ZW5kIHBvcnQgbmFtZSBjcmVhdGlvbiB1c2luZyBQQ0kgUEYgbnVtYmVyIG9uIGJl
c3QgZWZmb3J0IGJhc2lzLg0KPiA+ID4gPiBTbyB0aGF0IHZlbmRvciBkcml2ZXJzIGNhbiBza2lw
IGRlZmluaW5nIHRoZWlyIG93biBzY2hlbWUuDQo+ID4gPiA+DQo+ID4gPiA+ICQgZGV2bGluayBw
b3J0IHNob3cNCj4gPiA+ID4gcGNpLzAwMDA6MDU6MDAuMC8wOiB0eXBlIGV0aCBuZXRkZXYgZXRo
MCBmbGF2b3VyIHBjaXBmIHBmbnVtIDANCj4gPiA+ID4NCj4gPiA+ID4gQWNrZWQtYnk6IEppcmkg
UGlya28gPGppcmlAbWVsbGFub3guY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBQYXJhdiBQ
YW5kaXQgPHBhcmF2QG1lbGxhbm94LmNvbT4gZGlmZiAtLWdpdA0KPiA+ID4gPiBhL2luY2x1ZGUv
bmV0L2RldmxpbmsuaCBiL2luY2x1ZGUvbmV0L2RldmxpbmsuaCBpbmRleA0KPiA+ID4gPiA2NjI1
ZWEwNjhkNWUuLjhkYjljMGU4M2ZiNSAxMDA2NDQNCj4gPiA+ID4gLS0tIGEvaW5jbHVkZS9uZXQv
ZGV2bGluay5oDQo+ID4gPiA+ICsrKyBiL2luY2x1ZGUvbmV0L2RldmxpbmsuaA0KPiA+ID4gPiBA
QCAtMzgsNiArMzgsMTAgQEAgc3RydWN0IGRldmxpbmsgew0KPiA+ID4gPiAgCWNoYXIgcHJpdlsw
XSBfX2FsaWduZWQoTkVUREVWX0FMSUdOKTsgIH07DQo+ID4gPiA+DQo+ID4gPiA+ICtzdHJ1Y3Qg
ZGV2bGlua19wb3J0X3BjaV9wZl9hdHRycyB7DQo+ID4gPg0KPiA+ID4gV2h5IHRoZSBuYW1lZCBz
dHJ1Y3R1cmU/ICBBbm9ueW1vdXMgb25lIHNob3VsZCBiZSBqdXN0IGZpbmU/DQo+ID4gPg0KPiA+
IE5vIHNwZWNpZmljIHJlYXNvbiBmb3IgdGhpcyBwYXRjaC4gQnV0IG5hbWVkIHN0cnVjdHVyZSBh
bGxvd3MgdG8NCj4gPiBleHRlbmQgaXQgbW9yZSBlYXNpbHkgd2l0aCBjb2RlIHJlYWRhYmlsaXR5
Lg0KPiANCj4gSSdkIGFyZ3VlIHRoZSByZWFkYWJpbGl0eSAtIEkgaG92ZSB0byBzY3JvbGwgdXAv
bG9vayB1cCB0aGUgc3RydWN0dXJlIGp1c3QgdG8gc2VlDQo+IGl0IGhhcyBhIHNpbmdsZSBtZW1i
ZXIuICBCdXQgbm8gYmlnIGRlYWwgOikNCj4gDQpPay4gOi0pDQoNCj4gPiBTdWNoIGFzIHN1YnNl
cXVlbnRseSB3ZSB3YW50IHRvIGFkZCB0aGUgcGVlcl9tYWMgZXRjIHBvcnQgYXR0cmlidXRlcy4N
Cj4gPiBOYW1lZCBzdHJ1Y3R1cmUgdG8gc3RvcmUgdGhvc2UgYXR0cmlidXRlcyBhcmUgaGVscGZ1
bC4NCj4gDQo+IEl0IHJlbWFpbnMgdG8gYmUgc2VlbiBpZiBwZWVyIGF0dHJpYnV0ZXMgYXJlIGZs
YXZvdXIgc3BlY2lmaWMg8J+klA0KPiBJJ2QgaW1hZ2luZSBtb3N0IHBvcnQgdHlwZXMgd291bGQg
aGF2ZSBzb21lIGZvcm0gb2YgYSBwZWVyIChvdGhlciB0aGFuIGENCj4gbmV0d29yayBwb3J0LCBw
ZXJoYXBzKS4gIEJ1dCBwZXJoYXBzIGRpZmZlcmVudCBwZWVyIGF0dHJpYnV0ZXMuDQo+DQpGZXcg
YXR0cmlidXRlcyBtYXkgYmUgY29tbW9uIGFuZCBmZXcgd2lsbCBiZSBwb3J0IHNwZWNpZmljLg0K
U28gYXMgaXQgZXZvbHZlcywgZGF0YSBzdHJ1Y3R1cmUgd2lsbCBldm9sdmUuDQpDb21tb24gYXR0
cmlidXRlIEkgY2FuIHRoaW5rIG9mIGlzIC0gbWFjIGFkZHJlc3MuDQogDQo+ID4gPiA+IGRpZmYg
LS1naXQgYS9uZXQvY29yZS9kZXZsaW5rLmMgYi9uZXQvY29yZS9kZXZsaW5rLmMgaW5kZXgNCj4g
PiA+ID4gODljNTMzNzc4MTM1Li4wMDFmOWUyYzk2ZjAgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL25l
dC9jb3JlL2RldmxpbmsuYw0KPiA+ID4gPiArKysgYi9uZXQvY29yZS9kZXZsaW5rLmMNCj4gPiA+
ID4gQEAgLTUxNyw2ICs1MTcsMTEgQEAgc3RhdGljIGludCBkZXZsaW5rX25sX3BvcnRfYXR0cnNf
cHV0KHN0cnVjdA0KPiBza19idWZmICptc2csDQo+ID4gPiA+ICAJCXJldHVybiAtRU1TR1NJWkU7
DQo+ID4gPiA+ICAJaWYgKG5sYV9wdXRfdTMyKG1zZywgREVWTElOS19BVFRSX1BPUlRfTlVNQkVS
LCBhdHRycy0NCj4gPnBvcnRfbnVtYmVyKSkNCj4gPiA+ID4gIAkJcmV0dXJuIC1FTVNHU0laRTsN
Cj4gPiA+DQo+ID4gPiBXaHkgd291bGQgd2UgcmVwb3J0IG5ldHdvcmsgcG9ydCBpbmZvcm1hdGlv
biBmb3IgUEYgYW5kIFZGIHBvcnQNCj4gPiA+IGZsYXZvdXJzPw0KPiA+DQo+ID4gSSBkaWRuJ3Qg
c2VlIGFueSBpbW1lZGlhdGUgbmVlZCB0byByZXBvcnQsIGF0IHRoZSBzYW1lIHRpbWUgZGlkbid0
DQo+ID4gZmluZCBhbnkgcmVhc29uIHRvIHRyZWF0IHN1Y2ggcG9ydCBmbGF2b3VycyBkaWZmZXJl
bnRseSB0aGFuIGV4aXN0aW5nDQo+ID4gb25lLiBJdCBqdXN0IGdpdmVzIGEgY2xlYXIgdmlldyBv
ZiB0aGUgZGV2aWNlJ3MgZXN3aXRjaC4gTWlnaHQgZmluZCBpdA0KPiA+IHVzZWZ1bCBkdXJpbmcg
ZGVidWdnaW5nIHdoaWxlIGluc3BlY3RpbmcgZGV2aWNlIGludGVybmFsIHRhYmxlcy4uDQo+IA0K
PiBQRnMgYW5kIFZGcyBwb3J0cyBhcmUgbm90IHRpZWQgdG8gbmV0d29yayBwb3J0cyBpbiBzd2l0
Y2hkZXYgbW9kZS4NCj4gWW91IGhhdmUgb25seSBvbmUgbmV0d29yayBwb3J0IHVuZGVyIGEgZGV2
bGluayBpbnN0YW5jZSBBRkFJUiwgYW55d2F5Lg0KPiANCkkgYW0gbm90IHN1cmUgd2hhdCBkbyB5
b3UgbWVhbiBieSBuZXR3b3JrIHBvcnQuDQpEbyB5b3UgaW50ZW50IHRvIHNlZSBhIHBoeXNpY2Fs
IHBvcnQgdGhhdCBjb25uZWN0cyB0byBwaHlzaWNhbCBuZXR3b3JrPw0KDQpBcyBJIGRlc2NyaWJl
ZCBpbiB0aGUgY29tbWVudCBvZiB0aGUgUEYgYW5kIFZGIGZsYXZvdXIsIGl0IGlzIGFuIGVzd2l0
Y2ggcG9ydC4NCkkgaGF2ZSBzaG93biB0aGUgZGlhZ3JhbSBhbHNvIG9mIHRoZSBlc3dpdGNoIGlu
IHRoZSBjb3ZlciBsZXR0ZXIuDQpQb3J0X251bWJlciBkb2Vzbid0IGhhdmUgdG8gYSBwaHlzaWNh
bCBwb3J0LiBGbGF2b3VyIGRlc2NyaWJlIHdoYXQgcG9ydCB0eXBlIGlzIGFuZCBudW1iZXIgc2F5
cyB3aGF0IGlzIHRoZSBlc3dpdGNoIHBvcnQgbnVtYmVyLg0KSG9wZSBpdCBjbGFyaWZpZXMuDQoN
Cj4gPiA+ID4gKwlpZiAoZGV2bGlua19wb3J0LT5hdHRycy5mbGF2b3VyID09IERFVkxJTktfUE9S
VF9GTEFWT1VSX1BDSV9QRikgew0KPiA+ID4gPiArCQlpZiAobmxhX3B1dF91MTYobXNnLCBERVZM
SU5LX0FUVFJfUE9SVF9QQ0lfUEZfTlVNQkVSLA0KPiA+ID4gPiArCQkJCWF0dHJzLT5wY2lfcGYu
cGYpKQ0KPiA+ID4gPiArCQkJcmV0dXJuIC1FTVNHU0laRTsNCj4gPiA+ID4gKwl9DQo+ID4gPiA+
ICAJaWYgKCFhdHRycy0+c3BsaXQpDQo+ID4gPiA+ICAJCXJldHVybiAwOw0KPiA+ID4gPiAgCWlm
IChubGFfcHV0X3UzMihtc2csIERFVkxJTktfQVRUUl9QT1JUX1NQTElUX0dST1VQLA0KPiA+ID4g
PiBhdHRycy0+cG9ydF9udW1iZXIpKQ0K
