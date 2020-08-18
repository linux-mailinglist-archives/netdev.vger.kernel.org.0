Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D68D4247F1F
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:14:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgHRHO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:14:26 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:9786 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726341AbgHRHOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:14:25 -0400
X-UUID: 639abd32fad742f08779ff6fb81c4d16-20200818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=V6XxCpPTSlmV62qL2azad6TOR58m4DQS08EIOISEdq4=;
        b=hCWNi3bGS1TTNBHFXqsWpfZlZiz3rXEyJli0ekQMsb3zuFKECf2eOIO3smMPoF3Bw+tydUa829hikwZPrZi0C8xk1a+RKRgOozJjyMM47I9e0Z1+sDIz7VOdIi2aBw2U62h4xDfbaHDm/lMOtb2YLUi1kwzr3pNJsiFtbbyJ46c=;
X-UUID: 639abd32fad742f08779ff6fb81c4d16-20200818
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 18934888; Tue, 18 Aug 2020 15:14:17 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 18 Aug 2020 15:14:15 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 15:14:16 +0800
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
Subject: [PATCH net-next v2 0/7] net-next: dsa: mt7530: add support for MT7531
Date:   Tue, 18 Aug 2020 15:14:05 +0800
Message-ID: <cover.1597729692.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
Content-Transfer-Encoding: base64
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyBwYXRjaCBzZXJpZXMgYWRkcyBzdXBwb3J0IGZvciBNVDc1MzEuDQoNCk1UNzUzMSBpcyB0
aGUgbmV4dCBnZW5lcmF0aW9uIG9mIE1UNzUzMCB3aGljaCBjb3VsZCBiZSBmb3VuZCBvbiBNZWRp
YXRlaw0Kcm91dGVyIHBsYXRmb3JtcyBzdWNoIGFzIE1UNzYyMiBvciBNVDc2MjkuDQoNCkl0IGlz
IGFsc28gYSA3LXBvcnRzIHN3aXRjaCB3aXRoIDUgZ2lnYSBlbWJlZGRlZCBwaHlzLCAyIGNwdSBw
b3J0cywgYW5kDQp0aGUgc2FtZSBNQUMgbG9naWMgb2YgTVQ3NTMwLiBDcHUgcG9ydCA2IG9ubHkg
c3VwcG9ydHMgU0dNSUkgaW50ZXJmYWNlLg0KQ3B1IHBvcnQgNSBzdXBwb3J0cyBlaXRoZXIgUkdN
SUkgb3IgU0dNSUkgaW4gZGlmZmVyZW50IEhXIFNLVS4gRHVlIHRvDQpzdXBwb3J0IGZvciBTR01J
SSBpbnRlcmZhY2UsIHBsbCwgYW5kIHBhZCBzZXR0aW5nIGFyZSBkaWZmZXJlbnQgZnJvbQ0KTVQ3
NTMwLg0KDQpNVDc1MzEgU0dNSUkgaW50ZXJmYWNlIGNhbiBiZSBjb25maWd1cmVkIGluIGZvbGxv
d2luZyBtb2RlOg0KLSAnU0dNSUkgQU4gbW9kZScgd2l0aCBpbi1iYW5kIG5lZ290aWF0aW9uIGNh
cGFiaWxpdHkNCiAgICB3aGljaCBpcyBjb21wYXRpYmxlIHdpdGggUEhZX0lOVEVSRkFDRV9NT0RF
X1NHTUlJLg0KLSAnU0dNSUkgZm9yY2UgbW9kZScgd2l0aG91dCBpbi1ibmFkIG5lZ290aWF0aW9u
DQogICAgd2hpY2ggaXMgY29tcGF0aWJsZSB3aXRoIDEwQi84QiBlbmNvZGluZyBvZg0KICAgIFBI
WV9JTlRFUkZBQ0VfTU9ERV8xMDAwQkFTRVggd2l0aCBmaXhlZCBmdWxsLWR1cGxleCBhbmQgZml4
ZWQgcGF1c2UuDQotIDIuNSB0aW1lcyBmYXN0ZXIgY2xvY2tlZCAnU0dNSUkgZm9yY2UgbW9kZScg
d2l0aG91dCBpbi1ibmFkIG5lZ290aWF0aW9uDQogICAgd2hpY2ggaXMgY29tcGF0aWJsZSB3aXRo
IDEwQi84QiBlbmNvZGluZyBvZg0KICAgIFBIWV9JTlRFUkZBQ0VfTU9ERV8yNTAwQkFTRVggd2l0
aCBmaXhlZCBmdWxsLWR1cGxleCBhbmQgZml4ZWQgcGF1c2UuDQoNCmNoYW5nZXMgYmV0d2VlbiB2
MSAmIHYyDQotIGNoYW5nZSBwaHlsaW5rX3ZhbGlkYXRlIGNhbGxiYWNrIGZ1bmN0aW9uIHRvIHN1
cHBvcnQgZnVsbC1kdXBsZXgNCiAgZ2lnYWJpdCBvbmx5IHRvIG1hdGNoIGhhcmR3YXJlIGNhcGFi
aWxpdHkuDQotIGFkZCBkZXNjcmlwdGlvbiBvZiBTR01JSSBpbnRlcmZhY2UuDQotIGNvbmZpZ3Vy
ZSBtdDc1MzEgY3B1IHBvcnQgaW4gZmFzdGVzdCBzcGVlZCBieSBkZWZhdWx0Lg0KLSBwYXJzZSBT
R01JSSBjb250cm9sIHdvcmQgZm9yIGluLWJhbmQgbmVnb3RpYXRpb24gbW9kZS4NCi0gY29uZmln
dXJlIFJHTUlJIGRlbGF5IGJhc2VkIG9uIHBoeS5yc3QuDQotIFJlbmFtZSB0aGUgZGVmaW5pdGlv
biBpbiB0aGUgaGVhZGVyIGZpbGUgdG8gYXZvaWQgcG90ZW50aWFsIGNvbmZsaWN0cy4NCi0gQWRk
IHdyYXBwZXIgZnVuY3Rpb24gZm9yIG1kaW8gcmVhZC93cml0ZSB0byBzdXBwb3J0IGJvdGggQzIy
IGFuZCBDNDUuDQotIGNvcnJlY3QgZml4ZWQtbGluayBzcGVlZCBvZiAyNTAwYmFzZS14IGluIGR0
cy4NCi0gYWRkIE1UNzUzMSBwb3J0IG1pcnJvciBzZXR0aW5nLg0KDQpMYW5kZW4gQ2hhbyAoNyk6
DQogIG5ldDogZHNhOiBtdDc1MzA6IFJlZmluZSBtZXNzYWdlIGluIEtjb25maWcNCiAgbmV0OiBk
c2E6IG10NzUzMDogc3VwcG9ydCBmdWxsLWR1cGxleCBnaWdhYml0IG9ubHkNCiAgbmV0OiBkc2E6
IG10NzUzMDogRXh0ZW5kIGRldmljZSBkYXRhIHJlYWR5IGZvciBhZGRpbmcgYSBuZXcgaGFyZHdh
cmUNCiAgZHQtYmluZGluZ3M6IG5ldDogZHNhOiBhZGQgbmV3IE1UNzUzMSBiaW5kaW5nIHRvIHN1
cHBvcnQgTVQ3NTMxDQogIG5ldDogZHNhOiBtdDc1MzA6IEFkZCB0aGUgc3VwcG9ydCBvZiBNVDc1
MzEgc3dpdGNoDQogIGFybTY0OiBkdHM6IG10NzYyMjogYWRkIG10NzUzMSBkc2EgdG8gbXQ3NjIy
LXJmYjEgYm9hcmQNCiAgYXJtNjQ6IGR0czogbXQ3NjIyOiBhZGQgbXQ3NTMxIGRzYSB0byBiYW5h
bmFwaS1icGktcjY0IGJvYXJkDQoNCiAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL210
NzUzMC50eHQgICAgfCAgIDcxICstDQogLi4uL2R0cy9tZWRpYXRlay9tdDc2MjItYmFuYW5hcGkt
YnBpLXI2NC5kdHMgIHwgICA0NCArDQogYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDc2
MjItcmZiMS5kdHMgIHwgICA1NyArLQ0KIGRyaXZlcnMvbmV0L2RzYS9LY29uZmlnICAgICAgICAg
ICAgICAgICAgICAgICB8ICAgIDYgKy0NCiBkcml2ZXJzL25ldC9kc2EvbXQ3NTMwLmMgICAgICAg
ICAgICAgICAgICAgICAgfCAxMTg0ICsrKysrKysrKysrKysrKy0tDQogZHJpdmVycy9uZXQvZHNh
L210NzUzMC5oICAgICAgICAgICAgICAgICAgICAgIHwgIDI1OSArKystDQogNiBmaWxlcyBjaGFu
Z2VkLCAxNTE0IGluc2VydGlvbnMoKyksIDEwNyBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE3LjEN
Cg==

