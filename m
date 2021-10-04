Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D709420568
	for <lists+netdev@lfdr.de>; Mon,  4 Oct 2021 06:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232392AbhJDE30 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Oct 2021 00:29:26 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:24218 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhJDE30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Oct 2021 00:29:26 -0400
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4HN72j45xWz8tZV;
        Mon,  4 Oct 2021 12:26:37 +0800 (CST)
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2308.8; Mon, 4 Oct 2021 12:27:34 +0800
Received: from dggema772-chm.china.huawei.com (10.1.198.214) by
 dggema772-chm.china.huawei.com (10.1.198.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 4 Oct 2021 12:27:34 +0800
Received: from dggema772-chm.china.huawei.com ([10.9.128.138]) by
 dggema772-chm.china.huawei.com ([10.9.128.138]) with mapi id 15.01.2308.008;
 Mon, 4 Oct 2021 12:27:34 +0800
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
Subject: RE: [PATCH v4] skmsg: lose offset info in sk_psock_skb_ingress
Thread-Topic: [PATCH v4] skmsg: lose offset info in sk_psock_skb_ingress
Thread-Index: AQHXtNafWXeoX8LX90u02UwkM3/EjKu8qsUAgAWaNgA=
Date:   Mon, 4 Oct 2021 04:27:34 +0000
Message-ID: <af7c8e8776f844f085f6dc70e9b022fd@huawei.com>
References: <20210929020642.206454-1-liujian56@huawei.com>
 <61563ebaf2fe0_6c4e420813@john-XPS-13-9370.notmuch>
In-Reply-To: <61563ebaf2fe0_6c4e420813@john-XPS-13-9370.notmuch>
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSm9obiBGYXN0YWJlbmQg
W21haWx0bzpqb2huLmZhc3RhYmVuZEBnbWFpbC5jb21dDQo+IFNlbnQ6IEZyaWRheSwgT2N0b2Jl
ciAxLCAyMDIxIDY6NDggQU0NCj4gVG86IGxpdWppYW4gKENFKSA8bGl1amlhbjU2QGh1YXdlaS5j
b20+OyBqb2huLmZhc3RhYmVuZEBnbWFpbC5jb207DQo+IGRhbmllbEBpb2dlYXJib3gubmV0OyBq
YWt1YkBjbG91ZGZsYXJlLmNvbTsgbG1iQGNsb3VkZmxhcmUuY29tOw0KPiBkYXZlbUBkYXZlbWxv
ZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IGFzdEBrZXJuZWwub3JnOw0KPiBhbmRyaWlAa2VybmVs
Lm9yZzsga2FmYWlAZmIuY29tOyBzb25nbGl1YnJhdmluZ0BmYi5jb207IHloc0BmYi5jb207DQo+
IGtwc2luZ2hAa2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgYnBmQHZnZXIua2Vy
bmVsLm9yZzsNCj4geGl5b3Uud2FuZ2NvbmdAZ21haWwuY29tDQo+IENjOiBsaXVqaWFuIChDRSkg
PGxpdWppYW41NkBodWF3ZWkuY29tPg0KPiBTdWJqZWN0OiBSRTogW1BBVENIIHY0XSBza21zZzog
bG9zZSBvZmZzZXQgaW5mbyBpbiBza19wc29ja19za2JfaW5ncmVzcw0KPg0KPiBMaXUgSmlhbiB3
cm90ZToNCj4gPiBJZiBzb2NrbWFwIGVuYWJsZSBzdHJwYXJzZXIsIHRoZXJlIGFyZSBsb3NlIG9m
ZnNldCBpbmZvIGluDQo+ID4gc2tfcHNvY2tfc2tiX2luZ3Jlc3MuIElmIHRoZSBsZW5ndGggZGV0
ZXJtaW5lZCBieSBwYXJzZV9tc2cgZnVuY3Rpb24NCj4gPiBpcyBub3Qgc2tiLT5sZW4sIHRoZSBz
a2Igd2lsbCBiZSBjb252ZXJ0ZWQgdG8gc2tfbXNnIG11bHRpcGxlIHRpbWVzLA0KPiA+IGFuZCB1
c2Vyc3BhY2UgYXBwIHdpbGwgZ2V0IHRoZSBkYXRhIG11bHRpcGxlIHRpbWVzLg0KPiA+DQo+ID4g
Rml4IHRoaXMgYnkgZ2V0IHRoZSBvZmZzZXQgYW5kIGxlbmd0aCBmcm9tIHN0cnBfbXNnLg0KPiA+
IEFuZCBhcyBDb25nIHN1Z2dlc3Rpb24sIGFkZCBvbmUgYml0IGluIHNrYi0+X3NrX3JlZGlyIHRv
IGRpc3Rpbmd1aXNoDQo+ID4gZW5hYmxlIG9yIGRpc2FibGUgc3RycGFyc2VyLg0KPiA+DQo+ID4g
U2lnbmVkLW9mZi1ieTogTGl1IEppYW4gPGxpdWppYW41NkBodWF3ZWkuY29tPg0KPiA+IC0tLQ0K
Pg0KPiBUaGFua3MuIFBsZWFzZSBhZGQgRml4ZXMgdGFncyBzbyB3ZSBjYW4gdHJhY2sgdGhlc2Ug
SSd2ZSBhZGRlZCBpdCBoZXJlLg0KPg0KPiBUaGlzIGhhcyBiZWVuIGJyb2tlbiBmcm9tIHRoZSBp
bml0aWFsIHBhdGNoZXMgYW5kIGFmdGVyIGEgcXVpY2sgZ2xhbmNlIEkNCj4gc3VzcGVjdCB0aGlz
IHdpbGwgbmVlZCBtYW51YWwgYmFja3BvcnRzIGlmIHdlIG5lZWQgaXQuIEFsc28gYWxsIHRoZSBJ
IHVzZSBhbmQgYWxsDQo+IHRoZSBzZWxmdGVzdHMgc2V0IHBhcnNlciB0byBhIG5vcCBieSByZXR1
cm5pbmcgc2tiLT5sZW4uDQo+DQo+IENhbiB5b3UgYWxzbyBjcmVhdGUgYSB0ZXN0IHNvIHdlIGNh
biBlbnN1cmUgd2UgZG9uJ3QgYnJlYWsgdGhpcyBhZ2Fpbj8NCk9rYXksIEkgd2lsbCBkbyB0aGlz
IGFmdGVyIHRoZSBob2xpZGF5Lg0KPg0KPiBGaXhlczogNjA0MzI2YjQxYTZmYiAoImJwZiwgc29j
a21hcDogY29udmVydCB0byBnZW5lcmljIHNrX21zZyBpbnRlcmZhY2UiKQ0KPiBBY2tlZC1ieTog
Sm9obiBGYXN0YWJlbmQgPGpvaG4uZmFzdGFiZW5kQGdtYWlsLmNvbT4NClRoYW5rIHlvdSBmb3Ig
cmV2aWV3aW5nIHRoaXMgcGF0Y2ggYWdhaW4uDQo=
