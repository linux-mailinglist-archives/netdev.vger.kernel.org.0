Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648D83D5435
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 09:28:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbhGZGmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 02:42:33 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:50634 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232415AbhGZGm3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 02:42:29 -0400
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.73 with qID 16Q7MkxF6012244, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36502.realtek.com.tw[172.21.6.25])
        by rtits2.realtek.com.tw (8.15.2/2.71/5.88) with ESMTPS id 16Q7MkxF6012244
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 26 Jul 2021 15:22:46 +0800
Received: from RTEXDAG01.realtek.com.tw (172.21.6.100) by
 RTEXH36502.realtek.com.tw (172.21.6.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 15:22:45 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXDAG01.realtek.com.tw (172.21.6.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 26 Jul 2021 15:22:45 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91]) by
 RTEXMBS04.realtek.com.tw ([fe80::5bd:6f71:b434:7c91%5]) with mapi id
 15.01.2106.013; Mon, 26 Jul 2021 15:22:45 +0800
From:   Pkshih <pkshih@realtek.com>
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "tony0620emma@gmail.com" <tony0620emma@gmail.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Neo Jou <neojou@gmail.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
Subject: RE: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the iterator reads or writes registers
Thread-Topic: [PATCH RFC v1 2/7] rtw88: Use rtw_iterate_vifs where the
 iterator reads or writes registers
Thread-Index: AQHXe0wjJ2b05+r4fEiABzib9kTzlatJpBFQgAoYEgCAASRtAA==
Date:   Mon, 26 Jul 2021 07:22:45 +0000
Message-ID: <a9d39fa7f2974032adf10435927ac056@realtek.com>
References: <20210717204057.67495-1-martin.blumenstingl@googlemail.com>
 <20210717204057.67495-3-martin.blumenstingl@googlemail.com>
 <2170471a1c144adb882d06e08f3c9d1a@realtek.com>
 <CAFBinCCqVpqC+CaJqTjhCj6-4rFcttQ-cFjOPwtKFbXbnop3XA@mail.gmail.com>
In-Reply-To: <CAFBinCCqVpqC+CaJqTjhCj6-4rFcttQ-cFjOPwtKFbXbnop3XA@mail.gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.69.146]
x-kse-serverinfo: RTEXDAG01.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIxLzcvMjYg5LiK5Y2IIDA2OjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-KSE-ServerInfo: RTEXH36502.realtek.com.tw, 9
X-KSE-Attachment-Filter-Triggered-Rules: Clean
X-KSE-Attachment-Filter-Triggered-Filters: Clean
X-KSE-BulkMessagesFiltering-Scan-Result: protection disabled
X-KSE-AntiSpam-Outbound-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/26/2021 07:01:19
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165231 [Jul 26 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: pkshih@realtek.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;realtek.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-AntiSpam-Info: Auth:dkim=none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Heuristic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/26/2021 07:04:00
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcnRpbiBCbHVtZW5zdGlu
Z2wgW21haWx0bzptYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tXQ0KPiBTZW50OiBN
b25kYXksIEp1bHkgMjYsIDIwMjEgNTozMSBBTQ0KPiBUbzogUGtzaGloDQo+IENjOiBsaW51eC13
aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7IHRvbnkwNjIwZW1tYUBnbWFpbC5jb207IGt2YWxvQGNv
ZGVhdXJvcmEub3JnOw0KPiBqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBOZW8gSm91OyBKZXJuZWoN
Cj4gU2tyYWJlYw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIFJGQyB2MSAyLzddIHJ0dzg4OiBVc2Ug
cnR3X2l0ZXJhdGVfdmlmcyB3aGVyZSB0aGUgaXRlcmF0b3IgcmVhZHMgb3Igd3JpdGVzIHJlZ2lz
dGVycw0KPiANCj4gSGVsbG8gUGluZy1LZSwNCj4gDQo+IE9uIE1vbiwgSnVsIDE5LCAyMDIxIGF0
IDc6NDcgQU0gUGtzaGloIDxwa3NoaWhAcmVhbHRlay5jb20+IHdyb3RlOg0KPiA+DQo+ID4NCj4g
Pg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IE1hcnRpbiBC
bHVtZW5zdGluZ2wgW21haWx0bzptYXJ0aW4uYmx1bWVuc3RpbmdsQGdvb2dsZW1haWwuY29tXQ0K
PiA+ID4gU2VudDogU3VuZGF5LCBKdWx5IDE4LCAyMDIxIDQ6NDEgQU0NCj4gPiA+IFRvOiBsaW51
eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmcNCj4gPiA+IENjOiB0b255MDYyMGVtbWFAZ21haWwu
Y29tOyBrdmFsb0Bjb2RlYXVyb3JhLm9yZzsgam9oYW5uZXNAc2lwc29sdXRpb25zLm5ldDsNCj4g
bmV0ZGV2QHZnZXIua2VybmVsLm9yZzsNCj4gPiA+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IE5lbyBKb3U7IEplcm5laiBTa3JhYmVjOyBNYXJ0aW4gQmx1bWVuc3RpbmdsDQo+ID4gPiBT
dWJqZWN0OiBbUEFUQ0ggUkZDIHYxIDIvN10gcnR3ODg6IFVzZSBydHdfaXRlcmF0ZV92aWZzIHdo
ZXJlIHRoZSBpdGVyYXRvciByZWFkcyBvciB3cml0ZXMgcmVnaXN0ZXJzDQo+ID4gPg0KPiA+ID4g
VXBjb21pbmcgU0RJTyBzdXBwb3J0IG1heSBzbGVlcCBpbiB0aGUgcmVhZC93cml0ZSBoYW5kbGVy
cy4gU3dpdGNoDQo+ID4gPiBhbGwgdXNlcnMgb2YgcnR3X2l0ZXJhdGVfdmlmc19hdG9taWMoKSB3
aGljaCBhcmUgZWl0aGVyIHJlYWRpbmcgb3INCj4gPiA+IHdyaXRpbmcgYSByZWdpc3RlciB0byBy
dHdfaXRlcmF0ZV92aWZzKCkuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTWFydGluIEJs
dW1lbnN0aW5nbCA8bWFydGluLmJsdW1lbnN0aW5nbEBnb29nbGVtYWlsLmNvbT4NCj4gPiA+IC0t
LQ0KPiA+ID4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL3JlYWx0ZWsvcnR3ODgvbWFpbi5jIHwgNiAr
KystLS0NCj4gPiA+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L3BzLmMgICB8
IDIgKy0NCj4gPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlv
bnMoLSkNCj4gPiA+DQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVh
bHRlay9ydHc4OC9tYWluLmMNCj4gYi9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4
L21haW4uYw0KPiA+ID4gaW5kZXggYzYzNjQ4MzdlODNiLi4yMDcxNjFhOGY1YmQgMTAwNjQ0DQo+
ID4gPiAtLS0gYS9kcml2ZXJzL25ldC93aXJlbGVzcy9yZWFsdGVrL3J0dzg4L21haW4uYw0KPiA+
ID4gKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvcmVhbHRlay9ydHc4OC9tYWluLmMNCj4gPiA+
IEBAIC0yMjksOCArMjI5LDggQEAgc3RhdGljIHZvaWQgcnR3X3dhdGNoX2RvZ193b3JrKHN0cnVj
dCB3b3JrX3N0cnVjdCAqd29yaykNCj4gPiA+ICAgICAgIHJ0d19waHlfZHluYW1pY19tZWNoYW5p
c20ocnR3ZGV2KTsNCj4gPiA+DQo+ID4gPiAgICAgICBkYXRhLnJ0d2RldiA9IHJ0d2RldjsNCj4g
PiA+IC0gICAgIC8qIHVzZSBhdG9taWMgdmVyc2lvbiB0byBhdm9pZCB0YWtpbmcgbG9jYWwtPmlm
bGlzdF9tdHggbXV0ZXggKi8NCj4gPiA+IC0gICAgIHJ0d19pdGVyYXRlX3ZpZnNfYXRvbWljKHJ0
d2RldiwgcnR3X3ZpZl93YXRjaF9kb2dfaXRlciwgJmRhdGEpOw0KPiA+ID4gKw0KPiA+ID4gKyAg
ICAgcnR3X2l0ZXJhdGVfdmlmcyhydHdkZXYsIHJ0d192aWZfd2F0Y2hfZG9nX2l0ZXIsICZkYXRh
KTsNCj4gPg0KPiA+IFlvdSByZXZlcnQgdGhlIGZpeCBvZiBbMV0uDQo+IFRoYW5rcyBmb3IgYnJp
bmdpbmcgdGhpcyB0byBteSBhdHRlbnRpb24hDQo+IA0KPiA+IEkgdGhpbmsgd2UgY2FuIG1vdmUg
b3V0IHJ0d19jaGlwX2NmZ19jc2lfcmF0ZSgpIGZyb20gcnR3X2R5bmFtaWNfY3NpX3JhdGUoKSwg
YW5kDQo+ID4gYWRkL3NldCBhIGZpZWxkIGNmZ19jc2lfcmF0ZSB0byBpdGVyYSBkYXRhLiBUaGVu
LCB3ZSBkbyBydHdfY2hpcF9jZmdfY3NpX3JhdGUoKQ0KPiA+IG91dHNpZGUgaXRlcmF0ZSBmdW5j
dGlvbi4gVGhlcmVmb3JlLCB3ZSBjYW4ga2VlcCB0aGUgYXRvbWljIHZlcnNpb24gb2YgaXRlcmF0
ZV92aWZzLg0KPiBqdXN0IHRvIG1ha2Ugc3VyZSB0aGF0IEkgdW5kZXJzdGFuZCB0aGlzIGNvcnJl
Y3RseToNCj4gcnR3X2l0ZXJhdGVfdmlmc19hdG9taWMgY2FuIGJlIHRoZSBpdGVyYXRvciBhcyBp
dCB3YXMgYmVmb3JlDQo+IGluc2lkZSB0aGUgaXRlcmF0b3IgZnVuYyBJIHVzZSBzb21ldGhpbmcg
bGlrZToNCj4gICAgIGl0ZXJfZGF0YS0+Y2ZnX2NzaV9yYXRlID0gcnR3dmlmLT5iZmVlLnJvbGUg
PT0gUlRXX0JGRUVfU1UgfHwNCj4gcnR3dmlmLT5iZmVlLnJvbGUgPT0gUlRXX0JGRUVfTVUgfHwg
aXRlcl9kYXRhLT5jZmdfY3NpX3JhdGU7DQo+ICh0aGUgbGFzdCBpdGVyX2RhdGEtPmNmZ19jc2lf
cmF0ZSBtYXkgcmVhZCBhIGJpdCBzdHJhbmdlLCBidXQgSSB0aGluaw0KPiBpdCdzIG5lZWRlZCBi
ZWNhdXNlIHRoZXJlIGNhbiBiZSBtdWx0aXBsZSBpbnRlcmZhY2VzIGFuZCBpZiBhbnkgb2YNCj4g
dGhlbSBoYXMgY2ZnX2NzaV9yYXRlIHRydWUgdGhlbiB3ZSBuZWVkIHRvIHJlbWVtYmVyIHRoYXQp
DQo+IHRoZW4gbW92ZSB0aGUgcnR3X2NoaXBfY2ZnX2NzaV9yYXRlIG91dHNpZGUgdGhlIGl0ZXJh
dG9yIGZ1bmN0aW9uLA0KPiB0YWtpbmcgaXRlcl9kYXRhLT5jZmdfY3NpX3JhdGUgdG8gZGVjaWRl
IHdoZXRoZXIgaXQgbmVlZHMgdG8gYmUgY2FsbGVkDQo+IA0KDQpZZXMsIHlvdSB1bmRlcnN0YW5k
IGNvcnJlY3RseS4NCg0KRm9yIHRoZSBzdHJhbmdlIHBhcnQgdGhhdCB5b3UgbWVudGlvbmVkLCBo
b3cgYWJvdXQgdGhpcz8NCml0ZXJfZGF0YS0+Y2ZnX2NzaV9yYXRlIHw9IHJ0d3ZpZi0+YmZlZS5y
b2xlID09IFJUV19CRkVFX1NVIHx8DQogICAgICAgICAgICAgICAgICAgICAgICAgICBydHd2aWYt
PmJmZWUucm9sZSA9PSBSVFdfQkZFRV9NVTsNCg0KLS0NClBpbmctS2UNCg0K
