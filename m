Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63C12289F89
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 11:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbgJJJ1Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 05:27:25 -0400
Received: from Mailgw01.mediatek.com ([1.203.163.78]:28298 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726817AbgJJIyH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 04:54:07 -0400
X-UUID: 1ee4d5bc92554d7e958543434527e1b6-20201010
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=Content-Transfer-Encoding:Content-Type:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=pCXxuHl4NEKBv1fodutwA2PDZlk+wI3nQWXYl98dgik=;
        b=GHkgiflbxjIw2ZVAIl3o1SJbk0qbW3kUWqzFZk7Lzib3v2moF5gggI9B01q818rZNZH+eQwY5ibyk8D0iTA4urRchg5GbWHrX/6CzuqXMn4gFN87g36zStZ1Sk9Y8cgYtPxuu0FYmQjSfKIi+81r4hrkSJUL26Qf9ywOhQpIY/c=;
X-UUID: 1ee4d5bc92554d7e958543434527e1b6-20201010
Received: from mtkcas36.mediatek.inc [(172.27.4.253)] by mailgw01.mediatek.com
        (envelope-from <chunfeng.yun@mediatek.com>)
        (mailgw01.mediatek.com ESMTP with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 989034769; Sat, 10 Oct 2020 16:43:16 +0800
Received: from mtkcas08.mediatek.inc (172.21.101.126) by
 MTKMBS31DR.mediatek.inc (172.27.6.102) with Microsoft SMTP Server (TLS) id
 15.0.1497.2; Sat, 10 Oct 2020 16:43:15 +0800
Received: from mtkslt301.mediatek.inc (10.21.14.114) by mtkcas08.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sat, 10 Oct 2020 16:43:15 +0800
From:   Chunfeng Yun <chunfeng.yun@mediatek.com>
To:     Rob Herring <robh+dt@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-mediatek@lists.infradead.org>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>
Subject: [PATCH v2 2/4] dt-bindings: usb: add properties for hard wired devices
Date:   Sat, 10 Oct 2020 16:43:12 +0800
Message-ID: <bd71ed260efd162d25e0491988d61fcf1e589bc0.1602318869.git.chunfeng.yun@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
References: <3db52d534065dcf28e9a10b8129bea3eced0193e.1602318869.git.chunfeng.yun@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-SNTS-SMTP: 7F3660C5722A662249B3EB9CBC0716B5572E1DF5C225A3804D2A9E804D218B102000:8
X-MTK:  N
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QWRkIHNvbWUgb3B0aW9uYWwgcHJvcGVydGllcyB3aGljaCBhcmUgbmVlZGVkIGZvciBoYXJkIHdp
cmVkIGRldmljZXMNCg0KU2lnbmVkLW9mZi1ieTogQ2h1bmZlbmcgWXVuIDxjaHVuZmVuZy55dW5A
bWVkaWF0ZWsuY29tPg0KLS0tDQp2MiBjaGFuZ2VzIHN1Z2dlc3RlZCBieSBSb2I6DQogICAxLiBt
b2RpZnkgcGF0dGVybiB0byBzdXBwb3J0IGFueSBVU0IgY2xhc3MNCiAgIDIuIHJlZmVyIHRvIHVz
Yi1kZXZpY2UueWFtbCBpbnN0ZWFkIG9mIHVzYi1kZXZpY2UudHh0DQotLS0NCiAuLi4vZGV2aWNl
dHJlZS9iaW5kaW5ncy91c2IvdXNiLWhjZC55YW1sICAgICAgfCAxOSArKysrKysrKysrKysrKysr
KysrDQogMSBmaWxlIGNoYW5nZWQsIDE5IGluc2VydGlvbnMoKykNCg0KZGlmZiAtLWdpdCBhL0Rv
Y3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy91c2IvdXNiLWhjZC55YW1sIGIvRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL3VzYi91c2ItaGNkLnlhbWwNCmluZGV4IDcyNjNi
N2YyYjUxMC4uNDJiMjk1YWZkZjMyIDEwMDY0NA0KLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL3VzYi91c2ItaGNkLnlhbWwNCisrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy91c2IvdXNiLWhjZC55YW1sDQpAQCAtMjIsOSArMjIsMjggQEAgcHJvcGVy
dGllczoNCiAgICAgZGVzY3JpcHRpb246DQogICAgICAgTmFtZSBzcGVjaWZpZXIgZm9yIHRoZSBV
U0IgUEhZDQogDQorICAiI2FkZHJlc3MtY2VsbHMiOg0KKyAgICBjb25zdDogMQ0KKw0KKyAgIiNz
aXplLWNlbGxzIjoNCisgICAgY29uc3Q6IDANCisNCitwYXR0ZXJuUHJvcGVydGllczoNCisgICJe
W2EtZl0rQFswLTlhLWZdKyQiOg0KKyAgICB0eXBlOiBvYmplY3QNCisgICAgJHJlZjogL3VzYi91
c2ItZGV2aWNlLnlhbWwNCisgICAgZGVzY3JpcHRpb246IFRoZSBoYXJkIHdpcmVkIFVTQiBkZXZp
Y2VzDQorDQogZXhhbXBsZXM6DQogICAtIHwNCiAgICAgdXNiIHsNCiAgICAgICAgIHBoeXMgPSA8
JnVzYjJfcGh5MT4sIDwmdXNiM19waHkxPjsNCiAgICAgICAgIHBoeS1uYW1lcyA9ICJ1c2IiOw0K
KyAgICAgICAgI2FkZHJlc3MtY2VsbHMgPSA8MT47DQorICAgICAgICAjc2l6ZS1jZWxscyA9IDww
PjsNCisNCisgICAgICAgIGh1YkAxIHsNCisgICAgICAgICAgICBjb21wYXRpYmxlID0gInVzYjVl
Myw2MTAiOw0KKyAgICAgICAgICAgIHJlZyA9IDwxPjsNCisgICAgICAgIH07DQogICAgIH07DQot
LSANCjIuMTguMA0K

