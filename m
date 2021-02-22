Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA393214F4
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 12:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230256AbhBVLVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 06:21:54 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:32920 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhBVLVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 06:21:52 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 11MBKhBoA032543, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexmbs03.realtek.com.tw[172.21.6.96])
        by rtits2.realtek.com.tw (8.15.2/2.70/5.88) with ESMTPS id 11MBKhBoA032543
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 22 Feb 2021 19:20:43 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Feb 2021 19:20:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 22 Feb 2021 19:20:42 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::a98b:ac3a:714:c542]) by
 RTEXMBS04.realtek.com.tw ([fe80::a98b:ac3a:714:c542%6]) with mapi id
 15.01.2106.006; Mon, 22 Feb 2021 19:20:42 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "chenhaoa@uniontech.com" <chenhaoa@uniontech.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        Timlee <timlee@realtek.com>, "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR laptop
Thread-Topic: [PATCH] rtw88: 8822ce: fix wifi disconnect after S3/S4 on HONOR
 laptop
Thread-Index: AQHXB2cbd+ly6tMRxUmzRD20VUoPdapgwaMzgAMIlyL//7pbAA==
Date:   Mon, 22 Feb 2021 11:20:42 +0000
Message-ID: <1613992840.2331.8.camel@realtek.com>
References: <20210220084602.22386-1-chenhaoa@uniontech.com>
         <878s7jjeeh.fsf@codeaurora.org>
         <1323517535.1654941.1613976259730.JavaMail.xmail@bj-wm-cp-15>
         <874ki4k1ej.fsf@codeaurora.org>
In-Reply-To: <874ki4k1ej.fsf@codeaurora.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [125.224.90.247]
Content-Type: text/plain; charset="utf-8"
Content-ID: <914464DB947C5F4794AE420933F6AB85@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIxLTAyLTIyIGF0IDA5OjI3ICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiDp
mYjmtakgPGNoZW5oYW9hQHVuaW9udGVjaC5jb20+IHdyaXRlczoNCj4gDQo+ID4gQnkgZ2l0IGJs
YW1lIGNvbW1hbmQsIEkga25vdyB0aGF0IHRoZSBhc3NpZ25tZW50IG9mIC5kcml2ZXIucG0gPQ0K
PiA+IFJUV19QTV9PUFMNCj4gPg0KPiA+IHdhcyBpbiBjb21taXQgNDRiYzE3ZjdmNWIzYigicnR3
ODg6IHN1cHBvcnQgd293bGFuIGZlYXR1cmUgZm9yDQo+ID4gODgyMmMiKSwNCj4gPg0KPiA+IGFu
ZCBhbm90aGVyIGNvbW1pdCA3ZGM3YzQxNjA3ZDE5KCJhdm9pZCB1bnVzZWQgZnVuY3Rpb24gd2Fy
bmluZ3MiKQ0KPiA+DQo+ID4gcG9pbnRlZCBvdXQgcnR3X3BjaV9yZXN1bWUoKSBhbmQgcnR3X3Bj
aV9zdXNwZW5kKCkgYXJlIG5vdCB1c2VkIGF0DQo+ID4gYWxsLg0KPiA+DQo+ID4gU28gSSB0aGlu
ayBpdCdzIHNhZmUgdG8gcmVtb3ZlIHRoZW0uDQo+ID4NCg0KSSB0aGluayAiLmRyaXZlci5wbSA9
ICZydHdfcG1fb3BzIiBpcyBhIHN3aXRjaCB0byBlbmFibGUgd293bGFuIGZlYXR1cmUuDQpUaGF0
IG1lYW5zIHRoYXQgd293bGFuIGRvZXNuJ3Qgd29yayB3aXRob3V0IHRoaXMgZGVjbGFyYXRpb24u
DQoNCj4gPiBDdXJyZW50bHksIEkgZmluZCB0aGF0IHRoZSBydGw4ODIyY2Ugd2lmaSBjaGlwIGFu
ZCB0aGUgcGNpIGJyaWRnZSBvZg0KPiA+IGl0IGFyZSBub3QgbGlua2VkIGJ5IHBjaQ0KPiA+DQo+
ID4gYWZ0ZXIgd2FrZSB1cCBieSBgbHNwY2lgIGNvbW1hbmQuDQo+ID4NCj4gPiB3aGVuIEkgc2V0
IGBwY2llX2FzcG0ucG9saWN5PXBlcmZvcm1hbmNlIGAgaW4gdGhlIEdSVUIuIFRoZSBtYWNoaW5l
DQo+ID4gc2xlZXAgYW5kDQo+ID4NCj4gPiB3YWtlIHVwIG5vcm1hbC5TbyBJIHRoaW5rIHdoZW4g
dGhpcyBvcHMgaXMgYXNzaWdubWVudGVkLHRoZSBzbGVlcCBhbmQNCj4gPiB3YWtlIHVwIHByb2Nl
ZHVyZQ0KPiA+DQo+ID4gbWF5IGNhdXNlIHBjaSBkZXZpY2Ugbm90IGxpbmtlZC4NCg0KUGxlYXNl
IHRyeSBzZXR0aW5nIG1vZHVsZSBwYXJhbWV0ZXIgZGlzYWJsZV9hc3BtPTEgd2l0aCBwY2kua28u
DQoNCkNvdWxkIEkga25vdyB3aGF0IHRoZSBDUFUgYW5kIHBjaSBicmlkZ2UgY2hpcHNldCBhcmUg
dXNlZCBieSBIT05PUiBsYXB0b3A/DQoNCj4gDQo+IFBsZWFzZSBkb24ndCB1c2UgSFRNTCwgb3Vy
IGxpc3RzIGF1dG9tYXRpY2FsbHkgZHJvcCBhbGwgSFRNTCBlbWFpbC4NCj4gDQo=
