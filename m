Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC5046B596
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 09:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhLGIXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 03:23:39 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:40777 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230021AbhLGIXi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 03:23:38 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1B78K6iE4012929, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1B78K6iE4012929
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 7 Dec 2021 16:20:06 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 7 Dec 2021 16:20:05 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Tue, 7 Dec 2021 16:20:05 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Tue, 7 Dec 2021 16:20:05 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [RFC PATCH 4/4] r8169: add sysfs for dash
Thread-Topic: [RFC PATCH 4/4] r8169: add sysfs for dash
Thread-Index: AQHX5QnG3ZOFVvcQLEy4F0RtCKXQd6wgYQSAgAY/IQD//4ptgIAAj7fA
Date:   Tue, 7 Dec 2021 08:20:05 +0000
Message-ID: <aaf3a1e00fca472292446aa97ae36c0a@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
 <20211129101315.16372-385-nic_swsd@realtek.com>
 <b36df085-8f4e-790b-0b9e-1096047680f3@gmail.com>
 <2f5c720b6f3b46648678bee05eb23787@realtek.com>
 <d93143c8-5fda-70e1-8dd9-8350c6820e56@gmail.com>
In-Reply-To: <d93143c8-5fda-70e1-8dd9-8350c6820e56@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzcg5LiK5Y2IIDA3OjExOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogVHVlc2RheSwg
RGVjZW1iZXIgNywgMjAyMSAzOjM4IFBNDQpbLi4uXQ0KPiA+IEluIGFkZGl0aW9uIHRvIHByb3Rl
Y3QgdGhlIGNyaXRpY2FsIHNlY3Rpb24sIFJUTkwgaXMgdXNlZCB0byBhdm9pZA0KPiA+IGNhbGxp
bmcgY2xvc2UoKSBiZWZvcmUgQ01BQyBpcyBmaW5pc2hlZC4gVGhlIHRyYW5zZmVyIG9mIENNQUMN
Cj4gPiBtYXkgY29udGFpbiBzZXZlcmFsIHN0ZXBzLiBBbmQgY2xvc2UoKSB3b3VsZCBkaXNhYmxl
IENNQUMuDQo+ID4gSSBkb24ndCB3aXNoIHRoZSBDTUFDIHN0YXlzIGF0IHN0cmFuZ2Ugc3RhdGUu
IEl0IG1heSBpbmZsdWVuY2UNCj4gPiB0aGUgZmlybXdhcmUgb3IgaGFyZHdhcmUuIEJlc2lkZXMs
IEkgZmluZCB0aGUgb3JpZ2luYWwgZHJpdmVyIG9ubHkNCj4gPiB1c2UgUlROTCB0byBwcm90ZWN0
IGNyaXRpY2FsIHNlY3Rpb24uIElzIHRoZXJlIGEgYmV0dGVyIHdheSBmb3IgaXQ/DQo+ID4NCj4g
DQo+IFRoZSBtYWluIGlzc3VlIEkgc2VlIGlzIHRoYXQgeW91IGNhbGwgcnRsX2Rhc2hfZnJvbV9m
dygpIHVuZGVyIFJUTkwsDQo+IGFuZCB0aGlzIGZ1bmN0aW9uIG1heSBzbGVlcCB1cCB0byA1cy4g
SG9sZGluZyBhIHN5c3RlbS13aWRlIG11dGV4DQo+IGZvciB0aGF0IGxvbmcgaXNuJ3QgdG9vIG5p
Y2UuDQoNCkkgd291bGQgdGhpbmsgaWYgdGhlcmUgaXMgYSBiZXR0ZXIgd2F5IHRvIHJlcGxhY2Ug
Y3VycmVudCBvbmUuDQpUaGFua3MuDQoNCj4gSW4gcnRsX2Rhc2hfaW5mbygpIHlvdSBqdXN0IHBy
aW50IEZXIHZlcnNpb24gYW5kIGJ1aWxkIG51bWJlci4NCj4gV291bGRuJ3QgaXQgYmUgc3VmZmlj
aWVudCB0byBwcmludCB0aGlzIGluZm8gb25jZSB0byBzeXNsb2cNCj4gaW5zdGVhZCBvZiBleHBv
cnRpbmcgaXQgdmlhIHN5c2ZzPw0KDQpJdCBpcyB0aGUgaW5mb3JtYXRpb24gd2hpY2ggb3VyIHVz
ZXIgc3BhY2UgdG9vbCBuZWVkLg0KSSB0aGluayBpdCB3b3VsZCBiZSByZXBsYWNlZCB3aXRoIGRl
dmxpbmsgcGFyYW0uDQoNCkJlc3QgUmVnYXJkcywNCkhheWVzDQoNCg0K
