Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94083289C1
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 21:43:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389972AbfEWTlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 15:41:47 -0400
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:5030
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389876AbfEWTTq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 May 2019 15:19:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cHOmM/KGa0RyWai6IMj74bW9NLHtq4WA0zhzXCrwATU=;
 b=VA9XekBf+ActsYLYdtyv/vMSXocqKdVGi4pFWtWv49tLTdgdhA09eX6hmPsOr2hQGjnIdw6MicomA4KI90kNYKcm79iIwxUpgwOnqWnxH3HyBOz9ESkS1O8Y6joQqTqU3be3dYNJrOddy82G89oWB0uO0+A/roLwNH6e6PM9zlE=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1922.17; Thu, 23 May 2019 19:19:40 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::7159:5f3a:906:6aab%7]) with mapi id 15.20.1922.013; Thu, 23 May 2019
 19:19:40 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "jesper.brouer@gmail.com" <jesper.brouer@gmail.com>
CC:     "sthemmin@microsoft.com" <sthemmin@microsoft.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] net: core: support XDP generic on stacked devices.
Thread-Topic: [PATCH v3 2/2] net: core: support XDP generic on stacked
 devices.
Thread-Index: AQHVEZCixsr/wh+WbEOMJ1n0OIQBfKZ5FcsA
Date:   Thu, 23 May 2019 19:19:40 +0000
Message-ID: <3dbe4e29bf1ec71809e9dd2b32ec16272957a4cd.camel@mellanox.com>
References: <20190523175429.13302-1-sthemmin@microsoft.com>
         <20190523175429.13302-3-sthemmin@microsoft.com>
In-Reply-To: <20190523175429.13302-3-sthemmin@microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 588de63d-49be-4335-0ba8-08d6dfb39ab0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB6044;
x-ms-traffictypediagnostic: DB8PR05MB6044:
x-microsoft-antispam-prvs: <DB8PR05MB604481C992DCC52A25708A35BE010@DB8PR05MB6044.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 00462943DE
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(86362001)(71200400001)(71190400001)(2201001)(4326008)(6506007)(6246003)(5660300002)(2501003)(36756003)(99286004)(316002)(11346002)(446003)(66066001)(2616005)(476003)(118296001)(102836004)(110136005)(256004)(54906003)(25786009)(6116002)(76176011)(53936002)(2906002)(3846002)(14444005)(58126008)(91956017)(76116006)(68736007)(6436002)(478600001)(66446008)(66946007)(66476007)(14454004)(73956011)(66556008)(64756008)(26005)(7736002)(6486002)(186003)(486006)(8676002)(6512007)(229853002)(305945005)(8936002)(81156014)(81166006)(41533002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6044;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: t17G3P4QsHISiphNOqoGQZkx+wjreD00ygrmGJlxBh4qFAZU1AsZI4uS/ey9M3mIqbU/JyBTSnFP/hFx9U9Fl/lmBei1epDq1KyJGIM837Zi9iEtBdeYw/jcuyiEciQdnVzadv4zxHojCHDsbUNmrRTe418F4KGv2nROsrAl0uxHqQSFlmN8gHGNh3YPUjOxh1ZN6UgmXTjvtj0sMsFrdHIDssJXmcd8uUsf4+nhWFPKu5d9YvPnMqKc7wVzU8vrtKeGOuk/I3lA7bqNSmR0eHb+JHKfNK9JZuJhZXqgb29u252Up9/3KUsxAC8CScFBltpSwbKcjlkDKfTFP7OVBCVmiecq9+J5FJXynWzIQ+AFSsxGzFTtl8UZl9yoJlOm3nllv0Iidu+9A34WbgJqd3ljCpAG8rkhWAOWrFHacQ0=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BD810CC060BE6E47BF8E8E3614130BD1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 588de63d-49be-4335-0ba8-08d6dfb39ab0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2019 19:19:40.5893
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6044
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA1LTIzIGF0IDEwOjU0IC0wNzAwLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90
ZToNCj4gV2hlbiBhIGRldmljZSBpcyBzdGFja2VkIGxpa2UgKHRlYW0sIGJvbmRpbmcsIGZhaWxz
YWZlIG9yIG5ldHZzYykgdGhlDQo+IFhEUCBnZW5lcmljIHByb2dyYW0gZm9yIHRoZSBwYXJlbnQg
ZGV2aWNlIHdhcyBub3QgY2FsbGVkLg0KPiANCj4gTW92ZSB0aGUgY2FsbCB0byBYRFAgZ2VuZXJp
YyBpbnNpZGUgX19uZXRpZl9yZWNlaXZlX3NrYl9jb3JlIHdoZXJlDQo+IGl0IGNhbiBiZSBkb25l
IG11bHRpcGxlIHRpbWVzIGZvciBzdGFja2VkIGNhc2UuDQo+IA0KPiBTdWdnZXN0ZWQtYnk6IEpp
cmkgUGlya28gPGppcmlAcmVzbnVsbGkudXM+DQo+IEZpeGVzOiBkNDQ1NTE2OTY2ZGMgKCJuZXQ6
IHhkcDogc3VwcG9ydCB4ZHAgZ2VuZXJpYyBvbiB2aXJ0dWFsDQo+IGRldmljZXMiKQ0KPiBTaWdu
ZWQtb2ZmLWJ5OiBTdGVwaGVuIEhlbW1pbmdlciA8c3RoZW1taW5AbWljcm9zb2Z0LmNvbT4NCj4g
LS0tDQo+IHYxIC0gY2FsbCB4ZHBfZ2VuZXJpYyBpbiBuZXR2c2MgaGFuZGxlcg0KPiB2MiAtIGRv
IHhkcF9nZW5lcmljIGluIGdlbmVyaWMgcnggaGFuZGxlciBwcm9jZXNzaW5nDQo+IHYzIC0gbW92
ZSB4ZHBfZ2VuZXJpYyBjYWxsIGluc2lkZSB0aGUgYW5vdGhlciBwYXNzIGxvb3ANCj4gDQo+ICBu
ZXQvY29yZS9kZXYuYyB8IDU2ICsrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0NCj4gLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDExIGluc2VydGlvbnMoKyksIDQ1
IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL2Rldi5jIGIvbmV0L2Nv
cmUvZGV2LmMNCj4gaW5kZXggYjZiODUwNWNmYjNlLi42OTY3NzZlMTRkMDAgMTAwNjQ0DQo+IC0t
LSBhL25ldC9jb3JlL2Rldi5jDQo+ICsrKyBiL25ldC9jb3JlL2Rldi5jDQo+IEBAIC00NTAyLDIz
ICs0NTAyLDYgQEAgc3RhdGljIGludCBuZXRpZl9yeF9pbnRlcm5hbChzdHJ1Y3Qgc2tfYnVmZg0K
PiAqc2tiKQ0KPiAgDQo+ICAJdHJhY2VfbmV0aWZfcngoc2tiKTsNCj4gIA0KPiAtCWlmIChzdGF0
aWNfYnJhbmNoX3VubGlrZWx5KCZnZW5lcmljX3hkcF9uZWVkZWRfa2V5KSkgew0KPiAtCQlpbnQg
cmV0Ow0KPiAtDQo+IC0JCXByZWVtcHRfZGlzYWJsZSgpOw0KPiAtCQlyY3VfcmVhZF9sb2NrKCk7
DQo+IC0JCXJldCA9IGRvX3hkcF9nZW5lcmljKHJjdV9kZXJlZmVyZW5jZShza2ItPmRldi0NCj4g
PnhkcF9wcm9nKSwgc2tiKTsNCj4gLQkJcmN1X3JlYWRfdW5sb2NrKCk7DQo+IC0JCXByZWVtcHRf
ZW5hYmxlKCk7DQo+IC0NCj4gLQkJLyogQ29uc2lkZXIgWERQIGNvbnN1bWluZyB0aGUgcGFja2V0
IGEgc3VjY2VzcyBmcm9tDQo+IC0JCSAqIHRoZSBuZXRkZXYgcG9pbnQgb2YgdmlldyB3ZSBkbyBu
b3Qgd2FudCB0byBjb3VudA0KPiAtCQkgKiB0aGlzIGFzIGFuIGVycm9yLg0KPiAtCQkgKi8NCj4g
LQkJaWYgKHJldCAhPSBYRFBfUEFTUykNCj4gLQkJCXJldHVybiBORVRfUlhfU1VDQ0VTUzsNCj4g
LQl9DQo+IC0NCg0KQWRkaW5nIEplc3BlciwgDQoNClRoZXJlIGlzIGEgc21hbGwgYmVoYXZpb3Jh
bCBjaGFuZ2UgZHVlIHRvIHRoaXMgcGF0Y2gsIA0KdGhlIFhEUCBwcm9ncmFtIGFmdGVyIHRoaXMg
cGF0Y2ggd2lsbCBydW4gb24gdGhlIFJQUyBDUFUsIGlmDQpjb25maWd1cmVkLCB3aGljaCBjb3Vs
ZCBjYXVzZSBzb21lIGJlaGF2aW9yYWwgY2hhbmdlcyBpbg0KeGRwX3JlZGlyZWN0X2NwdTogYnBm
X3JlZGlyZWN0X21hcChjcHVfbWFwKS4NCg0KTWF5YmUgdGhpcyBpcyBhY2NlcHRhYmxlLCBidXQg
aXQgc2hvdWxkIGJlIGRvY3VtZW50ZWQsIGFzIHRoZSBjdXJyZW50DQphc3N1bXB0aW9uIGRpY3Rh
dGVzOiBYRFAgcHJvZ3JhbSBydW5zIG9uIHRoZSBjb3JlIHdoZXJlIHRoZSBYRFANCmZyYW1lL1NL
QiB3YXMgZmlyc3Qgc2Vlbi4NCg0KPiAgI2lmZGVmIENPTkZJR19SUFMNCj4gIAlpZiAoc3RhdGlj
X2JyYW5jaF91bmxpa2VseSgmcnBzX25lZWRlZCkpIHsNCj4gIAkJc3RydWN0IHJwc19kZXZfZmxv
dyB2b2lkZmxvdywgKnJmbG93ID0gJnZvaWRmbG93Ow0KPiBAQCAtNDg1OCw2ICs0ODQxLDE3IEBA
IHN0YXRpYyBpbnQgX19uZXRpZl9yZWNlaXZlX3NrYl9jb3JlKHN0cnVjdA0KPiBza19idWZmICpz
a2IsIGJvb2wgcGZtZW1hbGxvYywNCj4gIA0KPiAgCV9fdGhpc19jcHVfaW5jKHNvZnRuZXRfZGF0
YS5wcm9jZXNzZWQpOw0KPiAgDQo+ICsJaWYgKHN0YXRpY19icmFuY2hfdW5saWtlbHkoJmdlbmVy
aWNfeGRwX25lZWRlZF9rZXkpKSB7DQo+ICsJCWludCByZXQyOw0KPiArDQo+ICsJCXByZWVtcHRf
ZGlzYWJsZSgpOw0KPiArCQlyZXQyID0gZG9feGRwX2dlbmVyaWMocmN1X2RlcmVmZXJlbmNlKHNr
Yi0+ZGV2LQ0KPiA+eGRwX3Byb2cpLCBza2IpOw0KPiArCQlwcmVlbXB0X2VuYWJsZSgpOw0KPiAr
DQo+ICsJCWlmIChyZXQyICE9IFhEUF9QQVNTKQ0KPiArCQkJcmV0dXJuIE5FVF9SWF9EUk9QOw0K
PiArCX0NCj4gKw0KPiAgCWlmIChza2ItPnByb3RvY29sID09IGNwdV90b19iZTE2KEVUSF9QXzgw
MjFRKSB8fA0KPiAgCSAgICBza2ItPnByb3RvY29sID09IGNwdV90b19iZTE2KEVUSF9QXzgwMjFB
RCkpIHsNCj4gIAkJc2tiID0gc2tiX3ZsYW5fdW50YWcoc2tiKTsNCj4gQEAgLTUxNzgsMTkgKzUx
NzIsNiBAQCBzdGF0aWMgaW50IG5ldGlmX3JlY2VpdmVfc2tiX2ludGVybmFsKHN0cnVjdA0KPiBz
a19idWZmICpza2IpDQo+ICAJaWYgKHNrYl9kZWZlcl9yeF90aW1lc3RhbXAoc2tiKSkNCj4gIAkJ
cmV0dXJuIE5FVF9SWF9TVUNDRVNTOw0KPiAgDQo+IC0JaWYgKHN0YXRpY19icmFuY2hfdW5saWtl
bHkoJmdlbmVyaWNfeGRwX25lZWRlZF9rZXkpKSB7DQo+IC0JCWludCByZXQ7DQo+IC0NCj4gLQkJ
cHJlZW1wdF9kaXNhYmxlKCk7DQo+IC0JCXJjdV9yZWFkX2xvY2soKTsNCj4gLQkJcmV0ID0gZG9f
eGRwX2dlbmVyaWMocmN1X2RlcmVmZXJlbmNlKHNrYi0+ZGV2LQ0KPiA+eGRwX3Byb2cpLCBza2Ip
Ow0KPiAtCQlyY3VfcmVhZF91bmxvY2soKTsNCj4gLQkJcHJlZW1wdF9lbmFibGUoKTsNCj4gLQ0K
PiAtCQlpZiAocmV0ICE9IFhEUF9QQVNTKQ0KPiAtCQkJcmV0dXJuIE5FVF9SWF9EUk9QOw0KPiAt
CX0NCj4gLQ0KPiAgCXJjdV9yZWFkX2xvY2soKTsNCj4gICNpZmRlZiBDT05GSUdfUlBTDQo+ICAJ
aWYgKHN0YXRpY19icmFuY2hfdW5saWtlbHkoJnJwc19uZWVkZWQpKSB7DQo+IEBAIC01MjI0LDIx
ICs1MjA1LDYgQEAgc3RhdGljIHZvaWQNCj4gbmV0aWZfcmVjZWl2ZV9za2JfbGlzdF9pbnRlcm5h
bChzdHJ1Y3QgbGlzdF9oZWFkICpoZWFkKQ0KPiAgCX0NCj4gIAlsaXN0X3NwbGljZV9pbml0KCZz
dWJsaXN0LCBoZWFkKTsNCj4gIA0KPiAtCWlmIChzdGF0aWNfYnJhbmNoX3VubGlrZWx5KCZnZW5l
cmljX3hkcF9uZWVkZWRfa2V5KSkgew0KPiAtCQlwcmVlbXB0X2Rpc2FibGUoKTsNCj4gLQkJcmN1
X3JlYWRfbG9jaygpOw0KPiAtCQlsaXN0X2Zvcl9lYWNoX2VudHJ5X3NhZmUoc2tiLCBuZXh0LCBo
ZWFkLCBsaXN0KSB7DQo+IC0JCQl4ZHBfcHJvZyA9IHJjdV9kZXJlZmVyZW5jZShza2ItPmRldi0+
eGRwX3Byb2cpOw0KPiAtCQkJc2tiX2xpc3RfZGVsX2luaXQoc2tiKTsNCj4gLQkJCWlmIChkb194
ZHBfZ2VuZXJpYyh4ZHBfcHJvZywgc2tiKSA9PSBYRFBfUEFTUykNCj4gLQkJCQlsaXN0X2FkZF90
YWlsKCZza2ItPmxpc3QsICZzdWJsaXN0KTsNCj4gLQkJfQ0KPiAtCQlyY3VfcmVhZF91bmxvY2so
KTsNCj4gLQkJcHJlZW1wdF9lbmFibGUoKTsNCj4gLQkJLyogUHV0IHBhc3NlZCBwYWNrZXRzIGJh
Y2sgb24gbWFpbiBsaXN0ICovDQo+IC0JCWxpc3Rfc3BsaWNlX2luaXQoJnN1Ymxpc3QsIGhlYWQp
Ow0KPiAtCX0NCj4gLQ0KPiAgCXJjdV9yZWFkX2xvY2soKTsNCj4gICNpZmRlZiBDT05GSUdfUlBT
DQo+ICAJaWYgKHN0YXRpY19icmFuY2hfdW5saWtlbHkoJnJwc19uZWVkZWQpKSB7DQo=
