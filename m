Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E3B3298584
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 03:21:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1421374AbgJZCU5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Oct 2020 22:20:57 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:2482 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373844AbgJZCU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Oct 2020 22:20:56 -0400
Received: from DGGEMM402-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CKJV34ZzgzQkfZ;
        Mon, 26 Oct 2020 10:20:59 +0800 (CST)
Received: from dggema705-chm.china.huawei.com (10.3.20.69) by
 DGGEMM402-HUB.china.huawei.com (10.3.20.210) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 26 Oct 2020 10:20:54 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema705-chm.china.huawei.com (10.3.20.69) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Mon, 26 Oct 2020 10:20:53 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Mon, 26 Oct 2020 10:20:53 +0800
From:   zhangqilong <zhangqilong3@huawei.com>
To:     Joe Perches <joe@perches.com>, Vasily Averin <vvs@virtuozzo.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "lirongqing@baidu.com" <lirongqing@baidu.com>,
        "roopa@cumulusnetworks.com" <roopa@cumulusnetworks.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggLW5leHRdIG5laWdoOiByZW1vdmUgdGhlIGV4dHJh?=
 =?utf-8?Q?_slash?=
Thread-Topic: [PATCH -next] neigh: remove the extra slash
Thread-Index: AQHWqSWQ98Bo0d7ZtUGVsuf1ZhjPrKmnFEcAgAIU44A=
Date:   Mon, 26 Oct 2020 02:20:53 +0000
Message-ID: <f1bce5f03476409fa78920bddf4b4c06@huawei.com>
References: <20201023100146.34948-1-zhangqilong3@huawei.com>
         <e3e6a453-6a73-3f88-e94b-fa39b38252d9@virtuozzo.com>
 <a9bc6a8898116bc017152136265a523d5097da84.camel@perches.com>
In-Reply-To: <a9bc6a8898116bc017152136265a523d5097da84.camel@perches.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.28]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBGcmksIDIwMjAtMTAtMjMgYXQgMTM6MTYgKzAzMDAsIFZhc2lseSBBdmVyaW4gd3JvdGU6
DQo+ID4gT24gMTAvMjMvMjAgMTowMSBQTSwgWmhhbmcgUWlsb25nIHdyb3RlOg0KPiA+ID4gVGhl
IG5vcm1hbCBwYXRoIGhhcyBvbmx5IG9uZSBzbGFzaC4NCj4gPg0KPiA+IGl0IGlzIG5vdCBub3Jt
YWwgcGF0aA0KPiA+IHRoaXMgc3RyaW5nIGlzIHVzZWQgdG8gY2FsY3VsYXRlIG51bWJlciBvZiBz
eW1ib2xzIGluDQo+ID4gIm5ldC8lcy9uZWlnaC8lcyIgdXNlZCBiZWxvdw0KPiANCj4gVGhlbiBw
cm9iYWJseSBiZXR0ZXIgd291bGQgYmUgdG8gYWRkICsxIHJhdGhlciB0aGFuIHVzZSBhIHJhdGhl
ciBvZGQgZmlsZW5hbWUuDQoNCkhpLCBKb2UNCglJIHVzZSB0aGUgc3BsaWNpbmcgbWV0aG9kIHRv
IHJld3JpdGUgaXQgaW4gcGF0Y2ggVjIgWzAwMDEtbmVpZ2gtQWRqdXN0bWVudC1jYWxjdWxhdGlv
bi1tZXRob2Qtb2YtbmVpZ2hib3VyLXBhdC5wYXRjaF0sIEkgdGhpbmsgaXQgd2lsbCBiZSBjbGVh
cmVyLiBMb29raW5nIGZvcndhcmQgdG8geW91ciByZXBseS4NClRoYW5rcywgYmVzdCB3aXNoIHRv
IHlvdS4NClpoYW5nIFFpbG9uZw0KDQo+IA0KPiA+ID4gZGlmZiAtLWdpdCBhL25ldC9jb3JlL25l
aWdoYm91ci5jIGIvbmV0L2NvcmUvbmVpZ2hib3VyLmMNCj4gW10NCj4gPiA+IEBAIC0zNjIzLDcg
KzM2MjMsNyBAQCBpbnQgbmVpZ2hfc3lzY3RsX3JlZ2lzdGVyKHN0cnVjdCBuZXRfZGV2aWNlICpk
ZXYsDQo+IHN0cnVjdCBuZWlnaF9wYXJtcyAqcCwNCj4gPiA+IMKgCWludCBpOw0KPiA+ID4gwqAJ
c3RydWN0IG5laWdoX3N5c2N0bF90YWJsZSAqdDsNCj4gPiA+IMKgCWNvbnN0IGNoYXIgKmRldl9u
YW1lX3NvdXJjZTsNCj4gPiA+IC0JY2hhciBuZWlnaF9wYXRoWyBzaXplb2YoIm5ldC8vbmVpZ2gv
IikgKyBJRk5BTVNJWiArIElGTkFNU0laIF07DQo+ID4gPiArCWNoYXIgbmVpZ2hfcGF0aFtzaXpl
b2YoIm5ldC9uZWlnaC8iKSArIElGTkFNU0laICsgSUZOQU1TSVpdOw0KPiA+ID4gwqAJY2hhciAq
cF9uYW1lOw0KPiA+ID4NCj4gPiA+DQo+ID4gPiDCoAl0ID0ga21lbWR1cCgmbmVpZ2hfc3lzY3Rs
X3RlbXBsYXRlLCBzaXplb2YoKnQpLCBHRlBfS0VSTkVMKTsNCj4gPiA+DQo+IA0KDQo=
