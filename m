Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6B664EBC09
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 09:44:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243956AbiC3Hqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Mar 2022 03:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234304AbiC3Hqb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Mar 2022 03:46:31 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA6D7E62;
        Wed, 30 Mar 2022 00:44:45 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4KSz1R04W5z67gYW;
        Wed, 30 Mar 2022 15:42:51 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 30 Mar 2022 09:44:43 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Wed, 30 Mar 2022 09:44:43 +0200
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
Thread-Index: AQHYQsyWLcVpB05sakWRWVPVfsSzdqzW6LQAgACiZ4A=
Date:   Wed, 30 Mar 2022 07:44:43 +0000
Message-ID: <4621def6171f4ca5948a59a7e714d25f@huawei.com>
References: <20220328175033.2437312-1-roberto.sassu@huawei.com>
 <20220328175033.2437312-6-roberto.sassu@huawei.com>
 <CAEf4BzY9d0pUP2TFkOY41dbjyYrsr5S+sNCpynPtg_9XZHFb-Q@mail.gmail.com>
In-Reply-To: <CAEf4BzY9d0pUP2TFkOY41dbjyYrsr5S+sNCpynPtg_9XZHFb-Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.81.209.190]
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

PiBGcm9tOiBBbmRyaWkgTmFrcnlpa28gW21haWx0bzphbmRyaWkubmFrcnlpa29AZ21haWwuY29t
XQ0KPiBTZW50OiBXZWRuZXNkYXksIE1hcmNoIDMwLCAyMDIyIDE6NTIgQU0NCj4gT24gTW9uLCBN
YXIgMjgsIDIwMjIgYXQgMTA6NTIgQU0gUm9iZXJ0byBTYXNzdQ0KPiA8cm9iZXJ0by5zYXNzdUBo
dWF3ZWkuY29tPiB3cm90ZToNCj4gPg0KPiA+IFRoZSBmaXJzdCBwYXJ0IG9mIHRoZSBwcmVsb2Fk
IGNvZGUgZ2VuZXJhdGlvbiBjb25zaXN0cyBpbiBnZW5lcmF0aW5nIHRoZQ0KPiA+IHN0YXRpYyB2
YXJpYWJsZXMgdG8gYmUgdXNlZCBieSB0aGUgY29kZSBpdHNlbGY6IHRoZSBsaW5rcyBhbmQgbWFw
cyB0byBiZQ0KPiA+IHBpbm5lZCwgYW5kIHRoZSBza2VsZXRvbi4gR2VuZXJhdGlvbiBvZiB0aGUg
cHJlbG9hZCB2YXJpYWJsZXMgYW5kDQo+IG1ldGhvZHMNCj4gPiBpcyBlbmFibGVkIHdpdGggdGhl
IG9wdGlvbiAtUCBhZGRlZCB0byAnYnBmdG9vbCBnZW4gc2tlbGV0b24nLg0KPiA+DQo+ID4gVGhl
IGV4aXN0aW5nIHZhcmlhYmxlcyBtYXBzX2xpbmsgYW5kIHByb2dzX2xpbmtzIGluIGJwZl9wcmVs
b2FkX2tlcm4uYw0KPiBoYXZlDQo+ID4gYmVlbiByZW5hbWVkIHJlc3BlY3RpdmVseSB0byBkdW1w
X2JwZl9tYXBfbGluayBhbmQNCj4gZHVtcF9icGZfcHJvZ19saW5rLCB0bw0KPiA+IG1hdGNoIHRo
ZSBuYW1lIG9mIHRoZSB2YXJpYWJsZXMgaW4gdGhlIG1haW4gc3RydWN0dXJlIG9mIHRoZSBsaWdo
dA0KPiA+IHNrZWxldG9uLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogUm9iZXJ0byBTYXNzdSA8
cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICBrZXJuZWwvYnBmL3ByZWxv
YWQvYnBmX3ByZWxvYWRfa2Vybi5jICAgICAgICAgfCAgMzUgKy0NCj4gPiAga2VybmVsL2JwZi9w
cmVsb2FkL2l0ZXJhdG9ycy9NYWtlZmlsZSAgICAgICAgIHwgICAyICstDQo+ID4gIC4uLi9icGYv
cHJlbG9hZC9pdGVyYXRvcnMvaXRlcmF0b3JzLmxza2VsLmggICB8IDM3OCArKysrKysrKystLS0t
LS0tLS0NCj4gPiAgLi4uL2JwZi9icGZ0b29sL0RvY3VtZW50YXRpb24vYnBmdG9vbC1nZW4ucnN0
IHwgICA1ICsNCj4gPiAgdG9vbHMvYnBmL2JwZnRvb2wvYmFzaC1jb21wbGV0aW9uL2JwZnRvb2wg
ICAgIHwgICAyICstDQo+ID4gIHRvb2xzL2JwZi9icGZ0b29sL2dlbi5jICAgICAgICAgICAgICAg
ICAgICAgICB8ICAyNyArKw0KPiA+ICB0b29scy9icGYvYnBmdG9vbC9tYWluLmMgICAgICAgICAg
ICAgICAgICAgICAgfCAgIDcgKy0NCj4gPiAgdG9vbHMvYnBmL2JwZnRvb2wvbWFpbi5oICAgICAg
ICAgICAgICAgICAgICAgIHwgICAxICsNCj4gPiAgOCBmaWxlcyBjaGFuZ2VkLCAyNTQgaW5zZXJ0
aW9ucygrKSwgMjAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+IA0KPiBbLi4uXQ0KPiANCj4gPiArX19h
dHRyaWJ1dGVfXygodW51c2VkKSkgc3RhdGljIHZvaWQNCj4gPiAraXRlcmF0b3JzX2JwZl9fYXNz
ZXJ0KHN0cnVjdCBpdGVyYXRvcnNfYnBmICpzKQ0KPiA+ICt7DQo+ID4gKyNpZmRlZiBfX2NwbHVz
cGx1cw0KPiA+ICsjZGVmaW5lIF9TdGF0aWNfYXNzZXJ0IHN0YXRpY19hc3NlcnQNCj4gPiArI2Vu
ZGlmDQo+ID4gKyNpZmRlZiBfX2NwbHVzcGx1cw0KPiA+ICsjdW5kZWYgX1N0YXRpY19hc3NlcnQN
Cj4gPiArI2VuZGlmDQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBzdHJ1Y3QgYnBmX2xpbmsg
KmR1bXBfYnBmX21hcF9saW5rOw0KPiA+ICtzdGF0aWMgc3RydWN0IGJwZl9saW5rICpkdW1wX2Jw
Zl9wcm9nX2xpbms7DQo+ID4gK3N0YXRpYyBzdHJ1Y3QgaXRlcmF0b3JzX2JwZiAqc2tlbDsNCj4g
DQo+IEkgZG9uJ3QgdW5kZXJzdGFuZCB3aGF0IGlzIHRoaXMgYW5kIHdoYXQgZm9yPyBZb3UgYXJl
IG1ha2luZyBhbg0KPiBhc3N1bXB0aW9uIHRoYXQgbGlnaHQgc2tlbGV0b24gY2FuIGJlIGluc3Rh
bnRpYXRlZCBqdXN0IG9uY2UsIHdoeT8gQW5kDQo+IGFkZGluZyBleHRyYSBicGZ0b29sIG9wdGlv
biB0byBsaWdodCBza2VsZXRvbiBjb2RlZ2VuIGp1c3QgdG8gc2F2ZSBhDQo+IGJpdCBvZiB0eXBp
bmcgYXQgdGhlIHBsYWNlIHdoZXJlIGxpZ2h0IHNrZWxldG9uIGlzIGFjdHVhbGx5DQo+IGluc3Rh
bnRpYXRlZCBhbmQgdXNlZCBkb2Vzbid0IHNlZW1zIGxpa2UgYSByaWdodCBhcHByb2FjaC4NCg0K
VHJ1ZSwgaXRlcmF0b3JfYnBmIGlzIHNpbXBsZS4gV3JpdGluZyB0aGUgcHJlbG9hZGluZyBjb2Rl
DQpmb3IgaXQgaXMgc2ltcGxlLiBCdXQsIHdoYXQgaWYgeW91IHdhbnRlZCB0byBwcmVsb2FkIGFu
IExTTQ0Kd2l0aCAxMCBob29rcyBvciBtb3JlPw0KDQpPaywgcmVnYXJkaW5nIHdoZXJlIHRoZSBw
cmVsb2FkaW5nIGNvZGUgc2hvdWxkIGJlLCBJIHdpbGwNCnRyeSB0byBtb3ZlIHRoZSBnZW5lcmF0
ZWQgY29kZSB0byB0aGUga2VybmVsIG1vZHVsZSBpbnN0ZWFkDQpvZiB0aGUgbGlnaHQgc2tlbGV0
b24uDQoNClRoYW5rcw0KDQpSb2JlcnRvDQoNCkhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRv
cmYgR21iSCwgSFJCIDU2MDYzDQpNYW5hZ2luZyBEaXJlY3RvcjogTGkgUGVuZywgWmhvbmcgUm9u
Z2h1YQ0KDQo+IEZ1cnRoZXIsIGV2ZW4gaWYgdGhpcyBpcyB0aGUgd2F5IHRvIGdvLCBwbGVhc2Ug
c3BsaXQgb3V0IGJwZnRvb2wNCj4gY2hhbmdlcyBmcm9tIGtlcm5lbCBjaGFuZ2VzLiBUaGVyZSBp
cyBub3RoaW5nIHJlcXVpcmluZyB0aGVtIHRvIGJlDQo+IGNvdXBsZWQgdG9nZXRoZXIuDQo+IA0K
PiBbLi4uXQ0K
