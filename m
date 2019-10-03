Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51F4CCA129
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 17:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729655AbfJCPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 11:32:39 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:37797 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729408AbfJCPcj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 11:32:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1570116756; x=1601652756;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fAbd/DnYtQSlfW8Td/0sSlSY7VkggGh1Epv9GStwRiU=;
  b=OluYA9fb2q/Y0vsebYtG3N5VXbc44jIL1N03AAGhWJ4XXkID3VBf7wXH
   bZz7rPsDiuXyUN3vlk7+J2MW2Qgstu7KHCPH9DN5qdrTPNl9mygIbRHpj
   8qLTnuNm2Q3C5Crr7BH9mWynfoWjDTClQFJ+GpPBs9vyrxPW5wnobh0XK
   8=;
X-IronPort-AV: E=Sophos;i="5.67,252,1566864000"; 
   d="scan'208";a="755243971"
Received: from iad6-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.124.125.2])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 03 Oct 2019 15:32:35 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id B3B6BA2138;
        Thu,  3 Oct 2019 15:32:34 +0000 (UTC)
Received: from EX13D22EUB003.ant.amazon.com (10.43.166.142) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 3 Oct 2019 15:32:34 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D22EUB003.ant.amazon.com (10.43.166.142) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 3 Oct 2019 15:32:33 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Thu, 3 Oct 2019 15:32:33 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.co.uk>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>
Subject: RE: [PATCH V2 net-next 5/5] net: ena: ethtool: support set_channels
 callback
Thread-Topic: [PATCH V2 net-next 5/5] net: ena: ethtool: support set_channels
 callback
Thread-Index: AQHVePpcG3wEsSfMqUeoRjdXEQdnnadHyTUAgAFDpUA=
Date:   Thu, 3 Oct 2019 15:32:33 +0000
Message-ID: <577acdeedc7a4db6a28b5e8350e7b88f@EX13D11EUB003.ant.amazon.com>
References: <20191002082052.14051-1-sameehj@amazon.com>
 <20191002082052.14051-6-sameehj@amazon.com>
 <20191002131132.7b81f339@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191002131132.7b81f339@cakuba.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.164.213]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGpha3ViLmtpY2luc2tpQG5ldHJvbm9tZS5jb20+DQo+IFNlbnQ6IFdlZG5lc2RheSwgT2N0b2Jl
ciAyLCAyMDE5IDExOjEyIFBNDQo+IFRvOiBKdWJyYW4sIFNhbWloIDxzYW1lZWhqQGFtYXpvbi5j
b20+DQo+IENjOiBkYXZlbUBkYXZlbWxvZnQubmV0OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBX
b29kaG91c2UsIERhdmlkDQo+IDxkd213QGFtYXpvbi5jby51az47IE1hY2h1bHNreSwgWm9yaWsg
PHpvcmlrQGFtYXpvbi5jb20+Ow0KPiBNYXR1c2hldnNreSwgQWxleGFuZGVyIDxtYXR1YUBhbWF6
b24uY29tPjsgQnNoYXJhLCBTYWVlZA0KPiA8c2FlZWRiQGFtYXpvbi5jb20+OyBXaWxzb24sIE1h
dHQgPG1zd0BhbWF6b24uY29tPjsgTGlndW9yaSwNCj4gQW50aG9ueSA8YWxpZ3VvcmlAYW1hem9u
LmNvbT47IEJzaGFyYSwgTmFmZWEgPG5hZmVhQGFtYXpvbi5jb20+Ow0KPiBUemFsaWssIEd1eSA8
Z3R6YWxpa0BhbWF6b24uY29tPjsgQmVsZ2F6YWwsIE5ldGFuZWwNCj4gPG5ldGFuZWxAYW1hem9u
LmNvbT47IFNhaWRpLCBBbGkgPGFsaXNhaWRpQGFtYXpvbi5jb20+OyBIZXJyZW5zY2htaWR0LA0K
PiBCZW5qYW1pbiA8YmVuaEBhbWF6b24uY29tPjsgS2l5YW5vdnNraSwgQXJ0aHVyDQo+IDxha2l5
YW5vQGFtYXpvbi5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbmV0LW5leHQgNS81XSBu
ZXQ6IGVuYTogZXRodG9vbDogc3VwcG9ydA0KPiBzZXRfY2hhbm5lbHMgY2FsbGJhY2sNCj4gDQo+
IE9uIFdlZCwgMiBPY3QgMjAxOSAxMToyMDo1MiArMDMwMCwgc2FtZWVoakBhbWF6b24uY29tIHdy
b3RlOg0KPiA+IEZyb206IFNhbWVlaCBKdWJyYW4gPHNhbWVlaGpAYW1hem9uLmNvbT4NCj4gPg0K
PiA+IFNldCBjaGFubmVscyBjYWxsYmFjayBlbmFibGVzIHRoZSB1c2VyIHRvIGNoYW5nZSB0aGUg
Y291bnQgb2YgcXVldWVzDQo+ID4gdXNlZCBieSB0aGUgZHJpdmVyIHVzaW5nIGV0aHRvb2wuIFdl
IGRlY2lkZWQgdG8gY3VycmVudGx5IHN1cHBvcnQgb25seQ0KPiA+IGVxdWFsIG51bWJlciBvZiBy
eCBhbmQgdHggcXVldWVzLCB0aGlzIG1pZ2h0IGNoYW5nZSBpbiB0aGUgZnV0dXJlLg0KPiA+DQo+
ID4gQWxzbyByZW5hbWUgZGV2X3VwIHRvIGRldl93YXNfdXAgaW4gZW5hX3VwZGF0ZV9xdWV1ZV9j
b3VudCgpIHRvDQo+IG1ha2UNCj4gPiBpdCBjbGVhcmVyLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1i
eTogU2FtZWVoIEp1YnJhbiA8c2FtZWVoakBhbWF6b24uY29tPg0KPiA+IC0tLQ0KPiA+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9ldGh0b29sLmMgfCAxNyArKysrKysrKysr
KysrKw0KPiA+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5jICB8
IDIyDQo+ICsrKysrKysrKysrKysrKystLS0NCj4gPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6
b24vZW5hL2VuYV9uZXRkZXYuaCAgfCAgMyArKysNCj4gPiAgMyBmaWxlcyBjaGFuZ2VkLCAzOSBp
bnNlcnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX2V0aHRvb2wuYw0KPiA+IGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfZXRodG9vbC5jDQo+ID4gaW5kZXggYzlkNzYwNDY1
Li5mNThmYzNjNjggMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9u
L2VuYS9lbmFfZXRodG9vbC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9u
L2VuYS9lbmFfZXRodG9vbC5jDQo+ID4gQEAgLTc0NCw2ICs3NDQsMjIgQEAgc3RhdGljIHZvaWQg
ZW5hX2dldF9jaGFubmVscyhzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmV0ZGV2LA0KPiA+ICAJY2hh
bm5lbHMtPmNvbWJpbmVkX2NvdW50ID0gMDsNCj4gPiAgfQ0KPiA+DQo+ID4gK3N0YXRpYyBpbnQg
ZW5hX3NldF9jaGFubmVscyhzdHJ1Y3QgbmV0X2RldmljZSAqbmV0ZGV2LA0KPiA+ICsJCQkgICAg
c3RydWN0IGV0aHRvb2xfY2hhbm5lbHMgKmNoYW5uZWxzKSB7DQo+ID4gKwlzdHJ1Y3QgZW5hX2Fk
YXB0ZXIgKmFkYXB0ZXIgPSBuZXRkZXZfcHJpdihuZXRkZXYpOw0KPiA+ICsJdTMyIG5ld19jaGFu
bmVsX2NvdW50Ow0KPiA+ICsNCj4gPiArCWlmIChjaGFubmVscy0+cnhfY291bnQgIT0gY2hhbm5l
bHMtPnR4X2NvdW50IHx8DQo+IA0KPiBJZiB5b3UgdXNlIHRoZSBzYW1lIElSUSBhbmQgTkFQSSB0
byBzZXJ2aWNlIFJYIGFuZCBUWCBpdCdzIGEgY29tYmluZWQNCj4gY2hhbm5lbCwgbm90IHJ4IGFu
ZCB0eCBjaGFubmVscy4NCldpbGwgZG8uDQo+IA0KPiA+ICsJICAgIGNoYW5uZWxzLT5tYXhfdHgg
IT0gY2hhbm5lbHMtPm1heF9yeCkNCj4gDQo+IEhtLi4gbWF4ZXMgYXJlIGdlbmVyYWxseSBpZ25v
cmVkIG9uIHNldCDwn6SUDQo+IA0KPiA+ICsJCXJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4gPiAr
CW5ld19jaGFubmVsX2NvdW50ID0gY2xhbXBfdmFsKGNoYW5uZWxzLT50eF9jb3VudCwNCj4gPiAr
CQkJCSAgICAgIEVOQV9NSU5fTlVNX0lPX1FVRVVFUywgY2hhbm5lbHMtDQo+ID5tYXhfdHgpOw0K
PiANCj4gWW91IHNob3VsZCByZXR1cm4gYW4gZXJyb3IgaWYgdGhlIHZhbHVlIGlzIG5vdCB3aXRo
aW4gYm91bmRzLCByYXRoZXIgdGhhbg0KPiBndWVzc2luZy4NCldpbGwgZG8uDQo+IA0KPiA+ICsJ
cmV0dXJuIGVuYV91cGRhdGVfcXVldWVfY291bnQoYWRhcHRlciwgbmV3X2NoYW5uZWxfY291bnQp
OyB9DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGVuYV9nZXRfdHVuYWJsZShzdHJ1Y3QgbmV0X2Rl
dmljZSAqbmV0ZGV2LA0KPiA+ICAJCQkgICBjb25zdCBzdHJ1Y3QgZXRodG9vbF90dW5hYmxlICp0
dW5hLCB2b2lkICpkYXRhKSAgew0KPiBAQCAtODA3LDYNCj4gPiArODIzLDcgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBldGh0b29sX29wcyBlbmFfZXRodG9vbF9vcHMgPSB7DQo+ID4gIAkuZ2V0X3J4
ZmgJCT0gZW5hX2dldF9yeGZoLA0KPiA+ICAJLnNldF9yeGZoCQk9IGVuYV9zZXRfcnhmaCwNCj4g
PiAgCS5nZXRfY2hhbm5lbHMJCT0gZW5hX2dldF9jaGFubmVscywNCj4gPiArCS5zZXRfY2hhbm5l
bHMJCT0gZW5hX3NldF9jaGFubmVscywNCj4gPiAgCS5nZXRfdHVuYWJsZQkJPSBlbmFfZ2V0X3R1
bmFibGUsDQo+ID4gIAkuc2V0X3R1bmFibGUJCT0gZW5hX3NldF90dW5hYmxlLA0KPiA+ICB9Ow0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9uZXRk
ZXYuYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmMN
Cj4gPiBpbmRleCBlOTY0NzgzYzQuLjdkNDRiMzQ0MCAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJz
L25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9uZXRkZXYuYw0KPiA+ICsrKyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX25ldGRldi5jDQo+ID4gQEAgLTIwNDQsMTQgKzIw
NDQsMzAgQEAgaW50IGVuYV91cGRhdGVfcXVldWVfc2l6ZXMoc3RydWN0DQo+IGVuYV9hZGFwdGVy
ICphZGFwdGVyLA0KPiA+ICAJCQkgICB1MzIgbmV3X3R4X3NpemUsDQo+ID4gIAkJCSAgIHUzMiBu
ZXdfcnhfc2l6ZSkNCj4gPiAgew0KPiA+IC0JYm9vbCBkZXZfdXA7DQo+ID4gKwlib29sIGRldl93
YXNfdXA7DQo+ID4NCj4gPiAtCWRldl91cCA9IHRlc3RfYml0KEVOQV9GTEFHX0RFVl9VUCwgJmFk
YXB0ZXItPmZsYWdzKTsNCj4gPiArCWRldl93YXNfdXAgPSB0ZXN0X2JpdChFTkFfRkxBR19ERVZf
VVAsICZhZGFwdGVyLT5mbGFncyk7DQo+ID4gIAllbmFfY2xvc2UoYWRhcHRlci0+bmV0ZGV2KTsN
Cj4gPiAgCWFkYXB0ZXItPnJlcXVlc3RlZF90eF9yaW5nX3NpemUgPSBuZXdfdHhfc2l6ZTsNCj4g
PiAgCWFkYXB0ZXItPnJlcXVlc3RlZF9yeF9yaW5nX3NpemUgPSBuZXdfcnhfc2l6ZTsNCj4gPiAg
CWVuYV9pbml0X2lvX3JpbmdzKGFkYXB0ZXIpOw0KPiA+IC0JcmV0dXJuIGRldl91cCA/IGVuYV91
cChhZGFwdGVyKSA6IDA7DQo+ID4gKwlyZXR1cm4gZGV2X3dhc191cCA/IGVuYV91cChhZGFwdGVy
KSA6IDA7IH0NCj4gPiArDQo+ID4gK2ludCBlbmFfdXBkYXRlX3F1ZXVlX2NvdW50KHN0cnVjdCBl
bmFfYWRhcHRlciAqYWRhcHRlciwgdTMyDQo+ID4gK25ld19jaGFubmVsX2NvdW50KSB7DQo+ID4g
KwlzdHJ1Y3QgZW5hX2NvbV9kZXYgKmVuYV9kZXYgPSBhZGFwdGVyLT5lbmFfZGV2Ow0KPiA+ICsJ
Ym9vbCBkZXZfd2FzX3VwOw0KPiA+ICsNCj4gPiArCWRldl93YXNfdXAgPSB0ZXN0X2JpdChFTkFf
RkxBR19ERVZfVVAsICZhZGFwdGVyLT5mbGFncyk7DQo+ID4gKwllbmFfY2xvc2UoYWRhcHRlci0+
bmV0ZGV2KTsNCj4gPiArCWFkYXB0ZXItPm51bV9pb19xdWV1ZXMgPSBuZXdfY2hhbm5lbF9jb3Vu
dDsNCj4gPiArICAgICAgIC8qIFdlIG5lZWQgdG8gZGVzdHJveSB0aGUgcnNzIHRhYmxlIHNvIHRo
YXQgdGhlIGluZGlyZWN0aW9uDQo+ID4gKwkqIHRhYmxlIHdpbGwgYmUgcmVpbml0aWFsaXplZCBi
eSBlbmFfdXAoKQ0KPiA+ICsJKi8NCj4gPiArCWVuYV9jb21fcnNzX2Rlc3Ryb3koZW5hX2Rldik7
DQo+ID4gKwllbmFfaW5pdF9pb19yaW5ncyhhZGFwdGVyKTsNCj4gPiArCXJldHVybiBkZXZfd2Fz
X3VwID8gZW5hX29wZW4oYWRhcHRlci0+bmV0ZGV2KSA6IDA7DQo+IA0KPiBZb3Ugc2hvdWxkIHRy
eSB0byBwcmVwYXJlIHRoZSByZXNvdXJjZXMgZm9yIHRoZSBuZXcgY29uZmlndXJhdGlvbiBiZWZv
cmUNCj4geW91IGF0dGVtcHQgdGhlIGNoYW5nZS4gT3RoZXJ3aXNlIGlmIGFsbG9jYXRpb24gb2Yg
bmV3IHJpbmdzIGZhaWxzIHRoZSBvcGVuDQo+IHdpbGwgbGVhdmUgdGhlIGRldmljZSBpbiBhIGJy
b2tlbiBzdGF0ZS4NCg0KT3VyIGVuYV91cCgpIGFwcGxpZXMgbG9nYXJpdGhtaWMgYmFja29mZiBt
ZWNoYW5pc20gb24gdGhlIHJpbmdzIHNpemUgaWYNCnRoZSBhbGxvY2F0aW9ucyBmYWlsLCBhbmQg
dGhlcmVmb3JlIHRoZSBkZXZpY2Ugd2lsbCBzdGF5IGZ1bmN0aW9uYWwuDQoNCj4gDQo+IFRoaXMg
aXMgbm90IGFsd2F5cyBlbmZvcmNlZCB1cHN0cmVhbSwgYnV0IHlvdSBjYW4gc2VlIG1seDUgb3Ig
bmZwIGZvcg0KPiBleGFtcGxlcyBvZiBkcml2ZXJzIHdoaWNoIGRvIHRoaXMgcmlnaHQuLg0KPiAN
Cj4gPiAgfQ0KPiA+DQo+ID4gIHN0YXRpYyB2b2lkIGVuYV90eF9jc3VtKHN0cnVjdCBlbmFfY29t
X3R4X2N0eCAqZW5hX3R4X2N0eCwgc3RydWN0DQo+ID4gc2tfYnVmZiAqc2tiKQ0K
