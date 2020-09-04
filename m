Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D6425DB75
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730827AbgIDOY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:24:28 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:25656 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730814AbgIDOWh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:22:37 -0400
X-UUID: ea5bb4247d434aa49f53b4ca941b9646-20200904
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=yhMeXMSBNUBRDeycZh1L4Fz1F/RTkmYS9WTwdpA+DVs=;
        b=BPB1FcxJ2h/CagOuFEmnV3xgvuHqBGR5IyTd/6WaqR/kNn6wly2zNPBpo8YIYW6KNWtqk7HgK7ar9oN7E45IRdqfnNGWuNesNmdE1D0vlXREv6YkJMt0R9Mwb3Qkrbaei8h0NEBJo5YqBVPYs1Sw4lxu4wnh3Id1jiJz9Wn4bcc=;
X-UUID: ea5bb4247d434aa49f53b4ca941b9646-20200904
Received: from mtkexhb01.mediatek.inc [(172.21.101.102)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 745327262; Fri, 04 Sep 2020 22:22:33 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Sep 2020 22:22:30 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Sep 2020 22:22:30 +0800
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
Subject: [PATCH net-next v3 5/6] arm64: dts: mt7622: add mt7531 dsa to mt7622-rfb1 board
Date:   Fri, 4 Sep 2020 22:22:00 +0800
Message-ID: <72e9de50aa0dd36c59d45c80ad05883a6fff48aa.1599228079.git.landen.chao@mediatek.com>
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

QWRkIG10NzUzMSBkc2EgdG8gbXQ3NjIyLXJmYjEgYm9hcmQgZm9yIDUgZ2lnYSBFdGhlcm5ldCBw
b3J0cyBzdXBwb3J0Lg0KbXQ3NjIyIG9ubHkgc3VwcG9ydHMgMSBzZ21paSBpbnRlcmZhY2UsIHNv
IGVpdGhlciBnbWFjMCBvciBnbWFjMSBjYW4gYmUNCmNvbmZpZ3VyZWQgYXMgc2dtaWkgaW50ZXJm
YWNlLiBJbiB0aGlzIHBhdGNoLCBjaGFuZ2UgdG8gY29ubmVjdCBtdDc2MjINCmdtYWMwIGFuZCBt
dDc1MzEgcG9ydDYgdGhyb3VnaCBzZ21paSBpbnRlcmZhY2UuDQoNClNpZ25lZC1vZmYtYnk6IExh
bmRlbiBDaGFvIDxsYW5kZW4uY2hhb0BtZWRpYXRlay5jb20+DQotLS0NCiBhcmNoL2FybTY0L2Jv
b3QvZHRzL21lZGlhdGVrL210NzYyMi1yZmIxLmR0cyB8IDU3ICsrKysrKysrKysrKysrKysrLS0t
DQogMSBmaWxlIGNoYW5nZWQsIDUxIGluc2VydGlvbnMoKyksIDYgZGVsZXRpb25zKC0pDQoNCmRp
ZmYgLS1naXQgYS9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlhdGVrL210NzYyMi1yZmIxLmR0cyBi
L2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLXJmYjEuZHRzDQppbmRleCAwYjRk
ZTYyN2Y5NmUuLjNmZDk0OGZiN2Y3YSAxMDA2NDQNCi0tLSBhL2FyY2gvYXJtNjQvYm9vdC9kdHMv
bWVkaWF0ZWsvbXQ3NjIyLXJmYjEuZHRzDQorKysgYi9hcmNoL2FybTY0L2Jvb3QvZHRzL21lZGlh
dGVrL210NzYyMi1yZmIxLmR0cw0KQEAgLTEwNSwyMCArMTA1LDY1IEBADQogCXBpbmN0cmwtMCA9
IDwmZXRoX3BpbnM+Ow0KIAlzdGF0dXMgPSAib2theSI7DQogDQotCWdtYWMxOiBtYWNAMSB7DQor
CWdtYWMwOiBtYWNAMCB7DQogCQljb21wYXRpYmxlID0gIm1lZGlhdGVrLGV0aC1tYWMiOw0KLQkJ
cmVnID0gPDE+Ow0KLQkJcGh5LWhhbmRsZSA9IDwmcGh5NT47DQorCQlyZWcgPSA8MD47DQorCQlw
aHktbW9kZSA9ICIyNTAwYmFzZS14IjsNCisNCisJCWZpeGVkLWxpbmsgew0KKwkJCXNwZWVkID0g
PDI1MDA+Ow0KKwkJCWZ1bGwtZHVwbGV4Ow0KKwkJCXBhdXNlOw0KKwkJfTsNCiAJfTsNCiANCiAJ
bWRpby1idXMgew0KIAkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQogCQkjc2l6ZS1jZWxscyA9IDww
PjsNCiANCi0JCXBoeTU6IGV0aGVybmV0LXBoeUA1IHsNCi0JCQlyZWcgPSA8NT47DQotCQkJcGh5
LW1vZGUgPSAic2dtaWkiOw0KKwkJc3dpdGNoQDAgew0KKwkJCWNvbXBhdGlibGUgPSAibWVkaWF0
ZWssbXQ3NTMxIjsNCisJCQlyZWcgPSA8MD47DQorCQkJcmVzZXQtZ3Bpb3MgPSA8JnBpbyA1NCAw
PjsNCisNCisJCQlwb3J0cyB7DQorCQkJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KKwkJCQkjc2l6
ZS1jZWxscyA9IDwwPjsNCisNCisJCQkJcG9ydEAwIHsNCisJCQkJCXJlZyA9IDwwPjsNCisJCQkJ
CWxhYmVsID0gImxhbjAiOw0KKwkJCQl9Ow0KKw0KKwkJCQlwb3J0QDEgew0KKwkJCQkJcmVnID0g
PDE+Ow0KKwkJCQkJbGFiZWwgPSAibGFuMSI7DQorCQkJCX07DQorDQorCQkJCXBvcnRAMiB7DQor
CQkJCQlyZWcgPSA8Mj47DQorCQkJCQlsYWJlbCA9ICJsYW4yIjsNCisJCQkJfTsNCisNCisJCQkJ
cG9ydEAzIHsNCisJCQkJCXJlZyA9IDwzPjsNCisJCQkJCWxhYmVsID0gImxhbjMiOw0KKwkJCQl9
Ow0KKw0KKwkJCQlwb3J0QDQgew0KKwkJCQkJcmVnID0gPDQ+Ow0KKwkJCQkJbGFiZWwgPSAid2Fu
IjsNCisJCQkJfTsNCisNCisJCQkJcG9ydEA2IHsNCisJCQkJCXJlZyA9IDw2PjsNCisJCQkJCWxh
YmVsID0gImNwdSI7DQorCQkJCQlldGhlcm5ldCA9IDwmZ21hYzA+Ow0KKwkJCQkJcGh5LW1vZGUg
PSAiMjUwMGJhc2UteCI7DQorCQkJCX07DQorCQkJfTsNCiAJCX07DQorDQogCX07DQogfTsNCiAN
Ci0tIA0KMi4xNy4xDQo=

