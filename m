Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2955B4672F9
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 08:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379044AbhLCIAw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 03:00:52 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:35190 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379033AbhLCIAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 03:00:51 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1B37vAOj9000605, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1B37vAOj9000605
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 3 Dec 2021 15:57:10 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 3 Dec 2021 15:57:10 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 3 Dec 2021 02:57:09 -0500
Received: from RTEXMBS04.realtek.com.tw ([fe80::f915:ec6f:35f1:6b04]) by
 RTEXMBS04.realtek.com.tw ([fe80::f915:ec6f:35f1:6b04%5]) with mapi id
 15.01.2308.015; Fri, 3 Dec 2021 15:57:09 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [RFC PATCH 3/4] r8169: support CMAC
Thread-Topic: [RFC PATCH 3/4] r8169: support CMAC
Thread-Index: AQHX5QnGfpTgBjHPLk2je6IL6JYRZ6wadE2AgAKDC9A=
Date:   Fri, 3 Dec 2021 07:57:09 +0000
Message-ID: <f56cc112d886490792fcb98c8faadff6@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
 <20211129101315.16372-384-nic_swsd@realtek.com>
 <3b610e64-9013-5c8c-93e9-95994d79f128@gmail.com>
In-Reply-To: <3b610e64-9013-5c8c-93e9-95994d79f128@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzMg5LiK5Y2IIDA2OjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
Tm92ZW1iZXIgMzAsIDIwMjEgNDo0NyBBTQ0KPiBUbzogSGF5ZXMgV2FuZyA8aGF5ZXN3YW5nQHJl
YWx0ZWsuY29tPjsgSmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz47DQpbLi4uXQ0KPiA+
ICtzdHJ1Y3QgcnRsX2Rhc2ggew0KPiA+ICsJc3RydWN0IHJ0bDgxNjlfcHJpdmF0ZSAqdHA7DQo+
ID4gKwlzdHJ1Y3QgcGNpX2RldiAqcGRldl9jbWFjOw0KPiA+ICsJdm9pZCBfX2lvbWVtICpjbWFj
X2lvYWRkcjsNCj4gPiArCXN0cnVjdCBjbWFjX2Rlc2MgKnR4X2Rlc2MsICpyeF9kZXNjOw0KPiA+
ICsJc3RydWN0IHBhZ2UgKnR4X2J1ZiwgKnJ4X2J1ZjsNCj4gPiArCXN0cnVjdCBkYXNoX3R4X2lu
Zm8gdHhfaW5mb1tDTUFDX0RFU0NfTlVNXTsNCj4gPiArCXN0cnVjdCB0YXNrbGV0X3N0cnVjdCB0
bDsNCj4gDQo+IFBsZWFzZSBzZWUgdGhlIGZvbGxvd2luZyBpbiBpbmNsdWRlL2xpbnV4L2ludGVy
cnVwdC5oOg0KPiANCj4gLyogVGFza2xldHMgLS0tIG11bHRpdGhyZWFkZWQgYW5hbG9ndWUgb2Yg
QkhzLg0KPiANCj4gICAgVGhpcyBBUEkgaXMgZGVwcmVjYXRlZC4gUGxlYXNlIGNvbnNpZGVyIHVz
aW5nIHRocmVhZGVkIElSUXMgaW5zdGVhZDoNCg0KSG93IGFib3V0IHJlcGxhY2luZyB0aGUgdGFz
a2xldCB3aXRoIHdvcms/DQpJdCBzZWVtcyB0aGF0IHRoZSBib3R0b20gaGFsZiBvZiB0aHJlYWRl
ZCBJUlENCmlzIHRoZSB3b3JrLCB0b28uDQoNCkJlc3QgUmVnYXJkcywNCkhheWVzDQoNCg0K
