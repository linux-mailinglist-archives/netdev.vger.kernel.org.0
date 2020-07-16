Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64636221E06
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 10:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgGPIQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 04:16:45 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2580 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725867AbgGPIQp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 04:16:45 -0400
Received: from nkgeml708-chm.china.huawei.com (unknown [172.30.72.54])
        by Forcepoint Email with ESMTP id DE94255744157899DEBE;
        Thu, 16 Jul 2020 16:16:41 +0800 (CST)
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml708-chm.china.huawei.com (10.98.57.160) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Thu, 16 Jul 2020 16:16:41 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.1913.007;
 Thu, 16 Jul 2020 16:16:41 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     Julian Anastasov <ja@ssi.bg>
CC:     "wensong@linux-vs.org" <wensong@linux-vs.org>,
        "horms@verge.net.au" <horms@verge.net.au>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "fw@strlen.de" <fw@strlen.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "lvs-devel@vger.kernel.org" <lvs-devel@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBpcHZzOiBmaXggdGhlIGNvbm5lY3Rpb24gc3luYyBm?=
 =?gb2312?Q?ailed_in_some_cases?=
Thread-Topic: [PATCH] ipvs: fix the connection sync failed in some cases
Thread-Index: AQHWWnVcQeKvQJuISkaQl2jKbtaPdKkIYbIAgAFkcQA=
Date:   Thu, 16 Jul 2020 08:16:41 +0000
Message-ID: <4b51941de0ab441385c356cccfee7370@huawei.com>
References: <1594796027-66136-1-git-send-email-geffrey.guo@huawei.com>
 <alpine.LFD.2.23.451.2007152016420.6034@ja.home.ssi.bg>
In-Reply-To: <alpine.LFD.2.23.451.2007152016420.6034@ja.home.ssi.bg>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.164.122.165]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SSBkbyBhIGlwdnMgY29ubmVjdGlvbiBzeW5jIHRlc3QgaW4gYSAzLjEwIHZlcnNpb24ga2VybmVs
IHdoaWNoIGhhcyB0aGUgN2MxM2Y5N2ZmZGU2IGNvbW1pdCB3aGljaCBzdWNjZWVkLiBJIHdpbGwg
bW9kaWZ5IHRoZSBmaXhlcyBpbmZvcm1hdGlvbiBvZiB0aGUgcGF0Y2ggYW5kIHJlcGxhY2UgdGhl
IHNrYl9xdWV1ZV9lbXB0eSB3aXRoIHNrYl9xdWV1ZV9lbXB0eV9sb2NrbGVzcy4NClRoYW5rcy4N
Cg0KLS0tLS3Tyrz+1K28/i0tLS0tDQq3orz+yMs6IEp1bGlhbiBBbmFzdGFzb3YgW21haWx0bzpq
YUBzc2kuYmddIA0Kt6LLzcqxvOQ6IFRodXJzZGF5LCBKdWx5IDE2LCAyMDIwIDE6MzYNCsrVvP7I
yzogR3VvZGVxaW5nIChBKSA8Z2VmZnJleS5ndW9AaHVhd2VpLmNvbT4NCrOty806IHdlbnNvbmdA
bGludXgtdnMub3JnOyBob3Jtc0B2ZXJnZS5uZXQuYXU7IHBhYmxvQG5ldGZpbHRlci5vcmc7IGth
ZGxlY0BuZXRmaWx0ZXIub3JnOyBmd0BzdHJsZW4uZGU7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1
YmFAa2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbHZzLWRldmVsQHZnZXIua2Vy
bmVsLm9yZzsgbmV0ZmlsdGVyLWRldmVsQHZnZXIua2VybmVsLm9yZw0K1vfM4jogUmU6IFtQQVRD
SF0gaXB2czogZml4IHRoZSBjb25uZWN0aW9uIHN5bmMgZmFpbGVkIGluIHNvbWUgY2FzZXMNCg0K
DQoJSGVsbG8sDQoNCk9uIFdlZCwgMTUgSnVsIDIwMjAsIGd1b2RlcWluZyB3cm90ZToNCg0KPiBU
aGUgc3luY190aHJlYWRfYmFja3VwIG9ubHkgY2hlY2tzIHNrX3JlY2VpdmVfcXVldWUgaXMgZW1w
dHkgb3Igbm90LCANCj4gdGhlcmUgaXMgYSBzaXR1YXRpb24gd2hpY2ggY2Fubm90IHN5bmMgdGhl
IGNvbm5lY3Rpb24gZW50cmllcyB3aGVuIA0KPiBza19yZWNlaXZlX3F1ZXVlIGlzIGVtcHR5IGFu
ZCBza19ybWVtX2FsbG9jIGlzIGxhcmdlciB0aGFuIHNrX3JjdmJ1ZiwgDQo+IHRoZSBzeW5jIHBh
Y2tldHMgYXJlIGRyb3BwZWQgaW4gX191ZHBfZW5xdWV1ZV9zY2hlZHVsZV9za2IsIHRoaXMgaXMg
DQo+IGJlY2F1c2UgdGhlIHBhY2tldHMgaW4gcmVhZGVyX3F1ZXVlIGlzIG5vdCByZWFkLCBzbyB0
aGUgcm1lbSBpcyBub3QgDQo+IHJlY2xhaW1lZC4NCg0KCUdvb2QgY2F0Y2guIFdlIG1pc3NlZCB0
aGlzIGNoYW5nZSBpbiBVRFAuLi4NCg0KPiBIZXJlIEkgYWRkIHRoZSBjaGVjayBvZiB3aGV0aGVy
IHRoZSByZWFkZXJfcXVldWUgb2YgdGhlIHVkcCBzb2NrIGlzIA0KPiBlbXB0eSBvciBub3QgdG8g
c29sdmUgdGhpcyBwcm9ibGVtLg0KPiANCj4gRml4ZXM6IDdjMTNmOTdmZmRlNiAoInVkcDogZG8g
ZndkIG1lbW9yeSBzY2hlZHVsaW5nIG9uIGRlcXVldWUiKQ0KDQoJV2h5IHRoaXMgY29tbWl0IGFu
ZCBub3QgMjI3NmY1OGFjNTg5IHdoaWNoIGFkZHMgcmVhZGVyX3F1ZXVlIHRvIHVkcF9wb2xsKCkg
PyBNYXkgYmUgYm90aD8NCg0KPiBSZXBvcnRlZC1ieTogemhvdXh1ZG9uZyA8emhvdXh1ZG9uZzhA
aHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogZ3VvZGVxaW5nIDxnZWZmcmV5Lmd1b0BodWF3
ZWkuY29tPg0KPiAtLS0NCj4gIG5ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c19zeW5jLmMgfCAxMiAr
KysrKysrKy0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA4IGluc2VydGlvbnMoKyksIDQgZGVsZXRp
b25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvbmV0L25ldGZpbHRlci9pcHZzL2lwX3ZzX3N5bmMu
YyANCj4gYi9uZXQvbmV0ZmlsdGVyL2lwdnMvaXBfdnNfc3luYy5jIGluZGV4IDYwNWUwZjYuLmFi
ZThkNjMgMTAwNjQ0DQo+IC0tLSBhL25ldC9uZXRmaWx0ZXIvaXB2cy9pcF92c19zeW5jLmMNCj4g
KysrIGIvbmV0L25ldGZpbHRlci9pcHZzL2lwX3ZzX3N5bmMuYw0KPiBAQCAtMTcxNyw2ICsxNzE3
LDggQEAgc3RhdGljIGludCBzeW5jX3RocmVhZF9iYWNrdXAodm9pZCAqZGF0YSkgIHsNCj4gIAlz
dHJ1Y3QgaXBfdnNfc3luY190aHJlYWRfZGF0YSAqdGluZm8gPSBkYXRhOw0KPiAgCXN0cnVjdCBu
ZXRuc19pcHZzICppcHZzID0gdGluZm8tPmlwdnM7DQo+ICsJc3RydWN0IHNvY2sgKnNrID0gdGlu
Zm8tPnNvY2stPnNrOw0KPiArCXN0cnVjdCB1ZHBfc29jayAqdXAgPSB1ZHBfc2soc2spOw0KPiAg
CWludCBsZW47DQo+ICANCj4gIAlwcl9pbmZvKCJzeW5jIHRocmVhZCBzdGFydGVkOiBzdGF0ZSA9
IEJBQ0tVUCwgbWNhc3RfaWZuID0gJXMsICINCj4gQEAgLTE3MjQsMTIgKzE3MjYsMTQgQEAgc3Rh
dGljIGludCBzeW5jX3RocmVhZF9iYWNrdXAodm9pZCAqZGF0YSkNCj4gIAkJaXB2cy0+YmNmZy5t
Y2FzdF9pZm4sIGlwdnMtPmJjZmcuc3luY2lkLCB0aW5mby0+aWQpOw0KPiAgDQo+ICAJd2hpbGUg
KCFrdGhyZWFkX3Nob3VsZF9zdG9wKCkpIHsNCj4gLQkJd2FpdF9ldmVudF9pbnRlcnJ1cHRpYmxl
KCpza19zbGVlcCh0aW5mby0+c29jay0+c2spLA0KPiAtCQkJICFza2JfcXVldWVfZW1wdHkoJnRp
bmZvLT5zb2NrLT5zay0+c2tfcmVjZWl2ZV9xdWV1ZSkNCj4gLQkJCSB8fCBrdGhyZWFkX3Nob3Vs
ZF9zdG9wKCkpOw0KPiArCQl3YWl0X2V2ZW50X2ludGVycnVwdGlibGUoKnNrX3NsZWVwKHNrKSwN
Cj4gKwkJCQkJICFza2JfcXVldWVfZW1wdHkoJnNrLT5za19yZWNlaXZlX3F1ZXVlKSB8fA0KPiAr
CQkJCQkgIXNrYl9xdWV1ZV9lbXB0eSgmdXAtPnJlYWRlcl9xdWV1ZSkgfHwNCg0KCU1heSBiZSB3
ZSBzaG91bGQgdXNlIHNrYl9xdWV1ZV9lbXB0eV9sb2NrbGVzcyBmb3IgNS40KyBhbmQgc2tiX3F1
ZXVlX2VtcHR5KCkgZm9yIGJhY2twb3J0cyB0byA0LjE0IGFuZCA0LjE5Li4uDQoNCj4gKwkJCQkJ
IGt0aHJlYWRfc2hvdWxkX3N0b3AoKSk7DQo+ICANCj4gIAkJLyogZG8gd2UgaGF2ZSBkYXRhIG5v
dz8gKi8NCj4gLQkJd2hpbGUgKCFza2JfcXVldWVfZW1wdHkoJih0aW5mby0+c29jay0+c2stPnNr
X3JlY2VpdmVfcXVldWUpKSkgew0KPiArCQl3aGlsZSAoIXNrYl9xdWV1ZV9lbXB0eSgmc2stPnNr
X3JlY2VpdmVfcXVldWUpIHx8DQo+ICsJCSAgICAgICAhc2tiX3F1ZXVlX2VtcHR5KCZ1cC0+cmVh
ZGVyX3F1ZXVlKSkgew0KDQoJSGVyZSB0b28NCg0KPiAgCQkJbGVuID0gaXBfdnNfcmVjZWl2ZSh0
aW5mby0+c29jaywgdGluZm8tPmJ1ZiwNCj4gIAkJCQkJaXB2cy0+YmNmZy5zeW5jX21heGxlbik7
DQo+ICAJCQlpZiAobGVuIDw9IDApIHsNCj4gLS0NCj4gMi43LjQNCg0KUmVnYXJkcw0KDQotLQ0K
SnVsaWFuIEFuYXN0YXNvdiA8amFAc3NpLmJnPg0K
