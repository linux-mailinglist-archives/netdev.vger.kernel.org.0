Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0EF1113995
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbfLECLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:11:06 -0500
Received: from mx21.baidu.com ([220.181.3.85]:47336 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728374AbfLECLF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 21:11:05 -0500
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id 10C59DEE18E2F;
        Thu,  5 Dec 2019 09:55:25 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 5 Dec 2019 09:55:25 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 5 Dec 2019 09:55:25 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gcGFnZV9wb29sOiBtYXJrIHVuYm91?=
 =?utf-8?Q?nd_node_page_as_reusable_pages?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbUEFUQ0hdIHBhZ2VfcG9vbDogbWFyayB1bmJvdW5kIG5vZGUg?=
 =?utf-8?Q?page_as_reusable_pages?=
Thread-Index: AQHVqwayi5QrKWQh5UWha5lw3I639qequlQw//+EaICAAIiS4A==
Date:   Thu, 5 Dec 2019 01:55:25 +0000
Message-ID: <68135c0148894aa3b26db19120fb7bac@baidu.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
 <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
 <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
In-Reply-To: <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.17]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2019-12-05 09:55:26:099
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-12-05
 09:55:26:084
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFl1bnNoZW5nIExpbiBb
bWFpbHRvOmxpbnl1bnNoZW5nQGh1YXdlaS5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDEy
5pyINeaXpSA5OjQ0DQo+IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUu
Y29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gc2FlZWRtQG1lbGxhbm94LmNvbQ0KPiDk
uLvpopg6IFJlOiDnrZTlpI06IFtQQVRDSF0gcGFnZV9wb29sOiBtYXJrIHVuYm91bmQgbm9kZSBw
YWdlIGFzIHJldXNhYmxlDQo+IHBhZ2VzDQo+IA0KPiBPbiAyMDE5LzEyLzUgOTowOCwgTGksUm9u
Z3Fpbmcgd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiAtLS0tLemCruS7tuWOn+S7ti0tLS0tDQo+ID4+
IOWPkeS7tuS6ujogWXVuc2hlbmcgTGluIFttYWlsdG86bGlueXVuc2hlbmdAaHVhd2VpLmNvbV0N
Cj4gPj4g5Y+R6YCB5pe26Ze0OiAyMDE55bm0MTLmnIg15pelIDg6NTUNCj4gPj4g5pS25Lu25Lq6
OiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+OyBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnOw0KPiA+PiBzYWVlZG1AbWVsbGFub3guY29tDQo+ID4+IOS4u+mimDogUmU6IFtQQVRDSF0g
cGFnZV9wb29sOiBtYXJrIHVuYm91bmQgbm9kZSBwYWdlIGFzIHJldXNhYmxlIHBhZ2VzDQo+ID4+
DQo+ID4+IE9uIDIwMTkvMTIvNCAxODoxNCwgTGkgUm9uZ1Fpbmcgd3JvdGU6DQo+ID4+PiBzb21l
IGRyaXZlcnMgdXNlcyBwYWdlIHBvb2wsIGJ1dCBub3QgcmVxdWlyZSB0byBhbGxvY2F0ZSBwYWdl
IGZyb20NCj4gPj4+IGJvdW5kIG5vZGUsIHNvIHBvb2wucC5uaWQgaXMgTlVNQV9OT19OT0RFLCBh
bmQgdGhpcyBmaXhlZCBwYXRjaCB3aWxsDQo+ID4+PiBibG9jayB0aGlzIGtpbmQgb2YgZHJpdmVy
IHRvIHJlY3ljbGUNCj4gPj4+DQo+ID4+PiBGaXhlczogZDUzOTQ2MTBiMWJhICgicGFnZV9wb29s
OiBEb24ndCByZWN5Y2xlIG5vbi1yZXVzYWJsZSBwYWdlcyIpDQo+ID4+PiBTaWduZWQtb2ZmLWJ5
OiBMaSBSb25nUWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ID4+PiBDYzogU2FlZWQgTWFo
YW1lZWQgPHNhZWVkbUBtZWxsYW5veC5jb20+DQo+ID4+PiAtLS0NCj4gPj4+ICBuZXQvY29yZS9w
YWdlX3Bvb2wuYyB8IDQgKysrLQ0KPiA+Pj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KyksIDEgZGVsZXRpb24oLSkNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvcGFn
ZV9wb29sLmMgYi9uZXQvY29yZS9wYWdlX3Bvb2wuYyBpbmRleA0KPiA+Pj4gYTZhZWZlOTg5MDQz
Li40MDU0ZGI2ODMxNzggMTAwNjQ0DQo+ID4+PiAtLS0gYS9uZXQvY29yZS9wYWdlX3Bvb2wuYw0K
PiA+Pj4gKysrIGIvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gPj4+IEBAIC0zMTcsNyArMzE3LDkg
QEAgc3RhdGljIGJvb2wgX19wYWdlX3Bvb2xfcmVjeWNsZV9kaXJlY3Qoc3RydWN0DQo+ID4+PiBw
YWdlDQo+ID4+ICpwYWdlLA0KPiA+Pj4gICAqLw0KPiA+Pj4gIHN0YXRpYyBib29sIHBvb2xfcGFn
ZV9yZXVzYWJsZShzdHJ1Y3QgcGFnZV9wb29sICpwb29sLCBzdHJ1Y3QgcGFnZQ0KPiA+Pj4gKnBh
Z2UpICB7DQo+ID4+PiAtCXJldHVybiAhcGFnZV9pc19wZm1lbWFsbG9jKHBhZ2UpICYmIHBhZ2Vf
dG9fbmlkKHBhZ2UpID09DQo+IHBvb2wtPnAubmlkOw0KPiA+Pj4gKwlyZXR1cm4gIXBhZ2VfaXNf
cGZtZW1hbGxvYyhwYWdlKSAmJg0KPiA+Pj4gKwkJKHBhZ2VfdG9fbmlkKHBhZ2UpID09IHBvb2wt
PnAubmlkIHx8DQo+ID4+PiArCQkgcG9vbC0+cC5uaWQgPT0gTlVNQV9OT19OT0RFKTsNCj4gPj4N
Cj4gPj4gSWYgSSB1bmRlcnN0YW5kIGl0IGNvcnJlY3RseSwgeW91IGFyZSBhbGxvd2luZyByZWN5
Y2xpbmcgd2hlbg0KPiA+PiBwb29sLT5wLm5pZCBpcyBOVU1BX05PX05PREUsIHdoaWNoIGRvZXMg
bm90IHNlZW1zIG1hdGNoIHRoZSBjb21taXQNCj4gPj4gbG9nOiAidGhpcyBmaXhlZCBwYXRjaCB3
aWxsIGJsb2NrIHRoaXMga2luZCBvZiBkcml2ZXIgdG8gcmVjeWNsZSIuDQo+ID4+DQo+ID4+IE1h
eWJlIHlvdSBtZWFuICJjb21taXQgZDUzOTQ2MTBiMWJhIiBieSB0aGlzIGZpeGVkIHBhdGNoPw0K
PiA+DQo+ID4geWVzDQo+ID4NCj4gPj4NCj4gPj4gQWxzbywgbWF5YmUgaXQgaXMgYmV0dGVyIHRv
IGFsbG93IHJlY3ljbGluZyBpZiB0aGUgYmVsb3cgY29uZGl0aW9uIGlzIG1hdGNoZWQ6DQo+ID4+
DQo+ID4+IAlwb29sLT5wLm5pZCA9PSBOVU1BX05PX05PREUgJiYgcGFnZV90b19uaWQocGFnZSkg
PT0NCj4gPj4gbnVtYV9tZW1faWQoKQ0KPiA+DQo+ID4gSWYgZHJpdmVyIHVzZXMgTlVNQV9OT19O
T0RFLCBpdCBkb2VzIG5vdCBjYXJlIG51bWEgbm9kZSwgYW5kIG1heWJlIGl0cw0KPiA+IHBsYXRm
b3JtIE9ubHkgaGFzIGEgbm9kZSwgc28gbm90IG5lZWQgdG8gY29tcGFyZSBsaWtlICJwYWdlX3Rv
X25pZChwYWdlKSA9PQ0KPiBudW1hX21lbV9pZCgpIg0KPiANCj4gTm9ybWFsbHksIGRyaXZlciBk
b2VzIG5vdCBjYXJlIGlmIHRoZSBub2RlIG9mIGEgZGV2aWNlIGlzIE5VTUFfTk9fTk9ERSBvcg0K
PiBub3QsIGl0IGp1c3QgdXNlcyB0aGUgbm9kZSB0aGF0IHJldHVybnMgZnJvbSBkZXZfdG9fbm9k
ZSgpLg0KPiANCj4gRXZlbiBmb3IgbXVsdGkgbm9kZSBzeXN0ZW0sIHRoZSBub2RlIG9mIGEgZGV2
aWNlIG1heSBiZSBOVU1BX05PX05PREUNCj4gd2hlbiBCSU9TL0ZXIGhhcyBub3Qgc3BlY2lmaWVk
IGl0IHRocm91Z2ggQUNQSS9EVCwgc2VlIFsxXS4NCj4gDQo+IA0KPiBbMV0gaHR0cHM6Ly9sb3Jl
Lmtlcm5lbC5vcmcvcGF0Y2h3b3JrL3BhdGNoLzExNDE5NTIvDQo+IA0KDQphdCB0aGlzIGNvbmRp
dGlvbiwgcGFnZSBjYW4gYmUgYWxsb2NhdGVkIGZyb20gYW55IG5vZGUgZnJvbSBkcml2ZXIgYm9v
dCwNCndoeSBuZWVkIHRvIGNoZWNrICJwYWdlX3RvX25pZChwYWdlKSA9PSBudW1hX21lbV9pZCgp
IiBhdCByZWN5Y2xlPw0KDQotTGkgDQoNCj4gPg0KPiA+DQo+ID4gLVJvbmdRaW5nDQo+ID4NCj4g
Pg0KPiA+Pg0KPiA+Pj4gIH0NCj4gPj4+DQo+ID4+PiAgdm9pZCBfX3BhZ2VfcG9vbF9wdXRfcGFn
ZShzdHJ1Y3QgcGFnZV9wb29sICpwb29sLCBzdHJ1Y3QgcGFnZQ0KPiA+Pj4gKnBhZ2UsDQo+ID4+
Pg0KPiA+DQoNCg==
