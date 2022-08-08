Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51E9D58C39F
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 09:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiHHHEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 03:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiHHHEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 03:04:37 -0400
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 83A79B0A
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 00:04:34 -0700 (PDT)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 27874BVl8031527, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 27874BVl8031527
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Mon, 8 Aug 2022 15:04:11 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 15:04:21 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 8 Aug 2022 15:04:20 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97]) by
 RTEXMBS04.realtek.com.tw ([fe80::d902:19b0:8613:5b97%5]) with mapi id
 15.01.2375.007; Mon, 8 Aug 2022 15:04:20 +0800
From:   Hayes Wang <hayeswang@realtek.com>
To:     Oliver Neukum <oneukum@suse.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [RFC] r8152: pass through needs to be singular
Thread-Topic: [RFC] r8152: pass through needs to be singular
Thread-Index: AQHYorbkT7oEeBXrNkS3PRLAR8WbAK2cjJJwgAFoc4CABqlO0A==
Date:   Mon, 8 Aug 2022 07:04:20 +0000
Message-ID: <ee294e719e7b40acbc760eed8f781ba4@realtek.com>
References: <20220728191851.30402-1-oneukum@suse.com>
 <0f5422bbeb7642f492b99e9ec1f07751@realtek.com>
 <0c27917c-572a-7e70-3512-9357fabb458a@suse.com>
In-Reply-To: <0c27917c-572a-7e70-3512-9357fabb458a@suse.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.203]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzgvOCDkuIrljYggMDY6MTI6MDA=?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T2xpdmVyIE5ldWt1bSA8b25ldWt1bUBzdXNlLmNvbT4NCj4gU2VudDogVGh1cnNkYXksIEF1Z3Vz
dCA0LCAyMDIyIDQ6NTggUE0NClsuLi5dDQo+ID4+ICsJaWYgKCFob2xkZXJfb2ZfcGFzc190aHJv
dWdoKSB7DQo+ID4+ICsJCXJldCA9IC1FQlVTWTsNCj4gPj4gKwkJZ290byBmYWlsb3V0Ow0KPiA+
PiArCX0NCj4gPg0KPiA+IEV4Y3VzZSBtZS4gSSBoYXZlIG9uZSBxdWVzdGlvbi4NCj4gPiBXaGVu
IGlzIHRoZSBob2xkZXJfb2ZfcGFzc190aHJvdWdoIHNldD8NCj4gPiBUaGUgZGVmYXVsdCB2YWx1
ZSBvZiBob2xkZXJfb2ZfcGFzc190aHJvdWdoIGlzIE5VTEwsIHNvDQo+ID4gaXQgc2VlbXMgdGhl
IGhvbGRlcl9vZl9wYXNzX3Rocm91Z2ggd291bGQgbmV2ZXIgYmUgc2V0Lg0KPiANCj4gDQo+IEhp
LA0KPiANCj4gaGVyZSBpbiB2ZW5kb3JfbWFjX3Bhc3N0aHJ1X2FkZHJfcmVhZCgpDQoNCkkgbWVh
biB0aGF0IGhvbGRlcl9vZl9wYXNzX3Rocm91Z2ggaXMgTlVMTCwgc28geW91IHNldCByZXQgPSAt
RUJVU1kgYW5kIGdvdG8gZmFpbG91dC4NCkhvd2V2ZXIsIGhvbGRlcl9vZl9wYXNzX3Rocm91Z2gg
aXMgc2V0IG9ubHkgaWYgcmV0ID09IDAuIFRoYXQgaXMsDQpob2xkZXJfb2ZfcGFzc190aHJvdWdo
ID0gdHAgd291bGQgbmV2ZXIgb2NjdXIsIGJlY2F1c2UgcmV0IGlzIGVxdWFsIC1FQlVTWS4NClRo
ZSBkZWZhdWx0IHZhbHVlIG9mIGhvbGRlcl9vZl9wYXNzX3Rocm91Z2ggaXMgTlVMTCwgc28gaXQg
aGFzIG5vIGNoYW5jZSB0byBiZSBzZXQuDQpSaWdodD8NCg0KQmVzdCBSZWdhcmRzLA0KSGF5ZXMN
Cg0KPiA+PiAgYW1hY291dDoNCj4gPj4gIAlrZnJlZShvYmopOw0KPiA+PiArZmFpbG91dDoNCj4g
Pj4gKwlpZiAoIXJldCkNCj4gPj4gKwkJaG9sZGVyX29mX3Bhc3NfdGhyb3VnaCA9IHRwOw0KPiA+
PiArCW11dGV4X3VubG9jaygmcGFzc190aHJvdWdoX2xvY2spOw0KPiA+PiAgCXJldHVybiByZXQ7
DQo+ID4+ICB9DQo=
