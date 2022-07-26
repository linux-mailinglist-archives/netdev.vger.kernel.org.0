Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D584A5810AA
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 12:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbiGZKCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 06:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbiGZKCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 06:02:07 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46FFD2CDCD;
        Tue, 26 Jul 2022 03:02:05 -0700 (PDT)
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LsXQ93YV7z6893p;
        Tue, 26 Jul 2022 17:57:21 +0800 (CST)
Received: from fraeml714-chm.china.huawei.com (10.206.15.33) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 26 Jul 2022 12:02:02 +0200
Received: from fraeml714-chm.china.huawei.com ([10.206.15.33]) by
 fraeml714-chm.china.huawei.com ([10.206.15.33]) with mapi id 15.01.2375.024;
 Tue, 26 Jul 2022 12:02:02 +0200
From:   Roberto Sassu <roberto.sassu@huawei.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        "Florian Westphal" <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Lorenzo Bianconi" <lorenzo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc args
 to be trusted
Thread-Topic: [PATCH bpf-next v7 04/13] bpf: Add support for forcing kfunc
 args to be trusted
Thread-Index: AQHYnQf5YGGK69PM90+FORw5bILjSq2O3aiggAFrZ4CAACjgMA==
Date:   Tue, 26 Jul 2022 10:02:02 +0000
Message-ID: <e612d596b547456797dfee98f23bbd62@huawei.com>
References: <20220721134245.2450-1-memxor@gmail.com>
 <20220721134245.2450-5-memxor@gmail.com>
 <64f5b92546c14b69a20e9007bb31146b@huawei.com>
 <CAP01T7683DcToXdYPPZ5gQxiksuJRyrf_=k8PvQGtwNXt0+S-w@mail.gmail.com>
In-Reply-To: <CAP01T7683DcToXdYPPZ5gQxiksuJRyrf_=k8PvQGtwNXt0+S-w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.221.98.153]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBLdW1hciBLYXJ0aWtleWEgRHdpdmVkaSBbbWFpbHRvOm1lbXhvckBnbWFpbC5jb21d
DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjYsIDIwMjIgMTE6MzAgQU0NCj4gT24gTW9uLCAyNSBK
dWwgMjAyMiBhdCAxMTo1MiwgUm9iZXJ0byBTYXNzdSA8cm9iZXJ0by5zYXNzdUBodWF3ZWkuY29t
Pg0KPiB3cm90ZToNCj4gPg0KPiA+ID4gRnJvbTogS3VtYXIgS2FydGlrZXlhIER3aXZlZGkgW21h
aWx0bzptZW14b3JAZ21haWwuY29tXQ0KPiA+ID4gU2VudDogVGh1cnNkYXksIEp1bHkgMjEsIDIw
MjIgMzo0MyBQTQ0KPiA+ID4gVGVhY2ggdGhlIHZlcmlmaWVyIHRvIGRldGVjdCBhIG5ldyBLRl9U
UlVTVEVEX0FSR1Mga2Z1bmMgZmxhZywgd2hpY2gNCj4gPiA+IG1lYW5zIGVhY2ggcG9pbnRlciBh
cmd1bWVudCBtdXN0IGJlIHRydXN0ZWQsIHdoaWNoIHdlIGRlZmluZSBhcyBhDQo+ID4gPiBwb2lu
dGVyIHRoYXQgaXMgcmVmZXJlbmNlZCAoaGFzIG5vbi16ZXJvIHJlZl9vYmpfaWQpIGFuZCBhbHNv
IG5lZWRzIHRvDQo+ID4gPiBoYXZlIGl0cyBvZmZzZXQgdW5jaGFuZ2VkLCBzaW1pbGFyIHRvIGhv
dyByZWxlYXNlIGZ1bmN0aW9ucyBleHBlY3QgdGhlaXINCj4gPiA+IGFyZ3VtZW50LiBUaGlzIGFs
bG93cyBhIGtmdW5jIHRvIHJlY2VpdmUgcG9pbnRlciBhcmd1bWVudHMgdW5jaGFuZ2VkDQo+ID4g
PiBmcm9tIHRoZSByZXN1bHQgb2YgdGhlIGFjcXVpcmUga2Z1bmMuDQo+ID4gPg0KPiA+ID4gVGhp
cyBpcyByZXF1aXJlZCB0byBlbnN1cmUgdGhhdCBrZnVuYyB0aGF0IG9wZXJhdGUgb24gc29tZSBv
YmplY3Qgb25seQ0KPiA+ID4gd29yayBvbiBhY3F1aXJlZCBwb2ludGVycyBhbmQgbm90IG5vcm1h
bCBQVFJfVE9fQlRGX0lEIHdpdGggc2FtZSB0eXBlDQo+ID4gPiB3aGljaCBjYW4gYmUgb2J0YWlu
ZWQgYnkgcG9pbnRlciB3YWxraW5nLiBUaGUgcmVzdHJpY3Rpb25zIGFwcGxpZWQgdG8NCj4gPiA+
IHJlbGVhc2UgYXJndW1lbnRzIGFsc28gYXBwbHkgdG8gdHJ1c3RlZCBhcmd1bWVudHMuIFRoaXMg
aW1wbGllcyB0aGF0DQo+ID4gPiBzdHJpY3QgdHlwZSBtYXRjaGluZyAobm90IGRlZHVjaW5nIHR5
cGUgYnkgcmVjdXJzaXZlbHkgZm9sbG93aW5nIG1lbWJlcnMNCj4gPiA+IGF0IG9mZnNldCkgYW5k
IE9CSl9SRUxFQVNFIG9mZnNldCBjaGVja3MgKGVuc3VyaW5nIHRoZXkgYXJlIHplcm8pIGFyZQ0K
PiA+ID4gdXNlZCBmb3IgdHJ1c3RlZCBwb2ludGVyIGFyZ3VtZW50cy4NCj4gPiA+DQo+ID4gPiBT
aWduZWQtb2ZmLWJ5OiBLdW1hciBLYXJ0aWtleWEgRHdpdmVkaSA8bWVteG9yQGdtYWlsLmNvbT4N
Cj4gPiA+IC0tLQ0KPiA+ID4gIGluY2x1ZGUvbGludXgvYnRmLmggfCAzMiArKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKw0KPiA+ID4gIGtlcm5lbC9icGYvYnRmLmMgICAgfCAxNyArKysr
KysrKysrKysrKy0tLQ0KPiA+ID4gIG5ldC9icGYvdGVzdF9ydW4uYyAgfCAgNSArKysrKw0KPiA+
ID4gIDMgZmlsZXMgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4g
PiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9idGYuaCBiL2luY2x1ZGUvbGlu
dXgvYnRmLmgNCj4gPiA+IGluZGV4IDZkZmM2ZWFmN2Y4Yy4uY2I2M2FhNzFlODJmIDEwMDY0NA0K
PiA+ID4gLS0tIGEvaW5jbHVkZS9saW51eC9idGYuaA0KPiA+ID4gKysrIGIvaW5jbHVkZS9saW51
eC9idGYuaA0KPiA+ID4gQEAgLTE3LDYgKzE3LDM4IEBADQo+ID4gPiAgI2RlZmluZSBLRl9SRUxF
QVNFICAgKDEgPDwgMSkgLyoga2Z1bmMgaXMgYSByZWxlYXNlIGZ1bmN0aW9uICovDQo+ID4gPiAg
I2RlZmluZSBLRl9SRVRfTlVMTCAgKDEgPDwgMikgLyoga2Z1bmMgcmV0dXJucyBhIHBvaW50ZXIg
dGhhdCBtYXkgYmUgTlVMTA0KPiAqLw0KPiA+ID4gICNkZWZpbmUgS0ZfS1BUUl9HRVQgICgxIDw8
IDMpIC8qIGtmdW5jIHJldHVybnMgcmVmZXJlbmNlIHRvIGEga3B0ciAqLw0KPiA+ID4gKy8qIFRy
dXN0ZWQgYXJndW1lbnRzIGFyZSB0aG9zZSB3aGljaCBhcmUgbWVhbnQgdG8gYmUgcmVmZXJlbmNl
ZA0KPiBhcmd1bWVudHMNCj4gPiA+IHdpdGgNCj4gPiA+ICsgKiB1bmNoYW5nZWQgb2Zmc2V0LiBJ
dCBpcyB1c2VkIHRvIGVuZm9yY2UgdGhhdCBwb2ludGVycyBvYnRhaW5lZCBmcm9tDQo+IGFjcXVp
cmUNCj4gPiA+ICsgKiBrZnVuY3MgcmVtYWluIHVubW9kaWZpZWQgd2hlbiBiZWluZyBwYXNzZWQg
dG8gaGVscGVycyB0YWtpbmcgdHJ1c3RlZA0KPiBhcmdzLg0KPiA+ID4gKyAqDQo+ID4gPiArICog
Q29uc2lkZXINCj4gPiA+ICsgKiAgIHN0cnVjdCBmb28gew0KPiA+ID4gKyAqICAgICAgICAgICBp
bnQgZGF0YTsNCj4gPiA+ICsgKiAgICAgICAgICAgc3RydWN0IGZvbyAqbmV4dDsNCj4gPiA+ICsg
KiAgIH07DQo+ID4gPiArICoNCj4gPiA+ICsgKiAgIHN0cnVjdCBiYXIgew0KPiA+ID4gKyAqICAg
ICAgICAgICBpbnQgZGF0YTsNCj4gPiA+ICsgKiAgICAgICAgICAgc3RydWN0IGZvbyBmOw0KPiA+
ID4gKyAqICAgfTsNCj4gPiA+ICsgKg0KPiA+ID4gKyAqICAgc3RydWN0IGZvbyAqZiA9IGFsbG9j
X2ZvbygpOyAvLyBBY3F1aXJlIGtmdW5jDQo+ID4gPiArICogICBzdHJ1Y3QgYmFyICpiID0gYWxs
b2NfYmFyKCk7IC8vIEFjcXVpcmUga2Z1bmMNCj4gPiA+ICsgKg0KPiA+ID4gKyAqIElmIGEga2Z1
bmMgc2V0X2Zvb19kYXRhKCkgd2FudHMgdG8gb3BlcmF0ZSBvbmx5IG9uIHRoZSBhbGxvY2F0ZWQg
b2JqZWN0LA0KPiBpdA0KPiA+ID4gKyAqIHdpbGwgc2V0IHRoZSBLRl9UUlVTVEVEX0FSR1MgZmxh
Zywgd2hpY2ggd2lsbCBwcmV2ZW50IHVuc2FmZSB1c2FnZSBsaWtlOg0KPiA+ID4gKyAqDQo+ID4g
PiArICogICBzZXRfZm9vX2RhdGEoZiwgNDIpOyAgICAgICAvLyBBbGxvd2VkDQo+ID4gPiArICog
ICBzZXRfZm9vX2RhdGEoZi0+bmV4dCwgNDIpOyAvLyBSZWplY3RlZCwgbm9uLXJlZmVyZW5jZWQg
cG9pbnRlcg0KPiA+ID4gKyAqICAgc2V0X2Zvb19kYXRhKCZmLT5uZXh0LCA0Mik7Ly8gUmVqZWN0
ZWQsIHJlZmVyZW5jZWQsIGJ1dCBiYWQgb2Zmc2V0DQo+ID4gPiArICogICBzZXRfZm9vX2RhdGEo
JmItPmYsIDQyKTsgICAvLyBSZWplY3RlZCwgcmVmZXJlbmNlZCwgYnV0IHdyb25nIHR5cGUNCj4g
PiA+ICsgKg0KPiA+ID4gKyAqIEluIHRoZSBmaW5hbCBjYXNlLCB1c3VhbGx5IGZvciB0aGUgcHVy
cG9zZXMgb2YgdHlwZSBtYXRjaGluZywgaXQgaXMgZGVkdWNlZA0KPiA+ID4gKyAqIGJ5IGxvb2tp
bmcgYXQgdGhlIHR5cGUgb2YgdGhlIG1lbWJlciBhdCB0aGUgb2Zmc2V0LCBidXQgZHVlIHRvIHRo
ZQ0KPiA+ID4gKyAqIHJlcXVpcmVtZW50IG9mIHRydXN0ZWQgYXJndW1lbnQsIHRoaXMgZGVkdWN0
aW9uIHdpbGwgYmUgc3RyaWN0IGFuZCBub3QNCj4gZG9uZQ0KPiA+ID4gKyAqIGZvciB0aGlzIGNh
c2UuDQo+ID4gPiArICovDQo+ID4gPiArI2RlZmluZSBLRl9UUlVTVEVEX0FSR1MgKDEgPDwgNCkg
Lyoga2Z1bmMgb25seSB0YWtlcyB0cnVzdGVkIHBvaW50ZXINCj4gPiA+IGFyZ3VtZW50cyAqLw0K
PiA+DQo+ID4gSGkgS3VtYXINCj4gPg0KPiA+IHdvdWxkIGl0IG1ha2Ugc2Vuc2UgdG8gaW50cm9k
dWNlIHBlci1wYXJhbWV0ZXIgZmxhZ3M/IEkgaGF2ZSBhIGZ1bmN0aW9uDQo+ID4gdGhhdCBoYXMg
c2V2ZXJhbCBwYXJhbWV0ZXJzLCBidXQgb25seSBvbmUgaXMgcmVmZXJlbmNlZC4NCj4gPg0KPiAN
Cj4gSSBoYXZlIGEgcGF0Y2ggZm9yIHRoYXQgaW4gbXkgbG9jYWwgYnJhbmNoLCBJIGNhbiBmaXgg
aXQgdXAgYW5kIHBvc3QNCj4gaXQuIEJ1dCBmaXJzdCwgY2FuIHlvdSBnaXZlIGFuIGV4YW1wbGUg
b2Ygd2hlcmUgeW91IHRoaW5rIHlvdSBuZWVkIGl0Pw0KDQpJIGhhdmUgcHVzaGVkIHRoZSBjb21w
bGV0ZSBwYXRjaCBzZXQgaGVyZSwgZm9yIHRlc3Rpbmc6DQoNCmh0dHBzOi8vZ2l0aHViLmNvbS9y
b2JlcnRvc2Fzc3Uvdm10ZXN0L3RyZWUvYnBmLXZlcmlmeS1zaWctdjkvdHJhdmlzLWNpL2RpZmZz
DQoNCkkgcmViYXNlZCB0byBicGYtbmV4dC9tYXN0ZXIsIGFuZCBpbnRyb2R1Y2VkIEtGX1NMRUVQ
QUJMRSAoc2ltaWxhcg0KZnVuY3Rpb25hbGl0eSBvZiAiIGJ0ZjogQWRkIGEgbmV3IGtmdW5jIHNl
dCB3aGljaCBhbGxvd3MgdG8gbWFyaw0KYSBmdW5jdGlvbiB0byBiZSBzbGVlcGFibGUiIGZyb20g
QmVuamFtaW4gVGlzc29pcmVzKS4NCg0KVGhlIHBhdGNoIHdoZXJlIEkgd291bGQgdXNlIHBlci1w
YXJhbWV0ZXIgS0ZfVFJVU1RFRF9BUkdTIGlzDQpudW1iZXIgOC4gSSBhbHNvIHVzZWQgeW91ciBu
ZXcgQVBJIGluIHBhdGNoIDcgYW5kIGl0IHdvcmtzIHdlbGwuDQoNCkkgZGlkbid0IHJlcG9zdCwg
YXMgSSdtIHdhaXRpbmcgZm9yIGNvbW1lbnRzIG9uIHY4Lg0KDQpUaGFua3MNCg0KUm9iZXJ0bw0K
