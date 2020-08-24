Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5BD724F15E
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 05:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgHXDJT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 23:09:19 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:48868 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726635AbgHXDJS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 23:09:18 -0400
Received: from nkgeml707-chm.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id 5DCEFC53D0322B880C67;
        Mon, 24 Aug 2020 11:09:16 +0800 (CST)
Received: from nkgeml708-chm.china.huawei.com (10.98.57.160) by
 nkgeml707-chm.china.huawei.com (10.98.57.157) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1913.5; Mon, 24 Aug 2020 11:09:16 +0800
Received: from nkgeml708-chm.china.huawei.com ([10.98.57.160]) by
 nkgeml708-chm.china.huawei.com ([10.98.57.160]) with mapi id 15.01.1913.007;
 Mon, 24 Aug 2020 11:09:16 +0800
From:   "Guodeqing (A)" <geffrey.guo@huawei.com>
To:     David Ahern <dsahern@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIGlwdjQ6IGZpeCB0aGUgcHJvYmxlbSBvZiBwaW5n?=
 =?utf-8?Q?_failure_in_some_cases?=
Thread-Topic: [PATCH] ipv4: fix the problem of ping failure in some cases
Thread-Index: AQHWeFkty0AVBoLa8Um0ZFXgwnnYe6lGBUyAgAAB5QCAAI+5gA==
Date:   Mon, 24 Aug 2020 03:09:15 +0000
Message-ID: <5d678cbd20fd4f8fbd2ac75e62aab458@huawei.com>
References: <1598082397-115790-1-git-send-email-geffrey.guo@huawei.com>
 <0b7e931b-f159-4f53-1b9b-5bf84a072712@gmail.com>
 <63e26f77-ccf0-4c07-8eaf-e571dcf2204f@gmail.com>
In-Reply-To: <63e26f77-ccf0-4c07-8eaf-e571dcf2204f@gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.136.112.227]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IERhdmlkIEFoZXJuIFtt
YWlsdG86ZHNhaGVybkBnbWFpbC5jb21dDQo+IOWPkemAgeaXtumXtDogTW9uZGF5LCBBdWd1c3Qg
MjQsIDIwMjAgMTA6MzQNCj4g5pS25Lu25Lq6OiBHdW9kZXFpbmcgKEEpIDxnZWZmcmV5Lmd1b0Bo
dWF3ZWkuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KPiDmioTpgIE6IGt1YmFAa2VybmVsLm9y
ZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiDkuLvpopg6IFJlOiBbUEFUQ0hdIGlwdjQ6IGZp
eCB0aGUgcHJvYmxlbSBvZiBwaW5nIGZhaWx1cmUgaW4gc29tZSBjYXNlcw0KPiANCj4gT24gOC8y
My8yMCA4OjI3IFBNLCBEYXZpZCBBaGVybiB3cm90ZToNCj4gPiBPbiA4LzIyLzIwIDE6NDYgQU0s
IGd1b2RlcWluZyB3cm90ZToNCj4gPj4gaWUuLA0KPiA+PiAkIGlmY29uZmlnIGV0aDAgOS45Ljku
OSBuZXRtYXNrIDI1NS4yNTUuMjU1LjANCj4gPj4NCj4gPj4gJCBwaW5nIC1JIGxvIDkuOS45LjkN
Cj4gDQo+IElmIHRoYXQgZXZlciB3b3JrZWQgaXQgd2FzIHdyb25nOyB0aGUgYWRkcmVzcyBpcyBz
Y29wZWQgdG8gZXRoMCwgbm90IGxvLg0KPiANCj4gPj4gcGluZzogV2FybmluZzogc291cmNlIGFk
ZHJlc3MgbWlnaHQgYmUgc2VsZWN0ZWQgb24gZGV2aWNlIG90aGVyIHRoYW4gbG8uDQo+ID4+IFBJ
TkcgOS45LjkuOSAoOS45LjkuOSkgZnJvbSA5LjkuOS45IGxvOiA1Nig4NCkgYnl0ZXMgb2YgZGF0
YS4NCj4gPj4NCj4gPj4gNCBwYWNrZXRzIHRyYW5zbWl0dGVkLCAwIHJlY2VpdmVkLCAxMDAlIHBh
Y2tldCBsb3NzLCB0aW1lIDMwNjhtcw0KPiA+Pg0KPiA+PiBUaGlzIGlzIGJlY2F1c2UgdGhlIHJl
dHVybiB2YWx1ZSBvZiBfX3Jhd192NF9sb29rdXAgaW4gcmF3X3Y0X2lucHV0DQo+ID4+IGlzIG51
bGwsIHRoZSBwYWNrZXRzIGNhbm5vdCBiZSBzZW50IHRvIHRoZSBwaW5nIGFwcGxpY2F0aW9uLg0K
PiA+PiBUaGUgcmVhc29uIG9mIHRoZSBfX3Jhd192NF9sb29rdXAgZmFpbHVyZSBpcyB0aGF0IHNr
X2JvdW5kX2Rldl9pZiBhbmQNCj4gPj4gZGlmL3NkaWYgYXJlIG5vdCBlcXVhbCBpbiByYXdfc2tf
Ym91bmRfZGV2X2VxLg0KPiA+Pg0KPiA+PiBIZXJlIEkgYWRkIGEgY2hlY2sgb2Ygd2hldGhlciB0
aGUgc2tfYm91bmRfZGV2X2lmIGlzIExPT1BCQUNLX0lGSU5ERVgNCj4gPj4gdG8gc29sdmUgdGhp
cyBwcm9ibGVtLg0KPiA+Pg0KPiA+PiBGaXhlczogMTllNGU3NjgwNjRhOCAoImlwdjQ6IEZpeCBy
YXcgc29ja2V0IGxvb2t1cCBmb3IgbG9jYWwNCj4gPj4gdHJhZmZpYyIpDQo+ID4+IFNpZ25lZC1v
ZmYtYnk6IGd1b2RlcWluZyA8Z2VmZnJleS5ndW9AaHVhd2VpLmNvbT4NCj4gPj4gLS0tDQo+ID4+
ICBpbmNsdWRlL25ldC9pbmV0X3NvY2suaCB8IDIgKy0NCj4gPj4gIDEgZmlsZSBjaGFuZ2VkLCAx
IGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS9uZXQvaW5ldF9zb2NrLmggYi9pbmNsdWRlL25ldC9pbmV0X3NvY2suaCBpbmRleA0KPiA+
PiBhMzcwMmQxLi43NzA3YjFkIDEwMDY0NA0KPiA+PiAtLS0gYS9pbmNsdWRlL25ldC9pbmV0X3Nv
Y2suaA0KPiA+PiArKysgYi9pbmNsdWRlL25ldC9pbmV0X3NvY2suaA0KPiA+PiBAQCAtMTQ0LDcg
KzE0NCw3IEBAIHN0YXRpYyBpbmxpbmUgYm9vbCBpbmV0X2JvdW5kX2Rldl9lcShib29sDQo+ID4+
IGwzbWRldl9hY2NlcHQsIGludCBib3VuZF9kZXZfaWYsICB7DQo+ID4+ICAJaWYgKCFib3VuZF9k
ZXZfaWYpDQo+ID4+ICAJCXJldHVybiAhc2RpZiB8fCBsM21kZXZfYWNjZXB0Ow0KPiA+PiAtCXJl
dHVybiBib3VuZF9kZXZfaWYgPT0gZGlmIHx8IGJvdW5kX2Rldl9pZiA9PSBzZGlmOw0KPiA+PiAr
CXJldHVybiBib3VuZF9kZXZfaWYgPT0gZGlmIHx8IGJvdW5kX2Rldl9pZiA9PSBzZGlmIHx8IGJv
dW5kX2Rldl9pZg0KPiA+PiArPT0gTE9PUEJBQ0tfSUZJTkRFWDsNCj4gPj4gIH0NCj4gPj4NCj4g
Pj4gIHN0cnVjdCBpbmV0X2Nvcmsgew0KPiA+Pg0KPiA+DQo+ID4gdGhpcyBpcyB1c2VkIGJ5IG1v
cmUgdGhhbiBqdXN0IHJhdyBzb2NrZXQgbG9va3Vwcy4NCj4gPg0KPiANCj4gQW5kIGFzc3VtaW5n
IGl0IHNob3VsZCB3b3JrLCB0aGlzIGlzIGRlZmluaXRlbHkgdGhlIHdyb25nIGZpeC4NCg0Kb2ss
IEkgc2VlIG5vdy4gSSBtaXN1bmRlcnN0b29kIHRoZSBmdW5jdGlvbiBvZiB0aGUgbG9vcGJhY2sg
aW50ZXJmYWNlLCB0aGFua3MuDQo=
