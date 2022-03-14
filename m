Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AA3A4D7EC8
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 10:38:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236786AbiCNJjm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 05:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236656AbiCNJjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 05:39:39 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CDF1ADAF;
        Mon, 14 Mar 2022 02:38:27 -0700 (PDT)
Received: from dggpeml500020.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4KHBDV14hSz1GCRS;
        Mon, 14 Mar 2022 17:33:30 +0800 (CST)
Received: from dggpeml100026.china.huawei.com (7.185.36.103) by
 dggpeml500020.china.huawei.com (7.185.36.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 17:38:25 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml100026.china.huawei.com (7.185.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Mar 2022 17:38:25 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.021;
 Mon, 14 Mar 2022 17:38:25 +0800
From:   "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
To:     Jason Wang <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "sgarzare@redhat.com" <sgarzare@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>
CC:     "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Gonglei (Arei)" <arei.gonglei@huawei.com>,
        Yechuan <yechuan@huawei.com>,
        Huangzhichao <huangzhichao@huawei.com>,
        "gdawar@xilinx.com" <gdawar@xilinx.com>
Subject: RE: [PATCH v2 2/2] vdpa: support exposing the count of vqs to
 userspace
Thread-Topic: [PATCH v2 2/2] vdpa: support exposing the count of vqs to
 userspace
Thread-Index: AQHYNE9ilXZ4q7gcNEGAUh/4m44ES6y949sAgADB2WA=
Date:   Mon, 14 Mar 2022 09:38:25 +0000
Message-ID: <44f3932d183f4e9a8a77bc1f8e0340b5@huawei.com>
References: <20220310072051.2175-1-longpeng2@huawei.com>
 <20220310072051.2175-3-longpeng2@huawei.com>
 <7f7553d0-2217-6122-227a-a3bfd5706ac5@redhat.com>
In-Reply-To: <7f7553d0-2217-6122-227a-a3bfd5706ac5@redhat.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.148.223]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24gV2FuZyBbbWFp
bHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+IFNlbnQ6IE1vbmRheSwgTWFyY2ggMTQsIDIwMjIg
MjowNCBQTQ0KPiBUbzogTG9uZ3BlbmcgKE1pa2UsIENsb3VkIEluZnJhc3RydWN0dXJlIFNlcnZp
Y2UgUHJvZHVjdCBEZXB0LikNCj4gPGxvbmdwZW5nMkBodWF3ZWkuY29tPjsgbXN0QHJlZGhhdC5j
b207IHNnYXJ6YXJlQHJlZGhhdC5jb207DQo+IHN0ZWZhbmhhQHJlZGhhdC5jb20NCj4gQ2M6IHZp
cnR1YWxpemF0aW9uQGxpc3RzLmxpbnV4LWZvdW5kYXRpb24ub3JnOyBrdm1Admdlci5rZXJuZWwu
b3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOyBHb25nbGVpIChBcmVpKQ0KPiA8YXJlaS5nb25nbGVpQGh1YXdlaS5jb20+OyBZZWNodWFu
IDx5ZWNodWFuQGh1YXdlaS5jb20+OyBIdWFuZ3poaWNoYW8NCj4gPGh1YW5nemhpY2hhb0BodWF3
ZWkuY29tPjsgZ2Rhd2FyQHhpbGlueC5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiAyLzJd
IHZkcGE6IHN1cHBvcnQgZXhwb3NpbmcgdGhlIGNvdW50IG9mIHZxcyB0byB1c2Vyc3BhY2UNCj4g
DQo+IA0KPiDlnKggMjAyMi8zLzEwIOS4i+WNiDM6MjAsIExvbmdwZW5nKE1pa2UpIOWGmemBkzoN
Cj4gPiBGcm9tOiBMb25ncGVuZyA8bG9uZ3BlbmcyQGh1YXdlaS5jb20+DQo+ID4NCj4gPiAtIEdF
VF9WUVNfQ09VTlQ6IHRoZSBjb3VudCBvZiB2aXJ0cXVldWVzIHRoYXQgZXhwb3NlZA0KPiA+DQo+
ID4gQW5kIGNoYW5nZSB2ZHBhX2RldmljZS5udnFzIGFuZCB2aG9zdF92ZHBhLm52cXMgdG8gdXNl
IHUzMi4NCj4gDQo+IA0KPiBQYXRjaCBsb29rcyBnb29kLCBhIG5pdCBpcyB0aGF0IHdlJ2QgYmV0
dGVyIHVzZSBhIHNlcGFyYXRlIHBhdGNoIGZvciB0aGUNCj4gdTMyIGNvbnZlcnRpbmcuDQo+IA0K
DQpPSywgd2lsbCBkbyBpbiB2MywgdGhhbmtzLg0KDQo+IFRoYW5rcw0KPiANCj4gDQo+ID4NCj4g
PiBTaWduZWQtb2ZmLWJ5OiBMb25ncGVuZyA8bG9uZ3BlbmcyQGh1YXdlaS5jb20+DQo+ID4gLS0t
DQo+ID4gICBkcml2ZXJzL3ZkcGEvdmRwYS5jICAgICAgICB8ICA2ICsrKy0tLQ0KPiA+ICAgZHJp
dmVycy92aG9zdC92ZHBhLmMgICAgICAgfCAyMyArKysrKysrKysrKysrKysrKysrLS0tLQ0KPiA+
ICAgaW5jbHVkZS9saW51eC92ZHBhLmggICAgICAgfCAgNiArKystLS0NCj4gPiAgIGluY2x1ZGUv
dWFwaS9saW51eC92aG9zdC5oIHwgIDMgKysrDQo+ID4gICA0IGZpbGVzIGNoYW5nZWQsIDI4IGlu
c2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvdmRwYS92ZHBhLmMgYi9kcml2ZXJzL3ZkcGEvdmRwYS5jDQo+ID4gaW5kZXggMWVhNTI1NC4u
MmI3NWMwMCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3ZkcGEvdmRwYS5jDQo+ID4gKysrIGIv
ZHJpdmVycy92ZHBhL3ZkcGEuYw0KPiA+IEBAIC0yMzIsNyArMjMyLDcgQEAgc3RhdGljIGludCB2
ZHBhX25hbWVfbWF0Y2goc3RydWN0IGRldmljZSAqZGV2LCBjb25zdCB2b2lkDQo+ICpkYXRhKQ0K
PiA+ICAgCXJldHVybiAoc3RyY21wKGRldl9uYW1lKCZ2ZGV2LT5kZXYpLCBkYXRhKSA9PSAwKTsN
Cj4gPiAgIH0NCj4gPg0KPiA+IC1zdGF0aWMgaW50IF9fdmRwYV9yZWdpc3Rlcl9kZXZpY2Uoc3Ry
dWN0IHZkcGFfZGV2aWNlICp2ZGV2LCBpbnQgbnZxcykNCj4gPiArc3RhdGljIGludCBfX3ZkcGFf
cmVnaXN0ZXJfZGV2aWNlKHN0cnVjdCB2ZHBhX2RldmljZSAqdmRldiwgdTMyIG52cXMpDQo+ID4g
ICB7DQo+ID4gICAJc3RydWN0IGRldmljZSAqZGV2Ow0KPiA+DQo+ID4gQEAgLTI1Nyw3ICsyNTcs
NyBAQCBzdGF0aWMgaW50IF9fdmRwYV9yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IHZkcGFfZGV2aWNl
ICp2ZGV2LA0KPiBpbnQgbnZxcykNCj4gPiAgICAqDQo+ID4gICAgKiBSZXR1cm46IFJldHVybnMg
YW4gZXJyb3Igd2hlbiBmYWlsIHRvIGFkZCBkZXZpY2UgdG8gdkRQQSBidXMNCj4gPiAgICAqLw0K
PiA+IC1pbnQgX3ZkcGFfcmVnaXN0ZXJfZGV2aWNlKHN0cnVjdCB2ZHBhX2RldmljZSAqdmRldiwg
aW50IG52cXMpDQo+ID4gK2ludCBfdmRwYV9yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IHZkcGFfZGV2
aWNlICp2ZGV2LCB1MzIgbnZxcykNCj4gPiAgIHsNCj4gPiAgIAlpZiAoIXZkZXYtPm1kZXYpDQo+
ID4gICAJCXJldHVybiAtRUlOVkFMOw0KPiA+IEBAIC0yNzQsNyArMjc0LDcgQEAgaW50IF92ZHBh
X3JlZ2lzdGVyX2RldmljZShzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkZXYsIGludA0KPiBudnFzKQ0K
PiA+ICAgICoNCj4gPiAgICAqIFJldHVybjogUmV0dXJucyBhbiBlcnJvciB3aGVuIGZhaWwgdG8g
YWRkIHRvIHZEUEEgYnVzDQo+ID4gICAgKi8NCj4gPiAtaW50IHZkcGFfcmVnaXN0ZXJfZGV2aWNl
KHN0cnVjdCB2ZHBhX2RldmljZSAqdmRldiwgaW50IG52cXMpDQo+ID4gK2ludCB2ZHBhX3JlZ2lz
dGVyX2RldmljZShzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkZXYsIHUzMiBudnFzKQ0KPiA+ICAgew0K
PiA+ICAgCWludCBlcnI7DQo+ID4NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy92aG9zdC92ZHBh
LmMgYi9kcml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+IGluZGV4IDYwNWM3YWUuLjY5YjNmMDUgMTAw
NjQ0DQo+ID4gLS0tIGEvZHJpdmVycy92aG9zdC92ZHBhLmMNCj4gPiArKysgYi9kcml2ZXJzL3Zo
b3N0L3ZkcGEuYw0KPiA+IEBAIC00Miw3ICs0Miw3IEBAIHN0cnVjdCB2aG9zdF92ZHBhIHsNCj4g
PiAgIAlzdHJ1Y3QgZGV2aWNlIGRldjsNCj4gPiAgIAlzdHJ1Y3QgY2RldiBjZGV2Ow0KPiA+ICAg
CWF0b21pY190IG9wZW5lZDsNCj4gPiAtCWludCBudnFzOw0KPiA+ICsJdTMyIG52cXM7DQo+ID4g
ICAJaW50IHZpcnRpb19pZDsNCj4gPiAgIAlpbnQgbWlub3I7DQo+ID4gICAJc3RydWN0IGV2ZW50
ZmRfY3R4ICpjb25maWdfY3R4Ow0KPiA+IEBAIC0xNTgsNyArMTU4LDggQEAgc3RhdGljIGxvbmcg
dmhvc3RfdmRwYV9zZXRfc3RhdHVzKHN0cnVjdCB2aG9zdF92ZHBhICp2LA0KPiB1OCBfX3VzZXIg
KnN0YXR1c3ApDQo+ID4gICAJc3RydWN0IHZkcGFfZGV2aWNlICp2ZHBhID0gdi0+dmRwYTsNCj4g
PiAgIAljb25zdCBzdHJ1Y3QgdmRwYV9jb25maWdfb3BzICpvcHMgPSB2ZHBhLT5jb25maWc7DQo+
ID4gICAJdTggc3RhdHVzLCBzdGF0dXNfb2xkOw0KPiA+IC0JaW50IHJldCwgbnZxcyA9IHYtPm52
cXM7DQo+ID4gKwl1MzIgbnZxcyA9IHYtPm52cXM7DQo+ID4gKwlpbnQgcmV0Ow0KPiA+ICAgCXUx
NiBpOw0KPiA+DQo+ID4gICAJaWYgKGNvcHlfZnJvbV91c2VyKCZzdGF0dXMsIHN0YXR1c3AsIHNp
emVvZihzdGF0dXMpKSkNCj4gPiBAQCAtMzY5LDYgKzM3MCwxNiBAQCBzdGF0aWMgbG9uZyB2aG9z
dF92ZHBhX2dldF9jb25maWdfc2l6ZShzdHJ1Y3Qgdmhvc3RfdmRwYQ0KPiAqdiwgdTMyIF9fdXNl
ciAqYXJncCkNCj4gPiAgIAlyZXR1cm4gMDsNCj4gPiAgIH0NCj4gPg0KPiA+ICtzdGF0aWMgbG9u
ZyB2aG9zdF92ZHBhX2dldF92cXNfY291bnQoc3RydWN0IHZob3N0X3ZkcGEgKnYsIHUzMiBfX3Vz
ZXIgKmFyZ3ApDQo+ID4gK3sNCj4gPiArCXN0cnVjdCB2ZHBhX2RldmljZSAqdmRwYSA9IHYtPnZk
cGE7DQo+ID4gKw0KPiA+ICsJaWYgKGNvcHlfdG9fdXNlcihhcmdwLCAmdmRwYS0+bnZxcywgc2l6
ZW9mKHZkcGEtPm52cXMpKSkNCj4gPiArCQlyZXR1cm4gLUVGQVVMVDsNCj4gPiArDQo+ID4gKwly
ZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gPiAgIHN0YXRpYyBsb25nIHZob3N0X3ZkcGFfdnJp
bmdfaW9jdGwoc3RydWN0IHZob3N0X3ZkcGEgKnYsIHVuc2lnbmVkIGludCBjbWQsDQo+ID4gICAJ
CQkJICAgdm9pZCBfX3VzZXIgKmFyZ3ApDQo+ID4gICB7DQo+ID4gQEAgLTUwOSw2ICs1MjAsOSBA
QCBzdGF0aWMgbG9uZyB2aG9zdF92ZHBhX3VubG9ja2VkX2lvY3RsKHN0cnVjdCBmaWxlICpmaWxl
cCwNCj4gPiAgIAljYXNlIFZIT1NUX1ZEUEFfR0VUX0NPTkZJR19TSVpFOg0KPiA+ICAgCQlyID0g
dmhvc3RfdmRwYV9nZXRfY29uZmlnX3NpemUodiwgYXJncCk7DQo+ID4gICAJCWJyZWFrOw0KPiA+
ICsJY2FzZSBWSE9TVF9WRFBBX0dFVF9WUVNfQ09VTlQ6DQo+ID4gKwkJciA9IHZob3N0X3ZkcGFf
Z2V0X3Zxc19jb3VudCh2LCBhcmdwKTsNCj4gPiArCQlicmVhazsNCj4gPiAgIAlkZWZhdWx0Og0K
PiA+ICAgCQlyID0gdmhvc3RfZGV2X2lvY3RsKCZ2LT52ZGV2LCBjbWQsIGFyZ3ApOw0KPiA+ICAg
CQlpZiAociA9PSAtRU5PSU9DVExDTUQpDQo+ID4gQEAgLTk2NSw3ICs5NzksOCBAQCBzdGF0aWMg
aW50IHZob3N0X3ZkcGFfb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QNCj4gZmlsZSAq
ZmlsZXApDQo+ID4gICAJc3RydWN0IHZob3N0X3ZkcGEgKnY7DQo+ID4gICAJc3RydWN0IHZob3N0
X2RldiAqZGV2Ow0KPiA+ICAgCXN0cnVjdCB2aG9zdF92aXJ0cXVldWUgKip2cXM7DQo+ID4gLQlp
bnQgbnZxcywgaSwgciwgb3BlbmVkOw0KPiA+ICsJaW50IHIsIG9wZW5lZDsNCj4gPiArCXUzMiBp
LCBudnFzOw0KPiA+DQo+ID4gICAJdiA9IGNvbnRhaW5lcl9vZihpbm9kZS0+aV9jZGV2LCBzdHJ1
Y3Qgdmhvc3RfdmRwYSwgY2Rldik7DQo+ID4NCj4gPiBAQCAtMTAxOCw3ICsxMDMzLDcgQEAgc3Rh
dGljIGludCB2aG9zdF92ZHBhX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0DQo+IGZp
bGUgKmZpbGVwKQ0KPiA+DQo+ID4gICBzdGF0aWMgdm9pZCB2aG9zdF92ZHBhX2NsZWFuX2lycShz
dHJ1Y3Qgdmhvc3RfdmRwYSAqdikNCj4gPiAgIHsNCj4gPiAtCWludCBpOw0KPiA+ICsJdTMyIGk7
DQo+ID4NCj4gPiAgIAlmb3IgKGkgPSAwOyBpIDwgdi0+bnZxczsgaSsrKQ0KPiA+ICAgCQl2aG9z
dF92ZHBhX3Vuc2V0dXBfdnFfaXJxKHYsIGkpOw0KPiA+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xp
bnV4L3ZkcGEuaCBiL2luY2x1ZGUvbGludXgvdmRwYS5oDQo+ID4gaW5kZXggYTUyNjkxOS4uODk0
M2EyMCAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL2xpbnV4L3ZkcGEuaA0KPiA+ICsrKyBiL2lu
Y2x1ZGUvbGludXgvdmRwYS5oDQo+ID4gQEAgLTgzLDcgKzgzLDcgQEAgc3RydWN0IHZkcGFfZGV2
aWNlIHsNCj4gPiAgIAl1bnNpZ25lZCBpbnQgaW5kZXg7DQo+ID4gICAJYm9vbCBmZWF0dXJlc192
YWxpZDsNCj4gPiAgIAlib29sIHVzZV92YTsNCj4gPiAtCWludCBudnFzOw0KPiA+ICsJdTMyIG52
cXM7DQo+ID4gICAJc3RydWN0IHZkcGFfbWdtdF9kZXYgKm1kZXY7DQo+ID4gICB9Ow0KPiA+DQo+
ID4gQEAgLTMzOCwxMCArMzM4LDEwIEBAIHN0cnVjdCB2ZHBhX2RldmljZSAqX192ZHBhX2FsbG9j
X2RldmljZShzdHJ1Y3QgZGV2aWNlDQo+ICpwYXJlbnQsDQo+ID4gICAJCQkJICAgICAgIGRldl9z
dHJ1Y3QsIG1lbWJlcikpLCBuYW1lLCB1c2VfdmEpLCBcDQo+ID4gICAJCQkJICAgICAgIGRldl9z
dHJ1Y3QsIG1lbWJlcikNCj4gPg0KPiA+IC1pbnQgdmRwYV9yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0
IHZkcGFfZGV2aWNlICp2ZGV2LCBpbnQgbnZxcyk7DQo+ID4gK2ludCB2ZHBhX3JlZ2lzdGVyX2Rl
dmljZShzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkZXYsIHUzMiBudnFzKTsNCj4gPiAgIHZvaWQgdmRw
YV91bnJlZ2lzdGVyX2RldmljZShzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkZXYpOw0KPiA+DQo+ID4g
LWludCBfdmRwYV9yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IHZkcGFfZGV2aWNlICp2ZGV2LCBpbnQg
bnZxcyk7DQo+ID4gK2ludCBfdmRwYV9yZWdpc3Rlcl9kZXZpY2Uoc3RydWN0IHZkcGFfZGV2aWNl
ICp2ZGV2LCB1MzIgbnZxcyk7DQo+ID4gICB2b2lkIF92ZHBhX3VucmVnaXN0ZXJfZGV2aWNlKHN0
cnVjdCB2ZHBhX2RldmljZSAqdmRldik7DQo+ID4NCj4gPiAgIC8qKg0KPiA+IGRpZmYgLS1naXQg
YS9pbmNsdWRlL3VhcGkvbGludXgvdmhvc3QuaCBiL2luY2x1ZGUvdWFwaS9saW51eC92aG9zdC5o
DQo+ID4gaW5kZXggYmM3NGU5NS4uNWQ5OWU3YyAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3Vh
cGkvbGludXgvdmhvc3QuaA0KPiA+ICsrKyBiL2luY2x1ZGUvdWFwaS9saW51eC92aG9zdC5oDQo+
ID4gQEAgLTE1NCw0ICsxNTQsNyBAQA0KPiA+ICAgLyogR2V0IHRoZSBjb25maWcgc2l6ZSAqLw0K
PiA+ICAgI2RlZmluZSBWSE9TVF9WRFBBX0dFVF9DT05GSUdfU0laRQlfSU9SKFZIT1NUX1ZJUlRJ
TywgMHg3OSwgX191MzIpDQo+ID4NCj4gPiArLyogR2V0IHRoZSBjb3VudCBvZiBhbGwgdmlydHF1
ZXVlcyAqLw0KPiA+ICsjZGVmaW5lIFZIT1NUX1ZEUEFfR0VUX1ZRU19DT1VOVAlfSU9SKFZIT1NU
X1ZJUlRJTywgMHg4MCwgX191MzIpDQo+ID4gKw0KPiA+ICAgI2VuZGlmDQoNCg==
