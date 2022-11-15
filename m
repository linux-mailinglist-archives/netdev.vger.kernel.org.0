Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D4C629B59
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiKOOAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:00:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230440AbiKOOAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:00:44 -0500
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D24B2AE1B;
        Tue, 15 Nov 2022 06:00:40 -0800 (PST)
Received: from dggemv703-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NBSVm5t8dzmVym;
        Tue, 15 Nov 2022 22:00:16 +0800 (CST)
Received: from kwepemm600014.china.huawei.com (7.193.23.54) by
 dggemv703-chm.china.huawei.com (10.3.19.46) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:00:37 +0800
Received: from dggpemm500005.china.huawei.com (7.185.36.74) by
 kwepemm600014.china.huawei.com (7.193.23.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 15 Nov 2022 22:00:37 +0800
Received: from dggpemm500005.china.huawei.com ([7.185.36.74]) by
 dggpemm500005.china.huawei.com ([7.185.36.74]) with mapi id 15.01.2375.031;
 Tue, 15 Nov 2022 22:00:37 +0800
From:   "Lanhao (Lan)" <lanhao@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "huangguangbin (A)" <huangguangbin2@huawei.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shenjian (K)" <shenjian15@huawei.com>
Subject: Re: [PATCH net-next 1/4] net: hns3: refine the tcam key convert
 handle
Thread-Topic: [PATCH net-next 1/4] net: hns3: refine the tcam key convert
 handle
Thread-Index: Adj4+p1pXXKSqJpkU0i5PY69KbRjGg==
Date:   Tue, 15 Nov 2022 14:00:37 +0000
Message-ID: <fc3431dc55be4968909fb746e4c1d454@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.67.102.37]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Q2FuIHlvdSBwbGVhc2UgZXhwbGFpbiB3aHkgZG8geW91IG5lZWQgc3BlY2lhbCBkZWZpbmUgZm9y
IGJvb2xlYW4gQU5EPw0Kd2UgdXNlICcmJywganVzdCBkZWZpbmUgYSBiaXR3aXNlIEFORCwgbm90
IGRlZmluZSBib29sZWFuIEFORC4NCg0KT24gVHVlLCBTZXAgMjgsIDIwMjIgYXQgMTA6Mjg6MDJB
TSArMDgwMCwgTGVvbiBSb21hbm92c2t5IHdyb3RlOg0KPk9uIFR1ZSwgU2VwIDI3LCAyMDIyIGF0
IDA3OjEyOjAyUE0gKzA4MDAsIEd1YW5nYmluIEh1YW5nIHdyb3RlOg0KPj4gRnJvbTogSmlhbiBT
aGVuIDxzaGVuamlhbjE1QGh1YXdlaS5jb20+DQo+PiANCj4+IFRoZSBleHByZXNzaW9uICcoayBe
IH52KScgaXMgZXhhY2x0eSAnKGsgJiB2KScsIGFuZCAnKGsgJiB2KSAmIGsnIGlzIA0KPj4gZXhh
Y2x0eSAnayAmIHYnLiBTbyBzaW1wbGlmeSB0aGUgZXhwcmVzc2lvbiBmb3IgdGNhbSBrZXkgY29u
dmVydC4NCj4+IA0KPj4gSXQgYWxzbyBhZGQgbmVjZXNzYXJ5IGJyYWNrZXRzIGZvciB0aGVtLg0K
Pj4gDQo+PiBTaWduZWQtb2ZmLWJ5OiBKaWFuIFNoZW4gPHNoZW5qaWFuMTVAaHVhd2VpLmNvbT4N
Cj4+IFNpZ25lZC1vZmYtYnk6IEd1YW5nYmluIEh1YW5nIDxodWFuZ2d1YW5nYmluMkBodWF3ZWku
Y29tPg0KPj4gLS0tDQo+PiAgLi4uL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzcGYv
aGNsZ2VfbWFpbi5oICAgfCAxMSArKystLS0tLS0tLQ0KPj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGlu
c2VydGlvbnMoKyksIDggZGVsZXRpb25zKC0pDQo+PiANCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzcGYvaGNsZ2VfbWFpbi5oIA0KPj4gYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzcGYvaGNsZ2VfbWFpbi5oDQo+
PiBpbmRleCA0OTViNjM5YjBkYzIuLjU5YmZhY2M2ODdjOSAxMDA2NDQNCj4+IC0tLSBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huczNwZi9oY2xnZV9tYWluLmgNCj4+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huczNwZi9oY2xnZV9tYWlu
LmgNCj4+IEBAIC04MjcsMTUgKzgyNywxMCBAQCBzdHJ1Y3QgaGNsZ2VfdmZfdmxhbl9jZmcgew0K
Pj4gICAqIFRoZW4gZm9yIGlucHV0IGtleShrKSBhbmQgbWFzayh2KSwgd2UgY2FuIGNhbGN1bGF0
ZSB0aGUgdmFsdWUgYnkNCj4+ICAgKiB0aGUgZm9ybXVsYWU6DQo+PiAgICoJeCA9ICh+aykgJiB2
DQo+PiAtICoJeSA9IChrIF4gfnYpICYgaw0KPj4gKyAqCXkgPSBrICYgdg0KPj4gICAqLw0KPj4g
LSNkZWZpbmUgY2FsY194KHgsIGssIHYpICh4ID0gfihrKSAmICh2KSkgLSNkZWZpbmUgY2FsY195
KHksIGssIHYpIFwNCj4+IC0JZG8geyBcDQo+PiAtCQljb25zdCB0eXBlb2YoaykgX2tfID0gKGsp
OyBcDQo+PiAtCQljb25zdCB0eXBlb2YodikgX3ZfID0gKHYpOyBcDQo+PiAtCQkoeSkgPSAoX2tf
IF4gfl92XykgJiAoX2tfKTsgXA0KPj4gLQl9IHdoaWxlICgwKQ0KPj4gKyNkZWZpbmUgY2FsY194
KHgsIGssIHYpICgoeCkgPSB+KGspICYgKHYpKSAjZGVmaW5lIGNhbGNfeSh5LCBrLCB2KSANCj4+
ICsoKHkpID0gKGspICYgKHYpKQ0KPg0KPkNhbiB5b3UgcGxlYXNlIGV4cGxhaW4gd2h5IGRvIHlv
dSBuZWVkIHNwZWNpYWwgZGVmaW5lIGZvciBib29sZWFuIEFORD8NCj4NCj5UaGFua3MNCndlIHVz
ZSAnJicsIGp1c3QgZGVmaW5lIGEgYml0d2lzZSBBTkQsIG5vdCBkZWZpbmUgYm9vbGVhbiBBTkQu
DQo+DQo+PiAgDQo+PiAgI2RlZmluZSBIQ0xHRV9NQUNfU1RBVFNfRklFTERfT0ZGKGYpIChvZmZz
ZXRvZihzdHJ1Y3QgDQo+PiBoY2xnZV9tYWNfc3RhdHMsIGYpKSAgI2RlZmluZSBIQ0xHRV9TVEFU
U19SRUFEKHAsIG9mZnNldCkgKCoodTY0IA0KPj4gKikoKHU4ICopKHApICsgKG9mZnNldCkpKQ0K
Pj4gLS0NCj4+IDIuMzMuMA0KPj4gDQo+DQoNCi0tLS0t08q8/tStvP4tLS0tLQ0Kt6K8/sjLOiBM
ZW9uIFJvbWFub3Zza3kgPGxlb25Aa2VybmVsLm9yZz4gDQq3osvNyrG85DogMjAyMsTqOdTCMjjI
1SAxODoyOQ0KytW8/sjLOiBodWFuZ2d1YW5nYmluIChBKSA8aHVhbmdndWFuZ2JpbjJAaHVhd2Vp
LmNvbT4NCrOty806IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGt1YmFAa2VybmVsLm9yZzsgZWR1bWF6
ZXRAZ29vZ2xlLmNvbTsgcGFiZW5pQHJlZGhhdC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IHNoZW5qaWFuIChLKSA8c2hlbmppYW4xNUBo
dWF3ZWkuY29tPjsgTGFuaGFvIChMYW4pIDxsYW5oYW9AaHVhd2VpLmNvbT4NCtb3zOI6IFJlOiBb
UEFUQ0ggbmV0LW5leHQgMS80XSBuZXQ6IGhuczM6IHJlZmluZSB0aGUgdGNhbSBrZXkgY29udmVy
dCBoYW5kbGUNCg0KT24gVHVlLCBTZXAgMjcsIDIwMjIgYXQgMDc6MTI6MDJQTSArMDgwMCwgR3Vh
bmdiaW4gSHVhbmcgd3JvdGU6DQo+IEZyb206IEppYW4gU2hlbiA8c2hlbmppYW4xNUBodWF3ZWku
Y29tPg0KPiANCj4gVGhlIGV4cHJlc3Npb24gJyhrIF4gfnYpJyBpcyBleGFjbHR5ICcoayAmIHYp
JywgYW5kICcoayAmIHYpICYgaycgaXMgDQo+IGV4YWNsdHkgJ2sgJiB2Jy4gU28gc2ltcGxpZnkg
dGhlIGV4cHJlc3Npb24gZm9yIHRjYW0ga2V5IGNvbnZlcnQuDQo+IA0KPiBJdCBhbHNvIGFkZCBu
ZWNlc3NhcnkgYnJhY2tldHMgZm9yIHRoZW0uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKaWFuIFNo
ZW4gPHNoZW5qaWFuMTVAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogR3VhbmdiaW4gSHVh
bmcgPGh1YW5nZ3VhbmdiaW4yQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgLi4uL25ldC9ldGhlcm5l
dC9oaXNpbGljb24vaG5zMy9obnMzcGYvaGNsZ2VfbWFpbi5oICAgfCAxMSArKystLS0tLS0tLQ0K
PiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgOCBkZWxldGlvbnMoLSkNCj4gDQo+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzcGYv
aGNsZ2VfbWFpbi5oIA0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2hu
czNwZi9oY2xnZV9tYWluLmgNCj4gaW5kZXggNDk1YjYzOWIwZGMyLi41OWJmYWNjNjg3YzkgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huczNwZi9o
Y2xnZV9tYWluLmgNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMv
aG5zM3BmL2hjbGdlX21haW4uaA0KPiBAQCAtODI3LDE1ICs4MjcsMTAgQEAgc3RydWN0IGhjbGdl
X3ZmX3ZsYW5fY2ZnIHsNCj4gICAqIFRoZW4gZm9yIGlucHV0IGtleShrKSBhbmQgbWFzayh2KSwg
d2UgY2FuIGNhbGN1bGF0ZSB0aGUgdmFsdWUgYnkNCj4gICAqIHRoZSBmb3JtdWxhZToNCj4gICAq
CXggPSAofmspICYgdg0KPiAtICoJeSA9IChrIF4gfnYpICYgaw0KPiArICoJeSA9IGsgJiB2DQo+
ICAgKi8NCj4gLSNkZWZpbmUgY2FsY194KHgsIGssIHYpICh4ID0gfihrKSAmICh2KSkgLSNkZWZp
bmUgY2FsY195KHksIGssIHYpIFwNCj4gLQlkbyB7IFwNCj4gLQkJY29uc3QgdHlwZW9mKGspIF9r
XyA9IChrKTsgXA0KPiAtCQljb25zdCB0eXBlb2YodikgX3ZfID0gKHYpOyBcDQo+IC0JCSh5KSA9
IChfa18gXiB+X3ZfKSAmIChfa18pOyBcDQo+IC0JfSB3aGlsZSAoMCkNCj4gKyNkZWZpbmUgY2Fs
Y194KHgsIGssIHYpICgoeCkgPSB+KGspICYgKHYpKSAjZGVmaW5lIGNhbGNfeSh5LCBrLCB2KSAN
Cj4gKygoeSkgPSAoaykgJiAodikpDQoNCkNhbiB5b3UgcGxlYXNlIGV4cGxhaW4gd2h5IGRvIHlv
dSBuZWVkIHNwZWNpYWwgZGVmaW5lIGZvciBib29sZWFuIEFORD8NCg0KVGhhbmtzDQoNCj4gIA0K
PiAgI2RlZmluZSBIQ0xHRV9NQUNfU1RBVFNfRklFTERfT0ZGKGYpIChvZmZzZXRvZihzdHJ1Y3Qg
DQo+IGhjbGdlX21hY19zdGF0cywgZikpICAjZGVmaW5lIEhDTEdFX1NUQVRTX1JFQUQocCwgb2Zm
c2V0KSAoKih1NjQgDQo+ICopKCh1OCAqKShwKSArIChvZmZzZXQpKSkNCj4gLS0NCj4gMi4zMy4w
DQo+IA0K
