Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44DC955474D
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 14:12:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353349AbiFVJye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 05:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352645AbiFVJyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 05:54:23 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88BDB3A5DD;
        Wed, 22 Jun 2022 02:54:21 -0700 (PDT)
Received: from fraeml713-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LSdxs0C8dz689t8;
        Wed, 22 Jun 2022 17:53:53 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml713-chm.china.huawei.com (10.206.15.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 22 Jun 2022 11:54:18 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 22 Jun 2022 11:54:18 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "kafai@fb.com" <kafai@fb.com>, "yhs@fb.com" <yhs@fb.com>
CC:     "dhowells@redhat.com" <dhowells@redhat.com>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel test robot" <lkp@intel.com>
Subject: RE: [PATCH v5 3/5] bpf: Add bpf_verify_pkcs7_signature() helper
Thread-Topic: [PATCH v5 3/5] bpf: Add bpf_verify_pkcs7_signature() helper
Thread-Index: AQHYhY1kCHhKSR2HMUKh5v3j7X869a1aT6EAgADgkDA=
Date:   Wed, 22 Jun 2022 09:54:18 +0000
Message-ID: <03b67c7a6161428c9ff8a5dde0450402@huawei.com>
References: <20220621163757.760304-1-roberto.sassu@huawei.com>
 <20220621163757.760304-4-roberto.sassu@huawei.com>
 <62b245e22effa_1627420871@john.notmuch>
In-Reply-To: <62b245e22effa_1627420871@john.notmuch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBKb2huIEZhc3RhYmVuZCBbbWFpbHRvOmpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbV0N
Cj4gU2VudDogV2VkbmVzZGF5LCBKdW5lIDIyLCAyMDIyIDEyOjI4IEFNDQo+IFJvYmVydG8gU2Fz
c3Ugd3JvdGU6DQo+ID4gQWRkIHRoZSBicGZfdmVyaWZ5X3BrY3M3X3NpZ25hdHVyZSgpIGhlbHBl
ciwgdG8gZ2l2ZSBlQlBGIHNlY3VyaXR5IG1vZHVsZXMNCj4gPiB0aGUgYWJpbGl0eSB0byBjaGVj
ayB0aGUgdmFsaWRpdHkgb2YgYSBzaWduYXR1cmUgYWdhaW5zdCBzdXBwbGllZCBkYXRhLCBieQ0K
PiA+IHVzaW5nIHVzZXItcHJvdmlkZWQgb3Igc3lzdGVtLXByb3ZpZGVkIGtleXMgYXMgdHJ1c3Qg
YW5jaG9yLg0KPiA+DQo+ID4gVGhlIG5ldyBoZWxwZXIgbWFrZXMgaXQgcG9zc2libGUgdG8gZW5m
b3JjZSBtYW5kYXRvcnkgcG9saWNpZXMsIGFzIGVCUEYNCj4gPiBwcm9ncmFtcyBtaWdodCBiZSBh
bGxvd2VkIHRvIG1ha2Ugc2VjdXJpdHkgZGVjaXNpb25zIG9ubHkgYmFzZWQgb24gZGF0YQ0KPiA+
IHNvdXJjZXMgdGhlIHN5c3RlbSBhZG1pbmlzdHJhdG9yIGFwcHJvdmVzLg0KPiA+DQo+ID4gVGhl
IGNhbGxlciBzaG91bGQgcHJvdmlkZSBib3RoIHRoZSBkYXRhIHRvIGJlIHZlcmlmaWVkIGFuZCB0
aGUgc2lnbmF0dXJlIGFzDQo+ID4gZUJQRiBkeW5hbWljIHBvaW50ZXJzICh0byBtaW5pbWl6ZSB0
aGUgbnVtYmVyIG9mIHBhcmFtZXRlcnMpLg0KPiA+DQo+ID4gVGhlIGNhbGxlciBzaG91bGQgYWxz
byBwcm92aWRlIGEga2V5cmluZyBwb2ludGVyIG9idGFpbmVkIHdpdGgNCj4gPiBicGZfbG9va3Vw
X3VzZXJfa2V5KCkgb3IsIGFsdGVybmF0aXZlbHksIGEga2V5cmluZyBJRCB3aXRoIHZhbHVlcyBk
ZWZpbmVkDQo+ID4gaW4gdmVyaWZpY2F0aW9uLmguIFdoaWxlIHRoZSBmaXJzdCBjaG9pY2UgZ2l2
ZXMgdXNlcnMgbW9yZSBmbGV4aWJpbGl0eSwgdGhlDQo+ID4gc2Vjb25kIG9mZmVycyBiZXR0ZXIg
c2VjdXJpdHkgZ3VhcmFudGVlcywgYXMgdGhlIGtleXJpbmcgc2VsZWN0aW9uIHdpbGwgbm90DQo+
ID4gZGVwZW5kIG9uIHBvc3NpYmx5IHVudHJ1c3RlZCB1c2VyIHNwYWNlIGJ1dCBvbiB0aGUga2Vy
bmVsIGl0c2VsZi4NCj4gPg0KPiA+IERlZmluZWQga2V5cmluZyBJRHMgYXJlOiAwIGZvciB0aGUg
cHJpbWFyeSBrZXlyaW5nIChpbW11dGFibGUga2V5cmluZyBvZg0KPiA+IHN5c3RlbSBrZXlzKTsg
MSBmb3IgYm90aCB0aGUgcHJpbWFyeSBhbmQgc2Vjb25kYXJ5IGtleXJpbmcgKHdoZXJlIGtleXMg
Y2FuDQo+ID4gYmUgYWRkZWQgb25seSBpZiB0aGV5IGFyZSB2b3VjaGVkIGZvciBieSBleGlzdGlu
ZyBrZXlzIGluIHRob3NlIGtleXJpbmdzKTsNCj4gPiAyIGZvciB0aGUgcGxhdGZvcm0ga2V5cmlu
ZyAocHJpbWFyaWx5IHVzZWQgYnkgdGhlIGludGVncml0eSBzdWJzeXN0ZW0gdG8NCj4gPiB2ZXJp
ZnkgYSBrZXhlYydlZCBrZXJuZWQgaW1hZ2UgYW5kLCBwb3NzaWJseSwgdGhlIGluaXRyYW1mcyBz
aWduYXR1cmUpLg0KPiA+DQo+ID4gTm90ZTogc2luY2UgdGhlIGtleXJpbmcgSUQgYXNzaWdubWVu
dCBpcyB1bmRlcnN0b29kIG9ubHkgYnkNCj4gPiB2ZXJpZnlfcGtjczdfc2lnbmF0dXJlKCksIGl0
IG11c3QgYmUgcGFzc2VkIGRpcmVjdGx5IHRvIHRoZSBjb3JyZXNwb25kaW5nDQo+ID4gaGVscGVy
LCByYXRoZXIgdGhhbiB0byBhIHNlcGFyYXRlIG5ldyBoZWxwZXIgcmV0dXJuaW5nIGEgc3RydWN0
IGtleSBwb2ludGVyDQo+ID4gd2l0aCB0aGUga2V5cmluZyBJRCBhcyBhIHBvaW50ZXIgdmFsdWUu
IElmIHN1Y2ggcG9pbnRlciBpcyBwYXNzZWQgdG8gYW55DQo+ID4gb3RoZXIgaGVscGVyIHdoaWNo
IGRvZXMgbm90IGNoZWNrIGl0cyB2YWxpZGl0eSwgYW4gaWxsZWdhbCBtZW1vcnkgYWNjZXNzDQo+
ID4gY291bGQgb2NjdXIuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxy
b2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gUmVwb3J0ZWQtYnk6IGtlcm5lbCB0ZXN0IHJv
Ym90IDxsa3BAaW50ZWwuY29tPiAoY2FzdCB3YXJuaW5nKQ0KPiA+IC0tLQ0KPiA+ICBpbmNsdWRl
L3VhcGkvbGludXgvYnBmLmggICAgICAgfCAxNyArKysrKysrKysrKysrKysNCj4gPiAga2VybmVs
L2JwZi9icGZfbHNtLmMgICAgICAgICAgIHwgMzkgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKw0KPiA+ICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAxNyArKysrKysr
KysrKysrKysNCj4gPiAgMyBmaWxlcyBjaGFuZ2VkLCA3MyBpbnNlcnRpb25zKCspDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xp
bnV4L2JwZi5oDQo+ID4gaW5kZXggN2JiY2YyY2QxMDVkLi41MjRiZWQ0ZDcxNzAgMTAwNjQ0DQo+
ID4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2JwZi5oDQo+ID4gQEAgLTUzMzksNiArNTMzOSwyMiBAQCB1bmlvbiBicGZfYXR0ciB7
DQo+ID4gICAqCQlicGZfbG9va3VwX3VzZXJfa2V5KCkgaGVscGVyLg0KPiA+ICAgKglSZXR1cm4N
Cj4gPiAgICoJCTANCj4gPiArICoNCj4gPiArICogbG9uZyBicGZfdmVyaWZ5X3BrY3M3X3NpZ25h
dHVyZShzdHJ1Y3QgYnBmX2R5bnB0ciAqZGF0YV9wdHIsIHN0cnVjdA0KPiBicGZfZHlucHRyICpz
aWdfcHRyLCBzdHJ1Y3Qga2V5ICp0cnVzdGVkX2tleXMsIHVuc2lnbmVkIGxvbmcga2V5cmluZ19p
ZCkNCj4gPiArICoJRGVzY3JpcHRpb24NCj4gPiArICoJCVZlcmlmeSB0aGUgUEtDUyM3IHNpZ25h
dHVyZSAqc2lnKiBhZ2FpbnN0IHRoZSBzdXBwbGllZCAqZGF0YSoNCj4gPiArICoJCXdpdGgga2V5
cyBpbiAqdHJ1c3RlZF9rZXlzKiBvciBpbiBhIGtleXJpbmcgd2l0aCBJRA0KPiA+ICsgKgkJKmtl
eXJpbmdfaWQqLg0KPiANCj4gV291bGQgYmUgbmljZSB0byBnaXZlIHByZWNlZGVuY2UgaGVyZSBz
byB0aGF0IGl0cyBvYnZpb3VzIG9yZGVyIGJldHdlZW4NCj4gdHJ1c3RlZF9rZXlzIGFuZCBrZXly
aW5nX2lkLg0KDQpEaWQgeW91IG1lYW4gdG8gYWRkIGF0IHRoZSBlbmQgb2YgdGhlIHNlbnRlbmNl
Og0KDQpvciBpbiBhIGtleXJpbmcgd2l0aCBJRCAqa2V5cmluZ19pZCosIGlmICp0cnVzdGVkX2tl
eXMqIGlzIE5VTEwuDQoNClRoYW5rcw0KDQpSb2JlcnRvDQoNCkhVQVdFSSBURUNITk9MT0dJRVMg
RHVlc3NlbGRvcmYgR21iSCwgSFJCIDU2MDYzDQpNYW5hZ2luZyBEaXJlY3RvcjogTGkgUGVuZywg
WWFuZyBYaSwgTGkgSGUNCg0KPiA+ICsgKg0KPiA+ICsgKgkJKmtleXJpbmdfaWQqIGNhbiBoYXZl
IHRoZSBmb2xsb3dpbmcgdmFsdWVzIGRlZmluZWQgaW4NCj4gPiArICoJCXZlcmlmaWNhdGlvbi5o
OiAwIGZvciB0aGUgcHJpbWFyeSBrZXlyaW5nIChpbW11dGFibGUga2V5cmluZyBvZg0KPiA+ICsg
KgkJc3lzdGVtIGtleXMpOyAxIGZvciBib3RoIHRoZSBwcmltYXJ5IGFuZCBzZWNvbmRhcnkga2V5
cmluZw0KPiA+ICsgKgkJKHdoZXJlIGtleXMgY2FuIGJlIGFkZGVkIG9ubHkgaWYgdGhleSBhcmUg
dm91Y2hlZCBmb3IgYnkNCj4gPiArICoJCWV4aXN0aW5nIGtleXMgaW4gdGhvc2Uga2V5cmluZ3Mp
OyAyIGZvciB0aGUgcGxhdGZvcm0ga2V5cmluZw0KPiA+ICsgKgkJKHByaW1hcmlseSB1c2VkIGJ5
IHRoZSBpbnRlZ3JpdHkgc3Vic3lzdGVtIHRvIHZlcmlmeSBhIGtleGVjJ2VkDQo+ID4gKyAqCQlr
ZXJuZWQgaW1hZ2UgYW5kLCBwb3NzaWJseSwgdGhlIGluaXRyYW1mcyBzaWduYXR1cmUpLg0KPiA+
ICsgKglSZXR1cm4NCj4gPiArICoJCTAgb24gc3VjY2VzcywgYSBuZWdhdGl2ZSB2YWx1ZSBvbiBl
cnJvci4NCj4gPiAgICovDQo=
