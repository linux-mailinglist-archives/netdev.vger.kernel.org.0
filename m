Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ABCF249815
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 10:17:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgHSIRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 04:17:12 -0400
Received: from mx20.baidu.com ([111.202.115.85]:41664 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725275AbgHSIRL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 04:17:11 -0400
Received: from BJHW-Mail-Ex16.internal.baidu.com (unknown [10.127.64.39])
        by Forcepoint Email with ESMTPS id A7CE815747130467E385;
        Wed, 19 Aug 2020 16:17:02 +0800 (CST)
Received: from BJHW-Mail-Ex13.internal.baidu.com (10.127.64.36) by
 BJHW-Mail-Ex16.internal.baidu.com (10.127.64.39) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1979.3; Wed, 19 Aug 2020 16:17:02 +0800
Received: from BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) by
 BJHW-Mail-Ex13.internal.baidu.com ([100.100.100.36]) with mapi id
 15.01.1979.003; Wed, 19 Aug 2020 16:17:02 +0800
From:   "Li,Rongqing" <lirongqing@baidu.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Piotr <piotr.raczynski@intel.com>,
        Maciej <maciej.machnikowski@intel.com>
Subject: =?utf-8?B?562U5aSNOiDnrZTlpI06IFtJbnRlbC13aXJlZC1sYW5dIFtQQVRDSCAwLzJd?=
 =?utf-8?Q?_intel/xdp_fixes_for_fliping_rx_buffer?=
Thread-Topic: =?utf-8?B?562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFUQ0ggMC8yXSBpbnRlbC94?=
 =?utf-8?Q?dp_fixes_for_fliping_rx_buffer?=
Thread-Index: AQHWdWiRooPzdFWc8kC0ZfZ0v0ywr6k+oKRA///W0QCAAJeXUA==
Date:   Wed, 19 Aug 2020 08:17:02 +0000
Message-ID: <c3695fc71ca140d08a795bbd32d8522f@baidu.com>
References: <1594967062-20674-1-git-send-email-lirongqing@baidu.com>
 <CAJ+HfNi2B+2KYP9A7yCfFUhfUBd=sFPeuGbNZMjhNSdq3GEpMg@mail.gmail.com>
 <4268316b200049d58b9973ec4dc4725c@baidu.com>
 <83e45ec2-1c66-59f6-e817-d4c523879007@intel.com>
In-Reply-To: <83e45ec2-1c66-59f6-e817-d4c523879007@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.22.198.8]
x-baidu-bdmsfe-datecheck: 1_BJHW-Mail-Ex16_2020-08-19 16:17:02:415
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS3pgq7ku7bljp/ku7YtLS0tLQ0KPiDlj5Hku7bkuro6IEJqw7ZybiBUw7ZwZWwg
W21haWx0bzpiam9ybi50b3BlbEBpbnRlbC5jb21dDQo+IOWPkemAgeaXtumXtDogMjAyMOW5tDjm
nIgxOeaXpSAxNDo0NQ0KPiDmlLbku7bkuro6IExpLFJvbmdxaW5nIDxsaXJvbmdxaW5nQGJhaWR1
LmNvbT47IEJqw7ZybiBUw7ZwZWwNCj4gPGJqb3JuLnRvcGVsQGdtYWlsLmNvbT4NCj4g5oqE6YCB
OiBOZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBpbnRlbC13aXJlZC1sYW4NCj4gPGlu
dGVsLXdpcmVkLWxhbkBsaXN0cy5vc3Vvc2wub3JnPjsgS2FybHNzb24sIE1hZ251cw0KPiA8bWFn
bnVzLmthcmxzc29uQGludGVsLmNvbT47IGJwZiA8YnBmQHZnZXIua2VybmVsLm9yZz47IE1hY2ll
aiBGaWphbGtvd3NraQ0KPiA8bWFjaWVqLmZpamFsa293c2tpQGludGVsLmNvbT47IFBpb3RyIDxw
aW90ci5yYWN6eW5za2lAaW50ZWwuY29tPjsgTWFjaWVqDQo+IDxtYWNpZWoubWFjaG5pa293c2tp
QGludGVsLmNvbT4NCj4g5Li76aKYOiBSZTog562U5aSNOiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFU
Q0ggMC8yXSBpbnRlbC94ZHAgZml4ZXMgZm9yIGZsaXBpbmcgcnggYnVmZmVyDQo+IA0KPiBPbiAy
MDIwLTA4LTE5IDAzOjM3LCBMaSxSb25ncWluZyB3cm90ZToNCj4gWy4uLl0NCj4gID4gSGk6DQo+
ICA+DQo+ICA+IFRoYW5rcyBmb3IgeW91ciBleHBsYW5hdGlvbi4NCj4gID4NCj4gID4gQnV0IHdl
IGNhbiByZXByb2R1Y2UgdGhpcyBidWcNCj4gID4NCj4gID4gV2UgdXNlIGVicGYgdG8gcmVkaXJl
Y3Qgb25seS1WeGxhbiBwYWNrZXRzIHRvIG5vbi16ZXJvY29weSBBRl9YRFAsIEZpcnN0IHdlDQo+
IHNlZSBwYW5pYyBvbiB0Y3Agc3RhY2ssIGluIHRjcF9jb2xsYXBzZTogQlVHX09OKG9mZnNldCA8
IDApOyBpdCBpcyB2ZXJ5IGhhcmQgdG8NCj4gcmVwcm9kdWNlLg0KPiAgPg0KPiAgPiBUaGVuIHdl
IHVzZSB0aGUgc2NwIHRvIGRvIHRlc3QsIGFuZCBoYXMgbG90cyBvZiB2eGxhbiBwYWNrZXQgYXQg
dGhlIHNhbWUNCj4gdGltZSwgc2NwIHdpbGwgYmUgYnJva2VuIGZyZXF1ZW50bHkuDQo+ICA+DQo+
IA0KPiBPayEgSnVzdCBzbyB0aGF0IEknbSBjZXJ0YWluIG9mIHlvdXIgc2V0dXAuIFlvdSByZWNl
aXZlIHBhY2tldHMgdG8gYW4gaTQwZSBuZXRkZXYNCj4gd2hlcmUgdGhlcmUncyBhbiBYRFAgcHJv
Z3JhbS4gVGhlIHByb2dyYW0gZG9lcyBYRFBfUEFTUyBvciBYRFBfUkVESVJFQ1QNCj4gdG8gZS5n
LiBkZXZtYXAgZm9yIG5vbi12eGxhbiBwYWNrZXRzLiBIb3dldmVyLCB2eGxhbiBwYWNrZXRzIGFy
ZSByZWRpcmVjdGVkIHRvDQo+IEFGX1hEUCBzb2NrZXQocykgaW4gKmNvcHktbW9kZSouIEFtIEkg
dW5kZXJzdGFuZGluZyB0aGF0IGNvcnJlY3Q/DQo+IA0KU2ltaWxhciBhcyB5b3VyIGRlc2NyaXB0
aW9uLCANCg0KYnV0IHRoZSB4ZHAgcHJvZ3JhbSBvbmx5IHJlZGlyZWN0cyB2eGxhbiBwYWNrZXRz
IHRvIGFmX3hkcCBzb2NrZXQsIG90aGVyIHBhY2tldHMgd2lsbCBnbyB0byBMaW51eCBrZXJuZWwg
bmV0d29ya2luZyBzdGFjaywgbGlrZSBzY3Avc3NoIHBhY2tldHMNCg0KDQo+IEknbSBhc3N1bWlu
ZyB0aGlzIGlzIGFuIHg4Ni02NCB3aXRoIDRrIHBhZ2Ugc2l6ZSwgcmlnaHQ/IDotKSBUaGUgcGFn
ZSBmbGlwcGluZyBpcyBhDQo+IGJpdCBkaWZmZXJlbnQgaWYgdGhlIFBBR0VfU0laRSBpcyBub3Qg
NGsuDQo+IA0KDQpXZSB1c2UgNGsgcGFnZSBzaXplLCBwYWdlIGZsaXBwaW5nIGlzIDRrLCB3ZSBk
aWQgbm90IGNoYW5nZSB0aGUgaTQwZSBkcml2ZXJzLCA0LjE5IHN0YWJsZSBrZXJuZWwNCg0KPiAg
PiBXaXRoIHRoaXMgZml4ZXMsIHNjcCBoYXMgbm90IGJlZW4gYnJva2VuIGFnYWluLCBhbmQga2Vy
bmVsIGlzIG5vdCBwYW5pYw0KPiBhZ2FpbiAgPg0KPiANCj4gTGV0J3MgZGlnIGludG8geW91ciBz
Y2VuYXJpby4NCj4gDQo+IEFyZSB5b3Ugc2F5aW5nIHRoZSBmb2xsb3dpbmc6DQo+IA0KPiBQYWdl
IEE6DQo+ICstLS0tLS0tLS0tLS0NCj4gfCAiZmlyc3Qgc2tiIiAtLS0tPiBSeCBIVyByaW5nIGVu
dHJ5IFggDQo+ICstLS0tLS0tLS0tLS0NCj4gfCAic2Vjb25kIHNrYiItLS0tPiBSeCBIVyByaW5n
IGVudHJ5IFgrMSAob3IgWCtuKQ0KPiArLS0tLS0tLS0tLS0tDQo+IA0KDQpMaWtlOg0KDQpGaXJz
dCBza2Igd2lsbCBiZSBpbnRvIHRjcCBzb2NrZXQgcnggcXVldWUNCg0KU2Vjb25kcyBza2IgaXMg
dnhsYW4gcGFja2V0LCB3aWxsIGJlIGNvcHkgdG8gYWZfeGRwIHNvY2tldCwgYW5kIHJlbGVhc2Vk
Lg0KDQo+IFRoaXMgaXMgYSBzY2VuYXJpbyB0aGF0IHNob3VsZG4ndCBiZSBhbGxvd2VkLCBiZWNh
dXNlIHRoZXJlIGFyZSBub3cgdHdvIHVzZXJzDQo+IG9mIHRoZSBwYWdlLiBJZiB0aGF0J3MgdGhl
IGNhc2UsIHRoZSByZWZjb3VudGluZyBpcyBicm9rZW4uIElzIHRoYXQgdGhlIGNhc2U/DQo+IA0K
DQpUcnVlLCBpdCBpcyBicm9rZW4gZm9yIGNvcHkgbW9kZSB4c2sNCg0KLUxpDQoNCj4gQ2hlY2sg
b3V0IGk0MGVfY2FuX3JldXNlX3J4X3BhZ2UoKS4gVGhlIGlkZWEgd2l0aCBwYWdlIGZsaXBwaW5n
L3JldXNlIGlzIHRoYXQNCj4gdGhlIHBhZ2UgaXMgb25seSByZXVzZWQgaWYgdGhlcmUgaXMgb25s
eSBvbmUgdXNlci4NCj4gDQo+ICA+IFNlZW0geW91ciBleHBsYW5hdGlvbiBpcyB1bmFibGUgdG8g
c29sdmUgbXkgYW5hbHlzaXM6DQo+ICA+DQo+ICA+ICAgICAgICAgMS4gZmlyc3Qgc2tiIGlzIG5v
dCBmb3IgeHNrLCBhbmQgZm9yd2FyZGVkIHRvIGFub3RoZXIgZGV2aWNlDQo+ICA+ICAgICAgICAg
ICAgb3Igc29ja2V0IHF1ZXVlDQo+IA0KPiBUaGUgZGF0YSBmb3IgdGhlICJmaXJzdCBza2IiIHJl
c2lkZXMgb24gYSBwYWdlOg0KPiBBOg0KPiArLS0tLS0tLS0tLS0tDQo+IHwgImZpcnN0IHNrYiIN
Cj4gKy0tLS0tLS0tLS0tLQ0KPiB8IHRvIGJlIHJldXNlZA0KPiArLS0tLS0tLS0tLS0tDQo+IHJl
ZmNvdW50ID4+MQ0KPiANCj4gID4gICAgICAgICAyLiBzZWNvbmRzIHNrYiBpcyBmb3IgeHNrLCBj
b3B5IGRhdGEgdG8geHNrIG1lbW9yeSwgYW5kIHBhZ2UNCj4gID4gICAgICAgICAgICBvZiBza2It
PmRhdGEgaXMgcmVsZWFzZWQNCj4gDQo+IE5vdGUgdGhhdCBwYWdlIEIgIT0gcGFnZSBBLg0KPiAN
Cj4gQjoNCj4gKy0tLS0tLS0tLS0tLQ0KPiB8IHRvIGJlIHJldXNlZC9vciB1c2VkIGJ5IHRoZSBz
dGFjaw0KPiArLS0tLS0tLS0tLS0tDQo+IHwgInNlY29uZCBza2IgZm9yIHhzayINCj4gKy0tLS0t
LS0tLS0tLQ0KPiByZWZjb3VudCA+PjENCj4gDQo+IGRhdGEgaXMgY29waWVkIHRvIHNvY2tldCwg
cGFnZV9mcmFnX2ZyZWUoKSBpcyBjYWxsZWQsIGFuZCB0aGUgcGFnZSBjb3VudCBpcw0KPiBkZWNy
ZWFzZWQuIFRoZSBkcml2ZXIgd2lsbCB0aGVuIGNoZWNrIGlmIHRoZSBwYWdlIGNhbiBiZSByZXVz
ZWQuIElmIG5vdCwgaXQncyBmcmVlZA0KPiB0byB0aGUgcGFnZSBhbGxvY2F0b3IuDQo+IA0KPiAg
PiAgICAgICAgIDMuIHJ4X2J1ZmYgaXMgcmV1c2FibGUgc2luY2Ugb25seSBmaXJzdCBza2IgaXMg
aW4gaXQsIGJ1dA0KPiAgPiAgICAgICAgICAgICpfcnhfYnVmZmVyX2ZsaXAgd2lsbCBtYWtlIHRo
YXQgcGFnZV9vZmZzZXQgaXMgc2V0IHRvDQo+ICA+ICAgICAgICAgICAgZmlyc3Qgc2tiIGRhdGEN
Cj4gDQo+IEknbSBoYXZpbmcgdHJvdWJsZSBncmFzcGluZyBob3cgdGhpcyBpcyBwb3NzaWJsZS4g
TW9yZSB0aGFuIG9uZSB1c2VyIGltcGxpZXMNCj4gdGhhdCBpdCB3b250IGJlIHJldXNlZC4gSWYg
dGhpcyBpcyBwb3NzaWJsZSwgdGhlIHJlY291bnRpbmcvcmV1c2UgbWVjaGFuaXNtIGlzDQo+IGJy
b2tlbiwgYW5kIHRoYXQgaXMgd2hhdCBzaG91bGQgYmUgZml4ZWQuDQo+IA0KPiBUaGUgQUZfWERQ
IHJlZGlyZWN0IHNob3VsZCBub3QgaGF2ZSBzZW1hbnRpY3MgZGlmZmVyZW50IGZyb20sIHNheSwg
ZGV2bWFwDQo+IHJlZGlyZWN0LiBJdCdzIGp1c3QgdGhhdCB0aGUgcGFnZV9mcmFnX2ZyZWUoKSBp
cyBjYWxsZWQgZWFybGllciBmb3IgQUZfWERQLCBpbnN0ZWFkDQo+IG9mIGZyb20gaTQwZV9jbGVh
bl90eF9pcnEoKSBhcyB0aGUgY2FzZSBmb3IgZGV2bWFwL1hEUF9UWC4NCj4gDQo+ICA+ICAgICAg
ICAgNC4gdGhlbiByZXVzZSByeCBidWZmZXIsIGZpcnN0IHNrYiB3aGljaCBzdGlsbCBpcyBsaXZp
bmcNCj4gID4gICAgICAgICAgICB3aWxsIGJlIGNvcnJ1cHRlZC4NCj4gID4NCj4gID4NCj4gID4g
VGhlIHJvb3QgY2F1c2UgaXMgZGlmZmVyZW5jZSB5b3Ugc2FpZCB1cHBlciwgc28gSSBvbmx5IGZp
eGVzIGZvciBub24temVyb2NvcHkNCj4gQUZfWERQICA+DQo+IA0KPiBJIGhhdmUgb25seSBhZGRy
ZXNzZWQgbm9uLXplcm9jb3B5LCBzbyB3ZSdyZSBvbiB0aGUgc2FtZSBwYWdlIChwdW4NCj4gaW50
ZW5kZWQpIGhlcmUhDQo+IA0KPiANCj4gQmrDtnJuDQo+IA0KPiAgPiAtTGkNCg==
