Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A77467EE8B
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 10:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390717AbfHBIO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 04:14:58 -0400
Received: from mga01.intel.com ([192.55.52.88]:50029 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726937AbfHBIO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Aug 2019 04:14:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Aug 2019 01:14:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,337,1559545200"; 
   d="scan'208";a="174866824"
Received: from irsmsx106.ger.corp.intel.com ([163.33.3.31])
  by fmsmga007.fm.intel.com with ESMTP; 02 Aug 2019 01:14:55 -0700
Received: from irsmsx105.ger.corp.intel.com ([169.254.7.164]) by
 IRSMSX106.ger.corp.intel.com ([169.254.8.234]) with mapi id 14.03.0439.000;
 Fri, 2 Aug 2019 09:14:54 +0100
From:   "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
To:     Shannon Nelson <snelson@pensando.io>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Bowers, AndrewX" <andrewx.bowers@intel.com>
Subject: RE: [net-next 2/9] i40e: make visible changed vf mac on host
Thread-Topic: [net-next 2/9] i40e: make visible changed vf mac on host
Thread-Index: AQHVSKrzV/v8AaPFYUql2ho/oxqLW6bm63QAgACVCyA=
Date:   Fri, 2 Aug 2019 08:14:54 +0000
Message-ID: <0EF347314CF65544BA015993979A29CD74513DCB@irsmsx105.ger.corp.intel.com>
References: <20190801205149.4114-1-jeffrey.t.kirsher@intel.com>
 <20190801205149.4114-3-jeffrey.t.kirsher@intel.com>
 <9a3a4675-b031-7666-f259-978d18b6db19@pensando.io>
In-Reply-To: <9a3a4675-b031-7666-f259-978d18b6db19@pensando.io>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNzRkODEwYTctNjdkYy00YmQ3LTg5MTMtZjBlYTU5Y2Y0N2ViIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOGlhbkVqdzdlZ3RPNFwvYUQyVzc0SU4wQVpSbWhMekZMajJWcXJzQ2d6R1ZsOHB3MUxhXC9sOXR4M2pUUXNHcXRtIn0=
x-ctpclassification: CTP_NT
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

R29vZCBkYXkgTmVsc29uDQoNCkluIDk5JSBjYXNlcyBWRiBoYXMgX29ubHkgb25lXyB1bmljYXN0
IG1hYyBhbnl3YXksIGFuZCB0aGUgbGFzdCBNQUMgaGFzIGJlZW4gY2hvc2VuIGJlY2F1c2Ugb2Yg
VkYgbWFjIGFkZHJlc3MgY2hhbmdlIGFsZ28gLSAgaXQgbWFya3MgdW5pY2FzdCBmaWx0ZXIgZm9y
IGRlbGV0aW9uIGFuZCBhcHBlbmRzIGEgbmV3IHVuaWNhc3QgZmlsdGVyIHRvIHRoZSBsaXN0Lg0K
VGhlIGltcGxlbWVudGF0aW9uIGhhcyBiZWVuIGNob3NlbiBiZWNhdXNlIG9mIHNpbXBsaWNpdHkg
LyogSnVzdCAzIG1vcmUgbGluZXMgdG8gc29sdmUgdGhlIGlzc3VlICovLCBmcm9tIG9uZSBwb2lu
dCBpdCBtYXkgbG9vayB3YXN0ZWZ1bCBmb3Igc29tZSAxJSBvZiBWRiBjb3JuZXIgY2FzZXMuDQpC
dXQgZnJvbSBhbm90aGVyIHBvaW50IG9mIHZpZXcsIG1vcmUgY29tcGxpY2F0ZWQgY29kZSB3aWxs
IGFmZmVjdCA5OSUgbm9ybWFsIGNhc2VzLiBNb2Rlcm4gY3B1IGFyZSBzZW5zaXRpdmUgdG8gY2Fj
aGUgdGhyYXNoIGJ5IGNvZGUgc2l6ZSBhbmQgcGlwZWxpbmUgc3RhbGxzIGJ5IGNvbmRpdGlvbmFs
cy4NCg0KQWxleA0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KRnJvbTogU2hhbm5vbiBO
ZWxzb24gW21haWx0bzpzbmVsc29uQHBlbnNhbmRvLmlvXSANClNlbnQ6IEZyaWRheSwgQXVndXN0
IDIsIDIwMTkgMjoxMSBBTQ0KVG86IEtpcnNoZXIsIEplZmZyZXkgVCA8amVmZnJleS50LmtpcnNo
ZXJAaW50ZWwuY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldA0KQ2M6IExva3Rpb25vdiwgQWxla3Nh
bmRyIDxhbGVrc2FuZHIubG9rdGlvbm92QGludGVsLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IG5ob3JtYW5AcmVkaGF0LmNvbTsgc2Fzc21hbm5AcmVkaGF0LmNvbTsgQm93ZXJzLCBBbmRy
ZXdYIDxhbmRyZXd4LmJvd2Vyc0BpbnRlbC5jb20+DQpTdWJqZWN0OiBSZTogW25ldC1uZXh0IDIv
OV0gaTQwZTogbWFrZSB2aXNpYmxlIGNoYW5nZWQgdmYgbWFjIG9uIGhvc3QNCg0KT24gOC8xLzE5
IDE6NTEgUE0sIEplZmYgS2lyc2hlciB3cm90ZToNCj4gRnJvbTogQWxla3NhbmRyIExva3Rpb25v
diA8YWxla3NhbmRyLmxva3Rpb25vdkBpbnRlbC5jb20+DQo+DQo+IFRoaXMgcGF0Y2ggbWFrZXMg
Y2hhbmdlZCBWTSBtYWMgYWRkcmVzcyB2aXNpYmxlIG9uIGhvc3QgdmlhIGlwIGxpbmsgDQo+IHNo
b3cgY29tbWFuZC4gVGhpcyBwcm9ibGVtIGlzIGZpeGVkIGJ5IGNvcHlpbmcgbGFzdCB1bmljYXN0
IG1hYyBmaWx0ZXIgDQo+IHRvIHZmLT5kZWZhdWx0X2xhbl9hZGRyLmFkZHIuIFdpdGhvdXQgdGhp
cyBwYXRjaCBpZiBWRiBNQUMgd2FzIG5vdCBzZXQgDQo+IGZyb20gaG9zdCBzaWRlIGFuZCBpZiB5
b3UgcnVuIGlwIGxpbmsgc2hvdyAkcGYsIG9uIGhvc3Qgc2lkZSB5b3UnZCANCj4gYWx3YXlzIHNl
ZSBhIHplcm8gTUFDLCBub3QgdGhlIHJlYWwgVkYgTUFDIHRoYXQgVkYgYXNzaWduZWQgdG8gaXRz
ZWxmLg0KPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbGVrc2FuZHIgTG9rdGlvbm92IDxhbGVrc2FuZHIu
bG9rdGlvbm92QGludGVsLmNvbT4NCj4gVGVzdGVkLWJ5OiBBbmRyZXcgQm93ZXJzIDxhbmRyZXd4
LmJvd2Vyc0BpbnRlbC5jb20+DQo+IFNpZ25lZC1vZmYtYnk6IEplZmYgS2lyc2hlciA8amVmZnJl
eS50LmtpcnNoZXJAaW50ZWwuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pNDBlL2k0MGVfdmlydGNobmxfcGYuYyB8IDMgKysrDQo+ICAgMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKQ0KPg0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaTQwZS9pNDBlX3ZpcnRjaG5sX3BmLmMgDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaTQwZS9pNDBlX3ZpcnRjaG5sX3BmLmMNCj4gaW5kZXggMDJiMDlhOGFkNTRjLi4yMWY3
YWM1MTRkMWYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUv
aTQwZV92aXJ0Y2hubF9wZi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0
MGUvaTQwZV92aXJ0Y2hubF9wZi5jDQo+IEBAIC0yNjI5LDYgKzI2MjksOSBAQCBzdGF0aWMgaW50
IGk0MGVfdmNfYWRkX21hY19hZGRyX21zZyhzdHJ1Y3QgaTQwZV92ZiAqdmYsIHU4ICptc2cpDQo+
ICAgCQkJfSBlbHNlIHsNCj4gICAJCQkJdmYtPm51bV9tYWMrKzsNCj4gICAJCQl9DQo+ICsJCQlp
ZiAoaXNfdmFsaWRfZXRoZXJfYWRkcihhbC0+bGlzdFtpXS5hZGRyKSkNCj4gKwkJCQlldGhlcl9h
ZGRyX2NvcHkodmYtPmRlZmF1bHRfbGFuX2FkZHIuYWRkciwNCj4gKwkJCQkJCWFsLT5saXN0W2ld
LmFkZHIpOw0KPiAgIAkJfQ0KPiAgIAl9DQo+ICAgCXNwaW5fdW5sb2NrX2JoKCZ2c2ktPm1hY19m
aWx0ZXJfaGFzaF9sb2NrKTsNCg0KU2luY2UgdGhpcyBjb3B5IGlzIGRvbmUgaW5zaWRlIHRoZSBm
b3ItbG9vcCwgaXQgbG9va3MgbGlrZSB5b3UgYXJlIGNvcHlpbmcgZXZlcnkgYWRkcmVzcyBpbiB0
aGUgbGlzdCwgbm90IGp1c3QgdGhlIGxhc3Qgb25lLsKgIFRoaXMgc2VlbXMgd2FzdGVmdWwgYW5k
IHVubmVjZXNzYXJ5Lg0KDQpTaW5jZSBpdCBpcyBwb3NzaWJsZSwgYWx0aG8nIHVubGlrZWx5LCB0
aGF0IHRoZSBmaWx0ZXIgc3luYyB0aGF0IGhhcHBlbnMgYSBsaXR0bGUgbGF0ZXIgY291bGQgZmFp
bCwgbWlnaHQgaXQgYmUgYmV0dGVyIHRvIGRvIHRoZSBjb3B5IGFmdGVyIHlvdSBrbm93IHRoYXQg
dGhlIHN5bmMgaGFzIHN1Y2NlZWRlZD8NCg0KV2h5IGlzIHRoZSBsYXN0IG1hYyBjaG9zZW4gZm9y
IGRpc3BsYXkgcmF0aGVyIHRoYW4gdGhlIGZpcnN0P8KgIElzIHRoZXJlIGFueXRoaW5nIHNwZWNp
YWwgYWJvdXQgdGhlIGxhc3QgbWFjIGFzIG9wcG9zZWQgdG8gdGhlIGZpcnN0IG1hYz8NCg0Kc2xu
DQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tCgpJbnRlbCBUZWNobm9sb2d5IFBvbGFuZCBzcC4geiBvLm8uCnVsLiBT
bG93YWNraWVnbyAxNzMgfCA4MC0yOTggR2RhbnNrIHwgU2FkIFJlam9ub3d5IEdkYW5zayBQb2xu
b2MgfCBWSUkgV3lkemlhbCBHb3Nwb2RhcmN6eSBLcmFqb3dlZ28gUmVqZXN0cnUgU2Fkb3dlZ28g
LSBLUlMgMTAxODgyIHwgTklQIDk1Ny0wNy01Mi0zMTYgfCBLYXBpdGFsIHpha2xhZG93eSAyMDAu
MDAwIFBMTi4KClRhIHdpYWRvbW9zYyB3cmF6IHogemFsYWN6bmlrYW1pIGplc3QgcHJ6ZXpuYWN6
b25hIGRsYSBva3Jlc2xvbmVnbyBhZHJlc2F0YSBpIG1vemUgemF3aWVyYWMgaW5mb3JtYWNqZSBw
b3VmbmUuIFcgcmF6aWUgcHJ6eXBhZGtvd2VnbyBvdHJ6eW1hbmlhIHRlaiB3aWFkb21vc2NpLCBw
cm9zaW15IG8gcG93aWFkb21pZW5pZSBuYWRhd2N5IG9yYXogdHJ3YWxlIGplaiB1c3VuaWVjaWU7
IGpha2lla29sd2llawpwcnplZ2xhZGFuaWUgbHViIHJvenBvd3N6ZWNobmlhbmllIGplc3QgemFi
cm9uaW9uZS4KVGhpcyBlLW1haWwgYW5kIGFueSBhdHRhY2htZW50cyBtYXkgY29udGFpbiBjb25m
aWRlbnRpYWwgbWF0ZXJpYWwgZm9yIHRoZSBzb2xlIHVzZSBvZiB0aGUgaW50ZW5kZWQgcmVjaXBp
ZW50KHMpLiBJZiB5b3UgYXJlIG5vdCB0aGUgaW50ZW5kZWQgcmVjaXBpZW50LCBwbGVhc2UgY29u
dGFjdCB0aGUgc2VuZGVyIGFuZCBkZWxldGUgYWxsIGNvcGllczsgYW55IHJldmlldyBvciBkaXN0
cmlidXRpb24gYnkKb3RoZXJzIGlzIHN0cmljdGx5IHByb2hpYml0ZWQuCg==

