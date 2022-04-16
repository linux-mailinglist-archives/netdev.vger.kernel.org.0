Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E46F503600
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 12:45:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231487AbiDPKsK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 06:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiDPKsF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 06:48:05 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0214F286E7;
        Sat, 16 Apr 2022 03:45:32 -0700 (PDT)
Received: from canpemm500010.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4KgVFb0XRmzfYmG;
        Sat, 16 Apr 2022 18:44:51 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Sat, 16 Apr 2022 18:45:30 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.024;
 Sat, 16 Apr 2022 18:45:30 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
Subject: RE: [PATCH bpf-next v3 1/3] net: Enlarge offset check value from
 0xffff to INT_MAX in bpf_skb_load_bytes
Thread-Topic: [PATCH bpf-next v3 1/3] net: Enlarge offset check value from
 0xffff to INT_MAX in bpf_skb_load_bytes
Thread-Index: AQHYUAeCKtc+d3LDjkmzQKkW9I+ke6zw2LwAgAF/kUA=
Date:   Sat, 16 Apr 2022 10:45:30 +0000
Message-ID: <8d517be8560b426c88a08b267282b8c0@huawei.com>
References: <20220414135902.100914-1-liujian56@huawei.com>
 <20220414135902.100914-2-liujian56@huawei.com>
 <7229410f-590f-79f6-94e4-38904d9bead1@iogearbox.net>
In-Reply-To: <7229410f-590f-79f6-94e4-38904d9bead1@iogearbox.net>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuaWVsIEJvcmttYW5u
IFttYWlsdG86ZGFuaWVsQGlvZ2VhcmJveC5uZXRdDQo+IFNlbnQ6IFNhdHVyZGF5LCBBcHJpbCAx
NiwgMjAyMiAzOjMyIEFNDQo+IFRvOiBsaXVqaWFuIChDRSkgPGxpdWppYW41NkBodWF3ZWkuY29t
PjsgYXN0QGtlcm5lbC5vcmc7IGFuZHJpaUBrZXJuZWwub3JnOw0KPiBrYWZhaUBmYi5jb207IHNv
bmdsaXVicmF2aW5nQGZiLmNvbTsgeWhzQGZiLmNvbTsNCj4gam9obi5mYXN0YWJlbmRAZ21haWwu
Y29tOyBrcHNpbmdoQGtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGt1YmFAa2Vy
bmVsLm9yZzsgc2RmQGdvb2dsZS5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGJwZkB2
Z2VyLmtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0gg
YnBmLW5leHQgdjMgMS8zXSBuZXQ6IEVubGFyZ2Ugb2Zmc2V0IGNoZWNrIHZhbHVlIGZyb20NCj4g
MHhmZmZmIHRvIElOVF9NQVggaW4gYnBmX3NrYl9sb2FkX2J5dGVzDQo+IA0KPiBPbiA0LzE0LzIy
IDM6NTkgUE0sIExpdSBKaWFuIHdyb3RlOg0KPiA+IFRoZSBkYXRhIGxlbmd0aCBvZiBza2IgZnJh
Z3MgKyBmcmFnX2xpc3QgbWF5IGJlIGdyZWF0ZXIgdGhhbiAweGZmZmYsDQo+ID4gYW5kIHNrYl9o
ZWFkZXJfcG9pbnRlciBjYW4gbm90IGhhbmRsZSBuZWdhdGl2ZSBvZmZzZXQgYW5kIG5lZ2F0aXZl
IGxlbi4NCj4gPiBTbyBoZXJlIElOVF9NQVggaXMgdXNlZCB0byBjaGVjayB0aGUgdmFsaWRpdHkg
b2Ygb2Zmc2V0IGFuZCBsZW4uDQo+ID4gQWRkIHRoZSBzYW1lIGNoYW5nZSB0byB0aGUgcmVsYXRl
ZCBmdW5jdGlvbiBza2Jfc3RvcmVfYnl0ZXMuDQo+ID4NCj4gPiBGaXhlczogMDVjNzRlNWU1M2Y2
ICgiYnBmOiBhZGQgYnBmX3NrYl9sb2FkX2J5dGVzIGhlbHBlciIpDQo+ID4gU2lnbmVkLW9mZi1i
eTogTGl1IEppYW4gPGxpdWppYW41NkBodWF3ZWkuY29tPg0KPiA+IEFja2VkLWJ5OiBTb25nIExp
dSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPiA+IC0tLQ0KPiA+IHYyLT52MzogY2hhbmdlIG5v
dGhpbmcNCj4gPiAgIG5ldC9jb3JlL2ZpbHRlci5jIHwgNCArKy0tDQo+ID4gICAxIGZpbGUgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdp
dCBhL25ldC9jb3JlL2ZpbHRlci5jIGIvbmV0L2NvcmUvZmlsdGVyLmMgaW5kZXgNCj4gPiA2NDQ3
MGE3MjdlZjcuLjE1NzFiNmJjNTFlYSAxMDA2NDQNCj4gPiAtLS0gYS9uZXQvY29yZS9maWx0ZXIu
Yw0KPiA+ICsrKyBiL25ldC9jb3JlL2ZpbHRlci5jDQo+ID4gQEAgLTE2ODcsNyArMTY4Nyw3IEBA
IEJQRl9DQUxMXzUoYnBmX3NrYl9zdG9yZV9ieXRlcywgc3RydWN0IHNrX2J1ZmYNCj4gPiAqLCBz
a2IsIHUzMiwgb2Zmc2V0LA0KPiA+DQo+ID4gICAJaWYgKHVubGlrZWx5KGZsYWdzICYgfihCUEZf
Rl9SRUNPTVBVVEVfQ1NVTSB8DQo+IEJQRl9GX0lOVkFMSURBVEVfSEFTSCkpKQ0KPiA+ICAgCQly
ZXR1cm4gLUVJTlZBTDsNCj4gPiAtCWlmICh1bmxpa2VseShvZmZzZXQgPiAweGZmZmYpKQ0KPiA+
ICsJaWYgKHVubGlrZWx5KG9mZnNldCA+IElOVF9NQVggfHwgbGVuID4gSU5UX01BWCkpDQo+IA0K
PiBPbmUgbW9yZSBmb2xsb3ctdXAgcXVlc3Rpb24sIGxlbiBwYXJhbSBpcyBjaGVja2VkIGJ5IHRo
ZSB2ZXJpZmllciBmb3IgdGhlDQo+IHByb3ZpZGVkIGJ1ZmZlci4NCj4gV2h5IGlzIGl0IG5lZWRl
ZCBoZXJlPyBXZXJlIHlvdSBhYmxlIHRvIGNyZWF0ZSBlLmcuIG1hcCB2YWx1ZXMgb2Ygc2l6ZSBs
YXJnZXINCj4gdGhhbiBJTlRfTUFYPw0KPiBQbGVhc2UgcHJvdmlkZSBkZXRhaWxzLiAoT3RoZXIg
dGhhbiB0aGF0LCByZXN0IGxvb2tzIGdvb2QuKQ0KPiANCkkgb25seSBuZWVkIGNoYW5nZSAib2Zm
c2V0ID4gMHhmZmZmIi4gIERlbGV0ZSAiIHx8IGxlbiA+IElOVF9NQVggIiBpbiB2NC4NClRoYW5r
IHlvdX4NCg0KPiA+ICAgCQlyZXR1cm4gLUVGQVVMVDsNCj4gPiAgIAlpZiAodW5saWtlbHkoYnBm
X3RyeV9tYWtlX3dyaXRhYmxlKHNrYiwgb2Zmc2V0ICsgbGVuKSkpDQo+ID4gICAJCXJldHVybiAt
RUZBVUxUOw0KPiA+IEBAIC0xNzIyLDcgKzE3MjIsNyBAQCBCUEZfQ0FMTF80KGJwZl9za2JfbG9h
ZF9ieXRlcywgY29uc3Qgc3RydWN0DQo+IHNrX2J1ZmYgKiwgc2tiLCB1MzIsIG9mZnNldCwNCj4g
PiAgIHsNCj4gPiAgIAl2b2lkICpwdHI7DQo+ID4NCj4gPiAtCWlmICh1bmxpa2VseShvZmZzZXQg
PiAweGZmZmYpKQ0KPiA+ICsJaWYgKHVubGlrZWx5KG9mZnNldCA+IElOVF9NQVggfHwgbGVuID4g
SU5UX01BWCkpDQo+ID4gICAJCWdvdG8gZXJyX2NsZWFyOw0KPiA+DQo+ID4gICAJcHRyID0gc2ti
X2hlYWRlcl9wb2ludGVyKHNrYiwgb2Zmc2V0LCBsZW4sIHRvKTsNCj4gPg0KDQo=
