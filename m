Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797A359EA0A
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 19:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231270AbiHWRo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 13:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiHWRof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 13:44:35 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 311688A7C6
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 08:35:14 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27NFYjcK6030251, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27NFYjcK6030251
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Tue, 23 Aug 2022 23:34:45 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 23 Aug 2022 23:34:59 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Tue, 23 Aug 2022 23:34:58 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Tue, 23 Aug 2022 23:34:58 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH v3 net-next] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHYtkFCqIBipNqwCkqP74BSSxF+S6261lsAgAHEHKA=
Date:   Tue, 23 Aug 2022 15:34:58 +0000
Message-ID: <180133e86ad8413ba1c760480108ef34@realtek.com>
References: <20220822160714.2904-1-hau@realtek.com>
 <6018e2ca-a02f-f70f-cf9a-f635680a02ba@gmail.com>
In-Reply-To: <6018e2ca-a02f-f70f-cf9a-f635680a02ba@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.129]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzgvMjMg5LiL5Y2IIDAyOjA3OjAw?=
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

PiA+ICsjZGVmaW5lIE1ESU9fUkVBRCAyDQo+ID4gKyNkZWZpbmUgTURJT19XUklURSAxDQo+ID4g
Ky8qIE1ESU8gYnVzIGluaXQgZnVuY3Rpb24gKi8NCj4gPiArc3RhdGljIGludCBydGxfbWRpb19i
aXRiYW5nX2luaXQoc3RydWN0IHJ0bDgxNjlfcHJpdmF0ZSAqdHApIHsNCj4gPiArCXN0cnVjdCBi
Yl9pbmZvICpiaXRiYW5nOw0KPiA+ICsJc3RydWN0IGRldmljZSAqZCA9IHRwX3RvX2Rldih0cCk7
DQo+ID4gKwlzdHJ1Y3QgbWlpX2J1cyAqbmV3X2J1czsNCj4gPiArDQo+ID4gKwkvKiBjcmVhdGUg
Yml0IGNvbnRyb2wgc3RydWN0IGZvciBQSFkgKi8NCj4gPiArCWJpdGJhbmcgPSBkZXZtX2t6YWxs
b2MoZCwgc2l6ZW9mKHN0cnVjdCBiYl9pbmZvKSwgR0ZQX0tFUk5FTCk7DQo+ID4gKwlpZiAoIWJp
dGJhbmcpDQo+ID4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ID4gKw0KPiA+ICsJLyogYml0YmFuZyBp
bml0ICovDQo+ID4gKwliaXRiYW5nLT50cCA9IHRwOw0KPiA+ICsJYml0YmFuZy0+Y3RybC5vcHMg
PSAmYmJfb3BzOw0KPiA+ICsJYml0YmFuZy0+Y3RybC5vcF9jMjJfcmVhZCA9IE1ESU9fUkVBRDsN
Cj4gPiArCWJpdGJhbmctPmN0cmwub3BfYzIyX3dyaXRlID0gTURJT19XUklURTsNCj4gPiArDQo+
ID4gKwkvKiBNSUkgY29udHJvbGxlciBzZXR0aW5nICovDQo+ID4gKwluZXdfYnVzID0gZGV2bV9t
ZGlvYnVzX2FsbG9jKGQpOw0KPiA+ICsJaWYgKCFuZXdfYnVzKQ0KPiA+ICsJCXJldHVybiAtRU5P
TUVNOw0KPiA+ICsNCj4gPiArCW5ld19idXMtPnJlYWQgPSBtZGlvYmJfcmVhZDsNCj4gPiArCW5l
d19idXMtPndyaXRlID0gbWRpb2JiX3dyaXRlOw0KPiA+ICsJbmV3X2J1cy0+cHJpdiA9ICZiaXRi
YW5nLT5jdHJsOw0KPiA+ICsNCj4gDQo+IFRoaXMgbG9va3MgbGlrZSBhbiBvcGVuLWNvZGVkIHZl
cnNpb24gb2YgYWxsb2NfbWRpb19iaXRiYW5nKCkuDQo+IA0KWWVzLCBpdCBpcyBwYXJ0IG9mIGFs
bG9jX21kaW9fYml0YmFuZygpLg0KDQo+ID4gKwl0cC0+bWlpX2J1cyA9IG5ld19idXM7DQo+ID4g
Kw0KPiA+ICsJcmV0dXJuIDA7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIHJ0bF9z
ZnBfYml0YmFuZ19pbml0KHN0cnVjdCBydGw4MTY5X3ByaXZhdGUgKnRwLA0KPiA+ICsJCQkJICBz
dHJ1Y3QgcnRsX3NmcF9pZl9tYXNrICpzZnBfbWFzaykgew0KPiA+ICsJc3RydWN0IG1paV9idXMg
KmJ1cyA9IHRwLT5taWlfYnVzOw0KPiA+ICsJc3RydWN0IGJiX2luZm8gKmJpdGJhbmcgPSBjb250
YWluZXJfb2YoYnVzLT5wcml2LCBzdHJ1Y3QgYmJfaW5mbywNCj4gPiArY3RybCk7DQo+ID4gKw0K
PiA+ICsJcjgxNjhfbWFjX29jcF9tb2RpZnkodHAsIFBJTlBVLCBzZnBfbWFzay0+cGluX21hc2ss
IDApOw0KPiA+ICsJcjgxNjhfbWFjX29jcF9tb2RpZnkodHAsIFBJTk9FLCAwLCBzZnBfbWFzay0+
cGluX21hc2spOw0KPiA+ICsJYml0YmFuZy0+cGlub2VfdmFsdWUgPSByODE2OF9tYWNfb2NwX3Jl
YWQodHAsIFBJTk9FKTsNCj4gPiArCWJpdGJhbmctPnBpbl9pX3NlbF8xX3ZhbHVlID0gcjgxNjhf
bWFjX29jcF9yZWFkKHRwLA0KPiBQSU5fSV9TRUxfMSk7DQo+ID4gKwliaXRiYW5nLT5waW5faV9z
ZWxfMl92YWx1ZSA9IHI4MTY4X21hY19vY3BfcmVhZCh0cCwNCj4gUElOX0lfU0VMXzIpOw0KPiA+
ICsJbWVtY3B5KCZiaXRiYW5nLT5zZnBfbWFzaywgc2ZwX21hc2ssIHNpemVvZihzdHJ1Y3QNCj4g
PiArcnRsX3NmcF9pZl9tYXNrKSk7IH0NCj4gPiArDQo+ID4gK3N0YXRpYyB2b2lkIHJ0bF9zZnBf
bWRpb193cml0ZShzdHJ1Y3QgcnRsODE2OV9wcml2YXRlICp0cCwNCj4gPiArCQkJCSAgdTggcmVn
LA0KPiA+ICsJCQkJICB1MTYgdmFsKQ0KPiA+ICt7DQo+ID4gKwlzdHJ1Y3QgbWlpX2J1cyAqYnVz
ID0gdHAtPm1paV9idXM7DQo+ID4gKwlzdHJ1Y3QgYmJfaW5mbyAqYml0YmFuZzsNCj4gPiArDQo+
ID4gKwlpZiAoIWJ1cykNCj4gPiArCQlyZXR1cm47DQo+ID4gKw0KPiA+ICsJYml0YmFuZyA9IGNv
bnRhaW5lcl9vZihidXMtPnByaXYsIHN0cnVjdCBiYl9pbmZvLCBjdHJsKTsNCj4gPiArCWJ1cy0+
d3JpdGUoYnVzLCBiaXRiYW5nLT5zZnBfbWFzay5waHlfYWRkciwgcmVnLCB2YWwpOyB9DQo+ID4g
Kw0KPiA+ICtzdGF0aWMgdTE2IHJ0bF9zZnBfbWRpb19yZWFkKHN0cnVjdCBydGw4MTY5X3ByaXZh
dGUgKnRwLA0KPiA+ICsJCQkJICB1OCByZWcpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBtaWlfYnVz
ICpidXMgPSB0cC0+bWlpX2J1czsNCj4gPiArCXN0cnVjdCBiYl9pbmZvICpiaXRiYW5nOw0KPiA+
ICsNCj4gPiArCWlmICghYnVzKQ0KPiA+ICsJCXJldHVybiB+MDsNCj4gPiArDQo+ID4gKwliaXRi
YW5nID0gY29udGFpbmVyX29mKGJ1cy0+cHJpdiwgc3RydWN0IGJiX2luZm8sIGN0cmwpOw0KPiA+
ICsNCj4gPiArCXJldHVybiBidXMtPnJlYWQoYnVzLCBiaXRiYW5nLT5zZnBfbWFzay5waHlfYWRk
ciwgcmVnKTsgfQ0KPiA+ICsNCj4gPiArc3RhdGljIHZvaWQgcnRsX3NmcF9tZGlvX21vZGlmeShz
dHJ1Y3QgcnRsODE2OV9wcml2YXRlICp0cCwgdTMyIHJlZywgdTE2DQo+IG1hc2ssDQo+ID4gKwkJ
CQkgdTE2IHNldCkNCj4gPiArew0KPiA+ICsJdTE2IGRhdGEgPSBydGxfc2ZwX21kaW9fcmVhZCh0
cCwgcmVnKTsNCj4gPiArDQo+ID4gKwlydGxfc2ZwX21kaW9fd3JpdGUodHAsIHJlZywgKGRhdGEg
JiB+bWFzaykgfCBzZXQpOyB9DQo+ID4gKw0KPiA+ICsjZGVmaW5lIFJUTDgyMTFGU19QSFlfSURf
MSAweDAwMWMNCj4gPiArI2RlZmluZSBSVEw4MjExRlNfUEhZX0lEXzIgMHhjOTE2DQo+ID4gKw0K
PiANCj4gVGhlcmUgc2hvdWxkbid0IGJlIGEgZGVwZW5kZW5jeSBvbiBhIHNwZWNpZmljIFBIWSB0
eXBlLiBJdCBtYXkgbm90IHJlZmxlY3QNCj4geW91ciB1c2UgY2FzZXMsIGJ1dCBpdCBzaG91bGQg
YmUgcGVyZmVjdGx5IHBvc3NpYmxlIHRvIGNvbWJpbmUgdGhpcyBNQUMgd2l0aA0KPiBvdGhlciBQ
SFkgdHlwZXMsIGFsc28gZnJvbSBvdGhlciB2ZW5kb3JzLCBzdXBwb3J0aW5nIGZpYmVyLg0KPiAN
ClRoaXMgaXMgYSBzcGVjaWFsIHVzZSBjYXNlLiBydGw4MTY4aCBpcyBub3QgZGVzaWduZWQgYXMg
TUFDIHRvIGNvbm5lY3QgdG8gb3RoZXIgUEhZLg0KDQpUaGFua3MsDQpIYXUNCiAtLS0tLS1QbGVh
c2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4N
Cg==
