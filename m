Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F83113A4B
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 04:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbfLEDSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 22:18:35 -0500
Received: from mx20.baidu.com ([111.202.115.85]:59991 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728449AbfLEDSe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 22:18:34 -0500
X-Greylist: delayed 4983 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Dec 2019 22:18:32 EST
Received: from BJHW-Mail-Ex14.internal.baidu.com (unknown [10.127.64.37])
        by Forcepoint Email with ESMTPS id 5C3B667C305C3;
        Thu,  5 Dec 2019 11:18:22 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex14.internal.baidu.com (10.127.64.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1713.5; Thu, 5 Dec 2019 11:18:23 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 5 Dec 2019 11:18:23 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTog562U5aSNOiDnrZTlpI06IFtQQVRD?=
 =?utf-8?B?SF0gcGFnZV9wb29sOiBtYXJrIHVuYm91bmQgbm9kZSBwYWdlIGFzIHJldXNh?=
 =?utf-8?Q?ble_pages?=
Thread-Topic: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTog562U5aSNOiBbUEFUQ0hdIHBhZ2Vf?=
 =?utf-8?Q?pool:_mark_unbound_node_page_as_reusable_pages?=
Thread-Index: AQHVqwayi5QrKWQh5UWha5lw3I639qequlQw//+EaICAAIiS4P//fa6AgACIR2D//350gAARIFtw//+AQoD//3jLoA==
Date:   Thu, 5 Dec 2019 03:18:22 +0000
Message-ID: <3a0d273cb57146d3b2f5c849569fb244@baidu.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
 <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
 <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
 <68135c0148894aa3b26db19120fb7bac@baidu.com>
 <3e3b1e0c-e7e0-eea2-b1b5-20bf2b8fc34b@huawei.com>
 <cd63eccb89bb406ca6edea46aee60e3a@baidu.com>
 <cc336ff3-b729-539e-59f7-67c6c37663d9@huawei.com>
 <504bf0958f424a2c9add3a84543c45c6@baidu.com>
 <0c5b19c3-b639-b990-73a1-a1300d417221@huawei.com>
In-Reply-To: <0c5b19c3-b639-b990-73a1-a1300d417221@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.17]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex14_2019-12-05 11:18:23:376
x-baidu-bdmsfe-viruscheck: BJHW-Mail-Ex14_GRAY_Inside_WithoutAtta_2019-12-05
 11:18:23:360
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+ID4+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9wYXRjaHdvcmsvcGF0Y2gvMTEyNTc4
OS8NCj4gPg0KPiA+DQo+ID4gV2hhdCBpcyBzdGF0dXMgb2YgdGhpcyBwYXRjaD8gSSB0aGluayB5
b3Ugc2hvdWxkIGZpeCB5b3VyIGZpcm13YXJlIG9yDQo+ID4gYmlvcw0KPiANCj4gSGF2ZSBub3Qg
cmVhY2hlZCBhIGNvbmNsdXNpb24geWV0Lg0KDQpJIHRoaW5rIGl0IHdpbGwgbmV2ZXIgYmUgYWNj
ZXB0ZWQNCg0KPiANCj4gPg0KPiA+IENvbnNpZGVyIHRoZSBiZWxvdyBjb25kaXRpb246DQo+ID4N
Cj4gPiB0aGVyZSBpcyB0d28gbnVtYSBub2RlLCBhbmQgTklDIHNpdGVzIG9uIG5vZGUgMiwgYnV0
IE5VTUFfTk9fTk9ERSBpcw0KPiA+IHVzZWQsIHJlY3ljbGUgd2lsbCBmYWlsIGR1ZSB0byBwYWdl
X3RvX25pZChwYWdlKSA9PSBudW1hX21lbV9pZCgpLCBhbmQNCj4gcmVhbGxvY2F0ZWQgcGFnZXMg
bWF5YmUgYWx3YXlzIGZyb20gbm9kZSAxLCB0aGVuIHRoZSByZWN5Y2xlIHdpbGwgbmV2ZXINCj4g
c3VjY2Vzcy4NCj4gDQo+IEZvciBwYWdlIHBvb2w6DQo+IA0KPiAxLiBpZiB0aGUgcG9vbC0+cC5u
aWQgIT0gTlVNQV9OT19OT0RFLCB0aGUgcmVjeWNsZSBpcyBhbHdheXMgZGVjaWRlZCBieQ0KPiBj
aGVja2luZyBwYWdlX3RvX25pZChwYWdlKSA9PSBwb29sLT5wLm5pZC4NCj4gDQo+IDIuIG9ubHkg
d2hlbiB0aGUgcG9vbC0+cC5uaWQgPT0gTlVNQV9OT19OT0RFLCB0aGUgbnVtYV9tZW1faWQoKSBp
cw0KPiBjaGVja2VkDQo+ICAgIHRvIGRlY2lkZSB0aGUgcmVjeWNsZS4NCj4gDQo+IFllcywgSWYg
cG9vbC0+cC5uaWQgPT0gTlVNQV9OT19OT0RFLCBhbmQgdGhlIGNwdSB0aGF0IGlzIGRvaW5nIHJl
Y3ljbGluZyBpcw0KPiBjaGFuZ2luZyBlYWNoIHRpbWUsIHRoZSByZWN5Y2xlIG1heSBuZXZlciBz
dWNjZXNzLCBidXQgaXQgaXMgbm90IGNvbW1vbiwgDQoNCldoeSBjYW4gd2UgaWdub3JlIHRoaXMg
Y29uZGl0aW9uLCBhbmQgYWNjZXB0IHlvdXIgaGFyZHdhcmUgd2l0aCBhYm5vcm1hbCBub2RlDQpp
bmZvcm1hdGlvbg0KDQo+YW5kDQo+IGhhdmUgaXRzIG93biBwZXJmb3JtYW5jZSBwZW5hbHR5IHdo
ZW4gY2hhbmdpbmcgdGhlIHJlY3ljbGluZyBjcHUgc28gb2Z0ZW4uDQoNCkkgaGF2ZSBzYWlkIGlm
IGhhcmR3YXJlIHRha2VzIGNhcmUgb2YgbnVtYSBub2RlLCBpdCBzaG91bGQgYmUgYXNzaWduIHdo
ZW4gcGFnZSBwb29sDQpJcyBjcmVhdGVkLCBub3QgZGVwZW5kcyBvbiByZWN5Y2xlLg0KDQpJZiB5
b3UgaW5zaXN0IHlvdXIgaWRlYSwgeW91IGNhbiBzdWJtaXQgeW91IHBhdGNoIGFmdGVyIHRoaXMg
b25lDQoNCi1Sb25nUWluZw0KDQo+IA0KPiANCj4gPg0KPiA+IC1Sb25nUWluZw0KPiA+DQo+ID4N
Cg0K
