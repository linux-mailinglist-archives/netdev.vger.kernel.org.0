Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2252654A9B
	for <lists+netdev@lfdr.de>; Fri, 23 Dec 2022 02:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235205AbiLWB55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Dec 2022 20:57:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229627AbiLWB54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Dec 2022 20:57:56 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BF388C42;
        Thu, 22 Dec 2022 17:57:54 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BN1uEskD013722, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BN1uEskD013722
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Fri, 23 Dec 2022 09:56:14 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Fri, 23 Dec 2022 09:57:06 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 23 Dec 2022 09:57:05 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Fri, 23 Dec 2022 09:57:05 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     "icon@mricon.com" <icon@mricon.com>, Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jens Schleusener" <Jens.Schleusener@fossies.org>,
        Konstantin Ryabitsev <mricon@kernel.org>
Subject: RE: [PATCH] rtl8723ae: fix obvious spelling error tyep->type
Thread-Topic: [PATCH] rtl8723ae: fix obvious spelling error tyep->type
Thread-Index: AQHZFkOlMhKX+fVTnEGO1Lg/ZROhFa56tryg
Date:   Fri, 23 Dec 2022 01:57:05 +0000
Message-ID: <ac905b7e70094edcb3bcefe4b901428a@realtek.com>
References: <20221222-rtl8723ae-typo-fix-v1-1-848434b179c7@mricon.com>
In-Reply-To: <20221222-rtl8723ae-typo-fix-v1-1-848434b179c7@mricon.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzIyIOS4i+WNiCAxMDowMDowMA==?=
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

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEtvbnN0YW50aW4gUnlhYml0
c2V2IHZpYSBCNCBTdWJtaXNzaW9uIEVuZHBvaW50IDxkZXZudWxsK2ljb24ubXJpY29uLmNvbUBr
ZXJuZWwub3JnPg0KPiBTZW50OiBGcmlkYXksIERlY2VtYmVyIDIzLCAyMDIyIDQ6MjYgQU0NCj4g
VG86IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgS2FsbGUgVmFsbyA8a3ZhbG9A
a2VybmVsLm9yZz47IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+IEVy
aWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5jb20+DQo+IENjOiBsaW51eC13
aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtl
cm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEplbnMNCj4gU2NobGV1c2VuZXIgPEplbnMuU2NobGV1c2Vu
ZXJAZm9zc2llcy5vcmc+OyBLb25zdGFudGluIFJ5YWJpdHNldiA8bXJpY29uQGtlcm5lbC5vcmc+
OyBLb25zdGFudGluDQo+IFJ5YWJpdHNldiA8aWNvbkBtcmljb24uY29tPg0KPiBTdWJqZWN0OiBb
UEFUQ0hdIHJ0bDg3MjNhZTogZml4IG9idmlvdXMgc3BlbGxpbmcgZXJyb3IgdHllcC0+dHlwZQ0K
DQpzdWJqZWN0IHByZWZpeCBzaG91bGQgYmUgIndpZmk6IHJ0bHdpZmk6IHJ0bDg3MjNhZTogLi4u
Ig0KDQpPdGhlcnMgbG9vayBnb29kIHRvIG1lLg0KDQo+IA0KPiBGcm9tOiBLb25zdGFudGluIFJ5
YWJpdHNldiA8aWNvbkBtcmljb24uY29tPg0KPiANCj4gVGhpcyBhcHBlYXJzIHRvIGJlIGFuIG9i
dmlvdXMgc3BlbGxpbmcgZXJyb3IsIGluaXRpYWxseSBpZGVudGlmaWVkIGluIGENCj4gY29kZXNw
ZWxsIHJlcG9ydCBhbmQgbmV2ZXIgYWRkcmVzc2VkLg0KPiANCj4gUmVwb3J0ZWQtYnk6IEplbnMg
U2NobGV1c2VuZXIgPEplbnMuU2NobGV1c2VuZXJAZm9zc2llcy5vcmc+DQo+IExpbms6IGh0dHBz
Oi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjA1ODkxDQo+IFNpZ25lZC1v
ZmYtYnk6IEtvbnN0YW50aW4gUnlhYml0c2V2IDxpY29uQG1yaWNvbi5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9oYWxfYnRfY29l
eGlzdC5oIHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0
aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dGx3aWZpL3J0bDg3MjNhZS9oYWxfYnRfY29leGlzdC5oDQo+IGIvZHJpdmVycy9uZXQvd2lyZWxl
c3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9oYWxfYnRfY29leGlzdC5oDQo+IGluZGV4IDA0
NTVhMzcxMmYzZS4uMTJjZGVjZGFmYzMyIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJl
bGVzcy9yZWFsdGVrL3J0bHdpZmkvcnRsODcyM2FlL2hhbF9idF9jb2V4aXN0LmgNCj4gKysrIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3aWZpL3J0bDg3MjNhZS9oYWxfYnRfY29l
eGlzdC5oDQo+IEBAIC0xMTYsNyArMTE2LDcgQEAgdm9pZCBydGw4NzIzZV9kbV9idF9od19jb2V4
X2FsbF9vZmYoc3RydWN0IGllZWU4MDIxMV9odyAqaHcpOw0KPiAgbG9uZyBydGw4NzIzZV9kbV9i
dF9nZXRfcnhfc3Moc3RydWN0IGllZWU4MDIxMV9odyAqaHcpOw0KPiAgdm9pZCBydGw4NzIzZV9k
bV9idF9iYWxhbmNlKHN0cnVjdCBpZWVlODAyMTFfaHcgKmh3LA0KPiAgCQkJICAgIGJvb2wgYmFs
YW5jZV9vbiwgdTggbXMwLCB1OCBtczEpOw0KPiAtdm9pZCBydGw4NzIzZV9kbV9idF9hZ2NfdGFi
bGUoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHU4IHR5ZXApOw0KPiArdm9pZCBydGw4NzIzZV9k
bV9idF9hZ2NfdGFibGUoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHU4IHR5cGUpOw0KPiAgdm9p
ZCBydGw4NzIzZV9kbV9idF9iYl9iYWNrX29mZl9sZXZlbChzdHJ1Y3QgaWVlZTgwMjExX2h3ICpo
dywgdTggdHlwZSk7DQo+ICB1OCBydGw4NzIzZV9kbV9idF9jaGVja19jb2V4X3Jzc2lfc3RhdGUo
c3RydWN0IGllZWU4MDIxMV9odyAqaHcsDQo+ICAJCQkJCXU4IGxldmVsX251bSwgdTggcnNzaV90
aHJlc2gsDQo+IA0KPiAtLS0NCj4gYmFzZS1jb21taXQ6IDgzMGIzYzY4YzFmYjFlOTE3NjAyOGQw
MmVmODZmM2NmNzZhYTI0NzYNCj4gY2hhbmdlLWlkOiAyMDIyMTIyMi1ydGw4NzIzYWUtdHlwby1m
aXgtNWNjN2ZkYjdlZDZmDQo+IA0KPiBCZXN0IHJlZ2FyZHMsDQo+IC0tDQo+IEtvbnN0YW50aW4g
UnlhYml0c2V2IDxpY29uQG1yaWNvbi5jb20+DQo+IA0KPiAtLS0tLS1QbGVhc2UgY29uc2lkZXIg
dGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
