Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8014618978B
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 10:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727470AbgCRJC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 05:02:27 -0400
Received: from mail-eopbgr70050.outbound.protection.outlook.com ([40.107.7.50]:26439
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726523AbgCRJC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Mar 2020 05:02:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HfmOwDJnkXjuzQJDXeMKPPspZ50NiEEmForCtZHm/kn7UgOCfzPyZPhX0vCyyjCwZbbFGuRsOP+tShBSulB1man7MYk9qgzzi8HK7NNUc70sT6MP30jR5E8TaWdfZMRvbKTfkIZwr/HOLhDg8y2OyzbmZW2P61Sl0H1WHigo04GMxpRf+9GDsPJYNjwuYWIqbvTHZn2BLT87KXekVThOOhDkfZ16k3hTHPUQaqz1C3iiCV7t9Pi5ZhNq/xO0JOGnU1sfgSM8K/YhkkqAEFjq7Djwqr7UTJ0f89dFca3puJl8TQLe9hYJTo2aBMAhTA5Xa6NlvIjO2bk9Q15qTVZmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeU6SIX63l6k7b4DZXOo5AhU+rG60PfOaW5ir5GcdHg=;
 b=MSgVuKv3ANNlKWq8JVyREW1Gxg6WQ2aESShts77kfnIMnxTOvpSPTHHueNETI8zMuCqEEsEd9kTng2APjoySVcQd4qyEwheTiwmncIkboqrlwLmZu0xo7jjT+vAPrn+UpBrWwrr54uvHzQI0WSi/ZwmaVm4gFM1kU13ZM0i5XFYDCnUlMzWr9LlWbRPgE3HN0L3AHk/u2vCGA3T2D6ZC75WnCBEBw49ZFZns9lKuW00IqgkCfziEGPP65xYUT7p6SbKdspodH0lTEEZw8puUAZhx7NaWg6zzcdjlJxsp/BkHQkOB6Rbk3e5KsCwpC3l1Bs2uQwa9YKmS7WZRoQVy6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JeU6SIX63l6k7b4DZXOo5AhU+rG60PfOaW5ir5GcdHg=;
 b=TG1fBoaAr21MipCEtVO1lvZ/m3kPP3uUavXdj+fKiIwx72ajqh5F9dP5+Fi4cGQFMzgmgsOnOb4biaXsSVSkeuVTYU8n4kCYcCeX1gs7yJYKtqbzGe+y9MQfuk/O5Neyovb2JwyvAJ4oGy48ghZAv7F5syE/88+7rPByCTXYQMQ=
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com (52.134.3.146) by
 VI1PR0402MB3583.eurprd04.prod.outlook.com (52.134.7.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.13; Wed, 18 Mar 2020 09:02:23 +0000
Received: from VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768]) by VI1PR0402MB3600.eurprd04.prod.outlook.com
 ([fe80::c991:848b:cc80:2768%7]) with mapi id 15.20.2814.025; Wed, 18 Mar 2020
 09:02:22 +0000
From:   Andy Duan <fugang.duan@nxp.com>
To:     "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
CC:     Rob Herring <robh+dt@kernel.org>, Shawn Guo <shawnguo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        dl-linux-imx <linux-imx@nxp.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: RE: [EXT] [PATCH 1/4] net: fec: set GPR bit on suspend by DT
 connfiguration.
Thread-Topic: [EXT] [PATCH 1/4] net: fec: set GPR bit on suspend by DT
 connfiguration.
Thread-Index: AQHV/Hwf7o5FT7bkakCxQQlLHyLZc6hN4MmAgAAmsoCAAAWh0A==
Date:   Wed, 18 Mar 2020 09:02:22 +0000
Message-ID: <VI1PR0402MB3600BF8115865C58A463FE37FFF70@VI1PR0402MB3600.eurprd04.prod.outlook.com>
References: <1584463806-15788-1-git-send-email-martin.fuzzey@flowbird.group>
 <1584463806-15788-2-git-send-email-martin.fuzzey@flowbird.group>
 <VI1PR0402MB3600396A11D0AB39FBF9C54AFFF70@VI1PR0402MB3600.eurprd04.prod.outlook.com>
 <CANh8QzxNYzLL8sAXwYEnic2-o-3xzyQaUZZ3LmaRO7fCfgoLQg@mail.gmail.com>
In-Reply-To: <CANh8QzxNYzLL8sAXwYEnic2-o-3xzyQaUZZ3LmaRO7fCfgoLQg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=fugang.duan@nxp.com; 
x-originating-ip: [119.31.174.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3bda70bd-8665-4997-693f-08d7cb1b1260
x-ms-traffictypediagnostic: VI1PR0402MB3583:|VI1PR0402MB3583:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0402MB3583CF207077B3D68AEEAA9BFFF70@VI1PR0402MB3583.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 03468CBA43
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(199004)(33656002)(4326008)(76116006)(71200400001)(6916009)(64756008)(2906002)(86362001)(52536014)(66946007)(66556008)(15650500001)(66446008)(81166006)(66476007)(7696005)(81156014)(186003)(478600001)(8676002)(54906003)(55016002)(9686003)(8936002)(26005)(5660300002)(316002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3583;H:VI1PR0402MB3600.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JlMPaNER1fCP0+ql4AQ/WzmGumj7Ec3+Y3Q9iBGhVepXQWendyJjUyJecGnOYnbT5xqsbWjWpnFs7/sg1n/GgD1B64Plu89n5g9P3wf/G4pETc+vm8E9pALPFxJhIRF18tvEdrrjxZLDCWLt3NgQKZNIJ2eOZEYwBXnBZJuu0o53qWntEE9FYzVVePhiou2DO5J5xhxvMGtS+t532dlYiQ1l+uO72La2CTk7bNzClngaxLEfvMkyTYYPoB+2sBJKH1rztqFs71Cp+MDbS/7U64dCMo7nQS8RyN6lJ9494QuIQNcKoizdPOK2Ca7qS8dQmoikjXiPxvOxmLztBdSTaSVEfYaJofYxnW7VmbwlxuJt15LRrp5sPLDukCLVMNsz66tWSbSqY1f3T17QzqSAI+oeK9wEe5TSvC+7wM70kadQstqLgFX+UHrX5c2XEpvB
x-ms-exchange-antispam-messagedata: 9rcw4rOAUY2cv8+hQodLzaqclHRjlNhVHiQw9XMOr6H6PK2oDvS8WHA7rwMgEIG4KniR+ufSsrgs22meg5plxlOH/2i4CwDgU3KpQrmEZifu1UZ/xDZuZE95hNrZn1VSfiDijzvzAVMor+k6K7TYvw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3bda70bd-8665-4997-693f-08d7cb1b1260
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Mar 2020 09:02:22.7539
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KdQdRMLV1ALxzBUp3fXSOoLGb/jIcuSb4lF8xNjPLfGv1odT+Be1EeKwyyDvDMVnH+O2r00D2jQzodjXUIS/gg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3583
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRnV6emV5LCBNYXJ0aW4gPG1hcnRpbi5mdXp6ZXlAZmxvd2JpcmQuZ3JvdXA+IFNlbnQ6
IFdlZG5lc2RheSwgTWFyY2ggMTgsIDIwMjAgNDozNiBQTQ0KPiBPbiBXZWQsIDE4IE1hciAyMDIw
IGF0IDA3OjI2LCBBbmR5IER1YW4gPGZ1Z2FuZy5kdWFuQG54cC5jb20+IHdyb3RlOg0KPiA+DQo+
ID4gRnJvbTogTWFydGluIEZ1enpleSA8bWFydGluLmZ1enpleUBmbG93YmlyZC5ncm91cD4gU2Vu
dDogV2VkbmVzZGF5LA0KPiA+IE1hcmNoIDE4LCAyMDIwIDEyOjUwIEFNDQo+ID4gPiArc3RhdGlj
IGludCBmZWNfZW5ldF9vZl9wYXJzZV9zdG9wX21vZGUoc3RydWN0IGZlY19lbmV0X3ByaXZhdGUg
KmZlcCwNCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHN0cnVj
dCBkZXZpY2Vfbm9kZSAqbnApIHsNCj4gPiA+ICsgICAgICAgc3RhdGljIGNvbnN0IGNoYXIgcHJv
cFtdID0gImZzbCxzdG9wLW1vZGUiOw0KPiA+ID4gKyAgICAgICBzdHJ1Y3Qgb2ZfcGhhbmRsZV9h
cmdzIGFyZ3M7DQo+ID4gPiArICAgICAgIGludCByZXQ7DQo+ID4gPiArDQo+ID4gPiArICAgICAg
IHJldCA9IG9mX3BhcnNlX3BoYW5kbGVfd2l0aF9maXhlZF9hcmdzKG5wLCBwcm9wLCAyLCAwLA0K
PiA+ID4gKyAmYXJncyk7DQo+ID4gVG8gc2F2ZSBtZW1vcnk6DQo+ID4NCj4gPiAgICAgICAgICAg
ICAgICAgIHJldCA9IG9mX3BhcnNlX3BoYW5kbGVfd2l0aF9maXhlZF9hcmdzKG5wLA0KPiA+ICJm
c2wsc3RvcC1tb2RlIiwgMiwgMCwgJmFyZ3MpOw0KPiA+DQo+IA0KPiBXaHkgd291bGQgdGhpcyBz
YXZlIG1lbW9yeT8NCj4gcHJvcCBpcyBkZWZpbmVkIHN0YXRpYyBjb25zdCBjaGFyW10gKGFuZCBu
b3QgY2hhciAqKSBzbyB0aGVyZSB3aWxsIG5vIGJlIGV4dHJhDQo+IHBvaW50ZXJzLg0KPiANCj4g
SSBoYXZlbid0IGNoZWNrZWQgdGhlIGdlbmVyYXRlZCBhc3NlbWJsZXIgYnV0IHRoaXMgc2hvdWxk
IGdlbmVyYXRlIHRoZSBzYW1lDQo+IGNvZGUgYXMgYSBzdHJpbmcgbGl0dGVyYWwgSSB0aGluay4N
Cj4gDQo+IEl0IGlzIGFsc28gcmV1c2VkIGxhdGVyIGluIHRoZSBmdW5jdGlvbiBpbiBhIGRlYnVn
ICh3aGljaCBpcyB0aGUgcmVhc29uIEkgZGlkIGl0DQo+IHRoaXMgd2F5IHRvIGVuc3VyZSB0aGUg
cHJvcGVydHkgbmFtZSBpcyB1bmlxdWUgYW5kIGNvbnNpc3RlbnQuDQoNCnN0YXRpYyB2YXJpYWJs
ZSBjb3N0IG1lbW9yeSBhbmQgbmV2ZXIgaXMgbm90IGZyZWVkIGlmIHRoZSBtb2R1bGUgaXMgYnVp
bHQgaW4uIA0KDQp0aGUgbGF0ZXIgZGVidWcgbWVzc2FnZSBjYW5ub3QgZGVwZW5kIG9uIHRoZSB2
YXJpYWJsZS4NCj4gDQo+IFJlZ2FyZHMsDQo+IA0KPiBNYXJ0aW4NCj4gDQo+IC0tDQo=
