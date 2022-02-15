Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43FC4B75D2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:48:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240020AbiBORFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 12:05:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbiBORFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 12:05:12 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4382D11AA1F;
        Tue, 15 Feb 2022 09:04:59 -0800 (PST)
Received: from fraeml708-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JynQl6ZBqz67KsG;
        Wed, 16 Feb 2022 01:00:31 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml708-chm.china.huawei.com (10.206.15.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 15 Feb 2022 18:04:56 +0100
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2308.021;
 Tue, 15 Feb 2022 18:04:56 +0100
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Yonghong Song <yhs@fb.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>
CC:     "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 3/6] bpf-lsm: Introduce new helper bpf_ima_file_hash()
Thread-Topic: [PATCH v2 3/6] bpf-lsm: Introduce new helper bpf_ima_file_hash()
Thread-Index: AQHYImlh7GCSPCaH8Uastxbf0OJz26yUxh4AgAARGHA=
Date:   Tue, 15 Feb 2022 17:04:56 +0000
Message-ID: <b896e06f871645a6a2fb9a6f6cf4a8ff@huawei.com>
References: <20220215124042.186506-1-roberto.sassu@huawei.com>
 <20220215124042.186506-4-roberto.sassu@huawei.com>
 <f939bd53-96d0-d1dc-306f-6215ade6a7f1@fb.com>
In-Reply-To: <f939bd53-96d0-d1dc-306f-6215ade6a7f1@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.33]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBZb25naG9uZyBTb25nIFttYWlsdG86eWhzQGZiLmNvbV0NCj4gU2VudDogVHVlc2Rh
eSwgRmVicnVhcnkgMTUsIDIwMjIgNjowMyBQTQ0KPiBPbiAyLzE1LzIyIDQ6NDAgQU0sIFJvYmVy
dG8gU2Fzc3Ugd3JvdGU6DQo+ID4gaW1hX2ZpbGVfaGFzaCgpIGhhcyBiZWVuIG1vZGlmaWVkIHRv
IGNhbGN1bGF0ZSB0aGUgbWVhc3VyZW1lbnQgb2YgYSBmaWxlIG9uDQo+ID4gZGVtYW5kLCBpZiBp
dCBoYXMgbm90IGJlZW4gYWxyZWFkeSBwZXJmb3JtZWQgYnkgSU1BLiBGb3IgY29tcGF0aWJpbGl0
eQ0KPiA+IHJlYXNvbnMsIGltYV9pbm9kZV9oYXNoKCkgcmVtYWlucyB1bmNoYW5nZWQuDQo+ID4N
Cj4gPiBLZWVwIHRoZSBzYW1lIGFwcHJvYWNoIGluIGVCUEYgYW5kIGludHJvZHVjZSB0aGUgbmV3
IGhlbHBlcg0KPiA+IGJwZl9pbWFfZmlsZV9oYXNoKCkgdG8gdGFrZSBhZHZhbnRhZ2Ugb2YgdGhl
IG1vZGlmaWVkIGJlaGF2aW9yIG9mDQo+ID4gaW1hX2ZpbGVfaGFzaCgpLg0KPiA+DQo+ID4gU2ln
bmVkLW9mZi1ieTogUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29tPg0KPiA+
IC0tLQ0KPiA+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAgIHwgMTEgKysrKysrKysr
KysNCj4gPiAgIGtlcm5lbC9icGYvYnBmX2xzbS5jICAgICAgICAgICB8IDIwICsrKysrKysrKysr
KysrKysrKysrDQo+ID4gICB0b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggfCAxMSArKysr
KysrKysrKw0KPiA+ICAgMyBmaWxlcyBjaGFuZ2VkLCA0MiBpbnNlcnRpb25zKCspDQo+ID4NCj4g
PiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvaW5jbHVkZS91YXBpL2xp
bnV4L2JwZi5oDQo+ID4gaW5kZXggYjAzODNkMzcxYjlhLi5iYTMzZDU3MThkNmIgMTAwNjQ0DQo+
ID4gLS0tIGEvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oDQo+ID4gKysrIGIvaW5jbHVkZS91YXBp
L2xpbnV4L2JwZi5oDQo+ID4gQEAgLTQ2NDgsNiArNDY0OCwxNiBAQCB1bmlvbiBicGZfYXR0ciB7
DQo+ID4gICAgKgkJKiotRU9QTk9UU1VQKiogaWYgSU1BIGlzIGRpc2FibGVkIG9yICoqLUVJTlZB
TCoqIGlmDQo+ID4gICAgKgkJaW52YWxpZCBhcmd1bWVudHMgYXJlIHBhc3NlZC4NCj4gPiAgICAq
DQo+ID4gKyAqIGxvbmcgYnBmX2ltYV9maWxlX2hhc2goc3RydWN0IGZpbGUgKmZpbGUsIHZvaWQg
KmRzdCwgdTMyIHNpemUpDQo+ID4gKyAqCURlc2NyaXB0aW9uDQo+ID4gKyAqCQlSZXR1cm5zIGEg
Y2FsY3VsYXRlZCBJTUEgaGFzaCBvZiB0aGUgKmZpbGUqLg0KPiA+ICsgKgkJSWYgdGhlIGhhc2gg
aXMgbGFyZ2VyIHRoYW4gKnNpemUqLCB0aGVuIG9ubHkgKnNpemUqDQo+ID4gKyAqCQlieXRlcyB3
aWxsIGJlIGNvcGllZCB0byAqZHN0Kg0KPiA+ICsgKglSZXR1cm4NCj4gPiArICoJCVRoZSAqKmhh
c2hfYWxnbyoqIGlzIHJldHVybmVkIG9uIHN1Y2Nlc3MsDQo+ID4gKyAqCQkqKi1FT1BOT1RTVVAq
KiBpZiB0aGUgaGFzaCBjYWxjdWxhdGlvbiBmYWlsZWQgb3IgKiotRUlOVkFMKioNCj4gaWYNCj4g
PiArICoJCWludmFsaWQgYXJndW1lbnRzIGFyZSBwYXNzZWQuDQo+ID4gKyAqDQo+ID4gICAgKiBz
dHJ1Y3Qgc29ja2V0ICpicGZfc29ja19mcm9tX2ZpbGUoc3RydWN0IGZpbGUgKmZpbGUpDQo+ID4g
ICAgKglEZXNjcmlwdGlvbg0KPiA+ICAgICoJCUlmIHRoZSBnaXZlbiBmaWxlIHJlcHJlc2VudHMg
YSBzb2NrZXQsIHJldHVybnMgdGhlIGFzc29jaWF0ZWQNCj4gPiBAQCAtNTE4Miw2ICs1MTkyLDcg
QEAgdW5pb24gYnBmX2F0dHIgew0KPiA+ICAgCUZOKGJwcm1fb3B0c19zZXQpLAkJXA0KPiA+ICAg
CUZOKGt0aW1lX2dldF9jb2Fyc2VfbnMpLAlcDQo+ID4gICAJRk4oaW1hX2lub2RlX2hhc2gpLAkJ
XA0KPiA+ICsJRk4oaW1hX2ZpbGVfaGFzaCksCQlcDQo+IA0KPiBQbGVhc2UgcHV0IHRoZSBhYm92
ZSBGTihpbWFfZmlsZV9oYXNoKSB0byB0aGUgZW5kIG9mIHRoZSBsaXN0Lg0KPiBPdGhlcndpc2Us
IHdlIGhhdmUgYSBiYWNrd2FyZCBjb21wYXRhYmlsaXR5IGlzc3VlLg0KDQpIaSBZb25naG9uZw0K
DQpzdXJlLCB3aWxsIGRvLg0KDQpUaGFua3MNCg0KUm9iZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9H
SUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mw0KTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBl
bmcsIFpob25nIFJvbmdodWENCg0KPiA+ICAgCUZOKHNvY2tfZnJvbV9maWxlKSwJCVwNCj4gPiAg
IAlGTihjaGVja19tdHUpLAkJCVwNCj4gPiAgIAlGTihmb3JfZWFjaF9tYXBfZWxlbSksCQlcDQo+
ID4gZGlmZiAtLWdpdCBhL2tlcm5lbC9icGYvYnBmX2xzbS5jIGIva2VybmVsL2JwZi9icGZfbHNt
LmMNCj4gPiBpbmRleCA5ZTRlY2M5OTA2NDcuLmU4ZDI3YWY1YmJjYyAxMDA2NDQNCj4gPiAtLS0g
YS9rZXJuZWwvYnBmL2JwZl9sc20uYw0KPiA+ICsrKyBiL2tlcm5lbC9icGYvYnBmX2xzbS5jDQo+
IFsuLi5dDQo=
