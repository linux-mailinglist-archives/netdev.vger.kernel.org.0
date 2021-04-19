Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C34D363C15
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 09:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237628AbhDSHFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Apr 2021 03:05:32 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:49032 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233418AbhDSHFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Apr 2021 03:05:31 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13J74cvC6022121, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13J74cvC6022121
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Apr 2021 15:04:38 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Apr 2021 15:04:37 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Apr 2021 15:04:17 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74]) by
 RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74%5]) with mapi id
 15.01.2106.013; Mon, 19 Apr 2021 15:04:17 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Larry Finger <Larry.Finger@lwfinger.net>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: RE: rtlwifi/rtl8192cu AP mode broken with PS STA
Thread-Topic: rtlwifi/rtl8192cu AP mode broken with PS STA
Thread-Index: AQHXKt1YTEWAFQOqV0euMAbEDkc/GKqnJvGAgACuHgCAABntAIABFTKAgAEERdCAAG/QgIAOFRAAgAKClyD//4lTAIAA5Lfw
Date:   Mon, 19 Apr 2021 07:04:16 +0000
Message-ID: <56d52ee8681a43aaa20924c5fa047bf0@realtek.com>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
 <1617763692.9857.7.camel@realtek.com>
 <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
 <15737dcf-95ac-1ce6-a681-94ff5db968e4@maciej.szmigiero.name>
 <c5556a207c5c40ac849c6a0e1919baca@realtek.com>
 <220c4fe4-c9e1-347a-8cef-cd91d31c56df@maciej.szmigiero.name>
 <cfcc2988-3f20-3588-2f76-f04d09043811@maciej.szmigiero.name>
 <35249c6028f645a79c4186c9689ba8aa@realtek.com>
 <52f89f4f-568e-f04e-5c3e-e31f4a9e0910@lwfinger.net>
In-Reply-To: <52f89f4f-568e-f04e-5c3e-e31f4a9e0910@lwfinger.net>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMTkg5LiK5Y2IIDAzOjMwOjAw?=
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/19/2021 06:34:40
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163190 [Apr 19 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/19/2021 06:38:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/19/2021 06:46:44
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163190 [Apr 19 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: realtek.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;lore.kernel.org:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/19/2021 06:49:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IExhcnJ5IEZpbmdlciBbbWFp
bHRvOmxhcnJ5LmZpbmdlckBnbWFpbC5jb21dIE9uIEJlaGFsZiBPZiBMYXJyeSBGaW5nZXINCj4g
U2VudDogTW9uZGF5LCBBcHJpbCAxOSwgMjAyMSA5OjIzIEFNDQo+IFRvOiBQa3NoaWg7IE1hY2ll
aiBTLiBTem1pZ2llcm8NCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gam9o
YW5uZXNAc2lwc29sdXRpb25zLm5ldDsga3ZhbG9AY29kZWF1cm9yYS5vcmcNCj4gU3ViamVjdDog
UmU6IHJ0bHdpZmkvcnRsODE5MmN1IEFQIG1vZGUgYnJva2VuIHdpdGggUFMgU1RBDQo+IA0KPiBP
biA0LzE4LzIxIDc6MzIgUE0sIFBrc2hpaCB3cm90ZToNCj4gPg0KPiA+PiAtLS0tLU9yaWdpbmFs
IE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBNYWNpZWogUy4gU3ptaWdpZXJvIFttYWlsdG86bWFp
bEBtYWNpZWouc3ptaWdpZXJvLm5hbWVdDQo+ID4+IFNlbnQ6IFN1bmRheSwgQXByaWwgMTgsIDIw
MjEgMjowOCBBTQ0KPiA+PiBUbzogUGtzaGloDQo+ID4+IENjOiBsaW51eC13aXJlbGVzc0B2Z2Vy
Lmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7DQo+ID4+IGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ7IGt2YWxvQGNvZGVhdXJv
cmEub3JnOyBMYXJyeSBGaW5nZXINCj4gPj4gU3ViamVjdDogUmU6IHJ0bHdpZmkvcnRsODE5MmN1
IEFQIG1vZGUgYnJva2VuIHdpdGggUFMgU1RBDQo+ID4+DQo+ID4+IE9uIDA4LjA0LjIwMjEgMjE6
MDQsIE1hY2llaiBTLiBTem1pZ2llcm8gd3JvdGU6DQo+ID4+PiBPbiAwOC4wNC4yMDIxIDA2OjQy
LCBQa3NoaWggd3JvdGU6DQo+ID4+Pj4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4+
Pj4+IEZyb206IE1hY2llaiBTLiBTem1pZ2llcm8gW21haWx0bzptYWlsQG1hY2llai5zem1pZ2ll
cm8ubmFtZV0NCj4gPj4+Pj4gU2VudDogVGh1cnNkYXksIEFwcmlsIDA4LCAyMDIxIDQ6NTMgQU0N
Cj4gPj4+Pj4gVG86IExhcnJ5IEZpbmdlcjsgUGtzaGloDQo+ID4+Pj4+IENjOiBsaW51eC13aXJl
bGVzc0B2Z2VyLmtlcm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmc7DQo+ID4+Pj4+IGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ7IGt2
YWxvQGNvZGVhdXJvcmEub3JnDQo+ID4+Pj4+IFN1YmplY3Q6IFJlOiBydGx3aWZpL3J0bDgxOTJj
dSBBUCBtb2RlIGJyb2tlbiB3aXRoIFBTIFNUQQ0KPiA+Pj4+Pg0KPiA+Pj4gKC4uLikNCj4gPj4+
Pj4+IE1hY2VpaiwNCj4gPj4+Pj4+DQo+ID4+Pj4+PiBEb2VzIHRoaXMgcGF0Y2ggZml4IHRoZSBw
cm9ibGVtPw0KPiA+Pj4+Pg0KPiA+Pj4+PiBUaGUgYmVhY29uIHNlZW1zIHRvIGJlIHVwZGF0aW5n
IG5vdyBhbmQgU1RBcyBubyBsb25nZXIgZ2V0IHN0dWNrIGluIFBTDQo+ID4+Pj4+IG1vZGUuDQo+
ID4+Pj4+IEFsdGhvdWdoIHNvbWV0aW1lcyAoZXZlcnkgMi0zIG1pbnV0ZXMgd2l0aCBjb250aW51
b3VzIDFzIGludGVydmFsIHBpbmdzKQ0KPiA+Pj4+PiB0aGVyZSBpcyBhcm91bmQgNXMgZGVsYXkg
aW4gdXBkYXRpbmcgdGhlIHRyYW5zbWl0dGVkIGJlYWNvbiAtIGRvbid0IGtub3cNCj4gPj4+Pj4g
d2h5LCBtYXliZSB0aGUgTklDIGhhcmR3YXJlIHN0aWxsIGhhcyB0aGUgb2xkIHZlcnNpb24gaW4g
cXVldWU/DQo+ID4+Pj4NCj4gPj4+PiBTaW5jZSBVU0IgZGV2aWNlIGRvZXNuJ3QgdXBkYXRlIGV2
ZXJ5IGJlYWNvbiwgZHRpbV9jb3VudCBpc24ndCB1cGRhdGVkIG5laXRoZXIuDQo+ID4+Pj4gSXQg
bGVhZHMgU1RBIGRvZXNuJ3QgYXdha2UgcHJvcGVybHkuIFBsZWFzZSB0cnkgdG8gZml4IGR0aW1f
cGVyaW9kPTEgaW4NCj4gPj4+PiBob3N0YXBkLmNvbmYsIHdoaWNoIHRlbGxzIFNUQSBhd2FrZXMg
ZXZlcnkgYmVhY29uIGludGVydmFsLg0KPiA+Pj4NCj4gPj4+IFRoZSBzaXR1YXRpb24gaXMgdGhl
IHNhbWUgd2l0aCBkdGltX3BlcmlvZD0xLg0KPiA+Pj4NCj4gPj4gKC4uLikNCj4gPj4NCj4gPj4g
UGluZy1LZSwNCj4gPj4gYXJlIHlvdSBnb2luZyB0byBzdWJtaXQgeW91ciBzZXRfdGltKCkgcGF0
Y2ggc28gYXQgbGVhc3QgdGhlIEFQIG1vZGUgaXMNCj4gPj4gdXNhYmxlIHdpdGggUFMgU1RBcyBv
ciBhcmUgeW91IHdhaXRpbmcgZm9yIGEgc29sdXRpb24gdG8gdGhlIGRlbGF5ZWQNCj4gPj4gYmVh
Y29uIHVwZGF0ZSBpc3N1ZT8NCj4gPj4NCj4gPg0KPiA+IEknbSBzdGlsbCB0cnlpbmcgdG8gZ2V0
IGEgODE5MmN1LCBhbmQgdGhlbiBJIGNhbiByZXByb2R1Y2UgdGhlIHN5bXB0b20geW91DQo+ID4g
bWV0LiBIb3dldmVyLCBJJ20gYnVzeSBub3c7IG1heWJlIEkgaGF2ZSBmcmVlIHRpbWUgdHdvIHdl
ZWtzIGxhdGVyLg0KPiA+DQo+ID4gRG8geW91IHRoaW5rIEkgc3VibWl0IHRoZSBzZXRfdGltKCkg
cGF0Y2ggd2l0aCB5b3VyIFJlcG9ydGVkLWJ5IGFuZCBUZXN0ZWQtYnkgZmlyc3Q/DQo+IA0KPiBQ
SywNCj4gDQo+IEkgd291bGQgc2F5IHllcy4gR2V0IHRoZSBmaXggaW4gYXMgc29vbiBhcyBwb3Nz
aWJsZS4NCj4gDQoNCkkgaGF2ZSBzZW50IGEgcGF0Y2ggdGhhdCBvbmx5IDgxOTJjdSwgd2hpY2gg
aXMgdGhlIG9ubHkgb25lIFVTQiBkZXZpY2Ugc3VwcG9ydGVkIGJ5IHJ0bHdpZmksDQpzY2hlZHVs
ZXMgYSB3b3JrIHRvIHVwZGF0ZSBiZWFjb24gY29udGVudCB0byB3aWZpIGNhcmQuDQoNCmh0dHBz
Oi8vbG9yZS5rZXJuZWwub3JnL2xpbnV4LXdpcmVsZXNzLzIwMjEwNDE5MDY1OTU2LjYwODUtMS1w
a3NoaWhAcmVhbHRlay5jb20vVC8jdQ0KDQotLQ0KUGluZy1LZQ0KDQo=
