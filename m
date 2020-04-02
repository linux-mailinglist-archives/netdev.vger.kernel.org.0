Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7950D19CDA3
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 01:52:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390296AbgDBXwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 19:52:30 -0400
Received: from mail-db8eur05on2085.outbound.protection.outlook.com ([40.107.20.85]:47808
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390235AbgDBXwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Apr 2020 19:52:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gr1pYYH3wkTLMEbLzryLz6fhZ/eD7MsegyO/csmJMTfem7nfXXmlfkLsuO/3bQr8JiJXhcfFQaMD69MjK75VXmXECLayHEP9Zt/j2NljqA0f+B5HTR/FgMmb/k9YLP2lvmJ6SxYvRcQSuYVVNDnHiJFir0AUdOoEc8Gkvlz8215WgTk+d9xrnm0d+DmlPfgxOdI8W8svcNRagh41s2YqtTYils7qymE44OLdvURghL6sTOEa1X/qvV74PZz1iHOhM1/u1QrJVBUbjwahnn14B86nVEAZH5/OuBhjx/sp8Hx2UjIajIcjFtRLQEFhmcD89QLVz/WiuXiCgdR0t8g9qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PkiVbJHN2Wj3kDR9IouEU0b2EVdrOEULaOdnXhaih4=;
 b=fJFu3AbZ5H2NVOGvXDSX6OzYfJfkqvt1im3zwjRiYzIa2MDM40qH3ENeLtezceLbeYP4rS1FoynCWIMXaiGkMORbu7uNpi/SLgiEDV1ZTts3xv/YjYjYqUofsW317ArVCMmy0g1/dQmaB11hbQuej7AKS+D7+5QxI/bBHy+8xDySx7eAgLCbzIRqdVZAMQ09Z639RzXRrufxFK335Mgb0ZHjpkRlkBHVEROv79MJi2Fur/Er2Np1MmHTcWndOF21lBwI2GL6cAiCiAXmu7lu4WdZ09tdS15H7JQeQUZLPbKxAlrt2/uZk8P9x7TIwr9ktfugmckpoYPqi2O26kOkOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3PkiVbJHN2Wj3kDR9IouEU0b2EVdrOEULaOdnXhaih4=;
 b=My7Dj1TohFOJq6BNwSmy0CYCGu+6U/d5cgp0Mj4Mn+JbZplxbNaQYAN4O3bNbC2uWIMGA4sAypUuNSgOlCQG++D3DdcIMPksCIcOg6/GU57hZFYj0+TnpxpMbSRk+0t/A1YMaGam6Yery5LEL6JE5O7edpiZld9ehCTJQdwKqhY=
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com (2603:10a6:208:cd::25)
 by AM0PR05MB6708.eurprd05.prod.outlook.com (2603:10a6:20b:144::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Thu, 2 Apr
 2020 23:52:24 +0000
Received: from AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::a8a8:5862:d11d:627e]) by AM0PR05MB5089.eurprd05.prod.outlook.com
 ([fe80::a8a8:5862:d11d:627e%6]) with mapi id 15.20.2856.019; Thu, 2 Apr 2020
 23:52:24 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "nico@fluxnic.net" <nico@fluxnic.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-next: Tree for Mar 31 (mlx5)
Thread-Topic: linux-next: Tree for Mar 31 (mlx5)
Thread-Index: AQHWB3rm9BEPznDAaEeLeNHBn6MgyqhmhImA
Date:   Thu, 2 Apr 2020 23:52:24 +0000
Message-ID: <7fe582394e82f3e677f2097aab06299f5d5600d5.camel@mellanox.com>
References: <20200331201009.5572e93b@canb.auug.org.au>
         <f01f0019-2e52-bad5-2774-76863960de72@infradead.org>
In-Reply-To: <f01f0019-2e52-bad5-2774-76863960de72@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 68788286-774b-420e-7462-08d7d760e491
x-ms-traffictypediagnostic: AM0PR05MB6708:|AM0PR05MB6708:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR05MB670821C8D74EADAFCDA663C5BEC60@AM0PR05MB6708.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0361212EA8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB5089.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(346002)(136003)(39860400002)(396003)(54906003)(81156014)(81166006)(110136005)(6512007)(2906002)(86362001)(2616005)(36756003)(4326008)(76116006)(186003)(5660300002)(91956017)(71200400001)(6486002)(66446008)(66476007)(66556008)(64756008)(26005)(66946007)(316002)(53546011)(8676002)(8936002)(6506007)(478600001);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eSIrQidckmoTgbGDF2Bn+mMsUfMvKAe0sP509w9GB+Zl4saYlrT92dEpkuEJQmnv8Pmggp8HvSLYRl8DD9xesau13XmNTgEd/7R+JD3pR4yTEyzIvP8QOjqA5k2f6b5dXqs6aD1dz/v5IbGXvyJCfdkDOrrjwxrm6m3b4XAz703a+o962c/rcm2pz6IhJXh8A6oquNDKJ1anAkmxx6DxqXP6Ms+N+Ffq1AKCiXF7u+0GDBLk9eTEXpgXxjje+CAD6E9NN0VX/rIzwOWmLsDiSHbaPEmq9kKPCfE6sxVUiPB1FMsU0SSTQzO56/gt8QhfVSzbLg6YkIp8LvlXP6H6twn7Jt4Kuz5uarT41KCLUuDk7+TyYqDFRCITJ9HNXA00TaKea5P5qNx86kuhY22rHUGKB6XhuVkiJ0eY6cptIiIk9QTFB9cFdoQHxNk4ifYrUbN9mWQ19mR9wk447+Jrs7EngaPGlbyeMJNBfClz6W6y2PoCSkJNsr9hiqZA7tnYWZFs5jvhi9fd7vomotEGuA==
x-ms-exchange-antispam-messagedata: AKSTZ225h5wkHCa9mdmyCa73RJ7j+1YVjqkyQm+DNe6lqDhWMy8t7LZ8/oMmy2icCK0/r0OjrH6+l/7vPzYRg1OEcf8idPZ8okuTmGdqFvJ5SpTigmVmqBenjsibHRuZiNJNc4JUpAVe5txW0hFZIQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <28A42ACEF20D4142ADEA2E8CB2AE57AF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 68788286-774b-420e-7462-08d7d760e491
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Apr 2020 23:52:24.6705
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KvtpIj2dgAzxpAokEBl6EZe2Ze3aW2K0D0+yE/RUJ44gUv6SgdRv58bXUBWaD/5cX+Wtd6G1RfrtCXB/f+EmKw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB6708
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAzLTMxIGF0IDA5OjM5IC0wNzAwLCBSYW5keSBEdW5sYXAgd3JvdGU6DQo+
IE9uIDMvMzEvMjAgMjoxMCBBTSwgU3RlcGhlbiBSb3Rod2VsbCB3cm90ZToNCj4gPiBIaSBhbGws
DQo+ID4gDQo+ID4gVGhlIG1lcmdlIHdpbmRvdyBoYXMgb3BlbmVkLCBzbyBwbGVhc2UgZG8gbm90
IGFkZCBhbnkgbWF0ZXJpYWwgZm9yDQo+ID4gdGhlDQo+ID4gbmV4dCByZWxlYXNlIGludG8geW91
ciBsaW51eC1uZXh0IGluY2x1ZGVkIHRyZWVzL2JyYW5jaGVzIHVudGlsDQo+ID4gYWZ0ZXINCj4g
PiB0aGUgbWVyZ2Ugd2luZG93IGNsb3Nlcy4NCj4gPiANCj4gPiBDaGFuZ2VzIHNpbmNlIDIwMjAw
MzMwOg0KPiA+IA0KPiANCj4gb24geDg2XzY0Og0KPiANCj4gbGQ6IGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9tYWluLm86IGluIGZ1bmN0aW9uDQo+IGBtbHg1X2NsZWFu
dXBfb25jZSc6DQo+IG1haW4uYzooLnRleHQrMHgxY2EpOiB1bmRlZmluZWQgcmVmZXJlbmNlIHRv
IGBtbHg1X3Z4bGFuX2Rlc3Ryb3knDQo+IGxkOiBtYWluLmM6KC50ZXh0KzB4MWQyKTogdW5kZWZp
bmVkIHJlZmVyZW5jZSB0byBgbWx4NV9jbGVhbnVwX2Nsb2NrJw0KPiBsZDogZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21haW4ubzogaW4gZnVuY3Rpb24NCj4gYG1seDVf
bG9hZF9vbmUnOg0KPiBtYWluLmM6KC50ZXh0KzB4ZjQ0KTogdW5kZWZpbmVkIHJlZmVyZW5jZSB0
byBgbWx4NV9pbml0X2Nsb2NrJw0KPiBsZDogbWFpbi5jOigudGV4dCsweGY0Yyk6IHVuZGVmaW5l
ZCByZWZlcmVuY2UgdG8gYG1seDVfdnhsYW5fY3JlYXRlJw0KPiBsZDogbWFpbi5jOigudGV4dCsw
eGZlNSk6IHVuZGVmaW5lZCByZWZlcmVuY2UgdG8gYG1seDVfdnhsYW5fZGVzdHJveScNCj4gDQo+
IA0KDQpUaGlzIGR1ZSB0byBhIGNoYW5nZSBpbiBiZWhhdmlvciBvZiBpbXBseSBrZXl3b3JkIGlu
IGtjb25maWcgZHVlIHRvDQp0aGlzIHBhdGNoOg0KDQpkZWYyZmJmZmU2MmMwMGMzMzBjN2Y0MTU4
NGEzNTYwMDExNzljNTljIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0DQpjb21taXQgZGVmMmZiZmZl
NjJjMDBjMzMwYzdmNDE1ODRhMzU2MDAxMTc5YzU5Yw0KQXV0aG9yOiBNYXNhaGlybyBZYW1hZGEg
PG1hc2FoaXJveUBrZXJuZWwub3JnPg0KRGF0ZTogICBNb24gTWFyIDIgMTU6MjM6MzkgMjAyMCAr
MDkwMA0KDQogICAga2NvbmZpZzogYWxsb3cgc3ltYm9scyBpbXBsaWVkIGJ5IHkgdG8gYmVjb21l
IG0NCiAgICANCiAgICBUaGUgJ2ltcGx5JyBrZXl3b3JkIHJlc3RyaWN0cyBhIHN5bWJvbCB0byB5
IG9yIG4sIGV4Y2x1ZGluZyBtDQogICAgd2hlbiBpdCBpcyBpbXBsaWVkIGJ5IHkuIFRoaXMgaXMg
dGhlIG9yaWdpbmFsIGJlaGF2aW9yIHNpbmNlDQogICAgY29tbWl0IDIzN2UzYWQwZjE5NSAoIktj
b25maWc6IEludHJvZHVjZSB0aGUgImltcGx5IiBrZXl3b3JkIikuDQogICAgDQogICAgSG93ZXZl
ciwgdGhlIGF1dGhvciBvZiB0aGlzIGZlYXR1cmUsIE5pY29sYXMgUGl0cmUsIHN0YXRlZCB0aGF0
DQogICAgdGhlICdpbXBseScga2V5d29yZCBzaG91bGQgbm90IGltcG9zZSBhbnkgcmVzdHJpY3Rp
b25zLg0KICAgIChodHRwczovL2xrbWwub3JnL2xrbWwvMjAyMC8yLzE5LzcxNCkNCiAgICANCiAg
ICBJIGFncmVlLCBhbmQgd2FudCB0byBnZXQgcmlkIG9mIHRoaXMgdHJpY2t5IGJlaGF2aW9yLg0K
ICAgIA0KICAgIFN1Z2dlc3RlZC1ieTogTmljb2xhcyBQaXRyZSA8bmljb0BmbHV4bmljLm5ldD4N
CiAgICBTaWduZWQtb2ZmLWJ5OiBNYXNhaGlybyBZYW1hZGEgPG1hc2FoaXJveUBrZXJuZWwub3Jn
Pg0KICAgIEFja2VkLWJ5OiBOaWNvbGFzIFBpdHJlIDxuaWNvQGZsdXhuaWMubmV0Pg0KDQpGb3Ig
ZXhhbXBsZSBpbiBtbHg1IHdlIHJlbHkgb24gQ09ORklHX1ZYTEFOIHRvIGNvbXBpbGUgaW4vb3V0
IG1seDUncw0KdnhsYW4gc3VwcG9ydCwgdGhlIHByb2JsZW0gb2NjdXJzIHdoZW4gVlhMQU49bSBh
bmQgTUxYNV9DT1JFPXkuLiBwcmlvcg0KdG8gdGhpcyBwYXRjaCBpbXBseSByZXN0cmljdGVkIFZY
TEFOIHRvIHkgcHJpb3IgdG8gdGhpcyBjb21taXQsIGFuZCBhDQp1c2VyIHdobyBzZWxlY3RlZCBN
TFg1IGFuZCBWWExBTiwgcmVnYXJkbGVzcyBvZiBlYWNoIG1vZHVsZSBzdGF0ZQ0KKHksbSksDQpW
WExBTiBpbiBtbHg1IHdvcmtlZC4NCg0KYnV0IG5vdyB3aXRoIHRoZSBjaGFuZ2UgaW4gYmVoYXZp
b3IgLSBldmVuIGlmIHdlIGZpeCBNTFg1IC0gbWx4NSdzDQp2eGxhbiB3aWxsIGJlIGNvbXBpbGVk
LWluIGJ1dCB3aWxsIG5vdCBiZSBhY3R1YWxseSB1c2VkIGFzIFZYTEFOIGlzIG5vdA0KcmVhY2hh
YmxlIC4uIHRoaXMgY2hhbmdlIGluIGJlaGF2aW9yIHdpbGwgaW50cm9kdWNlIHJlZ3Jlc3Npb24g
Zm9yDQp0aG9zZSB3aG8gY2hvb3NlIFZYTEFOPW0gTUxYNV9DT1JFPXkuDQoNClRvIGJlIGhvbmVz
dCB0aGlzIGlzIGEgdmVyeSB1bmxpa2VseSBjb25maWd1cmF0aW9uLCBidXQgc3RpbGwgaSB3YW50
ZWQNCnRvIHJhaXNlIHRoaXMgcHJvYmxlbS4NCg0KSSB3aWxsIHByZXBhcmUgYSBwYXRjaCBmb3Ig
bWx4NS4uIHdoZXJlIGRvIHdlIHBvc3QgbGludXgtbmV4dCBmaXhlcyA/DQpzaW5jZSB0aGlzIGlz
c3VlIGRvZXNuJ3QgZXhpc3QgaW4gbmV0LW5leHQgdHJlZS4uIG9yIHNob3VsZCBpIGp1c3Qgd2Fp
dA0KZm9yIHJjMSA/DQoNClRoYW5rcywNClNhZWVkLg0KDQo=
