Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54550113945
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 02:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbfLEBZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 20:25:03 -0500
Received: from mx21.baidu.com ([220.181.3.85]:46778 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728100AbfLEBZD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 20:25:03 -0500
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id 397D2BB498C2A;
        Thu,  5 Dec 2019 09:08:55 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 5 Dec 2019 09:08:56 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 5 Dec 2019 09:08:56 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIHBhZ2VfcG9vbDogbWFyayB1bmJvdW5kIG5vZGUg?=
 =?utf-8?Q?page_as_reusable_pages?=
Thread-Topic: [PATCH] page_pool: mark unbound node page as reusable pages
Thread-Index: AQHVqwayi5QrKWQh5UWha5lw3I639qequlQw
Date:   Thu, 5 Dec 2019 01:08:56 +0000
Message-ID: <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
In-Reply-To: <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.17]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2019-12-05 09:08:56:283
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-12-05
 09:08:56:267
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFl1bnNoZW5nIExpbiBb
bWFpbHRvOmxpbnl1bnNoZW5nQGh1YXdlaS5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDEy
5pyINeaXpSA4OjU1DQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUu
Y29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gc2FlZWRtQG1lbGxhbm94LmNvbQ0KPiDk
uLvpopg6IFJlOiBbUEFUQ0hdIHBhZ2VfcG9vbDogbWFyayB1bmJvdW5kIG5vZGUgcGFnZSBhcyBy
ZXVzYWJsZSBwYWdlcw0KPiANCj4gT24gMjAxOS8xMi80IDE4OjE0LCBMaSBSb25nUWluZyB3cm90
ZToNCj4gPiBzb21lIGRyaXZlcnMgdXNlcyBwYWdlIHBvb2wsIGJ1dCBub3QgcmVxdWlyZSB0byBh
bGxvY2F0ZSBwYWdlIGZyb20NCj4gPiBib3VuZCBub2RlLCBzbyBwb29sLnAubmlkIGlzIE5VTUFf
Tk9fTk9ERSwgYW5kIHRoaXMgZml4ZWQgcGF0Y2ggd2lsbA0KPiA+IGJsb2NrIHRoaXMga2luZCBv
ZiBkcml2ZXIgdG8gcmVjeWNsZQ0KPiA+DQo+ID4gRml4ZXM6IGQ1Mzk0NjEwYjFiYSAoInBhZ2Vf
cG9vbDogRG9uJ3QgcmVjeWNsZSBub24tcmV1c2FibGUgcGFnZXMiKQ0KPiA+IFNpZ25lZC1vZmYt
Ynk6IExpIFJvbmdRaW5nIDxsaXJvbmdxaW5nQGJhaWR1LmNvbT4NCj4gPiBDYzogU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4gLS0tDQo+ID4gIG5ldC9jb3JlL3BhZ2Vf
cG9vbC5jIHwgNCArKystDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9uZXQvY29yZS9wYWdlX3Bvb2wuYyBi
L25ldC9jb3JlL3BhZ2VfcG9vbC5jIGluZGV4DQo+ID4gYTZhZWZlOTg5MDQzLi40MDU0ZGI2ODMx
NzggMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gPiArKysgYi9uZXQv
Y29yZS9wYWdlX3Bvb2wuYw0KPiA+IEBAIC0zMTcsNyArMzE3LDkgQEAgc3RhdGljIGJvb2wgX19w
YWdlX3Bvb2xfcmVjeWNsZV9kaXJlY3Qoc3RydWN0IHBhZ2UNCj4gKnBhZ2UsDQo+ID4gICAqLw0K
PiA+ICBzdGF0aWMgYm9vbCBwb29sX3BhZ2VfcmV1c2FibGUoc3RydWN0IHBhZ2VfcG9vbCAqcG9v
bCwgc3RydWN0IHBhZ2UNCj4gPiAqcGFnZSkgIHsNCj4gPiAtCXJldHVybiAhcGFnZV9pc19wZm1l
bWFsbG9jKHBhZ2UpICYmIHBhZ2VfdG9fbmlkKHBhZ2UpID09IHBvb2wtPnAubmlkOw0KPiA+ICsJ
cmV0dXJuICFwYWdlX2lzX3BmbWVtYWxsb2MocGFnZSkgJiYNCj4gPiArCQkocGFnZV90b19uaWQo
cGFnZSkgPT0gcG9vbC0+cC5uaWQgfHwNCj4gPiArCQkgcG9vbC0+cC5uaWQgPT0gTlVNQV9OT19O
T0RFKTsNCj4gDQo+IElmIEkgdW5kZXJzdGFuZCBpdCBjb3JyZWN0bHksIHlvdSBhcmUgYWxsb3dp
bmcgcmVjeWNsaW5nIHdoZW4NCj4gcG9vbC0+cC5uaWQgaXMgTlVNQV9OT19OT0RFLCB3aGljaCBk
b2VzIG5vdCBzZWVtcyBtYXRjaCB0aGUgY29tbWl0DQo+IGxvZzogInRoaXMgZml4ZWQgcGF0Y2gg
d2lsbCBibG9jayB0aGlzIGtpbmQgb2YgZHJpdmVyIHRvIHJlY3ljbGUiLg0KPiANCj4gTWF5YmUg
eW91IG1lYW4gImNvbW1pdCBkNTM5NDYxMGIxYmEiIGJ5IHRoaXMgZml4ZWQgcGF0Y2g/DQoNCnll
cw0KDQo+IA0KPiBBbHNvLCBtYXliZSBpdCBpcyBiZXR0ZXIgdG8gYWxsb3cgcmVjeWNsaW5nIGlm
IHRoZSBiZWxvdyBjb25kaXRpb24gaXMgbWF0Y2hlZDoNCj4gDQo+IAlwb29sLT5wLm5pZCA9PSBO
VU1BX05PX05PREUgJiYgcGFnZV90b19uaWQocGFnZSkgPT0NCj4gbnVtYV9tZW1faWQoKQ0KDQpJ
ZiBkcml2ZXIgdXNlcyBOVU1BX05PX05PREUsIGl0IGRvZXMgbm90IGNhcmUgbnVtYSBub2RlLCBh
bmQgbWF5YmUgaXRzIHBsYXRmb3JtDQpPbmx5IGhhcyBhIG5vZGUsIHNvIG5vdCBuZWVkIHRvIGNv
bXBhcmUgbGlrZSAicGFnZV90b19uaWQocGFnZSkgPT0gIG51bWFfbWVtX2lkKCkiDQoNCg0KLVJv
bmdRaW5nDQoNCg0KPiANCj4gPiAgfQ0KPiA+DQo+ID4gIHZvaWQgX19wYWdlX3Bvb2xfcHV0X3Bh
Z2Uoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCwgc3RydWN0IHBhZ2UgKnBhZ2UsDQo+ID4NCg0K
