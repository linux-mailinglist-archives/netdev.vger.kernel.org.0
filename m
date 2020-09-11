Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E658526668F
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbgIKR2z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:28:55 -0400
Received: from mailgw02.mediatek.com ([210.61.82.184]:57562 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726097AbgIKM6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 08:58:02 -0400
X-UUID: e3ab626e00f94af18a740517597bee37-20200911
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=DAk4ZLiJ85a7SZSqLzCU+r3oKFMIHRDhPdBXOk4LJMo=;
        b=esJhQGSevDOTBwhsKte6EkDtpF3yaaOgEnB7XxPhsrMafbpb10YkB9QPJyyDV1rYEdaYffS41odjPX+tVO5ayS9wPKwMD18Vpv04NNaQQe4wTGPTHyp0TfEiY6jXaGRm77e2aqy39KBUkZcSm0K55aQnMnm2M125v7CnmLpaylc=;
X-UUID: e3ab626e00f94af18a740517597bee37-20200911
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.14 Build 0819 with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 832199150; Fri, 11 Sep 2020 20:57:45 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Fri, 11 Sep 2020 20:57:41 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Fri, 11 Sep 2020 20:57:41 +0800
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
Subject: [PATCH net-next v4 3/6] dt-bindings: net: dsa: add new MT7531 binding to support MT7531
Date:   Fri, 11 Sep 2020 20:56:25 +0800
Message-ID: <3890c6b32e984e75be2e5fbfdfbd8da8cc30beaf.1599825966.git.landen.chao@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <cover.1599825966.git.landen.chao@mediatek.com>
References: <cover.1599825966.git.landen.chao@mediatek.com>
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
dHJlZS9iaW5kaW5ncy9uZXQvZHNhL210NzUzMC50eHQgICAgICAgICAgfCAxMyArKysrKysrKyst
LS0tDQogMSBmaWxlIGNoYW5nZWQsIDkgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCg0K
ZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL210
NzUzMC50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L2RzYS9tdDc1
MzAudHh0DQppbmRleCBjNWVkNWQyNWY2NDIuLjU2MDM2OWVmYWQ2YyAxMDA2NDQNCi0tLSBhL0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL210NzUzMC50eHQNCisrKyBi
L0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZHNhL210NzUzMC50eHQNCkBA
IC01LDYgKzUsNyBAQCBSZXF1aXJlZCBwcm9wZXJ0aWVzOg0KIA0KIC0gY29tcGF0aWJsZTogbWF5
IGJlIGNvbXBhdGlibGUgPSAibWVkaWF0ZWssbXQ3NTMwIg0KIAlvciBjb21wYXRpYmxlID0gIm1l
ZGlhdGVrLG10NzYyMSINCisJb3IgY29tcGF0aWJsZSA9ICJtZWRpYXRlayxtdDc1MzEiDQogLSAj
YWRkcmVzcy1jZWxsczogTXVzdCBiZSAxLg0KIC0gI3NpemUtY2VsbHM6IE11c3QgYmUgMC4NCiAt
IG1lZGlhdGVrLG1jbTogQm9vbGVhbjsgaWYgZGVmaW5lZCwgaW5kaWNhdGVzIHRoYXQgZWl0aGVy
IE1UNzUzMCBpcyB0aGUgcGFydA0KQEAgLTMyLDEwICszMywxNCBAQCBSZXF1aXJlZCBwcm9wZXJ0
aWVzIGZvciB0aGUgY2hpbGQgbm9kZXMgd2l0aGluIHBvcnRzIGNvbnRhaW5lcjoNCiANCiAtIHJl
ZzogUG9ydCBhZGRyZXNzIGRlc2NyaWJlZCBtdXN0IGJlIDYgZm9yIENQVSBwb3J0IGFuZCBmcm9t
IDAgdG8gNSBmb3INCiAJdXNlciBwb3J0cy4NCi0tIHBoeS1tb2RlOiBTdHJpbmcsIG11c3QgYmUg
ZWl0aGVyICJ0cmdtaWkiIG9yICJyZ21paSIgZm9yIHBvcnQgbGFiZWxlZA0KLQkgImNwdSIuDQot
DQotUG9ydCA1IG9mIHRoZSBzd2l0Y2ggaXMgbXV4ZWQgYmV0d2VlbjoNCistIHBoeS1tb2RlOiBT
dHJpbmcsIHRoZSBmb2xsb3dpbmcgdmFsdWVzIGFyZSBhY2NlcHRhYmxlIGZvciBwb3J0IGxhYmVs
ZWQNCisJImNwdSI6DQorCUlmIGNvbXBhdGlibGUgbWVkaWF0ZWssbXQ3NTMwIG9yIG1lZGlhdGVr
LG10NzYyMSBpcyBzZXQsDQorCW11c3QgYmUgZWl0aGVyICJ0cmdtaWkiIG9yICJyZ21paSINCisJ
SWYgY29tcGF0aWJsZSBtZWRpYXRlayxtdDc1MzEgaXMgc2V0LA0KKwltdXN0IGJlIGVpdGhlciAi
c2dtaWkiLCAiMTAwMGJhc2UteCIgb3IgIjI1MDBiYXNlLXgiDQorDQorUG9ydCA1IG9mIG10NzUz
MCBhbmQgbXQ3NjIxIHN3aXRjaCBpcyBtdXhlZCBiZXR3ZWVuOg0KIDEuIEdNQUM1OiBHTUFDNSBj
YW4gaW50ZXJmYWNlIHdpdGggYW5vdGhlciBleHRlcm5hbCBNQUMgb3IgUEhZLg0KIDIuIFBIWSBv
ZiBwb3J0IDAgb3IgcG9ydCA0OiBQSFkgaW50ZXJmYWNlcyB3aXRoIGFuIGV4dGVybmFsIE1BQyBs
aWtlIDJuZCBHTUFDDQogICAgb2YgdGhlIFNPQy4gVXNlZCBpbiBtYW55IHNldHVwcyB3aGVyZSBw
b3J0IDAvNCBiZWNvbWVzIHRoZSBXQU4gcG9ydC4NCi0tIA0KMi4xNy4xDQo=

