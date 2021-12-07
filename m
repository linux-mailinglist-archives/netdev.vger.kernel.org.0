Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6498746B339
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 07:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhLGG4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 01:56:40 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:60514 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbhLGG4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 01:56:40 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1B76r7GV1026987, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1B76r7GV1026987
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 7 Dec 2021 14:53:07 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 7 Dec 2021 14:53:07 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 6 Dec 2021 22:53:06 -0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Tue, 7 Dec 2021 14:53:06 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [RFC PATCH 4/4] r8169: add sysfs for dash
Thread-Topic: [RFC PATCH 4/4] r8169: add sysfs for dash
Thread-Index: AQHX5QnG3ZOFVvcQLEy4F0RtCKXQd6wgYQSAgAY/IQA=
Date:   Tue, 7 Dec 2021 06:53:06 +0000
Message-ID: <2f5c720b6f3b46648678bee05eb23787@realtek.com>
References: <20211129101315.16372-381-nic_swsd@realtek.com>
 <20211129101315.16372-385-nic_swsd@realtek.com>
 <b36df085-8f4e-790b-0b9e-1096047680f3@gmail.com>
In-Reply-To: <b36df085-8f4e-790b-0b9e-1096047680f3@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzcg5LiK5Y2IIDA1OjE5OjAw?=
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

SGVpbmVyIEthbGx3ZWl0IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogRnJpZGF5LCBE
ZWNlbWJlciAzLCAyMDIxIDExOjE1IFBNDQpbLi4uXQ0KPiBXaXRoIHJlZ2FyZCB0byBzeXNmcyB1
c2FnZToNCj4gLSBhdHRyaWJ1dGVzIHNob3VsZCBiZSBkb2N1bWVudGVkIHVuZGVyIC9Eb2N1bWVu
dGF0aW9uL0FCSS90ZXN0aW5nDQo+IC0gYXR0cmlidXRlcyBzaG91bGQgYmUgZGVmaW5lZCBzdGF0
aWNhbGx5IChkcml2ZXIuZGV2X2dyb3VwcyBpbnN0ZWFkDQo+ICAgb2Ygc3lzZnNfY3JlYXRlX2dy
b3VwKQ0KPiAtIGZvciBwcmludGluZyBpbmZvIHRoZXJlJ3Mgc3lzZnNfZW1pdCgpDQo+IC0gaXMg
cmVhbGx5IFJUTkwgbmVlZGVkPyBPciB3b3VsZCBhIGxpZ2h0ZXIgbXV0ZXggZG8/DQoNCkluIGFk
ZGl0aW9uIHRvIHByb3RlY3QgdGhlIGNyaXRpY2FsIHNlY3Rpb24sIFJUTkwgaXMgdXNlZCB0byBh
dm9pZA0KY2FsbGluZyBjbG9zZSgpIGJlZm9yZSBDTUFDIGlzIGZpbmlzaGVkLiBUaGUgdHJhbnNm
ZXIgb2YgQ01BQw0KbWF5IGNvbnRhaW4gc2V2ZXJhbCBzdGVwcy4gQW5kIGNsb3NlKCkgd291bGQg
ZGlzYWJsZSBDTUFDLg0KSSBkb24ndCB3aXNoIHRoZSBDTUFDIHN0YXlzIGF0IHN0cmFuZ2Ugc3Rh
dGUuIEl0IG1heSBpbmZsdWVuY2UNCnRoZSBmaXJtd2FyZSBvciBoYXJkd2FyZS4gQmVzaWRlcywg
SSBmaW5kIHRoZSBvcmlnaW5hbCBkcml2ZXIgb25seQ0KdXNlIFJUTkwgdG8gcHJvdGVjdCBjcml0
aWNhbCBzZWN0aW9uLiBJcyB0aGVyZSBhIGJldHRlciB3YXkgZm9yIGl0Pw0KDQpCZXN0IFJlZ2Fy
ZHMsDQpIYXllcw0KDQo=
