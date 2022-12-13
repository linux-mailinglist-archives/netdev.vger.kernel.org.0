Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2D0264B98B
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 17:23:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbiLMQXf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 11:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiLMQXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 11:23:30 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 353BEBF7
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 08:23:27 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2BDGMMtzC007428, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2BDGMMtzC007428
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Wed, 14 Dec 2022 00:22:22 +0800
Received: from RTEXMBS05.realtek.com.tw (172.21.6.98) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.32; Wed, 14 Dec 2022 00:23:11 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS05.realtek.com.tw (172.21.6.98) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Wed, 14 Dec 2022 00:23:10 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Wed, 14 Dec 2022 00:23:10 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHZBZK0jNmNF43ANUm+ON2R2qDGTK5d0aqAgATjHlD//8MxAIABsEYw///gi4CAAbFP8P//+V0AAJTwo+AAAFtNgAA2Y27A
Date:   Tue, 13 Dec 2022 16:23:10 +0000
Message-ID: <8f1ecb5c45d0438293baaf39ea1e0bea@realtek.com>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
 <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
 <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
 <7f460a37-d6f5-603f-2a6c-c65bae56f76b@gmail.com>
 <8b38c9f4552346ed84ba204b3e5edd5d@realtek.com>
 <6de467f2-e811-afbb-ab6f-f43f5456a857@gmail.com>
 <3395f909ef24454ca984a1b7977e0af4@realtek.com>
 <b3ded529-3676-3d7c-4ed8-a94de470b5d7@gmail.com>
In-Reply-To: <b3ded529-3676-3d7c-4ed8-a94de470b5d7@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.74]
x-kse-serverinfo: RTEXMBS05.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzEzIOS4i+WNiCAwMjowMDowMA==?=
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

PiANCj4gT24gMTIuMTIuMjAyMiAxNToxMSwgSGF1IHdyb3RlOg0KPiA+PiBPbiAwOS4xMi4yMDIy
IDE2OjI5LCBIYXUgd3JvdGU6DQo+ID4+Pj4NCj4gPj4+PiBPSywgSSB0aGluayBJIGdldCBhIGJl
dHRlciBpZGVhIG9mIHlvdXIgc2V0dXAuDQo+ID4+Pj4gU28gaXQgc2VlbXMgUlRMODIxMUZTIGlu
ZGVlZCBhY3RzIGFzIG1lZGlhIGNvbnZlcnRlci4gTGluayBzdGF0dXMNCj4gPj4+PiBvbiBNREkg
c2lkZSBvZiBSVEw4MjExRlMgcmVmbGVjdHMgbGluayBzdGF0dXMgb24gZmliZXIvc2VyZGVzIHNp
ZGUuDQo+ID4+Pj4gUlRMODE2OEggUEhZIGhhcyBubyBpZGVhIHdoZXRoZXIgaXQncyBjb25uZWN0
ZWQgdG8gUko0NSBtYWduZXRpY3MNCj4gPj4+PiBvciB0byB0aGUgTURJIHNpZGUgb2YgYSBSVEw4
MjExRlMuDQo+ID4+Pj4NCj4gPj4+PiBJIHRoaW5rIGZvciBjb25maWd1cmluZyBSVEw4MjExRlMg
eW91IGhhdmUgdHdvIG9wdGlvbnM6DQo+ID4+Pj4gMS4gRXh0ZW5kIHRoZSBSZWFsdGVrIFBIWSBk
cml2ZXIgdG8gc3VwcG9ydCBSVEw4MjExRlMgZmliZXIgbW9kZSAyLg0KPiA+Pj4+IENvbmZpZ3Vy
ZSBSVEw4MjExRlMgZnJvbSB1c2Vyc3BhY2UgKHBoeXRvb2wsIG1paS10b29sLCAuLikuIEhvd2V2
ZXINCj4gPj4+PiB0byBiZSBhYmxlIHRvIGRvIHRoaXMgeW91IG1heSBuZWVkIHRvIGFkZCBhIGR1
bW15IG5ldGRldmljZQ0KPiA+Pj4+ICAgIHRoYXQgUlRMODIxMUZTIGlzIGF0dGFjaGVkIHRvLiBX
aGVuIGdvaW5nIHdpdGggdGhpcyBvcHRpb24gaXQNCj4gPj4+PiBtYXkgYmUgYmV0dGVyIHRvIGF2
b2lkIHBoeWxpYiB0YWtpbmcgY29udHJvbCBvZiBSVEw4MjExRlMuDQo+ID4+Pj4gICAgVGhpcyBj
YW4gYmUgZG9uZSBieSBzZXR0aW5nIHRoZSBwaHlfbWFzayBvZiB0aGUgYml0LWJhbmdlZCBtaWlf
YnVzLg0KPiA+Pj4NCj4gPj4+IFRoYW5rcyBmb3IgeW91ciBhZHZhaWNlLg0KPiA+Pj4gSXMgdGhh
dCBwb3NzaWJsZSBmb3IgdXMgdG8gcmVnaXN0ZXIgYSBQSFkgZml4dXANCj4gPj4+IGZ1bmN0aW9u
KHBoeV9yZWdpc3Rlcl9maXh1cCgpKQ0KPiA+PiB0byBzZXR1cCBydGw4MjExZnMgaW5zdGVhZCBv
ZiBzZXR1cCBpdCBpbiBQSFkgZHJpdmVyPw0KPiA+Pj4NCj4gPj4gRnJvbSB3aGVyZSB3b3VsZCB5
b3UgbGlrZSB0byByZWdpc3RlciB0aGUgUEhZIGZpeHVwPyByODE2OSB3b3VsZCBiZQ0KPiA+PiB0
aGUgd3JvbmcgcGxhY2UgaGVyZS4NCj4gPj4gVGhlcmUgYXJlIHZlcnkgZmV3IGRyaXZlcnMgdXNp
bmcgYSBQSFkgZml4dXAgYW5kIEFGQUlDUyB0eXBpY2FsbHkgUEhZDQo+ID4+IGRyaXZlcnMgYXBw
bHkgZml4dXBzIGZyb20gdGhlIGNvbmZpZ19pbml0IGNhbGxiYWNrLg0KPiA+PiBIYXZpbmcgc2Fp
ZCB0aGF0LCBpZiBwb3NzaWJsZSBJJ2QgcmVjb21tZW5kIHRvIGF2b2lkIHVzaW5nIGEgUEhZIGZp
eHVwLg0KPiA+Pg0KPiA+IFRoYW5rcyBmb3IgeW91ciBwcm9tcHQgcmVwbHkuIEkgdGhpbmsgaW4g
bmV4dCBwYXRjaCBJIHdpbGwgcmVtb3ZlIHRoZQ0KPiBydGw4MjExZnMgcGh5IHBhcmFtZXRlciBz
ZXR0aW5nLg0KPiA+IEFuZCBvbmx5IGtlZXAgbm9uIHNwZWVkIGRvd24gcGF0Y2guDQo+ID4gSWYg
dGhlcmUncyBhbnkgcG9zc2liaWxpdHkgSSdkIGxpa2UgdG8gYXZvaWQgdGhlIG5vbiBzcGVlZCBk
b3duIHBhdGNoLg0KPiBZb3Ugd291bGQgaGF2ZSB0byB0aGluayBhbHNvIGFib3V0IHRoZSBjYXNl
IHRoYXQgYSB1c2VyIHVzZXMgZXRodG9vbCB0bw0KPiByZXN0cmljdCBhZHZlcnRpc2VtZW50IHRv
IDEwME1icHMsIHdoYXQgd291bGQgYnJlYWsgdGhlIGNvbm5lY3Rpb24uDQo+IHI4MTY5IGlzbid0
IHRoZSByaWdodCBwbGFjZSBmb3IgYSB3b3JrYXJvdW5kIGZvciBhIGJyb2tlbiBtZWRpYSBjb252
ZXJ0ZXIuDQo+IFRoZSBtZWRpYSBjb252ZXJ0ZXIgc2hvdWxkIGJlIGZ1bGx5IHRyYW5zcGFyZW50
IHRvIHI4MTY5Lg0KPiANCj4gUlRMODIxMUZTIHNob3VsZCBhbGlnbiB0aGUgYWR2ZXJ0aXNlbWVu
dCBvbiBNREkgc2lkZSB3aXRoIHRoZSBsaW5rIHNwZWVkIG9uDQo+IGZpYmVyIHNpZGUsIGJhc2Vk
IG9uIFNHTUlJIGluLWJhbmQgaW5mb3JtYXRpb24uDQo+IElmIHRoZSBmaWJlciBsaW5rIGlzIDFH
YnBzIGl0IG11c3Qgbm90IGFkdmVydGlzZSAxMDBNYnBzIG9uIE1ESSBzaWRlLg0KPiANClRoZSBm
dyBpbiBydGw4MjExZnMgd2lsbCBkZWZhdWx0IGFkdmVydGlzZSAxMDBNYnBzIGFuZCAxMDAwTWJw
cyAgb24gTURJIHNpZGUuIA0KV2UgYXJlIHRyeWluZyB0byBmaW5kIGEgd2F5IHRvIGZpeCB0aGlz
IGlzc3VlLiBJZiB3ZSBjYW5ub3QgZml4IHRoaXMgaXNzdWUgYnkgZncgdGhhbiB3ZQ0Kd2lsbCBz
dWJtaXQgYSBwYXRjaCBmb3IgdGhpcyBpc3N1ZS4NCiAgDQotLS0tLS1QbGVhc2UgY29uc2lkZXIg
dGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4NCg==
