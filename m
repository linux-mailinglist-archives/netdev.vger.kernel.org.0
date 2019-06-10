Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAD43B5E5
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 15:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390300AbfFJNVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 09:21:32 -0400
Received: from rfout1.hes.trendmicro.com ([54.193.4.136]:44396 "EHLO
        rfout1.hes.trendmicro.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388848AbfFJNVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 09:21:32 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2019 09:21:31 EDT
Received: from 0.0.0.0_hes.trendmicro.com (unknown [10.64.14.197])
        by rfout1.hes.trendmicro.com (Postfix) with ESMTPS id CE233112609F;
        Mon, 10 Jun 2019 13:15:04 +0000 (UTC)
Received: from 0.0.0.0_hes.trendmicro.com (unknown [10.64.0.51])
        by rout1.hes.trendmicro.com (Postfix) with SMTP id 1E2CDEFC06F;
        Mon, 10 Jun 2019 13:15:04 +0000 (UTC)
Received: from IND01-MA1-obe.outbound.protection.outlook.com (unknown [104.47.100.56])
        by relay2.hes.trendmicro.com (TrendMicro Hosted Email Security) with ESMTPS id 60483C48017;
        Mon, 10 Jun 2019 13:14:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=thinciit.onmicrosoft.com; s=selector2-thinciit-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUlhW0rBhrKggUM3MS9YoB8Wsmpj4X+v7j0BnYGUG/A=;
 b=tI2pDUDlHaxr8eBFHHMNIF+LMYJTIUmbz3UVmVH62aC6gQmcr2Q3rc4OHGbLk4mEjaFdrd9vOIZBjBJ54/JY8JB0+7X9fKgLzXeZWV4pkd2/lPQ4vO0/A7Ar6UeYam9iP0eKKJXv/s6Af7tUvWGv/hndhuC7bjOGBSiWgzB0hcU=
Received: from MA1PR01MB3963.INDPRD01.PROD.OUTLOOK.COM (20.179.239.80) by
 MA1PR01MB2315.INDPRD01.PROD.OUTLOOK.COM (52.134.147.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.16; Mon, 10 Jun 2019 13:14:56 +0000
Received: from MA1PR01MB3963.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::29f7:2b8f:2837:67e9]) by MA1PR01MB3963.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::29f7:2b8f:2837:67e9%7]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 13:14:56 +0000
From:   Matt Redfearn <matt.redfearn@thinci.com>
To:     Anders Roxell <anders.roxell@linaro.org>,
        Hans Verkuil <hverkuil@xs4all.nl>
CC:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>,
        "stefan@agner.ch" <stefan@agner.ch>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "a.hajda@samsung.com" <a.hajda@samsung.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 5/8] drivers: media: coda: fix warning same module names
Thread-Topic: [PATCH 5/8] drivers: media: coda: fix warning same module names
Thread-Index: AQHVHEzmHmKZqQFlTU6BnaS1W6flKaaOaFGAgAZ4/ACAAAMNgA==
Date:   Mon, 10 Jun 2019 13:14:56 +0000
Message-ID: <c2ff2c77-5c14-4bc4-f59c-7012d272ec76@thinci.com>
References: <20190606094722.23816-1-anders.roxell@linaro.org>
 <d6b79ee0-07c6-ad81-16b0-8cf929cc214d@xs4all.nl>
 <CADYN=9KY5=FzrkC7MKj9QnG-eM1NVuL00w8Xv4yU2r05rhr7WQ@mail.gmail.com>
In-Reply-To: <CADYN=9KY5=FzrkC7MKj9QnG-eM1NVuL00w8Xv4yU2r05rhr7WQ@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To MA1PR01MB3963.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:7f::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=matthew.redfearn@thinci.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [87.242.198.86]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3aa84816-6007-4985-26af-08d6eda5a209
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MA1PR01MB2315;
x-ms-traffictypediagnostic: MA1PR01MB2315:
x-microsoft-antispam-prvs: <MA1PR01MB2315ED05C410E7831765BA13F1130@MA1PR01MB2315.INDPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(39840400004)(366004)(396003)(189003)(199004)(6436002)(6486002)(31696002)(6246003)(6512007)(476003)(478600001)(66066001)(25786009)(486006)(4326008)(2616005)(7736002)(305945005)(54906003)(66556008)(66476007)(68736007)(31686004)(71200400001)(66446008)(71190400001)(446003)(73956011)(11346002)(110136005)(64756008)(66946007)(14454004)(53546011)(26005)(3846002)(7416002)(102836004)(81166006)(99286004)(6116002)(36756003)(229853002)(81156014)(5660300002)(186003)(6506007)(14444005)(52116002)(76176011)(53936002)(316002)(8936002)(386003)(256004)(8676002)(2906002);DIR:OUT;SFP:1102;SCL:1;SRVR:MA1PR01MB2315;H:MA1PR01MB3963.INDPRD01.PROD.OUTLOOK.COM;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: thinci.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Z9sH78Rn7KNwI7c6spiG/yFNBT+Z3/d+9DhzGdaXHj2cqaY0cbJuCBmh/+TuN6TjOI58kKkrq5M/l1/PrdJhqsBBIP8kHl9/qGI8gZ7cF/tZK/3aD5xR+doV0+PsE1lG8ECpNUpKqj8PJTLzY9zctjI+iriRObP2zcdS3D3yHMl3zWd5w43T+F1MSDK9Dd6HHWBTMVzRoB0QRmCVFg8t64Lc7VMCp05txqVUsVyYbK7tzPUwyUb2Ve1/l/HewE1HoZ/uV2kQopJeYphBLLssLeB1O9UtzHL4r+A6mnuSq6671upOM3Qb50ieSZIA50TGCqybOk2XQF3Rv+EN5X5adsWkyVjNSw0AzC8HxdlWLDGCXa6Pirz6qmKfq/DebGWY1/Zt0srS682cDthxCPPbwlbripAuO/k7/EkEolIHauA=
Content-Type: text/plain; charset="utf-8"
Content-ID: <83A8D730AC8F424FB5AD321EA46023BA@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: thinci.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3aa84816-6007-4985-26af-08d6eda5a209
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 13:14:56.6687
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9d1c3c89-8615-4064-88a7-bb1a8537c779
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: matthew.redfearn@thinci.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MA1PR01MB2315
X-TMASE-Version: StarCloud-1.3-8.2.1013-24666.000
X-TMASE-Result: 10--9.674200-4.000000
X-TMASE-MatchedRID: hls5oAVArl/c921WuZy4LvZvT2zYoYOwC/ExpXrHizzI13IEGi/Kk/Vl
        5vsoSSsoekEtDmHYp/k8zgHmpLzZp1/8tX/1KHzF/03t7eXCTBt6i696PjRPiJe4rIe5ItN8tZX
        KImxf+cFOgZA41QBeiY9CL1e45ag4w4mZjhdFeRXwoYkKJX7f8qbwyy5bAB/9T7zqZowzdpJsZN
        KjFdGXFlcPm8xgT5ExjC970acVks94mxFNFWno5/VY7U3NX8Jg+LidURF+DB318H7gy96lDKPFj
        JEFr+olUkOfGeXobzQ1NebtJxIilNLvsKjhs0ldVnRXm1iHN1bEQdG7H66TyF82MXkEdQ77AhDf
        rKTIID2QgB2b2qMifk9om7U1Hgkv8tFXTrGjKwiQwDVygjlXpw==
X-TM-Deliver-Signature: 6B5F4C92B27942A2C4992300E9399402
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzA2LzIwMTkgMTQ6MDMsIEFuZGVycyBSb3hlbGwgd3JvdGU6DQo+IE9uIFRodSwg
NiBKdW4gMjAxOSBhdCAxMjoxMywgSGFucyBWZXJrdWlsIDxodmVya3VpbEB4czRhbGwubmw+IHdy
b3RlOg0KPj4NCj4+IE9uIDYvNi8xOSAxMTo0NyBBTSwgQW5kZXJzIFJveGVsbCB3cm90ZToNCj4+
PiBXaGVuIGJ1aWxkaW5nIHdpdGggQ09ORklHX1ZJREVPX0NPREEgYW5kIENPTkZJR19DT0RBX0ZT
IGVuYWJsZWQgYXMNCj4+PiBsb2FkYWJsZSBtb2R1bGVzLCB3ZSBzZWUgdGhlIGZvbGxvd2luZyB3
YXJuaW5nOg0KPj4+DQo+Pj4gd2FybmluZzogc2FtZSBtb2R1bGUgbmFtZXMgZm91bmQ6DQo+Pj4g
ICAgZnMvY29kYS9jb2RhLmtvDQo+Pj4gICAgZHJpdmVycy9tZWRpYS9wbGF0Zm9ybS9jb2RhL2Nv
ZGEua28NCj4+Pg0KPj4+IFJld29yayBzbyBtZWRpYSBjb2RhIG1hdGNoZXMgdGhlIGNvbmZpZyBm
cmFnbWVudC4gTGVhdmluZyBDT0RBX0ZTIGFzIGlzDQo+Pj4gc2luY2UgdGhhdHMgYSB3ZWxsIGtu
b3duIG1vZHVsZS4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IEFuZGVycyBSb3hlbGwgPGFuZGVy
cy5yb3hlbGxAbGluYXJvLm9yZz4NCj4+PiAtLS0NCj4+PiAgIGRyaXZlcnMvbWVkaWEvcGxhdGZv
cm0vY29kYS9NYWtlZmlsZSB8IDQgKystLQ0KPj4+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0
aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL21l
ZGlhL3BsYXRmb3JtL2NvZGEvTWFrZWZpbGUgYi9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL2NvZGEv
TWFrZWZpbGUNCj4+PiBpbmRleCA1NGU5YTczYTkyYWIuLjU4OGU2YmY3YzE5MCAxMDA2NDQNCj4+
PiAtLS0gYS9kcml2ZXJzL21lZGlhL3BsYXRmb3JtL2NvZGEvTWFrZWZpbGUNCj4+PiArKysgYi9k
cml2ZXJzL21lZGlhL3BsYXRmb3JtL2NvZGEvTWFrZWZpbGUNCj4+PiBAQCAtMSw2ICsxLDYgQEAN
Cj4+PiAgICMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb25seQ0KPj4+DQo+Pj4g
LWNvZGEtb2JqcyA6PSBjb2RhLWNvbW1vbi5vIGNvZGEtYml0Lm8gY29kYS1nZGkubyBjb2RhLWgy
NjQubyBjb2RhLW1wZWcyLm8gY29kYS1tcGVnNC5vIGNvZGEtanBlZy5vDQo+Pj4gK3ZpZGVvLWNv
ZGEtb2JqcyA6PSBjb2RhLWNvbW1vbi5vIGNvZGEtYml0Lm8gY29kYS1nZGkubyBjb2RhLWgyNjQu
byBjb2RhLW1wZWcyLm8gY29kYS1tcGVnNC5vIGNvZGEtanBlZy5vDQo+Pj4NCj4+PiAtb2JqLSQo
Q09ORklHX1ZJREVPX0NPREEpICs9IGNvZGEubw0KPj4+ICtvYmotJChDT05GSUdfVklERU9fQ09E
QSkgKz0gdmlkZW8tY29kYS5vDQo+Pg0KPj4gSG93IGFib3V0IGlteC1jb2RhPyB2aWRlby1jb2Rh
IHN1Z2dlc3RzIGl0IGlzIHBhcnQgb2YgdGhlIHZpZGVvIHN1YnN5c3RlbSwNCj4+IHdoaWNoIGl0
IGlzbid0Lg0KPiANCj4gSSdsbCByZXNlbmQgYSB2MiBzaG9ydGx5IHdpdGggaW14LWNvZGEgaW5z
dGVhZC4NCg0KV2hhdCBhYm91dCBvdGhlciB2ZW5kb3IgU29DcyBpbXBsZW1lbnRpbmcgdGhlIENv
ZGEgSVAgYmxvY2sgd2hpY2ggYXJlIA0Kbm90IGFuIGlteD8gSSdkIHByZWZlciBhIG1vcmUgZ2Vu
ZXJpYyBuYW1lIC0gbWF5YmUgbWVkaWEtY29kYS4NCg0KVGhhbmtzLA0KTWF0dA0KDQo+IA0KPiAN
Cj4gQ2hlZXJzLA0KPiBBbmRlcnMNCj4gDQo+Pg0KPj4gUmVnYXJkcywNCj4+DQo+PiAgICAgICAg
ICBIYW5zDQo+Pg0KPj4+ICAgb2JqLSQoQ09ORklHX1ZJREVPX0lNWF9WRE9BKSArPSBpbXgtdmRv
YS5vDQo+Pj4NCj4+DQo=
