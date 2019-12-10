Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E5FD1181F0
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:15:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfLJIPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:15:00 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45567 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727022AbfLJIO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:14:59 -0500
X-UUID: a1d9a42928d44d63b201d5ad84c05baa-20191210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=KJqQ2m7z9H4vre+SZyxgKEGRWb9Edp5pJlYnepJNMyM=;
        b=SuczJHZpeY7vF8UsCGorYUAcT2lEUX2E0ciiyQBS1rDLPzTYnufK8OXyAw5Uq8U1m72TGWYCaq1o0VWtI1meJpEmCL2TVK/d+Y+IaacHlO716BmX77+0MU0crczE8zx1Nz2pNh+GicsB6AoC9qbBU+p5egbKDMBhpRaGQNAeBww=;
X-UUID: a1d9a42928d44d63b201d5ad84c05baa-20191210
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 297826603; Tue, 10 Dec 2019 16:14:47 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 10 Dec 2019 16:14:38 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 10 Dec 2019 16:14:26 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@savoirfairelinux.com>, <matthias.bgg@gmail.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <davem@davemloft.net>,
        <sean.wang@mediatek.com>, <opensource@vdorst.com>,
        <frank-w@public-files.de>, Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next 3/6] dt-bindings: net: dsa: add new MT7531 binding to support MT7531
Date:   Tue, 10 Dec 2019 16:14:39 +0800
Message-ID: <1c382fd916b66bfe3ce8ef18c12f954dbcbddbbc.1575914275.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1575914275.git.landen.chao@mediatek.com>
References: <cover.1575914275.git.landen.chao@mediatek.com>
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
IExhbmRlbiBDaGFvIDxsYW5kZW4uY2hhb0BtZWRpYXRlay5jb20+DQotLS0NCiAuLi4vZGV2aWNl
dHJlZS9iaW5kaW5ncy9uZXQvZHNhL210NzUzMC50eHQgICAgfCA3NyArKysrKysrKysrKysrKysr
KystDQogMSBmaWxlIGNoYW5nZWQsIDc0IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9t
dDc1MzAudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbXQ3
NTMwLnR4dA0KaW5kZXggYzVlZDVkMjVmNjQyLi5kYzIyNmE0ZTQwMmEgMTAwNjQ0DQotLS0gYS9E
b2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1MzAudHh0DQorKysg
Yi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1MzAudHh0DQpA
QCAtNSw2ICs1LDcgQEAgUmVxdWlyZWQgcHJvcGVydGllczoNCiANCiAtIGNvbXBhdGlibGU6IG1h
eSBiZSBjb21wYXRpYmxlID0gIm1lZGlhdGVrLG10NzUzMCINCiAJb3IgY29tcGF0aWJsZSA9ICJt
ZWRpYXRlayxtdDc2MjEiDQorCW9yIGNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ3NTMxIg0KIC0g
I2FkZHJlc3MtY2VsbHM6IE11c3QgYmUgMS4NCiAtICNzaXplLWNlbGxzOiBNdXN0IGJlIDAuDQog
LSBtZWRpYXRlayxtY206IEJvb2xlYW47IGlmIGRlZmluZWQsIGluZGljYXRlcyB0aGF0IGVpdGhl
ciBNVDc1MzAgaXMgdGhlIHBhcnQNCkBAIC0zMiwxMCArMzMsMTMgQEAgUmVxdWlyZWQgcHJvcGVy
dGllcyBmb3IgdGhlIGNoaWxkIG5vZGVzIHdpdGhpbiBwb3J0cyBjb250YWluZXI6DQogDQogLSBy
ZWc6IFBvcnQgYWRkcmVzcyBkZXNjcmliZWQgbXVzdCBiZSA2IGZvciBDUFUgcG9ydCBhbmQgZnJv
bSAwIHRvIDUgZm9yDQogCXVzZXIgcG9ydHMuDQotLSBwaHktbW9kZTogU3RyaW5nLCBtdXN0IGJl
IGVpdGhlciAidHJnbWlpIiBvciAicmdtaWkiIGZvciBwb3J0IGxhYmVsZWQNCi0JICJjcHUiLg0K
Ky0gcGh5LW1vZGU6IFN0cmluZywgdGhlIGZvbGxvdyB2YWx1ZSB3b3VsZCBiZSBhY2NlcHRhYmxl
IGZvciBwb3J0IGxhYmVsZWQgImNwdSINCisJSWYgY29tcGF0aWJsZSBtZWRpYXRlayxtdDc1MzAg
b3IgbWVkaWF0ZWssbXQ3NjIxIGlzIHNldCwNCisJbXVzdCBiZSBlaXRoZXIgInRyZ21paSIgb3Ig
InJnbWlpIg0KKwlJZiBjb21wYXRpYmxlIG1lZGlhdGVrLG10NzUzMSBpcyBzZXQsDQorCW11c3Qg
YmUgZWl0aGVyICJzZ21paSIsICIxMDAwYmFzZS14IiBvciAiMjUwMGJhc2UteCINCiANCi1Qb3J0
IDUgb2YgdGhlIHN3aXRjaCBpcyBtdXhlZCBiZXR3ZWVuOg0KK1BvcnQgNSBvZiBtdDc1MzAgYW5k
IG10NzYyMSBzd2l0Y2ggaXMgbXV4ZWQgYmV0d2VlbjoNCiAxLiBHTUFDNTogR01BQzUgY2FuIGlu
dGVyZmFjZSB3aXRoIGFub3RoZXIgZXh0ZXJuYWwgTUFDIG9yIFBIWS4NCiAyLiBQSFkgb2YgcG9y
dCAwIG9yIHBvcnQgNDogUEhZIGludGVyZmFjZXMgd2l0aCBhbiBleHRlcm5hbCBNQUMgbGlrZSAy
bmQgR01BQw0KICAgIG9mIHRoZSBTT0MuIFVzZWQgaW4gbWFueSBzZXR1cHMgd2hlcmUgcG9ydCAw
LzQgYmVjb21lcyB0aGUgV0FOIHBvcnQuDQpAQCAtMzA4LDMgKzMxMiw3MCBAQCBFeGFtcGxlIDM6
IE1UNzYyMTogUG9ydCA1IGlzIGNvbm5lY3RlZCB0byBleHRlcm5hbCBQSFk6IFBvcnQgNSAtPiBl
eHRlcm5hbCBQSFkuDQogCQl9Ow0KIAl9Ow0KIH07DQorDQorRXhhbXBsZSA0Og0KKw0KKyZldGgg
ew0KKwlnbWFjMDogbWFjQDAgew0KKwkJY29tcGF0aWJsZSA9ICJtZWRpYXRlayxldGgtbWFjIjsN
CisJCXJlZyA9IDwwPjsNCisJCXBoeS1tb2RlID0gIjI1MDBiYXNlLXgiOw0KKw0KKwkJZml4ZWQt
bGluayB7DQorCQkJc3BlZWQgPSA8MTAwMD47DQorCQkJZnVsbC1kdXBsZXg7DQorCQkJcGF1c2U7
DQorCQl9Ow0KKwl9Ow0KKw0KKwkmbWRpbzAgew0KKwkJc3dpdGNoQDAgew0KKwkJCWNvbXBhdGli
bGUgPSAibWVkaWF0ZWssbXQ3NTMxIjsNCisJCQlyZWcgPSA8MD47DQorCQkJcmVzZXQtZ3Bpb3Mg
PSA8JnBpbyA1NCAwPjsNCisNCisJCQlwb3J0cyB7DQorCQkJCSNhZGRyZXNzLWNlbGxzID0gPDE+
Ow0KKwkJCQkjc2l6ZS1jZWxscyA9IDwwPjsNCisJCQkJcmVnID0gPDA+Ow0KKw0KKwkJCQlwb3J0
QDAgew0KKwkJCQkJcmVnID0gPDA+Ow0KKwkJCQkJbGFiZWwgPSAibGFuMCI7DQorCQkJCX07DQor
DQorCQkJCXBvcnRAMSB7DQorCQkJCQlyZWcgPSA8MT47DQorCQkJCQlsYWJlbCA9ICJsYW4xIjsN
CisJCQkJfTsNCisNCisJCQkJcG9ydEAyIHsNCisJCQkJCXJlZyA9IDwyPjsNCisJCQkJCWxhYmVs
ID0gImxhbjIiOw0KKwkJCQl9Ow0KKw0KKwkJCQlwb3J0QDMgew0KKwkJCQkJcmVnID0gPDM+Ow0K
KwkJCQkJbGFiZWwgPSAibGFuMyI7DQorCQkJCX07DQorDQorCQkJCXBvcnRANCB7DQorCQkJCQly
ZWcgPSA8ND47DQorCQkJCQlsYWJlbCA9ICJ3YW4iOw0KKwkJCQl9Ow0KKw0KKwkJCQlwb3J0QDYg
ew0KKwkJCQkJcmVnID0gPDY+Ow0KKwkJCQkJbGFiZWwgPSAiY3B1IjsNCisJCQkJCWV0aGVybmV0
ID0gPCZnbWFjMD47DQorCQkJCQlwaHktbW9kZSA9ICIyNTAwYmFzZS14IjsNCisNCisJCQkJCWZp
eGVkLWxpbmsgew0KKwkJCQkJCXNwZWVkID0gPDEwMDA+Ow0KKwkJCQkJCWZ1bGwtZHVwbGV4Ow0K
KwkJCQkJCXBhdXNlOw0KKwkJCQkJfTsNCisJCQkJfTsNCisJCQl9Ow0KKwkJfTsNCisJfTsNCi0t
IA0KMi4xNy4xDQo=

