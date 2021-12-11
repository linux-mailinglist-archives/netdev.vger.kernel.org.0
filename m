Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44183471224
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 07:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhLKGbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Dec 2021 01:31:18 -0500
Received: from rtits2.realtek.com ([211.75.126.72]:44300 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhLKGbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Dec 2021 01:31:18 -0500
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 1BB6V20a8002517, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36505.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 1BB6V20a8002517
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 11 Dec 2021 14:31:02 +0800
Received: from RTEXDAG02.realtek.com.tw (172.21.6.101) by
 RTEXH36505.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sat, 11 Dec 2021 14:31:02 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG02.realtek.com.tw (172.21.6.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sat, 11 Dec 2021 14:31:02 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01]) by
 RTEXMBS04.realtek.com.tw ([fe80::65a3:1e23:d911:4b01%5]) with mapi id
 15.01.2308.020; Sat, 11 Dec 2021 14:31:01 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Jian-Hong Pan <jhp@endlessos.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>
CC:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@endlessos.org" <linux@endlessos.org>
Subject: RE: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
Thread-Topic: [PATCH] rtw88: 8821c: disable the ASPM of RTL8821CE
Thread-Index: AQHX7Z6qoa2juW6HuEaQNtYEJNeW8KwrYzIg//+KwICAAAK8AIAB4vUw
Date:   Sat, 11 Dec 2021 06:31:01 +0000
Message-ID: <617008e3be9c4b5aa37b26f97daf9354@realtek.com>
References: <20211210081659.4621-1-jhp@endlessos.org>
 <6b0fcc8cf3bd4a77ad190dc6f72eb66f@realtek.com>
 <CAAd53p66HPH9v0_hzOaQAydberd8JA4HthNVwpQ86xb-dSuUEA@mail.gmail.com>
 <CAPpJ_efvmPWsCFsff35GHV8Q52YvQcFr_Hs=q3RtvbfVohY+4Q@mail.gmail.com>
In-Reply-To: <CAPpJ_efvmPWsCFsff35GHV8Q52YvQcFr_Hs=q3RtvbfVohY+4Q@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.188]
x-kse-serverinfo: RTEXDAG02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzEyLzExIOS4iuWNiCAwNDozNTowMA==?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36505.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IEppYW4tSG9uZyBQYW4gPGpo
cEBlbmRsZXNzb3Mub3JnPg0KPiBTZW50OiBGcmlkYXksIERlY2VtYmVyIDEwLCAyMDIxIDU6MzQg
UE0NCj4gVG86IEthaS1IZW5nIEZlbmcgPGthaS5oZW5nLmZlbmdAY2Fub25pY2FsLmNvbT4NCj4g
Q2M6IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgWWFuLUhzdWFuIENodWFuZyA8dG9ueTA2
MjBlbW1hQGdtYWlsLmNvbT47IEthbGxlIFZhbG8NCj4gPGt2YWxvQGNvZGVhdXJvcmEub3JnPjsg
bGludXgtd2lyZWxlc3NAdmdlci5rZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOw0K
PiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eEBlbmRsZXNzb3Mub3JnDQo+IFN1
YmplY3Q6IFJlOiBbUEFUQ0hdIHJ0dzg4OiA4ODIxYzogZGlzYWJsZSB0aGUgQVNQTSBvZiBSVEw4
ODIxQ0UNCj4gDQo+IEthaS1IZW5nIEZlbmcgPGthaS5oZW5nLmZlbmdAY2Fub25pY2FsLmNvbT4g
5pa8IDIwMjHlubQxMuaciDEw5pelIOmAseS6lCDkuIvljYg1OjI05a+r6YGT77yaDQo+ID4NCj4g
PiBPbiBGcmksIERlYyAxMCwgMjAyMSBhdCA1OjAwIFBNIFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsu
Y29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiArS2FpLUhlbmcNCj4gPiA+DQo+ID4gPiA+IC0tLS0t
T3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gPiA+IEZyb206IEppYW4tSG9uZyBQYW4gPGpocEBl
bmRsZXNzb3Mub3JnPg0KPiA+ID4gPiBTZW50OiBGcmlkYXksIERlY2VtYmVyIDEwLCAyMDIxIDQ6
MTcgUE0NCj4gPiA+ID4gVG86IFBrc2hpaCA8cGtzaGloQHJlYWx0ZWsuY29tPjsgWWFuLUhzdWFu
IENodWFuZyA8dG9ueTA2MjBlbW1hQGdtYWlsLmNvbT47IEthbGxlIFZhbG8NCj4gPiA+ID4gPGt2
YWxvQGNvZGVhdXJvcmEub3JnPg0KPiA+ID4gPiBDYzogbGludXgtd2lyZWxlc3NAdmdlci5rZXJu
ZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwu
b3JnOw0KPiA+ID4gPiBsaW51eEBlbmRsZXNzb3Mub3JnOyBKaWFuLUhvbmcgUGFuIDxqaHBAZW5k
bGVzc29zLm9yZz4NCj4gPiA+ID4gU3ViamVjdDogW1BBVENIXSBydHc4ODogODgyMWM6IGRpc2Fi
bGUgdGhlIEFTUE0gb2YgUlRMODgyMUNFDQo+ID4gPiA+DQo+ID4gPiA+IE1vcmUgYW5kIG1vcmUg
bGFwdG9wcyBiZWNvbWUgZnJvemVuLCBkdWUgdG8gdGhlIGVxdWlwcGVkIFJUTDg4MjFDRS4NCj4g
PiA+ID4NCj4gPiA+ID4gVGhpcyBwYXRjaCBmb2xsb3dzIHRoZSBpZGVhIG1lbnRpb25lZCBpbiBj
b21taXRzIDk1NmM2ZDRmMjBjNSAoInJ0dzg4Og0KPiA+ID4gPiBhZGQgcXVpcmtzIHRvIGRpc2Fi
bGUgcGNpIGNhcGFiaWxpdGllcyIpIGFuZCAxZDRkY2FmM2RiOWJkICgicnR3ODg6IGFkZA0KPiA+
ID4gPiBxdWlyayB0byBkaXNhYmxlIHBjaSBjYXBzIG9uIEhQIFBhdmlsaW9uIDE0LWNlMHh4eCIp
LCBidXQgZGlzYWJsZXMgaXRzDQo+ID4gPiA+IFBDSSBBU1BNIGNhcGFiaWxpdHkgb2YgUlRMODgy
MUNFIGRpcmVjdGx5LCBpbnN0ZWFkIG9mIGNoZWNraW5nIERNSS4NCj4gPiA+ID4NCj4gPiA+ID4g
QnVnbGluazpodHRwczovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNTIz
OQ0KPiA+ID4gPiBGaXhlczogMWQ0ZGNhZjNkYjliZCAoInJ0dzg4OiBhZGQgcXVpcmsgdG8gZGlz
YWJsZSBwY2kgY2FwcyBvbiBIUCBQYXZpbGlvbiAxNC1jZTB4eHgiKQ0KPiA+ID4gPiBTaWduZWQt
b2ZmLWJ5OiBKaWFuLUhvbmcgUGFuIDxqaHBAZW5kbGVzc29zLm9yZz4NCj4gPiA+DQo+ID4gPiBX
ZSBhbHNvIGRpc2N1c3Mgc2ltaWxhciB0aGluZyBpbiB0aGlzIHRocmVhZDoNCj4gPiA+IGh0dHBz
Oi8vYnVnemlsbGEua2VybmVsLm9yZy9zaG93X2J1Zy5jZ2k/aWQ9MjE1MTMxDQo+ID4gPg0KPiA+
ID4gU2luY2Ugd2Ugc3RpbGwgd2FudCB0byB0dXJuIG9uIEFTUE0gdG8gc2F2ZSBtb3JlIHBvd2Vy
LCBJIHdvdWxkIGxpa2UgdG8NCj4gPiA+IGVudW1lcmF0ZSB0aGUgYmxhY2tsaXN0LiBEb2VzIGl0
IHdvcmsgdG8geW91Pw0KPiA+DQo+ID4gVG9vIG1hbnkgcGxhdGZvcm1zIGFyZSBhZmZlY3RlZCwg
dGhlIGJsYWNrbGlzdCBtZXRob2Qgd29uJ3Qgc2NhbGUuDQo+IA0KPiBFeGFjdGx5IQ0KDQpHb3Qg
aXQuDQoNCj4gDQo+ID4gUmlnaHQgbm93IGl0IHNlZW1zIGxpa2Ugb25seSBJbnRlbCBwbGF0Zm9y
bXMgYXJlIGFmZmVjdGVkLCBzbyBjYW4gSQ0KPiA+IHByb3Bvc2UgYSBwYXRjaCB0byBkaXNhYmxl
IEFTUE0gd2hlbiBpdHMgdXBzdHJlYW0gcG9ydCBpcyBJbnRlbD8NCj4gDQo+IEkgb25seSBoYXZl
IGxhcHRvcHMgd2l0aCBJbnRlbCBjaGlwIG5vdy4gIFNvLCBJIGFtIG5vdCBzdXJlIHRoZSBzdGF0
dXMNCj4gd2l0aCBBTUQgcGxhdGZvcm1zLg0KPiBJZiB0aGlzIGlzIHRydWUsIHRoZW4gImRpc2Fi
bGUgQVNQTSB3aGVuIGl0cyB1cHN0cmVhbSBwb3J0IGlzIEludGVsIg0KPiBtaWdodCBiZSBhIGdv
b2QgaWRlYS4NCj4gDQoNCkppYW4tSG9uZywgY291bGQgeW91IHRyeSBLYWktSGVuZydzIHdvcmth
cm91bmQgdGhhdCBvbmx5IHR1cm4gb2ZmIEFTUE0NCmR1cmluZyBOQVBJIHBvbGwgZnVuY3Rpb24u
IElmIGl0IGFsc28gd29ya3MgdG8geW91LCBJIHRoaW5rIGl0IGlzIG9rYXkNCnRvIGFwcGx5IHRo
aXMgd29ya2Fyb3VuZCB0byBhbGwgSW50ZWwgcGxhdGZvcm0gd2l0aCBSVEw4ODIxQ0UgY2hpcHNl
dC4NCkJlY2F1c2UgdGhpcyB3b3JrYXJvdW5kIGhhcyBsaXR0bGUgKGFsbW9zdCBubykgaW1wYWN0
IG9mIHBvd2VyIGNvbnN1bXB0aW9uLg0KDQo+IA0KPiA+ID4gSWYgc28sIHBsZWFzZSBoZWxwIHRv
IGFkZCBvbmUgcXVpcmsgZW50cnkgb2YgeW91ciBwbGF0Zm9ybS4NCj4gPiA+DQo+ID4gPiBBbm90
aGVyIHRoaW5nIGlzIHRoYXQgImF0dGFjaG1lbnQgMjk5NzM1IiBpcyBhbm90aGVyIHdvcmthcm91
bmQgZm9yIGNlcnRhaW4NCj4gPiA+IHBsYXRmb3JtLiBBbmQsIHdlIHBsYW4gdG8gYWRkIHF1aXJr
IHRvIGVuYWJsZSB0aGlzIHdvcmthcm91bmQuDQo+ID4gPiBDb3VsZCB5b3UgdHJ5IGlmIGl0IHdv
cmtzIHRvIHlvdT8NCj4gPg0KPiA+IFdoZW4gdGhlIGhhcmR3YXJlIGlzIGRvaW5nIERNQSwgaXQg
c2hvdWxkIGluaXRpYXRlIGxlYXZpbmcgQVNQTSBMMSwNCj4gPiBjb3JyZWN0PyBTbyBpbiB0aGVv
cnkgbXkgd29ya2Fyb3VuZCBzaG91bGQgYmUgYmVuaWduIGVub3VnaCBmb3IgbW9zdA0KPiA+IHBs
YXRmb3Jtcy4NCg0KSSBkb24ndCBzZWUgYW5kIGtub3cgdGhlIGRldGFpbCBvZiBoYXJkd2FyZSB3
YXZlZm9ybSwgYnV0IEkgdGhpbmsgeW91cg0KdW5kZXJzdGFuZGluZyBpcyBjb3JyZWN0Lg0KDQot
LQ0KUGluZy1LZQ0KDQo=
