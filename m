Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACCD6247F26
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:14:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726735AbgHRHOs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:14:48 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:12126 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726370AbgHRHOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:14:45 -0400
X-UUID: 031c4186c65c474db80104325d4d6fd9-20200818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=l8c959ZS0LpVJQ/d/MvvSj2ryOh4fCinGK68xeDTNG0=;
        b=WZ5H26PHRgjqagkm6U63ChVotgwt/24qyRkF9kCkBAy8SfPgVVkTtsMSsnsOQfa9EJ5qCsMaTRwFKShfNskln0HEODVkONFnrIVxYpC2HpRSun+a6nedIEaU7F3rhi4EQT1zm2cEMHHOLFgaUYpAdA2JrSz2rVUpDjALic05JEE=;
X-UUID: 031c4186c65c474db80104325d4d6fd9-20200818
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 458419947; Tue, 18 Aug 2020 15:14:39 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 18 Aug 2020 15:14:36 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 15:14:37 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@savoirfairelinux.com>, <matthias.bgg@gmail.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <davem@davemloft.net>,
        <sean.wang@mediatek.com>, <opensource@vdorst.com>,
        <frank-w@public-files.de>, <dqfext@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next v2 4/7] dt-bindings: net: dsa: add new MT7531 binding to support MT7531
Date:   Tue, 18 Aug 2020 15:14:09 +0800
Message-ID: <1ec38b68deec6f1c23e1236d38035b1823ea2ebf.1597729692.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1597729692.git.landen.chao@mediatek.com>
References: <cover.1597729692.git.landen.chao@mediatek.com>
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
dHJlZS9iaW5kaW5ncy9uZXQvZHNhL210NzUzMC50eHQgICAgfCA3MSArKysrKysrKysrKysrKysr
KystDQogMSBmaWxlIGNoYW5nZWQsIDY4IGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQoN
CmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9t
dDc1MzAudHh0IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbXQ3
NTMwLnR4dA0KaW5kZXggYzVlZDVkMjVmNjQyLi41MGVhZjQwZmI2MTIgMTAwNjQ0DQotLS0gYS9E
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
LzQgYmVjb21lcyB0aGUgV0FOIHBvcnQuDQpAQCAtMzA4LDMgKzMxMiw2NCBAQCBFeGFtcGxlIDM6
IE1UNzYyMTogUG9ydCA1IGlzIGNvbm5lY3RlZCB0byBleHRlcm5hbCBQSFk6IFBvcnQgNSAtPiBl
eHRlcm5hbCBQSFkuDQogCQl9Ow0KIAl9Ow0KIH07DQorDQorRXhhbXBsZSA0OiBNVDc1MzFCRSBw
b3J0NiAtLSB1cC1jbG9ja2VkIDIuNUdicHMgU0dNSUkgLS0gTVQ3NjIyIENQVSAxc3QgR01BQw0K
Kw0KKyZldGggew0KKwlnbWFjMDogbWFjQDAgew0KKwkJY29tcGF0aWJsZSA9ICJtZWRpYXRlayxl
dGgtbWFjIjsNCisJCXJlZyA9IDwwPjsNCisJCXBoeS1tb2RlID0gIjI1MDBiYXNlLXgiOw0KKw0K
KwkJZml4ZWQtbGluayB7DQorCQkJc3BlZWQgPSA8MjUwMD47DQorCQkJZnVsbC1kdXBsZXg7DQor
CQkJcGF1c2U7DQorCQl9Ow0KKwl9Ow0KKw0KKwkmbWRpbzAgew0KKwkJc3dpdGNoQDAgew0KKwkJ
CWNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ3NTMxIjsNCisJCQlyZWcgPSA8MD47DQorCQkJcmVz
ZXQtZ3Bpb3MgPSA8JnBpbyA1NCAwPjsNCisNCisJCQlwb3J0cyB7DQorCQkJCSNhZGRyZXNzLWNl
bGxzID0gPDE+Ow0KKwkJCQkjc2l6ZS1jZWxscyA9IDwwPjsNCisJCQkJcmVnID0gPDA+Ow0KKw0K
KwkJCQlwb3J0QDAgew0KKwkJCQkJcmVnID0gPDA+Ow0KKwkJCQkJbGFiZWwgPSAibGFuMCI7DQor
CQkJCX07DQorDQorCQkJCXBvcnRAMSB7DQorCQkJCQlyZWcgPSA8MT47DQorCQkJCQlsYWJlbCA9
ICJsYW4xIjsNCisJCQkJfTsNCisNCisJCQkJcG9ydEAyIHsNCisJCQkJCXJlZyA9IDwyPjsNCisJ
CQkJCWxhYmVsID0gImxhbjIiOw0KKwkJCQl9Ow0KKw0KKwkJCQlwb3J0QDMgew0KKwkJCQkJcmVn
ID0gPDM+Ow0KKwkJCQkJbGFiZWwgPSAibGFuMyI7DQorCQkJCX07DQorDQorCQkJCXBvcnRANCB7
DQorCQkJCQlyZWcgPSA8ND47DQorCQkJCQlsYWJlbCA9ICJ3YW4iOw0KKwkJCQl9Ow0KKw0KKwkJ
CQlwb3J0QDYgew0KKwkJCQkJcmVnID0gPDY+Ow0KKwkJCQkJbGFiZWwgPSAiY3B1IjsNCisJCQkJ
CWV0aGVybmV0ID0gPCZnbWFjMD47DQorCQkJCQlwaHktbW9kZSA9ICIyNTAwYmFzZS14IjsNCisJ
CQkJfTsNCisJCQl9Ow0KKwkJfTsNCisJfTsNCi0tIA0KMi4xNy4xDQo=

