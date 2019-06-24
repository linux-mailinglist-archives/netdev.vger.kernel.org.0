Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23EAF5099B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 13:17:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729707AbfFXLR3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 07:17:29 -0400
Received: from mail-eopbgr680053.outbound.protection.outlook.com ([40.107.68.53]:31463
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727953AbfFXLR2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 07:17:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ckJYqIGONeH6S9GCox0cwJAUE9EZ/+xckijl+xw5DeI=;
 b=Rcvebb8nbC0WzRaG1KQlKqRpT22HzNRxk7zRFK0/XwYF2KCED1l3dFS+rovUFq3JI/kTqQhddC/d0FQVVxpIVeE+kkS8mgM1VozNmbQXm/FdvMYt1AMRUA71kue6m45MPBlt+R7Sc5+Xa/CaCuHQl9NkzSUBZqRa13CG0qC2rNk=
Received: from MWHPR11MB1968.namprd11.prod.outlook.com (10.175.55.144) by
 MWHPR11MB1823.namprd11.prod.outlook.com (10.175.53.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 11:17:23 +0000
Received: from MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b]) by MWHPR11MB1968.namprd11.prod.outlook.com
 ([fe80::eda4:c685:f6f8:8a1b%7]) with mapi id 15.20.2008.017; Mon, 24 Jun 2019
 11:17:23 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 2/7] net: aquantia: add documentation for the
 atlantic driver
Thread-Topic: [PATCH net-next 2/7] net: aquantia: add documentation for the
 atlantic driver
Thread-Index: AQHVKn5luXncAJOQpkabx9dKxeuWew==
Date:   Mon, 24 Jun 2019 11:17:23 +0000
Message-ID: <7017d220-f47a-b2cb-f54f-29b42eed8930@aquantia.com>
References: <cover.1561210852.git.igor.russkikh@aquantia.com>
 <1e1b3a34f4ff27aad030e690058404b2140da914.1561210852.git.igor.russkikh@aquantia.com>
 <20190622151657.GC8497@lunn.ch>
In-Reply-To: <20190622151657.GC8497@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1PR0402CA0021.eurprd04.prod.outlook.com
 (2603:10a6:3:d0::31) To MWHPR11MB1968.namprd11.prod.outlook.com
 (2603:10b6:300:113::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 59946c0b-e000-47fe-718f-08d6f895879a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1823;
x-ms-traffictypediagnostic: MWHPR11MB1823:
x-microsoft-antispam-prvs: <MWHPR11MB182380696844A7584219B09498E00@MWHPR11MB1823.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39840400004)(376002)(136003)(366004)(199004)(189003)(8936002)(53936002)(6436002)(2906002)(14454004)(478600001)(44832011)(486006)(6116002)(3846002)(7736002)(2616005)(446003)(11346002)(99286004)(305945005)(476003)(81156014)(81166006)(8676002)(6486002)(36756003)(31696002)(72206003)(6512007)(66066001)(4326008)(6916009)(71200400001)(71190400001)(186003)(26005)(31686004)(256004)(68736007)(25786009)(316002)(76176011)(52116002)(86362001)(229853002)(6246003)(54906003)(5660300002)(102836004)(66946007)(73956011)(14444005)(66446008)(64756008)(66556008)(66476007)(6506007)(386003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1823;H:MWHPR11MB1968.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: AIhKEhTsUy5l3N7ij5VZFnRx3oTl5343BbzoM+Tg/M4K5RgTzac3zVgwQK1NIlV+T9e2J1YU+9ia/pZ+GNe0vLKJWgmHRHtungLY/qJrhUduSxLYi0PKdAvaWCWqORfYKIFjYOK2LAbMOs8/wTOgITfZBSGq1R7yIUUkuwotK3j+gGLnJqiXQr/+o6ofszYqrOHjUPJPYYPa6WU988YIjTxP5fME5Od/aLLYKksPTsbvpCIGLNYmzOEk/SSNF5LSlQJ5C6py2wiaABnWJHT2KTXeejErC9VvcmeydVDbuEV1clMwJL0RXo4o82n/HYuSzQ72bJP4R4+2cnDk/8s2H4Rbq5eQvgySxRfZrq3mM2SGbiME0VQ6qHM5UME9D40PQCPlCmSyDVp05yQRvO3Udzh2X/6LjIJxnY49ktchf50=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EBED4927FD90DA4EBE4E74109E2BCFB8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59946c0b-e000-47fe-718f-08d6f895879a
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 11:17:23.0807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: irusski@aquantia.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1823
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+PiArICBpbmNyZWFzZSB0aGUgTVRVIHNpemUuICBGb3IgZXhhbXBsZToNCj4+ICsNCj4+ICsg
ICAgICAgIGlmY29uZmlnIDxldGhYPiBtdHUgMTYwMDAgdXANCj4gDQo+IGlmY29uZmlnIGhhcyBi
ZWVuIGRlcHJlY2F0ZWQgZm9yIG1hbnkgeWVhcnMuIFBsZWFzZSBkb2N1bWVudCB0aGUNCj4gaXBy
b3V0ZTIgY29tbWFuZC4NCg0KVGhhbmtzIGZvciByZXZpZXcsIEFuZHJldywgeWVwLCB3aWxsIHVw
ZGF0ZSB0aGF0Lg0KDQo+PiArIHN1cHBvcnRzLXByaXYtZmxhZ3M6IG5vDQo+IA0KPiBTaG91bGRu
J3QgdGhlcmUgYmUgNS4yLXJjNSBpbiBoZXJlIHNvbWV3aGVyZSwgZ2l2ZW4gdGhlIGZpcnN0IHBh
dGNoIGluDQo+IHRoaXMgc2VyaWVzPw0KDQpHb29kIGNhdGNoICkNCg0KPj4gKyBEaXNhYmxlIEdS
TyB3aGVuIHJvdXRpbmcvYnJpZGdpbmcNCj4+ICsgLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tDQo+PiArIER1ZSB0byBhIGtub3duIGtlcm5lbCBpc3N1ZSwgR1JPIG11c3QgYmUgdHVy
bmVkIG9mZiB3aGVuIHJvdXRpbmcvYnJpZGdpbmcuDQo+PiArIEl0IGNhbiBiZSBkb25lIHdpdGgg
Y29tbWFuZDoNCj4gDQo+IElzIHRoaXMgYSBrZXJuZWwgaXNzdWUsIG9yIGEgZHJpdmVyIGlzc3Vl
PyANCg0KSG0sIGhvbmVzdGx5IEkndmUganVzdCBjb3B5IHBhc3RlZCB0aGF0IHNlY3Rpb24gZnJv
bSBvdXIgb2xkIGRyaXZlciBzcGVjLg0KQ2hlY2tlZCB0aGlzLCBmb3Igbm93IEkgc2VlIHRoYXQg
bmV0d29ya2luZyBjb3JlIGJ5IGl0c2VsZiB0YWtlcyBhY3Rpb25zIHRvDQpkaXNhYmxlIExSTy9H
Uk8gb24gZGV2aWNlIHdoZW4gaXRzIG5vdCBhcHByb3ByaWF0ZSwgZm9yIGV4YW1wbGUgd2hlbiBp
cDQNCmZvcndhcmRpbmcgaXMgZW5hYmxlZC4NCg0KTWF5IGJlIHRoYXQgd2FzIGEgY2FzZSB3aXRo
IG9sZGVyIGtlcm5lbHMuIFdpbGwgcmVtb3ZlIHRoZXNlIExSTy9HUk8gbm90aWNlcy4NCg0KPj4g
KyBUbyBkaXNhYmxlIGNvYWxlc2Npbmc6DQo+PiArDQo+PiArIGV0aHRvb2wgLUMgPGV0aFg+IHR4
LXVzZWNzIDAgcngtdXNlY3MgMCB0eC1tYXgtZnJhbWVzIDEgdHgtbWF4LWZyYW1lcyAxDQo+IA0K
PiBQbGVhc2UgcHV0IHRoZXNlIGJlZm9yZSB0aGUgbW9kdWxlIHBhcmFtZXRlcnMuIFdlIHNob3Vs
ZCBkaXNjb3VyYWdlDQo+IHRoZSB1c2Ugb2YgbW9kdWxlIHBhcmFtZXRlcnMuIFVzaW5nIGV0aHRv
b2wgaXMgdGhlIGNvcnJlY3Qgd2F5IHRvIGRvDQo+IHRoaXMuDQoNCk9rLA0KDQo+IA0KPiBncmVw
IFNQRFggZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvKi5jDQo+IGRyaXZl
cnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX2RydmluZm8uYzovLyBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vci1sYXRlcg0KPiBkcml2ZXJzL25ldC9ldGhlcm5l
dC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9ldGh0b29sLmM6Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZp
ZXI6IEdQTC0yLjAtb25seQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRp
Yy9hcV9maWx0ZXJzLmM6Ly8gU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IEdQTC0yLjAtb3ItbGF0
ZXINCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfaHdfdXRpbHMu
YzovLyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+IGRyaXZlcnMvbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX21haW4uYzovLyBTUERYLUxpY2Vuc2UtSWRl
bnRpZmllcjogR1BMLTIuMC1vbmx5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0
bGFudGljL2FxX25pYy5jOi8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkN
Cj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvYXF1YW50aWEvYXRsYW50aWMvYXFfcGNpX2Z1bmMuYzov
LyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+IGRyaXZlcnMvbmV0L2V0
aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX3JpbmcuYzovLyBTUERYLUxpY2Vuc2UtSWRlbnRp
ZmllcjogR1BMLTIuMC1vbmx5DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2FxdWFudGlhL2F0bGFu
dGljL2FxX3ZlYy5jOi8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4g
DQo+IFlvdSBoYXZlIGEgbWl4IG9mIDIgYW5kIDIrLg0KDQpUaGFua3MsIHdpbGwgY2xlYW4gdGhp
cyB1cC4NCg0KUmVnYXJkcywNCiAgSWdvcg0K
