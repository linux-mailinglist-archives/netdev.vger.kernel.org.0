Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59D291181F9
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:15:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfLJIP0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:15:26 -0500
Received: from mailgw01.mediatek.com ([210.61.82.183]:21469 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726062AbfLJIO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:14:56 -0500
X-UUID: f9b456136baf42daba0957485d388010-20191210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=BT+q/z4xoeKXCk+y25bvARvW/z0vRa1uB7kHqAjvpaw=;
        b=eagJVm76XNgnVVvxDHR4QtcIyynPPYY4k7twyvlRAQeSnsJbABh1afLK+LlxnJ0TM069F+hNNzWXq7ZGru/I+gYhmqZcYCt/SkEYgxdTb0VNE+DIW0hmNAOoJ0i23gobJ3xa7JVRfIfeZcbjwRJSuqwzLBRZBLIFzqSs71VZx1Y=;
X-UUID: f9b456136baf42daba0957485d388010-20191210
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1831961689; Tue, 10 Dec 2019 16:14:48 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n2.mediatek.inc (172.21.101.141) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 10 Dec 2019 16:14:32 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Tue, 10 Dec 2019 16:14:27 +0800
From:   Landen Chao <landen.chao@mediatek.com>
To:     <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <vivien.didelot@savoirfairelinux.com>, <matthias.bgg@gmail.com>,
        <robh+dt@kernel.org>, <mark.rutland@arm.com>
CC:     <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <davem@davemloft.net>,
        <sean.wang@mediatek.com>, <opensource@vdorst.com>,
        <frank-w@public-files.de>, Landen Chao <landen.chao@mediatek.com>
Subject: [PATCH net-next 6/6] arm64: dts: mt7622: add mt7531 dsa to bananapi-bpi-r64 board
Date:   Tue, 10 Dec 2019 16:14:42 +0800
Message-ID: <62eef5503c117f48d4b41e94fd28d75e123590b4.1575914275.git.landen.chao@mediatek.com>
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

QWRkIG10NzUzMSBkc2EgdG8gYmFuYW5hcGktYnBpLXI2NCBib2FyZCBmb3IgNSBnaWdhIEV0aGVy
bmV0IHBvcnRzIHN1cHBvcnQuDQoNClNpZ25lZC1vZmYtYnk6IExhbmRlbiBDaGFvIDxsYW5kZW4u
Y2hhb0BtZWRpYXRlay5jb20+DQotLS0NCiAuLi4vZHRzL21lZGlhdGVrL210NzYyMi1iYW5hbmFw
aS1icGktcjY0LmR0cyAgfCA1MCArKysrKysrKysrKysrKysrKysrDQogMSBmaWxlIGNoYW5nZWQs
IDUwIGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVk
aWF0ZWsvbXQ3NjIyLWJhbmFuYXBpLWJwaS1yNjQuZHRzIGIvYXJjaC9hcm02NC9ib290L2R0cy9t
ZWRpYXRlay9tdDc2MjItYmFuYW5hcGktYnBpLXI2NC5kdHMNCmluZGV4IDgzZTEwNTkxZTBlNS4u
ZmZhY2VmZWU4ZTJhIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9t
dDc2MjItYmFuYW5hcGktYnBpLXI2NC5kdHMNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVk
aWF0ZWsvbXQ3NjIyLWJhbmFuYXBpLWJwaS1yNjQuZHRzDQpAQCAtMTQzLDYgKzE0Myw1NiBAQA0K
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
MjUwMGJhc2UteCI7DQorDQorCQkJCQlmaXhlZC1saW5rIHsNCisJCQkJCQlzcGVlZCA9IDwyNTAw
PjsNCisJCQkJCQlmdWxsLWR1cGxleDsNCisJCQkJCQlwYXVzZTsNCisJCQkJCX07DQorCQkJCX07
DQorCQkJfTsNCisJCX07DQorDQogCX07DQogfTsNCiANCi0tIA0KMi4xNy4xDQo=

