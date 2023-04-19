Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24EC36E706A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231847AbjDSAV7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231846AbjDSAV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:21:57 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1DEAD0F;
        Tue, 18 Apr 2023 17:21:41 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 33J0LIEU0020318, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 33J0LIEU0020318
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Wed, 19 Apr 2023 08:21:18 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 19 Apr 2023 08:21:18 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Wed, 19 Apr 2023 08:21:17 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d]) by
 RTEXMBS04.realtek.com.tw ([fe80::e138:e7f1:4709:ff4d%5]) with mapi id
 15.01.2375.007; Wed, 19 Apr 2023 08:21:17 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Simon Horman <horms@kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtw88: Update spelling in main.h
Thread-Topic: [PATCH] wifi: rtw88: Update spelling in main.h
Thread-Index: AQHZcekPzqqRCrN6s0KgDL1BV7vRMa8xxdRg
Date:   Wed, 19 Apr 2023 00:21:17 +0000
Message-ID: <a3fb91e421d44c7ea06cff0deea531c5@realtek.com>
References: <20230418-rtw88-starspell-v1-1-70e52a23979b@kernel.org>
In-Reply-To: <20230418-rtw88-starspell-v1-1-70e52a23979b@kernel.org>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-antispam-interceptor-info: fallback
x-kse-antivirus-interceptor-info: fallback
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-AntiSpam-Interceptor-Info: fallback
X-KSE-Antivirus-Interceptor-Info: fallback
X-KSE-AntiSpam-Interceptor-Info: fallback
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2ltb24gSG9ybWFuIDxo
b3Jtc0BrZXJuZWwub3JnPg0KPiBTZW50OiBUdWVzZGF5LCBBcHJpbCAxOCwgMjAyMyA3OjI5IFBN
DQo+IFRvOiBZYW4tSHN1YW4gQ2h1YW5nIDx0b255MDYyMGVtbWFAZ21haWwuY29tPjsgS2FsbGUg
VmFsbyA8a3ZhbG9Aa2VybmVsLm9yZz4NCj4gQ2M6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtp
Y2luc2tpDQo+IDxrdWJhQGtlcm5lbC5vcmc+OyBQYW9sbyBBYmVuaSA8cGFiZW5pQHJlZGhhdC5j
b20+OyBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7DQo+IG5ldGRldkB2Z2VyLmtlcm5l
bC5vcmcNCj4gU3ViamVjdDogW1BBVENIXSB3aWZpOiBydHc4ODogVXBkYXRlIHNwZWxsaW5nIGlu
IG1haW4uaA0KPiANCj4gVXBkYXRlIHNwZWxsaW5nIGluIGNvbW1lbnRzIGluIG1haW4uaA0KPiAN
Cj4gRm91bmQgYnkgaW5zcGVjdGlvbi4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNpbW9uIEhvcm1h
biA8aG9ybXNAa2VybmVsLm9yZz4NCg0KUmV2aWV3ZWQtYnk6IFBpbmctS2UgU2hpaCA8cGtzaGlo
QHJlYWx0ZWsuY29tPg0KDQoNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVr
L3J0dzg4L21haW4uaCB8IDYgKysrLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCAzIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5oIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9y
dHc4OC9tYWluLmgNCj4gaW5kZXggZDRhNTNkNTU2NzQ1Li42MTEwNjc0MjM5NGEgMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5oDQo+ICsrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5oDQo+IEBAIC04OCw3ICs4
OCw3IEBAIGVudW0gcnR3X3N1cHBvcnRlZF9iYW5kIHsNCj4gICAgICAgICBSVFdfQkFORF82MEcg
PSBCSVQoTkw4MDIxMV9CQU5EXzYwR0haKSwNCj4gIH07DQo+IA0KPiAtLyogbm93LCBzdXBwb3J0
IHVwdG8gODBNIGJ3ICovDQo+ICsvKiBub3csIHN1cHBvcnQgdXAgdG8gODBNIGJ3ICovDQo+ICAj
ZGVmaW5lIFJUV19NQVhfQ0hBTk5FTF9XSURUSCBSVFdfQ0hBTk5FTF9XSURUSF84MA0KPiANCj4g
IGVudW0gcnR3X2JhbmR3aWR0aCB7DQo+IEBAIC0xODcxLDcgKzE4NzEsNyBAQCBlbnVtIHJ0d19z
YXJfYmFuZHMgew0KPiAgICAgICAgIFJUV19TQVJfQkFORF9OUiwNCj4gIH07DQo+IA0KPiAtLyog
dGhlIHVuaW9uIGlzIHJlc2VydmVkIGZvciBvdGhlciBrbmlkcyBvZiBTQVIgc291cmNlcw0KPiAr
LyogdGhlIHVuaW9uIGlzIHJlc2VydmVkIGZvciBvdGhlciBraW5kcyBvZiBTQVIgc291cmNlcw0K
PiAgICogd2hpY2ggbWlnaHQgbm90IHJlLXVzZSBzYW1lIGZvcm1hdCB3aXRoIGFycmF5IGNvbW1v
bi4NCj4gICAqLw0KPiAgdW5pb24gcnR3X3Nhcl9jZmcgew0KPiBAQCAtMjAyMCw3ICsyMDIwLDcg
QEAgc3RydWN0IHJ0d19kZXYgew0KPiAgICAgICAgIHN0cnVjdCBydHdfdHhfcmVwb3J0IHR4X3Jl
cG9ydDsNCj4gDQo+ICAgICAgICAgc3RydWN0IHsNCj4gLSAgICAgICAgICAgICAgIC8qIGluY2lj
YXRlIHRoZSBtYWlsIGJveCB0byB1c2Ugd2l0aCBmdyAqLw0KPiArICAgICAgICAgICAgICAgLyog
aW5kaWNhdGUgdGhlIG1haWwgYm94IHRvIHVzZSB3aXRoIGZ3ICovDQo+ICAgICAgICAgICAgICAg
ICB1OCBsYXN0X2JveF9udW07DQo+ICAgICAgICAgICAgICAgICB1MzIgc2VxOw0KPiAgICAgICAg
IH0gaDJjOw0KPiANCj4gDQo+IC0tLS0tLVBsZWFzZSBjb25zaWRlciB0aGUgZW52aXJvbm1lbnQg
YmVmb3JlIHByaW50aW5nIHRoaXMgZS1tYWlsLg0K
