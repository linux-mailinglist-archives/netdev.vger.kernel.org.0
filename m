Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42DCC43ADE6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 10:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233841AbhJZIXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 04:23:21 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29936 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233972AbhJZIXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 04:23:15 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.53])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Hdl5R6fhYzbnRv;
        Tue, 26 Oct 2021 16:16:11 +0800 (CST)
Received: from dggema724-chm.china.huawei.com (10.3.20.88) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.15; Tue, 26 Oct 2021 16:20:48 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema724-chm.china.huawei.com (10.3.20.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Tue, 26 Oct 2021 16:20:47 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2308.015;
 Tue, 26 Oct 2021 16:20:47 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     John Fastabend <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jakub@cloudflare.com" <jakub@cloudflare.com>,
        "lmb@cloudflare.com" <lmb@cloudflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>
Subject: RE: [PATHC bpf v5 3/3] selftests, bpf: Add one test for sockmap with
 strparser
Thread-Topic: [PATHC bpf v5 3/3] selftests, bpf: Add one test for sockmap with
 strparser
Thread-Index: AQHXvzXp2/El6N6AFUS/uEEa0ZcKOaveryUAgATgOnCAAXZo8A==
Date:   Tue, 26 Oct 2021 08:20:47 +0000
Message-ID: <da03f755b9b643a28ff35e10f5027880@huawei.com>
References: <20211012065705.224643-1-liujian56@huawei.com>
 <20211012065705.224643-3-liujian56@huawei.com>
 <6172d93e2a470_82a7f2083@john-XPS-13-9370.notmuch> 
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbGl1amlhbiAoQ0UpDQo+
IFNlbnQ6IE1vbmRheSwgT2N0b2JlciAyNSwgMjAyMSA2OjE3IFBNDQo+IFRvOiAnSm9obiBGYXN0
YWJlbmQnIDxqb2huLmZhc3RhYmVuZEBnbWFpbC5jb20+OyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsN
Cj4gamFrdWJAY2xvdWRmbGFyZS5jb207IGxtYkBjbG91ZGZsYXJlLmNvbTsgZGF2ZW1AZGF2ZW1s
b2Z0Lm5ldDsNCj4ga3ViYUBrZXJuZWwub3JnOyBhc3RAa2VybmVsLm9yZzsgYW5kcmlpQGtlcm5l
bC5vcmc7IGthZmFpQGZiLmNvbTsNCj4gc29uZ2xpdWJyYXZpbmdAZmIuY29tOyB5aHNAZmIuY29t
OyBrcHNpbmdoQGtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGJwZkB2Z2Vy
Lmtlcm5lbC5vcmc7IHhpeW91Lndhbmdjb25nQGdtYWlsLmNvbQ0KPiBTdWJqZWN0OiBSRTogW1BB
VEhDIGJwZiB2NSAzLzNdIHNlbGZ0ZXN0cywgYnBmOiBBZGQgb25lIHRlc3QgZm9yIHNvY2ttYXAg
d2l0aA0KPiBzdHJwYXJzZXINCj4gDQo+IA0KPiANCj4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+IEZyb206IEpvaG4gRmFzdGFiZW5kIFttYWlsdG86am9obi5mYXN0YWJlbmRAZ21h
aWwuY29tXQ0KPiA+IFNlbnQ6IEZyaWRheSwgT2N0b2JlciAyMiwgMjAyMSAxMTozMSBQTQ0KPiA+
IFRvOiBsaXVqaWFuIChDRSkgPGxpdWppYW41NkBodWF3ZWkuY29tPjsgam9obi5mYXN0YWJlbmRA
Z21haWwuY29tOw0KPiA+IGRhbmllbEBpb2dlYXJib3gubmV0OyBqYWt1YkBjbG91ZGZsYXJlLmNv
bTsgbG1iQGNsb3VkZmxhcmUuY29tOw0KPiA+IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2Vy
bmVsLm9yZzsgYXN0QGtlcm5lbC5vcmc7DQo+ID4gYW5kcmlpQGtlcm5lbC5vcmc7IGthZmFpQGZi
LmNvbTsgc29uZ2xpdWJyYXZpbmdAZmIuY29tOyB5aHNAZmIuY29tOw0KPiA+IGtwc2luZ2hAa2Vy
bmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2VybmVsLm9yZzsNCj4g
PiB4aXlvdS53YW5nY29uZ0BnbWFpbC5jb20NCj4gPiBDYzogbGl1amlhbiAoQ0UpIDxsaXVqaWFu
NTZAaHVhd2VpLmNvbT4NCj4gPiBTdWJqZWN0OiBSRTogW1BBVEhDIGJwZiB2NSAzLzNdIHNlbGZ0
ZXN0cywgYnBmOiBBZGQgb25lIHRlc3QgZm9yDQo+ID4gc29ja21hcCB3aXRoIHN0cnBhcnNlcg0K
PiA+DQo+ID4gTGl1IEppYW4gd3JvdGU6DQo+ID4gPiBBZGQgdGhlIHRlc3QgdG8gY2hlY2sgc29j
a21hcCB3aXRoIHN0cnBhcnNlciBpcyB3b3JraW5nIHdlbGwuDQo+ID4gPg0KPiA+ID4gU2lnbmVk
LW9mZi1ieTogTGl1IEppYW4gPGxpdWppYW41NkBodWF3ZWkuY29tPg0KPiA+ID4gLS0tDQo+ID4g
PiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rfc29ja21hcC5jIHwgMzMNCj4gPiA+
ICsrKysrKysrKysrKysrKysrKysrLS0NCj4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMzAgaW5zZXJ0
aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IEhpIExpdSwNCj4gPg0KPiA+IFRoaXMg
aXMgYSBnb29kIHRlc3QsIGJ1dCB3ZSBzaG91bGQgYWxzbyBhZGQgb25lIHdpdGggYSBwYXJzZXIN
Cj4gPiByZXR1cm5pbmcgYSB2YWx1ZSB0aGF0IGlzIG5vdCBza2ItPmxlbi4gVGhpcyBkb2Vzbid0
IGNvdmVyIHRoZSBjYXNlIGZpeGVkIGluDQo+IHBhdGNoIDEvMyBjb3JyZWN0Pw0KPiA+IEZvciB0
aGF0IHdlIHdvdWxkIG5lZWQgdG8gbW9kaWZ5IHRoZSBCUEYgcHJvZyBpdHNlbGYgYXMgd2VsbA0K
PiA+IHNvY2ttYXBfcGFyc2VfcHJvZy5jLg0KPiA+DQo+IEhpIEpvaG4sDQo+IFRoaXMgdGVzdCBw
YXRjaCB1c2UgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc29ja21hcF9r
ZXJuLmMNCj4gbm90IHNvY2ttYXBfcGFyc2VfcHJvZy5jLg0KPiANCj4gSWYgd2Ugc2V0IHNrYl91
c2VfcGFyc2VyIHRvIG5vbnplcm8sIHRoZSBicGYgcGFyc2VyIHByb2dyYW0gd2lsbCByZXR1cm4N
Cj4gc2tiX3VzZV9wYXJzZXIgbm90IHNrYi0+bGVuLg0KPiBJbiB0aGlzIHRlc3QgY2FzZSwgSSBz
ZXQgc2tiX3VzZV9wYXJzZXIgdG8gMTAsIHNrYi0+bGVuIHRvIDIwIChvcHQtPmlvdl9sZW5ndGgp
Lg0KPiBUaGlzIGNhbiB0ZXN0IDEvMyBwYXRjaCwgaXQgd2lsbCBjaGVjayB0aGUgcmVjdmVkIGRh
dGEgbGVuIGlzIDEwIG5vdCAyMC4NCj4gDQpTb3JyeSwgaXQgd2lsbCBjaGVjayB0aGUgcmVjdmVk
IGRhdGEgbGVuZ3RoIGlzIDIwIG5vdCA0MC4NCg0KPiBUaGUgcGFyc2VyIHByb2cgaW4gdG9vbHMv
dGVzdGluZy9zZWxmdGVzdHMvYnBmL3Byb2dzL3Rlc3Rfc29ja21hcF9rZXJuLmgNCj4gU0VDKCJz
a19za2IxIikNCj4gaW50IGJwZl9wcm9nMShzdHJ1Y3QgX19za19idWZmICpza2IpDQo+IHsNCj4g
ICAgICAgICBpbnQgKmYsIHR3byA9IDI7DQo+IA0KPiAgICAgICAgIGYgPSBicGZfbWFwX2xvb2t1
cF9lbGVtKCZzb2NrX3NrYl9vcHRzLCAmdHdvKTsNCj4gICAgICAgICBpZiAoZiAmJiAqZikgew0K
PiAgICAgICAgICAgICAgICAgcmV0dXJuICpmOw0KPiAgICAgICAgIH0NCj4gICAgICAgICByZXR1
cm4gc2tiLT5sZW47DQo+IH0NCj4gPiBGb3IgdGhpcyBwYXRjaCB0aG91Z2gsDQo+ID4NCj4gPiBB
Y2tlZC1ieTogSm9obiBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT4NCj4gPg0K
PiA+IFRoZW4gb25lIG1vcmUgcGF0Y2ggaXMgYWxsIHdlIG5lZWQgc29tZXRoaW5nIHRvIGJyZWFr
IHVwIHRoZSBza2IgZnJvbQ0KPiA+IHRoZSBwYXJzZXIuIFdlIHJlYWxseSBuZWVkIHRoZSB0ZXN0
IGJlY2F1c2UgaXRzIG5vdCBzb21ldGhpbmcgd2UgY2FuDQo+ID4gZWFzaWx5IHRlc3Qgb3RoZXJ3
aXNlIGFuZCBJIGRvbid0IGhhdmUgYW55IHVzZSBjYXNlcyB0aGF0IGRvIHRoaXMgc28gd291bGRu
J3QNCj4gY2F0Y2ggaXQuDQo+ID4NCj4gPiBUaGFua3MhDQo+ID4gSm9obg0K
