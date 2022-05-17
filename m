Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3762152970E
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 04:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230358AbiEQCBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 22:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232719AbiEQCA7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 22:00:59 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD44DEB8;
        Mon, 16 May 2022 19:00:56 -0700 (PDT)
Received: from canpemm100009.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4L2K792DWNzgYH5;
        Tue, 17 May 2022 09:59:33 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm100009.china.huawei.com (7.192.105.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 17 May 2022 10:00:53 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Tue, 17 May 2022 10:00:53 +0800
From:   shaozhengchao <shaozhengchao@huawei.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
CC:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSCBicGYtbmV4dF0gc2FtcGxlcy9icGY6?=
 =?utf-8?Q?_check_detach_prog_exist_or_not_in_xdp=5Ffwd?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0ggYnBmLW5leHRdIHNhbXBsZXMvYnBmOiBjaGVjayBk?=
 =?utf-8?Q?etach_prog_exist_or_not_in_xdp=5Ffwd?=
Thread-Index: AQHYYz67ysyf9xnyEEa5gXY59XVHBq0VxqsAgACPrJD//4OmgIAMgjnQ
Date:   Tue, 17 May 2022 02:00:52 +0000
Message-ID: <942eaafecf074ae8a5bb336c18658453@huawei.com>
References: <20220509005105.271089-1-shaozhengchao@huawei.com>
 <87pmknyr6b.fsf@toke.dk> <f9c85578b94a4a38b3f7b9c796810a30@huawei.com>
 <87h75zynz2.fsf@toke.dk>
In-Reply-To: <87h75zynz2.fsf@toke.dk>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.178.66]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCi0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCuWPkeS7tuS6ujogVG9rZSBIw7hpbGFuZC1Kw7hy
Z2Vuc2VuIFttYWlsdG86dG9rZUBrZXJuZWwub3JnXSANCuWPkemAgeaXtumXtDogMjAyMuW5tDXm
nIg55pelIDE4OjU1DQrmlLbku7bkuro6IHNoYW96aGVuZ2NoYW8gPHNoYW96aGVuZ2NoYW9AaHVh
d2VpLmNvbT47IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGFzdEBrZXJuZWwub3JnOyBkYW5pZWxAaW9nZWFy
Ym94Lm5ldDsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBoYXdrQGtlcm5l
bC5vcmc7IGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbTsgYW5kcmlpQGtlcm5lbC5vcmc7IGthZmFp
QGZiLmNvbTsgc29uZ2xpdWJyYXZpbmdAZmIuY29tOyB5aHNAZmIuY29tOyBrcHNpbmdoQGtlcm5l
bC5vcmcNCuaKhOmAgTogd2VpeW9uZ2p1biAoQSkgPHdlaXlvbmdqdW4xQGh1YXdlaS5jb20+OyB5
dWVoYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQrkuLvpopg6IFJlOiDnrZTlpI06IFtQ
QVRDSCBicGYtbmV4dF0gc2FtcGxlcy9icGY6IGNoZWNrIGRldGFjaCBwcm9nIGV4aXN0IG9yIG5v
dCBpbiB4ZHBfZndkDQoNCnNoYW96aGVuZ2NoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2VpLmNvbT4g
d3JpdGVzOg0KDQo+IC0tLS0t6YKu5Lu25Y6f5Lu2LS0tLS0NCj4g5Y+R5Lu25Lq6OiBUb2tlIEjD
uGlsYW5kLUrDuHJnZW5zZW4gW21haWx0bzp0b2tlQGtlcm5lbC5vcmddDQo+IOWPkemAgeaXtumX
tDogMjAyMuW5tDXmnIg55pelIDE3OjQ2DQo+IOaUtuS7tuS6ujogc2hhb3poZW5nY2hhbyA8c2hh
b3poZW5nY2hhb0BodWF3ZWkuY29tPjsgYnBmQHZnZXIua2VybmVsLm9yZzsgDQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGFzdEBrZXJuZWwu
b3JnOyANCj4gZGFuaWVsQGlvZ2VhcmJveC5uZXQ7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFA
a2VybmVsLm9yZzsgDQo+IGhhd2tAa2VybmVsLm9yZzsgam9obi5mYXN0YWJlbmRAZ21haWwuY29t
OyBhbmRyaWlAa2VybmVsLm9yZzsgDQo+IGthZmFpQGZiLmNvbTsgc29uZ2xpdWJyYXZpbmdAZmIu
Y29tOyB5aHNAZmIuY29tOyBrcHNpbmdoQGtlcm5lbC5vcmcNCj4g5oqE6YCBOiB3ZWl5b25nanVu
IChBKSA8d2VpeW9uZ2p1bjFAaHVhd2VpLmNvbT47IHNoYW96aGVuZ2NoYW8gDQo+IDxzaGFvemhl
bmdjaGFvQGh1YXdlaS5jb20+OyB5dWVoYWliaW5nIDx5dWVoYWliaW5nQGh1YXdlaS5jb20+DQo+
IOS4u+mimDogUmU6IFtQQVRDSCBicGYtbmV4dF0gc2FtcGxlcy9icGY6IGNoZWNrIGRldGFjaCBw
cm9nIGV4aXN0IG9yIG5vdCANCj4gaW4geGRwX2Z3ZA0KPg0KPiBaaGVuZ2NoYW8gU2hhbyA8c2hh
b3poZW5nY2hhb0BodWF3ZWkuY29tPiB3cml0ZXM6DQo+DQo+PiBCZWZvcmUgZGV0YWNoIHRoZSBw
cm9nLCB3ZSBzaG91bGQgY2hlY2sgZGV0YWNoIHByb2cgZXhpc3Qgb3Igbm90Lg0KPg0KPiBJZiB3
ZSdyZSBhZGRpbmcgc3VjaCBhIGNoZWNrIHdlIHNob3VsZCBhbHNvIGNoZWNrIHRoYXQgaXQncyB0
aGUgKnJpZ2h0KiBwcm9ncmFtLiBJLmUuLCBxdWVyeSB0aGUgSUQgZm9yIHRoZSBwcm9ncmFtIG5h
bWUgYW5kIGNoZWNrIHRoYXQgaXQgbWF0Y2hlcyB3aGF0IHRoZSBwcm9ncmFtIGF0dGFjaGVkLCB0
aGVuIG9idGFpbiBhbiBmZCBhbmQgcGFzcyB0aGF0IGFzIFhEUF9FWFBFQ1RFRF9GRCBvbiBkZXRh
Y2ggdG8gbWFrZSBzdXJlIGl0IHdhc24ndCBzd2FwcGVkIG91dCBpbiB0aGUgbWVhbnRpbWUuLi4N
Cj4NCj4gLVRva2UNCj4NCj4gVGhhbmsgeW91IGZvciB5b3VyIHJlcGx5LiBXaGVuIGZpbmlzaCBy
dW5uaW5nIHhkcF9md2QgdG8gYXR0YXRjaCBwcm9nLCANCj4gdGhlIHByb2dyYW0gd2lsbCBleGl0
IGFuZCBjYW4ndCBzdG9yZSBmZCBhcyBYRFBfRVhQRUNURURfRkQuDQo+DQo+IEkgdGhpbmsgdGhl
IHNhbXBsZSB4ZHBfZndkIC1kIGlzIGp1c3QgZGV0YWNoIHByb2cgYW5kIGRvbid0IGNhcmUgaWYg
DQo+IHRoZSBmZCBpcyBleHBlY3RlZC4NCg0KU28gd2h5IGFyZSB5b3UgYWRkaW5nIHRoZSBjaGVj
az8gRWl0aGVyIGtlZXAgaXQgdGhlIHdheSBpdCBpcywgb3IgYWRkIGEgcHJvcGVyIGNoZWNrIHRo
YXQgZXhhbWluZXMgdGhlIHByb2dyYW0gdHlwZTsgeW91J3JlIHJpZ2h0IHRoYXQgaXQgZG9lc24n
dCBzdG9yZSB0aGUgcHJvZyBGRCwgYnV0IHlvdSBjYW4gc3RpbGwgY2hlY2sgdGhlIHByb2dyYW0g
bmFtZSBhbmQgc2VlIGlmIGl0IG1hdGNoZXMgdG8gZ2V0IHNvbWUgaWRlYSB0aGF0IGl0J3Mgbm90
IGEgdG90YWxseSBzZXBhcmF0ZSBwcm9ncmFtIHRoYXQncyBsb2FkZWQuIEkgdGhpbmsgZG9pbmcg
c28gd291bGQgYmUgYW4gaW1wcm92ZW1lbnQgdG8gdGhlIHNhbXBsZSwgYnV0IGp1c3QgYWRkaW5n
IGEgY2hlY2sgaWYgYSBwcm9ncmFtIGlzIGxvYWRlZCBpcyBub3QsIHJlYWxseS4uLg0KDQotVG9r
ZQ0KDQoNCkNvdWxkIEkgYWRkIGhlbHBlciBmdW5jdGlvbiB0byBpbXBsZW1lbnQgdGhpcyBmdW5j
dGlvbiB3aGljaCBjYW4gY2hlY2sgdGhlIHByb2dyYW0gbmFtZSBhbmQgc2VlIGlmIGl0IGF0dGFj
aCB0byB0aGUgZGV2aWNlLg0KDQotWmhlbmdjaGFvIFNoYW8NCg==
