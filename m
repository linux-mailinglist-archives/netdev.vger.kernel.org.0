Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F02E2247F2B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726777AbgHRHOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:14:55 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54295 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726370AbgHRHOx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:14:53 -0400
X-UUID: 02bfad7e1fad48e3bfbeba36a133b4fe-20200818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=cX1RyWC6RhWrmSa5l9WmiLo7asIr+FhEw7uQh+t/SNY=;
        b=U+yfBntiTCeAsf9E+TNx26TZRCZY/8mJbF0Tb0He5ewi3ViMsiJKrFXGRAQfzIZGuLo0brokjQ03TfxGdTp/TIz7j7GH1ruMQQSked5EIq2i0WGXvzi90FfkRLHlYUXLn40ZhTxrcd4stT+OzZNWEz6Xdd9XZYzkAWSZfZBv61M=;
X-UUID: 02bfad7e1fad48e3bfbeba36a133b4fe-20200818
Received: from mtkcas08.mediatek.inc [(172.21.101.126)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 2014314872; Tue, 18 Aug 2020 15:14:46 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 18 Aug 2020 15:14:43 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 15:14:44 +0800
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
Subject: [PATCH net-next v2 7/7] arm64: dts: mt7622: add mt7531 dsa to bananapi-bpi-r64 board
Date:   Tue, 18 Aug 2020 15:14:12 +0800
Message-ID: <2a986604b49f7bfbee3898c8870bb0cf8182e879.1597729692.git.landen.chao@mediatek.com>
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

