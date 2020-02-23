Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B524C1696CB
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 09:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgBWISx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 03:18:53 -0500
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:47801 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725980AbgBWISx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Feb 2020 03:18:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1582445933; x=1613981933;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lJpZC5KAlrc4p42H46vyeZRIHSsfwTTCCbgXBQtq3zc=;
  b=dN8jZcoeUzWSeVCchC5ZVatLAhpCbhj+U2Y+/uydFdcid5d34cFhswjs
   AYSpjeMorTDbKTKGiyYtXnitRHo8uLlk9ILN+PGvVBvhzClOP6PZigXVw
   FbDozNMuNij7SIkzAaNVS6ZlaIkdCfPiYLH/Fb928yf2/8IaKzqsvEhDm
   I=;
IronPort-SDR: 45bi3yPsTHE2T47scwqq36EDV/qoBzhf0NvDWHNacA7cqqAW5I8icyK+mPCCX8zCNUpucdnMjE
 F+E7wzeTX8ZQ==
X-IronPort-AV: E=Sophos;i="5.70,475,1574121600"; 
   d="scan'208";a="18174763"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 23 Feb 2020 08:18:40 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan2.pdx.amazon.com [10.170.41.162])
        by email-inbound-relay-2a-6e2fc477.us-west-2.amazon.com (Postfix) with ESMTPS id D615FA220B;
        Sun, 23 Feb 2020 08:18:38 +0000 (UTC)
Received: from EX13D08EUB003.ant.amazon.com (10.43.166.117) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1236.3; Sun, 23 Feb 2020 08:18:38 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D08EUB003.ant.amazon.com (10.43.166.117) with Microsoft SMTP Server (TLS)
 id 15.0.1367.3; Sun, 23 Feb 2020 08:18:37 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1367.000;
 Sun, 23 Feb 2020 08:18:37 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Colin King <colin.king@canonical.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: ena: ethtool: remove redundant non-zero check on rc
Thread-Topic: [PATCH] net: ena: ethtool: remove redundant non-zero check on rc
Thread-Index: AQHV6Q6eGTNDoYnNxkWpPBJDZgkWjKgob4sQ
Date:   Sun, 23 Feb 2020 08:18:13 +0000
Deferred-Delivery: Sun, 23 Feb 2020 08:17:16 +0000
Message-ID: <0e46020a1433409a8daccb829902280b@EX13D11EUB003.ant.amazon.com>
References: <20200221232653.33134-1-colin.king@canonical.com>
In-Reply-To: <20200221232653.33134-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.165.118]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWNrLCBUaGFua3MNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDb2xp
biBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IFNlbnQ6IFNhdHVyZGF5LCBGZWJy
dWFyeSAyMiwgMjAyMCAxOjI3IEFNDQo+IFRvOiBCZWxnYXphbCwgTmV0YW5lbCA8bmV0YW5lbEBh
bWF6b24uY29tPjsgS2l5YW5vdnNraSwgQXJ0aHVyDQo+IDxha2l5YW5vQGFtYXpvbi5jb20+OyBU
emFsaWssIEd1eSA8Z3R6YWxpa0BhbWF6b24uY29tPjsgQnNoYXJhLCBTYWVlZA0KPiA8c2FlZWRi
QGFtYXpvbi5jb20+OyBNYWNodWxza3ksIFpvcmlrIDx6b3Jpa0BhbWF6b24uY29tPjsgRGF2aWQg
UyAuDQo+IE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEp1YnJhbiwgU2FtaWggPHNhbWVl
aGpAYW1hem9uLmNvbT47DQo+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1q
YW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4g
U3ViamVjdDogW1BBVENIXSBuZXQ6IGVuYTogZXRodG9vbDogcmVtb3ZlIHJlZHVuZGFudCBub24t
emVybyBjaGVjayBvbiByYw0KPiANCj4gRnJvbTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdA
Y2Fub25pY2FsLmNvbT4NCj4gDQo+IFRoZSBub24temVybyBjaGVjayBvbiByYyBpcyByZWR1bmRh
bnQgYXMgYSBwcmV2aW91cyBub24temVybyBjaGVjayBvbiByYyB3aWxsDQo+IGFsd2F5cyByZXR1
cm4gYW5kIHRoZSBzZWNvbmQgY2hlY2sgaXMgbmV2ZXIgcmVhY2hlZCwgaGVuY2UgaXQgaXMgcmVk
dW5kYW50DQo+IGFuZCBjYW4gYmUgcmVtb3ZlZC4gIEFsc28gcmVtb3ZlIGEgYmxhbmsgbGluZS4N
Cj4gDQo+IEFkZHJlc3Nlcy1Db3Zlcml0eTogKCJMb2dpY2FsbHkgZGVhZCBjb2RlIikNCj4gU2ln
bmVkLW9mZi1ieTogQ29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4g
LS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9hbWF6b24vZW5hL2VuYV9ldGh0b29sLmMgfCA0
IC0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX2V0aHRvb2wuYw0KPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L2FtYXpvbi9lbmEvZW5hX2V0aHRvb2wuYw0KPiBpbmRleCBjZWQx
ZDU3N2I2MmEuLjFlMzg5MzAzNTNmMiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvYW1hem9uL2VuYS9lbmFfZXRodG9vbC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L2FtYXpvbi9lbmEvZW5hX2V0aHRvb2wuYw0KPiBAQCAtNjc0LDcgKzY3NCw2IEBAIHN0YXRpYyBp
bnQgZW5hX2dldF9yeGZoKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRkZXYsDQo+IHUzMiAqaW5kaXIs
IHU4ICprZXksDQo+ICAJICogc3VwcG9ydHMgZ2V0dGluZy9zZXR0aW5nIHRoZSBoYXNoIGZ1bmN0
aW9uLg0KPiAgCSAqLw0KPiAgCXJjID0gZW5hX2NvbV9nZXRfaGFzaF9mdW5jdGlvbihhZGFwdGVy
LT5lbmFfZGV2LCAmZW5hX2Z1bmMsDQo+IGtleSk7DQo+IC0NCj4gIAlpZiAocmMpIHsNCj4gIAkJ
aWYgKHJjID09IC1FT1BOT1RTVVBQKSB7DQo+ICAJCQlrZXkgPSBOVUxMOw0KPiBAQCAtNjg1LDkg
KzY4NCw2IEBAIHN0YXRpYyBpbnQgZW5hX2dldF9yeGZoKHN0cnVjdCBuZXRfZGV2aWNlICpuZXRk
ZXYsDQo+IHUzMiAqaW5kaXIsIHU4ICprZXksDQo+ICAJCXJldHVybiByYzsNCj4gIAl9DQo+IA0K
PiAtCWlmIChyYykNCj4gLQkJcmV0dXJuIHJjOw0KPiAtDQo+ICAJc3dpdGNoIChlbmFfZnVuYykg
ew0KPiAgCWNhc2UgRU5BX0FETUlOX1RPRVBMSVRaOg0KPiAgCQlmdW5jID0gRVRIX1JTU19IQVNI
X1RPUDsNCj4gLS0NCj4gMi4yNS4wDQoNCg==
