Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E465A1E79
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 04:02:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244642AbiHZCCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 22:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244551AbiHZCCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 22:02:42 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 60B9ACAC94;
        Thu, 25 Aug 2022 19:02:41 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27Q21RKt8027399, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27Q21RKt8027399
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 26 Aug 2022 10:01:27 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 26 Aug 2022 10:01:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Fri, 26 Aug 2022 10:01:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Fri, 26 Aug 2022 10:01:42 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Yang Yingliang <yangyingliang@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        Bernie Huang <phhuang@realtek.com>
Subject: RE: [PATCH -next] wifi: rtw88: add missing destroy_workqueue() on error path in rtw_core_init()
Thread-Topic: [PATCH -next] wifi: rtw88: add missing destroy_workqueue() on
 error path in rtw_core_init()
Thread-Index: AQHYuIbMIe6iUQ1BjUawKWBN0SU+yq3AWAlQ//+O9oCAAIaswA==
Date:   Fri, 26 Aug 2022 02:01:42 +0000
Message-ID: <11d0e70bdadf491fab1586a8b4ef199e@realtek.com>
References: <20220825133731.1877569-1-yangyingliang@huawei.com>
 <2f08c305927a43d78d6ab86468609288@realtek.com>
 <39e21608-c7e2-422a-1e05-e7ebb250ecac@huawei.com>
In-Reply-To: <39e21608-c7e2-422a-1e05-e7ebb250ecac@huawei.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzgvMjUg5LiL5Y2IIDExOjUwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFlhbmcgWWluZ2xpYW5nIDx5
YW5neWluZ2xpYW5nQGh1YXdlaS5jb20+DQo+IFNlbnQ6IEZyaWRheSwgQXVndXN0IDI2LCAyMDIy
IDk6NTcgQU0NCj4gVG86IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgt
d2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+IENjOiB0b255MDYyMGVtbWFAZ21haWwuY29tOyBr
dmFsb0BrZXJuZWwub3JnOyBCZXJuaWUgSHVhbmcgPHBoaHVhbmdAcmVhbHRlay5jb20+DQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0ggLW5leHRdIHdpZmk6IHJ0dzg4OiBhZGQgbWlzc2luZyBkZXN0cm95
X3dvcmtxdWV1ZSgpIG9uIGVycm9yIHBhdGggaW4gcnR3X2NvcmVfaW5pdCgpDQo+IA0KPiBIaSwN
Cj4gDQo+IE9uIDIwMjIvOC8yNiA4OjQ0LCBQaW5nLUtlIFNoaWggd3JvdGU6DQo+ID4+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+IEZyb206IFlhbmcgWWluZ2xpYW5nIDx5YW5neWlu
Z2xpYW5nQGh1YXdlaS5jb20+DQo+ID4+IFNlbnQ6IFRodXJzZGF5LCBBdWd1c3QgMjUsIDIwMjIg
OTozOCBQTQ0KPiA+PiBUbzogbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnDQo+ID4+IENjOiB0
b255MDYyMGVtbWFAZ21haWwuY29tOyBrdmFsb0BrZXJuZWwub3JnOyBCZXJuaWUgSHVhbmcgPHBo
aHVhbmdAcmVhbHRlay5jb20+DQo+ID4+IFN1YmplY3Q6IFtQQVRDSCAtbmV4dF0gd2lmaTogcnR3
ODg6IGFkZCBtaXNzaW5nIGRlc3Ryb3lfd29ya3F1ZXVlKCkgb24gZXJyb3IgcGF0aCBpbiBydHdf
Y29yZV9pbml0KCkNCj4gPj4NCj4gPj4gQWRkIHRoZSBtaXNzaW5nIGRlc3Ryb3lfd29ya3F1ZXVl
KCkgYmVmb3JlIHJldHVybiBmcm9tIHJ0d19jb3JlX2luaXQoKQ0KPiA+PiBpbiBlcnJvciBwYXRo
Lg0KPiA+Pg0KPiA+PiBGaXhlczogZmUxMDE3MTZjN2M5ICgicnR3ODg6IHJlcGxhY2UgdHggdGFz
a2xldCB3aXRoIHdvcmsgcXVldWUiKQ0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBZYW5nIFlpbmdsaWFu
ZyA8eWFuZ3lpbmdsaWFuZ0BodWF3ZWkuY29tPg0KPiA+PiAtLS0NCj4gPj4gICBkcml2ZXJzL25l
dC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L21haW4uYyB8IDggKysrKysrLS0NCj4gPj4gICAxIGZp
bGUgY2hhbmdlZCwgNiBpbnNlcnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiA+Pg0KPiA+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9tYWluLmMgYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L21haW4uYw0KPiA+PiBpbmRleCA3OTBk
Y2ZlZDExMjUuLjU1NzIxM2U1Mjc2MSAxMDA2NDQNCj4gPj4gLS0tIGEvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvcmVhbHRlay9ydHc4OC9tYWluLmMNCj4gPj4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydHc4OC9tYWluLmMNCj4gPj4gQEAgLTIwOTQsNyArMjA5NCw3IEBAIGludCBy
dHdfY29yZV9pbml0KHN0cnVjdCBydHdfZGV2ICpydHdkZXYpDQo+ID4+ICAgCXJldCA9IHJ0d19s
b2FkX2Zpcm13YXJlKHJ0d2RldiwgUlRXX05PUk1BTF9GVyk7DQo+ID4+ICAgCWlmIChyZXQpIHsN
Cj4gPj4gICAJCXJ0d193YXJuKHJ0d2RldiwgIm5vIGZpcm13YXJlIGxvYWRlZFxuIik7DQo+ID4+
IC0JCXJldHVybiByZXQ7DQo+ID4+ICsJCWdvdG8gZGVzdHJveV93b3JrcXVldWU7DQo+ID4+ICAg
CX0NCj4gPj4NCj4gPj4gICAJaWYgKGNoaXAtPndvd19md19uYW1lKSB7DQo+ID4+IEBAIC0yMTA0
LDExICsyMTA0LDE1IEBAIGludCBydHdfY29yZV9pbml0KHN0cnVjdCBydHdfZGV2ICpydHdkZXYp
DQo+ID4+ICAgCQkJd2FpdF9mb3JfY29tcGxldGlvbigmcnR3ZGV2LT5mdy5jb21wbGV0aW9uKTsN
Cj4gPj4gICAJCQlpZiAocnR3ZGV2LT5mdy5maXJtd2FyZSkNCj4gPj4gICAJCQkJcmVsZWFzZV9m
aXJtd2FyZShydHdkZXYtPmZ3LmZpcm13YXJlKTsNCj4gPj4gLQkJCXJldHVybiByZXQ7DQo+ID4+
ICsJCQlnb3RvIGRlc3Ryb3lfd29ya3F1ZXVlOw0KPiA+PiAgIAkJfQ0KPiA+PiAgIAl9DQo+ID4+
DQo+ID4+ICAgCXJldHVybiAwOw0KPiA+PiArDQo+ID4+ICtkZXN0cm95X3dvcmtxdWV1ZToNCj4g
PiBJdCdzIG5vdCBzbyBnb29kIHRoYXQgdGhlIGxhYmVsICdkZXN0cm95X3dvcmtxdWV1ZScgaXMg
dGhlIHNhbWUgYXMgZnVuY3Rpb24gbmFtZS4NCj4gPiBJIHN1Z2dlc3QgdG8ganVzdCB1c2UgJ291
dCcgaW5zdGVhZC4NCj4gSG93IGFib3V0ICdvdXRfZGVzdG9yeV93b3JrcXVldWUnID8NCj4gDQoN
ClNpbmNlIHRoZXJlIGlzIG9ubHkgc2luZ2xlIG9uZSBlcnJvciBjYXNlIHdlIG5lZWQgdG8gaGFu
ZGxlLCB1c2luZyAnb3V0Jw0KaXNuJ3QgYW1iaWd1b3VzLg0KDQoNCg==
