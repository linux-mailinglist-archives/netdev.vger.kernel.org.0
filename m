Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46D2F472364
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 10:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbhLMJAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 04:00:12 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:49010 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233335AbhLMJAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 04:00:11 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BD8xuMvB029310, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36504.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BD8xuMvB029310
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 13 Dec 2021 16:59:56 +0800
Received: from RTEXMBS06.realtek.com.tw (172.21.6.99) by
 RTEXH36504.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 16:59:56 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS06.realtek.com.tw (172.21.6.99) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 13 Dec 2021 16:59:55 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Mon, 13 Dec 2021 16:59:55 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Jian-Hong Pan <jhp@endlessos.org>
CC:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessos.org" <linux@endlessos.org>
Subject: RE: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
Thread-Topic: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
Thread-Index: AQHX7Z6qoa2juW6HuEaQNtYEJNeW8KwrYzIg//+KwICAAAK8AIAB4vUwgAKxvgCAAJx1QA==
Date:   Mon, 13 Dec 2021 08:59:55 +0000
Message-ID: <e78b81f3a73c45b59f4c4d9f5b414508@realtek.com>
References: <20211210081659.4621-1-jhp@endlessos.org>
 <6b0fcc8cf3bd4a77ad190dc6f72eb66f@realtek.com>
 <CAAd53p66HPH9v0_hzOaQAydberd8JA4HthNVwpQ86xb-dSuUEA@mail.gmail.com>
 <CAPpJ_efvmPWsCFsff35GHV8Q52YvQcFr_Hs=q3RtvbfVohY+4Q@mail.gmail.com>
 <617008e3be9c4b5aa37b26f97daf9354@realtek.com>
 <CAPpJ_ecqf+LqkN-Wb+zNGHbtJ3rKD8_kU3W0c2gTQGQqK1sUwg@mail.gmail.com>
In-Reply-To: <CAPpJ_ecqf+LqkN-Wb+zNGHbtJ3rKD8_kU3W0c2gTQGQqK1sUwg@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXMBS06.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzEzIOS4iuWNiCAwNjozODowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36504.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEppYW4tSG9uZyBQYW4gPGpo
cEBlbmRsZXNzb3Mub3JnPg0KPiBTZW50OiBNb25kYXksIERlY2VtYmVyIDEzLCAyMDIxIDM6MzEg
UE0NCj4gVG86IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPg0KPiBDYzogS2FpLUhlbmcgRmVu
ZyA8a2FpLmhlbmcuZmVuZ0BjYW5vbmljYWwuY29tPjsgWWFuLUhzdWFuIENodWFuZyA8dG9ueTA2
MjBlbW1hQGdtYWlsLmNvbT47IEthbGxlIFZhbG8NCj4gPGt2YWxvQGNvZGVhdXJvcmEub3JnPjsg
bGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eEBlbmRsZXNzb3Mub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0hdIHJ0dzg4OiA4ODIxYzogZGlzYWJsZSB0aGUgQVNQTSBvZiBSVEw4
ODIxQ0UNCj4gDQo+IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPiDmlrwgMjAyMeW5tDEy5pyI
MTHml6Ug6YCx5YWtIOS4i+WNiDI6MzHlr6vpgZPvvJoNCj4gPg0KPiA+DQo+ID4gPiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogSmlhbi1Ib25nIFBhbiA8amhwQGVuZGxl
c3Nvcy5vcmc+DQo+ID4gPiBTZW50OiBGcmlkYXksIERlY2VtYmVyIDEwLCAyMDIxIDU6MzQgUE0N
Cj4gPiA+IFRvOiBLYWktSGVuZyBGZW5nIDxrYWkuaGVuZy5mZW5nQGNhbm9uaWNhbC5jb20+DQo+
ID4gPiBDYzogUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+OyBZYW4tSHN1YW4gQ2h1YW5nIDx0
b255MDYyMGVtbWFAZ21haWwuY29tPjsgS2FsbGUgVmFsbw0KPiA+ID4gPGt2YWxvQGNvZGVhdXJv
cmEub3JnPjsgbGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOw0KPiA+ID4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbGludXhAZW5kbGVz
c29zLm9yZw0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSF0gcnR3ODg6IDg4MjFjOiBkaXNhYmxl
IHRoZSBBU1BNIG9mIFJUTDg4MjFDRQ0KPiA+ID4NCj4gPiA+IEthaS1IZW5nIEZlbmcgPGthaS5o
ZW5nLmZlbmdAY2Fub25pY2FsLmNvbT4g5pa8IDIwMjHlubQxMuaciDEw5pelIOmAseS6lCDkuIvl
jYg1OjI05a+r6YGT77yaDQo+ID4gPg0KPiA+ID4gPiBSaWdodCBub3cgaXQgc2VlbXMgbGlrZSBv
bmx5IEludGVsIHBsYXRmb3JtcyBhcmUgYWZmZWN0ZWQsIHNvIGNhbiBJDQo+ID4gPiA+IHByb3Bv
c2UgYSBwYXRjaCB0byBkaXNhYmxlIEFTUE0gd2hlbiBpdHMgdXBzdHJlYW0gcG9ydCBpcyBJbnRl
bD8NCj4gPiA+DQo+ID4gPiBJIG9ubHkgaGF2ZSBsYXB0b3BzIHdpdGggSW50ZWwgY2hpcCBub3cu
ICBTbywgSSBhbSBub3Qgc3VyZSB0aGUgc3RhdHVzDQo+ID4gPiB3aXRoIEFNRCBwbGF0Zm9ybXMu
DQo+ID4gPiBJZiB0aGlzIGlzIHRydWUsIHRoZW4gImRpc2FibGUgQVNQTSB3aGVuIGl0cyB1cHN0
cmVhbSBwb3J0IGlzIEludGVsIg0KPiA+ID4gbWlnaHQgYmUgYSBnb29kIGlkZWEuDQo+ID4gPg0K
PiA+DQo+ID4gSmlhbi1Ib25nLCBjb3VsZCB5b3UgdHJ5IEthaS1IZW5nJ3Mgd29ya2Fyb3VuZCB0
aGF0IG9ubHkgdHVybiBvZmYgQVNQTQ0KPiA+IGR1cmluZyBOQVBJIHBvbGwgZnVuY3Rpb24uIElm
IGl0IGFsc28gd29ya3MgdG8geW91LCBJIHRoaW5rIGl0IGlzIG9rYXkNCj4gPiB0byBhcHBseSB0
aGlzIHdvcmthcm91bmQgdG8gYWxsIEludGVsIHBsYXRmb3JtIHdpdGggUlRMODgyMUNFIGNoaXBz
ZXQuDQo+ID4gQmVjYXVzZSB0aGlzIHdvcmthcm91bmQgaGFzIGxpdHRsZSAoYWxtb3N0IG5vKSBp
bXBhY3Qgb2YgcG93ZXIgY29uc3VtcHRpb24uDQo+IA0KPiBBY2NvcmRpbmcgdG8gS2FpLUhlbmcn
cyBoYWNrIHBhdGNoIFsxXSBhbmQgdGhlIGNvbW1lbnQgWzJdIG1lbnRpb25pbmcNCj4gY2hlY2tp
bmcgInJlZl9jbnQiIGJ5IHJ0d19wY2lfbGlua19wcygpLCBJIGFycmFuZ2UgdGhlIHBhdGNoIGFz
DQo+IGZvbGxvd2luZy4NCg0KSSBtZWFudCB0aGF0IG1vdmUgInJlZl9jbnQiIGludG8gcnR3X3Bj
aV9saW5rX3BzKCkgYnkgWzJdLCBidXQgeW91IHJlbW92ZQ0KdGhlICJyZWZfY250Ii4gVGhpcyBs
ZWFkcyBsb3dlciBwZXJmb3JtYW5jZSwgYmVjYXVzZSBpdCBtdXN0IHR1cm4gb2ZmDQpBU1BNIGFm
dGVyIG5hcGlfcG9sbCgpIHdoZW4gd2UgaGF2ZSBoaWdoIHRyYWZmaWMuDQoNCkluIGZhY3QsIEth
aS1IZW5nJ3MgcGF0Y2ggaXMgdG8gbGVhdmUgQVNQTSBiZWZvcmUgbmFwaV9wb2xsKCksIGFuZA0K
InJlc3RvcmUiIEFTUE0gc2V0dGluZy4gU28sIHdlIHN0aWxsIG5lZWQgInJlZl9jbnQiLg0KDQoN
Cj4gVGhpcyBwYXRjaCBvbmx5IGRpc2FibGVzIEFTUE0gKGlmIHRoZSBoYXJkd2FyZSBoYXMgdGhl
IGNhcGFiaWxpdHkpDQo+IHdoZW4gc3lzdGVtIGdldHMgaW50byBydHdfcGNpX25hcGlfcG9sbCgp
IGFuZCByZS1lbmFibGVzIEFTUE0gd2hlbiBpdA0KPiBsZWF2ZXMgcnR3X3BjaV9uYXBpX3BvbGwo
KS4gIEl0IGlzIGFzIFBpbmctS2UgbWVudGlvbmVkICJvbmx5IHR1cm4gb2ZmDQo+IEFTUE0gZHVy
aW5nIE5BUEkgcG9sbCBmdW5jdGlvbiIuDQo+IFRoZSBXaUZpICYgQlQgd29yaywgYW5kIHN5c3Rl
bSBpcyBzdGlsbCBhbGl2ZSBhZnRlciBJIHVzZSB0aGUgaW50ZXJuZXQNCj4gYXdoaWxlLiAgQmVz
aWRlcywgdGhlcmUgaXMgbm8gbW9yZSAicGNpIGJ1cyB0aW1lb3V0LCBjaGVjayBkbWEgc3RhdHVz
Ig0KPiBlcnJvci4NCj4gDQo+IFsxXSBodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19i
dWcuY2dpP2lkPTIxNTEzMSNjMTENCj4gWzJdIGh0dHBzOi8vYnVnemlsbGEua2VybmVsLm9yZy9z
aG93X2J1Zy5jZ2k/aWQ9MjE1MTMxI2MxNQ0KPiANCj4gSmlhbi1Ib25nIFBhbg0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvcGNpLmMNCj4gYi9k
cml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BjaS5jDQo+IGluZGV4IGE3YTZlYmZh
YTIwMy4uYTZmZGRkZWNkMzdkIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9y
ZWFsdGVrL3J0dzg4L3BjaS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsv
cnR3ODgvcGNpLmMNCj4gQEAgLTE2NTgsNiArMTY1OCw3IEBAIHN0YXRpYyBpbnQgcnR3X3BjaV9u
YXBpX3BvbGwoc3RydWN0IG5hcGlfc3RydWN0DQo+ICpuYXBpLCBpbnQgYnVkZ2V0KQ0KPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgcHJpdik7DQo+ICAgICAg
ICAgaW50IHdvcmtfZG9uZSA9IDA7DQo+IA0KPiArICAgICAgIHJ0d19wY2lfbGlua19wcyhydHdk
ZXYsIGZhbHNlKTsNCj4gICAgICAgICB3aGlsZSAod29ya19kb25lIDwgYnVkZ2V0KSB7DQo+ICAg
ICAgICAgICAgICAgICB1MzIgd29ya19kb25lX29uY2U7DQo+IA0KPiBAQCAtMTY4MSw2ICsxNjgy
LDcgQEAgc3RhdGljIGludCBydHdfcGNpX25hcGlfcG9sbChzdHJ1Y3QgbmFwaV9zdHJ1Y3QNCj4g
Km5hcGksIGludCBidWRnZXQpDQo+ICAgICAgICAgICAgICAgICBpZiAocnR3X3BjaV9nZXRfaHdf
cnhfcmluZ19ucihydHdkZXYsIHJ0d3BjaSkpDQo+ICAgICAgICAgICAgICAgICAgICAgICAgIG5h
cGlfc2NoZWR1bGUobmFwaSk7DQo+ICAgICAgICAgfQ0KPiArICAgICAgIHJ0d19wY2lfbGlua19w
cyhydHdkZXYsIHRydWUpOw0KPiANCj4gICAgICAgICByZXR1cm4gd29ya19kb25lOw0KPiAgfQ0K
PiANCg0KSG93IGFib3V0IGRvaW5nIHRoaXMgdGhpbmcgb25seSBpZiA4ODIxQ0UgYW5kIEludGVs
IHBsYXRmb3JtPw0KQ291bGQgeW91IGhlbHAgdG8gYWRkIHRoaXM/DQoNCi0tDQpQaW5nLWtlDQoN
Cg0K
