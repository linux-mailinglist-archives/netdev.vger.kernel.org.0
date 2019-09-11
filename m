Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACF50AFB91
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 13:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727627AbfIKLlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 07:41:05 -0400
Received: from mail-eopbgr690058.outbound.protection.outlook.com ([40.107.69.58]:16102
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726696AbfIKLlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Sep 2019 07:41:05 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WAy30sr3J31BZFi8fFqzAxCuT6R+2YAwKVYyanjE+Qyo37gi0M/atFAcHC9yIEJByAOSdVyOLR8ZU0vQ/dHjHPblFEcMshsL5utUphe0dSLH7tVrdKzda6ceinAS1zz7IcKC1gmHRl+bMuObkq8cGlPHDk6ghhnaCN7Dn0wB2mGyN7Wy+z4mRi+AAlDmmixFvIy3dCEzo59+KOoSSW1CKia8C/nCKM9haKhFSXw6EAJ2kMmf9lyyWGYIcD7tE/KZ7UdaarixkX/IfcagfRCU8gNikmSGJJTeq5W2RHArNk5y7fVUJ0LwvAWqRrchZw6RYNn7zocO0538FeuSG5WtKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHDKZP0JJJqE4dzHkqS5UbGEjWWEsNZIXSSB0pSSFAM=;
 b=TCfEruxvz6yLcsczYv0t3bO5NXEoeXpEUpw86DC0XLMduY5HepxNI1swDNNou2i/le44IStEpcBJaxshXA6ED7GbReIMLaZiDJkDmKts3VufRHCDWPqsPDfC4yR0RRm7AbX0I4nhB4tofSSQW4NtM9PE8WWMH5jI8+z7dPdOgllvdo9QSC3dcCobR+iZpIGTv9DlXBcWZZ1CBb6gcmplQZEmaApCWCfFzA6ywKQ5VRIcIxbRtylGUICrsj/d8GnaB6PS9lEdMrooO4t9nDy0E2cC7T/3n0t1kgFY8cqfhFq85r6z2cFXIHJuS1WnsElS0Ffcn1CrY+Yp2qqQ0R5Iaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CHDKZP0JJJqE4dzHkqS5UbGEjWWEsNZIXSSB0pSSFAM=;
 b=QVFm3Es/PxjnB0/gfzVNwRv37CUHYN2LB+FuJ/Pczo2QSO3/BmwHZ/oMOvP95VjOYS5ar8A67W0CabWETRQ20TjPKRstaAIgRWV/6T6QbFwhy3SUSYk8jv838O9QuoqT7Q8uzwgbmvXW2LPgML6RkyYXhgmPeXlkOMCaJ5ukAII=
Received: from BN6PR11MB4081.namprd11.prod.outlook.com (10.255.128.166) by
 BN6PR11MB4002.namprd11.prod.outlook.com (10.255.128.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Wed, 11 Sep 2019 11:41:02 +0000
Received: from BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5]) by BN6PR11MB4081.namprd11.prod.outlook.com
 ([fe80::95ec:a465:3f5f:e3e5%3]) with mapi id 15.20.2241.022; Wed, 11 Sep 2019
 11:41:02 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Sergey Samoilenko <Sergey.Samoilenko@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>
Subject: Re: [PATCH net-next 01/11] net: aquantia: PTP skeleton declarations
 and callbacks
Thread-Topic: [PATCH net-next 01/11] net: aquantia: PTP skeleton declarations
 and callbacks
Thread-Index: AQHVZxPi/lD9qRYqQ0+lyxhiEtXzvKclSKmAgAEUuQA=
Date:   Wed, 11 Sep 2019 11:41:01 +0000
Message-ID: <bb528d8c-575b-2d0c-6105-f0bd1f4d5d2c@aquantia.com>
References: <cover.1568034880.git.igor.russkikh@aquantia.com>
 <cf60b1d3d797d0666a4828fcf5e521e0bd73f8d4.1568034880.git.igor.russkikh@aquantia.com>
 <20190910191029.GE9761@lunn.ch>
In-Reply-To: <20190910191029.GE9761@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P192CA0004.EURP192.PROD.OUTLOOK.COM (2603:10a6:3:fe::14)
 To BN6PR11MB4081.namprd11.prod.outlook.com (2603:10b6:405:78::38)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a90bed26-2b6d-41e1-d574-08d736acebf2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB4002;
x-ms-traffictypediagnostic: BN6PR11MB4002:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB4002D516EEB992D6E242DC5B98B10@BN6PR11MB4002.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-forefront-prvs: 0157DEB61B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(366004)(396003)(136003)(346002)(376002)(39850400004)(199004)(189003)(53936002)(66946007)(6116002)(3846002)(31696002)(6916009)(186003)(26005)(71190400001)(4326008)(66446008)(64756008)(66556008)(86362001)(5660300002)(66476007)(478600001)(2906002)(71200400001)(52116002)(229853002)(6506007)(6486002)(102836004)(6512007)(76176011)(66066001)(6436002)(256004)(14454004)(316002)(99286004)(305945005)(386003)(54906003)(25786009)(486006)(7736002)(44832011)(446003)(81156014)(81166006)(8676002)(476003)(2616005)(11346002)(8936002)(31686004)(6246003)(107886003)(36756003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN6PR11MB4002;H:BN6PR11MB4081.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Wt7KuCHRVJQYc7HMuS3OlEIUrZ/exAraug9tDWC1ZMOtfkVmXWb7ze+KvOoRwiWyaYX7FpEevFTJJPSs5Z2WqBEXw0HyiydTaHQkTdaTK54ldBa8BbZyKOq4q0s8Wb3c17FdlZ5shlfB/mj2YawscGZbm4bA5mNq2VFmDHnXowXkW06F+PsxDrErHww+jKH+0GKDdHKhEOYSJwCrA6PB1iCCcWXRXO87sGy95BeqtTZmDVIYCHsro/2ul3wJtQhljdl+x4yQ9+mhgIW50EgzAckrOE5RbZQEZN4BHr0ndMleqX8DBX3B7XwX0/yLDxgA5xvN1PKpFicWz/O/H3LH/0olZIUpnQUib4nB9Y18T+q8eqyGjju67T1vXapL98x/uSySN7YId6A2espmlZtQLc23VA4F86MbOriJwciawy0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4F7740335925DB48B77C9406738907DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a90bed26-2b6d-41e1-d574-08d736acebf2
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Sep 2019 11:41:02.0597
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UEYxTzTbJrAfpjyj6StX6fCcGTlnpncWOpAY4ZXoI2lUW7uxk4MmR/EBdiHfOqLbBiIKD0qG7WIfbP1EjkZIeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4002
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBBbmRyZXcsDQoNCj4+ICsJc3RydWN0IHB0cF9jbG9jayAqY2xvY2s7DQo+PiArCXN0cnVj
dCBhcV9wdHBfcyAqc2VsZjsNCj4gDQo+IEkgZmluZCB0aGUgdXNlIG9mIHNlbGYgaW4gdGhpcyBj
b2RlIHF1aXRlIGNvbmZ1c2luZy4gSXQgZG9lcyBub3QNCj4gYXBwZWFyIHRvIGhhdmUgYSBjbGVh
ciBtZWFuaW5nLiBJdCBjYW4gYmUgYSBhcV9yaW5nX3MsIGFxX25pY19jLA0KPiBhcV9od19zLCBh
cV92ZWNfcy4NCj4gDQo+IExvb2tpbmcgYXQgdGhpcyBjb2RlIGkgYWx3YXlzIGhhdmUgdG8gZmln
dXJlIG91dCB3aGF0IHNlbGYgaXMuIENvdWxkDQo+IHlvdSBub3QganVzdCB1c2Ugc3RydWN0IGFx
X3B0cF9zIGFxX3B0cCBjb25zaXN0ZW50bHkgaW4gdGhlIGNvZGU/DQoNCkFncmVlZCwNCg0KPj4g
Kw0KPj4gKwlzZWxmID0ga3phbGxvYyhzaXplb2YoKnNlbGYpLCBHRlBfS0VSTkVMKTsNCj4gDQo+
IFVzaW5nIGRldm1fa3phbGxvYygpIHdpbGwgbWFrZSB5b3VyIGNsZWFuIHVwIGVhc2llci4NCg0K
Pj4gKw0KPj4gKwlrZnJlZShzZWxmKTsNCj4gDQo+IGtmcmVlKCkgaXMgaGFwcHkgdG8gdGFrZSBh
IE5VTEwgcG9pbnRlci4gQnV0IHRoaXMgY291bGQgYWxsIGdvIGF3YXkNCj4gd2l0aCBkZXZtX2t6
YWxsb2MoKS4NCg0KWW91IGFyZSBwcm9iYWJseSByaWdodCwgdGhhdCdsbCBiZSBlYXNpZXIsDQoN
Cg0KPj4gK3N0YXRpYyBpbnQgaHdfYXRsX2IwX2Fkal9zeXNfY2xvY2soc3RydWN0IGFxX2h3X3Mg
KnNlbGYsIHM2NCBkZWx0YSkNCj4+ICt7DQo+PiArCXB0cF9jbGtfb2Zmc2V0ICs9IGRlbHRhOw0K
Pj4gKw0KPj4gKwlyZXR1cm4gMDsNCj4+ICt9DQo+IA0KPiBEb2VzIHRoaXMgd29yayB3aGVuIGkg
aGF2ZSBhIGJveCB3aXRoIDQyIE5JQ3MgaW4gaXQ/IERvZXMgbm90IGVhY2ggTklDDQo+IG5lZWQg
aXRzIG93biBjbG9jayBvZmZzZXQ/IEp1c3Qgc2VlaW5nIGNvZGUgbGlrZSB0aGlzIGNhdXNlcyBh
bGFybQ0KPiBiZWxscy4gU28gaWYgaXQgaXMgY29ycmVjdCwgaSB3b3VsZCBleHBlY3Qgc29tZSBz
b3J0IG9mIGNvbW1lbnQgdG8NCj4gcHJldmVudCB0aG9zZSBhbGFybSBiZWxscy4NCg0KTm8gY29t
bWVudCBpcyBuZWVkZWQsIHRoYXQgaXMgb2J2aW91c2x5IGEgcGVyLWRldmljZSB2YXJpYWJsZSwN
Cg0KVGhhbmtzIGZvciBjYXRjaGluZyB0aGlzIQ0KDQpXaWxsIGZpeCB0aGF0LCBhcyB3ZWxsIGFz
IGtidWlsZCByb2JvdCBkaXNjb3ZlcmVkIGlzc3Vlcy4NCg0KUmVnYXJkcywNCiAgSWdvcg0K
