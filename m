Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02E65446D3
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 11:00:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241677AbiFIJAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 05:00:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbiFIJAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 05:00:14 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA47B4A9;
        Thu,  9 Jun 2022 02:00:12 -0700 (PDT)
Received: from fraeml707-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LJdHn0HnSz67M5Q;
        Thu,  9 Jun 2022 16:56:37 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml707-chm.china.huawei.com (10.206.15.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 9 Jun 2022 11:00:10 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Thu, 9 Jun 2022 11:00:10 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/3] selftests/bpf: Add test_progs opts for sign-file
 and kernel priv key + cert
Thread-Topic: [PATCH v2 2/3] selftests/bpf: Add test_progs opts for sign-file
 and kernel priv key + cert
Thread-Index: AQHYeykDmMQe6s5OOEy585q2owjOQ61GE2uAgACxe7A=
Date:   Thu, 9 Jun 2022 09:00:10 +0000
Message-ID: <92d8b9c08e20449782f19f64cc3ec5fa@huawei.com>
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
 <20220608111221.373833-3-roberto.sassu@huawei.com>
 <CAADnVQJ4RCSAeDMqFpF5bQznPQaTWFr=kL7GdssDQuzLof06fg@mail.gmail.com>
In-Reply-To: <CAADnVQJ4RCSAeDMqFpF5bQznPQaTWFr=kL7GdssDQuzLof06fg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.204.63.21]
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

PiBGcm9tOiBBbGV4ZWkgU3Rhcm92b2l0b3YgW21haWx0bzphbGV4ZWkuc3Rhcm92b2l0b3ZAZ21h
aWwuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgSnVuZSA5LCAyMDIyIDI6MTMgQU0NCj4gT24gV2Vk
LCBKdW4gOCwgMjAyMiBhdCA0OjE1IEFNIFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVh
d2VpLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBBY2NvcmRpbmcgdG8gdGhlIGxvZ3Mgb2YgdGhl
IGVCUEYgQ0ksIGJ1aWx0IGtlcm5lbCBhbmQgdGVzdHMgYXJlIGNvcGllZCB0bw0KPiA+IGEgdmly
dHVhbCBtYWNoaW5lIHRvIHJ1biB0aGVyZS4NCj4gPg0KPiA+IFNpbmNlIGEgdGVzdCBmb3IgYSBu
ZXcgaGVscGVyIHRvIHZlcmlmeSBQS0NTIzcgc2lnbmF0dXJlcyByZXF1aXJlcyB0byBzaWduDQo+
ID4gZGF0YSB0byBiZSB2ZXJpZmllZCwgZXh0ZW5kIHRlc3RfcHJvZ3MgdG8gc3RvcmUgaW4gdGhl
IHRlc3RfZW52IGRhdGENCj4gPiBzdHJ1Y3R1cmUgKGFjY2Vzc2libGUgYnkgaW5kaXZpZHVhbCB0
ZXN0cykgdGhlIHBhdGggb2Ygc2lnbi1maWxlIGFuZCBvZiB0aGUNCj4gPiBrZXJuZWwgcHJpdmF0
ZSBrZXkgYW5kIGNlcnQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxy
b2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gLS0tDQo+ID4gIHRvb2xzL3Rlc3Rpbmcvc2Vs
ZnRlc3RzL2JwZi90ZXN0X3Byb2dzLmMgfCAxMiArKysrKysrKysrKysNCj4gPiAgdG9vbHMvdGVz
dGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfcHJvZ3MuaCB8ICAzICsrKw0KPiA+ICAyIGZpbGVzIGNo
YW5nZWQsIDE1IGluc2VydGlvbnMoKykNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0
aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9ncy5jDQo+IGIvdG9vbHMvdGVzdGluZy9zZWxmdGVz
dHMvYnBmL3Rlc3RfcHJvZ3MuYw0KPiA+IGluZGV4IGM2MzlmMmU1NmZjNS4uOTBjZTJjMDZhMTVl
IDEwMDY0NA0KPiA+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3Byb2dz
LmMNCj4gPiArKysgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9ncy5jDQo+
ID4gQEAgLTcwNyw2ICs3MDcsOCBAQCBlbnVtIEFSR19LRVlTIHsNCj4gPiAgICAgICAgIEFSR19U
RVNUX05BTUVfR0xPQl9ERU5ZTElTVCA9ICdkJywNCj4gPiAgICAgICAgIEFSR19OVU1fV09SS0VS
UyA9ICdqJywNCj4gPiAgICAgICAgIEFSR19ERUJVRyA9IC0xLA0KPiA+ICsgICAgICAgQVJHX1NJ
R05fRklMRSA9ICdTJywNCj4gPiArICAgICAgIEFSR19LRVJORUxfUFJJVl9DRVJUID0gJ0MnLA0K
PiA+ICB9Ow0KPiA+DQo+ID4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYXJncF9vcHRpb24gb3B0c1td
ID0gew0KPiA+IEBAIC03MzIsNiArNzM0LDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgYXJncF9v
cHRpb24gb3B0c1tdID0gew0KPiA+ICAgICAgICAgICAiTnVtYmVyIG9mIHdvcmtlcnMgdG8gcnVu
IGluIHBhcmFsbGVsLCBkZWZhdWx0IHRvIG51bWJlciBvZiBjcHVzLiIgfSwNCj4gPiAgICAgICAg
IHsgImRlYnVnIiwgQVJHX0RFQlVHLCBOVUxMLCAwLA0KPiA+ICAgICAgICAgICAicHJpbnQgZXh0
cmEgZGVidWcgaW5mb3JtYXRpb24gZm9yIHRlc3RfcHJvZ3MuIiB9LA0KPiA+ICsgICAgICAgeyAi
c2lnbi1maWxlIiwgQVJHX1NJR05fRklMRSwgIlBBVEgiLCAwLA0KPiA+ICsgICAgICAgICAic2ln
bi1maWxlIHBhdGggIiB9LA0KPiA+ICsgICAgICAgeyAia2VybmVsLXByaXYtY2VydCIsIEFSR19L
RVJORUxfUFJJVl9DRVJULCAiUEFUSCIsIDAsDQo+ID4gKyAgICAgICAgICJrZXJuZWwgcHJpdmF0
ZSBrZXkgYW5kIGNlcnQgcGF0aCAiIH0sDQo+ID4gICAgICAgICB7fSwNCj4gPiAgfTsNCj4gPg0K
PiA+IEBAIC04NjIsNiArODY4LDEyIEBAIHN0YXRpYyBlcnJvcl90IHBhcnNlX2FyZyhpbnQga2V5
LCBjaGFyICphcmcsIHN0cnVjdA0KPiBhcmdwX3N0YXRlICpzdGF0ZSkNCj4gPiAgICAgICAgIGNh
c2UgQVJHX0RFQlVHOg0KPiA+ICAgICAgICAgICAgICAgICBlbnYtPmRlYnVnID0gdHJ1ZTsNCj4g
PiAgICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gKyAgICAgICBjYXNlIEFSR19TSUdOX0ZJTEU6
DQo+ID4gKyAgICAgICAgICAgICAgIGVudi0+c2lnbl9maWxlX3BhdGggPSBhcmc7DQo+ID4gKyAg
ICAgICAgICAgICAgIGJyZWFrOw0KPiA+ICsgICAgICAgY2FzZSBBUkdfS0VSTkVMX1BSSVZfQ0VS
VDoNCj4gPiArICAgICAgICAgICAgICAgZW52LT5rZXJuZWxfcHJpdl9jZXJ0X3BhdGggPSBhcmc7
DQo+ID4gKyAgICAgICAgICAgICAgIGJyZWFrOw0KPiANCj4gVGhhdCdzIGN1bWJlcnNvbWUgYXBw
cm9hY2ggdG8gdXNlIHRvIGZvcmNlIENJIGFuZA0KPiB1c2VycyB0byBwYXNzIHRoZXNlIGFyZ3Mg
b24gY29tbWFuZCBsaW5lLg0KPiBUaGUgdGVzdCBoYXMgdG8gYmUgc2VsZiBjb250YWluZWQuDQo+
IHRlc3RfcHJvZ3Mgc2hvdWxkIGV4ZWN1dGUgaXQgd2l0aG91dCBhbnkgYWRkaXRpb25hbCBpbnB1
dC4NCj4gRm9yIGV4YW1wbGUgYnkgaGF2aW5nIHRlc3Qtb25seSBwcml2YXRlL3B1YmxpYyBrZXkN
Cj4gdGhhdCBpcyB1c2VkIHRvIHNpZ24gYW5kIHZlcmlmeSB0aGUgc2lnbmF0dXJlLg0KDQpJIHRo
b3VnaHQgYSBiaXQgYWJvdXQgdGhpcy4gSnVzdCBnZW5lcmF0aW5nIGEgdGVzdCBrZXkgZG9lcyBu
b3Qgd29yaywNCmFzIGl0IG11c3QgYmUgc2lnbmVkIGJ5IHRoZSBrZXJuZWwgc2lnbmluZyBrZXkg
KG90aGVyd2lzZSwgbG9hZGluZw0KaW4gdGhlIHNlY29uZGFyeSBrZXlyaW5nIHdpbGwgYmUgcmVq
ZWN0ZWQpLiBIYXZpbmcgdGhlIHRlc3Qga2V5IGFyb3VuZA0KaXMgYXMgZGFuZ2Vyb3VzIGFzIGhh
dmluZyB0aGUga2VybmVsIHNpZ25pbmcga2V5IGFyb3VuZCBjb3BpZWQNCnNvbWV3aGVyZS4NCg0K
QWxsb3dpbmcgdXNlcnMgdG8gc3BlY2lmeSBhIHRlc3Qga2V5cmluZyBpbiB0aGUgaGVscGVyIGlz
IHBvc3NpYmxlLg0KQnV0IGl0IHdvdWxkIGludHJvZHVjZSB1bm5lY2Vzc2FyeSBjb2RlLCBwbHVz
IHRoZSBrZXlyaW5nIGlkZW50aWZpZXINCndpbGwgYmUgdW5kZXJzdG9vZCBieSBlQlBGIG9ubHkg
YW5kIG5vdCBieSB2ZXJpZnlfcGtjczdfc2lnbmF0dXJlKCksDQphcyBpdCBoYXBwZW5zIGZvciBv
dGhlciBrZXlyaW5nIGlkZW50aWZpZXJzLg0KDQpXZSBtYXkgaGF2ZSBlbnZpcm9ubWVudCB2YXJp
YWJsZXMgZGlyZWN0bHkgaW4gdGhlIGVCUEYgdGVzdCwgdG8NCnNwZWNpZnkgdGhlIGxvY2F0aW9u
IG9mIHRoZSBzaWduaW5nIGtleSwgYnV0IHRoZXJlIGlzIGEgcmlzayBvZg0KZHVwbGljYXRpb24s
IGFzIG90aGVyIHRlc3RzIHdhbnRpbmcgdGhlIHNhbWUgaW5mb3JtYXRpb24gbWlnaHQNCm5vdCBi
ZSBhd2FyZSBvZiB0aGVtLg0KDQpJIHdvdWxkIG5vdCBpbnRyb2R1Y2UgYW55IGNvZGUgdGhhdCBo
YW5kbGVzIHRoZSBrZXJuZWwgc2lnbmluZw0Ka2V5IChpbiB0aGUgTWFrZWZpbGUsIG9yIGluIGEg
c2VwYXJhdGUgc2NyaXB0KS4gVGhpcyBpbmZvcm1hdGlvbiBpcw0Kc28gc2Vuc2libGUsIHRoYXQg
aXQgbXVzdCBiZSByZXNwb25zaWJpbGl0eSBvZiBhbiBleHRlcm5hbCBwYXJ0eQ0KdG8gZG8gdGhl
IHdvcmsgb2YgbWFraW5nIHRoYXQga2V5IGF2YWlsYWJsZSBhbmQgdGVsbCB3aGVyZSBpdCBpcy4N
Cg0KUm9iZXJ0bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1
NjA2Mw0KTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFlhbmcgWGksIExpIEhlDQo=
