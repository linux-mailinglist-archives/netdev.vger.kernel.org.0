Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A98BB64858F
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 16:29:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLIP35 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 10:29:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230229AbiLIP3n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 10:29:43 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C3061FCC3
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 07:29:41 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B9FSgw76022852, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B9FSgw76022852
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 9 Dec 2022 23:28:43 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 9 Dec 2022 23:29:30 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 9 Dec 2022 23:29:29 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 9 Dec 2022 23:29:29 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHZBZK0jNmNF43ANUm+ON2R2qDGTK5d0aqAgATjHlD//8MxAIABsEYw///gi4CAAbFP8A==
Date:   Fri, 9 Dec 2022 15:29:29 +0000
Message-ID: <8b38c9f4552346ed84ba204b3e5edd5d@realtek.com>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
 <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
 <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
 <7f460a37-d6f5-603f-2a6c-c65bae56f76b@gmail.com>
In-Reply-To: <7f460a37-d6f5-603f-2a6c-c65bae56f76b@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.74]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzkg5LiL5Y2IIDAyOjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT0ssIEkgdGhpbmsgSSBnZXQgYSBiZXR0ZXIgaWRlYSBvZiB5b3VyIHNldHVwLg0KPiBT
byBpdCBzZWVtcyBSVEw4MjExRlMgaW5kZWVkIGFjdHMgYXMgbWVkaWEgY29udmVydGVyLiBMaW5r
IHN0YXR1cyBvbiBNREkNCj4gc2lkZSBvZiBSVEw4MjExRlMgcmVmbGVjdHMgbGluayBzdGF0dXMg
b24gZmliZXIvc2VyZGVzIHNpZGUuDQo+IFJUTDgxNjhIIFBIWSBoYXMgbm8gaWRlYSB3aGV0aGVy
IGl0J3MgY29ubmVjdGVkIHRvIFJKNDUgbWFnbmV0aWNzIG9yIHRvIHRoZQ0KPiBNREkgc2lkZSBv
ZiBhIFJUTDgyMTFGUy4NCj4gDQo+IEkgdGhpbmsgZm9yIGNvbmZpZ3VyaW5nIFJUTDgyMTFGUyB5
b3UgaGF2ZSB0d28gb3B0aW9uczoNCj4gMS4gRXh0ZW5kIHRoZSBSZWFsdGVrIFBIWSBkcml2ZXIg
dG8gc3VwcG9ydCBSVEw4MjExRlMgZmliZXIgbW9kZSAyLg0KPiBDb25maWd1cmUgUlRMODIxMUZT
IGZyb20gdXNlcnNwYWNlIChwaHl0b29sLCBtaWktdG9vbCwgLi4pLiBIb3dldmVyIHRvIGJlDQo+
IGFibGUgdG8gZG8gdGhpcyB5b3UgbWF5IG5lZWQgdG8gYWRkIGEgZHVtbXkgbmV0ZGV2aWNlDQo+
ICAgIHRoYXQgUlRMODIxMUZTIGlzIGF0dGFjaGVkIHRvLiBXaGVuIGdvaW5nIHdpdGggdGhpcyBv
cHRpb24gaXQgbWF5IGJlIGJldHRlcg0KPiB0byBhdm9pZCBwaHlsaWIgdGFraW5nIGNvbnRyb2wg
b2YgUlRMODIxMUZTLg0KPiAgICBUaGlzIGNhbiBiZSBkb25lIGJ5IHNldHRpbmcgdGhlIHBoeV9t
YXNrIG9mIHRoZSBiaXQtYmFuZ2VkIG1paV9idXMuDQoNClRoYW5rcyBmb3IgeW91ciBhZHZhaWNl
Lg0KSXMgdGhhdCBwb3NzaWJsZSBmb3IgdXMgdG8gcmVnaXN0ZXIgYSBQSFkgZml4dXAgZnVuY3Rp
b24ocGh5X3JlZ2lzdGVyX2ZpeHVwKCkpIHRvIHNldHVwIHJ0bDgyMTFmcyBpbnN0ZWFkIG9mIHNl
dHVwIGl0IGluIFBIWSBkcml2ZXI/DQoNCiAtLS0tLS1QbGVhc2UgY29uc2lkZXIgdGhlIGVudmly
b25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg0K
