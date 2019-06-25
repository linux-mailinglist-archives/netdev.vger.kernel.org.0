Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E9D652728
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730865AbfFYIyK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:54:10 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:56813 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730702AbfFYIyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:54:10 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,415,1557212400"; 
   d="scan'208";a="40305514"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jun 2019 01:54:09 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex01.mchp-main.com (10.10.87.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Jun 2019 01:54:07 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Jun 2019 01:54:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KpVRGw06KRgfqQVjrPzPfpk16gccSyuzdj2bJXGVQyI=;
 b=Y1aQ7pohXhAk2XvE1B4dSWqdAbOiRepwuJhGAMvZRHc8nFgLgdFn3OdOYHTFEQJ6dd3AzwRecD6HveSez06fCFwF5Hguy13+w8ObvGKNyI1AmYEThHGv0LiTJELQpMQdSXEE/CkPy5rw5O6Z5aCSlK9XWFcqQBg4I8x/gLFiGyk=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1456.namprd11.prod.outlook.com (10.172.53.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 08:54:04 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 08:54:04 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <palmer@sifive.com>, <harinik@xilinx.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] net: macb: Kconfig: Make MACB depend on COMMON_CLK
Thread-Topic: [PATCH v2 1/2] net: macb: Kconfig: Make MACB depend on
 COMMON_CLK
Thread-Index: AQHVKzLebS14DPAzREGVVVzaYIxBhqasEKAA
Date:   Tue, 25 Jun 2019 08:54:04 +0000
Message-ID: <b9a01045-f43c-0b42-1859-fc37e7c6683b@microchip.com>
References: <20190625084828.540-1-palmer@sifive.com>
 <20190625084828.540-2-palmer@sifive.com>
In-Reply-To: <20190625084828.540-2-palmer@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0217.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::13) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db9d860e-6083-4194-b294-08d6f94aacc0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1456;
x-ms-traffictypediagnostic: MWHPR11MB1456:
x-microsoft-antispam-prvs: <MWHPR11MB1456861DDD12C669C4D3080BE0E30@MWHPR11MB1456.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:883;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(3846002)(66446008)(66556008)(99286004)(386003)(76176011)(52116002)(53546011)(6506007)(73956011)(102836004)(66476007)(64756008)(66946007)(6116002)(31696002)(110136005)(54906003)(2501003)(316002)(486006)(11346002)(2616005)(476003)(26005)(5660300002)(31686004)(186003)(446003)(229853002)(14444005)(72206003)(6486002)(6436002)(478600001)(2906002)(14454004)(66066001)(71200400001)(256004)(71190400001)(8676002)(7736002)(305945005)(86362001)(81166006)(68736007)(25786009)(6246003)(4326008)(8936002)(81156014)(6512007)(53936002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1456;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: SOIAqaiANBNXGkBN7if7y785QU6yPLgxqkojcsqT8QFDxjnRPNfFp3H6LYI1D+533s17AYZ+0Bt8SSj1MtdKjyHBBhpo+rPP4b2Pg//BzFGbyI+8rF/0nr3gm2V3xXsCHaaiKo9lREWMkdIOA+r6lesnF7PzlQp+U9YBIAmBvaoWzZbt7EGWZ1zY4v2mKiox5FOkG4flCv1hFuZfps07WhjpIpQmLEcPdh92kYnOrCchckXc5H6DwGLyFAyMWyGN8VIVqCohrn+JY6mG1nioOdzToMra+BnuYvLseaTRwfuMYvXPE974SxZXJlDnUFqOAKgjdup5P2Rhb1Lw7E+LNqtlQUxWHJZL0hvtX2GKD8pw08YvePOI18054gsMvZZVPtppkHui77bkaR1L3Ak7RU4kfUruFESoQUrGbjSu+8M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AD97E83393D5E34982A5BAA2F0F4AE79@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: db9d860e-6083-4194-b294-08d6f94aacc0
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 08:54:04.2751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUvMDYvMjAxOSBhdCAxMDo0OCwgUGFsbWVyIERhYmJlbHQgd3JvdGU6DQo+IGNvbW1pdCBj
MjE4YWQ1NTkwMjAgKCJtYWNiOiBBZGQgc3VwcG9ydCBmb3IgU2lGaXZlIEZVNTQwLUMwMDAiKSBh
ZGRlZCBhDQo+IGRlcGVuZGVuY3kgb24gdGhlIGNvbW1vbiBjbG9jayBmcmFtZXdvcmsgdG8gdGhl
IG1hY2IgZHJpdmVyLCBidXQgZGlkbid0DQo+IGV4cHJlc3MgdGhhdCBkZXBlbmRlbmN5IGluIEtj
b25maWcuICBBcyBhIHJlc3VsdCBtYWNiIG5vdyBmYWlscyB0bw0KPiBjb21waWxlIG9uIHN5c3Rl
bXMgd2l0aG91dCBDT01NT05fQ0xLLCB3aGljaCBzcGVjaWZpY2FsbHkgY2F1c2VzIGEgYnVpbGQN
Cj4gZmFpbHVyZSBvbiBwb3dlcnBjIGFsbHllc2NvbmZpZy4NCj4gDQo+IFRoaXMgcGF0Y2ggYWRk
cyB0aGUgZGVwZW5kZW5jeSwgd2hpY2ggcmVzdWx0cyBpbiB0aGUgbWFjYiBkcml2ZXIgbm8NCj4g
bG9uZ2VyIGJlaW5nIHNlbGVjdGFibGUgb24gc3lzdGVtcyB3aXRob3V0IHRoZSBjb21tb24gY2xv
Y2sgZnJhbWV3b3JrLg0KPiBBbGwga25vd24gc3lzdGVtcyB0aGF0IGhhdmUgdGhpcyBkZXZpY2Ug
YWxyZWFkeSBzdXBwb3J0IHRoZSBjb21tb24gY2xvY2sNCj4gZnJhbWV3b3JrLCBzbyB0aGlzIHNo
b3VsZCBub3QgY2F1c2UgdHJvdWJsZSBmb3IgYW55IHVzZXMuICBTdXBwb3J0aW5nDQo+IGJvdGgg
dGhlIEZVNTQwLUMwMDAgYW5kIHN5c3RlbXMgd2l0aG91dCBDT01NT05fQ0xLIGlzIHF1aXRlIHVn
bHkuDQo+IA0KPiBJJ3ZlIGJ1aWxkIHRlc3RlZCB0aGlzIG9uIHBvd2VycGMgYWxseWVzY29uZmln
IGFuZCBSSVNDLVYgZGVmY29uZmlnDQo+ICh3aGljaCBzZWxlY3RzIE1BQ0IpLCBidXQgSSBoYXZl
IG5vdCBldmVuIGJvb3RlZCB0aGUgcmVzdWx0aW5nIGtlcm5lbHMuDQo+IA0KPiBGaXhlczogYzIx
OGFkNTU5MDIwICgibWFjYjogQWRkIHN1cHBvcnQgZm9yIFNpRml2ZSBGVTU0MC1DMDAwIikNCj4g
U2lnbmVkLW9mZi1ieTogUGFsbWVyIERhYmJlbHQgPHBhbG1lckBzaWZpdmUuY29tPg0KDQpBY2tl
ZC1ieTogTmljb2xhcyBGZXJyZSA8bmljb2xhcy5mZXJyZUBtaWNyb2NoaXAuY29tPg0KDQpUaGFu
a3MhDQoNCj4gLS0tDQo+ICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9LY29uZmlnIHwg
NCArKy0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMo
LSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL0tjb25m
aWcgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL0tjb25maWcNCj4gaW5kZXggMTc2NjY5
N2M5YzVhLi42NGQ4ZDZlZTc3MzkgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2NhZGVuY2UvS2NvbmZpZw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL0tj
b25maWcNCj4gQEAgLTIxLDcgKzIxLDcgQEAgaWYgTkVUX1ZFTkRPUl9DQURFTkNFDQo+ICAgDQo+
ICAgY29uZmlnIE1BQ0INCj4gICAJdHJpc3RhdGUgIkNhZGVuY2UgTUFDQi9HRU0gc3VwcG9ydCIN
Cj4gLQlkZXBlbmRzIG9uIEhBU19ETUENCj4gKwlkZXBlbmRzIG9uIEhBU19ETUEgJiYgQ09NTU9O
X0NMSw0KPiAgIAlzZWxlY3QgUEhZTElCDQo+ICAgCS0tLWhlbHAtLS0NCj4gICAJICBUaGUgQ2Fk
ZW5jZSBNQUNCIGV0aGVybmV0IGludGVyZmFjZSBpcyBmb3VuZCBvbiBtYW55IEF0bWVsIEFUMzIg
YW5kDQo+IEBAIC00Miw3ICs0Miw3IEBAIGNvbmZpZyBNQUNCX1VTRV9IV1NUQU1QDQo+ICAgDQo+
ICAgY29uZmlnIE1BQ0JfUENJDQo+ICAgCXRyaXN0YXRlICJDYWRlbmNlIFBDSSBNQUNCL0dFTSBz
dXBwb3J0Ig0KPiAtCWRlcGVuZHMgb24gTUFDQiAmJiBQQ0kgJiYgQ09NTU9OX0NMSw0KPiArCWRl
cGVuZHMgb24gTUFDQiAmJiBQQ0kNCj4gICAJLS0taGVscC0tLQ0KPiAgIAkgIFRoaXMgaXMgUENJ
IHdyYXBwZXIgZm9yIE1BQ0IgZHJpdmVyLg0KPiAgIA0KPiANCg0KDQotLSANCk5pY29sYXMgRmVy
cmUNCg==
