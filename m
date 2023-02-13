Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D8AD693B59
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 01:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbjBMAdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 19:33:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjBMAdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 19:33:16 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E884CEFB6;
        Sun, 12 Feb 2023 16:33:13 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 31D0VlOI2012081, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 31D0VlOI2012081
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=OK);
        Mon, 13 Feb 2023 08:31:47 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Mon, 13 Feb 2023 08:31:49 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Mon, 13 Feb 2023 08:31:48 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02]) by
 RTEXMBS04.realtek.com.tw ([fe80::b4a2:2bcc:48d1:8b02%5]) with mapi id
 15.01.2375.007; Mon, 13 Feb 2023 08:31:48 +0800
From:   Ping-Ke Shih <pkshih@realtek.com>
To:     Hector Martin <marcan@marcan.st>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC:     Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Arend van Spriel" <arend.vanspriel@broadcom.com>
Subject: RE: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Topic: [PATCH v3 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
Thread-Index: AQHZPPqASPo0Y2xlw0ybs7L5iADUua7Hh+hggAF5swCAAweG8A==
Date:   Mon, 13 Feb 2023 00:31:48 +0000
Message-ID: <b7c79a4f35e147ad9b8da5d2409b1e7c@realtek.com>
References: <20230210025009.21873-1-marcan@marcan.st>
 <20230210025009.21873-2-marcan@marcan.st>
 <0cd45af5812345878faf0dc8fa6b0963@realtek.com>
 <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
In-Reply-To: <624c0a20-f4e6-14a5-02a2-eaf7b36e9331@marcan.st>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzIvMTIg5LiL5Y2IIDEwOjAwOjAw?=
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

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVjdG9yIE1hcnRpbiA8
bWFyY2FuQG1hcmNhbi5zdD4NCj4gU2VudDogU2F0dXJkYXksIEZlYnJ1YXJ5IDExLCAyMDIzIDY6
MDkgUE0NCj4gVG86IFBpbmctS2UgU2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgQXJlbmQgdmFu
IFNwcmllbCA8YXNwcmllbEBnbWFpbC5jb20+OyBGcmFua3kgTGluDQo+IDxmcmFua3kubGluQGJy
b2FkY29tLmNvbT47IEhhbnRlIE1ldWxlbWFuIDxoYW50ZS5tZXVsZW1hbkBicm9hZGNvbS5jb20+
OyBLYWxsZSBWYWxvIDxrdmFsb0BrZXJuZWwub3JnPjsNCj4gRGF2aWQgUy4gTWlsbGVyIDxkYXZl
bUBkYXZlbWxvZnQubmV0PjsgRXJpYyBEdW1hemV0IDxlZHVtYXpldEBnb29nbGUuY29tPjsgSmFr
dWIgS2ljaW5za2kNCj4gPGt1YmFAa2VybmVsLm9yZz47IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVk
aGF0LmNvbT4NCj4gQ2M6IEFsZXhhbmRlciBQcnV0c2tvdiA8YWxlcEBjeXByZXNzLmNvbT47IENo
aS1Ic2llbiBMaW4gPGNoaS1oc2llbi5saW5AY3lwcmVzcy5jb20+OyBXcmlnaHQgRmVuZw0KPiA8
d3JpZ2h0LmZlbmdAY3lwcmVzcy5jb20+OyBJYW4gTGluIDxpYW4ubGluQGluZmluZW9uLmNvbT47
IFNvb250YWsgTGVlIDxzb29udGFrLmxlZUBjeXByZXNzLmNvbT47IEpvc2VwaA0KPiBjaHVhbmcg
PGppYWNAY3lwcmVzcy5jb20+OyBTdmVuIFBldGVyIDxzdmVuQHN2ZW5wZXRlci5kZXY+OyBBbHlz
c2EgUm9zZW56d2VpZyA8YWx5c3NhQHJvc2VuendlaWcuaW8+Ow0KPiBBZGl0eWEgR2FyZyA8Z2Fy
Z2FkaXR5YTA4QGxpdmUuY29tPjsgSm9uYXMgR29yc2tpIDxqb25hcy5nb3Jza2lAZ21haWwuY29t
PjsgYXNhaGlAbGlzdHMubGludXguZGV2Ow0KPiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5v
cmc7IGJyY204MDIxMS1kZXYtbGlzdC5wZGxAYnJvYWRjb20uY29tOyBTSEEtY3lmbWFjLWRldi1s
aXN0QGluZmluZW9uLmNvbTsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVs
QHZnZXIua2VybmVsLm9yZzsgQXJlbmQgdmFuIFNwcmllbCA8YXJlbmQudmFuc3ByaWVsQGJyb2Fk
Y29tLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MyAxLzRdIHdpZmk6IGJyY21mbWFjOiBS
ZW5hbWUgQ3lwcmVzcyA4OTQ1OSB0byBCQ000MzU1DQo+IA0KPiBPbiAxMC8wMi8yMDIzIDEyLjQy
LCBQaW5nLUtlIFNoaWggd3JvdGU6DQo+ID4NCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3Nh
Z2UtLS0tLQ0KPiA+PiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiA+
PiBTZW50OiBGcmlkYXksIEZlYnJ1YXJ5IDEwLCAyMDIzIDEwOjUwIEFNDQo+ID4+IFRvOiBBcmVu
ZCB2YW4gU3ByaWVsIDxhc3ByaWVsQGdtYWlsLmNvbT47IEZyYW5reSBMaW4gPGZyYW5reS5saW5A
YnJvYWRjb20uY29tPjsgSGFudGUgTWV1bGVtYW4NCj4gPj4gPGhhbnRlLm1ldWxlbWFuQGJyb2Fk
Y29tLmNvbT47IEthbGxlIFZhbG8gPGt2YWxvQGtlcm5lbC5vcmc+OyBEYXZpZCBTLiBNaWxsZXIg
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBFcmljDQo+ID4+IER1bWF6ZXQgPGVkdW1hemV0QGdv
b2dsZS5jb20+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkg
PHBhYmVuaUByZWRoYXQuY29tPg0KPiA+PiBDYzogQWxleGFuZGVyIFBydXRza292IDxhbGVwQGN5
cHJlc3MuY29tPjsgQ2hpLUhzaWVuIExpbiA8Y2hpLWhzaWVuLmxpbkBjeXByZXNzLmNvbT47IFdy
aWdodCBGZW5nDQo+ID4+IDx3cmlnaHQuZmVuZ0BjeXByZXNzLmNvbT47IElhbiBMaW4gPGlhbi5s
aW5AaW5maW5lb24uY29tPjsgU29vbnRhayBMZWUgPHNvb250YWsubGVlQGN5cHJlc3MuY29tPjsN
Cj4gSm9zZXBoDQo+ID4+IGNodWFuZyA8amlhY0BjeXByZXNzLmNvbT47IFN2ZW4gUGV0ZXIgPHN2
ZW5Ac3ZlbnBldGVyLmRldj47IEFseXNzYSBSb3Nlbnp3ZWlnIDxhbHlzc2FAcm9zZW56d2VpZy5p
bz47DQo+ID4+IEFkaXR5YSBHYXJnIDxnYXJnYWRpdHlhMDhAbGl2ZS5jb20+OyBKb25hcyBHb3Jz
a2kgPGpvbmFzLmdvcnNraUBnbWFpbC5jb20+OyBhc2FoaUBsaXN0cy5saW51eC5kZXY7DQo+ID4+
IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgYnJjbTgwMjExLWRldi1saXN0LnBkbEBi
cm9hZGNvbS5jb207DQo+IFNIQS1jeWZtYWMtZGV2LWxpc3RAaW5maW5lb24uY29tOw0KPiA+PiBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBIZWN0
b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0PjsgQXJlbmQgdmFuDQo+IFNwcmllbA0KPiA+PiA8
YXJlbmQudmFuc3ByaWVsQGJyb2FkY29tLmNvbT4NCj4gPj4gU3ViamVjdDogW1BBVENIIHYzIDEv
NF0gd2lmaTogYnJjbWZtYWM6IFJlbmFtZSBDeXByZXNzIDg5NDU5IHRvIEJDTTQzNTUNCj4gPj4N
Cj4gPj4gVGhlIGNvbW1pdCB0aGF0IGludHJvZHVjZWQgc3VwcG9ydCBmb3IgdGhpcyBjaGlwIGlu
Y29ycmVjdGx5IGNsYWltZWQgaXQNCj4gPj4gaXMgYSBDeXByZXNzLXNwZWNpZmljIHBhcnQsIHdo
aWxlIGluIGFjdHVhbGl0eSBpdCBpcyBqdXN0IGEgdmFyaWFudCBvZg0KPiA+PiBCQ000MzU1IHNp
bGljb24gKGFzIGV2aWRlbmNlZCBieSB0aGUgY2hpcCBJRCkuDQo+ID4+DQo+ID4+IFRoZSByZWxh
dGlvbnNoaXAgYmV0d2VlbiBDeXByZXNzIHByb2R1Y3RzIGFuZCBCcm9hZGNvbSBwcm9kdWN0cyBp
c24ndA0KPiA+PiBlbnRpcmVseSBjbGVhciBidXQgZ2l2ZW4gd2hhdCBsaXR0bGUgaW5mb3JtYXRp
b24gaXMgYXZhaWxhYmxlIGFuZCBwcmlvcg0KPiA+PiBhcnQgaW4gdGhlIGRyaXZlciwgaXQgc2Vl
bXMgdGhlIGNvbnZlbnRpb24gc2hvdWxkIGJlIHRoYXQgb3JpZ2luYWxseQ0KPiA+PiBCcm9hZGNv
bSBwYXJ0cyBzaG91bGQgcmV0YWluIHRoZSBCcm9hZGNvbSBuYW1lLg0KPiA+Pg0KPiA+PiBUaHVz
LCByZW5hbWUgdGhlIHJlbGV2YW50IGNvbnN0YW50cyBhbmQgZmlybXdhcmUgZmlsZS4gQWxzbyBy
ZW5hbWUgdGhlDQo+ID4+IHNwZWNpZmljIDg5NDU5IFBDSWUgSUQgdG8gQkNNNDM1OTYsIHdoaWNo
IHNlZW1zIHRvIGJlIHRoZSBvcmlnaW5hbA0KPiA+PiBzdWJ2YXJpYW50IG5hbWUgZm9yIHRoaXMg
UENJIElEIChhcyBkZWZpbmVkIGluIHRoZSBvdXQtb2YtdHJlZSBiY21kaGQNCj4gPj4gZHJpdmVy
KS4NCj4gPj4NCj4gPj4gdjI6IFNpbmNlIEN5cHJlc3MgYWRkZWQgdGhpcyBwYXJ0IGFuZCB3aWxs
IHByZXN1bWFibHkgYmUgcHJvdmlkaW5nDQo+ID4+IGl0cyBzdXBwb3J0ZWQgZmlybXdhcmUsIHdl
IGtlZXAgdGhlIENZVyBkZXNpZ25hdGlvbiBmb3IgdGhpcyBkZXZpY2UuDQo+ID4+DQo+ID4+IHYz
OiBEcm9wIHRoZSBSQVcgZGV2aWNlIElEIGluIHRoaXMgY29tbWl0LiBXZSBkb24ndCBkbyB0aGlz
IGZvciB0aGUNCj4gPj4gb3RoZXIgY2hpcHMgc2luY2UgYXBwYXJlbnRseSBzb21lIGRldmljZXMg
d2l0aCB0aGVtIGV4aXN0IGluIHRoZSB3aWxkLA0KPiA+PiBidXQgdGhlcmUgaXMgYWxyZWFkeSBh
IDQzNTUgZW50cnkgd2l0aCB0aGUgQnJvYWRjb20gc3VidmVuZG9yIGFuZCBXQ0MNCj4gPj4gZmly
bXdhcmUgdmVuZG9yLCBzbyBhZGRpbmcgYSBnZW5lcmljIGZhbGxiYWNrIHRvIEN5cHJlc3Mgc2Vl
bXMNCj4gPj4gcmVkdW5kYW50IChubyByZWFzb24gd2h5IGEgZGV2aWNlIHdvdWxkIGhhdmUgdGhl
IHJhdyBkZXZpY2UgSUQgKmFuZCogYW4NCj4gPj4gZXhwbGljaXRseSBwcm9ncmFtbWVkIHN1YnZl
bmRvcikuDQo+ID4NCj4gPiBEbyB5b3UgcmVhbGx5IHdhbnQgdG8gYWRkIGNoYW5nZXMgb2YgdjIg
YW5kIHYzIHRvIGNvbW1pdCBtZXNzYWdlPyBPciwNCj4gPiBqdXN0IHdhbnQgdG8gbGV0IHJldmll
d2VycyBrbm93IHRoYXQ/IElmIGxhdHRlciBvbmUgaXMgd2hhdCB5b3Ugd2FudCwNCj4gPiBtb3Zl
IHRoZW0gYWZ0ZXIgcy1vLWIgd2l0aCBkZWxpbWl0ZXIgLS0tDQo+IA0KPiBCb3RoOyBJIHRob3Vn
aHQgdGhvc2UgdGhpbmdzIHdlcmUgd29ydGggbWVudGlvbmluZyBpbiB0aGUgY29tbWl0IG1lc3Nh
Z2UNCj4gYXMgaXQgc3RhbmRzIG9uIGl0cyBvd24sIGFuZCBsZWZ0IHRoZSB2ZXJzaW9uIHRhZ3Mg
aW4gc28gcmV2aWV3ZXJzIGtub3cNCj4gd2hlbiB0aGV5IHdlcmUgaW50cm9kdWNlZC4NCj4gDQoN
CldpdGggdGhpcyByZXBseSwgaXQgaXMgY2xlYXIgdGhhdCB5b3UgZGlkIHRob3NlIGludGVudGlv
bmFsbHksIG5vdCBmb3Jnb3QNCnNvbWV0aGluZywgc28gdGhpbmdzIGFyZSBjbGVhciB0byBtZS4g
VGhlIGZ1cnRoZXIgZGlzY3Vzc2lvbiBpbiBkaWZmZXJlbnQNCmFzcGVjdHMgb2YgdmlldyBpbiB0
aHJlYWQgYXJlIGFsc28gaGVscGZ1bCBmb3IgbWUgdG8gZ2V0IG11Y2guDQoNClBpbmctS2UNCg0K
