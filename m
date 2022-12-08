Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA526473B6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 16:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiLHP7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 10:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHP7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 10:59:35 -0500
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 069A04B775
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 07:59:30 -0800 (PST)
Authenticated-By: 
X-SpamFilter-By: ArmorX SpamTrap 5.77 with qID 2B8FwcqmF016275, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (rtexh36506.realtek.com.tw[172.21.6.27])
        by rtits2.realtek.com.tw (8.15.2/2.81/5.90) with ESMTPS id 2B8FwcqmF016275
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=FAIL);
        Thu, 8 Dec 2022 23:58:38 +0800
Received: from RTEXMBS02.realtek.com.tw (172.21.6.95) by
 RTEXH36506.realtek.com.tw (172.21.6.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.9; Thu, 8 Dec 2022 23:59:26 +0800
Received: from RTEXMBS04.realtek.com.tw (172.21.6.97) by
 RTEXMBS02.realtek.com.tw (172.21.6.95) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.7; Thu, 8 Dec 2022 23:59:25 +0800
Received: from RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b]) by
 RTEXMBS04.realtek.com.tw ([fe80::15b5:fc4b:72f3:424b%5]) with mapi id
 15.01.2375.007; Thu, 8 Dec 2022 23:59:25 +0800
From:   Hau <hau@realtek.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) + rtl8211fs fiber application
Thread-Topic: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a)
 + rtl8211fs fiber application
Thread-Index: AQHZBZK0jNmNF43ANUm+ON2R2qDGTK5d0aqAgATjHlD//8MxAIABsEYw
Date:   Thu, 8 Dec 2022 15:59:25 +0000
Message-ID: <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
 <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
In-Reply-To: <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.177.74]
x-kse-serverinfo: RTEXMBS02.realtek.com.tw, 9
x-kse-attachmentfiltering-interceptor-info: no applicable attachment filtering
 rules found
x-kse-antivirus-interceptor-info: scan successful
x-kse-antivirus-info: =?utf-8?B?Q2xlYW4sIGJhc2VzOiAyMDIyLzEyLzgg5LiL5Y2IIDAyOjAwOjAw?=
x-kse-bulkmessagesfiltering-scan-result: protection disabled
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
        T_SPF_HELO_TEMPERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiAwNy4xMi4yMDIyIDE4OjQzLCBIYXUgd3JvdGU6DQo+ID4+DQo+ID4+IE9uIDAxLjEyLjIw
MjIgMTU6MzksIENodW5oYW8gTGluIHdyb3RlOg0KPiA+Pj4gcnRsODE2OGgocmV2aWQgMHgyYSkg
KyBydGw4MjExZnMgaXMgZm9yIHV0cCB0byBmaWJlciBhcHBsaWNhdGlvbi4NCj4gPj4+IHJ0bDgx
NjhoIGlzIGNvbm5lY3RlZCB0byBydGw4MjExZnMgdXRwIGludGVyZmFjZS4gQW5kIGZpYmVyIGlz
DQo+ID4+PiBjb25uZWN0ZWQgdG8gcnRsODIxMWZzIHNmcCBpbnRlcmZhY2UuIHJ0bDgxNjhoIHVz
ZSBpdHMgZWVwcm0gb3IgZ3BvDQo+ID4+PiBwaW5zIHRvIGNvbnRyb2wgcnRsODIxMWZzIG1kaW8g
YnVzLg0KPiA+Pj4NCj4gPj4NCj4gPj4gSSBmb3VuZCBhIGRhdGFzaGVldCBmb3IgUlRMODIxMUZT
IGFuZCBpdCBkb2Vzbid0IG1lbnRpb24gU0ZQIHN1cHBvcnQuDQo+ID4+IEZvciB0aGUgZmliZXIg
dXNlIGNhc2UgaXQgbWVudGlvbnMgUkdNSUkgZm9yIE1BQy9QSFkgY29ubmVjdGlvbiBhbmQNCj4g
Pj4gU2VyRGVzIGZvciBjb25uZWN0aW5nIHRoZSBQSFkgdG8gdGhlIGZpYmVyIG1vZHVsZS4gSXMg
dGhpcyB0aGUgbW9kZQ0KPiA+PiB5b3UnZCBsaWtlIHRvIHN1cHBvcnQ/DQo+ID4+ICJ1dHAgdG8g
ZmliZXIiIHNvdW5kcyBsaWtlIHRoZSBtZWRpYSBjb252ZXJ0ZXIgYXBwbGljYXRpb24sIGFuZCBJ
DQo+ID4+IHRoaW5rIHRoYXQncyBub3Qgd2hhdCB3ZSB3YW50IGhlcmUuIFNvIGl0J3MgbWlzbGVh
ZGluZy4NCj4gPiBUaGlzIGFwcGxpY2F0aW9uIGlzIG5vdCBsaXN0ZWQgaW4gZGF0YXNoZWV0LiBC
dXQgaXQgaXMgc2ltaWxhciB0byB1dHAgdG8gZmliZXINCj4gYXBwbGljYXRpb24uIEZpYmVyIGNv
bm5lY3RzIHRvIHJ0bDgyMTFmcyB0aHJvdWdoIFNlckRlcyBpbnRlcmZhY2UuDQo+ID4gcnRsODE2
OGggY29ubmVjdHMgdG8gcnRsODIxMWZzIHRocm91Z2ggbWRpIGludGVyZmFjZS4gcnRsODE2OGgg
YWxzbw0KPiA+IGNvbm5lY3RzIHRvIHJ0bDgyMTFmcyBtZGMvbWRpbyBpbnRlcmZhY2UgdGhyb3Vn
aCBpdHMgZWVwcm9tIG9yIGdwbyBwaW5zDQo+IGZvciBjb250cm9sbGluZyBydGw4MjExZnMuIFRo
ZSBsaW5rIGJldHdlZW4gcnRsODIxMWZzIGFuZCBmaWJlciwgYW5kIHRoZSBsaW5rDQo+IGJldHdl
ZW4gcnRsODIxMWZzIGFuZCBydGw4MTY4aCBzaG91bGQgYmUgdGhlIHNhbWUuDQo+ID4gIERyaXZl
ciBqdXN0IG5lZWRzIHRvIHNldCB0aGUgbGluayBjYXBhYmlsaXR5IG9mIHJ0bDgxNjhoIHRvIGF1
dG8gbmVnYXRpb24gYW5kDQo+IHJ0bDgyMTFmcyB3aWxsIHByb3BhZ2F0ZSB0aGUgbGluayBzdGF0
dXMgYmV0d2VlbiBmaWJlciBhbmQgaXRzZWxmIHRvIHJ0bDgxNjhoLg0KPiA+IEJ1dCBydGw4MTY4
aCB3aWxsIG5vdCBrbm93IHRoZSBsaW5rIGNhcGFiaWxpdHkgb2YgZmliZXIuIFNvIHdoZW4gc3lz
dGVtDQo+IHN1c3BlbmQsIGlmIHdvbCBpcyBlbmFibGVkLCBkcml2ZXIgY2Fubm90IHNwZWVkIGRv
d24gcnRsODE2OGgncyBwaHkuDQo+ID4gT3IgcnRsODE2OGggY2Fubm90IGJlIHdha2VuIHVwLg0K
PiA+DQo+ID4gSSB3aWxsIHN1Ym1pdCBhIG5ldyBwYXRjaCBhY2NvcmRpbmcgeW91ciBhZHZpY2Uu
IEJ1dCB3ZSBhcmUgY29uc2lkZXJpbmcgbm90DQo+IHRvIHVzZSBkcml2ZXIocjgxNjkpIHRvIHNl
dHVwIHJ0bDgyMTFmcy4gU28gbmV4dCBwYXRjaCBtYXliZSBzaW1wbGVyLg0KPiA+DQo+IA0KPiBT
b3VuZHMgc3RyYW5nZSB0aGF0IFJUTDgxNjhIIGNvbm5lY3RzIHRvIFJUTDgyMTFGUyB2aWEgTURJ
LiBUeXBpY2FsbHkgeW91DQo+IHdvdWxkIHVzZSBSR01JSSBoZXJlLg0KPiBJcyBpdCBiZWNhdXNl
IFJUTDgxNjhIIGhhcyBubyBwaW5zIGZvciBSR01JSSB0byBleHRlcm5hbCBQSFkncz8NCj4gDQo+
IFRoZW4gbXkgdW5kZXJzdGFuZGluZyB3b3VsZCBiZSB0aGF0IHlvdSBkbyBpdCBsaWtlIHRoaXM6
DQo+IFJUTDgxNjhIIE1BQyAtPiA8aW50ZXJuYWwgUkdNSUk+IC0+IFJUTDgxNjhIIFBIWSAtPiA8
TURJPiAtPiBSVEw4MjExRlMgLQ0KPiA+IDxTZXJEZXM+IC0+IEZpYmVyIG1vZHVsZQ0KPiAgICB8
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwNCj4gICAgIC0tLS0tLS0tLS0tLS0tLS0tLS1iaXQtYmFuZ2VkIE1ESU8tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0NCj4gDQo+IFNvdSB5b3Ugd291bGQgbmVlZCB0byBjb250cm9sIGJv
dGggUEhZJ3MsIHJpZ2h0PyBCZWNhdXNlIHNldHVwIHdvdWxkbid0DQo+IHdvcmsgaWYgZS5nLiBS
VEw4MTY4SC1pbnRlcm5hbCBQSFkgaXMgcG93ZXJlZCBkb3duLg0KPiBJcyB0aGUgUlRMODIxMUZT
IGludGVycnVwdCBwaW4gY29ubmVjdGVkIHRvIFJUTDgxNjhIPyBPciBoYXMgcG9sbGluZyB0byBi
ZQ0KPiB1c2VkIHRvIGdldCB0aGUgc3RhdHVzIGZyb20gUlRMODIxMUZTPw0KPiANCnJ0bDgxNjhI
IGlzIGFuIGludGVncmF0ZWQgRXRoZXJuZXQgY29udHJvbGxlciwgaXQgY29udGFpbnMgTUFDIGFu
ZCBQSFkuIEl0IGhhcyBubyBSR01JSSBpbnRlcmZhY2UgdG8gY29ubmVjdCB0byBleHRlcm5hbCBQ
SFkuDQpJbiB0aGlzIGFwcGxpY2F0aW9uLCBkcml2ZXIgcjgxNjkgY29udHJvbHMgdHdvIFBIWS4g
T25lIGlzIHJ0bDgxNjhoJ3MgUEhZLCBhbm90aGVyIFBIWSBpcyBydGw4MjExZnMuDQpXaGF0IHI4
MTY5IGhhdmUgdG8gZG8gaXMgdG8gZW5hYmxlIGFsbCBsaW5rIGNhcGFiaWxpdHkuIHJ0bDgyMTFm
cyBmaXJtd2FyZSB3aWxsIHByb3BhZ2F0ZSBmaWJlcidzIGxpbmsgc3RhdHVzIHRvIHJ0bDgxNjho
LiANCnJ0bDgxNjhoIHdpbGwga25vdyB0aGUgZmliZXIncyBsaW5rIHN0YXR1cyBmcm9tIGl0cyBN
QUMgcmVnaXN0ZXIgMHg2Yy4gVGhpcyB0aGUgc2FtZSBhcyBiZWZvcmUuIFNvIHJ0bDgyMTFmcydz
IGludGVycnVwdCBwaW4gDQp3aWxsIG5vdCBjb25uZWN0IHRvIHJ0bDgxNjhoLiBBbmQgcnRsODE2
OGggZG9lcyBub3QgaGF2ZSB0byBwb2xsaW5nIHRoZSBsaW5rIHN0YXR1cyBvZiBydGw4MjExZnMu
DQoNClJUTDgxNjhIIE1BQyAtPiA8aW50ZXJuYWwgUkdNSUk+IC0+IFJUTDgxNjhIIFBIWSAtPiA8
TURJPiAtPiBSVEw4MjExRlMgLT4gPFNlckRlcz4gLT4gRmliZXIgbW9kdWxlDQogICB8ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgfA0KICAgIC0tLS0tLS0tLS0tLS0tLS0tLS1iaXQtYmFuZ2VkIE1ESU8odXNl
IGVlcHJvbSBvciBncG8gcGluKS0tLS0tLS0tLS0tLS0tLS0tLS0tDQoNCkJlY2F1c2UgcnRsODIx
MWZzJ3MgZmlybXdhcmUgd2lsbCBzZXQgbGluayBjYXBhYmlsaXR5IHRvIDEwME0gYW5kIEdJR0Eg
d2hlbiBmaWJlciBsaW5rIGlzIGZyb20gb2ZmIHRvIG9uLi4NClNvIHdoZW4gc3lzdGVtIHN1c3Bl
bmQsIGlmIHdvbCBpcyBlbmFibGVkLCBydGw4MTY4aCB3aWxsIHNwZWVkIGRvd24gdG8gMTAwTShi
ZWNhdXNlIHJ0bDgyMTFmcyBhZHZlcnRpc2UgMTAwTSBhbmQgZ2lnYSB0byBydGw4MTY4aCkuDQpU
aGUgbGluayBzcGVlZCBiZXR3ZWVuIHJ0bDgxNjhoIGFuZCBmaWJlciB3aWxsIG1pc21hdGNoLiBU
aGF0IHdpbGwgY2F1c2Ugd29sIGZhaWwuDQoNCkFuZCBpbiB0aGUgYXBwbGljYXRpb24sIHdlIGFs
c28gbmVlZCB0byBzZXR1cCBydGw4MjExZnMuIE9yIGl0IG1heSBhbHdheXMgbGluayBkb3duLg0K
DQogLS0tLS0tUGxlYXNlIGNvbnNpZGVyIHRoZSBlbnZpcm9ubWVudCBiZWZvcmUgcHJpbnRpbmcg
dGhpcyBlLW1haWwuDQo=
