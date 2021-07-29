Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61AB03DA87A
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:07:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233453AbhG2QHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:07:41 -0400
Received: from mailgw02.mediatek.com ([1.203.163.81]:29600 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S233880AbhG2QGM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:06:12 -0400
X-UUID: 36b79c4521e141579b1629a2cd57443d-20210729
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=FmMPo1YNUA+2iUSxBL6ChqAQr9+S6f3vHwPsCvfChoo=;
        b=IPdNOmnVtffvAZPsvYRXBno+LDszfNichAqebQd6xhHt5wjPUQeF7ofMuRkkaJLmL3mmaa23XlV4u8D44MO9A/sZjaWPecFBCEVHnWnUIu0yHLmW2n8J37wBQRGTU36zpNqkLGW/uUKVUrJMfnyMKJ1ebuAYzE23HM9sUutPN14=;
X-UUID: 36b79c4521e141579b1629a2cd57443d-20210729
Received: from mtkcas32.mediatek.inc [(172.27.4.253)] by mailgw02.mediatek.com
        (envelope-from <rocco.yue@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 206471542; Thu, 29 Jul 2021 23:59:18 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 MTKMBS32N2.mediatek.inc (172.27.4.72) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Thu, 29 Jul 2021 23:59:16 +0800
Received: from localhost.localdomain (10.15.20.246) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 29 Jul 2021 23:59:15 +0800
From:   Rocco Yue <rocco.yue@mediatek.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>, <rocco.yue@gmail.com>,
        Rocco Yue <rocco.yue@mediatek.com>
Subject: Re: [PATCH net-next] net: ipv6: add IFLA_RA_MTU to expose mtu value in the RA message
Date:   Thu, 29 Jul 2021 23:42:51 +0800
Message-ID: <20210729154251.1380-1-rocco.yue@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <c4099beb-1c22-ac71-ae05-e3f9a8ab69e2@gmail.com>
References: <c4099beb-1c22-ac71-ae05-e3f9a8ab69e2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 84ED98E54976BBFA2B0C83D314996E8EF6CAE2511184AF380DDEB250A244991C2000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIxLTA3LTI5IGF0IDA4OjQxIC0wNjAwLCBEYXZpZCBBaGVybiB3cm90ZToNCj4g
T24gNy8yOS8yMSAzOjAyIEFNLCBSb2NjbyBZdWUgd3JvdGU6DQo+PiBkaWZmIC0tZ2l0IGEvaW5j
bHVkZS91YXBpL2xpbnV4L2lmX2xpbmsuaCBiL2luY2x1ZGUvdWFwaS9saW51eC9pZl9saW5rLmgN
Cj4+IGluZGV4IDQ4ODJlODE1MTRiNi4uZWE2Yzg3MmM1ZjJjIDEwMDY0NA0KPj4gLS0tIGEvaW5j
bHVkZS91YXBpL2xpbnV4L2lmX2xpbmsuaA0KPj4gKysrIGIvaW5jbHVkZS91YXBpL2xpbnV4L2lm
X2xpbmsuaA0KPj4gQEAgLTM0Nyw3ICszNDcsNyBAQCBlbnVtIHsNCj4+ICAJICovDQo+PiAgCUlG
TEFfUEFSRU5UX0RFVl9OQU1FLA0KPj4gIAlJRkxBX1BBUkVOVF9ERVZfQlVTX05BTUUsDQo+PiAt
DQo+PiArCUlGTEFfUkFfTVRVLA0KPj4gIAlfX0lGTEFfTUFYDQo+PiAgfTsNCj4+ICANCj4+IGRp
ZmYgLS1naXQgYS9pbmNsdWRlL3VhcGkvbGludXgvaXB2Ni5oIGIvaW5jbHVkZS91YXBpL2xpbnV4
L2lwdjYuaA0KPj4gaW5kZXggNzA2MDM3NzVmZTkxLi4zZGJjZjIxMmI3NjYgMTAwNjQ0DQo+PiAt
LS0gYS9pbmNsdWRlL3VhcGkvbGludXgvaXB2Ni5oDQo+PiArKysgYi9pbmNsdWRlL3VhcGkvbGlu
dXgvaXB2Ni5oDQo+PiBAQCAtMTkwLDYgKzE5MCw3IEBAIGVudW0gew0KPj4gIAlERVZDT05GX05E
SVNDX1RDTEFTUywNCj4+ICAJREVWQ09ORl9SUExfU0VHX0VOQUJMRUQsDQo+PiAgCURFVkNPTkZf
UkFfREVGUlRSX01FVFJJQywNCj4+ICsJREVWQ09ORl9SQV9NVFUsDQo+PiAgCURFVkNPTkZfTUFY
DQo+PiAgfTsNCj4+ICANCj4gDQo+IHlvdSBkbyBub3QgbmVlZCBib3RoIElGTEEgYW5kIERFVkNP
TkYuIERyb3AgdGhlIERFVkNPTkYgY29tcGxldGVseS4gSUZMQQ0KPiBhdHRyaWJ1dGUgY2FuIGJl
IHVzZWQgZm9yIGJvdGggaW5zcGVjdGlvbiBhbmQgbm90aWZpY2F0aW9uIG9uIGNoYW5nZS4NCg0K
SGkgRGF2aWQsDQoNClRoYW5rcyBmb3IgeW91ciByZXZpZXcuDQoNCkJlY2F1c2UgdGhlIHB1cnBv
c2Ugb2YgdGhpcyBwYXRjaCBpcyBmb3IgdXNlcnNwYWNlIHRvIGNvcnJlY3RseSByZWFkIHRoZQ0K
cmFfbXR1IHZhbHVlIG9mIGRpZmZlcmVudCBuZXR3b3JrIGRldmljZSwgaWYgdGhlIERFVkNPTkYg
aXMgY29tcGxldGVseSBkcm9wcGVkLA0KZG9lcyB0aGF0IG1lYW4gSSBjYW4gYWRkIHRoZSAicmFf
bXR1IiBtZW1iZXIgaW4gdGhlICJzdHJ1Y3QgbmV0X2RldmljZSIgLg0KDQo+IEFsc28gZG8gbm90
IGFkZCBtYWlsaW5nIGxpc3RzIHRoYXQgY2F1c2UgYm91bmNlcy4gU3BlY2lmaWNhbGx5LCB5b3Ug
dGVuZA0KPiB0byBhZGQgd3NkX3Vwc3RyZWFtQG1lZGlhdGVrLmNvbSBhcyBhIGNjIGFuZCBldmVy
eSByZXNwb25zZSB0byB5b3UNCj4gZ2VuZXJhdGVzIGEgYm91bmNlIG1lc3NhZ2UgZm9yIHRoaXMg
YWRkcmVzcy4NCg0KVGhhbmtzIGZvciBwb2ludGluZyBvdXQgdGhlIHByb2JsZW0sIEkgd2lsbCBy
ZW1vdmUgaXQgZnJvbSB0aGUgbWFpbGluZyBsaXN0Lg0KDQpCZXN0IFJlZ2FyZHMsDQpSb2Njbw==

