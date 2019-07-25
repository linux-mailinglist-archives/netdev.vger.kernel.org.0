Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90E37759AF
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 23:32:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726764AbfGYVc0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 17:32:26 -0400
Received: from mail-eopbgr20082.outbound.protection.outlook.com ([40.107.2.82]:25990
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726524AbfGYVcZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 17:32:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TgKDPDjScqzpWMW8fBS2i4ntavkPiyqZPqG+BRarGCaI/5TaeWAjFqXHthiy+QqRjfDIhgDqd1yTzZPpONsLxlw9MW+qXTFP+UfBk0eDp24w9c88sakpYY4lseOhz33iD/XggvuuZuyCl8KX84O11QE/M4hEvmrhqm8KhK/1KkMxNf+EmckeAe74p+YYCbW6k09Mf8B4pXyWn5hVgIMKCCPQzmGzJX96ChYMoGq71k1QzOZeAXc1/SOwjfK5S44aMWE4TsLCRhnU3UJXMFrf6KA3dFdLQTSzjT5paxUybouB0uzwM5KuRhYbWM0hVfyX5QIbtqcx5K967L1eqqA/wg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXmqHfqyf0kGySkqnq+y8a5Rq+BEHpAlAUkPRX1CwGo=;
 b=LK0VOoFiVpWPiPnjbav8KqRfaI/wNDGBDFLw5rSJQNWNQh9I6O1Ik+aqT4Ii0qtbnLQDcytR2GCMx6jnffBxh9F0bVWk25lt1pN4taulsxVd5ZKeFZwQq+S+L10Lslwnxe/bujqoBW8Z0uKPeGT6x7Y99Xe4GwoAOexSYBsAUZK7+OjMZGUOP6zL8Q0Eb1akjHc6pBgGxGYrCBwJIV7PwCB8jbtBhuupWcb+lH+MnIlQwDyS+cNzvtquDafO2+zDkFny4JOQlfOkQ6QbiYgpfPQpTkI0Ltql517cFy7VywtgeSdZ2DHkIQLWgjoci45im442AgL/v1kyh/B3HhY93A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BXmqHfqyf0kGySkqnq+y8a5Rq+BEHpAlAUkPRX1CwGo=;
 b=IzE5UuqYg9mCKg2tuitKrhOsotXRV8epPdVx1DbrLtTD0bUTtfIt3fuzSRu4my9PEA1zERc/3Q9sb2sJQ609rQNNrB8SU/eP8i36jZcYsvXcv7V0NWrJRmTz2sEALf7l2TKVi4r9u0LtCJETy3mjC+uXM/7v6VpkqEDANuljq7g=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2166.eurprd05.prod.outlook.com (10.168.55.22) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 21:32:21 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 21:32:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "moyufeng@huawei.com" <moyufeng@huawei.com>
Subject: Re: [PATCH net-next 06/11] net: hns3: modify firmware version display
 format
Thread-Topic: [PATCH net-next 06/11] net: hns3: modify firmware version
 display format
Thread-Index: AQHVQc7gPUQCkxP3gUGLgKEVDyBYDqbaGVMAgACGJACAAT3JAA==
Date:   Thu, 25 Jul 2019 21:32:20 +0000
Message-ID: <d6a32434af7e9c883f104ae66e62b7b376abb39c.camel@mellanox.com>
References: <1563938327-9865-1-git-send-email-tanhuazhong@huawei.com>
         <1563938327-9865-7-git-send-email-tanhuazhong@huawei.com>
         <4c4ce27c9a9372340c0e2b0f654b3fb9cd85b3e4.camel@mellanox.com>
         <95783289-9b3b-f085-876b-49815b07d595@huawei.com>
In-Reply-To: <95783289-9b3b-f085-876b-49815b07d595@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5464340f-c291-4d1d-e47e-08d711479367
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2166;
x-ms-traffictypediagnostic: DB6PR0501MB2166:
x-microsoft-antispam-prvs: <DB6PR0501MB21668A2408CBF2106CD73305BEC10@DB6PR0501MB2166.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(366004)(136003)(346002)(189003)(199004)(6116002)(86362001)(99286004)(3846002)(316002)(2616005)(53936002)(110136005)(58126008)(476003)(446003)(6486002)(53546011)(76176011)(68736007)(102836004)(54906003)(6506007)(11346002)(25786009)(186003)(76116006)(2906002)(6246003)(66556008)(26005)(64756008)(91956017)(66946007)(6512007)(66476007)(66446008)(6436002)(81156014)(7736002)(14454004)(486006)(229853002)(2501003)(305945005)(478600001)(8676002)(256004)(5660300002)(66066001)(81166006)(71200400001)(71190400001)(36756003)(118296001)(4326008)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2166;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: EfEP6Yu/W8IglDMTmlp8slWjblI01bN4JoEd1DQGLhMD1ZD4jk4CfLEGqX17eYGJz8Lz99sX9nkQfYWaYBFNZ4Xm6V6FGhpXs17gHe1riZ1y9EK7kBQUWZuVDA6gK74YVkwNMZ3e75i3XJeyQtn7aLlLj6frQGhJ2LGqT01pTR6NrjUpcIpO+q1MKkyyucv+KMZhTqHxpVs6u88gWNFiyV8zCOSplstZnwDD300GQ4Y2m8mZRUnSjC0XwxGWUJnaZmcP47U+i+xC4r3CqVp8JY1cHt4mdSKdGAFLMeRcpSu6Sl8zHdt+jFwKx1DWJUzV86f+C3Rl+B8+lJ+cp6zns9JojMgNbXwtnVbe1UsS6dJKK6m7BmUwtu5worQvHjSKHZ6mIyP2+GKTdH8K0QpCRphGpLaMGk2wn9V2pL1r9Sk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1992A6B248555C418ED65C4DE349F332@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5464340f-c291-4d1d-e47e-08d711479367
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 21:32:20.8864
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDEwOjM0ICswODAwLCB0YW5odWF6aG9uZyB3cm90ZToNCj4g
DQo+IE9uIDIwMTkvNy8yNSAyOjM0LCBTYWVlZCBNYWhhbWVlZCB3cm90ZToNCj4gPiBPbiBXZWQs
IDIwMTktMDctMjQgYXQgMTE6MTggKzA4MDAsIEh1YXpob25nIFRhbiB3cm90ZToNCj4gPiA+IEZy
b206IFl1ZmVuZyBNbyA8bW95dWZlbmdAaHVhd2VpLmNvbT4NCj4gPiA+IA0KPiA+ID4gVGhpcyBw
YXRjaCBtb2RpZmllcyBmaXJtd2FyZSB2ZXJzaW9uIGRpc3BsYXkgZm9ybWF0IGluDQo+ID4gPiBo
Y2xnZSh2ZilfY21kX2luaXQoKSBhbmQgaG5zM19nZXRfZHJ2aW5mbygpLiBBbHNvLCBhZGRzDQo+
ID4gPiBzb21lIG9wdGltaXphdGlvbnMgZm9yIGZpcm13YXJlIHZlcnNpb24gZGlzcGxheSBmb3Jt
YXQuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFl1ZmVuZyBNbyA8bW95dWZlbmdAaHVh
d2VpLmNvbT4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFBlbmcgTGkgPGxpcGVuZzMyMUBodWF3ZWku
Y29tPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogSHVhemhvbmcgVGFuIDx0YW5odWF6aG9uZ0BodWF3
ZWkuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNv
bi9obnMzL2huYWUzLmggICAgICAgICAgICAgIHwgIDkNCj4gPiA+ICsrKysrKysrKw0KPiA+ID4g
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzX2V0aHRvb2wuYyAgICAg
ICB8IDE1DQo+ID4gPiArKysrKysrKysrKysrLS0NCj4gPiA+ICAgZHJpdmVycy9uZXQvZXRoZXJu
ZXQvaGlzaWxpY29uL2huczMvaG5zM3BmL2hjbGdlX2NtZC5jICAgfCAxMA0KPiA+ID4gKysrKysr
KysrLQ0KPiA+ID4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzdmYv
aGNsZ2V2Zl9jbWQuYyB8IDExDQo+ID4gPiArKysrKysrKystLQ0KPiA+ID4gICA0IGZpbGVzIGNo
YW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDUgZGVsZXRpb25zKC0pDQo+ID4gPiANCj4gPiA+IA0K
DQpbLi4uXQ0KDQo+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5z
My9obnMzcGYvaGNsZ2VfY21kLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hp
c2lsaWNvbi9obnMzL2huczNwZi9oY2xnZV9jbWQuYw0KPiA+ID4gQEAgLTQxOSw3ICs0MTksMTUg
QEAgaW50IGhjbGdlX2NtZF9pbml0KHN0cnVjdCBoY2xnZV9kZXYgKmhkZXYpDQo+ID4gPiAgIAl9
DQo+ID4gPiAgIAloZGV2LT5md192ZXJzaW9uID0gdmVyc2lvbjsNCj4gPiA+ICAgDQo+ID4gPiAt
CWRldl9pbmZvKCZoZGV2LT5wZGV2LT5kZXYsICJUaGUgZmlybXdhcmUgdmVyc2lvbiBpcyAlMDh4
XG4iLA0KPiA+ID4gdmVyc2lvbik7DQo+ID4gPiArCXByX2luZm9fb25jZSgiVGhlIGZpcm13YXJl
IHZlcnNpb24gaXMgJWx1LiVsdS4lbHUuJWx1XG4iLA0KPiA+ID4gKwkJICAgICBobmFlM19nZXRf
ZmllbGQodmVyc2lvbiwNCj4gPiA+IEhOQUUzX0ZXX1ZFUlNJT05fQllURTNfTUFTSywNCj4gPiA+
ICsJCQkJICAgICBITkFFM19GV19WRVJTSU9OX0JZVEUzX1NISUZUKSwNCj4gPiA+ICsJCSAgICAg
aG5hZTNfZ2V0X2ZpZWxkKHZlcnNpb24sDQo+ID4gPiBITkFFM19GV19WRVJTSU9OX0JZVEUyX01B
U0ssDQo+ID4gPiArCQkJCSAgICAgSE5BRTNfRldfVkVSU0lPTl9CWVRFMl9TSElGVCksDQo+ID4g
PiArCQkgICAgIGhuYWUzX2dldF9maWVsZCh2ZXJzaW9uLA0KPiA+ID4gSE5BRTNfRldfVkVSU0lP
Tl9CWVRFMV9NQVNLLA0KPiA+ID4gKwkJCQkgICAgIEhOQUUzX0ZXX1ZFUlNJT05fQllURTFfU0hJ
RlQpLA0KPiA+ID4gKwkJICAgICBobmFlM19nZXRfZmllbGQodmVyc2lvbiwNCj4gPiA+IEhOQUUz
X0ZXX1ZFUlNJT05fQllURTBfTUFTSywNCj4gPiA+ICsJCQkJICAgICBITkFFM19GV19WRVJTSU9O
X0JZVEUwX1NISUZUKSk7DQo+ID4gPiAgIA0KPiA+IA0KPiA+IERldmljZSBuYW1lL3N0cmluZyB3
aWxsIG5vdCBiZSBwcmludGVkIG5vdywgd2hhdCBoYXBwZW5zIGlmIGkgaGF2ZQ0KPiA+IG11bHRp
cGxlIGRldmljZXMgPyBhdCBsZWFzdCBwcmludCB0aGUgZGV2aWNlIG5hbWUgYXMgaXQgd2FzIGJl
Zm9yZQ0KPiA+IA0KPiBTaW5jZSBvbiBlYWNoIGJvYXJkIHdlIG9ubHkgaGF2ZSBvbmUgZmlybXdh
cmUsIHRoZSBmaXJtd2FyZQ0KPiB2ZXJzaW9uIGlzIHNhbWUgcGVyIGRldmljZSwgYW5kIHdpbGwg
bm90IGNoYW5nZSB3aGVuIHJ1bm5pbmcuDQo+IFNvIHByX2luZm9fb25jZSgpIGxvb2tzIGdvb2Qg
Zm9yIHRoaXMgY2FzZS4NCj4gDQoNCmJvYXJkcyBjaGFuZ2UgdG9vIG9mdGVuIHRvIGhhdmUgc3Vj
aCBzdGF0aWMgYXNzdW1wdGlvbi4NCg0KPiBCVFcsIG1heWJlIHdlIHNob3VsZCBjaGFuZ2UgYmVs
b3cgcHJpbnQgaW4gdGhlIGVuZCBvZg0KPiBoY2xnZV9pbml0X2FlX2RldigpLCB1c2UgZGV2X2lu
Zm8oKSBpbnN0ZWFkIG9mIHByX2luZm8oKSwNCj4gdGhlbiB3ZSBjYW4ga25vdyB0aGF0IHdoaWNo
IGRldmljZSBoYXMgYWxyZWFkeSBpbml0aWFsaXplZC4NCj4gSSB3aWxsIHNlbmQgb3RoZXIgcGF0
Y2ggdG8gZG8gdGhhdCwgaXMgaXQgYWNjZXB0YWJsZSBmb3IgeW91Pw0KPiANCj4gInByX2luZm8o
IiVzIGRyaXZlciBpbml0aWFsaXphdGlvbiBmaW5pc2hlZC5cbiIsIEhDTEdFX0RSSVZFUl9OQU1F
KTsiDQo+IA0KDQpJIHdvdWxkIGF2b2lkIHVzaW5nIHByX2luZm8gd2hlbiBpIGNhbiAhIGlmIHlv
dSBoYXZlIHRoZSBvcHRpb24gdG8NCnByaW50IHdpdGggZGV2IGluZm9ybWF0aW9uIGFzIGl0IHdh
cyBiZWZvcmUgdGhhdCBpcyBwcmVmZXJhYmxlLg0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
