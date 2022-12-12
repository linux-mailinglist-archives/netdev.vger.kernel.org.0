Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD86764A2E9
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 15:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiLLOMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 09:12:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbiLLOL6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 09:11:58 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 67BE0E7A
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 06:11:57 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BCEAv052001144, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BCEAv052001144
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 12 Dec 2022 22:10:57 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 12 Dec 2022 22:11:46 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 12 Dec 2022 22:11:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 12 Dec 2022 22:11:45 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHZBZK0jNmNF43ANUm+ON2R2qDGTK5d0aqAgATjHlD//8MxAIABsEYw///gi4CAAbFP8P//+V0AAJTwo+A=
Date:   Mon, 12 Dec 2022 14:11:44 +0000
Message-ID: <3395f909ef24454ca984a1b7977e0af4@realtek.com>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
 <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
 <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
 <7f460a37-d6f5-603f-2a6c-c65bae56f76b@gmail.com>
 <8b38c9f4552346ed84ba204b3e5edd5d@realtek.com>
 <6de467f2-e811-afbb-ab6f-f43f5456a857@gmail.com>
In-Reply-To: <6de467f2-e811-afbb-ab6f-f43f5456a857@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.74]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzEyIOS4i+WNiCAxMjo0NzowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAwOS4xMi4yMDIyIDE2OjI5LCBIYXUgd3JvdGU6DQo+ID4+DQo+ID4+IE9LLCBJIHRoaW5r
IEkgZ2V0IGEgYmV0dGVyIGlkZWEgb2YgeW91ciBzZXR1cC4NCj4gPj4gU28gaXQgc2VlbXMgUlRM
ODIxMUZTIGluZGVlZCBhY3RzIGFzIG1lZGlhIGNvbnZlcnRlci4gTGluayBzdGF0dXMgb24NCj4g
Pj4gTURJIHNpZGUgb2YgUlRMODIxMUZTIHJlZmxlY3RzIGxpbmsgc3RhdHVzIG9uIGZpYmVyL3Nl
cmRlcyBzaWRlLg0KPiA+PiBSVEw4MTY4SCBQSFkgaGFzIG5vIGlkZWEgd2hldGhlciBpdCdzIGNv
bm5lY3RlZCB0byBSSjQ1IG1hZ25ldGljcyBvcg0KPiA+PiB0byB0aGUgTURJIHNpZGUgb2YgYSBS
VEw4MjExRlMuDQo+ID4+DQo+ID4+IEkgdGhpbmsgZm9yIGNvbmZpZ3VyaW5nIFJUTDgyMTFGUyB5
b3UgaGF2ZSB0d28gb3B0aW9uczoNCj4gPj4gMS4gRXh0ZW5kIHRoZSBSZWFsdGVrIFBIWSBkcml2
ZXIgdG8gc3VwcG9ydCBSVEw4MjExRlMgZmliZXIgbW9kZSAyLg0KPiA+PiBDb25maWd1cmUgUlRM
ODIxMUZTIGZyb20gdXNlcnNwYWNlIChwaHl0b29sLCBtaWktdG9vbCwgLi4pLiBIb3dldmVyDQo+
ID4+IHRvIGJlIGFibGUgdG8gZG8gdGhpcyB5b3UgbWF5IG5lZWQgdG8gYWRkIGEgZHVtbXkgbmV0
ZGV2aWNlDQo+ID4+ICAgIHRoYXQgUlRMODIxMUZTIGlzIGF0dGFjaGVkIHRvLiBXaGVuIGdvaW5n
IHdpdGggdGhpcyBvcHRpb24gaXQgbWF5DQo+ID4+IGJlIGJldHRlciB0byBhdm9pZCBwaHlsaWIg
dGFraW5nIGNvbnRyb2wgb2YgUlRMODIxMUZTLg0KPiA+PiAgICBUaGlzIGNhbiBiZSBkb25lIGJ5
IHNldHRpbmcgdGhlIHBoeV9tYXNrIG9mIHRoZSBiaXQtYmFuZ2VkIG1paV9idXMuDQo+ID4NCj4g
PiBUaGFua3MgZm9yIHlvdXIgYWR2YWljZS4NCj4gPiBJcyB0aGF0IHBvc3NpYmxlIGZvciB1cyB0
byByZWdpc3RlciBhIFBIWSBmaXh1cCBmdW5jdGlvbihwaHlfcmVnaXN0ZXJfZml4dXAoKSkNCj4g
dG8gc2V0dXAgcnRsODIxMWZzIGluc3RlYWQgb2Ygc2V0dXAgaXQgaW4gUEhZIGRyaXZlcj8NCj4g
Pg0KPiBGcm9tIHdoZXJlIHdvdWxkIHlvdSBsaWtlIHRvIHJlZ2lzdGVyIHRoZSBQSFkgZml4dXA/
IHI4MTY5IHdvdWxkIGJlIHRoZQ0KPiB3cm9uZyBwbGFjZSBoZXJlLg0KPiBUaGVyZSBhcmUgdmVy
eSBmZXcgZHJpdmVycyB1c2luZyBhIFBIWSBmaXh1cCBhbmQgQUZBSUNTIHR5cGljYWxseSBQSFkg
ZHJpdmVycw0KPiBhcHBseSBmaXh1cHMgZnJvbSB0aGUgY29uZmlnX2luaXQgY2FsbGJhY2suDQo+
IEhhdmluZyBzYWlkIHRoYXQsIGlmIHBvc3NpYmxlIEknZCByZWNvbW1lbmQgdG8gYXZvaWQgdXNp
bmcgYSBQSFkgZml4dXAuDQo+IA0KVGhhbmtzIGZvciB5b3VyIHByb21wdCByZXBseS4gSSB0aGlu
ayBpbiBuZXh0IHBhdGNoIEkgd2lsbCByZW1vdmUgdGhlIHJ0bDgyMTFmcyBwaHkgcGFyYW1ldGVy
IHNldHRpbmcuDQpBbmQgb25seSBrZWVwIG5vbiBzcGVlZCBkb3duIHBhdGNoLg0KDQogLS0tLS0t
UGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1h
aWwuDQo=
