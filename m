Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D49BE39EC34
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhFHChy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:37:54 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3462 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230377AbhFHChx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:37:53 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzZ6039Gkz6x6Q;
        Tue,  8 Jun 2021 10:32:56 +0800 (CST)
Received: from dggema718-chm.china.huawei.com (10.3.20.82) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 10:35:59 +0800
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggema718-chm.china.huawei.com (10.3.20.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 10:35:58 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 8 Jun 2021 10:35:58 +0800
From:   zhengyongjun <zhengyongjun3@huawei.com>
To:     yuehaibing <yuehaibing@huawei.com>,
        "patchwork-bot+netdevbpf@kernel.org" 
        <patchwork-bot+netdevbpf@kernel.org>
CC:     "jmaloy@redhat.com" <jmaloy@redhat.com>,
        "ying.xue@windriver.com" <ying.xue@windriver.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "tipc-discussion@lists.sourceforge.net" 
        <tipc-discussion@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHRdIHRpcGM6IFJldHVybiB0aGUgY29y?=
 =?utf-8?Q?rect_errno_code?=
Thread-Topic: [PATCH net-next] tipc: Return the correct errno code
Thread-Index: AQHXWOGc9Q9RY5DeKECVhQca9yM8QKsD1uUAgAUJqwCAAIuC4A==
Date:   Tue, 8 Jun 2021 02:35:58 +0000
Message-ID: <c86d09aa9dae46edaf11e3be44f32459@huawei.com>
References: <20210604014702.2087584-1-zhengyongjun3@huawei.com>
 <162284160438.23356.17911968954229324185.git-patchwork-notify@kernel.org>
 <410bbe52-5ead-4719-d711-8dc355a9a5f4@huawei.com>
In-Reply-To: <410bbe52-5ead-4719-d711-8dc355a9a5f4@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.64]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmtzIGZvciB5b3VyIGFkdmljZSwgSSB3aWxsIGZpeCBpdCByaWdodCBub3cgOikNCg0KLS0t
LS3pgq7ku7bljp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiB5dWVoYWliaW5nIA0K5Y+R6YCB5pe26Ze0
OiAyMDIx5bm0NuaciDjml6UgMTA6MTYNCuaUtuS7tuS6ujogcGF0Y2h3b3JrLWJvdCtuZXRkZXZi
cGZAa2VybmVsLm9yZzsgemhlbmd5b25nanVuIDx6aGVuZ3lvbmdqdW4zQGh1YXdlaS5jb20+DQrm
ioTpgIE6IGptYWxveUByZWRoYXQuY29tOyB5aW5nLnh1ZUB3aW5kcml2ZXIuY29tOyBkYXZlbUBk
YXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IHRp
cGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQ7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmcNCuS4u+mimDogUmU6IFtQQVRDSCBuZXQtbmV4dF0gdGlwYzogUmV0dXJuIHRoZSBj
b3JyZWN0IGVycm5vIGNvZGUNCg0KDQpPbiAyMDIxLzYvNSA1OjIwLCBwYXRjaHdvcmstYm90K25l
dGRldmJwZkBrZXJuZWwub3JnIHdyb3RlOg0KPiBIZWxsbzoNCj4gDQo+IFRoaXMgcGF0Y2ggd2Fz
IGFwcGxpZWQgdG8gbmV0ZGV2L25ldC1uZXh0LmdpdCAocmVmcy9oZWFkcy9tYXN0ZXIpOg0KDQpU
aGlzIHNob3VsZCBub3QgYmUgYXBwbGllZC4NCg0KdGlwY19ub2RlX3htaXQoKSBub3cgY2hlY2sg
LUVOT0JVRlMgcmF0aGVyIHRoYW4gLUVOT01FTS4NCg0KWW9uZ2p1biwgbWF5YmUgeW91IGZpeCB0
aGlzIG5vdz8NCg0KPiANCj4gT24gRnJpLCA0IEp1biAyMDIxIDA5OjQ3OjAyICswODAwIHlvdSB3
cm90ZToNCj4+IFdoZW4ga2FsbG9jIG9yIGttZW1kdXAgZmFpbGVkLCBzaG91bGQgcmV0dXJuIEVO
T01FTSByYXRoZXIgdGhhbiBFTk9CVUYuDQo+Pg0KPj4gU2lnbmVkLW9mZi1ieTogWmhlbmcgWW9u
Z2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KPj4gLS0tDQo+PiAgbmV0L3RpcGMvbGlu
ay5jIHwgNiArKystLS0NCj4+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRl
bGV0aW9ucygtKQ0KPiANCj4gSGVyZSBpcyB0aGUgc3VtbWFyeSB3aXRoIGxpbmtzOg0KPiAgIC0g
W25ldC1uZXh0XSB0aXBjOiBSZXR1cm4gdGhlIGNvcnJlY3QgZXJybm8gY29kZQ0KPiAgICAgaHR0
cHM6Ly9naXQua2VybmVsLm9yZy9uZXRkZXYvbmV0LW5leHQvYy8wZWZlYTNjNjQ5ZjANCj4gDQo+
IFlvdSBhcmUgYXdlc29tZSwgdGhhbmsgeW91IQ0KPiAtLQ0KPiBEZWV0LWRvb3QtZG90LCBJIGFt
IGEgYm90Lg0KPiBodHRwczovL2tvcmcuZG9jcy5rZXJuZWwub3JnL3BhdGNod29yay9wd2JvdC5o
dG1sDQo+IA0KPiANCj4gLg0KPiANCg==
