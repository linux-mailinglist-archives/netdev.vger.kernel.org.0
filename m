Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9745754664E
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 14:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347649AbiFJMKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 08:10:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345027AbiFJMKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 08:10:11 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCA8E104;
        Fri, 10 Jun 2022 05:10:06 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LKKSN66TKz683mZ;
        Fri, 10 Jun 2022 20:06:28 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 10 Jun 2022 14:10:04 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Fri, 10 Jun 2022 14:10:04 +0200
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
Thread-Index: AQHYeykDmMQe6s5OOEy585q2owjOQ61GE2uAgACxe7CAAFEpAIABeTEA
Date:   Fri, 10 Jun 2022 12:10:04 +0000
Message-ID: <f09b219668ee45e087f47d87cf2962f1@huawei.com>
References: <20220608111221.373833-1-roberto.sassu@huawei.com>
 <20220608111221.373833-3-roberto.sassu@huawei.com>
 <CAADnVQJ4RCSAeDMqFpF5bQznPQaTWFr=kL7GdssDQuzLof06fg@mail.gmail.com>
 <92d8b9c08e20449782f19f64cc3ec5fa@huawei.com>
 <CAADnVQLd2d+_2iJ84u9zK3Nnb+LL3Gw7k=XQCVOHuekb2hLf_g@mail.gmail.com>
In-Reply-To: <CAADnVQLd2d+_2iJ84u9zK3Nnb+LL3Gw7k=XQCVOHuekb2hLf_g@mail.gmail.com>
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
aWwuY29tXQ0KPiBTZW50OiBUaHVyc2RheSwgSnVuZSA5LCAyMDIyIDU6MzggUE0NCj4gT24gVGh1
LCBKdW4gOSwgMjAyMiBhdCAyOjAwIEFNIFJvYmVydG8gU2Fzc3UgPHJvYmVydG8uc2Fzc3VAaHVh
d2VpLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiA+IEZyb206IEFsZXhlaSBTdGFyb3ZvaXRvdiBb
bWFpbHRvOmFsZXhlaS5zdGFyb3ZvaXRvdkBnbWFpbC5jb21dDQo+ID4gPiBTZW50OiBUaHVyc2Rh
eSwgSnVuZSA5LCAyMDIyIDI6MTMgQU0NCj4gPiA+IE9uIFdlZCwgSnVuIDgsIDIwMjIgYXQgNDox
NSBBTSBSb2JlcnRvIFNhc3N1DQo+IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4gPiB3
cm90ZToNCj4gPiA+ID4NCj4gPiA+ID4gQWNjb3JkaW5nIHRvIHRoZSBsb2dzIG9mIHRoZSBlQlBG
IENJLCBidWlsdCBrZXJuZWwgYW5kIHRlc3RzIGFyZSBjb3BpZWQgdG8NCj4gPiA+ID4gYSB2aXJ0
dWFsIG1hY2hpbmUgdG8gcnVuIHRoZXJlLg0KPiA+ID4gPg0KPiA+ID4gPiBTaW5jZSBhIHRlc3Qg
Zm9yIGEgbmV3IGhlbHBlciB0byB2ZXJpZnkgUEtDUyM3IHNpZ25hdHVyZXMgcmVxdWlyZXMgdG8g
c2lnbg0KPiA+ID4gPiBkYXRhIHRvIGJlIHZlcmlmaWVkLCBleHRlbmQgdGVzdF9wcm9ncyB0byBz
dG9yZSBpbiB0aGUgdGVzdF9lbnYgZGF0YQ0KPiA+ID4gPiBzdHJ1Y3R1cmUgKGFjY2Vzc2libGUg
YnkgaW5kaXZpZHVhbCB0ZXN0cykgdGhlIHBhdGggb2Ygc2lnbi1maWxlIGFuZCBvZiB0aGUNCj4g
PiA+ID4ga2VybmVsIHByaXZhdGUga2V5IGFuZCBjZXJ0Lg0KPiA+ID4gPg0KPiA+ID4gPiBTaWdu
ZWQtb2ZmLWJ5OiBSb2JlcnRvIFNhc3N1IDxyb2JlcnRvLnNhc3N1QGh1YXdlaS5jb20+DQo+ID4g
PiA+IC0tLQ0KPiA+ID4gPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfcHJvZ3Mu
YyB8IDEyICsrKysrKysrKysrKw0KPiA+ID4gPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBm
L3Rlc3RfcHJvZ3MuaCB8ICAzICsrKw0KPiA+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAxNSBpbnNl
cnRpb25zKCspDQo+ID4gPiA+DQo+ID4gPiA+IGRpZmYgLS1naXQgYS90b29scy90ZXN0aW5nL3Nl
bGZ0ZXN0cy9icGYvdGVzdF9wcm9ncy5jDQo+ID4gPiBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi90ZXN0X3Byb2dzLmMNCj4gPiA+ID4gaW5kZXggYzYzOWYyZTU2ZmM1Li45MGNlMmMwNmEx
NWUgMTAwNjQ0DQo+ID4gPiA+IC0tLSBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0
X3Byb2dzLmMNCj4gPiA+ID4gKysrIGIvdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rf
cHJvZ3MuYw0KPiA+ID4gPiBAQCAtNzA3LDYgKzcwNyw4IEBAIGVudW0gQVJHX0tFWVMgew0KPiA+
ID4gPiAgICAgICAgIEFSR19URVNUX05BTUVfR0xPQl9ERU5ZTElTVCA9ICdkJywNCj4gPiA+ID4g
ICAgICAgICBBUkdfTlVNX1dPUktFUlMgPSAnaicsDQo+ID4gPiA+ICAgICAgICAgQVJHX0RFQlVH
ID0gLTEsDQo+ID4gPiA+ICsgICAgICAgQVJHX1NJR05fRklMRSA9ICdTJywNCj4gPiA+ID4gKyAg
ICAgICBBUkdfS0VSTkVMX1BSSVZfQ0VSVCA9ICdDJywNCj4gPiA+ID4gIH07DQo+ID4gPiA+DQo+
ID4gPiA+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGFyZ3Bfb3B0aW9uIG9wdHNbXSA9IHsNCj4gPiA+
ID4gQEAgLTczMiw2ICs3MzQsMTAgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBhcmdwX29wdGlvbiBv
cHRzW10gPSB7DQo+ID4gPiA+ICAgICAgICAgICAiTnVtYmVyIG9mIHdvcmtlcnMgdG8gcnVuIGlu
IHBhcmFsbGVsLCBkZWZhdWx0IHRvIG51bWJlciBvZiBjcHVzLiIgfSwNCj4gPiA+ID4gICAgICAg
ICB7ICJkZWJ1ZyIsIEFSR19ERUJVRywgTlVMTCwgMCwNCj4gPiA+ID4gICAgICAgICAgICJwcmlu
dCBleHRyYSBkZWJ1ZyBpbmZvcm1hdGlvbiBmb3IgdGVzdF9wcm9ncy4iIH0sDQo+ID4gPiA+ICsg
ICAgICAgeyAic2lnbi1maWxlIiwgQVJHX1NJR05fRklMRSwgIlBBVEgiLCAwLA0KPiA+ID4gPiAr
ICAgICAgICAgInNpZ24tZmlsZSBwYXRoICIgfSwNCj4gPiA+ID4gKyAgICAgICB7ICJrZXJuZWwt
cHJpdi1jZXJ0IiwgQVJHX0tFUk5FTF9QUklWX0NFUlQsICJQQVRIIiwgMCwNCj4gPiA+ID4gKyAg
ICAgICAgICJrZXJuZWwgcHJpdmF0ZSBrZXkgYW5kIGNlcnQgcGF0aCAiIH0sDQo+ID4gPiA+ICAg
ICAgICAge30sDQo+ID4gPiA+ICB9Ow0KPiA+ID4gPg0KPiA+ID4gPiBAQCAtODYyLDYgKzg2OCwx
MiBAQCBzdGF0aWMgZXJyb3JfdCBwYXJzZV9hcmcoaW50IGtleSwgY2hhciAqYXJnLCBzdHJ1Y3QN
Cj4gPiA+IGFyZ3Bfc3RhdGUgKnN0YXRlKQ0KPiA+ID4gPiAgICAgICAgIGNhc2UgQVJHX0RFQlVH
Og0KPiA+ID4gPiAgICAgICAgICAgICAgICAgZW52LT5kZWJ1ZyA9IHRydWU7DQo+ID4gPiA+ICAg
ICAgICAgICAgICAgICBicmVhazsNCj4gPiA+ID4gKyAgICAgICBjYXNlIEFSR19TSUdOX0ZJTEU6
DQo+ID4gPiA+ICsgICAgICAgICAgICAgICBlbnYtPnNpZ25fZmlsZV9wYXRoID0gYXJnOw0KPiA+
ID4gPiArICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gPiA+ICsgICAgICAgY2FzZSBBUkdfS0VS
TkVMX1BSSVZfQ0VSVDoNCj4gPiA+ID4gKyAgICAgICAgICAgICAgIGVudi0+a2VybmVsX3ByaXZf
Y2VydF9wYXRoID0gYXJnOw0KPiA+ID4gPiArICAgICAgICAgICAgICAgYnJlYWs7DQo+ID4gPg0K
PiA+ID4gVGhhdCdzIGN1bWJlcnNvbWUgYXBwcm9hY2ggdG8gdXNlIHRvIGZvcmNlIENJIGFuZA0K
PiA+ID4gdXNlcnMgdG8gcGFzcyB0aGVzZSBhcmdzIG9uIGNvbW1hbmQgbGluZS4NCj4gPiA+IFRo
ZSB0ZXN0IGhhcyB0byBiZSBzZWxmIGNvbnRhaW5lZC4NCj4gPiA+IHRlc3RfcHJvZ3Mgc2hvdWxk
IGV4ZWN1dGUgaXQgd2l0aG91dCBhbnkgYWRkaXRpb25hbCBpbnB1dC4NCj4gPiA+IEZvciBleGFt
cGxlIGJ5IGhhdmluZyB0ZXN0LW9ubHkgcHJpdmF0ZS9wdWJsaWMga2V5DQo+ID4gPiB0aGF0IGlz
IHVzZWQgdG8gc2lnbiBhbmQgdmVyaWZ5IHRoZSBzaWduYXR1cmUuDQo+ID4NCj4gPiBJIHRob3Vn
aHQgYSBiaXQgYWJvdXQgdGhpcy4gSnVzdCBnZW5lcmF0aW5nIGEgdGVzdCBrZXkgZG9lcyBub3Qg
d29yaywNCj4gPiBhcyBpdCBtdXN0IGJlIHNpZ25lZCBieSB0aGUga2VybmVsIHNpZ25pbmcga2V5
IChvdGhlcndpc2UsIGxvYWRpbmcNCj4gPiBpbiB0aGUgc2Vjb25kYXJ5IGtleXJpbmcgd2lsbCBi
ZSByZWplY3RlZCkuIEhhdmluZyB0aGUgdGVzdCBrZXkgYXJvdW5kDQo+ID4gaXMgYXMgZGFuZ2Vy
b3VzIGFzIGhhdmluZyB0aGUga2VybmVsIHNpZ25pbmcga2V5IGFyb3VuZCBjb3BpZWQNCj4gPiBz
b21ld2hlcmUuDQo+ID4NCj4gPiBBbGxvd2luZyB1c2VycyB0byBzcGVjaWZ5IGEgdGVzdCBrZXly
aW5nIGluIHRoZSBoZWxwZXIgaXMgcG9zc2libGUuDQo+IA0KPiBXZSBzaG91bGRuJ3QgbmVlZCB0
byBsb2FkIGludG8gdGhlIHNlY29uZGFyeSBrZXlyaW5nLg0KPiBUaGUgaGVscGVyIG5lZWRzIHRv
IHN1cHBvcnQgYW4gYXJiaXRyYXJ5IGtleSByaW5nLg0KPiBUaGUga2VybmVsIHNob3VsZG4ndCBp
bnRlcmZlcmUgd2l0aCBsb2FkaW5nIHRoYXQgdGVzdCBrZXkgaW50bw0KPiBhIHRlc3QgcmluZy4N
Cj4gDQo+ID4gQnV0IGl0IHdvdWxkIGludHJvZHVjZSB1bm5lY2Vzc2FyeSBjb2RlLCBwbHVzIHRo
ZSBrZXlyaW5nIGlkZW50aWZpZXINCj4gDQo+IFdoYXQga2luZCBvZiAndW5uZWNlc3NhcnkgY29k
ZScgPw0KDQpUaGUgY29kZSBmb3IgaGFuZGxpbmcgZUJQRi1zcGVjaWZpYyBrZXlyaW5nIGlkZW50
aWZpZXJzLg0KDQpCdXQgYXQgdGhlIGVuZCwgaXQgaXMgbm90IHRoYXQgbXVjaC4NCg0KUm9iZXJ0
bw0KDQpIVUFXRUkgVEVDSE5PTE9HSUVTIER1ZXNzZWxkb3JmIEdtYkgsIEhSQiA1NjA2Mw0KTWFu
YWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFlhbmcgWGksIExpIEhlDQoNCj4gPiB3aWxsIGJlIHVu
ZGVyc3Rvb2QgYnkgZUJQRiBvbmx5IGFuZCBub3QgYnkgdmVyaWZ5X3BrY3M3X3NpZ25hdHVyZSgp
LA0KPiA+IGFzIGl0IGhhcHBlbnMgZm9yIG90aGVyIGtleXJpbmcgaWRlbnRpZmllcnMuDQo+IA0K
PiBNYXliZSB3cmFwcGluZyB2ZXJpZnlfcGtjczdfc2lnbmF0dXJlIGFzIGEgaGVscGVyIGlzIHRv
byBoaWdoIGxldmVsPw0KPiANCj4gPiBXZSBtYXkgaGF2ZSBlbnZpcm9ubWVudCB2YXJpYWJsZXMg
ZGlyZWN0bHkgaW4gdGhlIGVCUEYgdGVzdCwgdG8NCj4gPiBzcGVjaWZ5IHRoZSBsb2NhdGlvbiBv
ZiB0aGUgc2lnbmluZyBrZXksIGJ1dCB0aGVyZSBpcyBhIHJpc2sgb2YNCj4gPiBkdXBsaWNhdGlv
biwgYXMgb3RoZXIgdGVzdHMgd2FudGluZyB0aGUgc2FtZSBpbmZvcm1hdGlvbiBtaWdodA0KPiA+
IG5vdCBiZSBhd2FyZSBvZiB0aGVtLg0KPiANCj4gVGhhdCdzIG5vIGdvLg0KPiANCj4gPiBJIHdv
dWxkIG5vdCBpbnRyb2R1Y2UgYW55IGNvZGUgdGhhdCBoYW5kbGVzIHRoZSBrZXJuZWwgc2lnbmlu
Zw0KPiA+IGtleSAoaW4gdGhlIE1ha2VmaWxlLCBvciBpbiBhIHNlcGFyYXRlIHNjcmlwdCkuIFRo
aXMgaW5mb3JtYXRpb24gaXMNCj4gPiBzbyBzZW5zaWJsZSwgdGhhdCBpdCBtdXN0IGJlIHJlc3Bv
bnNpYmlsaXR5IG9mIGFuIGV4dGVybmFsIHBhcnR5DQo+ID4gdG8gZG8gdGhlIHdvcmsgb2YgbWFr
aW5nIHRoYXQga2V5IGF2YWlsYWJsZSBhbmQgdGVsbCB3aGVyZSBpdCBpcy4NCj4gPg0KPiA+IFJv
YmVydG8NCj4gPg0KPiA+IEhVQVdFSSBURUNITk9MT0dJRVMgRHVlc3NlbGRvcmYgR21iSCwgSFJC
IDU2MDYzDQo+ID4gTWFuYWdpbmcgRGlyZWN0b3I6IExpIFBlbmcsIFlhbmcgWGksIExpIEhlDQo=
