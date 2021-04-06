Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7AF9354EC2
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 10:36:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244387AbhDFIgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 04:36:55 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2762 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234953AbhDFIgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 04:36:53 -0400
Received: from fraeml706-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FF13007C3z687ZC;
        Tue,  6 Apr 2021 16:31:40 +0800 (CST)
Received: from lhreml707-chm.china.huawei.com (10.201.108.56) by
 fraeml706-chm.china.huawei.com (10.206.15.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 6 Apr 2021 10:36:44 +0200
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 lhreml707-chm.china.huawei.com (10.201.108.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Tue, 6 Apr 2021 09:36:43 +0100
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.2106.013;
 Tue, 6 Apr 2021 09:36:43 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [Linuxarm]  Re: [PATCH net] net: hns3: Limiting the scope of
 vector_ring_chain variable
Thread-Topic: [Linuxarm]  Re: [PATCH net] net: hns3: Limiting the scope of
 vector_ring_chain variable
Thread-Index: AQHXKkE/K8at3CzCL0GXC2nZ4TjLkKqma5uAgAC7QdA=
Date:   Tue, 6 Apr 2021 08:36:43 +0000
Message-ID: <50c5a2d96e174e76afa4eada669c7b26@huawei.com>
References: <20210405172825.28380-1-salil.mehta@huawei.com>
 <161766060973.24414.1256394756703505340.git-patchwork-notify@kernel.org>
In-Reply-To: <161766060973.24414.1256394756703505340.git-patchwork-notify@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.71.1]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgRGF2ZSwNCkhvcGUgSSBhbSBub3QgbWlzc2luZyBzb21ldGhpbmcgYW5kIG5vdCBzdXJlIGhv
dyB0aGlzIHBhdGNod29yayBib3Qgd29ya3MsDQp0aGUgcGF0Y2ggd2FzIHNlbnQgZm9yIC1uZXQg
cmVwbyAoaS5lLiBidWcgZml4ZXMgYnJhbmNoKSBidXQgaXQgZ290IGFwcGxpZWQNCnRvIHRoZSAt
bmV0LW5leHQgcmVwby4NCg0KPiBTdWJqZWN0OiBbTGludXhhcm1dIFJlOiBbUEFUQ0ggbmV0XSBu
ZXQ6IGhuczM6IExpbWl0aW5nIHRoZSBzY29wZSBvZg0KPiB2ZWN0b3JfcmluZ19jaGFpbiB2YXJp
YWJsZQ0KDQpbLi4uXQ0KDQo+IEhlbGxvOg0KPiANCj4gVGhpcyBwYXRjaCB3YXMgYXBwbGllZCB0
byBuZXRkZXYvbmV0LW5leHQuZ2l0IChyZWZzL2hlYWRzL21hc3Rlcik6DQo+DQoNCkkgd2FzIHdv
bmRlcmluZyBpZiBJIG1pc3NlZCBhbnl0aGluZyBpbiBteSBzdWJtaXNzaW9uIG9yIGJlY2F1c2Ug
b2Ygc29tZQ0Kb3RoZXIgcmVhc29uIHRoaXMgcGF0Y2ggd2FzIGNob3NlbiB0byBiZSBhcHBsaWVk
IHRvIHRoZSAtbmV0LW5leHQgcmVwbw0KaW5zdGVhZC4gUGVyaGFwcyB0aGlzIGlzIG5vdCBjbGFz
c2lmaWVkIGFzIGJ1Zz8NCg0KTWFueSB0aGFua3MNClNhbGlsDQoNCj4gRnJvbTogcGF0Y2h3b3Jr
LWJvdCtuZXRkZXZicGZAa2VybmVsLm9yZw0KPiBbbWFpbHRvOnBhdGNod29yay1ib3QrbmV0ZGV2
YnBmQGtlcm5lbC5vcmddDQo+IFNlbnQ6IE1vbmRheSwgQXByaWwgNSwgMjAyMSAxMToxMCBQTQ0K
PiBUbzogU2FsaWwgTWVodGEgPHNhbGlsLm1laHRhQGh1YXdlaS5jb20+DQo+IENjOiBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IExpbnV4YXJtIDxsaW51eGFybUBodWF3ZWku
Y29tPjsNCj4gbGludXhhcm1Ab3BlbmV1bGVyLm9yZw0KPiBTdWJqZWN0OiBbTGludXhhcm1dIFJl
OiBbUEFUQ0ggbmV0XSBuZXQ6IGhuczM6IExpbWl0aW5nIHRoZSBzY29wZSBvZg0KPiB2ZWN0b3Jf
cmluZ19jaGFpbiB2YXJpYWJsZQ0KPiANCj4gSGVsbG86DQo+IA0KPiBUaGlzIHBhdGNoIHdhcyBh
cHBsaWVkIHRvIG5ldGRldi9uZXQtbmV4dC5naXQgKHJlZnMvaGVhZHMvbWFzdGVyKToNCj4gDQo+
IE9uIE1vbiwgNSBBcHIgMjAyMSAxODoyODoyNSArMDEwMCB5b3Ugd3JvdGU6DQo+ID4gTGltaXRp
bmcgdGhlIHNjb3BlIG9mIHRoZSB2YXJpYWJsZSB2ZWN0b3JfcmluZ19jaGFpbiB0byB0aGUgYmxv
Y2sgd2hlcmUgaXQNCj4gPiBpcyB1c2VkLg0KPiA+DQo+ID4gRml4ZXM6IDQyNGViODM0YTliZSAo
Im5ldDogaG5zMzogVW5pZmllZCBITlMzIHtWRnxQRn0gRXRoZXJuZXQgRHJpdmVyIGZvciBoaXAw
OA0KPiBTb0MiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFNhbGlsIE1laHRhIDxzYWxpbC5tZWh0YUBo
dWF3ZWkuY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24v
aG5zMy9obnMzX2VuZXQuYyB8IDMgKystDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlv
bnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IEhlcmUgaXMgdGhlIHN1bW1hcnkgd2l0aCBsaW5r
czoNCj4gICAtIFtuZXRdIG5ldDogaG5zMzogTGltaXRpbmcgdGhlIHNjb3BlIG9mIHZlY3Rvcl9y
aW5nX2NoYWluIHZhcmlhYmxlDQo+ICAgICBodHRwczovL2dpdC5rZXJuZWwub3JnL25ldGRldi9u
ZXQtbmV4dC9jL2QzOTJlY2QxYmMyOQ0KPiANCj4gWW91IGFyZSBhd2Vzb21lLCB0aGFuayB5b3Uh
DQo+IC0tDQo+IERlZXQtZG9vdC1kb3QsIEkgYW0gYSBib3QuDQo+IGh0dHBzOi8va29yZy5kb2Nz
Lmtlcm5lbC5vcmcvcGF0Y2h3b3JrL3B3Ym90Lmh0bWwNCj4gDQo+IF9fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fDQo+IExpbnV4YXJtIG1haWxpbmcgbGlzdCAt
LSBsaW51eGFybUBvcGVuZXVsZXIub3JnDQo+IFRvIHVuc3Vic2NyaWJlIHNlbmQgYW4gZW1haWwg
dG8gbGludXhhcm0tbGVhdmVAb3BlbmV1bGVyLm9yZw0K
