Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24E2F25DB74
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 16:24:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730797AbgIDOYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 10:24:13 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:25979 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730749AbgIDOWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 10:22:39 -0400
X-UUID: 9cce95f9729d41eba569f57477a3ee52-20200904
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=cX1RyWC6RhWrmSa5l9WmiLo7asIr+FhEw7uQh+t/SNY=;
        b=sFOuXGH3BfjmfohIUR1dAcN8cUJEoJNOMNY/Gt/Wnxf8lao8XL5JtGlmiLbbK7ZrsfxmZZqjsyH3YMC4ClGTwAXWzM2ON7sot3H+h+pndJaeyFbqHrHTS1G2yPwOE2UKldVq0GjzkXzgKO3YRmBcHzoXmAfItBuHjmwgWNtczic=;
X-UUID: 9cce95f9729d41eba569f57477a3ee52-20200904
Received: from mtkcas06.mediatek.inc [(172.21.101.30)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 360361354; Fri, 04 Sep 2020 22:22:35 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 4 Sep 2020 22:22:31 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 4 Sep 2020 22:22:32 +0800
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
Subject: [PATCH net-next v3 6/6] arm64: dts: mt7622: add mt7531 dsa to bananapi-bpi-r64 board
Date:   Fri, 4 Sep 2020 22:22:01 +0800
Message-ID: <316901affafb0121bf2554b433b76e446b7d2e1e.1599228079.git.landen.chao@mediatek.com>
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

QWRkIG10NzUzMSBkc2EgdG8gYmFuYW5hcGktYnBpLXI2NCBib2FyZCBmb3IgNSBnaWdhIEV0aGVy
bmV0IHBvcnRzIHN1cHBvcnQuDQoNClNpZ25lZC1vZmYtYnk6IExhbmRlbiBDaGFvIDxsYW5kZW4u
Y2hhb0BtZWRpYXRlay5jb20+DQotLS0NCiAuLi4vZHRzL21lZGlhdGVrL210NzYyMi1iYW5hbmFw
aS1icGktcjY0LmR0cyAgfCA0NCArKysrKysrKysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQs
IDQ0IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVk
aWF0ZWsvbXQ3NjIyLWJhbmFuYXBpLWJwaS1yNjQuZHRzIGIvYXJjaC9hcm02NC9ib290L2R0cy9t
ZWRpYXRlay9tdDc2MjItYmFuYW5hcGktYnBpLXI2NC5kdHMNCmluZGV4IGQxNzRhZDIxNDg1Ny4u
YzU3YjI1NzExNjVmIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9t
dDc2MjItYmFuYW5hcGktYnBpLXI2NC5kdHMNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVk
aWF0ZWsvbXQ3NjIyLWJhbmFuYXBpLWJwaS1yNjQuZHRzDQpAQCAtMTQzLDYgKzE0Myw1MCBAQA0K
IAltZGlvOiBtZGlvLWJ1cyB7DQogCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCiAJCSNzaXplLWNl
bGxzID0gPDA+Ow0KKw0KKwkJc3dpdGNoQDAgew0KKwkJCWNvbXBhdGlibGUgPSAibWVkaWF0ZWss
bXQ3NTMxIjsNCisJCQlyZWcgPSA8MD47DQorCQkJcmVzZXQtZ3Bpb3MgPSA8JnBpbyA1NCAwPjsN
CisNCisJCQlwb3J0cyB7DQorCQkJCSNhZGRyZXNzLWNlbGxzID0gPDE+Ow0KKwkJCQkjc2l6ZS1j
ZWxscyA9IDwwPjsNCisNCisJCQkJcG9ydEAwIHsNCisJCQkJCXJlZyA9IDwwPjsNCisJCQkJCWxh
YmVsID0gIndhbiI7DQorCQkJCX07DQorDQorCQkJCXBvcnRAMSB7DQorCQkJCQlyZWcgPSA8MT47
DQorCQkJCQlsYWJlbCA9ICJsYW4wIjsNCisJCQkJfTsNCisNCisJCQkJcG9ydEAyIHsNCisJCQkJ
CXJlZyA9IDwyPjsNCisJCQkJCWxhYmVsID0gImxhbjEiOw0KKwkJCQl9Ow0KKw0KKwkJCQlwb3J0
QDMgew0KKwkJCQkJcmVnID0gPDM+Ow0KKwkJCQkJbGFiZWwgPSAibGFuMiI7DQorCQkJCX07DQor
DQorCQkJCXBvcnRANCB7DQorCQkJCQlyZWcgPSA8ND47DQorCQkJCQlsYWJlbCA9ICJsYW4zIjsN
CisJCQkJfTsNCisNCisJCQkJcG9ydEA2IHsNCisJCQkJCXJlZyA9IDw2PjsNCisJCQkJCWxhYmVs
ID0gImNwdSI7DQorCQkJCQlldGhlcm5ldCA9IDwmZ21hYzA+Ow0KKwkJCQkJcGh5LW1vZGUgPSAi
MjUwMGJhc2UteCI7DQorCQkJCX07DQorCQkJfTsNCisJCX07DQorDQogCX07DQogfTsNCiANCi0t
IA0KMi4xNy4xDQo=

