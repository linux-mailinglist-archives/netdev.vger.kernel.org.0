Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93AAE661BB0
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 01:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbjAIAzu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 19:55:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbjAIAzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 19:55:49 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9086E003;
        Sun,  8 Jan 2023 16:55:44 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 3090sExG5030592, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 3090sExG5030592
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 9 Jan 2023 08:54:14 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 9 Jan 2023 08:55:11 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 9 Jan 2023 08:55:11 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 9 Jan 2023 08:55:11 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     gert erkelens <g.erkelens5@xs4all.nl>,
        "martin.blumenstingl@googlemail.com" 
        <martin.blumenstingl@googlemail.com>
CC:     "kvalo@kernel.org" <kvalo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>
Subject: RE: [PATCH 0/4] rtw88: Four fixes found while working on SDIO support
Thread-Topic: [PATCH 0/4] rtw88: Four fixes found while working on SDIO
 support
Thread-Index: AQHZG4P4Sc+U6Hvh6Ee2nkMHb6GZz66SzQKAgAKD9uA=
Date:   Mon, 9 Jan 2023 00:55:11 +0000
Message-ID: <7e576a8bb5344543aa2a227b97f3cb1d@realtek.com>
References: <20221229124845.1155429-1-martin.blumenstingl@googlemail.com>
 <8434a0c6-839c-36cc-2539-a00d1e32bd8d@xs4all.nl>
In-Reply-To: <8434a0c6-839c-36cc-2539-a00d1e32bd8d@xs4all.nl>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvOCDkuIvljYggMTA6MDA6MDA=?=
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogZ2VydCBlcmtlbGVucyA8
Zy5lcmtlbGVuczVAeHM0YWxsLm5sPg0KPiBTZW50OiBTdW5kYXksIEphbnVhcnkgOCwgMjAyMyAy
OjIzIEFNDQo+IFRvOiBtYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tDQo+IENjOiBr
dmFsb0BrZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IFBpbmctS2Ug
U2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgcy5oYXVlckBwZW5ndXRyb25peC5kZTsNCj4gdG9u
eTA2MjBlbW1hQGdtYWlsLmNvbQ0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDAvNF0gcnR3ODg6IEZv
dXIgZml4ZXMgZm91bmQgd2hpbGUgd29ya2luZyBvbiBTRElPIHN1cHBvcnQNCj4gDQo+IEluIHRo
ZSBjb3Vyc2Ugb2YgMyB3ZWVrcyBteSBTaHV0dGxlIERTMTBVIGJhcmUgYm9uZSBydW5uaW5nIFVi
dW50dSAyMi4wNCBzZXJ2ZXIgbG9ja2VkIHVwIDMgdGltZXMuDQo+IEknbSB1c2luZyB0aGUgUmVh
bHRlayBSVEw4ODIyQ0UgUENJZSBtb2R1bGUgaW4gYWNjZXNzIHBvaW50IG1vZGUuDQo+IEJlbG93
IGEgZHVtcCBvZiB0aGUgZmlyc3QgbG9jayB1cC4gVGhlcmUgaXMgbm8gbG9nIGZyb20gdGhlIG90
aGVyIHR3byBsb2NrdXBzLCBwb3NzaWJseSBiZWNhdXNlIG9mDQo+ICdvcHRpb25zIHJ0dzg4X3Bj
aSBkaXNhYmxlX2FzcG09MScgaW4gcnR3ODhfcGNpLmNvbmYNCj4gDQo+IEkgaG9wZSB0aGlzIGlz
IG9mIGFueSB1c2UgdG8geW91Lg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBHZXJ0IEVya2VsZW5z
DQo+IA0KPiANCj4gRGVjIDI5IDIyOjI0OjI5IHNodXR0bGUga2VybmVsOiBbOTgzMjguODEzODgw
XSBCVUc6IHNjaGVkdWxpbmcgd2hpbGUgYXRvbWljOg0KPiBrd29ya2VyL3U0OjAvNzU5Mi8weDAw
MDAwNzAwDQoNClsuLi5dDQoNCj4gRGVjIDI5IDIyOjI0OjI5IHNodXR0bGUga2VybmVsOiBbOTgz
MjguODE0MDMyXSBDUFU6IDAgUElEOiA3NTkyIENvbW06IGt3b3JrZXIvdTQ6MCBOb3QgdGFpbnRl
ZA0KPiA1LjE1LjAtNTYtZ2VuZXJpYyAjNjItVWJ1bnR1DQoNClRoZSB0cmFjZSBiZWxvdyBpcyB2
ZXJ5IHNpbWlsYXIgdG8gdGhpcyBmaXgNCjc3MTFmZTcxM2E0OSAoIndpZmk6IHJ0dzg4OiBhZGQg
YSB3b3JrIHRvIGNvcnJlY3QgYXRvbWljIHNjaGVkdWxpbmcgd2FybmluZyBvZiA6OnNldF90aW0i
KQ0KUGxlYXNlIGNoZWNrIGlmIHRoZSBkcml2ZXIgeW91IGFyZSB1c2luZyBpbmNsdWRlcyBpdC4N
Cg0KQnkgdGhlIHdheSwgOjpzZXRfdGltZSBpcyBhZGRlZCBhZnRlciA1LjE5LCBidXQgeW91ciBr
ZXJuZWwgaXMgNS4xNS4wLTU2LWdlbmVyaWMNCg0KUGluZy1LZQ0KDQo=
