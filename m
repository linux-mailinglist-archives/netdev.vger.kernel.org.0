Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D9361BE43
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 21:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726427AbfEMT61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 15:58:27 -0400
Received: from mail-eopbgr800092.outbound.protection.outlook.com ([40.107.80.92]:10256
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726007AbfEMT6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 15:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=impinj.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=69l9TEBeUvhkCemjlJQ02bKW7QrRB5wAmEztjOcog6E=;
 b=fuT3ckGDdHZe0EOvGm9lrv1Pg6DPEbBRAp5DHY6CeLRQPrKAtlIOE/3AL5qDMskLhLv/1M2zkrGRCOPb/OqfZbOLMLFIRp9hejLpgz5X0S4G0ahvdCLos3BCiJzEJ21IkR13y5nSWMr1oBinbwYDFtGJzD2zdXZZvfyLUqBih2U=
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com (10.167.236.38) by
 MWHPR0601MB3690.namprd06.prod.outlook.com (10.167.236.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.21; Mon, 13 May 2019 19:58:18 +0000
Received: from MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876]) by MWHPR0601MB3708.namprd06.prod.outlook.com
 ([fe80::b496:85ab:4cb0:5876%2]) with mapi id 15.20.1878.024; Mon, 13 May 2019
 19:58:18 +0000
From:   Trent Piepho <tpiepho@impinj.com>
To:     "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Topic: [PATCH 5/5] net: phy: dp83867: Use unsigned variables to store
 unsigned properties
Thread-Index: AQHVB3nKLczzbyv1Ekyx8+zOFp2aoKZlvT2AgAAe/wCAA6E4AA==
Date:   Mon, 13 May 2019 19:58:17 +0000
Message-ID: <1557777496.4229.13.camel@impinj.com>
References: <20190510214550.18657-1-tpiepho@impinj.com>
         <20190510214550.18657-5-tpiepho@impinj.com>
         <49c6afc4-6c5b-51c9-74ab-9a6e8c2460a5@gmail.com>
         <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
In-Reply-To: <3a42c0cc-4a4b-e168-c03e-1cc13bd2f5d4@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=tpiepho@impinj.com; 
x-originating-ip: [216.207.205.253]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f648efa3-c657-4852-4851-08d6d7dd582d
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:MWHPR0601MB3690;
x-ms-traffictypediagnostic: MWHPR0601MB3690:
x-microsoft-antispam-prvs: <MWHPR0601MB36908AFC6B04AC5647821DB5D30F0@MWHPR0601MB3690.namprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0036736630
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(346002)(366004)(39850400004)(396003)(199004)(189003)(229853002)(2201001)(86362001)(6436002)(6506007)(76176011)(6486002)(6116002)(3846002)(5660300002)(99286004)(54906003)(316002)(110136005)(68736007)(2906002)(446003)(478600001)(8936002)(81156014)(81166006)(8676002)(476003)(4326008)(186003)(71200400001)(486006)(2616005)(71190400001)(25786009)(305945005)(256004)(11346002)(7736002)(6246003)(14444005)(102836004)(26005)(36756003)(73956011)(66446008)(91956017)(66556008)(76116006)(53546011)(66476007)(64756008)(103116003)(66946007)(2501003)(14454004)(53936002)(6512007)(66066001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR0601MB3690;H:MWHPR0601MB3708.namprd06.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: impinj.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: e2kmf0zldGveD/Tx+Xl+LvkhbaJqTJWaH5EZvpOddgHdw7FlNiaeRAPyAtGGPLYGdgMhtJ8SUphzGQZ/2xR9Mgxoynx787QH1n+PhuWfKsXgLO7NGG4S5xaAc+NCYFeL9vThff+AKdGTPmAbODoCnAOPT64VDhgkde7B45m/WAYDb94ZLfY5t0KBnuyi92HYeVmMgRNudFRHdOwn6dS2Qff6JFw6UyLyuDA9Ju+vylVlAMlE3WoQ+vAkuLUqQQe6BdMv5i3M+m/VSI7Exjk0vscVLoiXBzf5puziAyFkfQEgNF8hrP3NvDFhqRNpeekAB5uEhhTUAiKlIqGKMM3+WN2iU+QgmsaqaHdgA5nyrbEEyncGaOiNI2aUsxYCkMQZAF6WoYxEXHxa5QMYu4y6OR/cQgV/ieYJftWLOWymZQc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9152E8B6F38C8948B2CA03A5C5C96E9A@namprd06.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: impinj.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f648efa3-c657-4852-4851-08d6d7dd582d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2019 19:58:18.2737
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 6de70f0f-7357-4529-a415-d8cbb7e93e5e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR0601MB3690
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDE5LTA1LTExIGF0IDE0OjMyICswMjAwLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6
DQo+IE9uIDExLjA1LjIwMTkgMTI6NDEsIEhlaW5lciBLYWxsd2VpdCB3cm90ZToNCj4gPiBPbiAx
MC4wNS4yMDE5IDIzOjQ2LCBUcmVudCBQaWVwaG8gd3JvdGU6DQo+ID4gPiBUaGUgdmFyaWFibGVz
IHVzZWQgdG8gc3RvcmUgdTMyIERUIHByb3BlcnRpZXMgd2VyZSBzaWduZWQNCj4gPiA+IGludHMu
ICBUaGlzDQo+ID4gPiBkb2Vzbid0IHdvcmsgcHJvcGVybHkgaWYgdGhlIHZhbHVlIG9mIHRoZSBw
cm9wZXJ0eSB3ZXJlIHRvDQo+ID4gPiBvdmVyZmxvdy4NCj4gPiA+IFVzZSB1bnNpZ25lZCB2YXJp
YWJsZXMgc28gdGhpcyBkb2Vzbid0IGhhcHBlbi4NCj4gPiA+IA0KPiA+IA0KPiA+IEluIHBhdGNo
IDMgeW91IGFkZGVkIGEgY2hlY2sgZm9yIERUIHByb3BlcnRpZXMgYmVpbmcgb3V0IG9mIHJhbmdl
Lg0KPiA+IEkgdGhpbmsgdGhpcyB3b3VsZCBiZSBnb29kIGFsc28gZm9yIHRoZSB0aHJlZSBwcm9w
ZXJ0aWVzIGhlcmUuDQo+ID4gVGhlIGRlbGF5IHZhbHVlcyBhcmUgb25seSA0IGJpdHMgd2lkZSwg
c28geW91IG1pZ2h0IGFsc28gY29uc2lkZXINCj4gPiB0byBzd2l0Y2ggdG8gdTggb3IgdTE2Lg0K
PiA+IA0KPiANCj4gSSBicmllZmx5IGxvb2tlZCBvdmVyIHRoZSByZXN0IG9mIHRoZSBkcml2ZXIu
IFdoYXQgaXMgcGxhaW4gd3JvbmcNCj4gaXMgdG8gYWxsb2NhdGUgbWVtb3J5IGZvciB0aGUgcHJp
dmF0ZSBkYXRhIHN0cnVjdHVyZSBpbiB0aGUNCj4gY29uZmlnX2luaXQgY2FsbGJhY2suIFRoaXMg
aGFzIHRvIGJlIGRvbmUgaW4gdGhlIHByb2JlIGNhbGxiYWNrLg0KPiBBbiBleGFtcGxlIGlzIG1h
cnZlbGxfcHJvYmUoKS4gQXMgeW91IHNlZW0gdG8gd29yayBvbiB0aGlzIGRyaXZlciwNCj4gY2Fu
IHlvdSBwcm92aWRlIGEgcGF0Y2ggZm9yIHRoaXM/DQoNCkl0IG9ubHkgYWxsb2NhdGVzIHRoZSBk
YXRhIG9uY2UsIHNvIGl0IGlzIG5vdCBhIG1lbW9yeSBsZWFrLiAgQnV0IHllcywNCnRvdGFsbHkg
d3JvbmcgcGxhY2UgdG8gZG8gaXQuICBJIGNhbiBmaXggdGhpcy4gIEl0IGFsc28gZG9lcyBub3Qg
c2V0DQp0aGUgc2lnbmFsIGxpbmUgaW1wZWRhbmNlIGZyb20gRFQgdmFsdWUgdW5sZXNzIHVubGVz
cyBhbHNvIGNvbmZpZ3VyaW5nDQpjbG9jayBza2V3LCBldmVuIHRob3VnaCB0aGV5IGFyZSBvcnRo
b2dvbmFsIGNvbmNlcHRzLiAgQW5kIGZhaWxzIHRvDQp2ZXJpZnkgYW55dGhpbmcgcmVhZCBmcm9t
IHRoZSBEVC4NCg0KUGVyaGFwcyB5b3UgY291bGQgdGVsbCBtZSBpZiB0aGUgYXBwcm9hY2ggSSd2
ZSB0YWtlbiBpbiBwYXRjaCAzLCANCiJBZGQgYWJpbGl0eSB0byBkaXNhYmxlIG91dHB1dCBjbG9j
ayIsIGFuZCBwYXRjaCA0LCAiRGlzYWJsZSB0eC9yeA0KZGVsYXkgd2hlbiBub3QgY29uZmlndXJl
ZCIsIGFyZSBjb25zaWRlcmVkIGFjY2VwdGFibGU/ICBJIGNhbiBjb25jZWl2ZQ0Kb2YgYXJndW1l
bnRzIGZvciBhbHRlcm5hdGUgYXBwcm9hY2hlcy4gIEkgd291bGQgbGlrZSB0byBhZGQgc3VwcG9y
dCBmb3INCiB0aGVzZSBpbnRvIHUtYm9vdCB0b28sIGJ1dCB0eXBpY2FsbHkgdS1ib290IGZvbGxv
d3MgdGhlIGtlcm5lbCBEVA0KYmluZGluZ3MsIHNvIEkgd2FudCB0byBmaW5hbGl6ZSB0aGUga2Vy
bmVsIERUIHNlbWFudGljcyBiZWZvcmUgc2VuZGluZw0KcGF0Y2hlcyB0byB1LWJvb3QuDQoNCj4g
PiBQbGVhc2Ugbm90ZSB0aGF0IG5ldC1uZXh0IGlzIGNsb3NlZCBjdXJyZW50bHkuIFBsZWFzZSBy
ZXN1Ym1pdCB0aGUNCj4gPiBwYXRjaGVzIG9uY2UgaXQncyBvcGVuIGFnYWluLCBhbmQgcGxlYXNl
IGFubm90YXRlIHRoZW0gcHJvcGVybHkNCj4gPiB3aXRoIG5ldC1uZXh0Lg0KDQpTb3JyeSwgZGlk
bid0IGtub3cgYWJvdXQgdGhpcyBwb2xpY3kuICBCZWVuIHllYXJzIHNpbmNlIEkndmUgc3VibWl0
dGVkDQpuZXQgcGF0Y2hlcy4gIElzIHRoZXJlIGEgZGVzY3JpcHRpb24gc29tZXdoZXJlIG9mIGhv
dyB0aGlzIGlzIGRvbmU/IA0KR29vZ2xpbmcgbmV0LW5leHQgd2Fzbid0IGhlbHBmdWwuICBJIGdh
dGhlciBuZXcgcGF0Y2hlcyBhcmUgb25seQ0KYWxsb3dlZCB3aGVuIHRoZSBrZXJuZWwgbWVyZ2Ug
d2luZG93IGlzIG9wZW4/ICBBbmQgdGhleSBjYW4ndCBiZSBxdWV1ZWQNCm9uIHBhdGNod29yayBv
ciBhIHRvcGljIGJyYW5jaCB1bnRpbCB0aGlzIGhhcHBlbnM/DQoNCg==
