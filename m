Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D03FD1139B8
	for <lists+netdev@lfdr.de>; Thu,  5 Dec 2019 03:18:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfLECSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 21:18:05 -0500
Received: from mx21.baidu.com ([220.181.3.85]:51925 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728132AbfLECSF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 21:18:05 -0500
Received: from Bc-Mail-Ex13.internal.baidu.com (unknown [172.31.51.53])
        by Forcepoint Email with ESMTPS id 33721402181EE;
        Thu,  5 Dec 2019 10:17:55 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 Bc-Mail-Ex13.internal.baidu.com (172.31.51.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1531.3; Thu, 5 Dec 2019 10:17:56 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1713.004; Thu, 5 Dec 2019 10:17:56 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogW1BBVENIXSBwYWdlX3Bvb2w6IG1h?=
 =?utf-8?Q?rk_unbound_node_page_as_reusable_pages?=
Thread-Topic: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtQQVRDSF0gcGFnZV9wb29sOiBtYXJrIHVuYm91?=
 =?utf-8?Q?nd_node_page_as_reusable_pages?=
Thread-Index: AQHVqwayi5QrKWQh5UWha5lw3I639qequlQw//+EaICAAIiS4P//fa6AgACIR2A=
Date:   Thu, 5 Dec 2019 02:17:55 +0000
Message-ID: <cd63eccb89bb406ca6edea46aee60e3a@baidu.com>
References: <1575454465-15386-1-git-send-email-lirongqing@baidu.com>
 <d7836d35-ba21-69ab-8aba-457b2da6ffa1@huawei.com>
 <656e11b6605740b18ac7bb8e3b67ed93@baidu.com>
 <f52fe7e8-2b6f-5e67-aa4b-38277478a7d1@huawei.com>
 <68135c0148894aa3b26db19120fb7bac@baidu.com>
 <3e3b1e0c-e7e0-eea2-b1b5-20bf2b8fc34b@huawei.com>
In-Reply-To: <3e3b1e0c-e7e0-eea2-b1b5-20bf2b8fc34b@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.17]
x-baidu-bdmsfe-datecheck: 1_Bc-Mail-Ex13_2019-12-05 10:17:56:229
x-baidu-bdmsfe-viruscheck: Bc-Mail-Ex13_GRAY_Inside_WithoutAtta_2019-12-05
 10:17:56:213
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IFl1bnNoZW5nIExpbiBb
bWFpbHRvOmxpbnl1bnNoZW5nQGh1YXdlaS5jb21dDQo+IOWPkemAgeaXtumXtDogMjAxOeW5tDEy
5pyINeaXpSAxMDowNg0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IHNhZWVkbUBtZWxsYW5veC5jb20NCj4g
5Li76aKYOiBSZTog562U5aSNOiDnrZTlpI06IFtQQVRDSF0gcGFnZV9wb29sOiBtYXJrIHVuYm91
bmQgbm9kZSBwYWdlIGFzDQo+IHJldXNhYmxlIHBhZ2VzDQo+IA0KPiBPbiAyMDE5LzEyLzUgOTo1
NSwgTGksUm9uZ3Fpbmcgd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiAtLS0tLemCruS7tuWOn+S7ti0t
LS0tDQo+ID4+IOWPkeS7tuS6ujogWXVuc2hlbmcgTGluIFttYWlsdG86bGlueXVuc2hlbmdAaHVh
d2VpLmNvbV0NCj4gPj4g5Y+R6YCB5pe26Ze0OiAyMDE55bm0MTLmnIg15pelIDk6NDQNCj4gPj4g
5pS25Lu25Lq6OiBMaSxSb25ncWluZyA8bGlyb25ncWluZ0BiYWlkdS5jb20+OyBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOw0KPiA+PiBzYWVlZG1AbWVsbGFub3guY29tDQo+ID4+IOS4u+mimDogUmU6
IOetlOWkjTogW1BBVENIXSBwYWdlX3Bvb2w6IG1hcmsgdW5ib3VuZCBub2RlIHBhZ2UgYXMgcmV1
c2FibGUNCj4gPj4gcGFnZXMNCj4gPj4NCj4gPj4gT24gMjAxOS8xMi81IDk6MDgsIExpLFJvbmdx
aW5nIHdyb3RlOg0KPiA+Pj4NCj4gPj4+DQo+ID4+Pj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0K
PiA+Pj4+IOWPkeS7tuS6ujogWXVuc2hlbmcgTGluIFttYWlsdG86bGlueXVuc2hlbmdAaHVhd2Vp
LmNvbV0NCj4gPj4+PiDlj5HpgIHml7bpl7Q6IDIwMTnlubQxMuaciDXml6UgODo1NQ0KPiA+Pj4+
IOaUtuS7tuS6ujogTGksUm9uZ3FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPjsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsNCj4gPj4+PiBzYWVlZG1AbWVsbGFub3guY29tDQo+ID4+Pj4g5Li76aKY
OiBSZTogW1BBVENIXSBwYWdlX3Bvb2w6IG1hcmsgdW5ib3VuZCBub2RlIHBhZ2UgYXMgcmV1c2Fi
bGUNCj4gcGFnZXMNCj4gPj4+Pg0KPiA+Pj4+IE9uIDIwMTkvMTIvNCAxODoxNCwgTGkgUm9uZ1Fp
bmcgd3JvdGU6DQo+ID4+Pj4+IHNvbWUgZHJpdmVycyB1c2VzIHBhZ2UgcG9vbCwgYnV0IG5vdCBy
ZXF1aXJlIHRvIGFsbG9jYXRlIHBhZ2UgZnJvbQ0KPiA+Pj4+PiBib3VuZCBub2RlLCBzbyBwb29s
LnAubmlkIGlzIE5VTUFfTk9fTk9ERSwgYW5kIHRoaXMgZml4ZWQgcGF0Y2gNCj4gPj4+Pj4gd2ls
bCBibG9jayB0aGlzIGtpbmQgb2YgZHJpdmVyIHRvIHJlY3ljbGUNCj4gPj4+Pj4NCj4gPj4+Pj4g
Rml4ZXM6IGQ1Mzk0NjEwYjFiYSAoInBhZ2VfcG9vbDogRG9uJ3QgcmVjeWNsZSBub24tcmV1c2Fi
bGUNCj4gPj4+Pj4gcGFnZXMiKQ0KPiA+Pj4+PiBTaWduZWQtb2ZmLWJ5OiBMaSBSb25nUWluZyA8
bGlyb25ncWluZ0BiYWlkdS5jb20+DQo+ID4+Pj4+IENjOiBTYWVlZCBNYWhhbWVlZCA8c2FlZWRt
QG1lbGxhbm94LmNvbT4NCj4gPj4+Pj4gLS0tDQo+ID4+Pj4+ICBuZXQvY29yZS9wYWdlX3Bvb2wu
YyB8IDQgKysrLQ0KPiA+Pj4+PiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBk
ZWxldGlvbigtKQ0KPiA+Pj4+Pg0KPiA+Pj4+PiBkaWZmIC0tZ2l0IGEvbmV0L2NvcmUvcGFnZV9w
b29sLmMgYi9uZXQvY29yZS9wYWdlX3Bvb2wuYyBpbmRleA0KPiA+Pj4+PiBhNmFlZmU5ODkwNDMu
LjQwNTRkYjY4MzE3OCAxMDA2NDQNCj4gPj4+Pj4gLS0tIGEvbmV0L2NvcmUvcGFnZV9wb29sLmMN
Cj4gPj4+Pj4gKysrIGIvbmV0L2NvcmUvcGFnZV9wb29sLmMNCj4gPj4+Pj4gQEAgLTMxNyw3ICsz
MTcsOSBAQCBzdGF0aWMgYm9vbCBfX3BhZ2VfcG9vbF9yZWN5Y2xlX2RpcmVjdChzdHJ1Y3QNCj4g
Pj4+Pj4gcGFnZQ0KPiA+Pj4+ICpwYWdlLA0KPiA+Pj4+PiAgICovDQo+ID4+Pj4+ICBzdGF0aWMg
Ym9vbCBwb29sX3BhZ2VfcmV1c2FibGUoc3RydWN0IHBhZ2VfcG9vbCAqcG9vbCwgc3RydWN0DQo+
ID4+Pj4+IHBhZ2UNCj4gPj4+Pj4gKnBhZ2UpICB7DQo+ID4+Pj4+IC0JcmV0dXJuICFwYWdlX2lz
X3BmbWVtYWxsb2MocGFnZSkgJiYgcGFnZV90b19uaWQocGFnZSkgPT0NCj4gPj4gcG9vbC0+cC5u
aWQ7DQo+ID4+Pj4+ICsJcmV0dXJuICFwYWdlX2lzX3BmbWVtYWxsb2MocGFnZSkgJiYNCj4gPj4+
Pj4gKwkJKHBhZ2VfdG9fbmlkKHBhZ2UpID09IHBvb2wtPnAubmlkIHx8DQo+ID4+Pj4+ICsJCSBw
b29sLT5wLm5pZCA9PSBOVU1BX05PX05PREUpOw0KPiA+Pj4+DQo+ID4+Pj4gSWYgSSB1bmRlcnN0
YW5kIGl0IGNvcnJlY3RseSwgeW91IGFyZSBhbGxvd2luZyByZWN5Y2xpbmcgd2hlbg0KPiA+Pj4+
IHBvb2wtPnAubmlkIGlzIE5VTUFfTk9fTk9ERSwgd2hpY2ggZG9lcyBub3Qgc2VlbXMgbWF0Y2gg
dGhlDQo+IGNvbW1pdA0KPiA+Pj4+IGxvZzogInRoaXMgZml4ZWQgcGF0Y2ggd2lsbCBibG9jayB0
aGlzIGtpbmQgb2YgZHJpdmVyIHRvIHJlY3ljbGUiLg0KPiA+Pj4+DQo+ID4+Pj4gTWF5YmUgeW91
IG1lYW4gImNvbW1pdCBkNTM5NDYxMGIxYmEiIGJ5IHRoaXMgZml4ZWQgcGF0Y2g/DQo+ID4+Pg0K
PiA+Pj4geWVzDQo+ID4+Pg0KPiA+Pj4+DQo+ID4+Pj4gQWxzbywgbWF5YmUgaXQgaXMgYmV0dGVy
IHRvIGFsbG93IHJlY3ljbGluZyBpZiB0aGUgYmVsb3cgY29uZGl0aW9uIGlzDQo+IG1hdGNoZWQ6
DQo+ID4+Pj4NCj4gPj4+PiAJcG9vbC0+cC5uaWQgPT0gTlVNQV9OT19OT0RFICYmIHBhZ2VfdG9f
bmlkKHBhZ2UpID09DQo+ID4+Pj4gbnVtYV9tZW1faWQoKQ0KPiA+Pj4NCj4gPj4+IElmIGRyaXZl
ciB1c2VzIE5VTUFfTk9fTk9ERSwgaXQgZG9lcyBub3QgY2FyZSBudW1hIG5vZGUsIGFuZCBtYXli
ZQ0KPiA+Pj4gaXRzIHBsYXRmb3JtIE9ubHkgaGFzIGEgbm9kZSwgc28gbm90IG5lZWQgdG8gY29t
cGFyZSBsaWtlDQo+ID4+PiAicGFnZV90b19uaWQocGFnZSkgPT0NCj4gPj4gbnVtYV9tZW1faWQo
KSINCj4gPj4NCj4gPj4gTm9ybWFsbHksIGRyaXZlciBkb2VzIG5vdCBjYXJlIGlmIHRoZSBub2Rl
IG9mIGEgZGV2aWNlIGlzDQo+ID4+IE5VTUFfTk9fTk9ERSBvciBub3QsIGl0IGp1c3QgdXNlcyB0
aGUgbm9kZSB0aGF0IHJldHVybnMgZnJvbQ0KPiBkZXZfdG9fbm9kZSgpLg0KPiA+Pg0KPiA+PiBF
dmVuIGZvciBtdWx0aSBub2RlIHN5c3RlbSwgdGhlIG5vZGUgb2YgYSBkZXZpY2UgbWF5IGJlIE5V
TUFfTk9fTk9ERQ0KPiA+PiB3aGVuIEJJT1MvRlcgaGFzIG5vdCBzcGVjaWZpZWQgaXQgdGhyb3Vn
aCBBQ1BJL0RULCBzZWUgWzFdLg0KPiA+Pg0KPiA+Pg0KPiA+PiBbMV0gaHR0cHM6Ly9sb3JlLmtl
cm5lbC5vcmcvcGF0Y2h3b3JrL3BhdGNoLzExNDE5NTIvDQo+ID4+DQo+ID4NCj4gPiBhdCB0aGlz
IGNvbmRpdGlvbiwgcGFnZSBjYW4gYmUgYWxsb2NhdGVkIGZyb20gYW55IG5vZGUgZnJvbSBkcml2
ZXINCj4gPiBib290LCB3aHkgbmVlZCB0byBjaGVjayAicGFnZV90b19uaWQocGFnZSkgPT0gbnVt
YV9tZW1faWQoKSIgYXQgcmVjeWNsZT8NCj4gDQo+IEZvciBwZXJmb3JtYW5jZSwgdGhlIHBlcmZv
cm1hbmNlIGlzIGJldHRlciB3aGVuIHRoZSByeCBwYWdlIGlzIG9uIHRoZSBzYW1lDQo+IG5vZGUg
YXMgdGhlIHJ4IHByb2Nlc3MgaXMgcnVubmluZy4NCj4gDQo+IFdlIHdhbnQgdGhlIG5vZGUgb2Yg
cnggcGFnZSBpcyBjbG9zZSB0byB0aGUgbm9kZSBvZiBkZXZpY2UvY3B1IHRvIGFjaGl2ZSBiZXR0
ZXINCj4gcGVyZm9ybWFuY2UsIHNpbmNlIHRoZSBub2RlIG9mIGRldmljZSBpcyB1bmtub3duLCBt
YXliZSB3ZSBjaG9vc2UgdGhlIG5vZGUNCj4gb2YgbWVtb3J5IHRoYXQgaXMgY2xvc2UgdG8gdGhl
IGNwdSB0aGF0IGlzIHJ1bm5pbmcgdG8gaGFuZGxlIHRoZSByeCBjbGVhbmluZy4NCj4gDQoNCmlm
IHRoZSBkcml2ZXIgdGFrZXMgY2FyZSBhYm91dCBudW1hIG5vZGUsIGl0IHNob3VsZCBub3QgYXNz
aWduIE5VTUFfTk9fTk9ERSwgaXQgc2hvdWxkDQphc3NpZ24gYSBkZXRhaWwgbnVtYSBub2RlIGF0
IHN0YXJ0aW5nIHN0ZXAuIE5vdCBkZXBlbmQgb24gcmVjeWNsZSB0byBkZWNpZGUgdGhlIG51bWEN
Cm5vZGUNCg0KLVJvbmdRaW5nDQoNCg0KPiA+DQo+ID4gLUxpDQo+ID4NCj4gPj4+DQo+ID4+Pg0K
PiA+Pj4gLVJvbmdRaW5nDQo+ID4+Pg0KPiA+Pj4NCj4gPj4+Pg0KPiA+Pj4+PiAgfQ0KPiA+Pj4+
Pg0KPiA+Pj4+PiAgdm9pZCBfX3BhZ2VfcG9vbF9wdXRfcGFnZShzdHJ1Y3QgcGFnZV9wb29sICpw
b29sLCBzdHJ1Y3QgcGFnZQ0KPiA+Pj4+PiAqcGFnZSwNCj4gPj4+Pj4NCj4gPj4+DQo+ID4NCg0K
