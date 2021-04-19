Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0693638CE
	for <lists+netdev@lfdr.de>; Mon, 19 Apr 2021 02:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235730AbhDSAdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 20:33:23 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:54170 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbhDSAdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Apr 2021 20:33:22 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 13J0WOkH4013071, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 13J0WOkH4013071
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Apr 2021 08:32:24 +0800
Received: from RTEXMBS03.realtek.com.tw (172.21.6.96) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Apr 2021 08:32:24 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS03.realtek.com.tw (172.21.6.96) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 19 Apr 2021 08:32:23 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74]) by
 RTEXMBS04.realtek.com.tw ([fe80::1d8:ba7d:61ca:bd74%5]) with mapi id
 15.01.2106.013; Mon, 19 Apr 2021 08:32:23 +0800
From:   Pkshih <pkshih@realtek.com>
To:     "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: RE: rtlwifi/rtl8192cu AP mode broken with PS STA
Thread-Topic: rtlwifi/rtl8192cu AP mode broken with PS STA
Thread-Index: AQHXKt1YTEWAFQOqV0euMAbEDkc/GKqnJvGAgACuHgCAABntAIABFTKAgAEERdCAAG/QgIAOFRAAgAKClyA=
Date:   Mon, 19 Apr 2021 00:32:23 +0000
Message-ID: <35249c6028f645a79c4186c9689ba8aa@realtek.com>
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
In-Reply-To: <cfcc2988-3f20-3588-2f76-f04d09043811@maciej.szmigiero.name>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXMBS03.realtek.com.tw, 9
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzQvMTgg5LiL5Y2IIDA0OjA0OjAw?=
x-kse-attachment-filter-triggered-rules: Clean
x-kse-attachment-filter-triggered-filters: Clean
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/19/2021 00:13:47
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163189 [Apr 18 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;realtek.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/19/2021 00:15:00
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 04/19/2021 00:21:51
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163189 [Apr 18 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 442 442 b985cb57763b61d2a20abb585d5d4cc10c315b09
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: 127.0.0.199:7.1.2;realtek.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 04/19/2021 00:25:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hY2llaiBTLiBTem1pZ2ll
cm8gW21haWx0bzptYWlsQG1hY2llai5zem1pZ2llcm8ubmFtZV0NCj4gU2VudDogU3VuZGF5LCBB
cHJpbCAxOCwgMjAyMSAyOjA4IEFNDQo+IFRvOiBQa3NoaWgNCj4gQ2M6IGxpbnV4LXdpcmVsZXNz
QHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZn
ZXIua2VybmVsLm9yZzsNCj4gam9oYW5uZXNAc2lwc29sdXRpb25zLm5ldDsga3ZhbG9AY29kZWF1
cm9yYS5vcmc7IExhcnJ5IEZpbmdlcg0KPiBTdWJqZWN0OiBSZTogcnRsd2lmaS9ydGw4MTkyY3Ug
QVAgbW9kZSBicm9rZW4gd2l0aCBQUyBTVEENCj4gDQo+IE9uIDA4LjA0LjIwMjEgMjE6MDQsIE1h
Y2llaiBTLiBTem1pZ2llcm8gd3JvdGU6DQo+ID4gT24gMDguMDQuMjAyMSAwNjo0MiwgUGtzaGlo
IHdyb3RlOg0KPiA+Pj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4+IEZyb206IE1h
Y2llaiBTLiBTem1pZ2llcm8gW21haWx0bzptYWlsQG1hY2llai5zem1pZ2llcm8ubmFtZV0NCj4g
Pj4+IFNlbnQ6IFRodXJzZGF5LCBBcHJpbCAwOCwgMjAyMSA0OjUzIEFNDQo+ID4+PiBUbzogTGFy
cnkgRmluZ2VyOyBQa3NoaWgNCj4gPj4+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5v
cmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7
DQo+ID4+PiBqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0OyBrdmFsb0Bjb2RlYXVyb3JhLm9yZw0K
PiA+Pj4gU3ViamVjdDogUmU6IHJ0bHdpZmkvcnRsODE5MmN1IEFQIG1vZGUgYnJva2VuIHdpdGgg
UFMgU1RBDQo+ID4+Pg0KPiA+ICguLi4pDQo+ID4+Pj4gTWFjZWlqLA0KPiA+Pj4+DQo+ID4+Pj4g
RG9lcyB0aGlzIHBhdGNoIGZpeCB0aGUgcHJvYmxlbT8NCj4gPj4+DQo+ID4+PiBUaGUgYmVhY29u
IHNlZW1zIHRvIGJlIHVwZGF0aW5nIG5vdyBhbmQgU1RBcyBubyBsb25nZXIgZ2V0IHN0dWNrIGlu
IFBTDQo+ID4+PiBtb2RlLg0KPiA+Pj4gQWx0aG91Z2ggc29tZXRpbWVzIChldmVyeSAyLTMgbWlu
dXRlcyB3aXRoIGNvbnRpbnVvdXMgMXMgaW50ZXJ2YWwgcGluZ3MpDQo+ID4+PiB0aGVyZSBpcyBh
cm91bmQgNXMgZGVsYXkgaW4gdXBkYXRpbmcgdGhlIHRyYW5zbWl0dGVkIGJlYWNvbiAtIGRvbid0
IGtub3cNCj4gPj4+IHdoeSwgbWF5YmUgdGhlIE5JQyBoYXJkd2FyZSBzdGlsbCBoYXMgdGhlIG9s
ZCB2ZXJzaW9uIGluIHF1ZXVlPw0KPiA+Pg0KPiA+PiBTaW5jZSBVU0IgZGV2aWNlIGRvZXNuJ3Qg
dXBkYXRlIGV2ZXJ5IGJlYWNvbiwgZHRpbV9jb3VudCBpc24ndCB1cGRhdGVkIG5laXRoZXIuDQo+
ID4+IEl0IGxlYWRzIFNUQSBkb2Vzbid0IGF3YWtlIHByb3Blcmx5LiBQbGVhc2UgdHJ5IHRvIGZp
eCBkdGltX3BlcmlvZD0xIGluDQo+ID4+IGhvc3RhcGQuY29uZiwgd2hpY2ggdGVsbHMgU1RBIGF3
YWtlcyBldmVyeSBiZWFjb24gaW50ZXJ2YWwuDQo+ID4NCj4gPiBUaGUgc2l0dWF0aW9uIGlzIHRo
ZSBzYW1lIHdpdGggZHRpbV9wZXJpb2Q9MS4NCj4gPg0KPiAoLi4uKQ0KPiANCj4gUGluZy1LZSwN
Cj4gYXJlIHlvdSBnb2luZyB0byBzdWJtaXQgeW91ciBzZXRfdGltKCkgcGF0Y2ggc28gYXQgbGVh
c3QgdGhlIEFQIG1vZGUgaXMNCj4gdXNhYmxlIHdpdGggUFMgU1RBcyBvciBhcmUgeW91IHdhaXRp
bmcgZm9yIGEgc29sdXRpb24gdG8gdGhlIGRlbGF5ZWQNCj4gYmVhY29uIHVwZGF0ZSBpc3N1ZT8N
Cj4gDQoNCkknbSBzdGlsbCB0cnlpbmcgdG8gZ2V0IGEgODE5MmN1LCBhbmQgdGhlbiBJIGNhbiBy
ZXByb2R1Y2UgdGhlIHN5bXB0b20geW91DQptZXQuIEhvd2V2ZXIsIEknbSBidXN5IG5vdzsgbWF5
YmUgSSBoYXZlIGZyZWUgdGltZSB0d28gd2Vla3MgbGF0ZXIuDQoNCkRvIHlvdSB0aGluayBJIHN1
Ym1pdCB0aGUgc2V0X3RpbSgpIHBhdGNoIHdpdGggeW91ciBSZXBvcnRlZC1ieSBhbmQgVGVzdGVk
LWJ5IGZpcnN0Pw0KDQpUaGFua3MgDQpQaW5nLUtlDQoNCg==
