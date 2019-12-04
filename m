Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6AC11129BC
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 11:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727802AbfLDK64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 05:58:56 -0500
Received: from mail-eopbgr70073.outbound.protection.outlook.com ([40.107.7.73]:5367
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727537AbfLDK6z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 05:58:55 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cT2Ofa4hYBYMd0hNuJn9cpRuZVGOcltJXGOlGXyKlRDQVNSaDwSzrNLWBSLzgd3s7ms93IZrnhY9HK7GK4X7gSDhNZKghjNhnIf5K5voBF6vjB2O7Dpzx4e8MeU1q01Pg5xknDAvGec2460xVT4po1bEJhqgcUesldcA4iggg06qd3ne2RnL0t2eVxvKJvNAGwH40Ar/JUGJl29guifFUB0GDHW2VAADv8D35E2b43HW+1VL0nT6ppWl0PZaV0X/3c55nx4Bk/+rjwHyLFjzhVoEAwAPHfk0zgLNUEvvRV/y+4HNQ70ygL9ffEOV8lFz/8tl65OHYYcPrAxaJlMxIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q55tosBjf/c9v2g6W8stSevucZ62vaBs9z0FP7sWqyU=;
 b=mZ0k3cD5A7EcM0wg41RoMB0vPfYIEF1UGmwb10D/UauyrQY4v0EBTBvAh6ICT1Dy1E/yMWVTjlvHrjFEDWpKIfpCQfZYT+qgNrrB1zo974NMh38FPOI/+z+PYKCrTrz1aqt+3OUudqFzWFVSPD9O/jJ36NEXcGQXrNQ0IarJNIlbX5DIlfbg3L6/7V1UWZ/rsy5AzuuPZjKHfuG2knlahckX8yzwCouSI40NS+jDcF7SR8zAa2cGi98fkgP3WY5FtmMh9FZxHHGBu+LpOitUiwmElzcpnaQCDAh+WQ3BiqWTI3sMmSX3jBPz4+/UoKtzEATX/Zyeyug1rpzqq4ha4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q55tosBjf/c9v2g6W8stSevucZ62vaBs9z0FP7sWqyU=;
 b=EW0ODuVeS+OHRvucI3b6e/NLOMSvGXepp3EdF7cJf2W7ndYm7DtRRddvxQdlRXXW87k05MMlV2V7rIQqDbm+4a8mubRt6an5/yEXIfoeHgk+nbFsvAMQ5/5+kISZeaF0upiftLn+IHE6jTTGIxP7lljrKALodgjTrWuAtE5H69g=
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com (52.135.139.151) by
 DB7PR04MB4780.eurprd04.prod.outlook.com (20.176.235.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2495.22; Wed, 4 Dec 2019 10:58:48 +0000
Received: from DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6]) by DB7PR04MB4618.eurprd04.prod.outlook.com
 ([fe80::1c96:c591:7d51:64e6%4]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 10:58:48 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "sean@geanix.com" <sean@geanix.com>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Topic: [PATCH V2 4/4] can: flexcan: add LPSR mode support
Thread-Index: AQHVpOd3D9txXS3dtUSMzmH9fMhQMaepvmsAgAAaIpA=
Date:   Wed, 4 Dec 2019 10:58:47 +0000
Message-ID: <DB7PR04MB46184BF58D78AE8EC56E0F48E65D0@DB7PR04MB4618.eurprd04.prod.outlook.com>
References: <20191127055334.1476-1-qiangqing.zhang@nxp.com>
 <20191127055334.1476-5-qiangqing.zhang@nxp.com>
 <31323458-7807-3e7c-7689-19cb38a23647@pengutronix.de>
In-Reply-To: <31323458-7807-3e7c-7689-19cb38a23647@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=qiangqing.zhang@nxp.com; 
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0488d950-9380-4e14-5541-08d778a8f08e
x-ms-traffictypediagnostic: DB7PR04MB4780:|DB7PR04MB4780:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB7PR04MB4780C685E36FC44A3A75DC36E65D0@DB7PR04MB4780.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0241D5F98C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(136003)(39860400002)(376002)(366004)(199004)(189003)(13464003)(54534003)(6436002)(316002)(2906002)(8936002)(229853002)(55016002)(6306002)(86362001)(9686003)(71200400001)(99286004)(71190400001)(11346002)(4326008)(186003)(53546011)(76176011)(110136005)(54906003)(6506007)(7696005)(6246003)(76116006)(74316002)(25786009)(2501003)(33656002)(64756008)(2201001)(966005)(478600001)(52536014)(14454004)(66946007)(66446008)(66476007)(102836004)(26005)(6116002)(8676002)(66556008)(305945005)(3846002)(5660300002)(81156014)(81166006)(7736002)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4780;H:DB7PR04MB4618.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CCNxfu8VRiA3wMXZzBiAUIK6wPEgvxouedlDujdfVXbOc9ZkKwSTqtPp8nzvrqTX67Oplnyq6laksnxVfkJQvuJlj1WRxnQTolTk8V13RohKEgZ+q/cSbySlmXp8D2pdXu02njWhAycIREdrV1gY9W/KEcQnhmQehBK6uIEADTsJomOFsI4MkKf+Gi2IBAHYMiZuXUbyHUsnJpshZ7ihFgWHDa1jMI0864hJB4ax8hzzVSc3QYQQuomT611ZoSTQFY0BG/NR0ySMyIBQf4F0Y7cUUEGWT4IytVz59veZ6cxNymaiL+KimXiPLH15uH5gQewVh2S2ycrsaU2luJB4mZ+OPBwqh35fzJdrnVWoldJmYqxpLE7DCEDXbpYsW1mVvhFgwK7HKxpywmqI7aZQUgx/OrAeKzxqFKDzDWVqavT5OjbFdqFhVrWnjC7P2JW8QmFDKSJnBp8sRyUmJOj4ncApsLAj0pzu333bRWQRl5oyjnBGuDXyvE6D7RAW8eu2yEK+tOR/I8nWWrQ3PQAaafySDfhwED7vFfdBirqbHKpMqezEMbKphBW458Wr5OyE
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0488d950-9380-4e14-5541-08d778a8f08e
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2019 10:58:48.0264
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eX9zZr7lRcMtZu2f3sliFs/LuYy78fQk/QoCBUY9kdv14dKOg6rzJXf5TGzYNmhrQobFZPqEE2oghPcH9Nn4ow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4780
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMTnlubQxMuaciDTml6UgMTc6MjENCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBzZWFuQGdlYW5peC5j
b207DQo+IGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGRsLWxpbnV4LWlteCA8bGlu
dXgtaW14QG54cC5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBb
UEFUQ0ggVjIgNC80XSBjYW46IGZsZXhjYW46IGFkZCBMUFNSIG1vZGUgc3VwcG9ydA0KPiANCj4g
T24gMTEvMjcvMTkgNjo1NiBBTSwgSm9ha2ltIFpoYW5nIHdyb3RlOg0KPiA+IEZvciBpLk1YN0Qg
TFBTUiBtb2RlLCB0aGUgY29udHJvbGxlciB3aWxsIGxvc3QgcG93ZXIgYW5kIGdvdCB0aGUNCj4g
PiBjb25maWd1cmF0aW9uIHN0YXRlIGxvc3QgYWZ0ZXIgc3lzdGVtIHJlc3VtZSBiYWNrLiAoY29t
aW5nIGkuTVg4UU0vUVhQDQo+ID4gd2lsbCBhbHNvIGNvbXBsZXRlbHkgcG93ZXIgb2ZmIHRoZSBk
b21haW4sIHRoZSBjb250cm9sbGVyIHN0YXRlIHdpbGwNCj4gPiBiZSBsb3N0IGFuZCBuZWVkcyBy
ZXN0b3JlKS4NCj4gPiBTbyB3ZSBuZWVkIHRvIHNldCBwaW5jdHJsIHN0YXRlIGFnYWluIGFuZCBy
ZS1zdGFydCBjaGlwIHRvIGRvDQo+ID4gcmUtY29uZmlndXJhdGlvbiBhZnRlciByZXN1bWUuDQo+
ID4NCj4gPiBGb3Igd2FrZXVwIGNhc2UsIGl0IHNob3VsZCBub3Qgc2V0IHBpbmN0cmwgdG8gc2xl
ZXAgc3RhdGUgYnkNCj4gPiBwaW5jdHJsX3BtX3NlbGVjdF9zbGVlcF9zdGF0ZS4NCj4gPiBGb3Ig
aW50ZXJmYWNlIGlzIG5vdCB1cCBiZWZvcmUgc3VzcGVuZCBjYXNlLCB3ZSBkb24ndCBuZWVkDQo+
ID4gcmUtY29uZmlndXJlIGFzIGl0IHdpbGwgYmUgY29uZmlndXJlZCBieSB1c2VyIGxhdGVyIGJ5
IGludGVyZmFjZSB1cC4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBaaGFuZyA8cWlh
bmdxaW5nLnpoYW5nQG54cC5jb20+DQo+ID4gLS0tLS0tDQo+ID4gQ2hhbmdlTG9nOg0KPiA+IAlW
MS0+VjI6IG5vIGNoYW5nZS4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4u
YyB8IDIxICsrKysrKysrKysrKysrLS0tLS0tLQ0KPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTQgaW5z
ZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9jYW4vZmxleGNhbi5jIGIvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KPiA+IGluZGV4
IGQxNzgxNDZiM2RhNS4uZDE1MDljZmZkZDI0IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L2Nhbi9mbGV4Y2FuLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9jYW4vZmxleGNhbi5jDQo+ID4g
QEAgLTI2LDYgKzI2LDcgQEANCj4gPiAgI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5o
Pg0KPiA+ICAjaW5jbHVkZSA8bGludXgvcG1fcnVudGltZS5oPg0KPiA+ICAjaW5jbHVkZSA8bGlu
dXgvcmVndWxhdG9yL2NvbnN1bWVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9waW5jdHJsL2Nv
bnN1bWVyLmg+DQo+ID4gICNpbmNsdWRlIDxsaW51eC9yZWdtYXAuaD4NCj4gPg0KPiA+ICAjZGVm
aW5lIERSVl9OQU1FCQkJImZsZXhjYW4iDQo+ID4gQEAgLTE3MDcsNyArMTcwOCw3IEBAIHN0YXRp
YyBpbnQgX19tYXliZV91bnVzZWQNCj4gZmxleGNhbl9zdXNwZW5kKHN0cnVjdA0KPiA+IGRldmlj
ZSAqZGV2aWNlKSAgew0KPiA+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGRldl9nZXRfZHJ2
ZGF0YShkZXZpY2UpOw0KPiA+ICAJc3RydWN0IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9w
cml2KGRldik7DQo+ID4gLQlpbnQgZXJyID0gMDsNCj4gPiArCWludCBlcnI7DQo+ID4NCj4gPiAg
CWlmIChuZXRpZl9ydW5uaW5nKGRldikpIHsNCj4gPiAgCQkvKiBpZiB3YWtldXAgaXMgZW5hYmxl
ZCwgZW50ZXIgc3RvcCBtb2RlIEBAIC0xNzE5LDI1ICsxNzIwLDI3DQo+IEBADQo+ID4gc3RhdGlj
IGludCBfX21heWJlX3VudXNlZCBmbGV4Y2FuX3N1c3BlbmQoc3RydWN0IGRldmljZSAqZGV2aWNl
KQ0KPiA+ICAJCQlpZiAoZXJyKQ0KPiA+ICAJCQkJcmV0dXJuIGVycjsNCj4gPiAgCQl9IGVsc2Ug
ew0KPiA+IC0JCQllcnIgPSBmbGV4Y2FuX2NoaXBfZGlzYWJsZShwcml2KTsNCj4gPiArCQkJZmxl
eGNhbl9jaGlwX3N0b3AoZGV2KTsNCj4gDQo+IGNoaXBfc3RvcCBjYWxscyBjaGlwX2Rpc2FibGUs
IGJ1dCBkb2Vzbid0IHByb3BhZ2F0ZSB0aGUgZXJyb3IgdmFsdWUuDQo+IFBsZWFzZSBjcmVhdGUg
YSBzZXBlcmF0ZSBwYXRjaCB0byBwcm9wYWdhdGUgdGhlIGVycm9yIHZhbHVlIG9mIGNoaXBfc3Rv
cCgpLg0KDQpIaSBNYXJjLA0KDQpJIGZvdW5kIG5vdCBvbmx5IGNoaXBfZGlzYWJsZSBzaG91bGQg
cHJvcGFnYXRlIHRoZSBlcnJvciB2YWx1ZSwgb3RoZXJzIGNoaXBfZnJlZXplLCB0cmFuc2NlaXZl
cl9kaXNhYmxlIGFsc28gbmVlZC4nDQpJIGNvb2sgYSBwYXRjaCBiZWxvdywgaXMgaXQgZmluZSBm
b3IgeW91Pw0KDQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYyBiL2RyaXZl
cnMvbmV0L2Nhbi9mbGV4Y2FuLmMNCmluZGV4IDE5NjAyYjc3OTA3Zi4uYzVlNGI2OTI4ZGVlIDEw
MDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvY2FuL2ZsZXhjYW4uYw0KKysrIGIvZHJpdmVycy9uZXQv
Y2FuL2ZsZXhjYW4uYw0KQEAgLTEyNjMsMTQgKzEyNjMsMTkgQEAgc3RhdGljIGludCBmbGV4Y2Fu
X2NoaXBfc3RhcnQoc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCiAgKg0KICAqIHRoaXMgZnVuY3Rp
b25zIGlzIGVudGVyZWQgd2l0aCBjbG9ja3MgZW5hYmxlZA0KICAqLw0KLXN0YXRpYyB2b2lkIGZs
ZXhjYW5fY2hpcF9zdG9wKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQorc3RhdGljIGludCBmbGV4
Y2FuX2NoaXBfc3RvcChzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KQ0KIHsNCiAgICAgICAgc3RydWN0
IGZsZXhjYW5fcHJpdiAqcHJpdiA9IG5ldGRldl9wcml2KGRldik7DQogICAgICAgIHN0cnVjdCBm
bGV4Y2FuX3JlZ3MgX19pb21lbSAqcmVncyA9IHByaXYtPnJlZ3M7DQorICAgICAgIGludCBlcnI7
DQoNCiAgICAgICAgLyogZnJlZXplICsgZGlzYWJsZSBtb2R1bGUgKi8NCi0gICAgICAgZmxleGNh
bl9jaGlwX2ZyZWV6ZShwcml2KTsNCi0gICAgICAgZmxleGNhbl9jaGlwX2Rpc2FibGUocHJpdik7
DQorICAgICAgIGVyciA9IGZsZXhjYW5fY2hpcF9mcmVlemUocHJpdik7DQorICAgICAgIGlmIChl
cnIpDQorICAgICAgICAgICAgICAgcmV0dXJuIGVycjsNCisgICAgICAgZXJyID0gZmxleGNhbl9j
aGlwX2Rpc2FibGUocHJpdik7DQorICAgICAgIGlmIChlcnIpDQorICAgICAgICAgICAgICAgZ290
byBvdXRfY2hpcF91bmZyZWV6ZTsNCg0KICAgICAgICAvKiBEaXNhYmxlIGFsbCBpbnRlcnJ1cHRz
ICovDQogICAgICAgIHByaXYtPndyaXRlKDAsICZyZWdzLT5pbWFzazIpOw0KQEAgLTEyNzgsOCAr
MTI4MywxOSBAQCBzdGF0aWMgdm9pZCBmbGV4Y2FuX2NoaXBfc3RvcChzdHJ1Y3QgbmV0X2Rldmlj
ZSAqZGV2KQ0KICAgICAgICBwcml2LT53cml0ZShwcml2LT5yZWdfY3RybF9kZWZhdWx0ICYgfkZM
RVhDQU5fQ1RSTF9FUlJfQUxMLA0KICAgICAgICAgICAgICAgICAgICAmcmVncy0+Y3RybCk7DQoN
Ci0gICAgICAgZmxleGNhbl90cmFuc2NlaXZlcl9kaXNhYmxlKHByaXYpOw0KKyAgICAgICBlcnIg
PSBmbGV4Y2FuX3RyYW5zY2VpdmVyX2Rpc2FibGUocHJpdik7DQorICAgICAgIGlmIChlcnIpDQor
ICAgICAgICAgICAgICAgZ290byBvdXRfY2hpcF9lbmFibGU7DQorDQogICAgICAgIHByaXYtPmNh
bi5zdGF0ZSA9IENBTl9TVEFURV9TVE9QUEVEOw0KKw0KKyAgICAgICByZXR1cm4gMDsNCisNCitv
dXRfY2hpcF9lbmFibGU6DQorICAgICAgIGZsZXhjYW5fY2hpcF9lbmFibGUocHJpdik7DQorb3V0
X2NoaXBfdW5mcmVlemU6DQorICAgICAgIGZsZXhjYW5fY2hpcF91bmZyZWV6ZShwcml2KTsNCisg
ICAgICAgcmV0dXJuIGVycjsNCiB9DQoNCiBzdGF0aWMgaW50IGZsZXhjYW5fb3BlbihzdHJ1Y3Qg
bmV0X2RldmljZSAqZGV2KQ0KDQpCZXN0IFJlZ2FyZHMsDQpKb2FraW0gWmhhbmcNCj4gTWFyYw0K
PiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAgICAgfCBNYXJjIEtsZWlu
ZS1CdWRkZSAgICAgICAgICAgfA0KPiBFbWJlZGRlZCBMaW51eCAgICAgICAgICAgICAgICAgICB8
IGh0dHBzOi8vd3d3LnBlbmd1dHJvbml4LmRlICB8DQo+IFZlcnRyZXR1bmcgV2VzdC9Eb3J0bXVu
ZCAgICAgICAgIHwgUGhvbmU6ICs0OS0yMzEtMjgyNi05MjQgICAgIHwNCj4gQW10c2dlcmljaHQg
SGlsZGVzaGVpbSwgSFJBIDI2ODYgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0KDQo=
