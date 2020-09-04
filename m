Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04C7525DB6D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730821AbgIDOWv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:22:51 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:52167 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730707AbgIDOWa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:22:30 -0400
X-UUID: 6c6d17cbab084dc68491a6a4fa756271-20200904
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=BTL6X8fSaZsikWRWd13KVTZPGLYYIeADDItPNkTY2EQ=;
        b=qv23qHzp0PLJEZDfGBiqwd2nM4RtTVVIe5x+t5E7AMOPP70IIVYrDnrr9bwL7cLI+or8H/JUKDpzpNLMTedd+6G6WHSgv4lRDc6k63lqOlPW6u6XbPTvmspif/3Nk8oijyIzE68WEvzqyOu1ebWQrJTRD5eSCbQPx1Y3D9m+ybo=;
X-UUID: 6c6d17cbab084dc68491a6a4fa756271-20200904
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 869483122; Fri, 04 Sep 2020 22:22:27 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Sep 2020 22:22:24 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Sep 2020 22:22:24 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <frank-w@public-files.de>,
        <opensource@vdorst.com>, <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next v3 3/6] dt-bindings: net: dsa: add new MT7531 binding to support MT7531
Date:   Fri, 4 Sep 2020 22:21:58 +0800
Message-ID: <4ec3c9e6a219c09fc90d1be8d3d63da587ef6fba.1599228079.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1599228079.git.landen.chao@mediatek.com>
References: <cover.1599228079.git.landen.chao@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIGRldmljZXRyZWUgYmluZGluZyB0byBzdXBwb3J0IHRoZSBjb21wYXRpYmxlIG10NzUzMSBz
d2l0Y2ggYXMgdXNlZA0KaW4gdGhlIE1lZGlhVGVrIE1UNzUzMSBzd2l0Y2guDQoNClNpZ25lZC1v
ZmYtYnk6IFNlYW4gV2FuZyA8c2Vhbi53YW5nQG1lZGlhdGVrLmNvbT4NClNpZ25lZC1vZmYtYnk6
IExhbmRlbiBDaGFvIDxsYW5kZW4uY2hhb0BtZWRpYXRlay5jb20+DQotLS0NCiBEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1MzAudHh0IHwgMTAgKysrKysrKy0t
LQ0KIDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1
MzAudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbXQ3NTMw
LnR4dA0KaW5kZXggYzVlZDVkMjVmNjQyLi5lMjJjZDU2ZDgzZmUgMTAwNjQ0DQotLS0gYS9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1MzAudHh0DQorKysgYi9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1MzAudHh0DQpAQCAt
NSw2ICs1LDcgQEAgUmVxdWlyZWQgcHJvcGVydGllczoNCiANCiAtIGNvbXBhdGlibGU6IG1heSBi
ZSBjb21wYXRpYmxlID0gIm1lZGlhdGVrLG10NzUzMCINCiAJb3IgY29tcGF0aWJsZSA9ICJtZWRp
YXRlayxtdDc2MjEiDQorCW9yIGNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ3NTMxIg0KIC0gI2Fk
ZHJlc3MtY2VsbHM6IE11c3QgYmUgMS4NCiAtICNzaXplLWNlbGxzOiBNdXN0IGJlIDAuDQogLSBt
ZWRpYXRlayxtY206IEJvb2xlYW47IGlmIGRlZmluZWQsIGluZGljYXRlcyB0aGF0IGVpdGhlciBN
VDc1MzAgaXMgdGhlIHBhcnQNCkBAIC0zMiwxMCArMzMsMTMgQEAgUmVxdWlyZWQgcHJvcGVydGll
cyBmb3IgdGhlIGNoaWxkIG5vZGVzIHdpdGhpbiBwb3J0cyBjb250YWluZXI6DQogDQogLSByZWc6
IFBvcnQgYWRkcmVzcyBkZXNjcmliZWQgbXVzdCBiZSA2IGZvciBDUFUgcG9ydCBhbmQgZnJvbSAw
IHRvIDUgZm9yDQogCXVzZXIgcG9ydHMuDQotLSBwaHktbW9kZTogU3RyaW5nLCBtdXN0IGJlIGVp
dGhlciAidHJnbWlpIiBvciAicmdtaWkiIGZvciBwb3J0IGxhYmVsZWQNCi0JICJjcHUiLg0KKy0g
cGh5LW1vZGU6IFN0cmluZywgdGhlIGZvbGxvdyB2YWx1ZSB3b3VsZCBiZSBhY2NlcHRhYmxlIGZv
ciBwb3J0IGxhYmVsZWQgImNwdSINCisJSWYgY29tcGF0aWJsZSBtZWRpYXRlayxtdDc1MzAgb3Ig
bWVkaWF0ZWssbXQ3NjIxIGlzIHNldCwNCisJbXVzdCBiZSBlaXRoZXIgInRyZ21paSIgb3IgInJn
bWlpIg0KKwlJZiBjb21wYXRpYmxlIG1lZGlhdGVrLG10NzUzMSBpcyBzZXQsDQorCW11c3QgYmUg
ZWl0aGVyICJzZ21paSIsICIxMDAwYmFzZS14IiBvciAiMjUwMGJhc2UteCINCiANCi1Qb3J0IDUg
b2YgdGhlIHN3aXRjaCBpcyBtdXhlZCBiZXR3ZWVuOg0KK1BvcnQgNSBvZiBtdDc1MzAgYW5kIG10
NzYyMSBzd2l0Y2ggaXMgbXV4ZWQgYmV0d2VlbjoNCiAxLiBHTUFDNTogR01BQzUgY2FuIGludGVy
ZmFjZSB3aXRoIGFub3RoZXIgZXh0ZXJuYWwgTUFDIG9yIFBIWS4NCiAyLiBQSFkgb2YgcG9ydCAw
IG9yIHBvcnQgNDogUEhZIGludGVyZmFjZXMgd2l0aCBhbiBleHRlcm5hbCBNQUMgbGlrZSAybmQg
R01BQw0KICAgIG9mIHRoZSBTT0MuIFVzZWQgaW4gbWFueSBzZXR1cHMgd2hlcmUgcG9ydCAwLzQg
YmVjb21lcyB0aGUgV0FOIHBvcnQuDQotLSANCjIuMTcuMQ0K

