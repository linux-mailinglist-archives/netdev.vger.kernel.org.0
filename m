Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F1F267244C
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 17:57:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjARQ5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 11:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjARQ5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 11:57:23 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0BBA6458A6
        for <netdev@vger.kernel.org>; Wed, 18 Jan 2023 08:57:21 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 30IGvBaW5019161, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 30IGvBaW5019161
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 19 Jan 2023 00:57:11 +0800
Received: from RTEXMBS01.realtek.com.tw (172.21.6.94) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 19 Jan 2023 00:57:12 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS01.realtek.com.tw (172.21.6.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 19 Jan 2023 00:57:11 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 19 Jan 2023 00:57:11 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Topic: [PATCH net] r8169: fix rtl8168h wol fail
Thread-Index: AQHZITAeQEw7+pbiWEKyObvpj0H4U66PsbSAgAAedICAARt84IAASKWAgAayTHD//86LgIABruOg//+8sACAACFVAIADUFuA//9/cYAADErCAACZvlRA//+eEwD//Ge5kA==
Date:   Wed, 18 Jan 2023 16:57:11 +0000
Message-ID: <34af6a17f84f4720b13b8b7c61202903@realtek.com>
References: <714782c5-b955-4511-23c0-9688224bba84@gmail.com>
 <Y7dAbxSPeaMnW/ly@lunn.ch> <9ee2f626bab3481697b71c58091e7def@realtek.com>
 <4014d243-8f8a-f273-fba8-2ae5a3844ea5@gmail.com>
 <6ff876a66e154bb4b357b31465c86741@realtek.com>
 <d28834dc-0426-5813-a24d-181839f23c38@gmail.com>
 <add32dc486bb4fc9abc283b2bb39efc3@realtek.com>
 <e201750b-f3be-b62d-4dc6-2a00f4834256@gmail.com> <Y78ssmMck/eZTpYz@lunn.ch>
 <d34e9d2f3a0d4ae8988d39b865de987b@realtek.com> <Y8GIgXKCtaYzpFdW@lunn.ch>
 <939fae88-ab42-132a-81d8-bbedfc20344e@gmail.com>
 <5084ca55d66f4e449253e54081e86986@realtek.com>
 <67a2e465-7a7b-6928-eefd-773c65a9b08d@gmail.com>
In-Reply-To: <67a2e465-7a7b-6928-eefd-773c65a9b08d@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.228.56]
x-kse-serverinfo: RTEXMBS01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIzLzEvMTgg5LiL5Y2IIDAyOjM1OjAw?=
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

PiBPbiAxNi4wMS4yMDIzIDE4OjA0LCBIYXUgd3JvdGU6DQo+ID4+IE9uIDEzLjAxLjIwMjMgMTc6
MzYsIEFuZHJldyBMdW5uIHdyb3RlOg0KPiA+Pj4gT24gRnJpLCBKYW4gMTMsIDIwMjMgYXQgMDQ6
MjM6NDVQTSArMDAwMCwgSGF1IHdyb3RlOg0KPiA+Pj4+Pj4+Pj4gSW4gdGhpcyBhcHBsaWNhdGlv
bihydGw4MTY4aCArIHJ0bDgyMTFmcykgaXQgYWxzbyBzdXBwb3J0cw0KPiA+Pj4+Pj4+Pj4gMTAw
TWJwcyBmaWJlcg0KPiA+Pj4+Pj4+PiBtb2R1bGUuDQo+ID4+Pj4+Pj4+DQo+ID4+Pj4+Pj4+IERv
ZXMgUlRMODIxMUZTIGFkdmVydGlzZSAxMDBNYnBzIGFuZCAxR2JwcyBvbiB0aGUgVVRQL01ESQ0K
PiBzaWRlDQo+ID4+IGluDQo+ID4+Pj4+Pj4+IGNhc2Ugb2YgYSAxMDBNYnBzIGZpYmVyIG1vZHVs
ZT8NCj4gPj4+Pj4+PiBZZXMuDQo+ID4+Pj4+Pj4NCj4gPj4+Pj4+IEkgdGhpbmsgaW4gdGhpcyBj
YXNlIGludGVybmFsIFBIWSBhbmQgUlRMODIxMUZTIHdvdWxkIG5lZ290aWF0ZQ0KPiA+Pj4+Pj4g
MUdicHMsIG5vdCBtYXRjaGluZyB0aGUgc3BlZWQgb2YgdGhlIDEwME1icHMgZmliZXIgbW9kdWxl
Lg0KPiA+Pj4+Pj4gSG93IGRvZXMgdGhpcyB3b3JrPw0KPiA+Pj4+DQo+ID4+Pj4gTXkgbWlzdGFr
ZS4gV2l0aCAxMDBNYnBzIGZpYmVyIG1vZHVsZSBSVEw4MjExRlMgd2lsbCBvbmx5IGFkdmVydGlz
ZQ0KPiA+Pj4+IDEwME1icHMgb24gdGhlIFVUUC9NREkgc2lkZS4gV2l0aCAxR2JwcyBmaWJlciBt
b2R1bGUgaXQgd2lsbA0KPiA+Pj4+IGFkdmVydGlzZSBib3RoIDEwME1icHMgYW5kIDFHYnBzLiBT
byBpc3N1ZSB3aWxsIG9ubHkgaGFwcGVuIHdpdGgNCj4gPj4+PiAxR2Jwcw0KPiA+PiBmaWJlciBt
b2R1bGUuDQo+ID4+Pj4NCj4gPj4+Pj4gRmlicmUgbGluZSBzaWRlIGhhcyBubyBhdXRvbmVnLiBC
b3RoIGVuZHMgbmVlZCB0byBiZSB1c2luZyB0aGUNCj4gPj4+Pj4gc2FtZSBzcGVlZCwgb3IgdGhl
IFNFUkRFUyBkb2VzIG5vdCBzeW5jaHJvbmlzZSBhbmQgZG9lcyBub3QNCj4gZXN0YWJsaXNoIGxp
bmsuDQo+ID4+Pj4+DQo+ID4+Pj4+IFlvdSBjYW4gYXNrIHRoZSBTRlAgbW9kdWxlIHdoYXQgYmF1
ZCByYXRlIGl0IHN1cHBvcnRzLCBhbmQgdGhlbg0KPiA+Pj4+PiB1c2UgYW55dGhpbmcgdXAgdG8g
dGhhdCBiYXVkIHJhdGUuIEkndmUgZ290IHN5c3RlbXMgd2hlcmUgdGhlIFNGUA0KPiA+Pj4+PiBp
cyBmYXN0IGVub3VnaCB0byBzdXBwb3J0IGEgMi41R2JwcyBsaW5rLCBzbyB0aGUgTUFDIGluZGlj
YXRlcw0KPiA+Pj4+PiBib3RoIDIuNUcgYW5kIDFHLCBkZWZhdWx0cyB0byAyLjVHLCBhbmQgZmFp
bHMgdG8gY29ubmVjdCB0byBhIDFHDQo+ID4+Pj4+IGxpbmsgcGVlci4gWW91IG5lZWQgdG8gdXNl
IGV0aHRvb2wgdG8gZm9yY2UgaXQgdG8gdGhlIGxvd2VyIHNwZWVkDQo+ID4+Pj4+IGJlZm9yZSB0
aGUNCj4gPj4gbGluayB3b3Jrcy4NCj4gPj4+Pj4NCj4gPj4+Pj4gQnV0IGZyb20gd2hhdCBpIHVu
ZGVyc3RhbmQsIHlvdSBjYW5ub3QgdXNlIGEgMTAwMEJhc2UtWCBTRlAsIHNldA0KPiA+Pj4+PiB0
aGUgTUFDIHRvIDEwME1icHMsIGFuZCBleHBlY3QgaXQgdG8gY29ubmVjdCB0byBhIDEwMEJhc2Ut
RlggU0ZQLg0KPiA+Pj4+PiBTbyBmb3IgbWUsIHRoZSBSVEw4MjExRlMgc2hvdWxkIG5vdCBiZSBh
ZHZlcnRpc2UgMTAwTWJwcyBhbmQNCj4gPj4+Pj4gMUdicHMsIGl0IG5lZWRzIHRvIHRhbGsgdG8g
dGhlIFNGUCBmaWd1cmUgb3V0IGV4YWN0bHkgd2hhdCBpdCBpcywNCj4gPj4+Pj4gYW5kIG9ubHkg
YWR2ZXJ0aXNlIHRoZSBvbmUgbW9kZSB3aGljaCBpcyBzdXBwb3J0ZWQuDQo+ID4+Pj4NCj4gPj4+
PiBJdCBpcyB0aGUgUlRMODIxMUZTIGZpcm13YXJlIGJ1Zy4gVGhpcyBwYXRjaCBpcyBmb3Igd29y
a2Fyb3VuZCB0aGlzIGlzc3VlLg0KPiA+Pj4NCj4gPj4+IFNvIGlmIGl0IGlzIGFkdmVydGlzaW5n
IGJvdGggMTAwTWJwcyBhbmQgMUdicHMsIHdlIGtub3cgdGhlIFNGUCBpcw0KPiA+Pj4gYWN0dWFs
bHkgMUcsIGFuZCB3ZSBjYW4gcmVtb3ZlIHRoZSAxMDBNYnBzIGFkdmVydGlzZW1lbnQ/IFRoYXQN
Cj4gPj4+IHNob3VsZCB0aGVuIHNvbHZlIGFsbCB0aGUgcHJvYmxlbXM/DQo+ID4+Pg0KPiA+PiBS
aWdodCwgdGhhdCdzIHdoYXQgSSBwcm9wb3NlZCB0b28sIHJlbW92aW5nIDFHYnBzIGFkdmVydGlz
ZW1lbnQgb2YNCj4gPj4gdGhlIFJUTDgxNjhILWludGVybmFsIFBIWSB2aWEgdXNlcnNwYWNlIHRv
b2wsIGUuZy4gZXRodG9vbC4gRm9yIG1lDQo+ID4+IHRoaXMgaXMgdGhlIGNsZWFuZXN0IHNvbHV0
aW9uLiBBZGRpbmcgYSB3b3JrYXJvdW5kIGZvciBhIGZpcm13YXJlIGJ1Zw0KPiA+PiBvZiBhIHNw
ZWNpZmljIGV4dGVybmFsIFBIWSB0byB0aGUgcjgxNjkgTUFDIGRyaXZlciB3b3VsZCBiZSBzb21l
d2hhdA0KPiBoYWNreS4NCj4gPj4NCj4gPiBUaGFua3MgZm9yIHlvdXIgc3VnZ2VzdGlvbnMuIEJ1
dCBiZWNhdXNlIGl0IG5lZWRzIHVzZXIgdG8gZXhlY3V0ZQ0KPiB1c2Vyc3BhY2UgdG9vbC4NCj4g
PiBUaGlzIHdvcmthcm91bmQgbWF5IG5vdCBiZSBhY2NlcHRlZCBieSBvdXIgY3VzdG9tZXINCj4g
Pg0KPiANCj4gSW4gdGhpcyBjYXNlIHlvdSBjYW4gcHJvdmlkZSB5b3VyIGN1c3RvbWVyIHdpdGgg
YSBkb3duc3RyZWFtIGtlcm5lbA0KPiBpbmNsdWRpbmcgeW91ciBwYXRjaC4NCj4gDQpUaGFua3Mu
IFdlIHdpbGwgaW5jbHVkZSBpdCBhcyBvbmUgb2YgdGhlIG9wdGlvbnMuDQoNCiAtLS0tLS1QbGVh
c2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0aGlzIGUtbWFpbC4N
Cg==
