Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87611BF2C5
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 14:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726073AbfIZMR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 08:17:58 -0400
Received: from smtp-fw-6002.amazon.com ([52.95.49.90]:16532 "EHLO
        smtp-fw-6002.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725768AbfIZMR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 08:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1569500276; x=1601036276;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=My9iW0ZYZXMJ01JS7LXIoYyI2Pxn/CJO9L+IqUSg2aY=;
  b=gcSB2dB3rM/7rHcTGHUuJN6DYFdUSLe9mdUwRu/aBiupgmzxXIvbFe4y
   SDQbPyvzFrXzsN90eEYAAa5TG7xSk5sUcQ+7TaOwNwDhudqkZ+G6YJ4wY
   ORxcmAHSuVk65EWWpZQWrmMRa3hW9tYmSRZFdjBoyJFnTtpWI7uORydU3
   Y=;
X-IronPort-AV: E=Sophos;i="5.64,551,1559520000"; 
   d="scan'208";a="423773963"
Received: from iad6-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-1e-a70de69e.us-east-1.amazon.com) ([10.124.125.6])
  by smtp-border-fw-out-6002.iad6.amazon.com with ESMTP; 26 Sep 2019 12:17:54 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad55-ws-svc-p15-lb9-vlan2.iad.amazon.com [10.40.159.162])
        by email-inbound-relay-1e-a70de69e.us-east-1.amazon.com (Postfix) with ESMTPS id C9A7AA2461;
        Thu, 26 Sep 2019 12:17:53 +0000 (UTC)
Received: from EX13D10EUA001.ant.amazon.com (10.43.165.242) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 26 Sep 2019 12:17:52 +0000
Received: from EX13D22EUA004.ant.amazon.com (10.43.165.129) by
 EX13D10EUA001.ant.amazon.com (10.43.165.242) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Thu, 26 Sep 2019 12:17:51 +0000
Received: from EX13D22EUA004.ant.amazon.com ([10.43.165.129]) by
 EX13D22EUA004.ant.amazon.com ([10.43.165.129]) with mapi id 15.00.1367.000;
 Thu, 26 Sep 2019 12:17:51 +0000
From:   "Kiyanovski, Arthur" <akiyano@amazon.com>
To:     Colin King <colin.king@canonical.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jubran, Samih" <sameehj@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: ena: clean up indentation issue
Thread-Topic: [PATCH] net: ena: clean up indentation issue
Thread-Index: AQHVdFzcGzusACwMIUKNmXCucf2dHqc93yZA
Date:   Thu, 26 Sep 2019 12:17:22 +0000
Deferred-Delivery: Thu, 26 Sep 2019 12:16:52 +0000
Message-ID: <4ed1ded9cc7f40e496f02007e05b61eb@EX13D22EUA004.ant.amazon.com>
References: <20190926112252.21498-1-colin.king@canonical.com>
In-Reply-To: <20190926112252.21498-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.48]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xpbiBLaW5nIDxjb2xpbi5r
aW5nQGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFRodXJzZGF5LCBTZXB0ZW1iZXIgMjYsIDIwMTkg
MjoyMyBQTQ0KPiBUbzogQmVsZ2F6YWwsIE5ldGFuZWwgPG5ldGFuZWxAYW1hem9uLmNvbT47IEJz
aGFyYSwgU2FlZWQNCj4gPHNhZWVkYkBhbWF6b24uY29tPjsgTWFjaHVsc2t5LCBab3JpayA8em9y
aWtAYW1hem9uLmNvbT47IERhdmlkIFMgLg0KPiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+
OyBLaXlhbm92c2tpLCBBcnRodXIgPGFraXlhbm9AYW1hem9uLmNvbT47DQo+IEp1YnJhbiwgU2Ft
aWggPHNhbWVlaGpAYW1hem9uLmNvbT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtl
cm5lbC1qYW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmcNCj4gU3ViamVjdDogW1BBVENIXSBuZXQ6IGVuYTogY2xlYW4gdXAgaW5kZW50YXRpb24gaXNz
dWUNCj4gDQo+IEZyb206IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+
DQo+IA0KPiBUaGVyZSBtZW1zZXQgaXMgaW5kZW50ZWQgaW5jb3JyZWN0bHksIHJlbW92ZSB0aGUg
ZXh0cmFuZW91cyB0YWJzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNv
bGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9h
bWF6b24vZW5hL2VuYV9ldGhfY29tLmMgfCA0ICsrLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAyIGlu
c2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9lbmFfZXRoX2NvbS5jDQo+IGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvYW1hem9uL2VuYS9lbmFfZXRoX2NvbS5jDQo+IGluZGV4IDM4MDQ2YmYwZmY0NC4uMjg0
NWFjMjc3NzI0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5h
L2VuYV9ldGhfY29tLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvYW1hem9uL2VuYS9l
bmFfZXRoX2NvbS5jDQo+IEBAIC0yMTEsOCArMjExLDggQEAgc3RhdGljIGludCBlbmFfY29tX3Nx
X3VwZGF0ZV9sbHFfdGFpbChzdHJ1Y3QNCj4gZW5hX2NvbV9pb19zcSAqaW9fc3EpDQo+IA0KPiAg
CQlwa3RfY3RybC0+Y3Vycl9ib3VuY2VfYnVmID0NCj4gIAkJCWVuYV9jb21fZ2V0X25leHRfYm91
bmNlX2J1ZmZlcigmaW9fc3EtDQo+ID5ib3VuY2VfYnVmX2N0cmwpOw0KPiAtCQkJbWVtc2V0KGlv
X3NxLT5sbHFfYnVmX2N0cmwuY3Vycl9ib3VuY2VfYnVmLA0KPiAtCQkJICAgICAgIDB4MCwgbGxx
X2luZm8tPmRlc2NfbGlzdF9lbnRyeV9zaXplKTsNCj4gKwkJbWVtc2V0KGlvX3NxLT5sbHFfYnVm
X2N0cmwuY3Vycl9ib3VuY2VfYnVmLA0KPiArCQkgICAgICAgMHgwLCBsbHFfaW5mby0+ZGVzY19s
aXN0X2VudHJ5X3NpemUpOw0KPiANCj4gIAkJcGt0X2N0cmwtPmlkeCA9IDA7DQo+ICAJCWlmICh1
bmxpa2VseShsbHFfaW5mby0+ZGVzY19zdHJpZGVfY3RybCA9PQ0KPiBFTkFfQURNSU5fU0lOR0xF
X0RFU0NfUEVSX0VOVFJZKSkNCj4gLS0NCj4gMi4yMC4xDQoNCkxHVE0gVGhhbmtzISANCg==
