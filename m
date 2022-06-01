Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33B5453A2A4
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 12:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245486AbiFAKdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 06:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232851AbiFAKdo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 06:33:44 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3415A69CFD;
        Wed,  1 Jun 2022 03:33:42 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.53])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4LClnX0p3Rz1K98Z;
        Wed,  1 Jun 2022 18:32:00 +0800 (CST)
Received: from dggpeml500026.china.huawei.com (7.185.36.106) by
 canpemm500005.china.huawei.com (7.192.104.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Wed, 1 Jun 2022 18:33:39 +0800
Received: from dggpeml500026.china.huawei.com ([7.185.36.106]) by
 dggpeml500026.china.huawei.com ([7.185.36.106]) with mapi id 15.01.2375.024;
 Wed, 1 Jun 2022 18:33:39 +0800
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
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggdjQsYnBmLW5leHRdIHNhbXBsZXMvYnBmOiBjaGVj?=
 =?utf-8?Q?k_detach_prog_exist_or_not_in_xdp=5Ffwd?=
Thread-Topic: [PATCH v4,bpf-next] samples/bpf: check detach prog exist or not
 in xdp_fwd
Thread-Index: AQHYdOeYthSV0XjomkS2wUDhrYtil605wyQAgACYzaA=
Date:   Wed, 1 Jun 2022 10:33:39 +0000
Message-ID: <6c5bdb8886784d1298cc954a7b1027bf@huawei.com>
References: <20220531121804.194901-1-shaozhengchao@huawei.com>
 <87pmjs7n1z.fsf@toke.dk>
In-Reply-To: <87pmjs7n1z.fsf@toke.dk>
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

DQotLS0tLemCruS7tuWOn+S7ti0tLS0tDQrlj5Hku7bkuro6IFRva2UgSMO4aWxhbmQtSsO4cmdl
bnNlbiBbbWFpbHRvOnRva2VAa2VybmVsLm9yZ10gDQrlj5HpgIHml7bpl7Q6IDIwMjLlubQ25pyI
MeaXpSAxNzoyNQ0K5pS25Lu25Lq6OiBzaGFvemhlbmdjaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdl
aS5jb20+OyBicGZAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBhc3RAa2VybmVsLm9yZzsgZGFuaWVsQGlvZ2VhcmJv
eC5uZXQ7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgaGF3a0BrZXJuZWwu
b3JnOyBqb2huLmZhc3RhYmVuZEBnbWFpbC5jb207IGFuZHJpaUBrZXJuZWwub3JnOyBrYWZhaUBm
Yi5jb207IHNvbmdsaXVicmF2aW5nQGZiLmNvbTsgeWhzQGZiLmNvbTsga3BzaW5naEBrZXJuZWwu
b3JnDQrmioTpgIE6IHdlaXlvbmdqdW4gKEEpIDx3ZWl5b25nanVuMUBodWF3ZWkuY29tPjsgc2hh
b3poZW5nY2hhbyA8c2hhb3poZW5nY2hhb0BodWF3ZWkuY29tPjsgeXVlaGFpYmluZyA8eXVlaGFp
YmluZ0BodWF3ZWkuY29tPg0K5Li76aKYOiBSZTogW1BBVENIIHY0LGJwZi1uZXh0XSBzYW1wbGVz
L2JwZjogY2hlY2sgZGV0YWNoIHByb2cgZXhpc3Qgb3Igbm90IGluIHhkcF9md2QNCg0KWmhlbmdj
aGFvIFNoYW8gPHNoYW96aGVuZ2NoYW9AaHVhd2VpLmNvbT4gd3JpdGVzOg0KDQo+IEJlZm9yZSBk
ZXRhY2ggdGhlIHByb2csIHdlIHNob3VsZCBjaGVjayBkZXRhY2ggcHJvZyBleGlzdCBvciBub3Qu
DQo+DQo+IFNpZ25lZC1vZmYtYnk6IFpoZW5nY2hhbyBTaGFvIDxzaGFvemhlbmdjaGFvQGh1YXdl
aS5jb20+DQoNClRoZSBsb2dpYyBsb29rcyBnb29kIG5vdywganVzdCBzcG90dGVkIG9uZSBpc3N1
ZSB3aXRoIHRoZSB1c2Ugb2YgJ3JldHVybiBlcnJubycgKHdoaWNoIEkganVzdCByZWFsaXNlZCBJ
IHN1Z2dlc3RlZCBvbiB0aGUgbGFzdCB2ZXJzaW9uLCBzb3JyeSBhYm91dCB0aGF0KS4NCg0KPiAg
c2FtcGxlcy9icGYveGRwX2Z3ZF91c2VyLmMgfCA2MiANCj4gKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKystLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA1MyBpbnNlcnRpb25zKCspLCA5
IGRlbGV0aW9ucygtKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvc2FtcGxlcy9icGYveGRwX2Z3ZF91c2Vy
LmMgYi9zYW1wbGVzL2JwZi94ZHBfZndkX3VzZXIuYyANCj4gaW5kZXggMTgyODQ4N2JhZTlhLi5h
NGJhNTM4OTE2NTMgMTAwNjQ0DQo+IC0tLSBhL3NhbXBsZXMvYnBmL3hkcF9md2RfdXNlci5jDQo+
ICsrKyBiL3NhbXBsZXMvYnBmL3hkcF9md2RfdXNlci5jDQo+IEBAIC00NywxNyArNDcsNjEgQEAg
c3RhdGljIGludCBkb19hdHRhY2goaW50IGlkeCwgaW50IHByb2dfZmQsIGludCBtYXBfZmQsIGNv
bnN0IGNoYXIgKm5hbWUpDQo+ICAJcmV0dXJuIGVycjsNCj4gIH0NCj4gIA0KPiAtc3RhdGljIGlu
dCBkb19kZXRhY2goaW50IGlkeCwgY29uc3QgY2hhciAqbmFtZSkNCj4gK3N0YXRpYyBpbnQgZG9f
ZGV0YWNoKGludCBpZmluZGV4LCBjb25zdCBjaGFyICppZm5hbWUsIGNvbnN0IGNoYXIgDQo+ICsq
YXBwX25hbWUpDQo+ICB7DQo+IC0JaW50IGVycjsNCj4gKwlMSUJCUEZfT1BUUyhicGZfeGRwX2F0
dGFjaF9vcHRzLCBvcHRzKTsNCj4gKwlzdHJ1Y3QgYnBmX3Byb2dfaW5mbyBwcm9nX2luZm8gPSB7
fTsNCj4gKwljaGFyIHByb2dfbmFtZVtCUEZfT0JKX05BTUVfTEVOXTsNCj4gKwlfX3UzMiBpbmZv
X2xlbiwgY3Vycl9wcm9nX2lkOw0KPiArCWludCBwcm9nX2ZkOw0KPiArCWludCBlcnIgPSAxOw0K
PiArDQo+ICsJaWYgKGJwZl94ZHBfcXVlcnlfaWQoaWZpbmRleCwgeGRwX2ZsYWdzLCAmY3Vycl9w
cm9nX2lkKSkgew0KPiArCQlwcmludGYoIkVSUk9SOiBicGZfeGRwX3F1ZXJ5X2lkIGZhaWxlZCAo
JXMpXG4iLA0KPiArCQkgICAgICAgc3RyZXJyb3IoZXJybm8pKTsNCj4gKwkJcmV0dXJuIC1lcnJu
bzsNCg0KVGhlIHByaW50ZiBhYm92ZSBtYXkgb3ZlcnJpZGUgZXJybm8sIHNvIHRoaXMgY291bGQg
cmV0dXJuIDA7IHRoZSBhY3R1YWwgcmV0dXJuIHZhbHVlIGlzIG5vdCByZWFsbHkgdXNlZCBieSB0
aGUgY2FsbGVyLCBzbyB5b3UgY291bGQganVzdCBhbHdheXMgJ3JldHVybiAtMScgb3IgJ3JldHVy
biBlcnInLg0KDQo+ICsJfQ0KPiArDQo+ICsJaWYgKCFjdXJyX3Byb2dfaWQpIHsNCj4gKwkJcHJp
bnRmKCJFUlJPUjogZmxhZ3MoMHgleCkgeGRwIHByb2cgaXMgbm90IGF0dGFjaGVkIHRvICVzXG4i
LA0KPiArCQkgICAgICAgeGRwX2ZsYWdzLCBpZm5hbWUpOw0KPiArCQlnb3RvIGVycl9vdXQ7DQoN
CkRvZXNuJ3QgcmVhbGx5IG5lZWQgYSBsYWJlbCwganVzdCBkbyBhIGRpcmVjdCByZXR1cm4gaGVy
ZSBhcyB3ZWxsLg0KDQo+ICsJfQ0KPiAgDQo+IC0JZXJyID0gYnBmX3hkcF9kZXRhY2goaWR4LCB4
ZHBfZmxhZ3MsIE5VTEwpOw0KPiAtCWlmIChlcnIgPCAwKQ0KPiAtCQlwcmludGYoIkVSUk9SOiBm
YWlsZWQgdG8gZGV0YWNoIHByb2dyYW0gZnJvbSAlc1xuIiwgbmFtZSk7DQo+ICsJaW5mb19sZW4g
PSBzaXplb2YocHJvZ19pbmZvKTsNCj4gKwlwcm9nX2ZkID0gYnBmX3Byb2dfZ2V0X2ZkX2J5X2lk
KGN1cnJfcHJvZ19pZCk7DQo+ICsJaWYgKHByb2dfZmQgPCAwKSB7DQo+ICsJCXByaW50ZigiRVJS
T1I6IGJwZl9wcm9nX2dldF9mZF9ieV9pZCBmYWlsZWQgKCVzKVxuIiwNCj4gKwkJICAgICAgIHN0
cmVycm9yKGVycm5vKSk7DQo+ICsJCXJldHVybiAtZXJybm87DQoNClNhbWUgaXNzdWUgYXMgYWJv
dmUgd2l0aCBlcnJubyBiZWluZyBvdmVyd3JpdHRlbi4NCg0KPiArCX0NCj4gKw0KPiArCWVyciA9
IGJwZl9vYmpfZ2V0X2luZm9fYnlfZmQocHJvZ19mZCwgJnByb2dfaW5mbywgJmluZm9fbGVuKTsN
Cj4gKwlpZiAoZXJyKSB7DQo+ICsJCXByaW50ZigiRVJST1I6IGJwZl9vYmpfZ2V0X2luZm9fYnlf
ZmQgZmFpbGVkICglcylcbiIsDQo+ICsJCSAgICAgICBzdHJlcnJvcihlcnJubykpOw0KPiArCQln
b3RvIGNsb3NlX291dDsNCj4gKwl9DQo+ICsJc25wcmludGYocHJvZ19uYW1lLCBzaXplb2YocHJv
Z19uYW1lKSwgIiVzX3Byb2ciLCBhcHBfbmFtZSk7DQo+ICsJcHJvZ19uYW1lW0JQRl9PQkpfTkFN
RV9MRU4gLSAxXSA9ICdcMCc7DQo+ICsNCj4gKwlpZiAoc3RyY21wKHByb2dfaW5mby5uYW1lLCBw
cm9nX25hbWUpKSB7DQo+ICsJCXByaW50ZigiRVJST1I6ICVzIGlzbid0IGF0dGFjaGVkIHRvICVz
XG4iLCBhcHBfbmFtZSwgaWZuYW1lKTsNCj4gKwkJZXJyID0gMTsNCj4gKwl9IGVsc2Ugew0KDQpZ
b3UgY2FuIHNhdmUgYSBsZXZlbCBvZiBpbmRlbnRhdGlvbiBieSBhZGRpbmcgYSAnZ290byBjbG9z
ZV9vdXQnIGFmdGVyICdlcnI9MScgaW5zdGVhZCBvZiB1c2luZyBhbiAnZWxzZScgYmxvY2suDQoN
Cj4gKwkJb3B0cy5vbGRfcHJvZ19mZCA9IHByb2dfZmQ7DQo+ICsJCWVyciA9IGJwZl94ZHBfZGV0
YWNoKGlmaW5kZXgsIHhkcF9mbGFncywgJm9wdHMpOw0KPiArCQlpZiAoZXJyIDwgMCkNCj4gKwkJ
CXByaW50ZigiRVJST1I6IGZhaWxlZCB0byBkZXRhY2ggcHJvZ3JhbSBmcm9tICVzICglcylcbiIs
DQo+ICsJCQkgICAgICAgaWZuYW1lLCBzdHJlcnJvcihlcnJubykpOw0KPiArCQkvKiBUT0RPOiBS
ZW1lbWJlciB0byBjbGVhbnVwIG1hcCwgd2hlbiBhZGRpbmcgdXNlIG9mIHNoYXJlZCBtYXANCj4g
KwkJICogIGJwZl9tYXBfZGVsZXRlX2VsZW0oKG1hcF9mZCwgJmlkeCk7DQo+ICsJCSAqLw0KPiAr
CX0NCj4gIA0KPiAtCS8qIFRPRE86IFJlbWVtYmVyIHRvIGNsZWFudXAgbWFwLCB3aGVuIGFkZGlu
ZyB1c2Ugb2Ygc2hhcmVkIG1hcA0KPiAtCSAqICBicGZfbWFwX2RlbGV0ZV9lbGVtKChtYXBfZmQs
ICZpZHgpOw0KPiAtCSAqLw0KPiArY2xvc2Vfb3V0Og0KPiArCWNsb3NlKHByb2dfZmQpOw0KPiAr
ZXJyX291dDoNCg0KZG9uJ3QgbmVlZCB0aGUgZXJyX291dCBsYWJlbCwgc2VlIGFib3ZlLg0KDQot
VG9rZQ0KDQpIaSBUb2tlOg0KCVRoYW5rIHlvdSBmb3IgeW91ciByZXBseS4gSSB3aWxsIGZpeCBp
dCBpbiBuZXh0IHBhdGNoLg0KDQpaaGVuZ2NoYW8gU2hhbw0KDQo=
