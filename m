Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2462646080
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 18:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiLGRnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 12:43:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiLGRnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 12:43:42 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 16957554FC
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 09:43:41 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B7HgozgF024433, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B7HgozgF024433
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 8 Dec 2022 01:42:50 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 8 Dec 2022 01:43:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 8 Dec 2022 01:43:36 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 8 Dec 2022 01:43:36 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHZBZK0jNmNF43ANUm+ON2R2qDGTK5d0aqAgATjHlA=
Date:   Wed, 7 Dec 2022 17:43:36 +0000
Message-ID: <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
In-Reply-To: <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.74]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzcg5LiL5Y2IIDAyOjU4OjAw?=
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

PiANCj4gT24gMDEuMTIuMjAyMiAxNTozOSwgQ2h1bmhhbyBMaW4gd3JvdGU6DQo+ID4gcnRsODE2
OGgocmV2aWQgMHgyYSkgKyBydGw4MjExZnMgaXMgZm9yIHV0cCB0byBmaWJlciBhcHBsaWNhdGlv
bi4NCj4gPiBydGw4MTY4aCBpcyBjb25uZWN0ZWQgdG8gcnRsODIxMWZzIHV0cCBpbnRlcmZhY2Uu
IEFuZCBmaWJlciBpcw0KPiA+IGNvbm5lY3RlZCB0byBydGw4MjExZnMgc2ZwIGludGVyZmFjZS4g
cnRsODE2OGggdXNlIGl0cyBlZXBybSBvciBncG8NCj4gPiBwaW5zIHRvIGNvbnRyb2wgcnRsODIx
MWZzIG1kaW8gYnVzLg0KPiA+DQo+IA0KPiBJIGZvdW5kIGEgZGF0YXNoZWV0IGZvciBSVEw4MjEx
RlMgYW5kIGl0IGRvZXNuJ3QgbWVudGlvbiBTRlAgc3VwcG9ydC4NCj4gRm9yIHRoZSBmaWJlciB1
c2UgY2FzZSBpdCBtZW50aW9ucyBSR01JSSBmb3IgTUFDL1BIWSBjb25uZWN0aW9uIGFuZA0KPiBT
ZXJEZXMgZm9yIGNvbm5lY3RpbmcgdGhlIFBIWSB0byB0aGUgZmliZXIgbW9kdWxlLiBJcyB0aGlz
IHRoZSBtb2RlIHlvdSdkDQo+IGxpa2UgdG8gc3VwcG9ydD8NCj4gInV0cCB0byBmaWJlciIgc291
bmRzIGxpa2UgdGhlIG1lZGlhIGNvbnZlcnRlciBhcHBsaWNhdGlvbiwgYW5kIEkgdGhpbmsgdGhh
dCdzDQo+IG5vdCB3aGF0IHdlIHdhbnQgaGVyZS4gU28gaXQncyBtaXNsZWFkaW5nLg0KVGhpcyBh
cHBsaWNhdGlvbiBpcyBub3QgbGlzdGVkIGluIGRhdGFzaGVldC4gQnV0IGl0IGlzIHNpbWlsYXIg
dG8gdXRwIHRvIGZpYmVyIGFwcGxpY2F0aW9uLiBGaWJlciBjb25uZWN0cyB0byBydGw4MjExZnMg
dGhyb3VnaCBTZXJEZXMgaW50ZXJmYWNlLg0KcnRsODE2OGggY29ubmVjdHMgdG8gcnRsODIxMWZz
IHRocm91Z2ggbWRpIGludGVyZmFjZS4gcnRsODE2OGggYWxzbyBjb25uZWN0cyB0byBydGw4MjEx
ZnMgbWRjL21kaW8gaW50ZXJmYWNlIHRocm91Z2ggaXRzIGVlcHJvbSBvciBncG8gcGlucw0KIGZv
ciBjb250cm9sbGluZyBydGw4MjExZnMuIFRoZSBsaW5rIGJldHdlZW4gcnRsODIxMWZzIGFuZCBm
aWJlciwgYW5kIHRoZSBsaW5rIGJldHdlZW4gcnRsODIxMWZzIGFuZCBydGw4MTY4aCBzaG91bGQg
YmUgdGhlIHNhbWUuDQogRHJpdmVyIGp1c3QgbmVlZHMgdG8gc2V0IHRoZSBsaW5rIGNhcGFiaWxp
dHkgb2YgcnRsODE2OGggdG8gYXV0byBuZWdhdGlvbiBhbmQgcnRsODIxMWZzIHdpbGwgcHJvcGFn
YXRlIHRoZSBsaW5rIHN0YXR1cyBiZXR3ZWVuIGZpYmVyIGFuZCBpdHNlbGYgdG8gcnRsODE2OGgu
IA0KQnV0IHJ0bDgxNjhoIHdpbGwgbm90IGtub3cgdGhlIGxpbmsgY2FwYWJpbGl0eSBvZiBmaWJl
ci4gU28gd2hlbiBzeXN0ZW0gc3VzcGVuZCwgaWYgd29sIGlzIGVuYWJsZWQsIGRyaXZlciBjYW5u
b3Qgc3BlZWQgZG93biBydGw4MTY4aCdzIHBoeS4NCk9yIHJ0bDgxNjhoIGNhbm5vdCBiZSB3YWtl
biB1cC4NCg0KSSB3aWxsIHN1Ym1pdCBhIG5ldyBwYXRjaCBhY2NvcmRpbmcgeW91ciBhZHZpY2Uu
IEJ1dCB3ZSBhcmUgY29uc2lkZXJpbmcgbm90IHRvIHVzZSBkcml2ZXIocjgxNjkpIHRvIHNldHVw
IHJ0bDgyMTFmcy4gU28gbmV4dCBwYXRjaCBtYXliZSBzaW1wbGVyLg0KDQotLS0tLS1QbGVhc2Ug
Y29uc2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
