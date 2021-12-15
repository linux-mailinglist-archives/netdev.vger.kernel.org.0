Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 807FF4758C7
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 13:23:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242428AbhLOMXd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 07:23:33 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:36813 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbhLOMXc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 07:23:32 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BFCN88r8021830, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BFCN88r8021830
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Dec 2021 20:23:08 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 15 Dec 2021 20:23:08 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 15 Dec 2021 20:23:07 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Wed, 15 Dec 2021 20:23:07 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "kai.heng.feng@canonical.com" <kai.heng.feng@canonical.com>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "jian-hong@endlessm.com" <jian-hong@endlessm.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Bernie Huang <phhuang@realtek.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "briannorris@chromium.org" <briannorris@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] rtw88: Disable PCIe ASPM while doing NAPI poll on 8821CE
Thread-Topic: [PATCH v4] rtw88: Disable PCIe ASPM while doing NAPI poll on
 8821CE
Thread-Index: AQHX8amLQ1c7M9LrfUaQkh1Nis88KKwy82wA
Date:   Wed, 15 Dec 2021 12:23:07 +0000
Message-ID: <d2ddfaa035315ca91a2a05a8188810ff50db83c8.camel@realtek.com>
References: <20211215114635.333767-1-kai.heng.feng@canonical.com>
In-Reply-To: <20211215114635.333767-1-kai.heng.feng@canonical.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.1-2 
x-originating-ip: [114.26.206.138]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzE1IOS4iuWNiCAxMDo0NjowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-ID: <BE14E3E86E3CFF46A962ED5D3DBCEDA6@realtek.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIxLTEyLTE1IGF0IDE5OjQ2ICswODAwLCBLYWktSGVuZyBGZW5nIHdyb3RlOg0K
PiBNYW55IEludGVsIGJhc2VkIHBsYXRmb3JtcyBmYWNlIHN5c3RlbSByYW5kb20gZnJlZXplIGFm
dGVyIGNvbW1pdA0KPiA5ZTJmZDI5ODY0YzUgKCJydHc4ODogYWRkIG5hcGkgc3VwcG9ydCIpLg0K
PiANCj4gVGhlIGNvbW1pdCBpdHNlbGYgc2hvdWxkbid0IGJlIHRoZSBjdWxwcml0LiBNeSBndWVz
cyBpcyB0aGF0IHRoZSA4ODIxQ0UNCj4gb25seSBsZWF2ZXMgQVNQTSBMMSBmb3IgYSBzaG9ydCBw
ZXJpb2Qgd2hlbiBJUlEgaXMgcmFpc2VkLiBTaW5jZSBJUlEgaXMNCj4gbWFza2VkIGR1cmluZyBO
QVBJIHBvbGxpbmcsIHRoZSBQQ0llIGxpbmsgc3RheXMgYXQgTDEgYW5kIG1ha2VzIFJYIERNQQ0K
PiBleHRyZW1lbHkgc2xvdy4gRXZlbnR1YWxseSB0aGUgUlggcmluZyBiZWNvbWVzIG1lc3NlZCB1
cDoNCj4gWyAxMTMzLjE5NDY5N10gcnR3Xzg4MjFjZSAwMDAwOjAyOjAwLjA6IHBjaSBidXMgdGlt
ZW91dCwgY2hlY2sgZG1hIHN0YXR1cw0KPiANCj4gU2luY2UgdGhlIDg4MjFDRSBoYXJkd2FyZSBt
YXkgZmFpbCB0byBsZWF2ZSBBU1BNIEwxLCBtYW51YWxseSBkbyBpdCBpbg0KPiB0aGUgZHJpdmVy
IHRvIHJlc29sdmUgdGhlIGlzc3VlLg0KPiANCj4gRml4ZXM6IDllMmZkMjk4NjRjNSAoInJ0dzg4
OiBhZGQgbmFwaSBzdXBwb3J0IikNCj4gQnVnemlsbGE6IGh0dHBzOi8vYnVnemlsbGEua2VybmVs
Lm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE1MTMxDQo+IEJ1Z0xpbms6IGh0dHBzOi8vYnVncy5sYXVu
Y2hwYWQubmV0L2J1Z3MvMTkyNzgwOA0KPiBTaWduZWQtb2ZmLWJ5OiBLYWktSGVuZyBGZW5nIDxr
YWkuaGVuZy5mZW5nQGNhbm9uaWNhbC5jb20+DQoNClJldmlld2VkLWFuZC1UZXN0ZWQtYnk6IFBp
bmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQo+IC0tLQ0KPiB2NDoNCj4gIC0gUmVi
YXNlIHRvIHRoZSByaWdodCB0cmVlLg0KPiANCj4gdjM6DQo+ICAtIE1vdmUgdGhlIG1vZHVsZSBw
YXJhbWV0ZXIgdG8gYmUgcGFydCBvZiBwcml2YXRlIHN0cnVjdC4NCj4gIC0gRW5zdXJlIGxpbmtf
dXNhZ2UgbmV2ZXIgZ29lcyBiZWxvdyB6ZXJvLg0KPiANCj4gdjI6DQo+ICAtIEFkZCBkZWZhdWx0
IHZhbHVlIGZvciBtb2R1bGUgcGFyYW1ldGVyLg0KPiANCj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNz
L3JlYWx0ZWsvcnR3ODgvcGNpLmMgfCA3MCArKysrKysrLS0tLS0tLS0tLS0tLS0tLS0NCj4gIGRy
aXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmggfCAgMiArDQo+ICAyIGZpbGVz
IGNoYW5nZWQsIDIxIGluc2VydGlvbnMoKyksIDUxIGRlbGV0aW9ucygtKQ0KPiANCj4gDQoNClsu
Li5dDQoNCg0K
