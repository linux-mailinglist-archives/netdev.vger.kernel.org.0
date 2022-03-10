Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C67224D3F93
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 04:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239169AbiCJDRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 22:17:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238404AbiCJDRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 22:17:13 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09D213CD3;
        Wed,  9 Mar 2022 19:16:12 -0800 (PST)
Received: from dggpeml500023.china.huawei.com (unknown [172.30.72.55])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KDZ1M6RllzdZnM;
        Thu, 10 Mar 2022 11:14:47 +0800 (CST)
Received: from dggpeml100025.china.huawei.com (7.185.36.37) by
 dggpeml500023.china.huawei.com (7.185.36.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 11:16:10 +0800
Received: from dggpeml100016.china.huawei.com (7.185.36.216) by
 dggpeml100025.china.huawei.com (7.185.36.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 10 Mar 2022 11:16:10 +0800
Received: from dggpeml100016.china.huawei.com ([7.185.36.216]) by
 dggpeml100016.china.huawei.com ([7.185.36.216]) with mapi id 15.01.2308.021;
 Thu, 10 Mar 2022 11:16:10 +0800
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
        Huangzhichao <huangzhichao@huawei.com>
Subject: RE: [RFC 2/3] vdpa: support exposing the count of vqs to userspace
Thread-Topic: [RFC 2/3] vdpa: support exposing the count of vqs to userspace
Thread-Index: AQHYC4S7IoB0Irjpnk2WF3yFNTfs4qxnk/AAgFCtsGA=
Date:   Thu, 10 Mar 2022 03:16:10 +0000
Message-ID: <4e1870fed35f487b8cc2a5d112e7c41b@huawei.com>
References: <20220117092921.1573-1-longpeng2@huawei.com>
 <20220117092921.1573-3-longpeng2@huawei.com>
 <1a26d7b3-1020-50c5-f0a3-ebc645cdcddf@redhat.com>
In-Reply-To: <1a26d7b3-1020-50c5-f0a3-ebc645cdcddf@redhat.com>
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

SGkgSmFzb24sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFzb24g
V2FuZyBbbWFpbHRvOmphc293YW5nQHJlZGhhdC5jb21dDQo+IFNlbnQ6IFR1ZXNkYXksIEphbnVh
cnkgMTgsIDIwMjIgMTE6MDggQU0NCj4gVG86IExvbmdwZW5nIChNaWtlLCBDbG91ZCBJbmZyYXN0
cnVjdHVyZSBTZXJ2aWNlIFByb2R1Y3QgRGVwdC4pDQo+IDxsb25ncGVuZzJAaHVhd2VpLmNvbT47
IG1zdEByZWRoYXQuY29tOyBzZ2FyemFyZUByZWRoYXQuY29tOw0KPiBzdGVmYW5oYUByZWRoYXQu
Y29tDQo+IENjOiB2aXJ0dWFsaXphdGlvbkBsaXN0cy5saW51eC1mb3VuZGF0aW9uLm9yZzsga3Zt
QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgR29uZ2xlaSAoQXJlaSkNCj4gPGFyZWkuZ29uZ2xlaUBodWF3ZWku
Y29tPjsgWWVjaHVhbiA8eWVjaHVhbkBodWF3ZWkuY29tPjsgSHVhbmd6aGljaGFvDQo+IDxodWFu
Z3poaWNoYW9AaHVhd2VpLmNvbT4NCj4gU3ViamVjdDogUmU6IFtSRkMgMi8zXSB2ZHBhOiBzdXBw
b3J0IGV4cG9zaW5nIHRoZSBjb3VudCBvZiB2cXMgdG8gdXNlcnNwYWNlDQo+IA0KPiANCj4g5Zyo
IDIwMjIvMS8xNyDkuIvljYg1OjI5LCBMb25ncGVuZyhNaWtlKSDlhpnpgZM6DQo+ID4gRnJvbTog
TG9uZ3BlbmcgPGxvbmdwZW5nMkBodWF3ZWkuY29tPg0KPiA+DQo+ID4gLSBHRVRfVlFTX0NPVU5U
OiB0aGUgY291bnQgb2YgdmlydHF1ZXVlcyB0aGF0IGV4cG9zZWQNCj4gPg0KPiA+IFNpZ25lZC1v
ZmYtYnk6IExvbmdwZW5nIDxsb25ncGVuZzJAaHVhd2VpLmNvbT4NCj4gPiAtLS0NCj4gPiAgIGRy
aXZlcnMvdmhvc3QvdmRwYS5jICAgICAgIHwgMTMgKysrKysrKysrKysrKw0KPiA+ICAgaW5jbHVk
ZS91YXBpL2xpbnV4L3Zob3N0LmggfCAgMyArKysNCj4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTYg
aW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvdmhvc3QvdmRwYS5j
IGIvZHJpdmVycy92aG9zdC92ZHBhLmMNCj4gPiBpbmRleCAxZWVhMTRhNGVhNTYuLmMxMDc0Mjc4
ZmM2YiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL3Zob3N0L3ZkcGEuYw0KPiA+ICsrKyBiL2Ry
aXZlcnMvdmhvc3QvdmRwYS5jDQo+ID4gQEAgLTM2OSw2ICszNjksMTYgQEAgc3RhdGljIGxvbmcg
dmhvc3RfdmRwYV9nZXRfY29uZmlnX3NpemUoc3RydWN0IHZob3N0X3ZkcGENCj4gKnYsIHUzMiBf
X3VzZXIgKmFyZ3ApDQo+ID4gICAJcmV0dXJuIDA7DQo+ID4gICB9DQo+ID4NCj4gPiArc3RhdGlj
IGxvbmcgdmhvc3RfdmRwYV9nZXRfdnFzX2NvdW50KHN0cnVjdCB2aG9zdF92ZHBhICp2LCB1MzIg
X191c2VyICphcmdwKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgdmRwYV9kZXZpY2UgKnZkcGEgPSB2
LT52ZHBhOw0KPiANCj4gDQo+IFdoaWxlIGF0IGl0LCBJIHRoaW5rIGl0J3MgYmV0dGVyIHRvIGNo
YW5nZSB2ZHBhLT5udnFzIHRvIHVzZSB1MzI/DQo+IA0KDQpzdHJ1Y3Qgdmhvc3RfdmRwYSB7DQog
ICAgLi4uDQoJaW50IG52cXM7DQogICAgLi4uDQp9Ow0KDQpzdHJ1Y3QgdmRwYV9kZXZpY2Ugew0K
ICAgIC4uLg0KCWludCBudnFzOw0KICAgIC4uLg0KfTsNCg0KSSB0aGluayB3ZSBzaG91bGQgY2hh
bmdlIGJvdGggdG8gdTMyPw0KDQoNCj4gVGhhbmtzDQo+IA0KPiANCj4gPiArDQo+ID4gKwlpZiAo
Y29weV90b191c2VyKGFyZ3AsICZ2ZHBhLT5udnFzLCBzaXplb2YodmRwYS0+bnZxcykpKQ0KPiA+
ICsJCXJldHVybiAtRUZBVUxUOw0KPiA+ICsNCj4gPiArCXJldHVybiAwOw0KPiA+ICt9DQo+ID4g
Kw0KPiA+ICAgc3RhdGljIGxvbmcgdmhvc3RfdmRwYV92cmluZ19pb2N0bChzdHJ1Y3Qgdmhvc3Rf
dmRwYSAqdiwgdW5zaWduZWQgaW50IGNtZCwNCj4gPiAgIAkJCQkgICB2b2lkIF9fdXNlciAqYXJn
cCkNCj4gPiAgIHsNCj4gPiBAQCAtNTA5LDYgKzUxOSw5IEBAIHN0YXRpYyBsb25nIHZob3N0X3Zk
cGFfdW5sb2NrZWRfaW9jdGwoc3RydWN0IGZpbGUgKmZpbGVwLA0KPiA+ICAgCWNhc2UgVkhPU1Rf
VkRQQV9HRVRfQ09ORklHX1NJWkU6DQo+ID4gICAJCXIgPSB2aG9zdF92ZHBhX2dldF9jb25maWdf
c2l6ZSh2LCBhcmdwKTsNCj4gPiAgIAkJYnJlYWs7DQo+ID4gKwljYXNlIFZIT1NUX1ZEUEFfR0VU
X1ZRU19DT1VOVDoNCj4gPiArCQlyID0gdmhvc3RfdmRwYV9nZXRfdnFzX2NvdW50KHYsIGFyZ3Ap
Ow0KPiA+ICsJCWJyZWFrOw0KPiA+ICAgCWRlZmF1bHQ6DQo+ID4gICAJCXIgPSB2aG9zdF9kZXZf
aW9jdGwoJnYtPnZkZXYsIGNtZCwgYXJncCk7DQo+ID4gICAJCWlmIChyID09IC1FTk9JT0NUTENN
RCkNCj4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS91YXBpL2xpbnV4L3Zob3N0LmggYi9pbmNsdWRl
L3VhcGkvbGludXgvdmhvc3QuaA0KPiA+IGluZGV4IGJjNzRlOTVhMjczYS4uNWQ5OWU3YzI0MmEy
IDEwMDY0NA0KPiA+IC0tLSBhL2luY2x1ZGUvdWFwaS9saW51eC92aG9zdC5oDQo+ID4gKysrIGIv
aW5jbHVkZS91YXBpL2xpbnV4L3Zob3N0LmgNCj4gPiBAQCAtMTU0LDQgKzE1NCw3IEBADQo+ID4g
ICAvKiBHZXQgdGhlIGNvbmZpZyBzaXplICovDQo+ID4gICAjZGVmaW5lIFZIT1NUX1ZEUEFfR0VU
X0NPTkZJR19TSVpFCV9JT1IoVkhPU1RfVklSVElPLCAweDc5LCBfX3UzMikNCj4gPg0KPiA+ICsv
KiBHZXQgdGhlIGNvdW50IG9mIGFsbCB2aXJ0cXVldWVzICovDQo+ID4gKyNkZWZpbmUgVkhPU1Rf
VkRQQV9HRVRfVlFTX0NPVU5UCV9JT1IoVkhPU1RfVklSVElPLCAweDgwLCBfX3UzMikNCj4gPiAr
DQo+ID4gICAjZW5kaWYNCg0K
