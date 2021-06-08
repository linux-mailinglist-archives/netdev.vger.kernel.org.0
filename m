Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBF8039EC42
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:39:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFHClG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:41:06 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:4503 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbhFHClF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 22:41:05 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FzZ9y1kvqzZfs3;
        Tue,  8 Jun 2021 10:36:22 +0800 (CST)
Received: from dggema769-chm.china.huawei.com (10.1.198.211) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2176.2; Tue, 8 Jun 2021 10:39:11 +0800
Received: from dggeme760-chm.china.huawei.com (10.3.19.106) by
 dggema769-chm.china.huawei.com (10.1.198.211) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Tue, 8 Jun 2021 10:39:10 +0800
Received: from dggeme760-chm.china.huawei.com ([10.6.80.70]) by
 dggeme760-chm.china.huawei.com ([10.6.80.70]) with mapi id 15.01.2176.012;
 Tue, 8 Jun 2021 10:39:11 +0800
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
Thread-Index: AQHXWOGc9Q9RY5DeKECVhQca9yM8QKsD1uUAgAUJqwCAAIxtYA==
Date:   Tue, 8 Jun 2021 02:39:10 +0000
Message-ID: <b0dce8ff570541788137990d6fddc3c2@huawei.com>
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

U29ycnkgYWdhaW4sIEkgaW50cm9kdWNlIGEgYnVnIHRvIGtlcm5lbCwgSSB3aWxsIGRvIGl0IGNh
cmVmdWxseSBsYXRlci4NCg0KLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0K5Y+R5Lu25Lq6OiB5dWVo
YWliaW5nIA0K5Y+R6YCB5pe26Ze0OiAyMDIx5bm0NuaciDjml6UgMTA6MTYNCuaUtuS7tuS6ujog
cGF0Y2h3b3JrLWJvdCtuZXRkZXZicGZAa2VybmVsLm9yZzsgemhlbmd5b25nanVuIDx6aGVuZ3lv
bmdqdW4zQGh1YXdlaS5jb20+DQrmioTpgIE6IGptYWxveUByZWRoYXQuY29tOyB5aW5nLnh1ZUB3
aW5kcml2ZXIuY29tOyBkYXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7IG5ldGRl
dkB2Z2VyLmtlcm5lbC5vcmc7IHRpcGMtZGlzY3Vzc2lvbkBsaXN0cy5zb3VyY2Vmb3JnZS5uZXQ7
IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCuS4u+mimDogUmU6IFtQQVRDSCBuZXQtbmV4
dF0gdGlwYzogUmV0dXJuIHRoZSBjb3JyZWN0IGVycm5vIGNvZGUNCg0KDQpPbiAyMDIxLzYvNSA1
OjIwLCBwYXRjaHdvcmstYm90K25ldGRldmJwZkBrZXJuZWwub3JnIHdyb3RlOg0KPiBIZWxsbzoN
Cj4gDQo+IFRoaXMgcGF0Y2ggd2FzIGFwcGxpZWQgdG8gbmV0ZGV2L25ldC1uZXh0LmdpdCAocmVm
cy9oZWFkcy9tYXN0ZXIpOg0KDQpUaGlzIHNob3VsZCBub3QgYmUgYXBwbGllZC4NCg0KdGlwY19u
b2RlX3htaXQoKSBub3cgY2hlY2sgLUVOT0JVRlMgcmF0aGVyIHRoYW4gLUVOT01FTS4NCg0KWW9u
Z2p1biwgbWF5YmUgeW91IGZpeCB0aGlzIG5vdz8NCg0KPiANCj4gT24gRnJpLCA0IEp1biAyMDIx
IDA5OjQ3OjAyICswODAwIHlvdSB3cm90ZToNCj4+IFdoZW4ga2FsbG9jIG9yIGttZW1kdXAgZmFp
bGVkLCBzaG91bGQgcmV0dXJuIEVOT01FTSByYXRoZXIgdGhhbiBFTk9CVUYuDQo+Pg0KPj4gU2ln
bmVkLW9mZi1ieTogWmhlbmcgWW9uZ2p1biA8emhlbmd5b25nanVuM0BodWF3ZWkuY29tPg0KPj4g
LS0tDQo+PiAgbmV0L3RpcGMvbGluay5jIHwgNiArKystLS0NCj4+ICAxIGZpbGUgY2hhbmdlZCwg
MyBpbnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gSGVyZSBpcyB0aGUgc3VtbWFy
eSB3aXRoIGxpbmtzOg0KPiAgIC0gW25ldC1uZXh0XSB0aXBjOiBSZXR1cm4gdGhlIGNvcnJlY3Qg
ZXJybm8gY29kZQ0KPiAgICAgaHR0cHM6Ly9naXQua2VybmVsLm9yZy9uZXRkZXYvbmV0LW5leHQv
Yy8wZWZlYTNjNjQ5ZjANCj4gDQo+IFlvdSBhcmUgYXdlc29tZSwgdGhhbmsgeW91IQ0KPiAtLQ0K
PiBEZWV0LWRvb3QtZG90LCBJIGFtIGEgYm90Lg0KPiBodHRwczovL2tvcmcuZG9jcy5rZXJuZWwu
b3JnL3BhdGNod29yay9wd2JvdC5odG1sDQo+IA0KPiANCj4gLg0KPiANCg==
