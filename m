Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB79348E443
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 07:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239373AbiANG3w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 01:29:52 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:56850 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239342AbiANG3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 01:29:51 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 20E6TS830017157, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 20E6TS830017157
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 14 Jan 2022 14:29:29 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 14:29:28 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Fri, 14 Jan 2022 14:29:28 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e]) by
 RTEXMBS04.realtek.com.tw ([fe80::35e4:d9d1:102d:605e%5]) with mapi id
 15.01.2308.020; Fri, 14 Jan 2022 14:29:28 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Jakub Kicinski <kuba@kernel.org>, Ryan Lahfa <ryan@lahfa.xyz>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andreas Seiderer <x64multicore@googlemail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: RTL8156(A|B) chip requires r8156 to be force loaded to operate
Thread-Topic: RTL8156(A|B) chip requires r8156 to be force loaded to operate
Thread-Index: AQHYCP2fosFQONoaMEaqk304BTUmfaxiChPg
Date:   Fri, 14 Jan 2022 06:29:28 +0000
Message-ID: <1e6d7b8c3af444ae900fd4248f2a9d35@realtek.com>
References: <20211224203018.z2n7sylht47ownga@Thors>
        <20211227182124.5cbc0d07@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <20211230000338.6q6zlj7ibvuz7yqt@Thors>
 <20220113201720.3aa6cb0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220113201720.3aa6cb0f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEvMTQg5LiK5Y2IIDA0OjQzOjAw?=
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

SmFrdWIgS2ljaW5za2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBKYW51YXJ5
IDE0LCAyMDIyIDEyOjE3IFBNDQpbLi4uXQ0KPiBEdW5ubyBtdWNoIGFib3V0IFVTQiBidXQgaXQg
c2VlbXMgdGhlIGRyaXZlciBtYXRjaGVzOg0KPiANCj4gCVVTQl9ERVZJQ0VfSU5URVJGQUNFX0NM
QVNTKHZlbmQsIHByb2QsIFVTQl9DTEFTU19WRU5ET1JfU1BFQyksDQo+IFwNCj4gDQo+IGFuZA0K
PiANCj4gCVVTQl9ERVZJQ0VfQU5EX0lOVEVSRkFDRV9JTkZPKHZlbmQsIHByb2QsIFVTQl9DTEFT
U19DT01NLCBcDQo+IAkJCVVTQl9DRENfU1VCQ0xBU1NfRVRIRVJORVQsIFVTQl9DRENfUFJPVE9f
Tk9ORSksIFwNCj4gDQo+IEJvdGggb2YgdGhlc2Ugc2hvdWxkIG1hdGNoLiBGb3JtZXIgYmVjYXVz
ZToNCj4gDQo+IEJ1cyAwMDIgRGV2aWNlIDAwMjogSUQgMGJkYTo4MTU2IFJlYWx0ZWsgU2VtaWNv
bmR1Y3RvciBDb3JwLiBVU0INCj4gMTAvMTAwLzFHLzIuNUcgTEFODQo+IFsuLi5dDQo+ICDCoMKg
wqAgSW50ZXJmYWNlIERlc2NyaXB0b3I6DQo+ICDCoMKgwqDCoMKgIGJMZW5ndGjCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCA5DQo+ICDCoMKgwqDCoMKgIGJEZXNjcmlwdG9yVHlwZcKg
wqDCoMKgwqDCoMKgwqAgNA0KPiAgwqDCoMKgwqDCoCBiSW50ZXJmYWNlTnVtYmVywqDCoMKgwqDC
oMKgwqAgMA0KPiAgwqDCoMKgwqDCoCBiQWx0ZXJuYXRlU2V0dGluZ8KgwqDCoMKgwqDCoCAwDQo+
ICDCoMKgwqDCoMKgIGJOdW1FbmRwb2ludHPCoMKgwqDCoMKgwqDCoMKgwqDCoCAzDQo+ICDCoMKg
wqDCoMKgIGJJbnRlcmZhY2VDbGFzc8KgwqDCoMKgwqDCoCAyNTUgVmVuZG9yIFNwZWNpZmljIENs
YXNzDQo+ICDCoMKgwqDCoMKgIGJJbnRlcmZhY2VTdWJDbGFzc8KgwqDCoCAyNTUgVmVuZG9yIFNw
ZWNpZmljIFN1YmNsYXNzDQo+IA0KPiBBbmQgdGhlIGxhdHRlciBiZWNhdXNlIG9mIGFub3RoZXIg
Y29uZmlnIHdpdGg6DQo+IA0KPiAgwqDCoMKgwqDCoCBiSW50ZXJmYWNlQ2xhc3PCoMKgwqDCoMKg
wqDCoMKgIDIgQ29tbXVuaWNhdGlvbnMNCj4gIMKgwqDCoMKgwqAgYkludGVyZmFjZVN1YkNsYXNz
wqDCoMKgwqDCoCA2IEV0aGVybmV0IE5ldHdvcmtpbmcNCj4gIMKgwqDCoMKgwqAgYkludGVyZmFj
ZVByb3RvY29swqDCoMKgwqDCoCAwDQoNClRoZXJlIGFyZSB0aHJlZSBjb25maWd1cmF0aW9ucyBm
b3IgUlRMODE1Ni4NCgljb25maWcgIzE6IHZlbmRvciBtb2RlIChyODE1MikNCgljb25maWcgIzI6
IE5DTSBtb2RlIChjZGNfbmNtKQ0KCWNvbmZpZyAjMzogRUNNIG1vZGUgKGNkY19ldGhlcikNCg0K
VGhlIFVTQiBjb3JlIHNlbGVjdHMgY29uZmlnICMyIGZvciBkZWZhdWx0LCBzbyBjZGNfbmNtIGlz
IGxvYWRlZC4NCklmIHlvdSBwbGFuIHRvIHVzZSB2ZW5kb3IgbW9kZSwgeW91IGhhdmUgdG8gc3dp
dGNoIHRoZSBjb25maWd1cmF0aW9uDQp0byBjb25maWcgIzEuIEZvciBleGFtcGxlLA0KDQoJZWNo
byAxID4gL3N5cy9idXMvdXNiL2RldmljZXMvMi03L2JDb25maWd1cmF0aW9uVmFsdWUNCg0KQmVz
dCBSZWdhcmRzLA0KSGF5ZXMNCg0K
