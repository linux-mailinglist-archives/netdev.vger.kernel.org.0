Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F123398242
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 08:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbhFBG66 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 02:58:58 -0400
Received: from szxga08-in.huawei.com ([45.249.212.255]:3338 "EHLO
        szxga08-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231538AbhFBG6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 02:58:46 -0400
Received: from dggeme711-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4Fw08273XBz19PCy;
        Wed,  2 Jun 2021 14:52:18 +0800 (CST)
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggeme711-chm.china.huawei.com (10.1.199.107) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Wed, 2 Jun 2021 14:57:01 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Wed, 2 Jun 2021 14:57:01 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     Sven Eckelmann <sven@narfation.org>,
        "mareklindner@neomailbox.ch" <mareklindner@neomailbox.ch>,
        "sw@simonwunderlich.de" <sw@simonwunderlich.de>,
        "a@unstable.cc" <a@unstable.cc>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "b.a.t.m.a.n@lists.open-mesh.org" <b.a.t.m.a.n@lists.open-mesh.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIIG5ldC1uZXh0XSBiYXRtYW4tYWR2OiBGaXggc3BlbGxp?=
 =?gb2312?Q?ng_mistakes?=
Thread-Topic: [PATCH net-next] batman-adv: Fix spelling mistakes
Thread-Index: AQHXV3pzyoNQoWpoCEyLGF27cSirc6r/wTEAgACHrbA=
Date:   Wed, 2 Jun 2021 06:57:01 +0000
Message-ID: <8b7a220a964f452c8c3ea0c5404c0632@huawei.com>
References: <20210602065603.106030-1-zhengyongjun3@huawei.com>
 <48077100.4opSpZgCWW@ripper>
In-Reply-To: <48077100.4opSpZgCWW@ripper>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIHN1Z2dlc3QgOikNCkluIGZhY3QsIEkgc2VuZCBwYXRjaCB0aHJvdWdo
IHRoZSBweXRob24gc2NyaXB0IG1hZGUgYnkgbXlzZWxmLg0KDQpXaGVuIEkgdXNlIGNvbW1hbmQi
IC4vc2NyaXB0cy9nZXRfbWFpbnRhaW5lci5wbCAwMDAxLWJhdG1hbi1hZHYtRml4LXNwZWxsaW5n
LW1pc3Rha2VzLnBhdGNoIiwgdGhlIGluZm9ybWF0aW9uIGlzOg0KYGBgDQpNYXJlayBMaW5kbmVy
IDxtYXJla2xpbmRuZXJAbmVvbWFpbGJveC5jaD4gKG1haW50YWluZXI6QkFUTUFOIEFEVkFOQ0VE
KQ0KU2ltb24gV3VuZGVybGljaCA8c3dAc2ltb253dW5kZXJsaWNoLmRlPiAobWFpbnRhaW5lcjpC
QVRNQU4gQURWQU5DRUQpDQpBbnRvbmlvIFF1YXJ0dWxsaSA8YUB1bnN0YWJsZS5jYz4gKG1haW50
YWluZXI6QkFUTUFOIEFEVkFOQ0VEKQ0KU3ZlbiBFY2tlbG1hbm4gPHN2ZW5AbmFyZmF0aW9uLm9y
Zz4gKG1haW50YWluZXI6QkFUTUFOIEFEVkFOQ0VEKQ0KIkRhdmlkIFMuIE1pbGxlciIgPGRhdmVt
QGRhdmVtbG9mdC5uZXQ+IChtYWludGFpbmVyOk5FVFdPUktJTkcgW0dFTkVSQUxdKQ0KSmFrdWIg
S2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4gKG1haW50YWluZXI6TkVUV09SS0lORyBbR0VORVJB
TF0pDQpiLmEudC5tLmEubkBsaXN0cy5vcGVuLW1lc2gub3JnIChtb2RlcmF0ZWQgbGlzdDpCQVRN
QU4gQURWQU5DRUQpDQpuZXRkZXZAdmdlci5rZXJuZWwub3JnIChvcGVuIGxpc3Q6TkVUV09SS0lO
RyBbR0VORVJBTF0pDQpsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnIChvcGVuIGxpc3QpDQpg
YGANCg0KTXkgc2VuZCBwYXRjaCBzY3JpcHQgZm9yZ290IHRvIGRlYWwgd2l0aCBsaW5lIGxpa2Ug
dGhpcyhmb3Jnb3QgZGVhbCB3aXRoIGtleSB3b3JkIG1vZGVyYXRlZCBsaXN0KTogIiBiLmEudC5t
LmEubkBsaXN0cy5vcGVuLW1lc2gub3JnIChtb2RlcmF0ZWQgbGlzdDpCQVRNQU4gQURWQU5DRUQp
Ig0KVGhlcmVmb3JlIEkgZm9yZ290IHRvIHNlbmQgaXQgdG8gdGhlIEIuQS5ULk0uQS5OLiBtYWls
aW5nIGxpc3QuDQoNCkkgd2lsbCBmaXggdGhpcywgdGhhbmsgeW91IGZvciB5b3VyIHN1Z2dlc3Qg
OikNCg0KLS0tLS3Tyrz+1K28/i0tLS0tDQq3orz+yMs6IFN2ZW4gRWNrZWxtYW5uIFttYWlsdG86
c3ZlbkBuYXJmYXRpb24ub3JnXSANCreiy83KsbzkOiAyMDIxxOo21MIyyNUgMTQ6NDcNCsrVvP7I
yzogbWFyZWtsaW5kbmVyQG5lb21haWxib3guY2g7IHN3QHNpbW9ud3VuZGVybGljaC5kZTsgYUB1
bnN0YWJsZS5jYzsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsga3ViYUBrZXJuZWwub3JnOyBuZXRkZXZA
dmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyB6aGVuZ3lvbmdq
dW4gPHpoZW5neW9uZ2p1bjNAaHVhd2VpLmNvbT47IGIuYS50Lm0uYS5uQGxpc3RzLm9wZW4tbWVz
aC5vcmcNCtb3zOI6IFJlOiBbUEFUQ0ggbmV0LW5leHRdIGJhdG1hbi1hZHY6IEZpeCBzcGVsbGlu
ZyBtaXN0YWtlcw0KDQpPbiBXZWRuZXNkYXksIDIgSnVuZSAyMDIxIDA4OjU2OjAzIENFU1QgWmhl
bmcgWW9uZ2p1biB3cm90ZToNCj4gRml4IHNvbWUgc3BlbGxpbmcgbWlzdGFrZXMgaW4gY29tbWVu
dHM6DQo+IGNvbnRhaW5nICA9PT4gY29udGFpbmluZw0KPiBkb250ICA9PT4gZG9uJ3QNCj4gZGF0
YXMgID09PiBkYXRhDQo+IGJyb2RjYXN0ICA9PT4gYnJvYWRjYXN0DQo+IA0KPiBTaWduZWQtb2Zm
LWJ5OiBaaGVuZyBZb25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAg
bmV0L2JhdG1hbi1hZHYvYnJpZGdlX2xvb3BfYXZvaWRhbmNlLmMgfCA0ICsrLS0NCj4gIG5ldC9i
YXRtYW4tYWR2L2hhcmQtaW50ZXJmYWNlLmMgICAgICAgIHwgMiArLQ0KPiAgbmV0L2JhdG1hbi1h
ZHYvaGFzaC5oICAgICAgICAgICAgICAgICAgfCAyICstDQo+ICAzIGZpbGVzIGNoYW5nZWQsIDQg
aW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0KDQpZb3UgZm9yZ290IHRvIHNlbmQgaXQg
dG8gdGhlIEIuQS5ULk0uQS5OLiBtYWlsaW5nIGxpc3QuIEFuZCBpdCB0aGVyZWZvcmUgZGlkbid0
IGFwcGVhciBpbiBvdXIgcGF0Y2h3b3JrLiBBbmQgeW91IHNlbmQgc3R1ZmYgZnJvbSB0aGUgZnV0
dXJlIC0gd2hpY2ggaXMgcmF0aGVyIG9kZC4NCg0KQXBwbGllZCBhbnl3YXkuDQoNClRoYW5rcywN
CglTdmVuDQo=
