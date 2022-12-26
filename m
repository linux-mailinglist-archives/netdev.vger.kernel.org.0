Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C27C6560DF
	for <lists+netdev@lfdr.de>; Mon, 26 Dec 2022 08:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbiLZHr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Dec 2022 02:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiLZHrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Dec 2022 02:47:25 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C0EDD2640;
        Sun, 25 Dec 2022 23:47:24 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BQ7jg4C3018991, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BQ7jg4C3018991
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 26 Dec 2022 15:45:42 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 26 Dec 2022 15:46:35 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS04.realtek.com.tw (172.21.6.97) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 26 Dec 2022 15:46:35 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Mon, 26 Dec 2022 15:46:35 +0800
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
Subject: RE: [PATCH v2] wifi: rtlwifi: rtl8723ae: fix obvious spelling error tyep->type
Thread-Topic: [PATCH v2] wifi: rtlwifi: rtl8723ae: fix obvious spelling error
 tyep->type
Thread-Index: AQHZFvs+eP0nSLMTWUKthJH9b6EQHa5/zlXg
Date:   Mon, 26 Dec 2022 07:46:35 +0000
Message-ID: <cdcfe0b56ee749658fdf1bf6470e3dbb@realtek.com>
References: <20221222-rtl8723ae-typo-fix-v2-1-71b6b67df3f5@mricon.com>
In-Reply-To: <20221222-rtl8723ae-typo-fix-v2-1-71b6b67df3f5@mricon.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS04.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzI2IOS4iuWNiCAwNDozNzowMA==?=
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS29uc3RhbnRpbiBSeWFi
aXRzZXYgdmlhIEI0IFN1Ym1pc3Npb24gRW5kcG9pbnQgPGRldm51bGwraWNvbi5tcmljb24uY29t
QGtlcm5lbC5vcmc+DQo+IFNlbnQ6IFNhdHVyZGF5LCBEZWNlbWJlciAyNCwgMjAyMiAyOjIwIEFN
DQo+IFRvOiBQaW5nLUtlIFNoaWggPHBrc2hpaEByZWFsdGVrLmNvbT47IEthbGxlIFZhbG8gPGt2
YWxvQGtlcm5lbC5vcmc+OyBEYXZpZCBTLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0K
PiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPg0KPiBDYzogbGlu
dXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBKZW5zDQo+IFNjaGxldXNlbmVyIDxKZW5zLlNjaGxl
dXNlbmVyQGZvc3NpZXMub3JnPjsgS29uc3RhbnRpbiBSeWFiaXRzZXYgPG1yaWNvbkBrZXJuZWwu
b3JnPjsgS29uc3RhbnRpbg0KPiBSeWFiaXRzZXYgPGljb25AbXJpY29uLmNvbT4NCj4gU3ViamVj
dDogW1BBVENIIHYyXSB3aWZpOiBydGx3aWZpOiBydGw4NzIzYWU6IGZpeCBvYnZpb3VzIHNwZWxs
aW5nIGVycm9yIHR5ZXAtPnR5cGUNCj4gDQo+IEZyb206IEtvbnN0YW50aW4gUnlhYml0c2V2IDxp
Y29uQG1yaWNvbi5jb20+DQo+IA0KPiBUaGlzIGFwcGVhcnMgdG8gYmUgYW4gb2J2aW91cyBzcGVs
bGluZyBlcnJvciwgaW5pdGlhbGx5IGlkZW50aWZpZWQgaW4gYQ0KPiBjb2Rlc3BlbGwgcmVwb3J0
IGFuZCBuZXZlciBhZGRyZXNzZWQuDQo+IA0KPiBSZXBvcnRlZC1ieTogSmVucyBTY2hsZXVzZW5l
ciA8SmVucy5TY2hsZXVzZW5lckBmb3NzaWVzLm9yZz4NCj4gTGluazogaHR0cHM6Ly9idWd6aWxs
YS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0yMDU4OTENCj4gU2lnbmVkLW9mZi1ieTogS29u
c3RhbnRpbiBSeWFiaXRzZXYgPGljb25AbXJpY29uLmNvbT4NCg0KQWNrZWQtYnk6IFBpbmctS2Ug
U2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KDQo+IC0tLQ0KPiBDaGFuZ2VzIGluIHYyOg0KPiAt
IFVwZGF0ZWQgY29tbWl0IHN1YmplY3QgYmFzZWQgb24gZmVlZGJhY2suDQo+IC0gTGluayB0byB2
MTogaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvci8yMDIyMTIyMi1ydGw4NzIzYWUtdHlwby1maXgt
djEtMS04NDg0MzRiMTc5YzdAbXJpY29uLmNvbQ0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvaGFsX2J0X2NvZXhpc3QuaCB8IDIgKy0NCj4g
IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUv
aGFsX2J0X2NvZXhpc3QuaA0KPiBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnRsd2lm
aS9ydGw4NzIzYWUvaGFsX2J0X2NvZXhpc3QuaA0KPiBpbmRleCAwNDU1YTM3MTJmM2UuLjEyY2Rl
Y2RhZmMzMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydGx3
aWZpL3J0bDg3MjNhZS9oYWxfYnRfY29leGlzdC5oDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnRsd2lmaS9ydGw4NzIzYWUvaGFsX2J0X2NvZXhpc3QuaA0KPiBAQCAtMTE2
LDcgKzExNiw3IEBAIHZvaWQgcnRsODcyM2VfZG1fYnRfaHdfY29leF9hbGxfb2ZmKHN0cnVjdCBp
ZWVlODAyMTFfaHcgKmh3KTsNCj4gIGxvbmcgcnRsODcyM2VfZG1fYnRfZ2V0X3J4X3NzKHN0cnVj
dCBpZWVlODAyMTFfaHcgKmh3KTsNCj4gIHZvaWQgcnRsODcyM2VfZG1fYnRfYmFsYW5jZShzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywNCj4gIAkJCSAgICBib29sIGJhbGFuY2Vfb24sIHU4IG1zMCwg
dTggbXMxKTsNCj4gLXZvaWQgcnRsODcyM2VfZG1fYnRfYWdjX3RhYmxlKHN0cnVjdCBpZWVlODAy
MTFfaHcgKmh3LCB1OCB0eWVwKTsNCj4gK3ZvaWQgcnRsODcyM2VfZG1fYnRfYWdjX3RhYmxlKHN0
cnVjdCBpZWVlODAyMTFfaHcgKmh3LCB1OCB0eXBlKTsNCj4gIHZvaWQgcnRsODcyM2VfZG1fYnRf
YmJfYmFja19vZmZfbGV2ZWwoc3RydWN0IGllZWU4MDIxMV9odyAqaHcsIHU4IHR5cGUpOw0KPiAg
dTggcnRsODcyM2VfZG1fYnRfY2hlY2tfY29leF9yc3NpX3N0YXRlKHN0cnVjdCBpZWVlODAyMTFf
aHcgKmh3LA0KPiAgCQkJCQl1OCBsZXZlbF9udW0sIHU4IHJzc2lfdGhyZXNoLA0KPiANCj4gLS0t
DQo+IGJhc2UtY29tbWl0OiA4MzBiM2M2OGMxZmIxZTkxNzYwMjhkMDJlZjg2ZjNjZjc2YWEyNDc2
DQo+IGNoYW5nZS1pZDogMjAyMjEyMjItcnRsODcyM2FlLXR5cG8tZml4LTVjYzdmZGI3ZWQ2Zg0K
PiANCj4gQmVzdCByZWdhcmRzLA0KPiAtLQ0KPiBLb25zdGFudGluIFJ5YWJpdHNldiA8aWNvbkBt
cmljb24uY29tPg0KPiANCj4gLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBi
ZWZvcmUgcHJpbnRpbmcgdGhpcyBlLW1haWwuDQo=
