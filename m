Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89B891181EC
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 09:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727225AbfLJIPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 03:15:04 -0500
Received: from mailgw02.mediatek.com ([210.61.82.184]:45567 "EHLO
        mailgw02.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726777AbfLJIPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 03:15:03 -0500
X-UUID: 140df03a2b0a469f90bbe1f29d7db70a-20191210
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=ZHw1FyeA3BLUxG4FfGgyMIigBe1oxHthdz5KxHVSl40=;
        b=qh6EOuOdbkGBZjdq2zNNSy2AYr6DD/qRcMpGfdVU3+kdK3im10fGUzkO1XNTGiWEEjxO/iIRcxYLeFOZz9kmtiw1w3Ect93n/ZTMhKXieB5VfneB1bS3hZ8AVfmqNsFT7bXVmz5ox+N9RzPRoffqg6gdvLcxg2wKS9WWKrj809g=;
X-UUID: 140df03a2b0a469f90bbe1f29d7db70a-20191210
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw02.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 586429920; Tue, 10 Dec 2019 16:14:47 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Tue, 10 Dec 2019 16:14:38 +0800
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
Subject: [PATCH net-next 5/6] arm64: dts: mt7622: add mt7531 dsa to mt7622-rfb1 board
Date:   Tue, 10 Dec 2019 16:14:41 +0800
Message-ID: <7f5a690281664a0fe47cfe7726f26d7f6211d015.1575914275.git.landen.chao@mediatek.com>
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

QWRkIG10NzUzMSBkc2EgdG8gbXQ3NjIyLXJmYjEgYm9hcmQgZm9yIDUgZ2lnYSBFdGhlcm5ldCBw
b3J0cyBzdXBwb3J0Lg0KbXQ3NjIyIG9ubHkgc3VwcG9ydHMgMSBzZ21paSBpbnRlcmZhY2UsIHNv
IGVpdGhlciBnbWFjMCBvciBnbWFjMSBjYW4gYmUNCmNvbmZpZ3VyZWQgYXMgc2dtaWkgaW50ZXJm
YWNlLiBJbiB0aGlzIHBhdGNoLCBjaGFuZ2UgdG8gY29ubmV0IG10NzYyMg0KZ21hYzAgYW5kIG10
NzUzMSBwb3J0NiB0aHJvdWdoIHNnbWlpIGludGVyZmFjZS4NCg0KU2lnbmVkLW9mZi1ieTogTGFu
ZGVuIENoYW8gPGxhbmRlbi5jaGFvQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGFyY2gvYXJtNjQvYm9v
dC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLXJmYjEuZHRzIHwgNjMgKysrKysrKysrKysrKysrKysrLS0N
CiAxIGZpbGUgY2hhbmdlZCwgNTcgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLXJmYjEuZHRzIGIv
YXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDc2MjItcmZiMS5kdHMNCmluZGV4IDNmNzgz
MzQ4YzY2YS4uZTUwOWIwYzJmZTc5IDEwMDY0NA0KLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9t
ZWRpYXRlay9tdDc2MjItcmZiMS5kdHMNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0
ZWsvbXQ3NjIyLXJmYjEuZHRzDQpAQCAtMTA1LDIwICsxMDUsNzEgQEANCiAJcGluY3RybC0wID0g
PCZldGhfcGlucz47DQogCXN0YXR1cyA9ICJva2F5IjsNCiANCi0JZ21hYzE6IG1hY0AxIHsNCisJ
Z21hYzA6IG1hY0AwIHsNCiAJCWNvbXBhdGlibGUgPSAibWVkaWF0ZWssZXRoLW1hYyI7DQotCQly
ZWcgPSA8MT47DQotCQlwaHktaGFuZGxlID0gPCZwaHk1PjsNCisJCXJlZyA9IDwwPjsNCisJCXBo
eS1tb2RlID0gIjI1MDBiYXNlLXgiOw0KKw0KKwkJZml4ZWQtbGluayB7DQorCQkJc3BlZWQgPSA8
MjUwMD47DQorCQkJZnVsbC1kdXBsZXg7DQorCQkJcGF1c2U7DQorCQl9Ow0KIAl9Ow0KIA0KIAlt
ZGlvLWJ1cyB7DQogCQkjYWRkcmVzcy1jZWxscyA9IDwxPjsNCiAJCSNzaXplLWNlbGxzID0gPDA+
Ow0KIA0KLQkJcGh5NTogZXRoZXJuZXQtcGh5QDUgew0KLQkJCXJlZyA9IDw1PjsNCi0JCQlwaHkt
bW9kZSA9ICJzZ21paSI7DQorCQlzd2l0Y2hAMCB7DQorCQkJY29tcGF0aWJsZSA9ICJtZWRpYXRl
ayxtdDc1MzEiOw0KKwkJCXJlZyA9IDwwPjsNCisJCQlyZXNldC1ncGlvcyA9IDwmcGlvIDU0IDA+
Ow0KKw0KKwkJCXBvcnRzIHsNCisJCQkJI2FkZHJlc3MtY2VsbHMgPSA8MT47DQorCQkJCSNzaXpl
LWNlbGxzID0gPDA+Ow0KKw0KKwkJCQlwb3J0QDAgew0KKwkJCQkJcmVnID0gPDA+Ow0KKwkJCQkJ
bGFiZWwgPSAibGFuMCI7DQorCQkJCX07DQorDQorCQkJCXBvcnRAMSB7DQorCQkJCQlyZWcgPSA8
MT47DQorCQkJCQlsYWJlbCA9ICJsYW4xIjsNCisJCQkJfTsNCisNCisJCQkJcG9ydEAyIHsNCisJ
CQkJCXJlZyA9IDwyPjsNCisJCQkJCWxhYmVsID0gImxhbjIiOw0KKwkJCQl9Ow0KKw0KKwkJCQlw
b3J0QDMgew0KKwkJCQkJcmVnID0gPDM+Ow0KKwkJCQkJbGFiZWwgPSAibGFuMyI7DQorCQkJCX07
DQorDQorCQkJCXBvcnRANCB7DQorCQkJCQlyZWcgPSA8ND47DQorCQkJCQlsYWJlbCA9ICJ3YW4i
Ow0KKwkJCQl9Ow0KKw0KKwkJCQlwb3J0QDYgew0KKwkJCQkJcmVnID0gPDY+Ow0KKwkJCQkJbGFi
ZWwgPSAiY3B1IjsNCisJCQkJCWV0aGVybmV0ID0gPCZnbWFjMD47DQorCQkJCQlwaHktbW9kZSA9
ICIyNTAwYmFzZS14IjsNCisNCisJCQkJCWZpeGVkLWxpbmsgew0KKwkJCQkJCXNwZWVkID0gPDI1
MDA+Ow0KKwkJCQkJCWZ1bGwtZHVwbGV4Ow0KKwkJCQkJCXBhdXNlOw0KKwkJCQkJfTsNCisJCQkJ
fTsNCisJCQl9Ow0KIAkJfTsNCisNCiAJfTsNCiB9Ow0KIA0KLS0gDQoyLjE3LjENCg==

