Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DE6357B71
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 06:42:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhDHEnD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 00:43:03 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:41714 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhDHEnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 00:43:02 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1384gHAI1011590, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1384gHAI1011590
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 8 Apr 2021 12:42:17 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 12:42:05 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 8 Apr 2021 12:42:04 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::4591:e6f0:2e30:96c6]) by
 RTEXMBS04.realtek.com.tw ([fe80::4591:e6f0:2e30:96c6%6]) with mapi id
 15.01.2106.013; Thu, 8 Apr 2021 12:42:04 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>,
        Larry Finger <Larry.Finger@lwfinger.net>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
Subject: RE: rtlwifi/rtl8192cu AP mode broken with PS STA
Thread-Topic: rtlwifi/rtl8192cu AP mode broken with PS STA
Thread-Index: AQHXKt1YTEWAFQOqV0euMAbEDkc/GKqnJvGAgACuHgCAABntAIABFTKAgAEERdA=
Date:   Thu, 8 Apr 2021 04:42:03 +0000
Message-ID: <c5556a207c5c40ac849c6a0e1919baca@realtek.com>
References: <e2924d81-0e30-2dd0-292b-428fea199484@maciej.szmigiero.name>
 <846f6166-c570-01fc-6bbc-3e3b44e51327@maciej.szmigiero.name>
 <87r1jnohq6.fsf@codeaurora.org>
 <8e0434eb-d15f-065d-2ba7-b50c67877112@maciej.szmigiero.name>
 <a2003668-5108-27b9-95cd-9e1d5d1aa94d@lwfinger.net>
 <1617763692.9857.7.camel@realtek.com>
 <1dc7e487-b97b-8584-47f7-37f3385c7bf9@lwfinger.net>
 <15737dcf-95ac-1ce6-a681-94ff5db968e4@maciej.szmigiero.name>
In-Reply-To: <15737dcf-95ac-1ce6-a681-94ff5db968e4@maciej.szmigiero.name>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvOCDkuIrljYggMDI6MjE6MDA=?=
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/08/2021 04:12:26
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162974 [Apr 07 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: wireless.wiki.kernel.org:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/08/2021 04:16:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/08/2021 04:12:26
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162974 [Apr 07 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: wireless.wiki.kernel.org:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/08/2021 04:16:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTWFjaWVqIFMuIFN6bWln
aWVybyBbbWFpbHRvOm1haWxAbWFjaWVqLnN6bWlnaWVyby5uYW1lXQ0KPiBTZW50OiBUaHVyc2Rh
eSwgQXByaWwgMDgsIDIwMjEgNDo1MyBBTQ0KPiBUbzogTGFycnkgRmluZ2VyOyBQa3NoaWgNCj4g
Q2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gam9oYW5uZXNAc2lwc29sdXRpb25z
Lm5ldDsga3ZhbG9AY29kZWF1cm9yYS5vcmcNCj4gU3ViamVjdDogUmU6IHJ0bHdpZmkvcnRsODE5
MmN1IEFQIG1vZGUgYnJva2VuIHdpdGggUFMgU1RBDQo+IA0KPiBPbiAwNy4wNC4yMDIxIDA2OjIx
LCBMYXJyeSBGaW5nZXIgd3JvdGU6DQo+ID4gT24gNC82LzIxIDk6NDggUE0sIFBrc2hpaCB3cm90
ZToNCj4gPj4gT24gVHVlLCAyMDIxLTA0LTA2IGF0IDExOjI1IC0wNTAwLCBMYXJyeSBGaW5nZXIg
d3JvdGU6DQo+ID4+PiBPbiA0LzYvMjEgNzowNiBBTSwgTWFjaWVqIFMuIFN6bWlnaWVybyB3cm90
ZToNCj4gPj4+PiBPbiAwNi4wNC4yMDIxIDEyOjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiA+Pj4+
PiAiTWFjaWVqIFMuIFN6bWlnaWVybyIgPG1haWxAbWFjaWVqLnN6bWlnaWVyby5uYW1lPiB3cml0
ZXM6DQo+ID4+Pj4+DQo+ID4+Pj4+PiBPbiAyOS4wMy4yMDIxIDAwOjU0LCBNYWNpZWogUy4gU3pt
aWdpZXJvIHdyb3RlOg0KPiA+Pj4+Pj4+IEhpLA0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gSXQgbG9v
a3MgbGlrZSBydGx3aWZpL3J0bDgxOTJjdSBBUCBtb2RlIGlzIGJyb2tlbiB3aGVuIGEgU1RBIGlz
IHVzaW5nIFBTLA0KPiA+Pj4+Pj4+IHNpbmNlIHRoZSBkcml2ZXIgZG9lcyBub3QgdXBkYXRlIGl0
cyBiZWFjb24gdG8gYWNjb3VudCBmb3IgVElNIGNoYW5nZXMsDQo+ID4+Pj4+Pj4gc28gYSBzdGF0
aW9uIHRoYXQgaXMgc2xlZXBpbmcgd2lsbCBuZXZlciBsZWFybiB0aGF0IGl0IGhhcyBwYWNrZXRz
DQo+ID4+Pj4+Pj4gYnVmZmVyZWQgYXQgdGhlIEFQLg0KPiA+Pj4+Pj4+DQo+ID4+Pj4+Pj4gTG9v
a2luZyBhdCB0aGUgY29kZSwgdGhlIHJ0bDgxOTJjdSBkcml2ZXIgaW1wbGVtZW50cyBuZWl0aGVy
IHRoZSBzZXRfdGltKCkNCj4gPj4+Pj4+PiBjYWxsYmFjaywgbm9yIGRvZXMgaXQgZXhwbGljaXRs
eSB1cGRhdGUgYmVhY29uIGRhdGEgcGVyaW9kaWNhbGx5LCBzbyBpdA0KPiA+Pj4+Pj4+IGhhcyBu
byB3YXkgdG8gbGVhcm4gdGhhdCBpdCBoYWQgY2hhbmdlZC4NCj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+
IFRoaXMgcmVzdWx0cyBpbiB0aGUgQVAgbW9kZSBiZWluZyB2aXJ0dWFsbHkgdW51c2FibGUgd2l0
aCBTVEFzIHRoYXQgZG8NCj4gPj4+Pj4+PiBQUyBhbmQgZG9uJ3QgYWxsb3cgZm9yIGl0IHRvIGJl
IGRpc2FibGVkIChJb1QgZGV2aWNlcywgbW9iaWxlIHBob25lcywNCj4gPj4+Pj4+PiBldGMuKS4N
Cj4gPj4+Pj4+Pg0KPiA+Pj4+Pj4+IEkgdGhpbmsgdGhlIGVhc2llc3QgZml4IGhlcmUgd291bGQg
YmUgdG8gaW1wbGVtZW50IHNldF90aW0oKSBmb3IgZXhhbXBsZQ0KPiA+Pj4+Pj4+IHRoZSB3YXkg
cnQyeDAwIGRyaXZlciBkb2VzOiBxdWV1ZSBhIHdvcmsgb3Igc2NoZWR1bGUgYSB0YXNrbGV0IHRv
IHVwZGF0ZQ0KPiA+Pj4+Pj4+IHRoZSBiZWFjb24gZGF0YSBvbiB0aGUgZGV2aWNlLg0KPiA+Pj4+
Pj4NCj4gPj4+Pj4+IEFyZSB0aGVyZSBhbnkgcGxhbnMgdG8gZml4IHRoaXM/DQo+ID4+Pj4+PiBU
aGUgZHJpdmVyIGlzIGxpc3RlZCBhcyBtYWludGFpbmVkIGJ5IFBpbmctS2UuDQo+ID4+Pj4+DQo+
ID4+Pj4+IFllYWgsIHBvd2VyIHNhdmUgaXMgaGFyZCBhbmQgSSdtIG5vdCBzdXJwcmlzZWQgdGhh
dCB0aGVyZSBhcmUgZHJpdmVycw0KPiA+Pj4+PiB3aXRoIGJyb2tlbiBwb3dlciBzYXZlIG1vZGUg
c3VwcG9ydC4gSWYgdGhlcmUncyBubyBmaXggYXZhaWxhYmxlIHdlDQo+ID4+Pj4+IHNob3VsZCBz
dG9wIHN1cHBvcnRpbmcgQVAgbW9kZSBpbiB0aGUgZHJpdmVyLg0KPiA+Pj4+Pg0KPiA+Pj4+IGh0
dHBzOi8vd2lyZWxlc3Mud2lraS5rZXJuZWwub3JnL2VuL2RldmVsb3BlcnMvZG9jdW1lbnRhdGlv
bi9tYWM4MDIxMS9hcGkNCj4gPj4+PiBjbGVhcmx5IGRvY3VtZW50cyB0aGF0ICJGb3IgQVAgbW9k
ZSwgaXQgbXVzdCAoLi4uKSByZWFjdCB0byB0aGUgc2V0X3RpbSgpDQo+ID4+Pj4gY2FsbGJhY2sg
b3IgZmV0Y2ggZWFjaCBiZWFjb24gZnJvbSBtYWM4MDIxMSIuDQo+ID4+Pj4gVGhlIGRyaXZlciBp
c24ndCBkb2luZyBlaXRoZXIgc28gbm8gd29uZGVyIHRoZSBiZWFjb24gaXQgaXMgc2VuZGluZw0K
PiA+Pj4+IGlzbid0IGdldHRpbmcgdXBkYXRlZC4NCj4gPj4+PiBBcyBJIGhhdmUgc2FpZCBhYm92
ZSwgaXQgc2VlbXMgdG8gbWUgdGhhdCBhbGwgdGhhdCBuZWVkcyB0byBiZSBkb25lIGhlcmUNCj4g
Pj4+PiBpcyB0byBxdWV1ZSBhIHdvcmsgaW4gYSBzZXRfdGltKCkgY2FsbGJhY2ssIHRoZW4gY2Fs
bA0KPiA+Pj4+IHNlbmRfYmVhY29uX2ZyYW1lKCkgZnJvbSBydGx3aWZpL2NvcmUuYyBmcm9tIHRo
aXMgd29yay4NCj4gPj4+PiBCdXQgSSBkb24ndCBrbm93IHRoZSBleGFjdCBkZXZpY2Ugc2VtYW50
aWNzLCBtYXliZSBpdCBuZWVkcyBzb21lIG90aGVyDQo+ID4+Pj4gbm90aWZpY2F0aW9uIHRoYXQg
dGhlIGJlYWNvbiBoYXMgY2hhbmdlZCwgdG9vLCBvciBldmVuIHRyaWVzIHRvDQo+ID4+Pj4gbWFu
YWdlIHRoZSBUSU0gYml0bWFwIGJ5IGl0c2VsZi4NCj4gPj4+PiBJdCB3b3VsZCBiZSBhIHNoYW1l
IHRvIGxvc2UgdGhlIEFQIG1vZGUgZm9yIHN1Y2ggbWlub3IgdGhpbmcsIHRob3VnaC4NCj4gPj4+
PiBJIHdvdWxkIHBsYXkgd2l0aCB0aGlzIG15c2VsZiwgYnV0IHVuZm9ydHVuYXRlbHkgSSBkb24n
dCBoYXZlIHRpbWUNCj4gPj4+PiB0byB3b3JrIG9uIHRoaXMgcmlnaHQgbm93Lg0KPiA+Pj4+IFRo
YXQncyB3aGVyZSBteSBxdWVzdGlvbiB0byBSZWFsdGVrIGNvbWVzOiBhcmUgdGhlcmUgcGxhbnMg
dG8gYWN0dWFsbHkNCj4gPj4+PiBmaXggdGhpcz8NCj4gPj4+DQo+ID4+PiBZZXMsIEkgYW0gd29y
a2luZyBvbiB0aGlzLiBNeSBvbmx5IHF1ZXN0aW9uIGlzICJpZiB5b3UgYXJlIHN1Y2ggYW4gZXhw
ZXJ0IG9uIHRoZQ0KPiA+Pj4gcHJvYmxlbSwgd2h5IGRvIHlvdSBub3QgZml4IGl0PyINCj4gPj4+
DQo+ID4+PiBUaGUgZXhhbXBsZSBpbiByeDIwMCBpcyBub3QgcGFydGljdWxhcmx5IHVzZWZ1bCwg
YW5kIEkgaGF2ZSBub3QgZm91bmQgYW55IG90aGVyDQo+ID4+PiBleGFtcGxlcy4NCj4gPj4+DQo+
ID4+DQo+ID4+IEhpIExhcnJ5LA0KPiA+Pg0KPiA+PiBJIGhhdmUgYSBkcmFmdCBwYXRjaCB0aGF0
IGZvcmtzIGEgd29yayB0byBkbyBzZW5kX2JlYWNvbl9mcmFtZSgpLCB3aG9zZQ0KPiA+PiBiZWhh
dmlvciBsaWtlIE1hY2llaiBtZW50aW9uZWQuDQo+IA0KPiBUaGF0J3MgZ3JlYXQsIHRoYW5rcyEN
Cj4gDQo+ID4+IEkgZGlkIHRlc3Qgb24gUlRMODgyMUFFOyBpdCB3b3JrcyB3ZWxsLiBCdXQsIGl0
IHNlZW1zIGFscmVhZHkgd29yayB3ZWxsIGV2ZW4NCj4gPj4gSSBkb24ndCBhcHBseSB0aGlzIHBh
dGNoLCBhbmQgSSdtIHN0aWxsIGRpZ2dpbmcgd2h5Lg0KPiANCj4gSXQgbG9va3MgbGlrZSBQQ0kg
cnRsd2lmaSBoYXJkd2FyZSB1c2VzIGEgdGFza2xldCAoc3BlY2lmaWNhbGx5LA0KPiBfcnRsX3Bj
aV9wcmVwYXJlX2Jjbl90YXNrbGV0KCkgaW4gcGNpLmMpIHRvIHBlcmlvZGljYWxseSB0cmFuc2Zl
ciB0aGUNCj4gY3VycmVudCBiZWFjb24gdG8gdGhlIE5JQy4NCg0KR290IGl0Lg0KDQo+IA0KPiBU
aGlzIHRhc2tsZXQgaXMgc2NoZWR1bGVkIG9uIGEgUlRMX0lNUl9CQ05JTlQgaW50ZXJydXB0LCB3
aGljaCBzb3VuZHMNCj4gbGlrZSBhIGJlYWNvbiBpbnRlcnZhbCBpbnRlcnJ1cHQuDQo+IA0KDQpZ
ZXMsIFBDSSBzZXJpZXMgdXBkYXRlIGV2ZXJ5IGJlYWNvbiwgc28gVElNIGFuZCBEVElNIGNvdW50
IG1haW50YWluZWQgYnkNCm1hYzgwMjExIHdvcmsgcHJvcGVybHkuDQoNCj4gPj4gSSBkb24ndCBo
YXZlIGHCoHJ0bDgxOTJjdSBkb25nbGUgb24gaGFuZCwgYnV0IEknbGwgdHJ5IHRvIGZpbmQgb25l
Lg0KPiA+DQo+ID4gTWFjZWlqLA0KPiA+DQo+ID4gRG9lcyB0aGlzIHBhdGNoIGZpeCB0aGUgcHJv
YmxlbT8NCj4gDQo+IFRoZSBiZWFjb24gc2VlbXMgdG8gYmUgdXBkYXRpbmcgbm93IGFuZCBTVEFz
IG5vIGxvbmdlciBnZXQgc3R1Y2sgaW4gUFMNCj4gbW9kZS4NCj4gQWx0aG91Z2ggc29tZXRpbWVz
IChldmVyeSAyLTMgbWludXRlcyB3aXRoIGNvbnRpbnVvdXMgMXMgaW50ZXJ2YWwgcGluZ3MpDQo+
IHRoZXJlIGlzIGFyb3VuZCA1cyBkZWxheSBpbiB1cGRhdGluZyB0aGUgdHJhbnNtaXR0ZWQgYmVh
Y29uIC0gZG9uJ3Qga25vdw0KPiB3aHksIG1heWJlIHRoZSBOSUMgaGFyZHdhcmUgc3RpbGwgaGFz
IHRoZSBvbGQgdmVyc2lvbiBpbiBxdWV1ZT8NCg0KU2luY2UgVVNCIGRldmljZSBkb2Vzbid0IHVw
ZGF0ZSBldmVyeSBiZWFjb24sIGR0aW1fY291bnQgaXNuJ3QgdXBkYXRlZCBuZWl0aGVyLg0KSXQg
bGVhZHMgU1RBIGRvZXNuJ3QgYXdha2UgcHJvcGVybHkuIFBsZWFzZSB0cnkgdG8gZml4IGR0aW1f
cGVyaW9kPTEgaW4NCmhvc3RhcGQuY29uZiwgd2hpY2ggdGVsbHMgU1RBIGF3YWtlcyBldmVyeSBi
ZWFjb24gaW50ZXJ2YWwuDQoNCj4gDQo+IEkgZG91YnQsIGhvd2V2ZXIgdGhhdCB0aGlzIHNldF90
aW0oKSBjYWxsYmFjayBzaG91bGQgYmUgYWRkZWQgZm9yIGV2ZXJ5DQo+IHJ0bHdpZmkgZGV2aWNl
IHR5cGUuDQo+IA0KPiBBcyBJIGhhdmUgc2FpZCBhYm92ZSwgUENJIGRldmljZXMgc2VlbSB0byBh
bHJlYWR5IGhhdmUgYSBtZWNoYW5pc20gaW4NCj4gcGxhY2UgdG8gdXBkYXRlIHRoZWlyIGJlYWNv
biBlYWNoIGJlYWNvbiBpbnRlcnZhbC4NCj4gWW91ciB0ZXN0IHRoYXQgUlRMODgyMUFFIHdvcmtz
IHdpdGhvdXQgdGhpcyBwYXRjaCBjb25maXJtcyB0aGF0IChhdA0KPiBsZWFzdCBmb3IgdGhlIHJ0
bDg4MjFhZSBkcml2ZXIpLg0KPiANCj4gSXQgc2VlbXMgdGhpcyBjYWxsYmFjayBpcyBvbmx5IG5l
Y2Vzc2FyaWx5IGZvciBVU0IgcnRsd2lmaSBkZXZpY2VzLg0KPiBXaGljaCBjdXJyZW50bHkgbWVh
bnMgcnRsODE5MmN1IG9ubHkuDQo+IA0KDQpJIGFncmVlIHdpdGggeW91Lg0KDQotLQ0KUGluZy1L
ZQ0KDQoNCg==
