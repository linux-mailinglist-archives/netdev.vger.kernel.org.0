Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 574412CD966
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 15:40:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730966AbgLCOj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 09:39:29 -0500
Received: from smtp-fw-6001.amazon.com ([52.95.48.154]:24334 "EHLO
        smtp-fw-6001.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730963AbgLCOj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 09:39:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1607006366; x=1638542366;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=C0k9iQJQH820O/EgTb3lOyGPgYE3NgLN8VSQWf46MHs=;
  b=kn6Eg19WYym7vRm/LSBtBOOEev3ufG2LNyUukZxuFCeYF+DozEBF4jA2
   rnLvr4AciHm4wBUxVp+8NZp585gEMJDTzR0r61fJ7bShuMguaFs++TbTz
   UAvfpL+rzsXvnhJctS9LPIzWstw2eDUCoFAL8KSWO0/0DIkslIrBAjCrX
   k=;
X-IronPort-AV: E=Sophos;i="5.78,389,1599523200"; 
   d="scan'208";a="70349841"
Subject: RE: [PATCH V3 net-next 1/9] net: ena: use constant value for net_device
 allocation
Thread-Topic: [PATCH V3 net-next 1/9] net: ena: use constant value for net_device
 allocation
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-6001.iad6.amazon.com with ESMTP; 03 Dec 2020 14:38:38 +0000
Received: from EX13D10EUA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-1d-474bcd9f.us-east-1.amazon.com (Postfix) with ESMTPS id A01C0A2113;
        Thu,  3 Dec 2020 14:38:36 +0000 (UTC)
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D10EUA001.ant.amazon.com (10.43.165.146) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Thu, 3 Dec 2020 14:38:35 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1497.006;
 Thu, 3 Dec 2020 14:38:35 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Woodhouse, David" <dwmw@amazon.co.uk>,
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
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Jubran, Samih" <sameehj@amazon.com>
Thread-Index: AQHWyOY7W5up3AKuN0yNOHumslDLmKnkWc6AgAEWr1A=
Date:   Thu, 3 Dec 2020 14:38:16 +0000
Deferred-Delivery: Thu, 3 Dec 2020 14:37:43 +0000
Message-ID: <fa4653d9d4d54f9d8ffc982fb809b618@EX13D22EUA004.ant.amazon.com>
References: <1606939410-26718-1-git-send-email-akiyano@amazon.com>
 <1606939410-26718-2-git-send-email-akiyano@amazon.com>
 <10a1c719-1408-5305-38fd-254213f8a42b@gmail.com>
In-Reply-To: <10a1c719-1408-5305-38fd-254213f8a42b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.16]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0
IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBEZWNlbWJlciAyLCAy
MDIwIDExOjU1IFBNDQo+IFRvOiBLaXlhbm92c2tpLCBBcnRodXIgPGFraXlhbm9AYW1hem9uLmNv
bT47IGt1YmFAa2VybmVsLm9yZzsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogV29v
ZGhvdXNlLCBEYXZpZCA8ZHdtd0BhbWF6b24uY28udWs+OyBNYWNodWxza3ksIFpvcmlrDQo+IDx6
b3Jpa0BhbWF6b24uY29tPjsgTWF0dXNoZXZza3ksIEFsZXhhbmRlciA8bWF0dWFAYW1hem9uLmNv
bT47DQo+IEJzaGFyYSwgU2FlZWQgPHNhZWVkYkBhbWF6b24uY29tPjsgV2lsc29uLCBNYXR0IDxt
c3dAYW1hem9uLmNvbT47DQo+IExpZ3VvcmksIEFudGhvbnkgPGFsaWd1b3JpQGFtYXpvbi5jb20+
OyBCc2hhcmEsIE5hZmVhDQo+IDxuYWZlYUBhbWF6b24uY29tPjsgVHphbGlrLCBHdXkgPGd0emFs
aWtAYW1hem9uLmNvbT47IEJlbGdhemFsLA0KPiBOZXRhbmVsIDxuZXRhbmVsQGFtYXpvbi5jb20+
OyBTYWlkaSwgQWxpIDxhbGlzYWlkaUBhbWF6b24uY29tPjsNCj4gSGVycmVuc2NobWlkdCwgQmVu
amFtaW4gPGJlbmhAYW1hem9uLmNvbT47IERhZ2FuLCBOb2FtDQo+IDxuZGFnYW5AYW1hem9uLmNv
bT47IEFncm9za2luLCBTaGF5IDxzaGF5YWdyQGFtYXpvbi5jb20+OyBKdWJyYW4sDQo+IFNhbWlo
IDxzYW1lZWhqQGFtYXpvbi5jb20+DQo+IFN1YmplY3Q6IFJFOiBbRVhURVJOQUxdIFtQQVRDSCBW
MyBuZXQtbmV4dCAxLzldIG5ldDogZW5hOiB1c2UgY29uc3RhbnQNCj4gdmFsdWUgZm9yIG5ldF9k
ZXZpY2UgYWxsb2NhdGlvbg0KPiANCj4gQ0FVVElPTjogVGhpcyBlbWFpbCBvcmlnaW5hdGVkIGZy
b20gb3V0c2lkZSBvZiB0aGUgb3JnYW5pemF0aW9uLiBEbyBub3QgY2xpY2sNCj4gbGlua3Mgb3Ig
b3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91IGNhbiBjb25maXJtIHRoZSBzZW5kZXIgYW5kIGtu
b3cgdGhlDQo+IGNvbnRlbnQgaXMgc2FmZS4NCj4gDQo+IA0KPiANCj4gQW0gMDIuMTIuMjAyMCB1
bSAyMTowMyBzY2hyaWViIGFraXlhbm9AYW1hem9uLmNvbToNCj4gPiBGcm9tOiBBcnRodXIgS2l5
YW5vdnNraSA8YWtpeWFub0BhbWF6b24uY29tPg0KPiA+DQo+ID4gVGhlIHBhdGNoIGNoYW5nZXMg
dGhlIG1heGltdW0gbnVtYmVyIG9mIFJYL1RYIHF1ZXVlcyBpdCBhZHZlcnRpc2VzIHRvDQo+ID4g
dGhlIGtlcm5lbCAodmlhIGFsbG9jX2V0aGVyZGV2X21xKCkpIGZyb20gYSB2YWx1ZSByZWNlaXZl
ZCBmcm9tIHRoZQ0KPiA+IGRldmljZSB0byBhIGNvbnN0YW50IHZhbHVlIHdoaWNoIGlzIHRoZSBt
aW5pbXVtIGJldHdlZW4gMTI4IGFuZCB0aGUNCj4gPiBudW1iZXIgb2YgQ1BVcyBpbiB0aGUgc3lz
dGVtLg0KPiA+DQo+ID4gQnkgYWxsb2NhdGluZyB0aGUgbmV0X2RldmljZSBzdHJ1Y3Qgd2l0aCBh
IGNvbnN0YW50IG51bWJlciBvZiBxdWV1ZXMsDQo+ID4gdGhlIGRyaXZlciBpcyBhYmxlIHRvIGFs
bG9jYXRlIGl0IGF0IGEgbXVjaCBlYXJsaWVyIHN0YWdlLCBiZWZvcmUNCj4gPiBjYWxsaW5nIGFu
eSBlbmFfY29tIGZ1bmN0aW9ucy4gVGhpcyB3b3VsZCBhbGxvdyB0byBtYWtlIGFsbCBsb2cgcHJp
bnRzDQo+ID4gaW4gZW5hX2NvbSB0byB1c2UgbmV0ZGV2XyogbG9nIGZ1bmN0aW9ucyBpbnN0ZWFk
IG9yIGN1cnJlbnQgcHJfKiBvbmVzLg0KPiA+DQo+IA0KPiBEaWQgeW91IHRlc3QgdGhpcz8gVXN1
YWxseSB1c2luZyBuZXRkZXZfKiBiZWZvcmUgdGhlIG5ldF9kZXZpY2UgaXMgcmVnaXN0ZXJlZA0K
PiByZXN1bHRzIGluIHF1aXRlIHVnbHkgbWVzc2FnZXMuIFRoZXJlZm9yZSB0aGVyZSdzIGEgbnVt
YmVyIG9mIHBhdGNoZXMgZG9pbmcNCj4gdGhlIG9wcG9zaXRlLCByZXBsYWNpbmcgbmV0ZGV2Xyog
d2l0aCBkZXZfKiBiZWZvcmUgcmVnaXN0ZXJfbmV0ZGV2KCkuIFNlZQ0KPiBlLmcuDQo+IDIyMTQ4
ZGYwZDBiZCAoInI4MTY5OiBkb24ndCB1c2UgbmV0aWZfaW5mbyBldCBhbCBiZWZvcmUgbmV0X2Rl
dmljZSBoYXMgYmVlbg0KPiByZWdpc3RlcmVkIikNCg0KVGhhbmtzIGZvciB5b3VyIGNvbW1lbnQu
DQpZZXMgd2UgZGlkIHRlc3QgaXQuDQpQbGVhc2Ugc2VlIHRoZSBkaXNjdXNzaW9uIHdoaWNoIGxl
ZCB0byB0aGlzIHBhdGNoIGluIGEgcHJldmlvdXMgdGhyZWFkIGhlcmU6DQpodHRwczovL3d3dy5t
YWlsLWFyY2hpdmUuY29tL25ldGRldkB2Z2VyLmtlcm5lbC5vcmcvbXNnMzUzNTkwLmh0bWwNCiAN
Cj4gPiBTaWduZWQtb2ZmLWJ5OiBTaGF5IEFncm9za2luIDxzaGF5YWdyQGFtYXpvbi5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogQXJ0aHVyIEtpeWFub3Zza2kgPGFraXlhbm9AYW1hem9uLmNvbT4N
Cj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2
LmMgfCA0Ng0KPiA+ICsrKysrKysrKystLS0tLS0tLS0tDQo+ID4gIDEgZmlsZSBjaGFuZ2VkLCAy
MyBpbnNlcnRpb25zKCspLCAyMyBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9uZXRkZXYuYw0KPiA+IGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfbmV0ZGV2LmMNCj4gPiBpbmRleCBkZjE4ODRk
NTdkMWEuLjk4NWRlYTE4NzBiNSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9hbWF6b24vZW5hL2VuYV9uZXRkZXYuYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2FtYXpvbi9lbmEvZW5hX25ldGRldi5jDQo+ID4gQEAgLTI5LDYgKzI5LDggQEAgTU9EVUxFX0xJ
Q0VOU0UoIkdQTCIpOw0KPiA+ICAvKiBUaW1lIGluIGppZmZpZXMgYmVmb3JlIGNvbmNsdWRpbmcg
dGhlIHRyYW5zbWl0dGVyIGlzIGh1bmcuICovDQo+ID4gI2RlZmluZSBUWF9USU1FT1VUICAoNSAq
IEhaKQ0KPiA+DQo+ID4gKyNkZWZpbmUgRU5BX01BWF9SSU5HUyBtaW5fdCh1bnNpZ25lZCBpbnQs
DQo+IEVOQV9NQVhfTlVNX0lPX1FVRVVFUywNCj4gPiArbnVtX3Bvc3NpYmxlX2NwdXMoKSkNCj4g
PiArDQo+ID4gICNkZWZpbmUgRU5BX05BUElfQlVER0VUIDY0DQo+ID4NCj4gPiAgI2RlZmluZSBE
RUZBVUxUX01TR19FTkFCTEUgKE5FVElGX01TR19EUlYgfCBORVRJRl9NU0dfUFJPQkUNCj4gfA0K
PiA+IE5FVElGX01TR19JRlVQIHwgXCBAQCAtNDE3NiwxOCArNDE3OCwzNCBAQCBzdGF0aWMgaW50
DQo+IGVuYV9wcm9iZShzdHJ1Y3QNCj4gPiBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNp
X2RldmljZV9pZCAqZW50KQ0KPiA+DQo+ID4gICAgICAgZW5hX2Rldi0+ZG1hZGV2ID0gJnBkZXYt
PmRldjsNCj4gPg0KPiA+ICsgICAgIG5ldGRldiA9IGFsbG9jX2V0aGVyZGV2X21xKHNpemVvZihz
dHJ1Y3QgZW5hX2FkYXB0ZXIpLA0KPiBFTkFfTUFYX1JJTkdTKTsNCj4gPiArICAgICBpZiAoIW5l
dGRldikgew0KPiA+ICsgICAgICAgICAgICAgZGV2X2VycigmcGRldi0+ZGV2LCAiYWxsb2NfZXRo
ZXJkZXZfbXEgZmFpbGVkXG4iKTsNCj4gPiArICAgICAgICAgICAgIHJjID0gLUVOT01FTTsNCj4g
PiArICAgICAgICAgICAgIGdvdG8gZXJyX2ZyZWVfcmVnaW9uOw0KPiA+ICsgICAgIH0NCj4gPiAr
DQo+ID4gKyAgICAgU0VUX05FVERFVl9ERVYobmV0ZGV2LCAmcGRldi0+ZGV2KTsNCj4gPiArICAg
ICBhZGFwdGVyID0gbmV0ZGV2X3ByaXYobmV0ZGV2KTsNCj4gPiArICAgICBhZGFwdGVyLT5lbmFf
ZGV2ID0gZW5hX2RldjsNCj4gPiArICAgICBhZGFwdGVyLT5uZXRkZXYgPSBuZXRkZXY7DQo+ID4g
KyAgICAgYWRhcHRlci0+cGRldiA9IHBkZXY7DQo+ID4gKyAgICAgYWRhcHRlci0+bXNnX2VuYWJs
ZSA9IG5ldGlmX21zZ19pbml0KGRlYnVnLA0KPiBERUZBVUxUX01TR19FTkFCTEUpOw0KPiA+ICsN
Cj4gPiArICAgICBwY2lfc2V0X2RydmRhdGEocGRldiwgYWRhcHRlcik7DQo+ID4gKw0KPiA+ICAg
ICAgIHJjID0gZW5hX2RldmljZV9pbml0KGVuYV9kZXYsIHBkZXYsICZnZXRfZmVhdF9jdHgsICZ3
ZF9zdGF0ZSk7DQo+ID4gICAgICAgaWYgKHJjKSB7DQo+ID4gICAgICAgICAgICAgICBkZXZfZXJy
KCZwZGV2LT5kZXYsICJFTkEgZGV2aWNlIGluaXQgZmFpbGVkXG4iKTsNCj4gPiAgICAgICAgICAg
ICAgIGlmIChyYyA9PSAtRVRJTUUpDQo+ID4gICAgICAgICAgICAgICAgICAgICAgIHJjID0gLUVQ
Uk9CRV9ERUZFUjsNCj4gPiAtICAgICAgICAgICAgIGdvdG8gZXJyX2ZyZWVfcmVnaW9uOw0KPiA+
ICsgICAgICAgICAgICAgZ290byBlcnJfbmV0ZGV2X2Rlc3Ryb3k7DQo+ID4gICAgICAgfQ0KPiA+
DQo+ID4gICAgICAgcmMgPSBlbmFfbWFwX2xscV9tZW1fYmFyKHBkZXYsIGVuYV9kZXYsIGJhcnMp
Ow0KPiA+ICAgICAgIGlmIChyYykgew0KPiA+ICAgICAgICAgICAgICAgZGV2X2VycigmcGRldi0+
ZGV2LCAiRU5BIGxscSBiYXIgbWFwcGluZyBmYWlsZWRcbiIpOw0KPiA+IC0gICAgICAgICAgICAg
Z290byBlcnJfZnJlZV9lbmFfZGV2Ow0KPiA+ICsgICAgICAgICAgICAgZ290byBlcnJfZGV2aWNl
X2Rlc3Ryb3k7DQo+ID4gICAgICAgfQ0KPiA+DQo+ID4gICAgICAgY2FsY19xdWV1ZV9jdHguZW5h
X2RldiA9IGVuYV9kZXY7IEBAIC00MjA3LDI2ICs0MjI1LDggQEAgc3RhdGljDQo+ID4gaW50IGVu
YV9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGRldiwgY29uc3Qgc3RydWN0IHBjaV9kZXZpY2VfaWQg
KmVudCkNCj4gPiAgICAgICAgICAgICAgIGdvdG8gZXJyX2RldmljZV9kZXN0cm95Ow0KPiA+ICAg
ICAgIH0NCj4gPg0KPiA+IC0gICAgIC8qIGRldiB6ZXJvZWQgaW4gaW5pdF9ldGhlcmRldiAqLw0K
PiA+IC0gICAgIG5ldGRldiA9IGFsbG9jX2V0aGVyZGV2X21xKHNpemVvZihzdHJ1Y3QgZW5hX2Fk
YXB0ZXIpLA0KPiBtYXhfbnVtX2lvX3F1ZXVlcyk7DQo+ID4gLSAgICAgaWYgKCFuZXRkZXYpIHsN
Cj4gPiAtICAgICAgICAgICAgIGRldl9lcnIoJnBkZXYtPmRldiwgImFsbG9jX2V0aGVyZGV2X21x
IGZhaWxlZFxuIik7DQo+ID4gLSAgICAgICAgICAgICByYyA9IC1FTk9NRU07DQo+ID4gLSAgICAg
ICAgICAgICBnb3RvIGVycl9kZXZpY2VfZGVzdHJveTsNCj4gPiAtICAgICB9DQo+ID4gLQ0KPiA+
IC0gICAgIFNFVF9ORVRERVZfREVWKG5ldGRldiwgJnBkZXYtPmRldik7DQo+ID4gLQ0KPiA+IC0g
ICAgIGFkYXB0ZXIgPSBuZXRkZXZfcHJpdihuZXRkZXYpOw0KPiA+IC0gICAgIHBjaV9zZXRfZHJ2
ZGF0YShwZGV2LCBhZGFwdGVyKTsNCj4gPiAtDQo+ID4gLSAgICAgYWRhcHRlci0+ZW5hX2RldiA9
IGVuYV9kZXY7DQo+ID4gLSAgICAgYWRhcHRlci0+bmV0ZGV2ID0gbmV0ZGV2Ow0KPiA+IC0gICAg
IGFkYXB0ZXItPnBkZXYgPSBwZGV2Ow0KPiA+IC0NCj4gPiAgICAgICBlbmFfc2V0X2NvbmZfZmVh
dF9wYXJhbXMoYWRhcHRlciwgJmdldF9mZWF0X2N0eCk7DQo+ID4NCj4gPiAtICAgICBhZGFwdGVy
LT5tc2dfZW5hYmxlID0gbmV0aWZfbXNnX2luaXQoZGVidWcsDQo+IERFRkFVTFRfTVNHX0VOQUJM
RSk7DQo+ID4gICAgICAgYWRhcHRlci0+cmVzZXRfcmVhc29uID0gRU5BX1JFR1NfUkVTRVRfTk9S
TUFMOw0KPiA+DQo+ID4gICAgICAgYWRhcHRlci0+cmVxdWVzdGVkX3R4X3Jpbmdfc2l6ZSA9IGNh
bGNfcXVldWVfY3R4LnR4X3F1ZXVlX3NpemU7DQo+ID4gQEAgLTQyNTcsNyArNDI1Nyw3IEBAIHN0
YXRpYyBpbnQgZW5hX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdA0KPiBzdHJ1Y3Qg
cGNpX2RldmljZV9pZCAqZW50KQ0KPiA+ICAgICAgIGlmIChyYykgew0KPiA+ICAgICAgICAgICAg
ICAgZGV2X2VycigmcGRldi0+ZGV2LA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAiRmFpbGVk
IHRvIHF1ZXJ5IGludGVycnVwdCBtb2RlcmF0aW9uIGZlYXR1cmVcbiIpOw0KPiA+IC0gICAgICAg
ICAgICAgZ290byBlcnJfbmV0ZGV2X2Rlc3Ryb3k7DQo+ID4gKyAgICAgICAgICAgICBnb3RvIGVy
cl9kZXZpY2VfZGVzdHJveTsNCj4gPiAgICAgICB9DQo+ID4gICAgICAgZW5hX2luaXRfaW9fcmlu
Z3MoYWRhcHRlciwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAwLA0KPiA+IEBAIC00MzM1
LDExICs0MzM1LDExIEBAIHN0YXRpYyBpbnQgZW5hX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2
LA0KPiBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqZW50KQ0KPiA+ICAgICAgIGVuYV9kaXNh
YmxlX21zaXgoYWRhcHRlcik7DQo+ID4gIGVycl93b3JrZXJfZGVzdHJveToNCj4gPiAgICAgICBk
ZWxfdGltZXIoJmFkYXB0ZXItPnRpbWVyX3NlcnZpY2UpOw0KPiA+IC1lcnJfbmV0ZGV2X2Rlc3Ry
b3k6DQo+ID4gLSAgICAgZnJlZV9uZXRkZXYobmV0ZGV2KTsNCj4gPiAgZXJyX2RldmljZV9kZXN0
cm95Og0KPiA+ICAgICAgIGVuYV9jb21fZGVsZXRlX2hvc3RfaW5mbyhlbmFfZGV2KTsNCj4gPiAg
ICAgICBlbmFfY29tX2FkbWluX2Rlc3Ryb3koZW5hX2Rldik7DQo+ID4gK2Vycl9uZXRkZXZfZGVz
dHJveToNCj4gPiArICAgICBmcmVlX25ldGRldihuZXRkZXYpOw0KPiA+ICBlcnJfZnJlZV9yZWdp
b246DQo+ID4gICAgICAgZW5hX3JlbGVhc2VfYmFycyhlbmFfZGV2LCBwZGV2KTsNCj4gPiAgZXJy
X2ZyZWVfZW5hX2RldjoNCj4gPg0KDQo=
