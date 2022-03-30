Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDC844EC7ED
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 17:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348017AbiC3POs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 11:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346432AbiC3POo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 11:14:44 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEEDA10663B;
        Wed, 30 Mar 2022 08:12:58 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KT8z54Vvqz67yhs;
        Wed, 30 Mar 2022 23:11:29 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 30 Mar 2022 17:12:57 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 30 Mar 2022 17:12:57 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
CC:     Jonathan Corbet <corbet@lwn.net>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, "Shuah Khan" <shuah@kernel.org>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        "Linux Doc Mailing List" <linux-doc@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 05/18] bpf-preload: Generate static variables
Thread-Topic: [PATCH 05/18] bpf-preload: Generate static variables
Thread-Index: AQHYQsyWLcVpB05sakWRWVPVfsSzdqzW6LQAgACiZ4CAAH9p4A==
Date:   Wed, 30 Mar 2022 15:12:57 +0000
Message-ID: <af5e27aeef544581804b578032fc1b4e@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220328175033.2437312-6-roberto.sassu@huawei.com>
 <CAEf4BzY9d0pUP2TFkOY41dbjyYrsr5S+sNCpynPtg_9XZHFb-Q@mail.gmail.com> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.211.106]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBSb2JlcnRvIFNhc3N1DQo+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggMzAsIDIwMjIg
OTo0NSBBTQ0KPiA+IEZyb206IEFuZHJpaSBOYWtyeWlrbyBbbWFpbHRvOmFuZHJpaS5uYWtyeWlr
b0BnbWFpbC5jb21dDQo+ID4gU2VudDogV2VkbmVzZGF5LCBNYXJjaCAzMCwgMjAyMiAxOjUyIEFN
DQo+ID4gT24gTW9uLCBNYXIgMjgsIDIwMjIgYXQgMTA6NTIgQU0gUm9iZXJ0byBTYXNzdQ0KPiA+
IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+IHdyb3RlOg0KPiA+ID4NCj4gPiA+IFRoZSBmaXJz
dCBwYXJ0IG9mIHRoZSBwcmVsb2FkIGNvZGUgZ2VuZXJhdGlvbiBjb25zaXN0cyBpbiBnZW5lcmF0
aW5nIHRoZQ0KPiA+ID4gc3RhdGljIHZhcmlhYmxlcyB0byBiZSB1c2VkIGJ5IHRoZSBjb2RlIGl0
c2VsZjogdGhlIGxpbmtzIGFuZCBtYXBzIHRvIGJlDQo+ID4gPiBwaW5uZWQsIGFuZCB0aGUgc2tl
bGV0b24uIEdlbmVyYXRpb24gb2YgdGhlIHByZWxvYWQgdmFyaWFibGVzIGFuZA0KPiA+IG1ldGhv
ZHMNCj4gPiA+IGlzIGVuYWJsZWQgd2l0aCB0aGUgb3B0aW9uIC1QIGFkZGVkIHRvICdicGZ0b29s
IGdlbiBza2VsZXRvbicuDQo+ID4gPg0KPiA+ID4gVGhlIGV4aXN0aW5nIHZhcmlhYmxlcyBtYXBz
X2xpbmsgYW5kIHByb2dzX2xpbmtzIGluIGJwZl9wcmVsb2FkX2tlcm4uYw0KPiA+IGhhdmUNCj4g
PiA+IGJlZW4gcmVuYW1lZCByZXNwZWN0aXZlbHkgdG8gZHVtcF9icGZfbWFwX2xpbmsgYW5kDQo+
ID4gZHVtcF9icGZfcHJvZ19saW5rLCB0bw0KPiA+ID4gbWF0Y2ggdGhlIG5hbWUgb2YgdGhlIHZh
cmlhYmxlcyBpbiB0aGUgbWFpbiBzdHJ1Y3R1cmUgb2YgdGhlIGxpZ2h0DQo+ID4gPiBza2VsZXRv
bi4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNh
c3N1QGh1YXdlaS5jb20+DQo+ID4gPiAtLS0NCj4gPiA+ICBrZXJuZWwvYnBmL3ByZWxvYWQvYnBm
X3ByZWxvYWRfa2Vybi5jICAgICAgICAgfCAgMzUgKy0NCj4gPiA+ICBrZXJuZWwvYnBmL3ByZWxv
YWQvaXRlcmF0b3JzL01ha2VmaWxlICAgICAgICAgfCAgIDIgKy0NCj4gPiA+ICAuLi4vYnBmL3By
ZWxvYWQvaXRlcmF0b3JzL2l0ZXJhdG9ycy5sc2tlbC5oICAgfCAzNzggKysrKysrKysrLS0tLS0t
LS0tDQo+ID4gPiAgLi4uL2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1nZW4ucnN0
IHwgICA1ICsNCj4gPiA+ICB0b29scy9icGYvYnBmdG9vbC9iYXNoLWNvbXBsZXRpb24vYnBmdG9v
bCAgICAgfCAgIDIgKy0NCj4gPiA+ICB0b29scy9icGYvYnBmdG9vbC9nZW4uYyAgICAgICAgICAg
ICAgICAgICAgICAgfCAgMjcgKysNCj4gPiA+ICB0b29scy9icGYvYnBmdG9vbC9tYWluLmMgICAg
ICAgICAgICAgICAgICAgICAgfCAgIDcgKy0NCj4gPiA+ICB0b29scy9icGYvYnBmdG9vbC9tYWlu
LmggICAgICAgICAgICAgICAgICAgICAgfCAgIDEgKw0KPiA+ID4gIDggZmlsZXMgY2hhbmdlZCwg
MjU0IGluc2VydGlvbnMoKyksIDIwMyBkZWxldGlvbnMoLSkNCj4gPiA+DQo+ID4NCj4gPiBbLi4u
XQ0KPiA+DQo+ID4gPiArX19hdHRyaWJ1dGVfXygodW51c2VkKSkgc3RhdGljIHZvaWQNCj4gPiA+
ICtpdGVyYXRvcnNfYnBmX19hc3NlcnQoc3RydWN0IGl0ZXJhdG9yc19icGYgKnMpDQo+ID4gPiAr
ew0KPiA+ID4gKyNpZmRlZiBfX2NwbHVzcGx1cw0KPiA+ID4gKyNkZWZpbmUgX1N0YXRpY19hc3Nl
cnQgc3RhdGljX2Fzc2VydA0KPiA+ID4gKyNlbmRpZg0KPiA+ID4gKyNpZmRlZiBfX2NwbHVzcGx1
cw0KPiA+ID4gKyN1bmRlZiBfU3RhdGljX2Fzc2VydA0KPiA+ID4gKyNlbmRpZg0KPiA+ID4gK30N
Cj4gPiA+ICsNCj4gPiA+ICtzdGF0aWMgc3RydWN0IGJwZl9saW5rICpkdW1wX2JwZl9tYXBfbGlu
azsNCj4gPiA+ICtzdGF0aWMgc3RydWN0IGJwZl9saW5rICpkdW1wX2JwZl9wcm9nX2xpbms7DQo+
ID4gPiArc3RhdGljIHN0cnVjdCBpdGVyYXRvcnNfYnBmICpza2VsOw0KPiA+DQo+ID4gSSBkb24n
dCB1bmRlcnN0YW5kIHdoYXQgaXMgdGhpcyBhbmQgd2hhdCBmb3I/IFlvdSBhcmUgbWFraW5nIGFu
DQo+ID4gYXNzdW1wdGlvbiB0aGF0IGxpZ2h0IHNrZWxldG9uIGNhbiBiZSBpbnN0YW50aWF0ZWQg
anVzdCBvbmNlLCB3aHk/IEFuZA0KPiA+IGFkZGluZyBleHRyYSBicGZ0b29sIG9wdGlvbiB0byBs
aWdodCBza2VsZXRvbiBjb2RlZ2VuIGp1c3QgdG8gc2F2ZSBhDQo+ID4gYml0IG9mIHR5cGluZyBh
dCB0aGUgcGxhY2Ugd2hlcmUgbGlnaHQgc2tlbGV0b24gaXMgYWN0dWFsbHkNCj4gPiBpbnN0YW50
aWF0ZWQgYW5kIHVzZWQgZG9lc24ndCBzZWVtcyBsaWtlIGEgcmlnaHQgYXBwcm9hY2guDQo+IA0K
PiBUcnVlLCBpdGVyYXRvcl9icGYgaXMgc2ltcGxlLiBXcml0aW5nIHRoZSBwcmVsb2FkaW5nIGNv
ZGUNCj4gZm9yIGl0IGlzIHNpbXBsZS4gQnV0LCB3aGF0IGlmIHlvdSB3YW50ZWQgdG8gcHJlbG9h
ZCBhbiBMU00NCj4gd2l0aCAxMCBob29rcyBvciBtb3JlPw0KPiANCj4gT2ssIHJlZ2FyZGluZyB3
aGVyZSB0aGUgcHJlbG9hZGluZyBjb2RlIHNob3VsZCBiZSwgSSB3aWxsDQo+IHRyeSB0byBtb3Zl
IHRoZSBnZW5lcmF0ZWQgY29kZSB0byB0aGUga2VybmVsIG1vZHVsZSBpbnN0ZWFkDQo+IG9mIHRo
ZSBsaWdodCBza2VsZXRvbi4NCg0KRG9uZS4gSSBtb3ZlZCBldmVyeXRoaW5nIGZyb20gdGhlIGxp
Z2h0IHNrZWxldG9uIHRvIHRoZSBrZXJuZWwNCm1vZHVsZS4gVGhlIGNoYW5nZXMgbm93IGFyZSBh
bHNvIHdlbGwgc2VwYXJhdGVkLCBhbmQNCnJlZ2VuZXJhdGlvbiBvZiB0aGUga2VybmVsIG1vZHVs
ZSBvY2N1cnMgb25seSBhZnRlciBhbGwgdGhlDQpnZW5lcmF0aW9uIGNvZGUgaXMgYWRkZWQgdG8g
YnBmdG9vbC4NCg0KSSBwdXNoZWQgYSBuZXcgYnJhbmNoOg0KDQpodHRwczovL2dpdGh1Yi5jb20v
cm9iZXJ0b3Nhc3N1L2xpbnV4L2NvbW1pdHMvYnBmLXByZWxvYWQtdjItZGV2ZWwtdjINCg0KUm9i
ZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mw0K
TWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFpob25nIFJvbmdodWENCg==
