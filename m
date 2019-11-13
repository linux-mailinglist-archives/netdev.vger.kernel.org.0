Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 16649FA6A0
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:39:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfKMCiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:38:52 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:20278 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726958AbfKMCiw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 21:38:52 -0500
X-UUID: 4d5e93c17efb4d5099b71f334942ca0f-20191113
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=Xz5t62Az4ex1Dw4JbEiqpduOllpXnz09mFnqd5LCa2w=;
        b=sLm8JMGgQrZ9PhTMwDtM/yPmXF/iUqkXiJ0+eL6e7yeBpX8Q0+VzzufD+s8PL5aDfCwvsMDWZHUiH1PDtozRyuJzLxt7lJ/SyejcTWh8Rhcwe9eKa1ZwsbLRlG5CrI1reXC9l75EtaylUGIxWbDMNfkoZ5QvyF9+oPIqCsok/yU=;
X-UUID: 4d5e93c17efb4d5099b71f334942ca0f-20191113
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw02.mediatek.com
        (envelope-from <mark-mc.lee@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 803015657; Wed, 13 Nov 2019 10:38:47 +0800
Received: from mtkmbs05dr.mediatek.inc (172.21.101.97) by
 mtkexhb02.mediatek.inc (172.21.101.103) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 13 Nov 2019 10:38:44 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs05dr.mediatek.inc (172.21.101.97) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 13 Nov 2019 10:38:44 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Wed, 13 Nov 2019 10:38:44 +0800
From:   MarkLee <Mark-MC.Lee@mediatek.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Sean Wang <sean.wang@mediatek.com>,
        John Crispin <john@phrozen.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Rene van Dorst <opensource@vdorst.com>,
        <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        "Jakub Kicinski" <jakub.kicinski@netronome.com>,
        MarkLee <Mark-MC.Lee@mediatek.com>
Subject: [PATCH net,v3 3/3] net: ethernet: mediatek: Enable GDM GDMA_DROP_ALL mode
Date:   Wed, 13 Nov 2019 10:38:44 +0800
Message-ID: <20191113023844.17800-4-Mark-MC.Lee@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <20191113023844.17800-1-Mark-MC.Lee@mediatek.com>
References: <20191113023844.17800-1-Mark-MC.Lee@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RW5hYmxlIEdETSBHRE1BX0RST1BfQUxMIG1vZGUgdG8gZHJvcCBhbGwgcGFja2V0IGR1cmluZyB0
aGUgDQpzdG9wIG9wZXJhdGlvbi4gVGhpcyBpcyByZWNvbW1lbmRlZCBieSB0aGUgbXQ3NjJ4IEhX
IGRlc2lnbiANCnRvIGRyb3AgYWxsIHBhY2tldCBmcm9tIEdNQUMgYmVmb3JlIHN0b3BwaW5nIFBE
TUEuDQoNClNpZ25lZC1vZmYtYnk6IE1hcmtMZWUgPE1hcmstTUMuTGVlQG1lZGlhdGVrLmNvbT4N
Ci0tDQp2MS0+djI6DQoqIG5vIGNoYW5nZQ0KdjItPnYzOg0KKiBubyBjaGFuZ2UNCg0KLS0tDQog
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuYyB8IDIgKysNCiBkcml2
ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRlay9tdGtfZXRoX3NvYy5oIHwgMSArDQogMiBmaWxlcyBj
aGFuZ2VkLCAzIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVy
bmV0L21lZGlhdGVrL210a19ldGhfc29jLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWRpYXRl
ay9tdGtfZXRoX3NvYy5jDQppbmRleCBiMTQ3YWIwZTQ0Y2UuLjVmZTFhYjBjMTZjYyAxMDA2NDQN
Ci0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmMNCisrKyBi
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmMNCkBAIC0yMjc5LDYg
KzIyNzksOCBAQCBzdGF0aWMgaW50IG10a19zdG9wKHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQog
CWlmICghcmVmY291bnRfZGVjX2FuZF90ZXN0KCZldGgtPmRtYV9yZWZjbnQpKQ0KIAkJcmV0dXJu
IDA7DQogDQorCW10a19nZG1fY29uZmlnKGV0aCwgTVRLX0dETUFfRFJPUF9BTEwpOw0KKw0KIAlt
dGtfdHhfaXJxX2Rpc2FibGUoZXRoLCBNVEtfVFhfRE9ORV9JTlQpOw0KIAltdGtfcnhfaXJxX2Rp
c2FibGUoZXRoLCBNVEtfUlhfRE9ORV9JTlQpOw0KIAluYXBpX2Rpc2FibGUoJmV0aC0+dHhfbmFw
aSk7DQpkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9z
b2MuaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lZGlhdGVrL210a19ldGhfc29jLmgNCmluZGV4
IGIxNmQ4ZDliMTk2YS4uODU4MzBmZTE0YTFiIDEwMDY0NA0KLS0tIGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWVkaWF0ZWsvbXRrX2V0aF9zb2MuaA0KKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVkaWF0ZWsvbXRrX2V0aF9zb2MuaA0KQEAgLTg1LDYgKzg1LDcgQEANCiAjZGVmaW5lIE1US19H
RE1BX1RDU19FTgkJQklUKDIxKQ0KICNkZWZpbmUgTVRLX0dETUFfVUNTX0VOCQlCSVQoMjApDQog
I2RlZmluZSBNVEtfR0RNQV9UT19QRE1BCTB4MA0KKyNkZWZpbmUgTVRLX0dETUFfRFJPUF9BTEwg
ICAgICAgMHg3Nzc3DQogDQogLyogVW5pY2FzdCBGaWx0ZXIgTUFDIEFkZHJlc3MgUmVnaXN0ZXIg
LSBMb3cgKi8NCiAjZGVmaW5lIE1US19HRE1BX01BQ19BRFJMKHgpCSgweDUwOCArICh4ICogMHgx
MDAwKSkNCi0tIA0KMi4xNy4xDQo=

