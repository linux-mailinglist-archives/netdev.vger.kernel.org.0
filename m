Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5E6247F36
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 09:15:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726836AbgHRHP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 03:15:27 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:54295 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726721AbgHRHOq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 03:14:46 -0400
X-UUID: 65657ec6bc9642d0b4f29de22353c409-20200818
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=gDibrP8XDXH4a6q7xadIT86AI1aSO+lmsd9yRivA8HM=;
        b=uExWSBoea6IG/xwJEDnFfQZR5ptdfx1DkdDw0J5PVRhmGrzEXAv7Kbg9RTI/i1WRABeMxQ/r6mjf3OdzAyU4TLl8s1G8UVpL/VrDwWeSe8NTju95pMVMRmgGUw3i8o0nkNAC/Dm1HgTAA66dk6BG+99UMKELfuz4mXlkvCsqb+o=;
X-UUID: 65657ec6bc9642d0b4f29de22353c409-20200818
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <landen.chao@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1590323193; Tue, 18 Aug 2020 15:14:43 +0800
Received: from mtkcas07.mediatek.inc (172.21.101.84) by
 mtkmbs07n1.mediatek.inc (172.21.101.16) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Tue, 18 Aug 2020 15:14:40 +0800
Received: from mtksdccf07.mediatek.inc (172.21.84.99) by mtkcas07.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 18 Aug 2020 15:14:41 +0800
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
Subject: [PATCH net-next v2 6/7] arm64: dts: mt7622: add mt7531 dsa to mt7622-rfb1 board
Date:   Tue, 18 Aug 2020 15:14:11 +0800
Message-ID: <fb458715fc82b2222674d857d16841da57920990.1597729692.git.landen.chao@mediatek.com>
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

QWRkIG10NzUzMSBkc2EgdG8gbXQ3NjIyLXJmYjEgYm9hcmQgZm9yIDUgZ2lnYSBFdGhlcm5ldCBw
b3J0cyBzdXBwb3J0Lg0KbXQ3NjIyIG9ubHkgc3VwcG9ydHMgMSBzZ21paSBpbnRlcmZhY2UsIHNv
IGVpdGhlciBnbWFjMCBvciBnbWFjMSBjYW4gYmUNCmNvbmZpZ3VyZWQgYXMgc2dtaWkgaW50ZXJm
YWNlLiBJbiB0aGlzIHBhdGNoLCBjaGFuZ2UgdG8gY29ubmV0IG10NzYyMg0KZ21hYzAgYW5kIG10
NzUzMSBwb3J0NiB0aHJvdWdoIHNnbWlpIGludGVyZmFjZS4NCg0KU2lnbmVkLW9mZi1ieTogTGFu
ZGVuIENoYW8gPGxhbmRlbi5jaGFvQG1lZGlhdGVrLmNvbT4NCi0tLQ0KIGFyY2gvYXJtNjQvYm9v
dC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLXJmYjEuZHRzIHwgNTcgKysrKysrKysrKysrKysrKystLS0N
CiAxIGZpbGUgY2hhbmdlZCwgNTEgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCg0KZGlm
ZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0ZWsvbXQ3NjIyLXJmYjEuZHRzIGIv
YXJjaC9hcm02NC9ib290L2R0cy9tZWRpYXRlay9tdDc2MjItcmZiMS5kdHMNCmluZGV4IDBiNGRl
NjI3Zjk2ZS4uM2ZkOTQ4ZmI3ZjdhIDEwMDY0NA0KLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9t
ZWRpYXRlay9tdDc2MjItcmZiMS5kdHMNCisrKyBiL2FyY2gvYXJtNjQvYm9vdC9kdHMvbWVkaWF0
ZWsvbXQ3NjIyLXJmYjEuZHRzDQpAQCAtMTA1LDIwICsxMDUsNjUgQEANCiAJcGluY3RybC0wID0g
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
ICIyNTAwYmFzZS14IjsNCisJCQkJfTsNCisJCQl9Ow0KIAkJfTsNCisNCiAJfTsNCiB9Ow0KIA0K
LS0gDQoyLjE3LjENCg==

