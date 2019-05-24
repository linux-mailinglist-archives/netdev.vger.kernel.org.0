Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD5C629658
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 12:52:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390639AbfEXKwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 06:52:16 -0400
Received: from mail-eopbgr140048.outbound.protection.outlook.com ([40.107.14.48]:14567
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390537AbfEXKwQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 06:52:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1IIIjTs4V5Ep5tM6f0QAU2Wmtwg6ogqZOwiWLwS2QLQ=;
 b=CqpLHk931HsGodA8aNLXDWHs6tdUT/7FWgc8zxMhVRSpDfAeJhImfrRVStkfy+tX8GCp7agugVyQ/5Sb0EoL3DGLRp8Qz7kcTDKNAJHuU8zhnJR3rYc05KxdjrEvpLB29waGh9pRnHS9cKW++HyoecNwTqpO5ehku7pdbA8UI30=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3389.eurprd04.prod.outlook.com (52.134.1.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Fri, 24 May 2019 10:52:10 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::f494:9fa1:ebae:6053%8]) with mapi id 15.20.1922.019; Fri, 24 May 2019
 10:52:10 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "maxime.chevallier@bootlin.com" <maxime.chevallier@bootlin.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [RFC PATCH net-next 3/9] net: phy: Add phy_standalone sysfs entry
Thread-Topic: [RFC PATCH net-next 3/9] net: phy: Add phy_standalone sysfs
 entry
Thread-Index: AQHVEQW7wDCFQR6sQUWynBU/WT9lsaZ39dMAgAIkn2A=
Date:   Fri, 24 May 2019 10:52:10 +0000
Message-ID: <VI1PR0402MB2800D7A42DB0D6E3E0A63F5AE0020@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <20190523011958.14944-1-ioana.ciornei@nxp.com>
 <20190523011958.14944-4-ioana.ciornei@nxp.com>
 <8e954092-852b-6e69-a10f-8da480ba8749@gmail.com>
In-Reply-To: <8e954092-852b-6e69-a10f-8da480ba8749@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c74fa927-9906-4e49-8ff8-08d6e035df76
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:VI1PR0402MB3389;
x-ms-traffictypediagnostic: VI1PR0402MB3389:
x-microsoft-antispam-prvs: <VI1PR0402MB3389AB417B9FEB3ED35AD069E0020@VI1PR0402MB3389.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0047BC5ADE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(136003)(376002)(39860400002)(346002)(189003)(199004)(476003)(446003)(11346002)(478600001)(8676002)(8936002)(81156014)(81166006)(186003)(5024004)(256004)(7736002)(305945005)(26005)(7696005)(3846002)(6116002)(74316002)(76176011)(102836004)(66066001)(52536014)(6506007)(53546011)(54906003)(110136005)(486006)(5660300002)(44832011)(33656002)(68736007)(2906002)(99286004)(229853002)(9686003)(55016002)(6436002)(316002)(2501003)(2201001)(4326008)(25786009)(86362001)(6246003)(71190400001)(71200400001)(53936002)(76116006)(73956011)(66946007)(14454004)(66556008)(64756008)(66446008)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3389;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yx0MQZCdYMrj6hWrC5Go4ihkK71op3caSV2r6NSC5Tl9RY5mNyd/KKIAy/1bLaMaZoLQBjTN2lFgmgJ3ypwYvRL7i8AKOrLBgMQKHLfolTyHR534cJclEerQZnoHiyAaI9aGEoqF23MOjOTH113YrSh6HKf3hccAGnyk94EM4Q8L2+GjhUAmRS/iZA4AJkGWxz3HNhtdZ4iFcY1eqic2Z2q7RfAVlKGOZoEvwcmi4ywhAmlmds8DCzXV0Q5ACbK50k5srfVsMuXzRWR7UKgMzEla3aeDVc18sYrOQMFh4EeE6zHaADO1lxMkSnzdV15P03fxJLe+y4tjoOVOAKEecPbzw+mNbR1Iqa9f4j0jAyKchgaTlAkFa0pTxmdVtVNh01i6wlf1nbLZy2jwSQOR3zuimv/9SlCGW2SEUNdk6y4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c74fa927-9906-4e49-8ff8-08d6e035df76
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2019 10:52:10.6081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ioana.ciornei@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3389
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IFN1YmplY3Q6IFJlOiBbUkZDIFBBVENIIG5ldC1uZXh0IDMvOV0gbmV0OiBwaHk6IEFkZCBw
aHlfc3RhbmRhbG9uZSBzeXNmcyBlbnRyeQ0KPiANCj4gDQo+IA0KPiBPbiA1LzIyLzIwMTkgNjoy
MCBQTSwgSW9hbmEgQ2lvcm5laSB3cm90ZToNCj4gPiBFeHBvcnQgYSBwaHlfc3RhbmRhbG9uZSBk
ZXZpY2UgYXR0cmlidXRlIHRoYXQgaXMgbWVhbnQgdG8gZ2l2ZSB0aGUNCj4gPiBpbmRpY2F0aW9u
IHRoYXQgdGhpcyBQSFkgbGFja3MgYW4gYXR0YWNoZWRfZGV2IGFuZCBpdHMgY29ycmVzcG9uZGlu
Zw0KPiA+IHN5c2ZzIGxpbmsuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBJb2FuYSBDaW9ybmVp
IDxpb2FuYS5jaW9ybmVpQG54cC5jb20+DQo+IA0KPiBJIHdvdWxkIHJhdGhlciBoYXZlIHRoYXQg
YXR0cmlidXRlIGJlIGNvbmRpdGlvbmFsbHkgdmlzaWJsZS9jcmVhdGVkIHVwb24gYSBQSFkNCj4g
ZGV2aWNlIGJlaW5nIGFzc29jaWF0ZWQgd2l0aCBhIE5VTEwgbmV0X2RldmljZSBhbmQgbm90IGhh
dmUgaXQgZm9yICJub24tDQo+IHN0YW5kYWxvbmUiIFBIWSBkZXZpY2VzLCB0aGF0IHdvdWxkIGJl
IGNvbmZ1c2luZy4NCj4gDQoNCk9rLCBJIHVuZGVyc3RhbmQgdGhlIHJlYXNvbmluZyBhbmQgd2ls
bCBjaGFuZ2UgaXQgaW4gdjIuDQoNCi0tDQpJb2FuYQ0KDQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMv
bmV0L3BoeS9waHlfZGV2aWNlLmMgfCAxMiArKysrKysrKysrKysNCj4gPiAgMSBmaWxlIGNoYW5n
ZWQsIDEyIGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9w
aHkvcGh5X2RldmljZS5jDQo+ID4gYi9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5jIGluZGV4
IDI1Y2M3YzMzZjhkZC4uMzBlMGU3M2Q1Zjg2IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0
L3BoeS9waHlfZGV2aWNlLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9waHkvcGh5X2RldmljZS5j
DQo+ID4gQEAgLTUzNywxMCArNTM3LDIyIEBAIHBoeV9oYXNfZml4dXBzX3Nob3coc3RydWN0IGRl
dmljZSAqZGV2LCBzdHJ1Y3QNCj4gPiBkZXZpY2VfYXR0cmlidXRlICphdHRyLCAgfSAgc3RhdGlj
IERFVklDRV9BVFRSX1JPKHBoeV9oYXNfZml4dXBzKTsNCj4gPg0KPiA+ICtzdGF0aWMgc3NpemVf
dCBwaHlfc3RhbmRhbG9uZV9zaG93KHN0cnVjdCBkZXZpY2UgKmRldiwNCj4gPiArCQkJCSAgIHN0
cnVjdCBkZXZpY2VfYXR0cmlidXRlICphdHRyLA0KPiA+ICsJCQkJICAgY2hhciAqYnVmKQ0KPiA+
ICt7DQo+ID4gKwlzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2ID0gdG9fcGh5X2RldmljZShkZXYp
Ow0KPiA+ICsNCj4gPiArCXJldHVybiBzcHJpbnRmKGJ1ZiwgIiVkXG4iLCAhcGh5ZGV2LT5hdHRh
Y2hlZF9kZXYpOyB9DQo+ID4gKw0KPiA+ICtzdGF0aWMgREVWSUNFX0FUVFJfUk8ocGh5X3N0YW5k
YWxvbmUpOw0KPiA+ICsNCj4gPiAgc3RhdGljIHN0cnVjdCBhdHRyaWJ1dGUgKnBoeV9kZXZfYXR0
cnNbXSA9IHsNCj4gPiAgCSZkZXZfYXR0cl9waHlfaWQuYXR0ciwNCj4gPiAgCSZkZXZfYXR0cl9w
aHlfaW50ZXJmYWNlLmF0dHIsDQo+ID4gIAkmZGV2X2F0dHJfcGh5X2hhc19maXh1cHMuYXR0ciwN
Cj4gPiArCSZkZXZfYXR0cl9waHlfc3RhbmRhbG9uZS5hdHRyLA0KPiA+ICAJTlVMTCwNCj4gPiAg
fTsNCj4gPiAgQVRUUklCVVRFX0dST1VQUyhwaHlfZGV2KTsNCj4gPg0KPiANCj4gLS0NCj4gRmxv
cmlhbg0K
