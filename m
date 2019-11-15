Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12BC5FE529
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 19:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727323AbfKOSob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 13:44:31 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:58800 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726323AbfKOSob (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 13:44:31 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID xAFIiODO001255, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCASV01.realtek.com.tw[172.21.6.18])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id xAFIiODO001255
        (version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT);
        Sat, 16 Nov 2019 02:44:24 +0800
Received: from RTEXMB01.realtek.com.tw (172.21.6.94) by
 RTITCASV01.realtek.com.tw (172.21.6.18) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Sat, 16 Nov 2019 02:44:23 +0800
Received: from RTEXMB04.realtek.com.tw (172.21.6.97) by
 RTEXMB01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Sat, 16 Nov 2019 02:44:22 +0800
Received: from RTEXMB04.realtek.com.tw ([fe80::f0a5:1a8b:cf45:7112]) by
 RTEXMB04.realtek.com.tw ([fe80::f0a5:1a8b:cf45:7112%4]) with mapi id
 15.01.1779.005; Sat, 16 Nov 2019 02:44:22 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "linux-firmware@kernel.org" <linux-firmware@kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] rtl_nic: add firmware rtl8168fp-3
Thread-Topic: [PATCH] rtl_nic: add firmware rtl8168fp-3
Thread-Index: AQHVm+Ihegt6nnnJ5UmWim6I5HqVj6eMkW0w
Date:   Fri, 15 Nov 2019 18:44:22 +0000
Message-ID: <e1e4ff02b82a4c278364be1924cf31ac@realtek.com>
References: <3de90521-8324-087f-f3d1-f616fda021b4@gmail.com>
In-Reply-To: <3de90521-8324-087f-f3d1-f616fda021b4@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.157]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gVGhpcyBhZGRzIGZpcm13YXJlIHJ0bDgxNjhmcC0zIGZvciBSZWFsdGVrJ3MgUlRMODE2
OGZwL1JUTDgxMTcuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBIZWluZXIgS2FsbHdlaXQgPGhrYWxs
d2VpdDFAZ21haWwuY29tPg0KDQpTaWduZWQtb2ZmLWJ5OiBDaHVuaGFvIExpbiA8aGF1QHJlYWx0
ZWsuY29tPg0KDQo+IC0tLQ0KPiBGaXJtd2FyZSBmaWxlIHdhcyBwcm92aWRlZCBieSBSZWFsdGVr
IGFuZCB0aGV5IGFza2VkIG1lIHRvIHN1Ym1pdCBpdC4NCj4gSGF1LCBjb3VsZCB5b3UgcGxlYXNl
IGFkZCB5b3VyIFNpZ25lZC1vZmYtYnk/DQo+IFRoZSByZWxhdGVkIGV4dGVuc2lvbiB0byByODE2
OSBkcml2ZXIgd2lsbCBiZSBzdWJtaXR0ZWQgaW4gdGhlIG5leHQgZGF5cy4NCj4gLS0tDQo+ICBX
SEVOQ0UgICAgICAgICAgICAgICAgIHwgICAzICsrKw0KPiAgcnRsX25pYy9ydGw4MTY4ZnAtMy5m
dyB8IEJpbiAwIC0+IDMzNiBieXRlcw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMo
KykNCj4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBydGxfbmljL3J0bDgxNjhmcC0zLmZ3DQo+IA0KPiBk
aWZmIC0tZ2l0IGEvV0hFTkNFIGIvV0hFTkNFDQo+IGluZGV4IDcxN2M4YzkuLjgxZWU5NjUgMTAw
NjQ0DQo+IC0tLSBhL1dIRU5DRQ0KPiArKysgYi9XSEVOQ0UNCj4gQEAgLTI5NTcsNiArMjk1Nyw5
IEBAIFZlcnNpb246IDAuMC4yDQo+ICBGaWxlOiBydGxfbmljL3J0bDgxNjhoLTIuZncNCj4gIFZl
cnNpb246IDAuMC4yDQo+IA0KPiArRmlsZTogcnRsX25pYy9ydGw4MTY4ZnAtMy5mdw0KPiArVmVy
c2lvbjogMC4wLjENCj4gKw0KPiAgRmlsZTogcnRsX25pYy9ydGw4MTA3ZS0xLmZ3DQo+ICBWZXJz
aW9uOiAwLjAuMg0KPiANCj4gZGlmZiAtLWdpdCBhL3J0bF9uaWMvcnRsODE2OGZwLTMuZncgYi9y
dGxfbmljL3J0bDgxNjhmcC0zLmZ3IG5ldyBmaWxlIG1vZGUNCj4gMTAwNjQ0IGluZGV4DQo+IDAw
MDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAuLmNjNzAzODQ0NjE1YmRkZTdh
MDNlNzIzOA0KPiBkODI3YjBiYjk0OWJmM2NhDQo+IEdJVCBiaW5hcnkgcGF0Y2gNCj4gbGl0ZXJh
bCAzMzYNCj4gemNtVy0NCj4gYyFBaXFXNUprdFRBdGElZDU8KkZmMX1QIyUpQXdReFglemA3TWZ7
MVZ3VzEoZU5ebUxuMm1BfHt1SDNtMQ0KPiB6Yj5WbHNnKTk5QkAhRW0mSU5VZUdGZGB6O0A7Y0xM
Yn1geDlEcGFndTlja1V3WDs9NjgkdlBvQnE/RX5OSWwzJUgNCj4geng5OCpIWmFoNkc1fmNnOW10
XnRUKWxIPDVmbDNFelRPSjxVPzNUczxYSEYjbHNJNVN4TDJUaj5rNXRKTHNTfT9CDQo+IHptPWBm
MzdRbFluMnBtJkUlYEN0LTc2TjBWVkh8fFVMKDVjQWBRKz90OW5UI2ZaX05OZCF2PW52QXU4YEok
amRUOQ0KPiB6SCk2aVp5cDgrajh1TkFMOWVsZVJvUSpsRnhIRjttPXFXdjs1OXF0fUokZz54cnl0
VVheZHRIKVgxQm4/UV4kdHkNCj4gT0l7MCF1U2hMJEM3dUZ2fHM4fDYyDQo+IA0KPiBsaXRlcmFs
IDANCj4gSGNtVj9kMDAwMDENCj4gDQo+IC0tDQo+IDIuMjQuMA0KPiANCj4gDQo+IC0tLS0tLVBs
ZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQgYmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWls
Lg0K
