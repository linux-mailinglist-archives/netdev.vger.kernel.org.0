Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69155A4175
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 02:53:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728445AbfHaAxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 20:53:48 -0400
Received: from rtits2.realtek.com ([211.75.126.72]:51535 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728368AbfHaAxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 20:53:48 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.62 with qID x7V0raCF025222, This message is accepted by code: ctloc85258
Received: from mail.realtek.com (RTITCAS12.realtek.com.tw[172.21.6.16])
        by rtits2.realtek.com.tw (8.15.2/2.57/5.78) with ESMTPS id x7V0raCF025222
        (version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 31 Aug 2019 08:53:36 +0800
Received: from RTITMBSVM01.realtek.com.tw ([fe80::f4ca:82cf:5a3:5d7a]) by
 RTITCAS12.realtek.com.tw ([::1]) with mapi id 14.03.0439.000; Sat, 31 Aug
 2019 08:53:35 +0800
From:   Amber Chen <amber.chen@realtek.com>
To:     Prashant Malani <pmalani@chromium.org>
CC:     Hayes Wang <hayeswang@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Bambi Yeh <bambi.yeh@realtek.com>,
        Ryankao <ryankao@realtek.com>, Jackc <jackc@realtek.com>,
        Albertk <albertk@realtek.com>,
        "marcochen@google.com" <marcochen@google.com>,
        nic_swsd <nic_swsd@realtek.com>,
        Grant Grundler <grundler@chromium.org>
Subject: Re: Proposal: r8152 firmware patching framework
Thread-Topic: Proposal: r8152 firmware patching framework
Thread-Index: AQHVX4GpLe4Ainm62U+w4SHIO4NvIacUbgZs
Date:   Sat, 31 Aug 2019 00:53:35 +0000
Message-ID: <755AFD2B-D66F-40FF-ADCD-5077ECC569FE@realtek.com>
References: <CACeCKacOcg01NuCWgf2RRer3bdmW-CH7d90Y+iD2wQh5Ka6Mew@mail.gmail.com>,<CACeCKacjCkS5UmzS9irm0JjGmk98uBBBsTLSzrXoDUJ60Be9Vw@mail.gmail.com>
In-Reply-To: <CACeCKacjCkS5UmzS9irm0JjGmk98uBBBsTLSzrXoDUJ60Be9Vw@mail.gmail.com>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

KyBhY2N0IG1nciwgU3RlcGhlbg0KDQoNCg0KPiBQcmFzaGFudCBNYWxhbmkgPHBtYWxhbmlAY2hy
b21pdW0ub3JnPiCp8yAyMDE5pn44pOszMaTpIKRXpMg2OjI0ILxnuUShRw0KPiANCj4gKEFkZGlu
ZyBhIGZldyBtb3JlIFJlYWx0ZWsgZm9sa3MpDQo+IA0KPiBGcmllbmRseSBwaW5nLiBBbnkgdGhv
dWdodHMgLyBmZWVkYmFjaywgUmVhbHRlayBmb2xrcyAoYW5kIG90aGVycykgPw0KPiANCj4+IE9u
IFRodSwgQXVnIDI5LCAyMDE5IGF0IDExOjQwIEFNIFByYXNoYW50IE1hbGFuaSA8cG1hbGFuaUBj
aHJvbWl1bS5vcmc+IHdyb3RlOg0KPj4gDQo+PiBIaSwNCj4+IA0KPj4gVGhlIHI4MTUyIGRyaXZl
ciBzb3VyY2UgY29kZSBkaXN0cmlidXRlZCBieSBSZWFsdGVrIChvbg0KPj4gd3d3LnJlYWx0ZWsu
Y29tKSBjb250YWlucyBmaXJtd2FyZSBwYXRjaGVzLiBUaGlzIGludm9sdmVzIGJpbmFyeQ0KPj4g
Ynl0ZS1hcnJheXMgYmVpbmcgd3JpdHRlbiBieXRlL3dvcmQtd2lzZSB0byB0aGUgaGFyZHdhcmUg
bWVtb3J5DQo+PiBFeGFtcGxlOiBncnVuZGxlckBjaHJvbWl1bS5vcmcgKGNjLWVkKSBoYXMgYW4g
ZXhwZXJpbWVudGFsIHBhdGNoIHdoaWNoDQo+PiBpbmNsdWRlcyB0aGUgZmlybXdhcmUgcGF0Y2hp
bmcgY29kZSB3aGljaCB3YXMgZGlzdHJpYnV0ZWQgd2l0aCB0aGUNCj4+IFJlYWx0ZWsgc291cmNl
IDoNCj4+IGh0dHBzOi8vY2hyb21pdW0tcmV2aWV3Lmdvb2dsZXNvdXJjZS5jb20vYy9jaHJvbWl1
bW9zL3RoaXJkX3BhcnR5L2tlcm5lbC8rLzE0MTc5NTMNCj4+IA0KPj4gSXQgd291bGQgYmUgbmlj
ZSB0byBoYXZlIGEgd2F5IHRvIGluY29ycG9yYXRlIHRoZXNlIGZpcm13YXJlIGZpeGVzDQo+PiBp
bnRvIHRoZSB1cHN0cmVhbSBjb2RlLiBTaW5jZSBoYXZpbmcgaW5kZWNpcGhlcmFibGUgYnl0ZS1h
cnJheXMgaXMgbm90DQo+PiBwb3NzaWJsZSB1cHN0cmVhbSwgSSBwcm9wb3NlIHRoZSBmb2xsb3dp
bmc6DQo+PiAtIFdlIHVzZSB0aGUgYXNzaXN0YW5jZSBvZiBSZWFsdGVrIHRvIGNvbWUgdXAgd2l0
aCBhIGZvcm1hdCB3aGljaCB0aGUNCj4+IGZpcm13YXJlIHBhdGNoIGZpbGVzIGNhbiBmb2xsb3cg
KHRoaXMgY2FuIGJlIGRvY3VtZW50ZWQgaW4gdGhlDQo+PiBjb21tZW50cykuDQo+PiAgICAgICAt
IEEgcmVhbCBzaW1wbGUgZm9ybWF0IGNvdWxkIGxvb2sgbGlrZSB0aGlzOg0KPj4gICAgICAgICAg
ICAgICArDQo+PiA8c2VjdGlvbjE+PHNpemVfaW5fYnl0ZXM+PGFkZHJlc3MxPjxkYXRhMT48YWRk
cmVzczI+PGRhdGEyPi4uLjxhZGRyZXNzTj48ZGF0YU4+PHNlY3Rpb24yPi4uLg0KPj4gICAgICAg
ICAgICAgICAgKyBUaGUgZHJpdmVyIHdvdWxkIGJlIGFibGUgdG8gdW5kZXJzdGFuZCBob3cgdG8g
cGFyc2UNCj4+IGVhY2ggc2VjdGlvbiAoZS5nIGlzIGVhY2ggZGF0YSBlbnRyeSBhIGJ5dGUgb3Ig
YSB3b3JkPykNCj4+IA0KPj4gLSBXZSB1c2UgcmVxdWVzdF9maXJtd2FyZSgpIHRvIGxvYWQgdGhl
IGZpcm13YXJlLCBwYXJzZSBpdCBhbmQgd3JpdGUNCj4+IHRoZSBkYXRhIHRvIHRoZSByZWxldmFu
dCByZWdpc3RlcnMuDQo+PiANCj4+IEknbSB1bmZhbWlsaWFyIHdpdGggd2hhdCB0aGUgcHJlZmVy
cmVkIG1ldGhvZCBvZiBmaXJtd2FyZSBwYXRjaGluZyBpcywNCj4+IHNvIEkgaG9wZSB0aGUgbWFp
bnRhaW5lcnMgY2FuIGhlbHAgc3VnZ2VzdCB0aGUgYmVzdCBwYXRoIGZvcndhcmQuDQo+PiANCj4+
IEFzIGFuIGFzaWRlOiBJdCB3b3VsZCBiZSBncmVhdCBpZiBSZWFsdGVrIGNvdWxkIHB1Ymxpc2gg
YSBsaXN0IG9mDQo+PiBmaXhlcyB0aGF0IHRoZSBmaXJtd2FyZSBwYXRjaGVzIGltcGxlbWVudCAo
SSB0aGluayBhIGxpc3Qgb24gdGhlDQo+PiBkcml2ZXIgZG93bmxvYWQgcGFnZSBvbiB0aGUgUmVh
bHRlayB3ZWJzaXRlIHdvdWxkIGJlIGFuIGV4Y2VsbGVudA0KPj4gc3RhcnRpbmcgcG9pbnQpLg0K
Pj4gDQo+PiBUaGFua3MgYW5kIEJlc3QgcmVnYXJkcywNCj4+IA0KPj4gLVByYXNoYW50DQo+IA0K
PiAtLS0tLS1QbGVhc2UgY29uc2lkZXIgdGhlIGVudmlyb25tZW50IGJlZm9yZSBwcmludGluZyB0
aGlzIGUtbWFpbC4NCg==
